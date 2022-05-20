public inherited sharing class Clib_QuickAction_ctrl {

	@AuraEnabled
	public static clib_QuickActions__mdt getQuickAction(String devName) {

		        // Create unit of work to capture work and commit it under one transaction
		fflib_ISObjectUnitOfWork uow = Clib_Application.UNITOFWORK.newInstance();
                // Query Project Checklists with evidences
		List<clib_QuickActions__mdt> quickActions = new Clib_QuickActionsSelector().selectByDeveloperName(new Set <String>{devName});
		if (quickActions.size() == 1){
			return quickActions[0];
		} else {
			return null;
		}
	}

	@AuraEnabled
	public static String callQuickActionMethod(clib_QuickActions__mdt quickAction, Id recordId) {
		Type t = Type.forName(quickAction.clib_Class_Name__c);
		Clib_IQuickAction interfaceClass = (Clib_IQuickAction)t.newInstance();
		return interfaceClass.switcher(quickAction.clib_Method_Name__c, recordId);
	}
}