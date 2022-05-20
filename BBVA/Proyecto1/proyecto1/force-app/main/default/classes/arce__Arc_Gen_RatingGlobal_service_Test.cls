/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_RatingGlobal_service_Test
* @Author   amunguia.contractor@bbva.com
* @Date     Created: 2021-07-22
* @Group    ARCE
* ------------------------------------------------------------------------------------------------
* @Description: Arc_Gen_RatingGlobal_service Test
* ------------------------------------------------------------------------------------------------
* @Changes
*
* |2021-07-22 amunguia.contractor@bbva.com
*              Class creation.
* ------------------------------------------------------------------------------------------------
*/
@isTest
public with sharing class Arc_Gen_RatingGlobal_service_Test {
    /**
    * @description creation of records for the test
    * @author amunguia.contractor@bbva.com | 07-23-2021
    **/
    @TestSetup
    static void makeData(){
        Account acc = new Account();
        acc.Name = 'TestAcc';
        acc.AccountNumber = 'CAONlXcCA_uxyJ402AA_xw';
        insert acc;

        final arce__Analysis__c newArce = Arc_Gen_TestingGlobal_Util.createAnalisis();
        newArce.Name = 'ARCE';
        newArce.arce__Group__c = acc.id;
        newArce.arce__Stage__c = '1';
        newArce.arce__wf_status_id__c = '01';
        newArce.arce__rating_prerating_type__c = Arc_Gen_RatingGlobal_Constants.RATING;
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
        ffss.arce__ffss_valid_for_rating_type__c = '1';
        ffss.arce__ffss_valid_type__c = '1';
        final List<arce__Financial_Statements__c> lstFFSS = new List<arce__Financial_Statements__c>();
        lstFFSS.add(ffss);
        final Arc_Gen_RatingGlobal_data ratingHelper = new Arc_Gen_RatingGlobal_data();
        ratingHelper.updateRecords(lstFFSS);
        newAnalysis.arce__ffss_for_rating_id__c = ffss.id;
        ratingHelper.updateRecord(newAnalysis);
    }
    /**
    * @description callAnchorEngineTest
    * @author amunguia.contractor@bbva.com | 07-23-2021
    **/
    @isTest
    public static void callAnchorEngineTest() {
        arce__Account_has_Analysis__c aha = [SELECT Id FROM arce__Account_has_Analysis__c LIMIT 1];
        Test.startTest();
        Arc_Gen_RatingGlobal_service.AnchorData response = Arc_Gen_RatingGlobal_service.callAnchorEngine(aha.Id);
        Test.stopTest();
        System.debug('amc' + JSON.serialize(response));
        System.assertEquals('BB+', response.anchorRating, 'ERROR  CALL RATING ENGINE');
    }
    /**
    * @description setupRatingTest
    * @author amunguia.contractor@bbva.com | 07-23-2021
    **/
    @isTest
    public static void setupRatingTest() {
        arce__Account_has_Analysis__c aha = [SELECT Id FROM arce__Account_has_Analysis__c LIMIT 1];
        Test.startTest();
        arce.Arc_Gen_ServiceAndSaveResponse response = new arce.Arc_Gen_ServiceAndSaveResponse();
        final arce__Account_has_Analysis__c accHasAnalysis = arce.Arc_Gen_AccHasAnalysis_Data.getAccHasAnalysis(new List<String>{aha.Id})[0];
        response = arce.Arc_Gen_RatingGlobal_service.setupRating(accHasAnalysis, null, arce.Arc_Gen_RatingGlobal_Constants.METHOD_OVERLAY);
        Test.stopTest();
        System.debug('amc' + JSON.serialize(response));
        System.assertEquals('Success', response.serviceMessage, 'ERROR  CALL RATING ENGINE');
    }
    /**
    * @description setupRatingKOTest
    * @author amunguia.contractor@bbva.com | 07-23-2021
    **/
    @isTest
    public static void setupRatingKOTest() {
        arce__Account_has_Analysis__c aha = [SELECT Id FROM arce__Account_has_Analysis__c LIMIT 1];
        arce__Financial_Statements__c ffee = [SELECT Id, arce__ffss_valid_type__c FROM arce__Financial_Statements__c LIMIT 1];
        ffee.arce__ffss_valid_type__c = '2';
        update ffee;
        Test.startTest();
        arce.Arc_Gen_ServiceAndSaveResponse response = new arce.Arc_Gen_ServiceAndSaveResponse();
        final arce__Account_has_Analysis__c accHasAnalysis = arce.Arc_Gen_AccHasAnalysis_Data.getAccHasAnalysis(new List<String>{aha.Id})[0];
        response = arce.Arc_Gen_RatingGlobal_service.setupRating(accHasAnalysis, null, arce.Arc_Gen_RatingGlobal_Constants.METHOD_OVERLAY);
        Test.stopTest();
        System.debug('amc' + JSON.serialize(response));
        System.assertEquals(System.Label.Lc_arce_NoValidFFSS, response.saveMessage, 'ERROR  CALL RATING ENGINE');
    }
}