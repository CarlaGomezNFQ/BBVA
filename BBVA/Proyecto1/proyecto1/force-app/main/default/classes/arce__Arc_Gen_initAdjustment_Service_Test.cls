/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_initAdjustment_Service_Test
* @Author   saimassimilianno.jordana.contractor@bbva.com
* @Date     Created: 2021-03-15
* @Group    ARCE
* ------------------------------------------------------------------------------------------------
* @Description test class for Arc_Gen_initAdjustment_Service_Test
* ------------------------------------------------------------------------------------------------
* @Changes
*
* |2020-07-14 saimassimilianno.jordana.contractor@bbva.com
*             Test Class creation.
* |2020-05-13 saimassimilianno.jordana.contractor@bbva.com
*             Add label for forzaje001.
* |2020-05-13 saimassimilianno.jordana.contractor@bbva.com
*             isEspClientTest, getRtngIdTest meth0ds added.
* ------------------------------------------------------------------------------------------------
*/
@isTest
public with sharing class Arc_Gen_initAdjustment_Service_Test {
    @TestSetup
    static void testSetup() {
        final Account acc = new Account();
        acc.Name = 'TestAcc';
        acc.AccountNumber = 'CAONlXcCA_uxyJ402AA_xw';
        insert acc;
        final arce__Analysis__c analisis = Arc_Gen_Testing_Util.createAnalisis();
        analisis.arce__anlys_wkfl_sub_process_type__c = '4';
        analisis.arce__rating_prerating_type__c = 'Prerating';
        insert analisis;
        final arce__Account_has_Analysis__c aha = Arc_Gen_Testing_Util.createAccountHasAnalisis(analisis.Id);
        aha.arce__Customer__c = acc.id;
        aha.arce__InReview__c = true;
        insert aha;

        final arce__rating__c emptyRating = new arce__rating__c();
        insert emptyRating;

        final arce__Financial_Statements__c ffss = new arce__Financial_Statements__c(arce__financial_statement_id__c = aha.name, arce__rating_id__c = emptyRating.Id);
        insert ffss;
    }

    /**
    * @description analysisSummarytestGeo method test
    * @author saimassimilianno.jordana.contractor@bbva.com | 15-03-2021
    **/
    @isTest
    public static void riskAssRatingIdTest() {

        final String ahasId = [SELECT Id from arce__Account_has_Analysis__c LIMIT 1].Id;
        final arce__Account_has_Analysis__c ahas = arce.Arc_Gen_AccHasAnalysis_Data.getAccHasAnalysis(new List<String>{ahasId}).get(0);

        final arce.Arc_Gen_ServiceAndSaveResponse serviceRes = Arc_Gen_initAdjustment_Service.riskAssRatingId(ahas);
        final String ratingId = Arc_Gen_initAdjustment_Service.getIdFromHeader(serviceRes);
        System.assertEquals('804', ratingId, 'THERE IS AN ERROR ON riskAssRatingIdTest');

    }

    /**
    * @description getRespAndRefresh method test
    * @author saimassimilianno.jordana.contractor@bbva.com | 24-03-2021
    **/
    @isTest
    public static void getRespAndRefreshTest() {
        Arc_Gen_initAdjustment_Service.AdjustResponse response = new Arc_Gen_initAdjustment_Service.AdjustResponse();
        final arce.Arc_Gen_ServiceAndSaveResponse serAndSave = new arce.Arc_Gen_ServiceAndSaveResponse();
        serAndSave.saveMessage = 'Save Error';
        serAndSave.serviceCode = '400';
        serAndSave.serviceMessage = 'Call Error';
        response = Arc_Gen_initAdjustment_Service.getRespAndRefresh(response,serAndSave,true);
        System.assertEquals(response.serviceCode, serAndSave.serviceCode, 'THERE IS AN ERROR ON getRespAndRefreshTest');

    }

    /**
    * @description getRespAndRefresh method test
    * @author saimassimilianno.jordana.contractor@bbva.com | 24-03-2021
    **/
    @isTest
    public static void noEspClientInfoTest() {
        final arce__Account_has_Analysis__c ahas = [SELECT Id from arce__Account_has_Analysis__c LIMIT 1];
        final arce__Financial_Statements__c ffss = [SELECT Id from arce__Financial_Statements__c LIMIT 1];
        ahas.arce__ffss_for_rating_id__c = ffss.id;
        ahas.arce__IRP_Workflow__c = System.Label.Arc_Gen_NewRaipAdjustmentApi;
        update ahas;
        final Arc_Gen_initAdjustment_Service.AdjustResponse response =  Arc_Gen_initAdjustment_Controller.clientInfo((String)ahas.Id);
        System.assert(response.saveStatus, 'There is an Error in overrClientInfoTest method.');
    }

    /**
    * @description getRespAndRefresh method test
    * @author saimassimilianno.jordana.contractor@bbva.com | 24-03-2021
    **/
    @isTest
    public static void overrClientInfoTest() {
        final arce__Account_has_Analysis__c ahas = [SELECT Id from arce__Account_has_Analysis__c LIMIT 1];
        final arce__Financial_Statements__c ffss = [SELECT Id from arce__Financial_Statements__c LIMIT 1];
        ahas.arce__ffss_for_rating_id__c = ffss.id;
        ahas.arce__IRP_Workflow__c = System.Label.Arc_Gen_NewRaipOverrideApi;
        update ahas;
        final Arc_Gen_initAdjustment_Service.AdjustResponse response =  Arc_Gen_initAdjustment_Controller.clientInfo((String)ahas.Id);
        System.assert(response.saveStatus, 'There is an Error in overrClientInfoTest method.');
    }

    /**
    * @description isESPClient method test
    * @author saimassimilianno.jordana.contractor@bbva.com | 24-03-2021
    **/
    @isTest
    public static void isEspClientTest() {
        final arce__Account_has_Analysis__c ahas = [SELECT Id from arce__Account_has_Analysis__c LIMIT 1];
        final arce__Financial_Statements__c ffss = [SELECT Id from arce__Financial_Statements__c LIMIT 1];
        ahas.arce__ffss_for_rating_id__c = ffss.id;
        ahas.arce__IRP_Workflow__c = System.Label.Arc_Gen_NewRaipOverrideApi;
        update ahas;
        final arce.Arc_Gen_ServiceAndSaveResponse response =  Arc_Gen_initAdjustment_Controller.isESPClient(ahas);
        System.assert(!Boolean.valueOf(response.saveStatus), 'There is an Error in isEspClientTest method.');
    }

    /**
    * @description getRtngIdRiskAss method test
    * @author saimassimilianno.jordana.contractor@bbva.com | 24-03-2021
    **/
    @isTest
    public static void getRtngIdTest() {
        final arce__Account_has_Analysis__c ahas = [SELECT Id from arce__Account_has_Analysis__c LIMIT 1];
        final arce__Financial_Statements__c ffss = [SELECT Id from arce__Financial_Statements__c LIMIT 1];
        ahas.arce__ffss_for_rating_id__c = ffss.id;
        ahas.arce__IRP_Workflow__c = System.Label.Arc_Gen_NewRaipOverrideApi;
        update ahas;
        final Arc_Gen_initAdjustment_Service.AdjustResponse response =  Arc_Gen_initAdjustment_Controller.getRtngIdRiskAss(ahas.id);
        System.assert(response.saveStatus, 'There is an Error in getRtngIdTest method.');
    }
}