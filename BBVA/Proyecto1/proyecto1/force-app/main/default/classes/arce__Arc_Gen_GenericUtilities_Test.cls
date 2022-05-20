/*------------------------------------------------------------------
*Author:        bbva.com developers
*Project:      	ARCE - BBVA Bancomer
*Description:   Test class for Arc_Gen_GenericUtilities
*_______________________________________________________________________________________
*Versión    Date           	Author                              Description
*1.0        2020-11-04      ARCE's TEAM                         Created.
-----------------------------------------------------------------------------------------*/
@SuppressWarnings('sf:TooManyMethods')
@isTest
global with sharing class Arc_Gen_GenericUtilities_Test {
    /**
    * @Description: String with literal EUR
    */
    static final string EUR = 'EUR';
    /**
    * @Description: String with literal Euro
    */
    static final string EURO = 'Euro';
    /**
    * @Description: String with literal CurrencyIsoCode
    */
    static final string CURRENCYISO = 'CurrencyIsoCode';
    /**
    *-------------------------------------------------------------------------------
    * @Description Test setup
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-11-04
    *--------------------------------------------------------------------------------
    **/
    @TestSetup
    static void testSetup() {
        final Account acc = Arc_UtilitiesToTest_tst.crearCuenta('TestAcc', null, null, 'CAONlXcCA_uxyJ402AA_xw');
        insert acc;
        final arce__Analysis__c analisis = Arc_UtilitiesToTest_tst.crearArceAnalysis('TestAna', 'Arce', acc.id);
        insert analisis;
        final arce__Sector__c sector = Arc_UtilitiesToTest_tst.crearSector('g-01', '100', 'g-01', null);
        insert sector;
        final arce__Account_has_Analysis__c aha = Arc_UtilitiesToTest_tst.crearAccHasAnalysis(sector.Id, analisis.Id, acc.id, 'g-01');
        final List<arce__Account_has_Analysis__c> lstAha = new List<arce__Account_has_Analysis__c>();
        lstAha.add(aha);
        Arc_Gen_GenericUtilities.insertRecords(lstAha);
        lstAha[0].arce__magnitude_unit_type__c = '1';
        lstAha[0].arce__prev_magnitude_unit_type__c = '2';
        lstAha[0].arce__anlys_wkfl_cnsld_ffss_type__c = '1';
        lstAha[0].arce__anlys_wkfl_cnsld_ffss_type__c = 'BOTTOM_UP';
        lstAha[0].arce__InReview__c = true;
        lstAha[0].arce__group_asset_header_type__c = '2';
        final arce__rating__c rating = Arc_UtilitiesToTest_tst.crearRating(null);
        insert rating;
        final arce__Financial_Statements__c ffss = Arc_UtilitiesToTest_tst.crearFinStatement(acc.id, aha.id, rating.id, null);
        insert ffss;
        lstAha[0].arce__ffss_for_rating_id__c = ffss.id;
        Arc_Gen_GenericUtilities.updateRecords(lstAha);
        new Arc_Gen_Arceconfigs_locator();
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Testing NEW in Arc_Gen_GenericUtilities.getEventTypeValue
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-11-04
    *--------------------------------------------------------------------------------
    **/
    @isTest
    global static void getupdatedStructureTest() {
        Test.startTest();
        final Boolean updatedStructure = Arc_Gen_GenericUtilities.getUpdateStructure();
        System.assert(updatedStructure, 'Error getupdatedStructure_Test');
        Test.stopTest();
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Testing NEW in Arc_Gen_GenericUtilities.getEventTypeValue
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-11-04
    *--------------------------------------------------------------------------------
    **/
    @isTest
    global static void getOrphanAnsStructureTest() {
        Test.startTest();
        final Boolean orphanStructure = Arc_Gen_GenericUtilities.getOrphanAnsStructure();
        System.assert(!orphanStructure, 'Error getOrphanAnsStructure_Test');
        Test.stopTest();
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Testing NEW in Arc_Gen_GenericUtilities.getEventTypeValue
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-11-04
    *--------------------------------------------------------------------------------
    **/
    @isTest
    global static void getEventTypeNewTest() {
        Test.startTest();
        final String spvalue = '2';
        final String resultNew = Arc_Gen_GenericUtilities.getEventTypeValue(spvalue);
        System.assertEquals('NEW', resultNew, 'Error getEventTypeNew_Test');
        Test.stopTest();
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Testing EDIT in Arc_Gen_GenericUtilities.getEventTypeValue
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-11-04
    *--------------------------------------------------------------------------------
    **/
    @isTest
    global static void getEventTypeEdit() {
        Test.startTest();
        final String spEdit = '3';
        final String resultEdit = Arc_Gen_GenericUtilities.getEventTypeValue(spEdit);
        System.assertEquals('EDIT', resultEdit, 'Error getEventTypeEdit_Test');
        Test.stopTest();
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Testing RATING in Arc_Gen_GenericUtilities.getEventTypeValue
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-11-04
    *--------------------------------------------------------------------------------
    **/
    @isTest
    global static void getEventTypeRating() {
        Test.startTest();
        final String spRating = '4';
        final String resultRating = Arc_Gen_GenericUtilities.getEventTypeValue(spRating);
        System.assertEquals('RATING', resultRating, 'Error getEventTypeRating_Test');
        Test.stopTest();
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Testing NEW in Arc_Gen_GenericUtilities.getRecordTypeData
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-11-04
    *--------------------------------------------------------------------------------
    **/
    @isTest
    global static void getRecordTypeDataTest() {
        Test.startTest();
        final String recordTypeName = 'Arce';
        final List<RecordType> resultNew = Arc_Gen_GenericUtilities.getRecordTypeData(recordTypeName);
        System.assertEquals(recordTypeName, resultNew[0].Name, 'Error getRecordTypeDataTest');
        Test.stopTest();
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Testing NEW in Arc_Gen_GenericUtilities.getTypeOfCustomer
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-11-04
    *--------------------------------------------------------------------------------
    **/
    @isTest
    global static void getTypeOfCustomerTest() {
        Test.startTest();
        final arce__Account_has_Analysis__c arceVar = [Select Id,arce__Analysis__c,arce__Analysis__r.arce__analysis_customer_relation_type__c from arce__Account_has_Analysis__c limit 1];
        final Id userId = UserInfo.getUserId();
        final List<User> ltsMembers = [Select id from User where id =: userId];
        final Id recordId = arceVar.arce__Analysis__c;
        Arc_Gen_GenericUtilities.createNotifications(ltsMembers, recordId,arceVar.Id);
        final String typeOfCustomer = Arc_Gen_GenericUtilities.getTypeOfCustomer(arceVar.Id);
        System.assertEquals(arceVar.arce__Analysis__r.arce__analysis_customer_relation_type__c, typeOfCustomer, 'Error getTypeOfCustomer');
        Test.stopTest();
    }
/**
    *-------------------------------------------------------------------------------
    * @Description Testing NEW in Arc_Gen_GenericUtilities.getTypeOfCustomerFromStrngs
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-11-04
    *--------------------------------------------------------------------------------
    **/
    @isTest
    global static void getTypeOfCustomerFromStrngsTest() {
        Test.startTest();
        final arce__Account_has_Analysis__c arceVar = [Select Id,arce__Analysis__c,arce__Analysis__r.arce__analysis_customer_relation_type__c from arce__Account_has_Analysis__c limit 1];
        final Id userId = UserInfo.getUserId();
        final List<User> ltsMembers = [Select id from User where id =: userId];
        final Id recordId = arceVar.arce__Analysis__c;
        Arc_Gen_GenericUtilities.createNotifications(ltsMembers, recordId,arceVar.Id);
        final String typeCustomeStr = Arc_Gen_GenericUtilities.getTypeOfCustomerFromStrngs(arceVar.Id, '1');
        System.assertEquals(arceVar.arce__Analysis__r.arce__analysis_customer_relation_type__c, typeCustomeStr, 'Error getTypeOfCustomerFromStrngs');
        Test.stopTest();
    }
    /**
    *-------------------------------------------------------------------------------
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-11-04
    *--------------------------------------------------------------------------------
    **/
    @isTest
    global static void getIdsOfSubsidiariesTest() {
        Test.startTest();
        final arce__Account_has_Analysis__c arceVar = [Select Id,arce__Analysis__c,arce__Analysis__r.arce__analysis_customer_relation_type__c from arce__Account_has_Analysis__c limit 1];
        final List<Id> ids = Arc_Gen_GenericUtilities.getIdsOfSubsidiaries(arceVar.arce__Analysis__c);
        System.assertEquals(ids[0], arceVar.Id, 'Error getIdsOfSubsidiaries');
        Test.stopTest();
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Testing NEW in Arc_Gen_GenericUtilities.convertUnits
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-11-04
    *--------------------------------------------------------------------------------
    **/
    @isTest
    global static void convertUnitsTest() {
        Test.startTest();
        final arce__Account_has_Analysis__c arceVar = [Select Id,Name, arce__Analysis__c,arce__Analysis__r.arce__analysis_customer_relation_type__c from arce__Account_has_Analysis__c limit 1];
        final Arc_Gen_GenericUtilities.ConversionWrapper wrapper = new Arc_Gen_GenericUtilities.ConversionWrapper();
        final Map<String, Object> result = arce.Arc_Gen_GenericUtilities.convertUnits(wrapper);
        wrapper.actualData = 'arce__magnitude_unit_type__c';
        wrapper.previousData = 'arce__prev_magnitude_unit_type__c';
        wrapper.objDataLts = arce.Arc_Gen_LimitsExposures_Data.getExposureData(new List<Id>{arceVar.Id});
        System.assertEquals(result.get('status'), 'Error', 'error convertUnitsTest');
        Test.stopTest();
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Testing NEW in Arc_Gen_GenericUtilities.getValuesPickList
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-11-04
    *--------------------------------------------------------------------------------
    **/
    @isTest
    global static void getValuesPickListTest() {
        Test.startTest();
        final arce__Account_has_Analysis__c arceVar = [Select Id,Name, arce__Analysis__c,arce__Analysis__r.arce__analysis_customer_relation_type__c from arce__Account_has_Analysis__c limit 1];
        final String objectType = String.valueOf(arceVar.getSObjectType());
        final String selectedField = CURRENCYISO;
        final List<String> result = arce.Arc_Gen_GenericUtilities.getValuesPickList(objectType, selectedField);
        System.assertEquals(result[0], EURO, 'error getValuesPickListTest');
        Test.stopTest();
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Testing NEW in Arc_Gen_GenericUtilities.getPicklistValuesLabels
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-11-04
    *--------------------------------------------------------------------------------
    **/
    @isTest
    global static void getPicklistValuesLabelsTest1() {
        Test.startTest();
        final arce__Account_has_Analysis__c arceVar = [Select Id,Name, arce__Analysis__c,arce__Analysis__r.arce__analysis_customer_relation_type__c from arce__Account_has_Analysis__c limit 1];
        final String objectType = String.valueOf(arceVar.getSObjectType());
        final String selectedField = CURRENCYISO;
        final List<String> seelectedValues = new List<String>();
        seelectedValues.add(EUR);
        final List<map<String,String>> result = arce.Arc_Gen_GenericUtilities.getPicklistValuesLabels(objectType, selectedField);
        System.assertEquals(result[0].get('label'), EURO, 'error getPicklistValuesLabelsTest 1');
        Test.stopTest();
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Testing NEW in Arc_Gen_GenericUtilities.getPicklistValuesLabels
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-11-04
    *--------------------------------------------------------------------------------
    **/
    @isTest
    global static void getPicklistValuesLabelsTest2() {
        Test.startTest();
        final arce__Account_has_Analysis__c arceVar = [Select Id,Name, arce__Analysis__c,arce__Analysis__r.arce__analysis_customer_relation_type__c from arce__Account_has_Analysis__c limit 1];
        final String objectType = String.valueOf(arceVar.getSObjectType());
        final String selectedField = CURRENCYISO;
        final List<String> seelectedValues = new List<String>();
        seelectedValues.add(EUR);
        final List<map<String,String>> result = arce.Arc_Gen_GenericUtilities.getPicklistValuesLabels(objectType, selectedField, seelectedValues);
        System.assertEquals(result[0].get('label'), EURO, 'error getPicklistValuesLabelsTest 2');
        Test.stopTest();
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Testing NEW in Arc_Gen_GenericUtilities.getMapPicklistValuesLabels
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-11-04
    *--------------------------------------------------------------------------------
    **/
    @isTest
    global static void getMapPicklistValuesLabelsTest() {
        Test.startTest();
        final arce__Account_has_Analysis__c arceVar = [Select Id,Name, arce__Analysis__c,arce__Analysis__r.arce__analysis_customer_relation_type__c from arce__Account_has_Analysis__c limit 1];
        final String objectType = String.valueOf(arceVar.getSObjectType());
        final String selectedField = CURRENCYISO;
        final Map<String,String> result = arce.Arc_Gen_GenericUtilities.getMapPicklistValuesLabels(objectType, selectedField);
        System.assertEquals(result.get(EUR), EURO, 'error getMapPicklistValuesLabelsTest');
        Test.stopTest();
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Testing NEW in Arc_Gen_GenericUtilities.validateAllRatingsInArce
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-11-04
    *--------------------------------------------------------------------------------
    **/
    @isTest
    global static void validateAllRatingsInArceTest() {
        Test.startTest();
        final arce__Account_has_Analysis__c arceVar = [Select Id,Name, arce__Analysis__c,arce__Analysis__r.arce__analysis_customer_relation_type__c from arce__Account_has_Analysis__c limit 1];
        final Boolean result = arce.Arc_Gen_GenericUtilities.validateAllRatingsInArce(arceVar.arce__Analysis__c, '1');
        System.assert(!result, 'error validateAllRatingsInArceTest');
        Test.stopTest();
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Testing NEW in Arc_Gen_GenericUtilities.getAllAnalysis
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-11-04
    *--------------------------------------------------------------------------------
    **/
    @isTest
    global static void getAllAnalysisTest() {
        Test.startTest();
        final arce__Account_has_Analysis__c arceVar = [Select Id,Name, arce__Analysis__c,arce__Analysis__r.arce__analysis_customer_relation_type__c from arce__Account_has_Analysis__c limit 1];
        final List<Arc_Gen_GenericUtilities.Acchasanamap> result = arce.Arc_Gen_GenericUtilities.getAllAnalysis(arceVar.arce__Analysis__c);
        System.assertEquals(result[0].ids, arceVar.id, 'error getAllAnalysisTest');
        Test.stopTest();
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Testing NEW in Arc_Gen_GenericUtilities.getMultiplicationFactor
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-11-04
    *--------------------------------------------------------------------------------
    **/
    @isTest
    global static void getMultiplicationFactorTest() {
        Test.startTest();
        final arce__Account_has_Analysis__c arceVar = [Select Id, arce__magnitude_unit_type__c,arce__prev_magnitude_unit_type__c, Name, arce__Analysis__c,arce__Analysis__r.arce__analysis_customer_relation_type__c from arce__Account_has_Analysis__c limit 1];
        final SObject objectType =arceVar;
        final Double result = arce.Arc_Gen_GenericUtilities.getMultiplicationFactor('arce__magnitude_unit_type__c', 'arce__prev_magnitude_unit_type__c', objectType);
        System.assertEquals(result, 1000, 'error getMultiplicationFactor');
        Test.stopTest();
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Testing NEW in Arc_Gen_GenericUtilities.isButtonAvailable
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-11-04
    *--------------------------------------------------------------------------------
    **/
    @isTest
    global static void isButtonAvailableTest() {
        Test.startTest();
        final arce__Account_has_Analysis__c arceVar = [Select Id, arce__magnitude_unit_type__c,arce__prev_magnitude_unit_type__c, Name, arce__Analysis__c,arce__Analysis__r.arce__analysis_customer_relation_type__c from arce__Account_has_Analysis__c limit 1];
        final Boolean result = arce.Arc_Gen_GenericUtilities.isButtonAvailable(arceVar.id, 'edit');
        System.assert(result, 'error isButtonAvailableTest');
        Test.stopTest();
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Testing NEW in Arc_Gen_GenericUtilities.getMapLabelFromValue
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-11-04
    *--------------------------------------------------------------------------------
    **/
    @isTest
    global static void getMapLabelFromValueTest() {
        Test.startTest();
        final Map<String,String> result = arce.Arc_Gen_GenericUtilities.getMapLabelFromValue('arce__Account_has_Analysis__c', CURRENCYISO);
        System.assertEquals(result.get(EUR), EURO, 'error getMapLabelFromValueTest');
        Test.stopTest();
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Testing NEW in Arc_Gen_GenericUtilities.getLabelFromValue
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-11-04
    *--------------------------------------------------------------------------------
    **/
    @isTest
    global static void getLabelFromValueTest() {
        Test.startTest();
        final String result = arce.Arc_Gen_GenericUtilities.getLabelFromValue('arce__Account_has_Analysis__c', CURRENCYISO, EUR);
        System.assertEquals(result, EURO, 'error getLabelFromValueTest');
        Test.stopTest();
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Testing NEW in Arc_Gen_GenericUtilities.getAccHasAnalysis
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-11-04
    *--------------------------------------------------------------------------------
    **/
    @isTest
    global static void getAccHasAnalysisTest() {
        Test.startTest();
        final arce__Account_has_Analysis__c arceVar = [Select Id, arce__Analysis__c,arce__Analysis__r.arce__analysis_customer_relation_type__c from arce__Account_has_Analysis__c limit 1];
        final List<arce__Account_has_Analysis__c> result = arce.Arc_Gen_GenericUtilities.getAccHasAnalysis(arceVar.arce__Analysis__c);
        System.assertEquals(result[0].Id, arceVar.Id, 'error getAccHasAnalysisTest');
        Test.stopTest();
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Testing NEW in Arc_Gen_GenericUtilities.getConsolidatedType
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-11-04
    *--------------------------------------------------------------------------------
    **/
    @isTest
    global static void getConsolidatedTypeTest() {
        Test.startTest();
        final arce__Account_has_Analysis__c arceVar = [Select Id,arce__anlys_wkfl_cnsld_ffss_type__c, arce__Analysis__c,arce__Analysis__r.arce__analysis_customer_relation_type__c from arce__Account_has_Analysis__c limit 1];
        System.assertEquals('BOTTOM_UP', arceVar.arce__anlys_wkfl_cnsld_ffss_type__c, 'error getConsolidatedTypeTest');
        Test.stopTest();
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Testing NEW in Arc_Gen_GenericUtilities.getRecordTypeLimExp
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-11-04
    *--------------------------------------------------------------------------------
    **/
    @isTest
    global static void getRecordTypeLimExpTest() {
        Test.startTest();
        final Id recordType = Arc_Gen_GenericUtilities.getRecType('arce__limits_exposures__c', 'Default');
        final Id recordTypeLim = Arc_Gen_GenericUtilities.getRecordTypeLimExp('Default');
        System.assertEquals(recordType, recordTypeLim, 'error getRecordType');
        Test.stopTest();
    }
}