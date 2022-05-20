public with sharing class Clib_MDTTriggerExtensionSelector extends fflib_SObjectSelector implements Clib_IMDTTriggerExtensionSelector {

	public static Clib_MDTTriggerExtensionSelector newInstance() {
		return (Clib_MDTTriggerExtensionSelector) Clib_Application.SELECTOR.newInstance(clib_TriggerExtension__mdt.SObjectType);
	}

        /**
         * Default constructor. Reads the fields from the getSObjectFieldList() method
         **/
	public Clib_MDTTriggerExtensionSelector() {
		super(false);
	}

        /**
         * Returns a default list of fields if FieldSets functionality is not used (No Dependency Injection Pattern here!)
         **/
	public override List<Schema.SObjectField> getSObjectFieldList() {
		return new List<Schema.SObjectField> {
			clib_TriggerExtension__mdt.Id,
			clib_TriggerExtension__mdt.DeveloperName,
			clib_TriggerExtension__mdt.clib_ObjectName__c,
            clib_TriggerExtension__mdt.clib_ClassName__c,
            clib_TriggerExtension__mdt.clib_Active__c
		};
	}

	public override Schema.SObjectType getSObjectType() {
		return clib_TriggerExtension__mdt.sObjectType;
	}

	public List<clib_TriggerExtension__mdt> selectActiveByObjectName(String objectName) {
		fflib_QueryFactory triggerExtension = newQueryFactory();
		return (List<clib_TriggerExtension__mdt>) Database.query (
			triggerExtension.setCondition('clib_Active__c = true AND clib_ObjectName__r.QualifiedApiName =: objectName').toSOQL());
	}
}