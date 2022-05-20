public inherited sharing class Clib_QuickActionsSelector extends fflib_SObjectSelector implements Clib_IQuickActionsSelector { //NOSONAR

    public static Clib_IQuickActionsSelector newInstance() {
		return (Clib_IQuickActionsSelector) Clib_Application.SELECTOR.newInstance(clib_QuickActions__mdt.SObjectType);
	}

        /**
         * Default constructor. Reads the fields from the getSObjectFieldList() method
         **/
	public Clib_QuickActionsSelector() {
		super(false);
	}

        /**
         * Returns a default list of fields if FieldSets functionality is not used (No Dependency Injection Pattern here!)
         **/
	public override List<Schema.SObjectField> getSObjectFieldList() {
		return new List<Schema.SObjectField> {
			       clib_QuickActions__mdt.Id,
			       clib_QuickActions__mdt.DeveloperName,
                   clib_QuickActions__mdt.clib_Class_Name__c,
                   clib_QuickActions__mdt.clib_Method_Name__c
		};
	}

	public override Schema.SObjectType getSObjectType() {
		return clib_QuickActions__mdt.sObjectType;
	}

    public List<clib_QuickActions__mdt> selectByDeveloperName(Set<String> stringSet) {
		fflib_QueryFactory projectChecklistsQF = newQueryFactory();
		return (List<clib_QuickActions__mdt>) Database.query (
			projectChecklistsQF.setCondition('DeveloperName in :stringSet').toSOQL());

	}
}