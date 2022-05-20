/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_GetPermissions_Locator_Test
* @Author   saimassimilianno.jordana.contractor@bbva.com
* @Date     Created: 26/11/2021
* @Group    ARCE
* -----------------------------------------------------------------------------------------------
* @Description Class "Arc_Gen_GetPermissions_Locator_Test"
* -----------------------------------------------------------------------------------------------
* @Changes
*
* |2021-11-26 saimassimilianno.jordana.contractor@bbva.com
*             Class creation
* -----------------------------------------------------------------------------------------------
*/
@isTest
public class Arc_Gen_GetPermissions_Locator_Test {

    /**
    * @Description: String with value "accNumber"
    */
    private static String accNumber = 'CAONlXcCA_uxyJ402AA_xw';

    /**
    *-------------------------------------------------------------------------------
    * @Description Test setup
    *--------------------------------------------------------------------------------
    * @ Author saimassimilianno.jordana.contractor@bbva.com
    * @ Date 2021-11-26
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
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Test Arc_Gen_ServiceAndSaveResponse
    *--------------------------------------------------------------------------------
    * @ Author saimassimilianno.jordana.contractor@bbva.com
    * @ Date 2021-11-26
    *--------------------------------------------------------------------------------
    **/
    @isTest
    public static void getPermissionToEditTest() {
        final Id ahaId = [Select id from arce__Account_has_Analysis__c LIMIT 1].id;
        Test.startTest();
        final Boolean tuAssert = Arc_Gen_GetPermissions_Locator.getPermissionToEdit(ahaId);
        System.assert(tuAssert, 'Error getting permissions');
        Test.stopTest();
    }
}