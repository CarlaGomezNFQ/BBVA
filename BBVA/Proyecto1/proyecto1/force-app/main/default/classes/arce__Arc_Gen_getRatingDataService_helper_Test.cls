/*------------------------------------------------------------------
*Author:        bbva.com developers
*Project:      	ARCE - BBVA Bancomer
*Description:   Test class for Arc_Gen_RatingGlobal_helper
*_______________________________________________________________________________________
*Versión    Date           	Author                              Description
*1.0        14/09/2020      ARCE's TEAM                         Created.
*2.0        04/11/2020      ARCE's TEAM                         Moved to dependencies package
*2.1        12/03/2021      eduardoefrain.hernandez.contractor@bbva.com  Add arce__rating_modifier_adj_type__c field in rating variable init
*2.2        06/05/2021      saimassimilianno.jordana.contractor@bbva.com add arce__IRP_Workflow__c field in processResponseTest meth0d.
*2.3        26/08/2021      saimassimilianno.jordana.contractor@bbva.com arce__RAR_rating_tool_id__c field added to all Ahas SOQL.
-----------------------------------------------------------------------------------------*/
@isTest
global with sharing class Arc_Gen_getRatingDataService_helper_Test {
    /**
    *-------------------------------------------------------------------------------
    * @Description Test setup for methods
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 14-09-2020
    *--------------------------------------------------------------------------------
    **/
    @TestSetup
    static void testSetup() {
        final arce__rating__c rating = new arce__rating__c();
        rating.arce__rating_calculation_type__c = '1';
        insert rating;
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Testing Arc_Gen_RatingGlobal_helper.getMapFromList
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 14-09-2020
    *--------------------------------------------------------------------------------
    **/
    @isTest
    global static void getMapFromListTest() {
        Test.startTest();
        final List<Object> ratings = new List<Object>();
        final String rating = '{"defaultProbability":1.5, "longScaleValue":"BBB-2", "ratingType":{"id":"ANCHOR"}, "score":3, "shortScaleValue":"AAA", "tool":{"id":"00110008001200010005"}}';
        ratings.add(JSON.deserializeUntyped(rating));
        final String typeratings = 'ANCHOR';
        final Map<String, Object> response = Arc_Gen_RatingGlobal_helper.getMapFromList(ratings, typeratings);
        System.assertEquals(ratings[0], response, 'Error getMapFromListTest');
        Test.stopTest();
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Testing Arc_Gen_RatingGlobal_helper.RatingParameters
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 14-09-2020
    *--------------------------------------------------------------------------------
    **/
    @isTest
    global static void createRatingParameters() {
        Test.startTest();
        final Arc_Gen_RatingGlobal_helper.RatingParameters ratingParams = new Arc_Gen_RatingGlobal_helper.RatingParameters();
        ratingParams.subEvent = '';
        ratingParams.ratingId = '';
        ratingParams.riskAssessmentId = '';
        ratingParams.participantId = '';
        ratingParams.ffssId = '';
        ratingParams.participationType = '';
        ratingParams.businessAgentId = '';
        ratingParams.bankId = '';
        ratingParams.branchId = '';
        ratingParams.branchLevel = '';
        ratingParams.eventType = '';
        System.assertEquals('', ratingParams.bankId, 'Error createRatingParameters at the method: createRatingParameters');
        Test.stopTest();
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Testing Arc_Gen_RatingGlobal_helper.processResponse
    *--------------------------------------------------------------------------------
    * @ Author saimassimilianno.jordana.contractor@bbva.com
    * @ Date 30-10-2020
    *--------------------------------------------------------------------------------
    **/
    @isTest
    global static void processResponseTest() {
        Arc_Gen_getIASOResponse.serviceResponse response = new Arc_Gen_getIASOResponse.serviceResponse();
        final Arc_Gen_RatingGlobal_data locator = new Arc_Gen_RatingGlobal_data();
        Arc_Gen_ServiceAndSaveResponse servResp = new Arc_Gen_ServiceAndSaveResponse();
        final Account acc = Arc_UtilitiesToTest_tst.crearCuenta('TestAcc', null, null, 'CAONlXcCA_uxyJ402AA_xw');
        insert acc;
        final arce__Analysis__c analisis = Arc_UtilitiesToTest_tst.crearArceAnalysis('TestAna', 'Arce', acc.id);
        analisis.arce__analysis_customer_relation_type__c = '01';
        insert analisis;
        final arce__rating__c rating = Arc_UtilitiesToTest_tst.crearRating(null);
        insert rating;
        final arce__Sector__c sector = Arc_UtilitiesToTest_tst.crearSector('g-01', '100', 'g-01', null);
        insert sector;
        final arce__Account_has_Analysis__c aha = Arc_UtilitiesToTest_tst.crearAccHasAnalysis(sector.Id, analisis.Id, acc.id, 'g-01');
        aha.arce__anlys_wkfl_cnsld_ffss_type__c = '1';
        insert aha;
        final arce__Financial_Statements__c ffss = Arc_UtilitiesToTest_tst.crearFinStatement(acc.id, aha.id, rating.Id, null);
        insert ffss;
        final List<arce__Financial_Statements__c> validFinancialSt = new List<arce__Financial_Statements__c>();
        validFinancialSt.add(ffss);
        aha.arce__ffss_for_rating_id__c = ffss.id;
        aha.arce__financial_statement_id__c = ffss.id;
        aha.arce__anlys_wkfl_cnsld_ffss_type__c = '1';
        update aha;

        Test.startTest();
        final arce__Account_has_Analysis__c newAha = [Select id, Name, arce__CustomAccountID__c, arce__Analysis__r.arce__anlys_wkfl_sub_process_type__c, arce__Analysis__r.arce__analysis_customer_relation_type__c,arce__anlys_wkfl_cnsld_ffss_type__c, arce__Analysis__r.OwnerId, arce__ffss_for_rating_id__r.arce__financial_statement_id__c, arce__ffss_for_rating_id__r.arce__rating_id__c, arce__Analysis__c, arce__Customer__c, arce__group_asset_header_type__c, arce__InReview__c, arce__ffss_for_rating_id__c, arce__IRP_Workflow__c, arce__RAR_rating_tool_id__c
                                                FROM arce__Account_has_Analysis__c
                                                where id = :aha.Id];
        final Arc_Gen_RatingGlobal_helper.HelperParameters helpWrapper = new Arc_Gen_RatingGlobal_helper.HelperParameters(newAha, null, 'OVERRIDE');
        final String parameters = Arc_Gen_RatingGlobal_helper.setServiceParameters(helpWrapper);
        final String serviceName = 'ratingEngineForTest';
        response = locator.callRatingService(parameters, serviceName);
        servResp = Arc_Gen_RatingGlobal_helper.processResponse(response, helpWrapper);
        System.assertEquals(servResp.serviceCode, '200', 'There is an Error in this Method: processResponseTest');
        Test.stopTest();
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Testing Arc_Gen_RatingGlobal_helper.processSuccess
    *--------------------------------------------------------------------------------
    * @ Author saimassimilianno.jordana.contractor@bbva.com
    * @ Date 30-10-2020
    *--------------------------------------------------------------------------------
    **/
    @isTest
    global static void processSuccessTest() {
        final Account acc = Arc_UtilitiesToTest_tst.crearCuenta('TestAcc', null, null, 'CAONlXcCA_uxyJ402AA_xw');
        insert acc;
        final arce__Analysis__c analisis = Arc_UtilitiesToTest_tst.crearArceAnalysis('TestAna', 'Arce', acc.id);
        insert analisis;
        final arce__rating__c rating = Arc_UtilitiesToTest_tst.crearRating(null);
        insert rating;
        final List<arce__Financial_Statements__c> validFinancialSt = new List<arce__Financial_Statements__c>();
        final arce__Sector__c sector = Arc_UtilitiesToTest_tst.crearSector('g-01', '100', 'g-01', null);
        insert sector;
        final arce__Account_has_Analysis__c aha = Arc_UtilitiesToTest_tst.crearAccHasAnalysis(sector.Id, analisis.Id, acc.id, 'g-01');
        insert aha;
        final arce__Financial_Statements__c ffss = Arc_UtilitiesToTest_tst.crearFinStatement(acc.id, aha.id, rating.Id, null);
        insert ffss;
        validFinancialSt.add(ffss);
        aha.arce__ffss_for_rating_id__c = ffss.id;
        aha.arce__financial_statement_id__c = ffss.id;
        update aha;
        Test.startTest();
        final arce__Account_has_Analysis__c newAha = [Select id, Name, arce__IRP_Workflow__c, arce__RAR_rating_tool_id__c, arce__CustomAccountID__c, arce__anlys_wkfl_cnsld_ffss_type__c, arce__Analysis__r.arce__anlys_wkfl_sub_process_type__c, arce__Analysis__r.OwnerId, arce__ffss_for_rating_id__r.arce__financial_statement_id__c, arce__ffss_for_rating_id__r.arce__rating_id__c, arce__Analysis__c, arce__Customer__c, arce__group_asset_header_type__c, arce__InReview__c, arce__ffss_for_rating_id__c
                                                FROM arce__Account_has_Analysis__c
                                                where id = :aha.Id];
        final Arc_Gen_RatingGlobal_helper.HelperParameters helpWrapper = new Arc_Gen_RatingGlobal_helper.HelperParameters(newAha, null, Arc_Gen_RatingGlobal_Constants.RATINGCAL);

        final Arc_Gen_ServiceAndSaveResponse toAssert = Arc_Gen_RatingGlobal_helper.calcRating(helpWrapper);
        System.assertEquals(toAssert.serviceCode, '200', 'There is an Error in this Method: processSuccessTest');
        Test.stopTest();
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Testing Arc_Gen_RatingGlobal_helper.updateRatVarOverride
    *--------------------------------------------------------------------------------
    * @ Author saimassimilianno.jordana.contractor@bbva.com
    * @ Date 30-10-2020
    *--------------------------------------------------------------------------------
    **/
    @isTest
    global static void updateRatVarOverrideTest() {
        final Account acc = Arc_UtilitiesToTest_tst.crearCuenta('TestAcc', null, null, 'CAONlXcCA_uxyJ402AA_xw');
        insert acc;

        final arce__Analysis__c analisis = Arc_UtilitiesToTest_tst.crearArceAnalysis('TestAna', 'Arce', acc.id);
        insert analisis;

        arce__rating__c rating = Arc_UtilitiesToTest_tst.crearRating(null);
        insert rating;

        final List<arce__Financial_Statements__c> validFinancialSt = new List<arce__Financial_Statements__c>();

        final arce__Sector__c sector = Arc_UtilitiesToTest_tst.crearSector('g-01', '100', 'g-01', null);
        insert sector;
        final arce__Account_has_Analysis__c aha = Arc_UtilitiesToTest_tst.crearAccHasAnalysis(sector.Id, analisis.Id, acc.id, 'g-01');
        insert aha;

        final arce__Financial_Statements__c ffss = Arc_UtilitiesToTest_tst.crearFinStatement(acc.id, aha.id, rating.Id, null);
        insert ffss;
        validFinancialSt.add(ffss);
        aha.arce__ffss_for_rating_id__c = ffss.id;
        aha.arce__financial_statement_id__c = ffss.id;
        update aha;
        final arce__rating_variables_detail__c ratingvarDet = new arce__rating_variables_detail__c();
        ratingvarDet.arce__account_has_analysis_id__c = aha.Id;
        ratingvarDet.arce__rating_id__c = rating.Id;
        ratingvarDet.arce__rating_modifier_adj_type__c = 'OVERRIDE';
        insert ratingvarDet;

        Test.startTest();
        final List<Object> ratings = new List<Object>();
        final String ratingTest = '{"defaultProbability":1.5,"modifier":{"id":"00110008001200010005","description":"test test"},"description":"test tetst tetst", "longScaleValue":"BBB-2", "ratingType":{"id":"ANCHOR"},"adjustmentType":{"id":"OVERRIDE"}, "score":3, "shortScaleValue":"AAA", "tool":{"id":"00110008001200010005"}}';
        ratings.add(JSON.deserializeUntyped(ratingTest));
        final String typeratings = 'ANCHOR';
        final Map<String, Object> response = Arc_Gen_RatingGlobal_helper.getMapFromList(ratings, typeratings);

        final arce__rating_variables_detail__c toAssert = Arc_Gen_RatingGlobal_helper.updateRatVarOverride(response,aha.Id,rating);
        System.assertEquals(toAssert.arce__rating_modifier_id__c, '00110008001200010005', 'There is an error with this method: updateRatVarOverrideTest');
        Test.stopTest();
    }
}