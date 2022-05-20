/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_StatusButtons_Test
* @ Author jorge.diaz-blanco.contactor@bbva.com (Axpe Consulting)
* @ Date 2020-10-22
* @Group    ARCE
* -----------------------------------------------------------------------------------------------
* @Description test for method class Arc_Gen_StatusButtons.
* -----------------------------------------------------------------------------------------------
*/
@isTest
public class Arc_Gen_StatusButtons_Test {
    /**
    *-------------------------------------------------------------------------------
    * @Description Test setup
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-10-22
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
        insert aha;
    }
    /**
    * --------------------------------------------------------------------------------------
    * @Description Test method to Arc_Gen_StatusButtons
    * --------------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-10-22
    * @param void
    * @return void
    * @example Arc_Gen_StatusButtons.getDynamicButtonStatusTest()
    * --------------------------------------------------------------------------------------
    **/
    @isTest static void getDynamicButtonStatusTest() {
        final arce__Account_has_Analysis__c arceVar = [Select Id from arce__Account_has_Analysis__c limit 1];
        final arce.Arc_Gen_StatusButtons clase = new arce.Arc_Gen_StatusButtons();
        Test.startTest();
        final Set<String> ltsValues = clase.getDynamicButtonStatus(arceVar.Id, 'arce__Analysis__c');
        System.assert(ltsValues.isEmpty(), 'The result is empty');
        Test.stopTest();
    }
}