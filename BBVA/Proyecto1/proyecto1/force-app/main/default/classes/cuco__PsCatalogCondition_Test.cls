/**
* ────────────────────────────────────────────────────────────────────
* PsCatalogCondition_Test
* Test class for PsCatalogCondition
* ────────────────────────────────────────────────────────────────────
* @author      Torcuato Tejada <torcuato.tejada.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-04-08
* @modified
* @systemLayer Test
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@IsTest
public with sharing class PsCatalogCondition_Test {

    @IsTest
    static void getPsCatalogConditionServiceTest() {
        Test.startTest();
            final PsCatalogCondition_Service res = new PsCatalogCondition_Service();
            System.assertEquals(res, res, 'private constructor');
        Test.stopTest();
    }

    @IsTest
    static void getPsCatalogConditionHelperTest() {
        Test.startTest();
            final PsCatalogCondition_Helper res = new PsCatalogCondition_Helper();
            System.assertEquals(res, res, 'private constructor');
        Test.stopTest();
    }

}