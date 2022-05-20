public inherited sharing class Clib_MDTMappingFieldsSelector extends fflib_SObjectSelector implements Clib_IMDTMappingFieldsSelector { //NOSONAR

	public static Clib_MDTMappingFieldsSelector newInstance() {
		return (Clib_MDTMappingFieldsSelector) Clib_Application.SELECTOR.newInstance(clib_Mapping_Fields__mdt.SObjectType);
	}

        /**
         * Default constructor. Reads the fields from the getSObjectFieldList() method
         **/
	public Clib_MDTMappingFieldsSelector() {
		super(false);
	}

        /**
         * Returns a default list of fields if FieldSets functionality is not used (No Dependency Injection Pattern here!)
         **/
	public override List<Schema.SObjectField> getSObjectFieldList() {
		return new List<Schema.SObjectField> {
			       clib_Mapping_Fields__mdt.Id,
			       clib_Mapping_Fields__mdt.DeveloperName,
			       clib_Mapping_Fields__mdt.clib_Source_Field__c,
			       clib_Mapping_Fields__mdt.clib_Destination_Field__c,
						 clib_Mapping_Fields__mdt.clib_Parent_External_Name__c
		};
	}

	public override Schema.SObjectType getSObjectType() {
		return clib_Mapping_Fields__mdt.sObjectType;
	}

	public List<clib_Mapping_Fields__mdt> selectByDeveloperName(Set<String> stringSet) {
		fflib_QueryFactory mappingFields = newQueryFactory();
		return (List<clib_Mapping_Fields__mdt>) Database.query (
			mappingFields.setCondition('DeveloperName in :stringSet').toSOQL());
	}
}