/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_InvocableGroupStructure_Test
* @Author   amunguia.contractor@bbva.com
* @Date     Created: 18/03/2021
* @Group    ARCE
* -----------------------------------------------------------------------------------------------
* @Description Class method for Arc_Gen_InvocableGroupStructure
* -----------------------------------------------------------------------------------------------
* @Changes
*
* |18-03-2021 amunguia.contractor@bbva.com
*             Class creation.
* -----------------------------------------------------------------------------------------------
*/
@isTest
public with sharing class Arc_Gen_InvocableGroupStructure_Test {
    /**
    * @description test method
    * @author amunguia.contractor@bbva.com | 03-18-2021
    **/
    @isTest
    public static void callGroupServicesTest() {
        Test.startTest();
        final Account acc = Arc_UtilitiesToTest_tst.crearCuenta('TestAcc', null, null, 'CAONlXcCA_uxyJ402AA_xw');
        insert acc;
        final arce__Analysis__c analisis = Arc_UtilitiesToTest_tst.crearArceAnalysis('TestAna', 'Arce', acc.id);
        insert analisis;
        final arce__Sector__c sector = Arc_UtilitiesToTest_tst.crearSector('g-01', '100', 'g-01', null);
        insert sector;
        final arce__Account_has_Analysis__c aha = Arc_UtilitiesToTest_tst.crearAccHasAnalysis(sector.Id, analisis.Id, acc.id, 'g-01');
        insert aha;
        Test.stopTest();
        final arce__Overlay__c current = [SELECT Id, arce__Account_has_AnalysisId__c FROM arce__Overlay__c LIMIT 1];
        System.assertEquals(aha.Id, current.arce__Account_has_AnalysisId__c, 'Error callGroupServicesTest');
    }
}