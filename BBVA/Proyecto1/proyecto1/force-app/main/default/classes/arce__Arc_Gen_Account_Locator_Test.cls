/*------------------------------------------------------------------
*Author:        bbva.com developers
*Project:      	ARCE - BBVA Bancomer
*Description:   Test class for Arc_Gen_Account_Locator
*_______________________________________________________________________________________
*Versión    Date           	Author                              Description
*1.0        14/09/2020      ARCE's TEAM                         Created.
*2.0        17/03/2021      ARCE's TEAM                         create getRatingGCPByAccountNumberTest method
-----------------------------------------------------------------------------------------*/
@isTest
global with sharing class Arc_Gen_Account_Locator_Test {
    /**
        * @Description: String with value "accNumber"
    */
    private static String accNumber = 'CAONlXcCA_uxyJ402AA_xw';
    /**
    *-------------------------------------------------------------------------------
    * @Description Test setup
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-09-14
    *--------------------------------------------------------------------------------
    **/
    @TestSetup
    static void testSetup() {
        final Account acc = Arc_UtilitiesToTest_tst.crearCuenta('TestAcc', null, null, accNumber);
        insert acc;
        final arce__Analysis__c analisis = Arc_UtilitiesToTest_tst.crearArceAnalysis('TestAna', 'Arce', acc.id);
        insert analisis;
        final arce__Sector__c sector = Arc_UtilitiesToTest_tst.crearSector('g-01', '100', 'g-01', null);
        insert sector;
        final arce__Account_has_Analysis__c aha = Arc_UtilitiesToTest_tst.crearAccHasAnalysis(sector.Id, analisis.Id, acc.id, 'g-01');
        insert aha;
        final arce__rating__c rating = Arc_UtilitiesToTest_tst.crearRating(null);
        insert rating;
        final arce__Financial_Statements__c ffss = Arc_UtilitiesToTest_tst.crearFinStatement(acc.id, aha.id, rating.id, null);
        ffss.arce__ffss_submitted_type__c = '1';
        ffss.arce__ffss_valid_type__c = '1';
        insert ffss;
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Test Arc_Gen_ServiceAndSaveResponse
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-09-14
    *--------------------------------------------------------------------------------
    **/
    @isTest
    global static void createServiceAndSaveResponse() {
        Test.startTest();
        final Arc_Gen_ServiceAndSaveResponse sasResp = new Arc_Gen_ServiceAndSaveResponse();
        sasResp.serviceCode = '';
        sasResp.serviceMessage = '';
        sasResp.saveMessage = '';
        sasResp.saveStatus = '';
        sasResp.serviceResponse = '';
        System.assertEquals('', sasResp.serviceResponse, 'Error createServiceResponse');
        Test.stopTest();
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Test Arc_Gen_Account_Locator.getAccountByAccNumber
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-09-14
    *--------------------------------------------------------------------------------
    **/
    @isTest
    global static void getAccountByAccNumberTest() {
        Test.startTest();
        final List<Account> lstAcc = [Select AccountNumber from Account LIMIT 1];
        final List<String> lstStr = new List<String>();
        for(Account acc : lstAcc) {
            lstStr.add(acc.AccountNumber);
        }
        final Map<String, Arc_Gen_Account_Wrapper> mapa = Arc_Gen_Account_Locator.getAccountByAccNumber(lstStr);
        System.assert(!mapa.isEmpty(), 'Error getAccountByAccNumberTest');
        Test.stopTest();
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Test Arc_Gen_Account_Locator.getAccountByAccNumber
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-09-14
    *--------------------------------------------------------------------------------
    **/
    @isTest
    global static void getAccountInfoByIdTest() {
        Test.startTest();
        final List<Account> lstAcc = [Select Id from Account LIMIT 1];
        final List<Id> lstStr = new List<Id>();
        for(Account acc : lstAcc) {
            lstStr.add(acc.Id);
        }
        final Map<Id, Arc_Gen_Account_Wrapper> mapa = Arc_Gen_Account_Locator.getAccountInfoById(lstStr);
        System.assert(!mapa.isEmpty(), 'Error getAccountInfoByIdTest');
        Test.stopTest();
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Test Arc_Gen_Account_Locator.accountsForLookup
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-09-14
    *--------------------------------------------------------------------------------
    **/
    @isTest
    global static void accountsForLookupTest() {
        Test.startTest();
        final List<Arc_Gen_Account_Wrapper> lista = Arc_Gen_Account_Locator.accountsForLookup(accNumber);
        System.assert(lista.isEmpty(), 'Error accountsForLookupTest');
        Test.stopTest();
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Test Arc_Gen_Account_Locator.accountUpdate
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-09-14
    *--------------------------------------------------------------------------------
    **/
    @isTest
    global static void accountUpdateTest() {
        Test.startTest();
        final Account acc = [Select id from Account LIMIT 1];
        final Map<String, String> mapaStr = new Map<String, String>();
        mapaStr.put('Name', 'TESTUPDATE');
        final Map<Id, Map<String,String>> lstAccUp = new Map<Id, Map<String, String>>();
        lstAccUp.put(acc.id, mapaStr);
        final Arc_Gen_ServiceAndSaveResponse resp = Arc_Gen_Account_Locator.accountUpdate(lstAccUp);
        System.assertEquals(null, resp.saveStatus, 'Error accountUpdateTest');
        Test.stopTest();
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Test Arc_Gen_Account_Locator.createGroup
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-09-14
    *--------------------------------------------------------------------------------
    **/
    @isTest
    global static void createGroupTest() {
        Test.startTest();
        final Map<String,String> mapa = new Map<String, String>();
        mapa.put('Name', 'TESTNAME');
        final Arc_Gen_ServiceAndSaveResponse resp = Arc_Gen_Account_Locator.createGroup(mapa);
        System.assertEquals(null, resp.saveStatus, 'Error createGroupTest');
        Test.stopTest();
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Test Arc_Gen_Account_Locator.getRatingGCPByAccountNumber
    *--------------------------------------------------------------------------------
    * @ Author alexander.munguia.contactor@bbva.com
    * @ Date 2021-03-17
    *--------------------------------------------------------------------------------
    **/
    @isTest
    global static void getRatingGCPByAccountNumberTest() {
        final arce__Account_has_Analysis__c aha = [SELECT Id FROM arce__Account_has_Analysis__c LIMIT 1];
        Test.startTest();
        final Map<String, arce__Financial_Statements__c> resp = Arc_Gen_Account_Locator.getRatingGCPByAccountNumber(new List<String> {accNumber});
        System.assertEquals(aha.Id, resp.get(accNumber).arce__account_has_analysis_id__c, 'Error getRatingGCPByAccountNumberTest');
        Test.stopTest();
    }
}