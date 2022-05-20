@isTest
public class Clib_TestQuickActionsSelector {

    @isTest static void selectByDeveloperNameTest() {
        List <clib_QuickActions__mdt> quickActionList = Clib_QuickActionsSelector.newInstance().selectByDeveloperName(new Set <String> {'Sample_Quick_Action'});
        System.assert(!quickActionList.isEmpty());
    }
}