/*------------------------------------------------------------------
*Author:        bbva.com developers
*Project:      	ARCE - BBVA Bancomer
*Description:   Test class for Arc_Gen_ArceAnalysis_Data
*_______________________________________________________________________________________
*Versión    Date           	Author                              Description
*1.0        14/09/2020      ARCE's TEAM                         Created.
*2.0        04/11/2020      ARCE's TEAM                         Moved to dependencies package
-----------------------------------------------------------------------------------------*/
@isTest
global with sharing class Arc_Gen_ArceAnalysis_Data_Test {
    /**
    *-------------------------------------------------------------------------------
    * @Description Test Setup
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
        final List<arce__Analysis__c> lstAna = new List<arce__Analysis__c>();
        lstAna.add(analisis);
        Arc_Gen_ArceAnalysis_Data.insertArce(lstAna);
        lstAna[0].arce__anlys_wkfl_sub_process_type__c = '2';
        Arc_Gen_ArceAnalysis_Data.updateArce(lstAna);
        final arce__Account_has_Analysis__c aha = new arce__Account_has_Analysis__c();
        aha.arce__Analysis__c = analisis.id;
        aha.arce__Customer__c = acc.id;
        insert aha;
        final Map<String, Object> fieldValueMap = new Map<String, Object>();
        fieldValueMap.put('Name', analisis.Name);
        Arc_Gen_ArceAnalysis_Data.changeStatusArce(aha, analisis, '01');
        Arc_Gen_ArceAnalysis_Data.editAnalysisFields(analisis.Id, fieldValueMap);
        new Arc_Gen_ArceAnalysis_Data();
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Testing Arc_Gen_ArceAnalysis_Data.getArceAnalysisData
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-09-14
    *--------------------------------------------------------------------------------
    **/
    @isTest
    global static void getArceAnalysisDataTest() {
        Test.startTest();
        final arce__Analysis__c aha = [Select id from arce__Analysis__c LIMIT 1];
        final List<Id> arceLtsId = new List<Id>();
        arceLtsId.add(aha.id);
        final List<arce__Analysis__c> actual = Arc_Gen_ArceAnalysis_Data.getArceAnalysisData(arceLtsId);
        System.assertEquals(actual[0].Id, aha.id, 'Error getArceAnalysisData_Test');
        Test.stopTest();
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Testing Arc_Gen_ArceAnalysis_Data.getArcesFromAccounts
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-09-14
    *--------------------------------------------------------------------------------
    **/
    @isTest
    global static void getArcesFromAccountsTest() {
        Test.startTest();
        final Account acc = [Select id from Account LIMIT 1];
        final List<Id> accLst = new List<Id>();
        accLst.add(acc.id);
        final List<arce__Analysis__c> actual = Arc_Gen_ArceAnalysis_Data.getArcesFromAccounts(accLst);
        System.assertEquals(actual[0].arce__Group__c, acc.id, 'Error getArcesFromAccounts_Test');
        Test.stopTest();
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Testing Arc_Gen_ArceAnalysis_Data.getGroupId
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-09-14
    *--------------------------------------------------------------------------------
    **/
    @isTest
    global static void getGroupIdTest() {
        Test.startTest();
        final arce__Analysis__c ana = [Select id from arce__Analysis__c LIMIT 1];
        final arce__Analysis__c actual = Arc_Gen_ArceAnalysis_Data.getGroupId(ana.id);
        System.assertEquals(actual.id, ana.id, 'Error getGroupId_Test');
        Test.stopTest();
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Testing Arc_Gen_ArceAnalysis_Data.gerArce
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-09-14
    *--------------------------------------------------------------------------------
    **/
    @isTest
    global static void gerArceTest() {
        Test.startTest();
        final arce__Account_has_Analysis__c aha = [Select id, arce__Analysis__c from arce__Account_has_Analysis__c LIMIT 1];
        final arce__Analysis__c actual = Arc_Gen_ArceAnalysis_Data.gerArce(aha.id);
        System.assertEquals(actual.id, aha.arce__Analysis__c, 'Error gerArce_Test');
        Test.stopTest();
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Testing Arc_Gen_ArceAnalysis_Data.getLatestArceOfType
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-09-14
    *--------------------------------------------------------------------------------
    **/
    @isTest
    global static void getLatestArceOfTypeTest() {
        Test.startTest();
        final Account acc = [Select id from Account LIMIT 1];
        final List<Id> lstId = new List<Id>();
        lstId.add(acc.id);
        final List<arce__Analysis__c> actual = Arc_Gen_ArceAnalysis_Data.getLatestArceOfType(lstId, '2');
        System.assertEquals(actual[0].arce__Group__c, lstId[0], 'Error getLatestArceOfType_Test');
        Test.stopTest();
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Testing Arc_Gen_ArceAnalysis_Data.getArceByRiskAssessm
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-09-14
    *--------------------------------------------------------------------------------
    **/
    @isTest
    global static void getArceByRiskAssessmTest() {
        Test.startTest();
        final arce__Account_has_Analysis__c aha = [Select id, Name, arce__Analysis__c from arce__Account_has_Analysis__c LIMIT 1];
        final List<String> lstStr = new List<String>();
        lstStr.add(aha.Name);
        final List<arce__Analysis__c> actual = Arc_Gen_ArceAnalysis_Data.getArceByRiskAssessm(lstStr);
        System.assertEquals(actual[0].id, aha.arce__Analysis__c, 'Error gerArce_Test');
        Test.stopTest();
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Testing Arc_Gen_ArceAnalysis_Data.getArceAnalysisDataToModification
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-09-14
    *--------------------------------------------------------------------------------
    **/
    @isTest
    global static void getArceAnalysisDataToModificationTest() {
        Test.startTest();
        final arce__Analysis__c aha = [Select id from arce__Analysis__c LIMIT 1];
        final List<String> lstStr = new List<String>();
        lstStr.add(aha.id);
        final List<arce__Analysis__c> actual = Arc_Gen_ArceAnalysis_Data.getArceAnalysisDataToModification(lstStr);
        System.assertEquals(actual[0].id, aha.id, 'Error getArceAnalysisDataToModification_Test');
        Test.stopTest();
    }
}