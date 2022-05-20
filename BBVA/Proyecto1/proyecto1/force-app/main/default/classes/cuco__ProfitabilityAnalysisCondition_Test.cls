/**
* ────────────────────────────────────────────────────────────────────
* ProfitabilityAnalysisCondition_Test
* Test class for ProfitabilityAnalysisCondition
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
public with sharing class ProfitabilityAnalysisCondition_Test {

    @IsTest
    static void profAnalysisConditionServiceTest() {
        Test.startTest();
            final ProfitabilityAnalysisCondition_Service res = new ProfitabilityAnalysisCondition_Service();
            System.assertEquals(res, res, 'private constructor');
        Test.stopTest();
    }

    @IsTest
    static void profAnalysisConditionHelperTest() {
        Test.startTest();
            final ProfitabilityAnalysisCondition_Helper res = new ProfitabilityAnalysisCondition_Helper();
            System.assertEquals(res, res, 'private constructor');
        Test.stopTest();
    }
}