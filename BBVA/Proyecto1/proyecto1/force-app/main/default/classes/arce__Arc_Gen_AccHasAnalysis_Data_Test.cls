/*------------------------------------------------------------------
*Author:        bbva.com developers
*Project:      	ARCE - BBVA Bancomer
*Description:   Test class for Arc_Gen_AccHasAnalysis_Data
*_______________________________________________________________________________________
*Versión    Date           	Author                              Description
*1.0        11/04/2020      ARCE's TEAM                         Created.
*2.0        04/11/2020      ARCE's TEAM                         Moved to dependencies package
-----------------------------------------------------------------------------------------*/
@SuppressWarnings('sf:TooManyMethods')
@isTest
global with sharing class Arc_Gen_AccHasAnalysis_Data_Test {
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
        final Account acc = Arc_UtilitiesToTest_tst.crearCuenta('TestAcc', null, null, 'CAONlXcCA_uxyJ402AA_xw');
        insert acc;
        final arce__Analysis__c analisis = Arc_UtilitiesToTest_tst.crearArceAnalysis('TestAna', 'Arce', acc.id);
        insert analisis;
        arce__Sector__c sector = Arc_UtilitiesToTest_tst.crearSector('g-01', '100', 'g-01', null);
        insert sector;
        arce__Account_has_Analysis__c aha = Arc_UtilitiesToTest_tst.crearAccHasAnalysis(sector.Id, analisis.Id, acc.id, 'g-01');
        aha.arce__group_asset_header_type__c = '1';
        aha.arce__analysis_template_id__c = 'Generic';
        aha.arce__InReview__c = true;
        insert aha;
        Arc_Gen_AccHasAnalysis_Data.updateRecords(aha);
        final List<arce__Account_has_Analysis__c> lstAha = new List<arce__Account_has_Analysis__c>();
        lstAha.add(aha);
        Arc_Gen_AccHasAnalysis_Data.updateAccHasAnalysis(lstAha);
        Arc_Gen_AccHasAnalysis_Data.upsertObjects(lstAha);
        arce__Account_has_Analysis__c aha2 = Arc_UtilitiesToTest_tst.crearAccHasAnalysis(sector.Id, analisis.Id, acc.id, 'g-01');
        aha.arce__InReview__c = true;
        insert aha2;
        final Map<String, String> mapIds = new Map<String, String>();
        mapIds.put(aha2.Id, aha2.Id);
        Arc_Gen_AccHasAnalysis_Data.setDeleteLogic(mapIds);
        final dyfr__Template__c template = Arc_UtilitiesToTest_tst.crearTemplate('Generic');
        insert template;
        final dyfr__Tab__c tab = Arc_UtilitiesToTest_tst.crearTab('BasicData',template.id);
        insert tab;
        final dyfr__Field_Config__c fieldConf = Arc_UtilitiesToTest_tst.crearfieldConfigData('Name', tab.id, 'Name');
        insert fieldConf;
        final arce__main_banks__c mBank = new arce__main_banks__c();
        mBank.arce__account_has_analysis_id__c = aha.id;
        mBank.arce__entity_name__c = 'TestBank';
        mBank.arce__entity_quota_share_per__c = 1;
        insert mBank;
        new Arc_Gen_AccHasAnalysis_Data();

    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Testing Arc_Gen_AccHasAnalysis_Data.getAccHasAnalysis
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-09-14
    *--------------------------------------------------------------------------------
    **/
    @isTest
    global static void getAccHasAnalysisTest() {
        Test.startTest();
        final arce__Account_has_Analysis__c aha = [Select id from arce__Account_has_Analysis__c LIMIT 1];
        final List<String> recordId = new List<String>();
        recordId.add(aha.id);
        final Arc_Gen_Account_Has_Analysis_Wrapper ahaWrapper = new Arc_Gen_Account_Has_Analysis_Wrapper();
        ahaWrapper.ahaObj = aha;
        final Arc_Gen_Account_Wrapper accWrapper = new Arc_Gen_Account_Wrapper();
        accWrapper.name = '';
        accWrapper.accNumber = '';
        accWrapper.participantType = '';
        accWrapper.participantParentaccNumber = '';
        accWrapper.bankId = '';
        accWrapper.docNumber = '';
        accWrapper.docType = '';
        accWrapper.error = '';
        accWrapper.updateStructure = true;
        accWrapper.currentLimit = 1;
        accWrapper.commited = 1;
        accWrapper.unCommited = 1;
        accWrapper.outstanding= 1;
        accWrapper.currencyType = '';
        accWrapper.unit = '';
        ahaWrapper.accWrapperObj =accWrapper;
        ahaWrapper.getX('name');
        final List<arce__Account_has_Analysis__c>  lstAha = Arc_Gen_AccHasAnalysis_Data.getAccHasAnalysis(recordId);
        System.assertEquals(lstAha[0].id, aha.id, 'Error getAccHasAnalysisTest');
        Test.stopTest();
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Testing Arc_Gen_AccHasAnalysis_Data.getAccHasAnalysisFields
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-09-14
    *--------------------------------------------------------------------------------
    **/
    @isTest
    global static void getAccHasAnalysisFieldsTest() {
        Test.startTest();
        final arce__Account_has_Analysis__c aha = [Select id from arce__Account_has_Analysis__c LIMIT 1];
        final List<String> fieldList = new List<String>();
        fieldList.add('id');
        final arce__Account_has_Analysis__c ahana = Arc_Gen_AccHasAnalysis_Data.getAccHasAnalysisFields(aha.id, fieldList);
        System.assertEquals(ahana.id, aha.id, 'Error getAccHasAnalysisFieldsTest');
        Test.stopTest();
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Testing Arc_Gen_AccHasAnalysis_Data.getByARCEandClient
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-09-14
    *--------------------------------------------------------------------------------
    **/
    @isTest
    global static void getByARCEandClientTest() {
        Test.startTest();
        final arce__Account_has_Analysis__c aha = [Select id, arce__Customer__r.AccountNumber,arce__Customer__c, arce__Analysis__c from arce__Account_has_Analysis__c LIMIT 1];
        final List<String> customerNumbers = new List<String>();
        customerNumbers.add(aha.arce__Customer__r.AccountNumber);
        final List<Arc_Gen_Account_Has_Analysis_Wrapper>  lstAha = Arc_Gen_AccHasAnalysis_Data.getByARCEandClient(aha.arce__Analysis__c, customerNumbers);
        System.assertEquals(lstAha[0].ahaObj.id, aha.id, 'Error getByARCEandClientTest');
        Test.stopTest();
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Testing Arc_Gen_AccHasAnalysis_Data.accHasAnByArce
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-09-14
    *--------------------------------------------------------------------------------
    **/
    @isTest
    global static void accHasAnByArceTest() {
        Test.startTest();
        final arce__Account_has_Analysis__c aha = [Select id, arce__Analysis__c from arce__Account_has_Analysis__c LIMIT 1];
        final List<String> lstAnalysis = new List<String>();
        lstAnalysis.add(aha.arce__Analysis__c);
        final List<arce__Account_has_Analysis__c>  lstAha = Arc_Gen_AccHasAnalysis_Data.accHasAnByArce(lstAnalysis);
        System.assertEquals(lstAha[0].id, aha.id, 'Error accHasAnByArceTest');
        Test.stopTest();
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Testing Arc_Gen_AccHasAnalysis_Data.getAccHasRelation
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-09-14
    *--------------------------------------------------------------------------------
    **/
    @isTest
    global static void getAccHasRelationTest() {
        Test.startTest();
        final arce__Account_has_Analysis__c aha = [Select id, arce__Analysis__c from arce__Account_has_Analysis__c LIMIT 1];
        final arce__Account_has_Analysis__c result = Arc_Gen_AccHasAnalysis_Data.getAccHasRelation(aha.id);
        System.assertEquals(result.id, aha.id, 'Error getAccHasRelationTest');
        Test.stopTest();
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Testing Arc_Gen_AccHasAnalysis_Data.getRelatedData
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-09-14
    *--------------------------------------------------------------------------------
    **/
    @isTest
    global static void getRelatedDataTest() {
        Test.startTest();
        final arce__Account_has_Analysis__c aha = [Select id, arce__Analysis__c from arce__Account_has_Analysis__c LIMIT 1];
        final List<String> mapFields = new List<String>();
        mapFields.add('arce__Analysis__c');
        final List<arce__Account_has_Analysis__c> result = Arc_Gen_AccHasAnalysis_Data.getRelatedData(mapFields, aha.id);
        System.assertEquals(result[0].id, aha.id, 'Error getRelatedDataTest');
        Test.stopTest();
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Testing Arc_Gen_AccHasAnalysis_Data.updateRecords
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-09-14
    *--------------------------------------------------------------------------------
    **/
    @isTest
    global static void updateRecordsTest() {
        Test.startTest();
        final arce__Account_has_Analysis__c aha = [Select id, arce__Analysis__c from arce__Account_has_Analysis__c LIMIT 1];
        final Arc_Gen_ServiceAndSaveResponse result = Arc_Gen_AccHasAnalysis_Data.updateRecords(aha);
        System.assertEquals(result.saveStatus, 'true', 'Error updateRecordsTest');
        Test.stopTest();
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Testing Arc_Gen_AccHasAnalysis_Data.getRatingStatus
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-09-14
    *--------------------------------------------------------------------------------
    **/
    @isTest
    global static void getRatingStatusTest() {
        Test.startTest();
        final arce__Account_has_Analysis__c aha = [Select id, arce__Analysis__c from arce__Account_has_Analysis__c LIMIT 1];
        final List<Id> lstId = new List<Id>();
        lstId.add(aha.id);
        final List<arce__Account_has_Analysis__c> result = Arc_Gen_AccHasAnalysis_Data.getRatingStatus(lstId);
        System.assertEquals(result[0].id, aha.id, 'Error getRatingStatusTest');
        Test.stopTest();
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Testing Arc_Gen_AccHasAnalysis_Data.getAccForResume
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-09-14
    *--------------------------------------------------------------------------------
    **/
    @isTest
    global static void getAccForResumeTest() {
        Test.startTest();
        final Account acc = [Select id from Account LIMIT 1];
        final arce__Account_has_Analysis__c aha = [Select id from arce__Account_has_Analysis__c LIMIT 1];
        final Set<Id> lstId = new Set<Id>();
        lstId.add(acc.id);
        final List<arce__Account_has_Analysis__c> result = Arc_Gen_AccHasAnalysis_Data.getAccForResume(lstId);
        System.assertEquals(result[0].id, aha.id, 'Error getAccForResumeTest');
        Test.stopTest();
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Testing Arc_Gen_AccHasAnalysis_Data.getCustomersData
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-09-14
    *--------------------------------------------------------------------------------
    **/
    @isTest
    global static void getCustomersDataTest() {
        Test.startTest();
        final arce__Account_has_Analysis__c aha = [Select id, arce__Customer__c from arce__Account_has_Analysis__c LIMIT 1];
        final arce__Account_has_Analysis__c result = Arc_Gen_AccHasAnalysis_Data.getCustomersData(aha.id);
        System.assertEquals(result.arce__Customer__c, aha.arce__Customer__c, 'Error getCustomersDataTest');
        Test.stopTest();
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Testing Arc_Gen_AccHasAnalysis_Data.getAccHasAnFromArce
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-09-14
    *--------------------------------------------------------------------------------
    **/
    @isTest
    global static void getAccHasAnFromArceTest() {
        Test.startTest();
        final arce__Analysis__c ana = [Select id from arce__Analysis__c LIMIT 1];
        final List<arce__Account_has_Analysis__c> result = Arc_Gen_AccHasAnalysis_Data.getAccHasAnFromArce(ana.id);
        System.assertEquals(result[0].arce__Analysis__c, ana.id, 'Error getAccHasAnFromArceTest');
        Test.stopTest();
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Testing Arc_Gen_AccHasAnalysis_Data.getAllAnalysis
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-09-14
    *--------------------------------------------------------------------------------
    **/
    @isTest
    global static void getAllAnalysisTest() {
        Test.startTest();
        final arce__Account_has_Analysis__c aha = [Select id from arce__Account_has_Analysis__c LIMIT 1];
        final List<Arc_Gen_Account_Has_Analysis_Wrapper> result = Arc_Gen_AccHasAnalysis_Data.getAllAnalysis(aha.id);
        System.assertEquals(result[0].ahaObj.id, aha.id, 'Error getAllAnalysisTest');
        Test.stopTest();
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Testing Arc_Gen_AccHasAnalysis_Data.separateListsByFFSSDate
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-09-14
    *--------------------------------------------------------------------------------
    **/
    @isTest
    global static void separateListsByFFSSDateTest() {
        Test.startTest();
        final arce__Account_has_Analysis__c aha = [Select id from arce__Account_has_Analysis__c LIMIT 1];
        final Set<id> ids = new Set<id>();
        ids.add(aha.id);
        final Map<String, Set<Id>> result = Arc_Gen_AccHasAnalysis_Data.separateListsByFFSSDate(ids);
        System.assertEquals(result.get('notInForce'), ids, 'Error separateListsByFFSSDateTest');
        Test.stopTest();
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Testing Arc_Gen_AccHasAnalysis_Data.getAhaGroupOfArce
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-09-14
    *--------------------------------------------------------------------------------
    **/
    @isTest
    global static void getAhaGroupOfArceTest() {
        Test.startTest();
        final arce__Analysis__c aha = [Select id from arce__Analysis__c LIMIT 1];
        final arce__Account_has_Analysis__c result = Arc_Gen_AccHasAnalysis_Data.getAhaGroupOfArce(aha.id);
        System.assertEquals(result.arce__Analysis__c, aha.id, 'Error getAhaGroupOfArceTest');
        Test.stopTest();
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Testing Arc_Gen_AccHasAnalysis_Data.getAhaByRiskAssessment
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-09-14
    *--------------------------------------------------------------------------------
    **/
    @isTest
    global static void getAhaByRiskAssessmentTest() {
        Test.startTest();
        final arce__Account_has_Analysis__c aha = [Select id, name from arce__Account_has_Analysis__c LIMIT 1];
        final List<String> names = new List<String>();
        names.add(aha.name);
        final List<arce__Account_has_Analysis__c> result = Arc_Gen_AccHasAnalysis_Data.getAhaByRiskAssessment(names);
        System.assertEquals(result[0].id, aha.id, 'Error getAhaByRiskAssessmentTest');
        Test.stopTest();
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Testing Arc_Gen_AccHasAnalysis_Data.copyAccHasAnforReno
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-09-14
    *--------------------------------------------------------------------------------
    **/
    @isTest
    global static void copyAccHasAnforRenoTest() {
        Test.startTest();
        final arce__Account_has_Analysis__c aha = [Select id, name from arce__Account_has_Analysis__c LIMIT 1];
        final Set<id> ids = new Set<id>();
        ids.add(aha.id);
        final List<arce__Account_has_Analysis__c> result = Arc_Gen_AccHasAnalysis_Data.copyAccHasAnforReno(ids,Arc_Gen_Constants.RENOVATION_CODE);
        System.assertEquals(result[0].id, aha.id, 'Error copyAccHasAnforRenoTest');
        Test.stopTest();
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Testing Arc_Gen_AccHasAnalysis_Data.getAccMainBanksData
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-09-14
    *--------------------------------------------------------------------------------
    **/
    @isTest
    global static void getAccMainBanksDataTest() {
        Test.startTest();
        final arce__Account_has_Analysis__c aha = [Select id, name from arce__Account_has_Analysis__c LIMIT 1];
        final Set<id> ids = new Set<id>();
        ids.add(aha.id);
        final List<arce__main_banks__c> result = Arc_Gen_AccHasAnalysis_Data.getAccMainBanksData(ids);
        System.assertEquals(result[0].arce__account_has_analysis_id__c, aha.id, 'Error getAccMainBanksDataTest');
        Test.stopTest();
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Testing Arc_Gen_AccHasAnalysis_Data.getAllAccFromArce
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-09-14
    *--------------------------------------------------------------------------------
    **/
    @isTest
    global static void getAllAccFromArceTest() {
        Test.startTest();
        final arce__Account_has_Analysis__c aha = [Select id, arce__Analysis__c, name from arce__Account_has_Analysis__c LIMIT 1];
        final List<arce__Account_has_Analysis__c> result = Arc_Gen_AccHasAnalysis_Data.getAllAccFromArce(aha.arce__Analysis__c);
        System.assertEquals(result[0].arce__Analysis__c, aha.arce__Analysis__c, 'Error getAllAccFromArceTest');
        Test.stopTest();
    }
}