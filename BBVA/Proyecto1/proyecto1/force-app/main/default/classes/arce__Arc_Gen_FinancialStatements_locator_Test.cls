/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_FinancialStatements_locator_Test
* @Author   Sai Jordana - saimassimilianno.jordana.contractor@bbva.com / BBVA ARCE
* @Date     Created: 29/10/2020
* @Group    ARCE
* -----------------------------------------------------------------------------------------------
* @Description test for method class Arc_Gen_FinancialStatements_locator.
* -----------------------------------------------------------------------------------------------
* @Changes
*
* |29-10-2020 Sai Jordana
*             Class creation.
*/
@IsTest
public with sharing class Arc_Gen_FinancialStatements_locator_Test {
    /**
    * --------------------------------------------------------------------------------------
    * @Description Setup method for Arc_Gen_FinancialStatements_locator_Test
    * --------------------------------------------------------------------------------------
    * @Author   Sai Jordana - saimassimilianno.jordana.contractor@bbva.com / BBVA ARCE
    * @Date     Created: 29/10/2020
    * @param void
    * @return void
    * @example Arc_Gen_FinancialStatements_locator_Test.getFSInfoTest()
    * --------------------------------------------------------------------------------------
    **/
    @IsTest
    public static void getFSInfoTest() {
        new Arc_Gen_FinancialStatements_locator();
        final arce__Financial_Statements__c ffSS = new arce__Financial_Statements__c();
        ffSS.Name = 'Test FFSS';
        ffSS.arce__economic_month_info_number__c = 'test month';
        insert ffSS;

        final List<Id> testList = new List<Id>();
        testList.add(ffSS.Id);

        Test.startTest();
        final List<arce__Financial_Statements__c> listToAssert = Arc_Gen_FinancialStatements_locator.getFSInfo(testList);
        System.assertEquals(listToAssert[0].arce__economic_month_info_number__c, 'test month', 'The result is empty');
        Test.stopTest();
    }
    /**
    * --------------------------------------------------------------------------------------
    * @Description Setup method for Arc_Gen_FinancialStatements_locator_Test
    * --------------------------------------------------------------------------------------
    * @Author   Sai Jordana - saimassimilianno.jordana.contractor@bbva.com / BBVA ARCE
    * @Date     Created: 29/10/2020
    * @param void
    * @return void
    * @example Arc_Gen_FinancialStatements_locator_Test.getEmptyFFSSTest()
    * --------------------------------------------------------------------------------------
    * @Changes: |2019-11-05 jorge.diaz-blanco.contactor@bbva.com Validations
    * --------------------------------------------------------------------------------------
    **/
    @IsTest
    public static void getEmptyFFSSTest() {
        final arce__Financial_Statements__c ffSS = Arc_Gen_FinancialStatements_locator.setFFSS();
        Test.startTest();
        final List<arce__Financial_Statements__c> toAssert = Arc_Gen_FinancialStatements_locator.getEmptyFFSS();
        System.assertEquals(ffSS.arce__financial_statement_id__c,toAssert[0].arce__financial_statement_id__c, 'Error getEmptyFFSSTest');
        Test.stopTest();
    }
    /**
    * --------------------------------------------------------------------------------------
    * @Description Setup method for setFFSSWAhasName
    * --------------------------------------------------------------------------------------
    * @Author   Sai Jordana - saimassimilianno.jordana.contractor@bbva.com / BBVA ARCE
    * @Date     Created: 25/02/2021
    * @param void
    * @return void
    * @example Arc_Gen_FinancialStatements_locator_Test.setFFSSWAhasNameTest()
    * --------------------------------------------------------------------------------------
    **/
    @IsTest
    public static void setFFSSNmTest() {
        Test.startTest();
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
        arce__Financial_Statements__c ffsstest = Arc_Gen_FinancialStatements_locator.setFFSSWAhasName(aha.Name);
        System.assertEquals(aha.Name,ffsstest.arce__financial_statement_id__c, 'Error setFFSSNmTest');
        Test.stopTest();
    }
}