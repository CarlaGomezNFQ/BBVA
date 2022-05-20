/*------------------------------------------------------------------
*Author:        bbva.com developers
*Project:      	ARCE - BBVA Bancomer
*Description:   Test class for Arc_GBL_SampleRatingDetailsMapping_test
*_______________________________________________________________________________________
*Versión    Date           	Author                              Description
*1.0        22/07/2021      ARCE's TEAM                         Created.
-----------------------------------------------------------------------------------------*/
@isTest
global with sharing class Arc_GBL_SampleRatingDetailsMapping_test {
    /**
        * @Description: String with value "accNumber"
    */
    private static String accNumber = 'CAONlXcCA_uxyJ402AA_xw';
    /**
    *-------------------------------------------------------------------------------
    * @Description Test setup
    *--------------------------------------------------------------------------------
    * @ Author juanignacio.hita.contractor@bbva.com
    * @ Date 2021-07-22
    *--------------------------------------------------------------------------------
    **/
    @TestSetup
    static void testSetup() {
        final Account acc = Arc_UtilitiesToTest_tst.crearCuenta('TestAcc', null, null, accNumber);
        insert acc;
        final arce__Analysis__c analisis = Arc_UtilitiesToTest_tst.crearArceAnalysis('TestAna', 'Arce', acc.id);
        insert analisis;
        final arce__Sector__c sector = Arc_UtilitiesToTest_tst.crearSector('g-01', '100', 'g-01', null);
        insert sector;
        final arce__Account_has_Analysis__c aha = Arc_UtilitiesToTest_tst.crearAccHasAnalysis(sector.Id, analisis.Id, acc.id, 'g-01');
        insert aha;
        final arce__rating__c rating = Arc_UtilitiesToTest_tst.crearRating(null);
        insert rating;
        final arce__Financial_Statements__c ffss = Arc_UtilitiesToTest_tst.crearFinStatement(acc.id, aha.id, rating.id, null);
        ffss.arce__ffss_submitted_type__c = '1';
        ffss.arce__ffss_valid_type__c = '1';
        insert ffss;
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Test Arc_GBL_SampleRatingDetailsMapping setRatingVariable method
    *--------------------------------------------------------------------------------
    * @ Author juanignacio.hita.contractor@bbva.com
    * @ Date 2021-07-22
    *--------------------------------------------------------------------------------
    **/
    @isTest
    global static void setRatingVariableTest() {
        Test.startTest();
        final arce__Account_has_Analysis__c aha = [SELECT Id, Name FROM arce__Account_has_Analysis__c];
        final arce__rating__c rating = new arce__rating__c();
        Arc_GBL_SampleRatingDetailsMapping sampleRatingClass = new Arc_GBL_SampleRatingDetailsMapping();
        final arce__rating_variables_detail__c ratingVar = sampleRatingClass.setRatingVariable(new Map<String, Object>{}, aha.Id, rating);
        System.assertNotEquals(null, ratingVar, 'Test setRatingVariable');
        Test.stopTest();
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Test Arc_GBL_SampleRatingDetailsMapping setRatingModifier method
    *--------------------------------------------------------------------------------
    * @ Author juanignacio.hita.contractor@bbva.com
    * @ Date 2021-07-22
    *--------------------------------------------------------------------------------
    **/
    @isTest
    global static void setRatingModifierTest() {
        Test.startTest();
        final arce__Account_has_Analysis__c aha = [SELECT Id, Name FROM arce__Account_has_Analysis__c];
        final arce__rating__c rating = new arce__rating__c();
        Arc_GBL_SampleRatingDetailsMapping sampleRatingClass = new Arc_GBL_SampleRatingDetailsMapping();
        final arce__rating_variables_detail__c ratingVar = sampleRatingClass.setRatingModifier(new Map<String, Object>{}, aha.Id, rating);
        System.assertNotEquals(null, ratingVar, 'Test setRatingVariable');
        Test.stopTest();
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Test Arc_GBL_SampleRatingDetailsMapping updateOverlayObj method
    *--------------------------------------------------------------------------------
    * @ Author juanignacio.hita.contractor@bbva.com
    * @ Date 2021-07-22
    *--------------------------------------------------------------------------------
    **/
    @isTest
    global static void updateOverlayObjTest() {
        Test.startTest();
        final arce__Account_has_Analysis__c aha = [SELECT Id, Name FROM arce__Account_has_Analysis__c];
        final arce__Overlay__c overlayOb = new arce__Overlay__c();
        Arc_GBL_SampleRatingDetailsMapping sampleRatingClass = new Arc_GBL_SampleRatingDetailsMapping();
        sampleRatingClass.updateOverlayObj(new Map<String, Object>{}, '', overlayOb);
        System.assertNotEquals(null, overlayOb, 'Test updateOverlayObj');
        Test.stopTest();
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Test Arc_GBL_SampleRatingDetailsMapping setRating method
    *--------------------------------------------------------------------------------
    * @ Author juanignacio.hita.contractor@bbva.com
    * @ Date 2021-07-22
    *--------------------------------------------------------------------------------
    **/
    @isTest
    global static void setRatingTest() {
        Test.startTest();
        final arce__Account_has_Analysis__c aha = [SELECT Id, Name FROM arce__Account_has_Analysis__c];
        final arce__rating__c rating = new arce__rating__c();
        Arc_GBL_SampleRatingDetailsMapping sampleRatingClass = new Arc_GBL_SampleRatingDetailsMapping();
        sampleRatingClass.setRating(new Map<String, Object>{}, '', aha, rating);
        System.assertNotEquals(null, rating, 'Test setRating');
        Test.stopTest();
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Test Arc_GBL_SampleRatingDetailsMapping setRatingCombinedRating method
    *--------------------------------------------------------------------------------
    * @ Author juanignacio.hita.contractor@bbva.com
    * @ Date 2021-07-22
    *--------------------------------------------------------------------------------
    **/
    @isTest
    global static void setRatingCombinedRatingTest() {
        Test.startTest();
        Arc_GBL_SampleRatingDetailsMapping sampleRatingClass = new Arc_GBL_SampleRatingDetailsMapping();
        final arce__rating_variables_detail__c ratingVar = sampleRatingClass.setRatingCombinedRating(new Map<String, Object>(), 'a', 1.0, 'e', 'i');
        System.assertNotEquals(null, ratingVar, 'Test setRatingCombinedRating');
        Test.stopTest();
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Test Arc_GBL_SampleRatingDetailsMapping getActivitiesWeightByTemplate method
    *--------------------------------------------------------------------------------
    * @ Author juanignacio.hita.contractor@bbva.com
    * @ Date 2021-07-22
    *--------------------------------------------------------------------------------
    **/
    @isTest
    global static void getActivitiesWeightByTemplateTest() {
        Test.startTest();
        Arc_GBL_SampleRatingDetailsMapping sampleRatingClass = new Arc_GBL_SampleRatingDetailsMapping();
        final List<AggregateResult> lstAggregate = sampleRatingClass.getActivitiesWeightByTemplate('', new Set<String>());
        System.assertEquals(true, lstAggregate.isEmpty(), 'Error getActivitiesWeightByTemplate');
        Test.stopTest();
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Test Arc_GBL_SampleRatingDetailsMapping getActivitiesWeightByTemplate method
    *--------------------------------------------------------------------------------
    * @ Author juanignacio.hita.contractor@bbva.com
    * @ Date 2021-07-22
    *--------------------------------------------------------------------------------
    **/
    @isTest
    global static void getRelativeWeightSumTest() {
        Test.startTest();
        Arc_GBL_SampleRatingDetailsMapping sampleRatingClass = new Arc_GBL_SampleRatingDetailsMapping();
        final AggregateResult aggregate = sampleRatingClass.getRelativeWeightSum('');
        System.assertEquals(null, aggregate, 'Error getRelativeWeightSum');
        Test.stopTest();
    }
}