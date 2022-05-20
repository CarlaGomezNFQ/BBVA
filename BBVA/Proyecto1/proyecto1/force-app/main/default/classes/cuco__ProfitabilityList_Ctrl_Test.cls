/**
* ────────────────────────────────────────────────────────────────────────────────────
* ProfitabilityList_Ctrl_Test
* Test class for ProfitabilityList_Ctrl_Test apex class
* ────────────────────────────────────────────────────────────────────────────────────
* @author      Giancarlo Mastrogiorgio <giancarlo.Mastrogiorigo.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-02-10
* @modified
* @systemLayer Presentation
* ────────────────────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────────────────────
*/
@IsTest
public class ProfitabilityList_Ctrl_Test {
    @TestSetup
    static void makeDataOfParticipantsCtrl() {

        final List<Account> lstGroupAccount = Test_Utils.createAccounts(5);
        lstGroupAccount[0].Name = 'Account Test Group 0';
        lstGroupAccount[1].Name = 'Account Test Orphan 1';
        lstGroupAccount[2].Name = 'Account Test Subsidiary 0';
        lstGroupAccount[3].Name = 'Account Test Group 1';
        lstGroupAccount[4].Name = 'Account Test Group 2';
        insert lstGroupAccount;

        final List<Account> lstAccount = Test_Utils.createAccounts(4);
        lstAccount[0].ParentId = lstGroupAccount[0].Id;
        lstAccount[1].ParentId = lstGroupAccount[0].Id;
        lstAccount[2].ParentId = lstGroupAccount[3].Id;
        lstAccount[3].ParentId = lstGroupAccount[4].Id;
        insert lstAccount;

        final List<Account> lstAccs2PS = new List<Account>{lstGroupAccount[0], lstGroupAccount[3], lstGroupAccount[4], lstGroupAccount[1]};
        final List<profitability_sheet__c> lstPS = Test_Utils.createProfSheet(4, lstAccs2PS);
        lstPS[0].gf_prftbly_sheet_stt_type_name__c = '01';
        lstPS[1].gf_prftbly_sheet_stt_type_name__c ='10';
        insert lstPS;

        final List<profitability_sheet_participant__c> lstPSP = Test_Utils.createProfSheetParticipant(2, lstPS[0].Id, new List<Id>{lstAccount[0].Id, lstAccount[1].Id});
        insert lstPSP;

        final List<Account> lstAccs2PA = new List<Account>{lstGroupAccount[0], lstGroupAccount[3], lstGroupAccount[4]};
        final List<profitability_analysis__c> lstPA = Test_Utils.createProfAnalysis(3, lstAccs2PA);
        lstPA[0].gf_pa_management_type_name__c = 'Novation';
        lstPA[0].gf_pa_mgmt_stage_type_name__c = 'Analysis';
        lstPA[0].gf_pa_mgmt_status_type_name__c = 'Analysis';
        lstPA[0].gf_profitability_sheet_id__c = lstPS[0].Id;
        lstPA[1].gf_pa_management_type_name__c = 'New';
        lstPA[1].gf_pa_mgmt_stage_type_name__c = 'Analysis';
        lstPA[1].gf_pa_mgmt_status_type_name__c = 'Analysis';
        lstPA[1].gf_profitability_sheet_id__c = lstPS[1].Id;
        lstPA[2].gf_pa_management_type_name__c = 'Cancellation';
        lstPA[2].gf_pa_mgmt_stage_type_name__c = 'Analysis';
        lstPA[2].gf_pa_mgmt_status_type_name__c = 'Analysis';
        lstPA[2].gf_profitability_sheet_id__c = lstPS[2].Id;
        insert lstPA;

        final List<profitability_analysis_participant__c> lstPAP = Test_Utils.createProfAnalysisParticipant(2, lstPA[0].Id, new List<Id>{lstAccount[0].Id, lstAccount[1].Id});
        insert lstPAP;
    }
    // Check participantsInfo related to Prof Sheet with prof sheet participants
    @IsTest
    static void getParticpantHrcyTest1() {
        final List<Account> lstAcc = [SELECT Id FROM Account WHERE Parent.Name = 'Account Test Group 0' LIMIT 1];
        Test.startTest();
            final Map<String, Object> retMap = ProfitabilityList_Ctrl.getParticpantHrcy(lstAcc[0].Id, 'Account');
            final Map<String, Object> actualMap1 = new Map<String, Object>();
                actualMap1.put('LName', retMap.get('LName'));
                actualMap1.put('Name', 'Account Test 0');
                actualMap1.put('Type', retMap.get('Type'));
                actualMap1.put('tableTitle', Label.available_client_ps);
                actualMap1.put('gritdata', null);
            final Map<String, Object> expectedMap1 = new Map<String, Object>();
                expectedMap1.put('LName', Label.Client);
                expectedMap1.put('Name', 'Account Test 0');
                expectedMap1.put('Type', 'subsidiary');
                expectedMap1.put('tableTitle', Label.available_client_ps);
                expectedMap1.put('gritdata', null);
            System.assertEquals(expectedMap1, actualMap1, 'Err at ProfitabilityList_Ctrl_Test - getParticpantHrcyTest1');
        Test.stopTest();
    }
    // Check participantsInfo related to Prof Sheet with prof sheet participants
    @IsTest
    static void getParticpantHrcyTest2() {
        final List<Account> lstAcc6 = [SELECT Id FROM Account WHERE Name = 'Account Test Orphan 1' LIMIT 1];
        Test.startTest();
            final Map<String, Object> retMap = ProfitabilityList_Ctrl.getParticpantHrcy(lstAcc6[0].Id, 'Account');
            final Map<String, Object> actualMap1 = new Map<String, Object>();
                actualMap1.put('LName', retMap.get('LName'));
                actualMap1.put('Name', 'Account Test Orphan 1');
                actualMap1.put('Type', retMap.get('Type'));
                actualMap1.put('tableTitle', Label.available_client_ps);
                actualMap1.put('gritdata', null);
            final Map<String, Object> expectedMap1 = new Map<String, Object>();
                expectedMap1.put('LName', Label.Client);
                expectedMap1.put('Name', 'Account Test Orphan 1');
                expectedMap1.put('Type', 'orphan');
                expectedMap1.put('tableTitle', Label.available_client_ps);
                expectedMap1.put('gritdata', null);
            System.assertEquals(expectedMap1, actualMap1, 'Err at ProfitabilityList_Ctrl_Test - getParticpantHrcyTest2');
        Test.stopTest();
    }
    // Check participantsInfo related to Prof Sheet with prof sheet participants
    @IsTest
    static void getParticpantHrcyTest3() {
        final List<Account> lstAcc6 = [SELECT Id FROM Account WHERE Name = 'Account Test Group 0' LIMIT 1];
        Test.startTest();
            final Map<String, Object> retMap = ProfitabilityList_Ctrl.getParticpantHrcy(lstAcc6[0].Id, 'Account');
            final Map<String, Object> actualMap1 = new Map<String, Object>();
                actualMap1.put('LName', retMap.get('LName'));
                actualMap1.put('Name', 'Account Test Group 0');
                actualMap1.put('Type', retMap.get('Type'));
                actualMap1.put('tableTitle', Label.available_client_ps);
                actualMap1.put('gritdata', null);
            final Map<String, Object> expectedMap1 = new Map<String, Object>();
                expectedMap1.put('LName', Label.Group);
                expectedMap1.put('Name', 'Account Test Group 0');
                expectedMap1.put('Type', 'group');
                expectedMap1.put('tableTitle', Label.available_client_ps);
                expectedMap1.put('gritdata', null);
            System.assertEquals(expectedMap1, actualMap1, 'Err at ProfitabilityList_Ctrl_Test - getParticpantHrcyTest3');
        Test.stopTest();
    }
    // Check participantsInfo related to Prof Sheet with prof sheet participants
    @IsTest
    static void getParticpantHrcyTest5() {
        final List<Account> lstAcc6 = [SELECT Id FROM Account WHERE Name = 'Account Test Group 2' LIMIT 1];
        Test.startTest();
            final Map<String, Object> retMap = ProfitabilityList_Ctrl.getParticpantHrcy(lstAcc6[0].Id, 'Account');
            final Map<String, Object> actualMap1 = new Map<String, Object>();
                actualMap1.put('LName', retMap.get('LName'));
                actualMap1.put('Name', 'Account Test Group 2');
                actualMap1.put('Type', retMap.get('Type'));
                actualMap1.put('tableTitle', Label.available_client_ps);
                actualMap1.put('gritdata', null);
            final Map<String, Object> expectedMap1 = new Map<String, Object>();
                expectedMap1.put('LName', Label.Group);
                expectedMap1.put('Name', 'Account Test Group 2');
                expectedMap1.put('Type', 'group');
                expectedMap1.put('tableTitle', Label.available_client_ps);
                expectedMap1.put('gritdata', null);
            System.assertEquals(expectedMap1, actualMap1, 'Err at ProfitabilityList_Ctrl_Test - getParticpantHrcyTest5');
        Test.stopTest();
    }
    @IsTest
    static void getParticpantHrcyTest4() {
        Test.startTest();
            try {
                ProfitabilityList_Ctrl.getParticpantHrcy(null,null);
            } catch (AuraHandledException e) {
                System.assertNotEquals(null, e.getMessage(), 'Err at ProfitabilityList_Ctrl_Test - getParticpantHrcyTest4');
            }
        Test.stopTest();
    }
    @IsTest
    static void handleCreatedActionTest1() {
        final List<Account> lstAcc6 = [SELECT Id FROM Account WHERE Name = 'Account Test 1' LIMIT 1];
        Test.startTest();
            final Map<String, Object> retMap = ProfitabilityList_Ctrl.handleCreatedAction(lstAcc6[0].Id);
            final Map<String, Object> expectedMap1 = new Map<String, Object>();
                expectedMap1.put('create', retMap.get('create'));
            final Map<String, Object> actualMap1 = new Map<String, Object>();
                actualMap1.put('create', true);
            System.assertEquals(expectedMap1, actualMap1, 'Err at ProfitabilityList_Ctrl_Test - handleCreatedActionTest1');
        Test.stopTest();
    }
    @IsTest
    static void handleCreatedActionTest2() {
        Test.startTest();
            try {
                ProfitabilityList_Ctrl.handleCreatedAction(null);
            } catch (AuraHandledException e) {
                System.assertNotEquals(null, e.getMessage(), 'Err at ProfitabilityList_Ctrl_Test - handleCreatedActionTest2');
            }
        Test.stopTest();
    }

    // Private ProfitabilityList_Ctrl constructor test
    @IsTest
    static void profitabilityListConstructorTest1() {
        Test.startTest();
            final ProfitabilityList_Ctrl constructorTest1 = new ProfitabilityList_Ctrl();
            System.assertEquals(constructorTest1, constructorTest1, 'Err at ProfitabilityList_Ctrl_Test - profitabilityListConstructorTest1');
        Test.stopTest();
    }

    // Private ProfitabilityList_Service constructor test
    @IsTest
    static void profitabilityListConstructorTest2() {
        Test.startTest();
            final ProfitabilityList_Service constructorTest2 = new ProfitabilityList_Service();
            System.assertEquals(constructorTest2, constructorTest2, 'Err at ProfitabilityList_Ctrl_Test - profitabilityListConstructorTest2');
        Test.stopTest();
    }

    // Private ProfitabilityList_Ctrl constructor test
    @IsTest
    static void profitabilityListConstructorTest3() {
        Test.startTest();
            final ProfitabilityList_Helper constructorTest3 = new ProfitabilityList_Helper();
            System.assertEquals(constructorTest3, constructorTest3, 'Err at ProfitabilityList_Ctrl_Test - profitabilityListConstructorTest3');
        Test.stopTest();
    }
}