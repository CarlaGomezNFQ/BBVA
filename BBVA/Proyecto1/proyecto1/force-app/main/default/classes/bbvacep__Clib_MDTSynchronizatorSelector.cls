public inherited sharing class Clib_MDTSynchronizatorSelector extends fflib_SObjectSelector implements Clib_IMDTSynchronizatorSelector { //NOSONAR

	public static Clib_MDTSynchronizatorSelector newInstance() {
		return (Clib_MDTSynchronizatorSelector) Clib_Application.SELECTOR.newInstance(clib_Synchronizator__mdt.SObjectType);
	}

        /**
         * Default constructor. Reads the fields from the getSObjectFieldList() method
         **/
	public Clib_MDTSynchronizatorSelector() {
		super(false);
	}

        /**
         * Returns a default list of fields if FieldSets functionality is not used (No Dependency Injection Pattern here!)
         **/
	public override List<Schema.SObjectField> getSObjectFieldList() {
		return new List<Schema.SObjectField> {
			       clib_Synchronizator__mdt.Id,
			       clib_Synchronizator__mdt.DeveloperName,
			       clib_Synchronizator__mdt.clib_Source_Object__c,
			       clib_Synchronizator__mdt.clib_Destination_Object__c,
						 clib_Synchronizator__mdt.clib_Destination_Key_Field__c,
						 clib_Synchronizator__mdt.clib_Active__c
		};
	}

	public override Schema.SObjectType getSObjectType() {
		return clib_Synchronizator__mdt.sObjectType;
	}

	public List<clib_Synchronizator__mdt> selectByDeveloperName(Set<String> stringSet) {
		fflib_QueryFactory synchronizator = newQueryFactory();
		return (List<clib_Synchronizator__mdt>) Database.query (
			synchronizator.setCondition('DeveloperName in :stringSet').toSOQL());
	}

	public List<clib_Synchronizator__mdt> selectBySourceObjectName(Set<String> stringSet) {
		fflib_QueryFactory synchronizator = newQueryFactory();
		return (List<clib_Synchronizator__mdt>) Database.query (
			synchronizator.setCondition('clib_Source_Object__c in :stringSet').toSOQL());
	}

	public List<clib_Synchronizator__mdt> selectBySourceObjectNameWithMappings(Set<String> stringSet) {
		fflib_QueryFactory synchronizator = newQueryFactory();
		fflib_QueryFactory mappings = new Clib_MDTMappingFieldsSelector().addQueryFactorySubselect(synchronizator);
		return (List<clib_Synchronizator__mdt>) Database.query (
			synchronizator.setCondition('clib_Source_Object__c in :stringSet').toSOQL());
	}
}