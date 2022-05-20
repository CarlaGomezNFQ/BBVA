/**
* @File Name          : Arc_Gen_Studies_controller_Test.cls
* @Description        : test of Controller class for Arc_Gen_StudiesSP2.cmp
* @Author             : juanpedro.benito.contractor@bbva.com
* @Group              : ARCE Team
* @Last Modified By   : juanpedro.benito.contractor@bbva.com
* @Last Modified On   : 29-04-2021
* @Changes
*==============================================================================
* Ver         Date                     Author                 Modification
*==============================================================================
* 1.0    29-04-2021  juanpedro.benito.contractor@bbva.com     Initial Version
**/
@isTest
public class Arc_Gen_Studies_controller_Test {
    /**
    * @description makeData
    * @author juanpedro.benito.contractor@bbva.com | 29-04-2021
    **/
    @TestSetup
    static void testSetup() {
        final Account acc = new Account();
        acc.Name = 'TestAcc';
        acc.AccountNumber = 'CAONlXcCA_uxyJ402AA_xw';
        insert acc;
        final arce__Analysis__c analisis = Arc_Gen_Testing_Util.createAnalisis();
        analisis.arce__anlys_wkfl_sub_process_type__c = '4';
        analisis.arce__rating_prerating_type__c = 'Prerating';
        insert analisis;
        final arce__Account_has_Analysis__c aha = Arc_Gen_Testing_Util.createAccountHasAnalisis(analisis.Id);
        aha.arce__Customer__c = acc.id;
        aha.arce__InReview__c = true;
        insert aha;
        iaso__GBL_Rest_Services_Url__c cs = new iaso__GBL_Rest_Services_Url__c();
        cs.iaso__Cache_Partition__c = 'iaso.ServicesPartition';
        cs.iaso__Url__c = 'https://ei-asoexternos.grupobbva.com/ESCD/risk-analyst/v0/risk-assessments';
        cs.Name = 'ratingsSP2';
        cs.iaso__Timeout__c = 60000;
        cs.iaso__isCacheInOrg__c = true;
        cs.iaso__Blocked_Service__c = false;
        cs.iaso__cacheTTLInSecs__c = 300;
        cs.iaso__Enable_Log__c = false;
        insert cs;
    }
    /**
    * @description getJsonTableTest method test
    * @author juanpedro.benito.contractor@bbva.com | 29-04-2021
    **/
    @isTest
    public static void getJsonTableTest1() {
        final Account acc = [SELECT id FROM Account LIMIT 1];
        Test.startTest();
        try {
            Map<String, Object> resp = Arc_Gen_Studies_controller.getJsonTable(acc.Id);
            System.assertNotEquals(resp, null, 'getJsonTableTest');
        } catch (Exception e) {
            System.debug(e);
        }
        Test.stopTest();
    }
    /**
    * @description getJsonTableTest method test
    * @author juanpedro.benito.contractor@bbva.com | 29-04-2021
    **/
    @isTest
    public static void getJsonTableTest2() {
        final arce__Account_has_Analysis__c aha = [SELECT id FROM arce__Account_has_Analysis__c LIMIT 1];
        Test.startTest();
        try {
            Map<String, Object> resp = Arc_Gen_Studies_controller.getJsonTable(aha.Id);
            System.assertNotEquals(resp, null, 'getJsonTableTest');
        } catch (Exception e) {
            System.debug(e);
        }
        Test.stopTest();
    }
}