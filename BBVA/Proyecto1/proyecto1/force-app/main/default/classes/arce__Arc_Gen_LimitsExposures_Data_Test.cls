/*------------------------------------------------------------------
*Author:        bbva.com developers
*Project:      	ARCE - BBVA Bancomer
*Description:   Test class for Arc_Gen_LimitsExposures_Data
*_______________________________________________________________________________________
*Versión    Date           	Author                                Description
*1.0        14/09/2020      ARCE's TEAM                           Created.
*1.1        08/06/2021      juanignacio.hita.contractor@bbva.com  Modified getExposureDatafromIdsTest method
-----------------------------------------------------------------------------------------*/
@isTest
public with sharing class  Arc_Gen_LimitsExposures_Data_Test {
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

        final arce__limits_exposures__c limitExp = new arce__limits_exposures__c();
        final arce__limits_typology__c tipology = new arce__limits_typology__c();
        tipology.arce__Typology_Order__c = 2;
        insert tipology;
        limitExp.arce__account_has_analysis_id__c = aha.id;
        limitExp.arce__limits_typology_id__c = tipology.id;
        insert limitExp;

        final Product2 product = new Product2();
        product.name = 'Test';
        insert product;
        limitExp.arce__Product_id__c = product.id;
        final List<arce__limits_exposures__c> lstLimits = new List<arce__limits_exposures__c>();
        lstLimits.add(limitExp);
        Arc_Gen_LimitsExposures_Data.insertExposureData(lstLimits);
        Arc_Gen_LimitsExposures_Data.updateExposureData(lstLimits);

        final arce__limits_exposures__c limitExp2 = new arce__limits_exposures__c();
        final arce__limits_typology__c tipology2 = new arce__limits_typology__c();
        tipology.arce__Typology_Order__c = 8;
        insert tipology2;
        limitExp2.arce__account_has_analysis_id__c = aha.id;
        limitExp2.arce__limits_typology_id__c = tipology2.id;
        insert limitExp2;

        limitExp2.arce__Product_id__c = product.id;
        limitExp2.arce__limits_exposures_parent_id__c = limitexp.id;
        final List<arce__limits_exposures__c> lstLimits2 = new List<arce__limits_exposures__c>();
        final arce__limits_exposures__c limitExp3 = new arce__limits_exposures__c();
        limitExp3.arce__Product_id__c = product.id;
        limitExp3.arce__account_has_analysis_id__c = aha.id;
        limitExp3.arce__limits_typology_id__c = null;
        insert limitExp3;

        lstLimits2.add(limitExp2);
        lstLimits2.add(limitExp3);
        Arc_Gen_LimitsExposures_Data.insertExposureData(lstLimits2);

    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Testing NEW in Arc_Gen_LimitsExposures_Data.conRecord2Delete
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-09-14
    *--------------------------------------------------------------------------------
    **/
    @isTest
    public static void conRecord2DeleteTest() {
        Test.startTest();
        final arce__limits_exposures__c limitExp = [Select Id from arce__limits_exposures__c limit 1];
        final List<arce__limits_exposures__c> resultNew = Arc_Gen_LimitsExposures_Data.conRecord2Delete(limitExp.id);
        System.assertEquals(limitExp.Id, resultNew[0].Id, 'Error conRecord2Delete_Test');
        Test.stopTest();
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Testing NEW in Arc_Gen_LimitsExposures_Data.tipologyL1, L2 y Modailityfull
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-09-14
    *--------------------------------------------------------------------------------
    **/
    @isTest
    public static void tipologyL1Test() {
        Test.startTest();
        final arce__Account_has_Analysis__c aha = [Select Id,arce__Analysis__c,arce__Analysis__r.arce__analysis_customer_relation_type__c from arce__Account_has_Analysis__c limit 1];
        final arce__limits_exposures__c limitexp = [Select id from arce__limits_exposures__c limit  1];
        final arce__limits_exposures__c[] resultNew = Arc_Gen_LimitsExposures_Data.tipologyL1(aha.id);
        System.assertEquals(limitexp.Id, resultNew[0].Id, 'Error tipologyL1_Test');
        Test.stopTest();
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Testing NEW in Arc_Gen_LimitsExposures_Data.tipologyL1, L2 y Modailityfull
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-09-14
    *--------------------------------------------------------------------------------
    **/
    @isTest
    public static void tipologyL2Test() {
        Test.startTest();
        final arce__Account_has_Analysis__c aha = [Select Id,arce__Analysis__c,arce__Analysis__r.arce__analysis_customer_relation_type__c from arce__Account_has_Analysis__c limit 1];
        final List<arce__limits_exposures__c> limitexp = [Select id from arce__limits_exposures__c where arce__limits_exposures_parent_id__c != null]; //NOSONAR
        final arce__limits_exposures__c[] resultNew2 = Arc_Gen_LimitsExposures_Data.tipologyL2(aha.id);
        System.assertEquals(limitexp[0].Id, resultNew2[0].Id, 'Error tipologyL2Test');
        Test.stopTest();
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Testing NEW in Arc_Gen_LimitsExposures_Data.tipologyL1, L2 y Modailityfull
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-09-14
    *--------------------------------------------------------------------------------
    **/
    @isTest
    public static void tipologyFullTest() {
        Test.startTest();
        final arce__Account_has_Analysis__c aha = [Select Id,arce__Analysis__c,arce__Analysis__r.arce__analysis_customer_relation_type__c from arce__Account_has_Analysis__c limit 1];
        final List<arce__limits_exposures__c> limitexp = [Select id from arce__limits_exposures__c where arce__limits_typology_id__c = null]; //NOSONAR
        final arce__limits_exposures__c[] resultNew3 = Arc_Gen_LimitsExposures_Data.modalityFull(aha.id);
        System.assertEquals(limitexp[0].Id, resultNew3[0].Id, 'Error tipologyFullTest');
        Test.stopTest();
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Testing NEW in Arc_Gen_LimitsExposures_Data.getExposureDatafromIds
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-09-14
    *--------------------------------------------------------------------------------
    **/
    @isTest
    public static void getExposureDatafromIdsTest() {
        Test.startTest();
        final arce__Account_has_Analysis__c aha = [Select Id,arce__Analysis__c,arce__Analysis__r.arce__analysis_customer_relation_type__c from arce__Account_has_Analysis__c limit 1];
        final arce__limits_exposures__c limitExp4 = new arce__limits_exposures__c();
        limitExp4.arce__account_has_analysis_id__c = aha.id;
        limitExp4.arce__limits_typology_id__c = null;
        insert limitExp4;
        final arce__limits_exposures__c limitexp = [Select id from arce__limits_exposures__c where arce__Product_id__c = null limit 1];
        final Set<Id> recordId = new Set<Id>();
        recordId.add(aha.id);
        final List<arce__limits_exposures__c> resultNew = Arc_Gen_LimitsExposures_Data.getExposureDatafromIds(recordId);
        System.assertEquals(limitexp.Id, resultNew[0].Id, 'Error getExposureDatafromIds_Test');
        Test.stopTest();
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Testing NEW in Arc_Gen_LimitsExposures_Data.getExposurDataMod
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-09-14
    *--------------------------------------------------------------------------------
    **/
    @isTest
    public static void getExposurDataModTest() {
        Test.startTest();
        final arce__Account_has_Analysis__c aha = [Select Id,arce__Analysis__c,arce__Analysis__r.arce__analysis_customer_relation_type__c from arce__Account_has_Analysis__c limit 1];
        final arce__limits_exposures__c limitexp = [Select id from arce__limits_exposures__c limit  1];
        final List<Id> recordId = new List<Id>();
        recordId.add(aha.id);
        final List<arce__limits_exposures__c> resultNew = Arc_Gen_LimitsExposures_Data.getExposurDataMod(recordId);
        System.assertEquals(limitexp.Id, resultNew[0].Id, 'Error getExposurDataMod_Test');
        Test.stopTest();
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Testing NEW in Arc_Gen_LimitsExposures_Data.getLimExpByAccHasMap
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-09-14
    *--------------------------------------------------------------------------------
    **/
    @isTest
    public static void getLimExpByAccHasMapTest() {
        Test.startTest();
        final arce__Account_has_Analysis__c aha = [Select Id,arce__Arc_Gen_EEGRP__c,arce__Analysis__c,arce__Analysis__r.arce__analysis_customer_relation_type__c from arce__Account_has_Analysis__c limit 1];
        final Set<Id> recordId = new Set<Id>();
        recordId.add(aha.id);
        final String modRenVar = 'ren';
        final Map<Id,Map<String,arce__limits_exposures__c>> resultNew = Arc_Gen_LimitsExposures_Data.getLimExpByAccHasMap(recordId, modRenVar);
        final Map<String,arce__limits_exposures__c> expected = new Map<String,arce__limits_exposures__c>();
        System.assertEquals(resultNew.get(aha.id), expected, 'Error getLimExpByAccHasMap_Test');
        Test.stopTest();
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Testing NEW in Arc_Gen_LimitsExposures_Data.getMapExposureDataAha
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-09-14
    *--------------------------------------------------------------------------------
    **/
    @isTest
    public static void getMapExposureDataAhaTest() {
        Test.startTest();
        final arce__Account_has_Analysis__c aha = [Select Id,arce__Arc_Gen_EEGRP__c,arce__Analysis__c,arce__Analysis__r.arce__analysis_customer_relation_type__c from arce__Account_has_Analysis__c limit 1];
        final arce__limits_exposures__c limitexp = [Select id, arce__Product_id__c,arce__limits_typology_id__c  from arce__limits_exposures__c limit  1];
        final List<Id> recordId = new List<Id>();
        recordId.add(limitexp.id);
        final Map<Id, arce__limits_exposures__c> resultNew = Arc_Gen_LimitsExposures_Data.getMapExposureDataAha(aha.id, recordId);
        System.assertEquals(resultNew.get(limitexp.id).id, limitexp.id, 'Error getMapExposureDataAha_Test');
        Test.stopTest();
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Testing NEW in Arc_Gen_LimitsExposures_Data.getLabels
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-09-14
    *--------------------------------------------------------------------------------
    **/
    @isTest
    public static void getLabelsTest() {
        Test.startTest();
        final List<String> fields = new List<String>();
        fields.add('arce__Product_id__c');
        final List<String> resultNew = Arc_Gen_LimitsExposures_Data.getLabels(fields);
        System.assertEquals(resultNew[0], 'Product', 'Error getLabels_Test');
        Test.stopTest();
    }
}