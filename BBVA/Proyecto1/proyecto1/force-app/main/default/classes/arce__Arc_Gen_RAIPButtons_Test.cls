/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_RAIPButtons_Test
* @Author   Sai Jordana - saimassimilianno.jordana.contractor@bbva.com / BBVA ARCE
* @Date     Created: 29/10/2020
* @Group    ARCE
* -----------------------------------------------------------------------------------------------
* @Description test for method class Arc_Gen_RAIPButtons.
* -----------------------------------------------------------------------------------------------
* @Changes
*
* |29-10-2020 Sai Jordana
*             Class creation.
*/
@isTest
public class Arc_Gen_RAIPButtons_Test {
    /**
    * --------------------------------------------------------------------------------------
    * @Description Setup method for Arc_Gen_StatusButtons_Test
    * --------------------------------------------------------------------------------------
    * @Author   Sai Jordana - saimassimilianno.jordana.contractor@bbva.com / BBVA ARCE
    * @Date     Created: 29/10/2020
    * @param void
    * @return void
    * @example Arc_Gen_RAIPButtons_Test.setup()
    * --------------------------------------------------------------------------------------
    **/
    @testSetup
    public static void setup() {
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
    * @Description Test method to Arc_Gen_RAIPButtons
    * --------------------------------------------------------------------------------------
    * @Author   Sai Jordana - saimassimilianno.jordana.contractor@bbva.com / BBVA ARCE
    * @Date     Created: 29/10/2020
    * @param void
    * @return void
    * @example Arc_Gen_RAIPButtons_Test.getDynamicButtonStatusTest()
    * --------------------------------------------------------------------------------------
    **/
    @isTest
    public static void getDynamicButtonStatusTest() {
        final arce__Account_has_Analysis__c arceVar = [Select Id from arce__Account_has_Analysis__c limit 1];
        final Arc_Gen_RAIPButtons clase = new Arc_Gen_RAIPButtons();
        Test.startTest();
        final Set<String> ltsValues = clase.getDynamicButtonStatus(arceVar.Id, 'arce__Analysis__c');
        System.assert(ltsValues.isEmpty(), 'The result is empty');
        Test.stopTest();
    }
}