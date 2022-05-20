/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_Overlays_Utils_Test
* @Author   amunguia.contractor@bbva.com
* @Date     Created: 2021-07-21
* @Group    ARCE
* ------------------------------------------------------------------------------------------------
* @Description: Arc_Gen_Overlays_Utils Test
* ------------------------------------------------------------------------------------------------
* @Changes
*
* |2021-07-21 amunguia.contractor@bbva.com
*              Class creation.
* ------------------------------------------------------------------------------------------------
*/
@isTest
public with sharing class Arc_Gen_Overlays_Utils_Test {
    /**
    * @description creation of records for the test
    * @author amunguia.contractor@bbva.com | 07-23-2021
    **/
    @testSetup
    static void setupTest() {
        Account acc = new Account();
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

        final arce__rating__c rating = Arc_Gen_Ratings_Test_Utils.setRating();
        final arce__rating_variables_detail__c variableDetail = Arc_Gen_Ratings_Test_Utils.setRatingVariable(newAnalysis.id, rating.id);
        variableDetail.arce__rating_variable_data_type__c = 'RISK_FACTOR';
        final arce__Financial_Statements__c ffss = Arc_Gen_Ratings_Test_Utils.setFFSS(rating.id, '1');
        ffss.arce__account_has_analysis_id__c = newAnalysis.Id;
        ffss.arce__ffss_valid_for_rating_type__c = '1';
        ffss.arce__ffss_valid_type__c = '1';
        ffss.arce__ffss_submitted_type__c = '1';
        final List<arce__Financial_Statements__c> lstFFSS = new List<arce__Financial_Statements__c>();
        lstFFSS.add(ffss);
        final Arc_Gen_RatingGlobal_data ratingHelper = new Arc_Gen_RatingGlobal_data();
        ratingHelper.updateRecords(lstFFSS);
        newAnalysis.arce__ffss_for_rating_id__c = ffss.id;
        ratingHelper.updateRecord(newAnalysis);

    }

    /**
    * @description getOverlaysByAhaTest
    * @author amunguia.contractor@bbva.com | 07-23-2021
    **/
    @isTest
    static void getOverlaysByAhaTest() {
        final arce__Account_has_Analysis__c aha = [SELECT id FROM arce__Account_has_Analysis__c LIMIT 1];
        Test.startTest();
        final List<arce__Overlay__c> result = Arc_Gen_Overlays_Utils.getOverlaysByAha(new Set<String>{aha.Id});
        Test.stopTest();
        System.assertEquals('OVY - 000100000', result[0].Name, 'Service call must have been successful');
    }

    /**
    * @description createOverlayTest
    * @author amunguia.contractor@bbva.com | 07-23-2021
    **/
    @isTest
    static void createOverlayTest() {
        final arce__Account_has_Analysis__c aha = [SELECT id FROM arce__Account_has_Analysis__c LIMIT 1];
        Test.startTest();
        final arce__Overlay__c result = Arc_Gen_Overlays_Utils.createOverlay(aha.Id);
        Test.stopTest();
        System.assertEquals('1', result.arce__Arc_Gen_Type__c, 'Service call must have been successful');
    }

    /**
    * @description getOverlayMapByAhaTest
    * @author amunguia.contractor@bbva.com | 07-23-2021
    **/
    @isTest
    static void getOverlayMapByAhaTest() {
        final arce__Account_has_Analysis__c aha = [SELECT id FROM arce__Account_has_Analysis__c LIMIT 1];
        Test.startTest();
        Map<Id, List<arce__Overlay__c>> result = Arc_Gen_Overlays_Utils.getOverlayMapByAha(new Set<Id>{aha.Id});
        Test.stopTest();
        System.assertEquals('OVY - 000100000', result.get(aha.Id)[0].Name, 'Service call must have been successful');
    }

    /**
    * @description updateGCPRatingTest
    * @author amunguia.contractor@bbva.com | 07-23-2021
    **/
    @isTest
    static void updateGCPRatingTest() {
        final arce__Account_has_Analysis__c aha = [SELECT id FROM arce__Account_has_Analysis__c LIMIT 1];
        arce__Overlay__c overlayObj = Arc_Gen_Overlays_Utils.getOverlaysByAha(new Set<String>{aha.Id})[0];
        arce__Financial_Statements__c ffee = [SELECT Id, arce__account_has_analysis_id__r.arce__long_rating_value_type__c, arce__account_has_analysis_id__r.arce__short_rating_value_type__c, arce__financial_statement_end_date__c,
                                                arce__total_rating_score_number__c, arce__rar_rating_tool_id__c, arce__rating_id__r.arce__rating_id__c,arce__financial_statement_id__c, arce__rating_id__r.arce__rating_long_value_type__c, arce__rating_id__r.arce__rating_short_value_type__c
                                                FROM arce__Financial_Statements__c LIMIT 1];
        Test.startTest();
        final arce__Overlay__c result = Arc_Gen_Overlays_Utils.updateGCPRating(ffee, overlayObj);
        Test.stopTest();
        System.assertEquals(result.arce__Arc_Gen_Parent_Long_Rating_GCP__c,ffee.arce__account_has_analysis_id__r.arce__long_rating_value_type__c, 'Service call must have been successful');
    }

    /**
    * @description updateOverlayObjectTest
    * @author amunguia.contractor@bbva.com | 07-23-2021
    **/
    @isTest
    static void updateOverlayObjectTest() {
        final arce__Account_has_Analysis__c aha = [SELECT id, arce__Customer__r.AccountNumber FROM arce__Account_has_Analysis__c LIMIT 1];
        arce__Overlay__c overlayObj = Arc_Gen_Overlays_Utils.getOverlaysByAha(new Set<String>{aha.Id})[0];
        Test.startTest();
        Arc_Gen_Overlays_Utils.updateOverlayObject(aha.Id, JSON.serialize(new Set<String>{aha.arce__Customer__r.AccountNumber}),overlayObj);
        Test.stopTest();
        arce__Overlay__c result = Arc_Gen_Overlays_Utils.getOverlaysByAha(new Set<String>{aha.Id})[0];
        System.assert(String.isNotBlank(result.arce__Arc_Gen_GCP_Select_VC__c), 'ERROR OVERLAY UPDATE');
    }
}