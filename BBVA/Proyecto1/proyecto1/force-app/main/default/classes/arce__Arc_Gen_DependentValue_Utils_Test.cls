/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_DependentValue_Utils
* @Author   amunguia.contractor@bbva.com
* @Date     Created: 18/03/2021
* @Group    ARCE
* -----------------------------------------------------------------------------------------------
* @Description Arc_Gen_DependentValue_Utils
* -----------------------------------------------------------------------------------------------
* @Changes
*
* |18-03-2021 amunguia.contractor@bbva.com
*             Class creation.
* -----------------------------------------------------------------------------------------------
*/
@isTest
public with sharing class Arc_Gen_DependentValue_Utils_Test {
    /**
    * @description makeData
    * @author amunguia.contractor@bbva.com | 11-05-2020
    **/
    @TestSetup
    static void testSetup() {
        final Account acc = new Account();
        acc.Name = 'TestAcc';
        acc.AccountNumber = 'CAONlXcCA_uxyJ402AA_xw';
        insert acc;

        final arce__Analysis__c newArce = Arc_Gen_TestingGlobal_Util.createAnalisis();
        newArce.Name = 'ARCE';
        newArce.arce__Group__c = acc.id;
        newArce.arce__Stage__c = '1';
        newArce.arce__wf_status_id__c = '01';
        insert newArce;

        final arce__Account_has_Analysis__c newAnalysis = Arc_Gen_TestingGlobal_Util.createAccountHasAnalisis(newArce.Id);
        newAnalysis.arce__gf_company_economic_actvy_id__c = String.valueOf((Math.random()*10000000).round());
        newAnalysis.arce__Customer__c = acc.id;
        newAnalysis.arce__currency_id__c = 'EUR';

        insert newAnalysis;
        final arce__Overlay__c over = new arce__Overlay__c();
        over.arce__Account_has_AnalysisId__c = newAnalysis.Id;

        insert over;
        final arce__Financial_Statements__c ffss = new arce__Financial_Statements__c();
        ffss.arce__account_has_analysis_id__c = newAnalysis.Id;
        ffss.arce__ffss_valid_for_rating_type__c = '1';
        ffss.arce__ffss_valid_type__c = '1';
        ffss.arce__ffss_submitted_type__c = '1';
        insert ffss;
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Test Arc_Gen_DependentValue_Utils
    *--------------------------------------------------------------------------------
    * @ Author alexander.munguia.contactor@bbva.com
    * @ Date 2021-03-17
    *--------------------------------------------------------------------------------
    **/
    @isTest
    public static void gcpBuilderTest() {
        Test.startTest();
        final dyfr__Dependent_value__c result = Arc_Gen_DependentValue_Utils.gcpBuilder (new arce__Financial_Statements__c(), new arce__Account_has_Analysis__c(), 'ES018255456567');
        System.assertEquals(result.dyfr__Values_control_value__c, 'ES018255456567', 'Error gcpBuilder');
        Test.stopTest();
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Test Arc_Gen_DependentValue_Utils
    *--------------------------------------------------------------------------------
    * @ Author alexander.munguia.contactor@bbva.com
    * @ Date 2021-03-17
    *--------------------------------------------------------------------------------
    **/
    @isTest
    public static void parentBuilderTest() {
        final Account aux = [SELECT Id, Name, AccountNumber FROM Account LIMIT 1];
        final Map<String, String> accountsMap = new Map<String, String>{aux.AccountNumber => aux.Name};
        Test.startTest();
        final List<String> children = new List<String>{'child1', 'CAONlXcCA_uxyJ402AA_xw'};
        final Map<String,List<String>> parentMap = new Map<String,List<String>>{aux.AccountNumber => children};
        final List<dyfr__Dependent_value__c> result = Arc_Gen_DependentValue_Utils.parentBuilder(parentMap, accountsMap);
        System.assertEquals('CAONlXcCA_uxyJ402AA_xw', result[0].dyfr__Values_control_value__c, 'Error parentBuilder');
        Test.stopTest();
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Test Arc_Gen_DependentValue_Utils
    *--------------------------------------------------------------------------------
    * @ Author alexander.munguia.contactor@bbva.com
    * @ Date 2021-03-17
    *--------------------------------------------------------------------------------
    **/
    @isTest
    public static void recalculateRatingTest() {
        final arce__Financial_Statements__c aux = [SELECT Id, arce__total_rating_score_number__c FROM arce__Financial_Statements__c LIMIT 1];
        final arce__Account_has_Analysis__c aha = [SELECT Id FROM arce__Account_has_Analysis__c LIMIT 1];
        Test.startTest();
        dyfr__Dependent_value__c result = Arc_Gen_DependentValue_Utils.recalculateRating(aux, aha, 'ES018255456567');
        System.assertEquals('ES018255456567', result.dyfr__Values_control_value__c, 'Error parentBuilder');
        Test.stopTest();
    }
}