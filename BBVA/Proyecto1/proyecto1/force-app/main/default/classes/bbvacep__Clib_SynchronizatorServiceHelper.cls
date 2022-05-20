public inherited sharing class Clib_SynchronizatorServiceHelper { //NOSONAR
	private class MappingField {
		String fieldName {get; set;}
		String parentExternalName {get; set;}
	}
        //stores the list of fields source/origin for a given Sobject. Read from metadata
	Map <String, MappingField> fieldMappings = new Map<String, MappingField>();
        //stores a map of records by Id with pair values of fields with their values to update
	Map <String, Map<String, String> > fieldsPerRecord = new Map <String, Map<String, String> >();
        //stores a mapping of all reference files in the target object with their corresponding sObject
	Map <String, String> referencesFields = new Map<String, String>();
        //sObjectName of the records to synchronize from/in
	String srcSObjectName;
	String dstSObjectName;
	String dstSObjectKeyField;
	Boolean dstActive;
        //List of destination sObject Ids synchronized
	Map<Id,String> results = new Map<Id,String>();

        /**
         * Main function that coordinates the sincronization process
         * Returns a Map of destination object Ids and the operation performed CREATE | UPDATE | DELETE
         **/
	public Map<Id,String> synchronize(List<SObject> records) {
		for (SObject eventRecord : records) {
			EventBus.ChangeEventHeader header = (EventBus.ChangeEventHeader)eventRecord.get('ChangeEventHeader');
			if (fieldMappings.isEmpty()) {
				fieldMappings = getFieldMapping(header.entityname);
				validate();
				referencesFields = getReferenceFields(dstSObjectName);
			}
			if (Test.isRunningTest() || dstActive) {
				switch on header.changetype {
					when 'UPDATE' { results.putAll(manageUpdateRecords(eventRecord, header)); }
					when 'CREATE' { results.putAll(manageCreateRecords(eventRecord, header)); }
					when 'DELETE' { results.putAll(manageDeleteRecords(eventRecord, header)); }
				}
				fieldsPerRecord = new Map <String, Map<String, String> >();
			} else {
				system.debug('No active mapping found to synchronize ' + srcSObjectName + ' into ' + dstSObjectName);
			}
		}
		return results;
	}

        /**
         * an Event can contain multiple records creation, this function manages all those
         * operations at once
         **/
	private Map<Id,String> manageCreateRecords (SObject srcRecord, EventBus.ChangeEventHeader eventHeader) {
		return manageCreateRecords(srcRecord, eventHeader.getRecordIds(), eventHeader.changetype);
	}

        /**
         * manageCreateRecords Manages the creation of a set of records
         * @param  srcRecord   Record to be created
         * @param  recordIds   Ids of the records to be created
         * @param  sourceEvent A record can be created from a CREATE or UPDATE event if coming from an UPDATE
         *                                                                               data needs to be retrieved from Database as it is not in the event info
         * @return             A List of recordIds created
         */
	private Map<Id,String> manageCreateRecords (SObject srcRecord, List<String> recordIds, String sourceEvent) {
		Map<Id,String> createResults = new Map<Id,String>();
		List<SObject> recordsToCreate = new List<SObject>();
		SObject recordToCreate;

		switch on sourceEvent {
			when 'UPDATE' {
				List<SObject> srcTmpRecords = getSourceRecords(recordIds);
				for (SObject srcTmpRecord : srcTmpRecords) {
					recordToCreate = createRecord(srcTmpRecord, String.valueOf(srcTmpRecord.get('Id')));
					recordsToCreate.add (recordToCreate);
					createResults.put((id)recordToCreate.get('Id'), sourceEvent);
				}
			}
			when 'CREATE' {
				for (String recordId : recordIds) {
					recordToCreate = createRecord(srcRecord, recordId);
					recordsToCreate.add (recordToCreate);
					createResults.put((id)recordToCreate.get('Id'), sourceEvent);
				}
			}
		}

		try {
			insert recordsToCreate;
		} catch (DmlException e) {
			System.debug(e.getMessage());
		}
		return createResults;
	}

        /**
         * an Event can contain multiple records deletion, this function manages all those
         * operations at once
         **/
	private Map<Id,String> manageDeleteRecords (SObject srcRecord, EventBus.ChangeEventHeader eventHeader) {
		Map<Id,String> deleteResults = new Map<Id,String>();
		List<String> idsToDelete = eventHeader.getRecordIds();

		List<SObject> recordsToDelete = selectRecordsToDelete(new Set<String>(idsToDelete), dstSObjectKeyField);
		for (SObject recordToDelete : recordsToDelete) {
			deleteResults.put((id)recordToDelete.get('Id'), 'DELETE');
		}
		try {
			delete recordsToDelete;
		} catch (DmlException e) {
			System.debug(e.getMessage());
		}
		return deleteResults;
	}

        /**
         * an Event can contain multiple records updates, this function manages all those
         * operations at once. if a record doesn't exist, it will be add to a list to be created
         **/
	private Map<Id,String> manageUpdateRecords (SObject srcRecord, EventBus.ChangeEventHeader eventHeader) {
		Map<Id,String> updateResults = new Map<Id,String>();
		List<SObject> recordsToUpdate = new List<SObject>();
		List<String> recordsToCreate = new List<String>();

		SObject recordToUpdate;

		for (String recordId : eventHeader.getRecordIds()) {
			recordToUpdate = updateRecord(srcRecord, recordId, eventHeader.changedFields);
			if (recordToUpdate != null) {
				system.debug('Added record to update: ' + recordToUpdate);
				recordsToUpdate.add (recordToUpdate);
				updateResults.put((id)recordToUpdate.get('Id'), 'UPDATE');
			} else {
				system.debug('Adding record to create: ' + recordId);
				recordsToCreate.add(recordId);
				updateResults.put((id)recordId, 'CREATE');
			}
		}
		try {
			if (recordsToUpdate.size() > 0) {
				system.debug('updating ' + recordsToUpdate.size() + ' records');
				update recordsToUpdate;
			}
			if (recordsToCreate.size() > 0) {
				system.debug('creating ' + recordsToCreate.size() + ' records');
				manageCreateRecords(srcRecord, recordsToCreate, eventHeader.changetype);
			}
		} catch (DmlException e) {
			System.debug(e.getMessage());
		}
		return updateResults;
	}

        /**
         * getSourceRecord  returns the SObject of the source Object with the mapping fields populated
         *                                                                      This is required when the creation of the record comes from an UPDATE operation as
         *                                                                      the UPDATE event only has the updated fields and not all
         * @param  recordId recordId Id of the source object to retrieve
         * @return          return the SObject with the mapping fields populated
         */
	private List<SObject> getSourceRecords (List<String> recordIds) {
		set<schema.SObjectField> selectFields = new set<schema.SObjectField>();
		schema.SObjectType myObject = schema.getGlobalDescribe().get(srcSObjectName);

		for (String field : fieldMappings.keySet()) {
			selectFields.add(schema.getGlobalDescribe().get(srcSObjectName).getDescribe().fields.getMap().get(field));
		}

		List<SObject> sObjList = new Clib_SynchronizatorSelector().selectById(myObject, selectFields, new set<String>(recordIds));
		return sObjList;
	}

        /**
         * createRecord                  Process a record creation from the changeevent trigger
         * @param  srcRecord Record to create
         * @param  recordId  recordId in the Source Object to be replicated. Used to track updates
         * @return           The record created in the destination object so it can be commited
         */
	private SObject createRecord (SObject srcRecord, String recordId) {
		sObject dstRecord = Schema.getGlobalDescribe().get(dstSObjectName).newSObject();
		String parentObjectName;

		for (String fieldName : fieldMappings.keySet()) {
			System.debug('CREATE - reading source fieldName: ' + fieldName + ' to update destination field: ' + fieldMappings.get(fieldName).fieldName + ' with value: ' + srcRecord.get(fieldName));
			parentObjectName = referencesFields.get(fieldMappings.get(fieldName).fieldName);
			if (parentObjectName != null) {
                                //it is a lookup/master-detail field
				dstRecord.put(fieldMappings.get(fieldName).fieldName, getDstParentId(parentObjectName,String.valueOf(srcRecord.get(fieldName)), fieldMappings.get(fieldName).parentExternalName));
			} else {
                                //it is a non-reference field
				dstRecord.put(fieldMappings.get(fieldName).fieldName, srcRecord.get(fieldName));
			}
		}
		dstRecord.put(dstSObjectKeyField, recordId);
		return dstRecord;
	}

        /**
         * Process a record update from the changeevent trigger
         * Returns the record updated in the destination object so it can be commited
         **/
	private SObject updateRecord (SObject srcRecord, String recordId, List<String> changedFields)  {
                //stores each pair value of fields updated for this particular record
		Map <String, String> eventFields = new Map <String, String>();
                //Set to store all fields that have been updated across all records
		Set <String> fieldsToSelect = new Set<String>();
		List<SObject> recordsToUpdate;
		SObject recordToUpdate;
		MappingField destinationFieldMapping;

		for (String field : changedfields) {
			System.debug('Process Field: ' + field + ' with value: ' + srcRecord.get(field));
                        //mapping of source/destination fields to store the value to the appropriate field on destination
			destinationFieldMapping = fieldMappings.get(field);
			if (destinationFieldMapping != null) {
				String parentObjectName = referencesFields.get(fieldMappings.get(field).fieldName);
				if (parentObjectName != null) {
                                        //it is a lookup/master-detail field
					eventFields.put(destinationFieldMapping.fieldName, getDstParentId(parentObjectName,String.valueOf(srcRecord.get(field)), fieldMappings.get(field).parentExternalName));
				} else {
                                        //it is a non-reference field
					eventFields.put(destinationFieldMapping.fieldName, String.valueOf(srcRecord.get(field)));
				}
				fieldsToSelect.add(destinationFieldMapping.fieldName);
			}
		}
                //add the record and all its destination fields with appropriate values
		fieldsPerRecord.put(recordId, eventFields);

                //return the destination records to update
		recordsToUpdate = selectRecordsToUpdate(fieldsToSelect, fieldsPerRecord.keySet());

                //for each record retrieved retrieve the fields and update it with the corresponding value in the Map calculated before
		if (recordsToUpdate.size() > 0) {
			for (SObject newRecordToUpdate : recordsToUpdate) {
				System.debug('recordToUpdate: ' + newRecordToUpdate);
				Map <String, String> objectFields = fieldsPerRecord.get((String)newRecordToUpdate.get(dstSObjectKeyField));
				for (String fieldName : objectFields.keySet()) {
					newRecordToUpdate.put(fieldName, objectFields.get(fieldName));
				}
				recordToUpdate = newRecordToUpdate;
			}
		}
		return recordToUpdate;
	}

        /**
         * selectRecordsToUpdate                                 Queries for the list of records to update
         * @param  selectClauseFieldsSet List of fields to add in the SELECT clause
         * @param  whereClauseIds        list of Ids to look for in the WHERE clause
         * @return                       returns a list of records
         */
	private List<SObject> selectRecordsToUpdate(Set<String> selectClauseFieldsSet, Set<String> whereClauseIds){
		set<schema.SObjectField> selectFields = new set<schema.SObjectField>();
		schema.SObjectField externalKeyField = schema.getGlobalDescribe().get(dstSObjectName).getDescribe().fields.getMap().get(dstSObjectKeyField);
		schema.SObjectType myObject = schema.getGlobalDescribe().get(dstSObjectName);

		selectFields.add(schema.getGlobalDescribe().get(dstSObjectName).getDescribe().fields.getMap().get(dstSObjectKeyField));

		for (String field : selectClauseFieldsSet) {
			selectFields.add(schema.getGlobalDescribe().get(dstSObjectName).getDescribe().fields.getMap().get(field));
		}


		List<SObject> sObjList = new Clib_SynchronizatorSelector().selectByExternalName(myObject, selectFields, whereClauseIds, externalKeyField);
		return sObjList;
	}

        /**
         * selectRecordsToDelete         Queries for the list of records to delete
         * @param  selectClauseFieldsSet List of fields to add in the SELECT clause
         * @param  whereClauseIds        list of Ids to look for in the WHERE clause
         * @return                       returns a list of records
         */
	private List<SObject> selectRecordsToDelete(Set<String> whereClauseIds, String dstSObjectKeyField){
		set<schema.SObjectField> selectFields = new set<schema.SObjectField>();
		schema.SObjectField externalKeyField = schema.getGlobalDescribe().get(dstSObjectName).getDescribe().fields.getMap().get(dstSObjectKeyField);
		schema.SObjectType myObject = schema.getGlobalDescribe().get(dstSObjectName);

		selectFields.add(schema.getGlobalDescribe().get(dstSObjectName).getDescribe().fields.getMap().get(dstSObjectKeyField));

		List<SObject> sObjList = new Clib_SynchronizatorSelector().selectByExternalName(myObject, selectFields, whereClauseIds, externalKeyField);
		return sObjList;
	}

        /**
         * Loads the field mapping from the custom metadata into the class fieldMappings variable
         **/
	private Map<String,MappingField> getFieldMapping(String sObjectName) {
		List<clib_Synchronizator__mdt> myMdtMappings = new Clib_MDTSynchronizatorSelector().selectBySourceObjectNameWithMappings(new Set<String> {sObjectName});
		Map<String,MappingField> results = new Map<String,MappingField>();

		for (clib_Synchronizator__mdt myMdtMapping : myMdtMappings) {
			srcSObjectName = myMdtMapping.clib_Source_Object__c;
			dstSObjectName = myMdtMapping.clib_Destination_Object__c;
			dstSObjectKeyField = myMdtMapping.clib_Destination_Key_Field__c;
			dstActive = myMdtMapping.clib_Active__c;
			System.debug('Synchronize from : ' + srcSObjectName + ' to: ' + dstSObjectName);

			for (clib_Mapping_Fields__mdt myMdtMappingField : myMdtMapping.Mapping_Fields__r) {
				MappingField myMappingField = new MappingField();
				System.debug('Recovering mapping with source field: ' + myMdtMappingField.clib_Source_Field__c +
					     ' and destination field: ' + myMdtMappingField.clib_Destination_Field__c +
					     ' with parentExternalName: ' + myMdtMappingField.clib_Parent_External_Name__c);
				myMappingField.fieldName = myMdtMappingField.clib_Destination_Field__c;
				myMappingField.parentExternalName = myMdtMappingField.clib_Parent_External_Name__c;

				results.put(myMdtMappingField.clib_Source_Field__c, myMappingField);
			}
		}
		return results;
	}

        /**
         * it Validates that the object names and the fields in the mappings exists in the schema
         * If anything fails, the appropriate custom exception is thrown
         * Calls a submethod to validate mappings to avoid cyclomatic complexity problem
         **/
	private void validate() {
		Map<String, Schema.SObjectType> mapSObjects = Schema.getGlobalDescribe();
		Schema.SObjectType srcObject = mapSObjects.get(srcSObjectName);
		Schema.SObjectType dstObject = mapSObjects.get(dstSObjectName);

		if (srcObject == null) {
			throw new Clib_CustomMetadataException('Invalid Source SObject: ' + srcSObjectName);
		}
		if (dstObject == null) {
			throw new Clib_CustomMetadataException('Invalid Destination SObject: ' + dstSObjectName);
		}

		if (dstObject.getDescribe().fields.getMap().get(dstSObjectKeyField) == null) {
			throw new Clib_CustomMetadataException('Invalid Key Field Name: ' + dstSObjectKeyField + ' in Destination SObject: ' + dstSObjectName);
		}

		validateMappings(srcObject, dstObject);
	}

        /**
         * validateMappings function to validate all the sObject and field names specified in a mappin
         * @param  srcObject srcObject source sObject to read mappings from
         * @param  dstObject dstObject destination sObject to read mappings from
         */
	private void validateMappings (Schema.SObjectType srcObject, Schema.SObjectType dstObject) {
		for (String fieldName : fieldMappings.keySet()) {
			if (srcObject.getDescribe().fields.getMap().get(fieldName) == null) {
				throw new Clib_CustomMetadataException('Invalid Field Name: ' + fieldName + ' in Source SObject: ' + srcSObjectName);
			}
			if (dstObject.getDescribe().fields.getMap().get(fieldMappings.get(fieldName).fieldName) == null) {
				throw new Clib_CustomMetadataException('Invalid Field Name: ' + fieldMappings.get(fieldName).fieldName + ' in Destination SObject: ' + dstSObjectName);
			}
		}
	}

        /**
         * getReferenceFields  function to get a list of field references and their destination sObjects
         * @param  sObjectName Name of the sObject to look for reference fields
         * @return             Returns a map of field names and destination object names for an SObject Name
         **/
	private Map<String,String> getReferenceFields (String sObjectName) {
		map<string, Map<String, Schema.SObjectField> > objectFieldsMap = new map<string, Map<String, Schema.SObjectField> >();
		map<String, Schema.SObjectField> objectFields = Schema.getGlobalDescribe().get(sObjectName).getDescribe().fields.getMap();
		map <String, String> results = new map <String, String>();

		for(Schema.SObjectField fld :objectFields.values()) {
			schema.describeFieldResult dfield = fld.getDescribe();
			string fldType = string.valueOf(dfield.getType());

			if (fldType == 'REFERENCE') { // Lookup field!
				for (Schema.SObjectType reference : dfield.getReferenceTo()) {
					results.put(string.valueOf(dfield.Name), reference.getDescribe().getName());
				}
			}
		}
		system.debug('References Fields found: ' + results);
		return (results);
	}

        /**
         * getDstParentId      function to look for a record Id that contains the Id in an external field
         * @param  sObjectName sObjectName name of the sObject to do the search
         * @param  sourceId    sourceId Id to look in an external field
         * @return             return an Id to populate
         */
	private String getDstParentId (String sObjectName, String sourceId, String parentExternalName) {
		String result;
		set<schema.SObjectField> selectFields = new set<schema.SObjectField>();
		schema.SObjectField parentField = schema.getGlobalDescribe().get(sObjectName).getDescribe().fields.getMap().get(parentExternalName);
		schema.SObjectType myObject = schema.getGlobalDescribe().get(sObjectName);

		List<SObject> sObjList = new Clib_SynchronizatorSelector().selectByExternalName(myObject, selectFields, new Set<String> { sourceId }, parentField);
		if (!sObjList.isEmpty()) {
			system.debug('ParentId: ' + sObjList[0].get('Id'));
			result = String.valueof(sObjList[0].get('Id'));
		}
		return result;
	}
}