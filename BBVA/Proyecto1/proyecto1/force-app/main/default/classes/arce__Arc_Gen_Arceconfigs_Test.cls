/*------------------------------------------------------------------
*Author:        bbva.com developers
*Project:      	ARCE - BBVA Bancomer
*Description:   Test class for Arc_Gen_Arceconfigs_locator
*_______________________________________________________________________________________
*Versión    Date           	Author                              Description
*1.0        22/07/2021      ARCE's TEAM                         Created.
-----------------------------------------------------------------------------------------*/
@isTest
global with sharing class Arc_Gen_Arceconfigs_Test {
    /**
    *-------------------------------------------------------------------------------
    * @Description Test Setup
    *--------------------------------------------------------------------------------
    * @ Author juanignacio.hita.contractor@bbva.com
    * @ Date 2021-07-22
    *--------------------------------------------------------------------------------
    **/
    @TestSetup
    static void testSetup() {
        final Account acc = Arc_UtilitiesToTest_tst.crearCuenta('TestAcc', null, null, 'CAONlXcCA_uxyJ402AA_xw');
        insert acc;

        final arce__Analysis__c analisis = Arc_UtilitiesToTest_tst.crearArceAnalysis('TestAna', 'Arce', acc.id);
        final List<arce__Analysis__c> lstAna = new List<arce__Analysis__c>();
        lstAna.add(analisis);
        lstAna[0].arce__anlys_wkfl_sub_process_type__c = '1';
        Arc_Gen_ArceAnalysis_Data.insertArce(lstAna);

        final arce__Account_has_Analysis__c aha = new arce__Account_has_Analysis__c();
        aha.arce__Analysis__c = analisis.id;
        aha.arce__Customer__c = acc.id;
        insert aha;

        final User userAdmin = Arc_UtilitiesToTest_tst.crearUsuario('UserAdmin','System Administrator','');
        userAdmin.federationIdentifier = 'XME';
        insert userAdmin;
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Testing Arc_Gen_Arceconfigs_locator.getCustPermCurrUser
    *--------------------------------------------------------------------------------
    * @ Author juanignacio.hita.contractor@bbva.com
    * @ Date 2021-07-22
    *--------------------------------------------------------------------------------
    **/
    @isTest
    global static void getCustPermCurrUserTest() {
        Test.startTest();
        final User userAdmin = [SELECT Id FROM User LIMIT 1];
        System.runAs(userAdmin) {
            final List<CustomPermission> lstCustPerm = Arc_Gen_Arceconfigs_locator.getCustPermCurrUser(new Set<String>{'Configuration'});
            System.assertEquals(true, lstCustPerm.isEmpty(), 'Error getArceAnalysisData_Test');
        }
        Test.stopTest();
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Testing Arc_Gen_Arceconfigs_locator.getConfigurationInfo
    *--------------------------------------------------------------------------------
    * @ Author juanignacio.hita.contractor@bbva.com
    * @ Date 2021-07-22
    *--------------------------------------------------------------------------------
    **/
    @isTest
    global static void getConfigurationInfoTest() {
        Test.startTest();
        final List<Arce_Config__mdt> lstArceCnf = Arc_Gen_Arceconfigs_locator.getConfigurationInfo('UserInterface');
        System.assertEquals('UserInterface', lstArceCnf[0].DeveloperName, 'Error getArceAnalysisData_Test');
        Test.stopTest();
    }

}