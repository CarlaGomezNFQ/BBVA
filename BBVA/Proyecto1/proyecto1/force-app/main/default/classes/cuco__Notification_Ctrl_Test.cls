/**
* ────────────────────────────────────────────────────────────────────
* Notification_Ctrl_Test
* Test class for Notification_Ctrl apex class
* ────────────────────────────────────────────────────────────────────
* @author      Diego Arias <diego.arias.fernandez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-06-10
* @modified
* @systemLayer
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@IsTest
public class Notification_Ctrl_Test {

    @TestSetup
    static void makeDataNotification() {
        // Create parent acc
        final List<Account> lstNotificationAcc = Test_Utils.createAccounts(2);
        insert lstNotificationAcc;

        // Create child accs
        final List<Account> lstNotificationChildAcc = Test_Utils.createAccounts(2);
        for (Account acc : lstNotificationChildAcc) {
            acc.ParentId = lstNotificationAcc[0].Id;
        }
        insert lstNotificationChildAcc;

        // Create profitability sheet
        final List<profitability_sheet__c> lstPSNotification = Test_Utils.createProfSheet(1, lstNotificationAcc);
        insert lstPSNotification;

        // Create profitability analysis
        final List<profitability_analysis__c> lstPANotification = Test_Utils.createProfAnalysis(2, lstNotificationAcc);
        for (Integer i=0; i<lstPANotification.size(); i++) {
            lstPANotification[i].gf_profitability_sheet_id__c = lstPSNotification[0].Id;
        }
        lstPANotification[0].gf_pa_mgmt_stage_type_name__c = 'Formalization';
        lstPANotification[0].gf_pa_mgmt_status_type_name__c = 'Formalization Returned';
        lstPANotification[1].gf_pa_mgmt_stage_type_name__c = 'Formalization';
        lstPANotification[1].gf_pa_mgmt_status_type_name__c = 'Sent for Formalization';
        insert lstPANotification;

        // Create profitability analysis participant
        final List<profitability_analysis_participant__c> lstPAPNotification = Test_Utils.createProfAnalysisParticipant(2, lstPANotification[1].Id, new List<Id>{lstNotificationChildAcc[0].Id, lstNotificationChildAcc[1].Id});
        insert lstPAPNotification;
    }

    // Check doNotificationSave with action not available
    @IsTest
    static void doNotificationSaveTest1() {

        final ProfitabilityAnalysis_Selector profAnSelector1 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA1 = new Set<String>{'Prof Analysis Test 0'};
        final List<profitability_analysis__c> lstPA1 = profAnSelector1.selectByName(setNamesPA1);
        final String notificationComments1 = 'Test notification comments';
        final String auditSave1 = 'test audit html';

        Test.startTest();
            try {
                Notification_Ctrl.doNotificationSave(lstPA1[0].Id, notificationComments1, auditSave1);
            } catch (AuraHandledException e) {
                System.assertNotEquals(null, e.getMessage(), 'Err at Notification_Ctrl_Test - doNotificationSaveTest1');
            }
        Test.stopTest();
    }

    // Check doNotificationSave withoput err
    @IsTest
    static void doNotificationSaveTest2() {

        final ProfitabilityAnalysis_Selector profAnSelector2 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA2 = new Set<String>{'Prof Analysis Test 1'};
        final List<profitability_analysis__c> lstPA2 = profAnSelector2.selectByName(setNamesPA2);
        final String notificationComments2 = 'Test notification comments';
        final String auditSave2 = 'test audit html';

        Test.startTest();

            final Map<String, Object> retMap2 = Notification_Ctrl.doNotificationSave(lstPA2[0].Id, notificationComments2, auditSave2);
            final Map<String, Object> expectedMap2 = new Map<String, Object>();
            expectedMap2.put('isSuccess', true);
            expectedMap2.put('message', Label.notification_success_sample);
            System.assertEquals(expectedMap2, retMap2, 'Err at Notification_Ctrl_Test - doNotificationSaveTest2');

        Test.stopTest();
    }

    // doNotificationSave err
    @IsTest
    static void doNotificationSaveTest3() {
        Test.startTest();
            try {
                Notification_Ctrl.doNotificationSave(null, null, null);
            } catch (AuraHandledException e) {
                System.assertNotEquals(null, e.getMessage(), 'Err at Notification_Ctrl_Test - doNotificationSaveTest3');
            }
        Test.stopTest();
    }

    // Private constructor test
    @IsTest
    static void notificationCtrlConstructorTest1() {
        Test.startTest();
            final Notification_Ctrl constructorTest1 = new Notification_Ctrl();
            System.assertEquals(constructorTest1, constructorTest1, 'Err at Notification_Ctrl_Test - notificationCtrlConstructorTest1');
        Test.stopTest();
    }

    // Private constructor test
    @IsTest
    static void notificationCtrlConstructorTest2() {
        Test.startTest();
            final Notification_Service constructorTest2 = new Notification_Service();
            System.assertEquals(constructorTest2, constructorTest2, 'Err at Notification_Ctrl_Test - notificationCtrlConstructorTest2');
        Test.stopTest();
    }

    // Private constructor test
    @IsTest
    static void notificationCtrlConstructorTest3() {
        Test.startTest();
            final Notification_Helper constructorTest3 = new Notification_Helper();
            System.assertEquals(constructorTest3, constructorTest3, 'Err at Notification_Ctrl_Test - notificationCtrlConstructorTest3');
        Test.stopTest();
    }
}