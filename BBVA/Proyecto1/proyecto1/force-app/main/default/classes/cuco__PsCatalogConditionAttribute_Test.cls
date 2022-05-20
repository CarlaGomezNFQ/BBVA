/**
* ────────────────────────────────────────────────────────────────────
* PsCatalogConditionAttribute_Test
* Test class for PsCatalogConditionAttribute
* ────────────────────────────────────────────────────────────────────
* @author      Torcuato Tejada <torcuato.tejada.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-04  -08
* @modified
* @systemLayer Test
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@IsTest
public with sharing class PsCatalogConditionAttribute_Test {

    @IsTest
    static void getPsCatalogConditionAttributeServiceTest() {
        Test.startTest();
            final PsCatalogConditionAttribute_Service res = new PsCatalogConditionAttribute_Service();
            System.assertEquals(res, res, 'private constructor');
        Test.stopTest();
    }

    @IsTest
    static void getPCatalogConditionAttributeHelperTest() {
        Test.startTest();
            final PsCatalogConditionAttribute_Helper res = new PsCatalogConditionAttribute_Helper();
            System.assertEquals(res, res, 'private constructor');
        Test.stopTest();
    }
}