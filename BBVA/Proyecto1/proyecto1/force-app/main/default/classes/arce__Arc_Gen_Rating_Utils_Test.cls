/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_Rating_Utils_Test
* @Author   amunguia.contractor@bbva.com
* @Date     Created: 13/05/2021
* @Group    ARCE
* -----------------------------------------------------------------------------------------------
* @Description Class method for Arc_Gen_Rating_Utils
* -----------------------------------------------------------------------------------------------
* @Changes
*
* |13-05-2021 amunguia.contractor@bbva.com
*             Class creation.
* -----------------------------------------------------------------------------------------------
*/
@isTest
public with sharing class Arc_Gen_Rating_Utils_Test {
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
        analisis.arce__rating_prerating_type__c = 'Prerating';
        insert analisis;
        final arce__Account_has_Analysis__c aha = Arc_Gen_Testing_Util.createAccountHasAnalisis(analisis.Id);
        aha.arce__Customer__c = acc.id;
        aha.arce__InReview__c = true;
        insert aha;
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
        variableDetail.arce__rating_modifier_adj_type__c = 'OVERRIDE';
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
    * @description calculateParentRatingTest
    * @author amunguia.contractor@bbva.com | 05-11-2021
    **/
    @isTest
    public static void getRatingsTest() {
        final arce__Account_has_Analysis__c aha = [SELECT Id FROM arce__Account_has_Analysis__c LIMIT 1];
        Test.startTest();
        final List<arce__rating_variables_detail__c> response = Arc_Gen_Rating_Utils.getRatingDetByAha(new Set<String>{aha.Id}, new Set<String>{'OVERRIDE'});
        Test.stopTest();
        System.assert(!response.isEmpty(), 'Error getRating');
    }
}