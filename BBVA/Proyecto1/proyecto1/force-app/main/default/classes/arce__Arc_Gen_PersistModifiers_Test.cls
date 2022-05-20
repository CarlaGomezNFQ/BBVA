/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_PersistModifiers_Test
* @Author   jorge.diaz-blanco.contractor@bbva.com
* @Date     Created: 25/09/2020
* @Group    ARCE
* -----------------------------------------------------------------------------------------------
* @Description Test class that covers:  Arc_Gen_PersistModifiers_Service and Arc_Gen_PersistenceQualitative_Data
* -----------------------------------------------------------------------------------------------
* |2021-04-14 joseluis.garcia4.contractor@bbva.com
*             Class renaming for dependencies package.
* |2021-07-22 amunguia.contractor@bbva.com
*             modifiers are added to work
* -----------------------------------------------------------------------------------------------
*/
@IsTest
public class Arc_Gen_PersistModifiers_Test {
    /**
    * --------------------------------------------------------------------------------------
    * @Description Test setup method. Creates accounts, analysis and AHA.
    * --------------------------------------------------------------------------------------
    * @Author   jorge.diaz-blanco.contractor@bbva.com
    * --------------------------------------------------------------------------------------
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
        arce__Modifier__c mod = Arc_Gen_TestingGlobal_Util.createModifier(newAnalysis.Id);
        insert mod;
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
    * --------------------------------------------------------------------------------------
    * @Description Test method. Tests the persistence of variables.
    * --------------------------------------------------------------------------------------
    * @Author   jorge.diaz-blanco.contractor@bbva.com
    * --------------------------------------------------------------------------------------
    **/
    @isTest static void testPersistVariablesModifiers() {
        final arce__Account_has_Analysis__c aha = [SELECT id FROM arce__Account_has_Analysis__c LIMIT 1];

        Test.startTest();
        Arc_Gen_PersistModifiers_Service elem = new Arc_Gen_PersistModifiers_Service('persistenceModifiers');
        final Arc_Gen_PersistModifiers_Service.VariablePersistenceResult response = elem.persistVariablesOfAnalysis(aha.Id);
        Test.stopTest();
        System.assertEquals('200', response.serviceCode, 'Service call must have been successful');
    }
}