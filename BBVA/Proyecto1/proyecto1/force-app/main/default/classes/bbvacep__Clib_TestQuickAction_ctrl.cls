@isTest
public class Clib_TestQuickAction_ctrl {
	
    public class SampleClass implements Clib_IQuickAction {
        public String switcher(String method, Id recordId) {
            return method;
        }
    }
    @isTest static void coreTest() {
        cLib_QuickActions__mdt quickAction = Clib_QuickAction_ctrl.getQuickAction('Sample_Quick_Action');
        System.assert(quickAction != null);
        String res = Clib_QuickAction_ctrl.callQuickActionMethod(quickAction, null);
        System.assertEquals(res, 'SampleMethod');
    }
    
    @isTest static void badNameTest() {
        cLib_QuickActions__mdt quickAction = Clib_QuickAction_ctrl.getQuickAction('Unexisting_QuickAction');
        System.assert(quickAction == null);
    }
}