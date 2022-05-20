/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_AnalysisSummary_Controller_Test
* @Author   BBVA Developers
* @Date     Created: 2020-07-01
* @Group    ARCE
* ------------------------------------------------------------------------------------------------
* @Description test class for Arc_Gen_AnalysisSummary_Controller
* ------------------------------------------------------------------------------------------------
* @Changes
*
* |2020-07-01  BBVA Developers.
*              Test Class creation.
* |2020-07-09  ivan.cons.contractor@bbva.com.
*              Test Class refact.
* |2020-10-20  amunguia.contractor@bbva.com
*              Se actualiza los valores de las picklist al crear arce__Activity_Split__c y Arc_Gen_Testing_Util
* |2021-07-29  saimassimilianno.jordana.contractor@bbva.com
*              callMultitemplateCtrllrTest and callMultitemplateEngineTest modified for 2012 model, and created
*              new methods to increase code coverage (getSttsAndStgTest, checkPmnsOvrlTest, checkPmnsAlonTest).
* |2021-08-02 saimassimilianno.jordana.contractor@bbva.com checkCompletenessCtrlTest modified to work with 2012 model adaptations.
* |2021-11-25 saimassimilianno.jordana.contractor@bbva.com getSttsAndStgTest method name changed.
* ------------------------------------------------------------------------------------------------
*/
@SuppressWarnings('sf:TooManyMethods')
@isTest
public class Arc_Gen_AnalysisSummary_Controller_Test {
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
        final arce__Analysis__c analisis = Arc_Gen_Testing_Util.createAnalisis();
        analisis.arce__anlys_wkfl_sub_process_type__c = '4';
        analisis.arce__rating_prerating_type__c = 'Rating';
        insert analisis;
        final arce__Account_has_Analysis__c aha = Arc_Gen_Testing_Util.createAccountHasAnalisis(analisis.Id);
        aha.arce__Customer__c = acc.id;
        aha.arce__InReview__c = true;
        insert aha;
        final arce__Overlay__c overlay = new arce__Overlay__c();
        overlay.arce__Account_has_AnalysisId__c = aha.Id;
        insert overlay;
        final arce__Activity_Split__c activity = Arc_Gen_Testing_Util.createActivitySplit('C', 'CB','CBA', '1331', '7', 90, '1');
        activity.arce__Account_has_Analysis__c = aha.Id;
        insert activity;
        final List<arce__Geographic_Split__c> geoList = new List<arce__Geographic_Split__c>();
        geoList.add(Arc_Gen_Testing_Util.createGeographicSplit('ES', 40, activity.Id, '1'));
        geoList.add(Arc_Gen_Testing_Util.createGeographicSplit('FR', 40, activity.Id, '1'));
        insert geoList;
        final dyfr__Template__c template = new dyfr__Template__c();
        template.Name = 's-01-100';
        insert template;
        final dyfr__Tab__c tab =new dyfr__Tab__c();
        tab.name = 'Basic Data';
        tab.dyfr__Template__c = template.id;
        tab.dyfr__Tab_Code__c = 'BasicData';
        insert tab;
        final dyfr__Field_Config__c fieldConfig = new dyfr__Field_Config__c();
        fieldConfig.dyfr__Section_name__c = 'CONCENTRATION';
        fieldConfig.dyfr__Map_field__c = 'arce__cust_conc_clients_type__c';
        fieldConfig.dyfr__Label__c = 'Comments';
        fieldConfig.dyfr__Tab__c = tab.id;
        final arce__Modifier__c modifier = new arce__Modifier__c();
        modifier.arce__Account_has_AnalysisId__c = aha.id;
        modifier.arce__Tipo__c = '1';
        insert modifier;
        final arce__rating__c rating = Arc_Gen_Ratings_Test_Utils.setRating();
        final arce__rating_variables_detail__c variableDetail = Arc_Gen_Ratings_Test_Utils.setRatingVariable(aha.id, rating.id);
        variableDetail.arce__rating_variable_data_type__c = 'RISK_FACTOR';
        final arce__Financial_Statements__c ffss = Arc_Gen_Ratings_Test_Utils.setFFSS(rating.id, '1');
        ffss.arce__ffss_valid_for_rating_type__c = '1';
        ffss.arce__ffss_valid_type__c = '1';
        final List<arce__Financial_Statements__c> lstFFSS = new List<arce__Financial_Statements__c>();
        lstFFSS.add(ffss);
        final arce.Arc_Gen_RatingGlobal_data ratingHelper = new arce.Arc_Gen_RatingGlobal_data();
        ratingHelper.updateRecords(lstFFSS);
        aha.arce__ffss_for_rating_id__c = ffss.id;
        ratingHelper.updateRecord(aha);
        new Arc_Gen_SP2_MultiPersistence_Service();
        Test.loadData(dyfr__Template__c.sObjectType, 'Arc_Gen_templates');
        Test.loadData(dyfr__Tab__c.sObjectType, 'Arc_Gen_tabs');
        Test.loadData(dyfr__Field_Config__c.sObjectType, 'Arc_Gen_fieldConfigs');
        Test.loadData(dyfr__Dependent_value__c.sObjectType, 'Arc_Gen_dataValues');
    }
    /**
    * @description analysisSummarytestGeo method test
    * @author amunguia.contractor@bbva.com | 11-05-2020
    **/
    @isTest
    public static void analysisSummarytestGeo() {
        final arce__Account_has_Analysis__c aha = [Select id from arce__Account_has_Analysis__c limit 1];
        final arce__Activity_Split__c activity = [Select id from arce__Activity_Split__c limit 1];
        final String collectionType = 'geographiesChart2019';
        Test.startTest();
        final Arc_Gen_ChartWrapper wrapper = Arc_Gen_AnalysisSummary_Controller.getWrapper(collectionType, activity.Id, aha.Id);
        System.assertEquals(wrapper.JSON_Setup.config.options.title.text, 'Geographic distribution', 'Error analysisSummary_Controller_Test');
        Test.stopTest();
    }

    /**
    * @description analysisSummarytestActties method test
    * @author amunguia.contractor@bbva.com | 11-05-2020
    **/
    @isTest
    public static void analysisSummarytestActties() {
        final arce__Account_has_Analysis__c aha = [Select id from arce__Account_has_Analysis__c limit 1];
        final arce__Activity_Split__c activity = [Select id from arce__Activity_Split__c limit 1];
        final String collectionType = 'subActivityChart2019';
        Test.startTest();
        final Arc_Gen_ChartWrapper wrapper = Arc_Gen_AnalysisSummary_Controller.getWrapper(collectionType, activity.Id, aha.Id);
        System.assertEquals(wrapper.JSON_Setup.config.options.title.text, 'Subactivity distribution', 'Error analysisSummary_Controller_Test');
        Test.stopTest();
    }

    /**
    * @description checkCompletenessCtrl method test
    * @author amunguia.contractor@bbva.com | 11-05-2020
    **/
    @isTest
    public static void checkCompletenessCtrlTest() {
        final arce__Account_has_Analysis__c aha = [Select id from arce__Account_has_Analysis__c limit 1];
        Test.startTest();
        final List<String> returnList = Arc_Gen_AnalysisSummary_Controller.checkCompletenessCtrl(aha.Id, '2019');
        System.assertEquals(returnList.size(),1, 'Error analysisSummary_Controller_Test');
        Test.stopTest();
    }
    /**
    * @description callAnchorEngine method test
    * @author amunguia.contractor@bbva.com | 11-05-2020
    **/
    @isTest
    public static void callAnchorEngineTest() {
        final arce__Account_has_Analysis__c aha = [Select id from arce__Account_has_Analysis__c limit 1];
        Test.startTest();
            final arce.Arc_Gen_RatingGlobal_service.AnchorData anchorData = Arc_Gen_AnalysisSummary_Controller.callAnchorEngine(aha.Id);
            System.assertEquals('BB+', anchorData.anchorRating, 'Error analysisSummary_Controller_Test');
        Test.stopTest();
    }
    /**
    * @description callMultitemplateCtrllr method test
    * @author amunguia.contractor@bbva.com | 11-05-2020
    **/
    @isTest
    public static void callMultitemplateCtrllrTest() {
        final arce__Account_has_Analysis__c aha = [Select Id from arce__Account_has_Analysis__c limit 1];
        Test.startTest();
            Arc_Gen_AnalysisSummary_Controller.callMultitemplateCtrllr(aha.Id,'2019');
            final List<arce__Activity_Split__c> lstAct = [Select arce__Final_Industry_Risk_DV__c from arce__Activity_Split__c limit 1];
            System.assert(lstAct[0].arce__Final_Industry_Risk_DV__c != '', 'Error callMultitemplateCtrllrTest');
        Test.stopTest();
    }
    /**
    * @description callMultiPersistenceEngine method test
    * @author amunguia.contractor@bbva.com | 11-05-2020
    **/
    @isTest
    public static void callMultitemplateEngineTest() {
        final arce__Account_has_Analysis__c aha = [Select id from arce__Account_has_Analysis__c limit 1];
        Test.startTest();
        try {
            Arc_Gen_AnalysisSummary_Controller.callMultiPersistenceEngine(aha.Id, '2019');
            System.assert(true, 'callMultiPersistenceEngine OK');
        } catch(Arc_Gen_SP2_MultiPersistence_Service.SP2MultitemplateException e) {
            System.assert(e.getMessage().contains('Error Calling MultiTemplate Engine'), 'message=' + e.getMessage());
        }
        Test.stopTest();
    }

    /**
    * @description  checkModifiers method test
    * @author amunguia.contractor@bbva.com | 11-05-2020
    **/
    @isTest
    public static void checkModifiersTest() {
        final arce__Account_has_Analysis__c aha = [Select id from arce__Account_has_Analysis__c limit 1];
        final dyfr__Template__c currentTemplate = [SELECT Id, name FROM dyfr__Template__c  LIMIT 1];
        Test.startTest();
        final List<String> returnList = Arc_Gen_AnalysisSummary_Controller.checkModifiers(aha.Id,currentTemplate.Name);
        System.assertEquals(returnList.size(),1,'Modifier check failed');
        Test.stopTest();
    }

    /**
    * @description callPersistModifiers method test
    * @author amunguia.contractor@bbva.com | 11-05-2020
    **/
    @isTest
    public static void callPersistModifiersTest() {
        final arce__Account_has_Analysis__c aha = [Select id from arce__Account_has_Analysis__c limit 1];
        Test.startTest();
        final arce.Arc_Gen_PersistModifiers_Service.VariablePersistenceResult result = Arc_Gen_AnalysisSummary_Controller.callPersistModifiers(aha.Id, 'persistenceOverlays');
        System.assertEquals(result.serviceCode, '200','Error calling persist modifiers engine');
        Test.stopTest();
    }
    /**
    * @description callPersistModifiers catch method test
    * @author juanpedro.benito.contractor@bbva.com | 02-03-2021
    **/
    @isTest
    public static void callPersistModifiersCatchTest() {
        Test.startTest();
        final arce.Arc_Gen_PersistModifiers_Service.VariablePersistenceResult result = Arc_Gen_AnalysisSummary_Controller.callPersistModifiers(null, 'persistenceOverlays');
        System.assertEquals(result.serviceCode, '403','Error calling catch persist modifiers engine');
        Test.stopTest();
    }
    /**
    * @description callPersistModifiers method test with 1 rating
    * @author amunguia.contractor@bbva.com | 11-05-2020
    **/
    @isTest
    public static void callRatingEngineTest() {
        final arce__Account_has_Analysis__c aha = [Select id from arce__Account_has_Analysis__c limit 1];
        arce__Account_has_Analysis__c accHasAnalysis = arce.Arc_Gen_AccHasAnalysis_Data.getAccHasAnalysis(new List<String>{aha.Id})[0];
        final String serviceMock = '{"data":{"id":"kg001","evaluationDate":"2019-09-12T05:28:19","status":{"id":"VALIDATED"},"calculationType":{"id":"AUTOMATIC"},"isSmallMediumEnterprise":true,"ratings":[{"tool":{"id":"00110008001200010005"},"ratingType":{"id":"FINAL"},"score":3,"defaultProbability":1.5,"shortScaleValue":"AAA","longScaleValue":"BBB-2"},{"tool":{"id":"00110008001200010005"},"ratingType":{"id":"STANDALONE"},"score":3,"defaultProbability":1.5,"shortScaleValue":"AAA","longScaleValue":"BBB-2"}],"adjustments":[{"adjustmentType":{"id":"OVERLAY"},"modifier":{"id":"01","description":"No information added","modifierType":"01","value":"01"},"score":3,"defaultProbability":5.3,"shortScaleValue":"AAA","longScaleValue":"BBB-2"}],"variables":[{"id":"1100","level":"1","parentCode":"0","hasFinalScoreWeight":true,"value":"12","adjustedValue":"3.3","blockType":"QUALITATIVE_BLOCK","score":{"value":"98","adjustedScore":10,"minimumScore":2,"maximumScore":8}}],"controls":[{"id":"InvalidBusinessLogicData","description":"Invalid SME calculation variables","isValid":false}]}}';
        arce.Arc_Gen_RatingGlobal_helper.HelperParameters helperWrapper = new arce.Arc_Gen_RatingGlobal_helper.HelperParameters(accHasAnalysis, null, arce.Arc_Gen_RatingGlobal_Constants.RATINGCAL);
        helperWrapper.setMock('ratingEngine', serviceMock);
        Test.startTest();
        //final arce.Arc_Gen_ServiceAndSaveResponse result = Arc_Gen_AnalysisSummary_Controller.callRatingEngine(aha.id, aha.arce__Customer__c, serviceMock, 'ratingStandalone', null);
        final arce.Arc_Gen_ServiceAndSaveResponse result = arce.Arc_Gen_RatingGlobal_helper.calcRating(helperWrapper);
        System.assertEquals(result.serviceCode, '200','Error callRatingEngineTest');
        Test.stopTest();
    }
    /**
    * @description callPersistModifiers method test with 3 ratings
    * @author jorge.diaz-blanco.contractor@bbva.com | 27-11-2020
    **/
    @isTest
    public static void callRatingEngineTestV3() {
        final arce__Account_has_Analysis__c aha = [Select id from arce__Account_has_Analysis__c limit 1];
        arce__Account_has_Analysis__c accHasAnalysis = arce.Arc_Gen_AccHasAnalysis_Data.getAccHasAnalysis(new List<String>{aha.Id})[0];
        final String serviceMock = '{"data":{"id":"kg001","evaluationDate":"2019-09-12T05:28:19","status":{"id":"VALIDATED"},"calculationType":{"id":"AUTOMATIC"},"isSmallMediumEnterprise":true,"ratings":[{"tool":{"id":"00110008001200010005"},"ratingType":{"id":"FINAL"},"score":3,"defaultProbability":1.5,"shortScaleValue":"AAA","longScaleValue":"BBB-2"},{"tool":{"id":"00110008001200010005"},"ratingType":{"id":"STANDALONE"},"score":3,"defaultProbability":1.5,"shortScaleValue":"AAA","longScaleValue":"BBB-2"}],"adjustments":[{"adjustmentType":{"id":"OVERLAY"},"modifier":{"id":"01","description":"No information added","modifierType":"01","value":"01"},"score":3,"defaultProbability":5.3,"shortScaleValue":"AAA","longScaleValue":"BBB-2"},{"adjustmentType":{"id":"OVERLAY"},"modifier":{"id":"01","description":"No information added","modifierType":"01","value":"01"},"score":3,"defaultProbability":6.3,"shortScaleValue":"AAA","longScaleValue":"BBB-2"},{"adjustmentType":{"id":"OVERLAY"},"modifier":{"id":"01","description":"No information added","modifierType":"01","value":"01"},"score":3,"defaultProbability":6.3,"shortScaleValue":"AAA","longScaleValue":"BBB-2"}],"variables":[{"id":"1100","level":"1","parentCode":"0","hasFinalScoreWeight":true,"value":"12","adjustedValue":"3.3","blockType":"QUALITATIVE_BLOCK","score":{"value":"98","adjustedScore":10,"minimumScore":2,"maximumScore":8}}],"controls":[{"id":"InvalidBusinessLogicData","description":"Invalid SME calculation variables","isValid":false}]}}';
        arce.Arc_Gen_RatingGlobal_helper.HelperParameters helperWrapper = new arce.Arc_Gen_RatingGlobal_helper.HelperParameters(accHasAnalysis, null, arce.Arc_Gen_RatingGlobal_Constants.RATINGCAL);
        helperWrapper.setMock('ratingEngine', serviceMock);
        Test.startTest();
        // final arce.Arc_Gen_ServiceAndSaveResponse result = Arc_Gen_AnalysisSummary_Controller.callRatingEngine(aha.id, aha.arce__Customer__c, serviceMock, 'ratingStandalone', null);
        final arce.Arc_Gen_ServiceAndSaveResponse result = arce.Arc_Gen_RatingGlobal_helper.calcRating(helperWrapper);
        System.assertEquals(result.serviceCode, '200','Error callRatingEngineTestV3');
        Test.stopTest();
    }
    /**
    * @description callPersistModifiers method test with 5 ratings
    * @author jorge.diaz-blanco.contractor@bbva.com  | 27-11-2020
    **/
    @isTest
    public static void callRatingEngineTestV5() {
        final arce__Account_has_Analysis__c aha = [Select id from arce__Account_has_Analysis__c limit 1];
        arce__Account_has_Analysis__c accHasAnalysis = arce.Arc_Gen_AccHasAnalysis_Data.getAccHasAnalysis(new List<String>{aha.Id})[0];
        final String serviceMock = '{"data":{"id":"kg001","evaluationDate":"2019-09-12T05:28:19","status":{"id":"VALIDATED"},"calculationType":{"id":"AUTOMATIC"},"isSmallMediumEnterprise":true,"ratings":[{"tool":{"id":"00110008001200010005"},"ratingType":{"id":"FINAL"},"score":3,"defaultProbability":1.5,"shortScaleValue":"AAA","longScaleValue":"BBB-2"},{"tool":{"id":"00110008001200010005"},"ratingType":{"id":"STANDALONE"},"score":3,"defaultProbability":1.5,"shortScaleValue":"AAA","longScaleValue":"BBB-2"}],"adjustments":[{"adjustmentType":{"id":"OVERLAY"},"modifier":{"id":"01","description":"No information added","modifierType":"01","value":"01"},"score":3,"defaultProbability":5.3,"shortScaleValue":"AAA","longScaleValue":"BBB-2"},{"adjustmentType":{"id":"OVERLAY"},"modifier":{"id":"01","description":"No information added","modifierType":"01","value":"01"},"score":3,"defaultProbability":6.3,"shortScaleValue":"AAA","longScaleValue":"BBB-2"},{"adjustmentType":{"id":"OVERLAY"},"modifier":{"id":"01","description":"No information added","modifierType":"01","value":"01"},"score":3,"defaultProbability":3.3,"shortScaleValue":"AAA","longScaleValue":"BBB-2"},{"adjustmentType":{"id":"OVERLAY"},"modifier":{"id":"01","description":"No information added","modifierType":"01","value":"01"},"score":3,"defaultProbability":2.3,"shortScaleValue":"AAA","longScaleValue":"BBB-2"},{"adjustmentType":{"id":"OVERLAY"},"modifier":{"id":"01","description":"No information added","modifierType":"01","value":"01"},"score":3,"defaultProbability":6.3,"shortScaleValue":"AAA","longScaleValue":"BBB-2"}],"variables":[{"id":"1100","level":"1","parentCode":"0","hasFinalScoreWeight":true,"value":"12","adjustedValue":"3.3","blockType":"QUALITATIVE_BLOCK","score":{"value":"98","adjustedScore":10,"minimumScore":2,"maximumScore":8}}],"controls":[{"id":"InvalidBusinessLogicData","description":"Invalid SME calculation variables","isValid":false}]}}';
        arce.Arc_Gen_RatingGlobal_helper.HelperParameters helperWrapper = new arce.Arc_Gen_RatingGlobal_helper.HelperParameters(accHasAnalysis, null, arce.Arc_Gen_RatingGlobal_Constants.RATINGCAL);
        helperWrapper.setMock('ratingEngine', serviceMock);
        Test.startTest();
        // final arce.Arc_Gen_ServiceAndSaveResponse result = Arc_Gen_AnalysisSummary_Controller.callRatingEngine(aha.id, aha.arce__Customer__c, serviceMock, 'ratingStandalone', null);
        final arce.Arc_Gen_ServiceAndSaveResponse result = arce.Arc_Gen_RatingGlobal_helper.calcRating(helperWrapper);
        System.assertEquals(result.serviceCode, '200','Error callRatingEngineTestV5');
        Test.stopTest();
    }
    /**
    * @description callPersistModifiers method test
    * @author amunguia.contractor@bbva.com | 11-05-2020
    **/
    @isTest
    public static void getCustomerDataTest() {
        final arce__Account_has_Analysis__c aha = [Select id, arce__Analysis__c,arce__CustomAccountID__c,arce__Customer__c from arce__Account_has_Analysis__c limit 1];
        Test.startTest();
        final List<String> result = arce.Arc_Gen_RatingGlobal_data.getCustomerData(aha.id);
        System.assertEquals(result[0], 'TestAcc','Error getCustomerDataTest');
        Test.stopTest();
    }
    /**
    * @description callPersistModifiers method test
    * @author amunguia.contractor@bbva.com | 11-05-2020
    **/
    @isTest
    public static void getAllAnalysisTest() {
        final arce__Account_has_Analysis__c aha = [Select id from arce__Account_has_Analysis__c limit 1];
        Test.startTest();
        final List<Arc_Gen_Account_Has_Analysis_Wrapper> lstAhaWrapper = Arc_Gen_AccHasAnalysis_Data.getAllAnalysis(aha.id);
        System.assertEquals(lstAhaWrapper[0].ahaObj.id, aha.id,'Error getAllAnalysis');
        Test.stopTest();
    }
    /**
    * @description callOverlayRating method test
    * @author juanpedro.benito.contractor@bbva.com | 02-03-2021
    **/
    @isTest
    public static void callOverlayRatingTest() {
        final arce__Account_has_Analysis__c aha = [Select id from arce__Account_has_Analysis__c limit 1];
        Test.startTest();
        final arce.Arc_Gen_ServiceAndSaveResponse result = Arc_Gen_AnalysisSummary_Controller.callOverlayRating(aha.Id);
        System.assertEquals(result.serviceCode, '200','Error calling overlay rating engine');
        Test.stopTest();
    }
    /**
    * @description callOverlayRating catch method test
    * @author juanpedro.benito.contractor@bbva.com | 02-03-2021
    **/
    @isTest
    public static void callOverlayRatingCatchTest() {
        Test.startTest();
        final arce.Arc_Gen_ServiceAndSaveResponse result = Arc_Gen_AnalysisSummary_Controller.callOverlayRating(null);
        System.assertEquals('500', result.serviceCode, 'Error calling catch overlay rating engine');
        Test.stopTest();
    }

    /**
    * @description callRatingEngine method test
    * @author juanpedro.benito.contractor@bbva.com | 02-03-2021
    **/
    @isTest
    public static void callRatingEngineSummTest() {
        final arce__Account_has_Analysis__c aha = [Select id from arce__Account_has_Analysis__c limit 1];
        Test.startTest();
        final arce.Arc_Gen_ServiceAndSaveResponse result = Arc_Gen_AnalysisSummary_Controller.callRatingEngine(aha.Id);
        System.assertEquals(result.serviceCode, '200','Error calling rating engine');
        Test.stopTest();
    }

    /**
    * @description getBSbuttonsPerm method test
    * @author saimassimilianno.jordana.contractor@bbva.com | 26-07-2021
    **/
    @isTest
    public static void getBSbuttonsPermTest() {
        final arce__Account_has_Analysis__c aha = [Select id from arce__Account_has_Analysis__c limit 1];
        Test.startTest();
        final Boolean result = Arc_Gen_AnalysisSummary_Controller.getBSbuttonsPerm(aha.Id);
        System.assert(result, 'Error getting status and stage of analysis');
        Test.stopTest();
    }

    /**
    * @description checkPmnsOvrl method test
    * @author saimassimilianno.jordana.contractor@bbva.com | 26-07-2021
    **/
    @isTest
    public static void checkPmnsOvrlTest() {
        final arce__Account_has_Analysis__c aha = [Select id from arce__Account_has_Analysis__c limit 1];
        Test.startTest();
        final String result = Arc_Gen_AnalysisSummary_Controller.checkPmnsOvrl(aha.Id);
        final Map<String,String> mapResult = (Map<String,String>)JSON.deserialize(result, Map<String,String>.class);
        System.assertEquals(mapResult.get('errorCode'), '200', 'Error getting permission results for Overlay');
        Test.stopTest();
    }

    /**
    * @description checkPmnsOvrl method test
    * @author saimassimilianno.jordana.contractor@bbva.com | 26-07-2021
    **/
    @isTest
    public static void checkPmnsAlonTest() {
        final arce__Account_has_Analysis__c aha = [Select id from arce__Account_has_Analysis__c limit 1];
        Test.startTest();
        final Boolean result = Arc_Gen_AnalysisSummary_Controller.checkPmnsAlon(aha.Id);
        System.assert(result, 'Error getting permission results for Standalone');
        Test.stopTest();
    }

}