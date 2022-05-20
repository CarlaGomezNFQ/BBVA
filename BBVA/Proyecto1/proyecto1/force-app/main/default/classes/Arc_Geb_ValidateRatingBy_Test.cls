/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Geb_ValidateRatingBy_Test
* @Author   jose.hijar.contractor@bbva.com
* @Date     Created: 19/05/2021
* @Group    ARCE
* -----------------------------------------------------------------------------------------------
* @Description Tests methods of Arc_Gen_ValidateRatingBy_Controller class
* -----------------------------------------------------------------------------------------------
* @Changes
*
* |19-05-2021 jose.hijar.contractor@bbva.com
*             Class creation.
* -----------------------------------------------------------------------------------------------
*/
@isTest
public with sharing class Arc_Geb_ValidateRatingBy_Test {

  /**
  *-------------------------------------------------------------------------------
  * @Description Tests a OK case for Arc_Gen_ValidateRatingBy_Controller.getRatingData method
  *--------------------------------------------------------------------------------
  * @ Author jose.hijar.contactor@bbva.com
  * @ Date 2021-05-21
  *--------------------------------------------------------------------------------
  **/
  @isTest
  public static void getRatingDataTestOK(){

    arce.Arc_UtilitiesToTest_tst.setupAcccounts();
    Arc_Gen_ValidateRatingBy_Controller.ValidatedByResponse assertTest;

    Account acc = [SELECT Id FROM Account WHERE Name = 'Child2Group1'][0];
    Account groupAcc = [SELECT Id FROM Account WHERE Name = 'Group1Child'][0];

    arce__Analysis__c analysis = arce.Arc_UtilitiesToTest_tst.crearArceAnalysis('testName', null, groupAcc.Id);
    insert analysis;
    arce__Account_has_Analysis__c aHa = arce.Arc_UtilitiesToTest_tst.crearAccHasAnalysis(null, analysis.Id, acc.Id, null);
    insert aHa;

    Test.startTest();
    assertTest = Arc_Gen_ValidateRatingBy_Controller.getRatingData(aHa.Id);
    System.AssertEquals(true, assertTest.success, 'Ok');
    Test.stopTest();
  }

  /**
  *-------------------------------------------------------------------------------
  * @Description Tests a KO case for Arc_Gen_ValidateRatingBy_Controller.getRatingData method
  *--------------------------------------------------------------------------------
  * @ Author jose.hijar.contactor@bbva.com
  * @ Date 2021-05-21
  *--------------------------------------------------------------------------------
  **/
  @isTest
  public static void getRatingDataTestKO1(){

    Test.startTest();
    try{
      Arc_Gen_ValidateRatingBy_Controller.getRatingData('xxxx');
    }catch(Exception e){
      System.AssertEquals(true, e.getTypeName() == 'System.AuraHandledException', 'ko');
    }
    Test.stopTest();
  }

  /**
  *-------------------------------------------------------------------------------
  * @Description Tests a KO case for Arc_Gen_ValidateRatingBy_Controller.getRatingData method
  *--------------------------------------------------------------------------------
  * @ Author jose.hijar.contactor@bbva.com
  * @ Date 2021-05-21
  *--------------------------------------------------------------------------------
  **/
  @isTest
  public static void getRatingDataTestKO2(){

    Arc_Gen_ValidateRatingBy_Controller.ValidatedByResponse assertTest;
    Test.startTest();
    assertTest = Arc_Gen_ValidateRatingBy_Controller.getRatingData(null);
    System.AssertEquals(false, assertTest.success, 'ko');
    Test.stopTest();
  }

  /**
  *-------------------------------------------------------------------------------
  * @Description Tests a OK case for Arc_Gen_ValidateRatingBy_Controller.fetchUsers method
  *--------------------------------------------------------------------------------
  * @ Author jose.hijar.contactor@bbva.com
  * @ Date 2021-05-21
  *--------------------------------------------------------------------------------
  **/
  @isTest
  public static void fetchUsersOK1(){

    Arc_Gen_ValidateRatingBy_Controller.ValidatedByResponse assertTest;
    Test.startTest();
    assertTest = Arc_Gen_ValidateRatingBy_Controller.fetchUsers('ambit1');
    System.AssertEquals(true, assertTest.success, 'ok');
    Test.stopTest();
  }

  /**
  *-------------------------------------------------------------------------------
  * @Description Tests a KO case for Arc_Gen_ValidateRatingBy_Controller.fetchUsers method
  *--------------------------------------------------------------------------------
  * @ Author jose.hijar.contactor@bbva.com
  * @ Date 2021-05-21
  *--------------------------------------------------------------------------------
  **/
  @isTest
  public static void fetchUsersKO(){

    Arc_Gen_ValidateRatingBy_Controller.ValidatedByResponse assertTest;
    Test.startTest();
    assertTest = Arc_Gen_ValidateRatingBy_Controller.fetchUsers(null);
    System.AssertEquals(false, assertTest.success, 'ko');
    Test.stopTest();
  }


  /**
  *-------------------------------------------------------------------------------
  * @Description Tests a OK case for Arc_Gen_ValidateRatingBy_Controller.validateRating method
  *--------------------------------------------------------------------------------
  * @ Author jose.hijar.contactor@bbva.com
  * @ Date 2021-05-21
  *--------------------------------------------------------------------------------
  **/
  @isTest
  public static void validateRatingTestOk1(){
    Arc_Gen_ValidateRatingBy_Controller.ValidatedByResponse resp;

    final Account acc = arce.Arc_UtilitiesToTest_tst.crearCuenta('ES', null, null, 'CAONlXcCA_uxyJ402AA_xw');
    insert acc;
    arce__Analysis__c analysis = arce.Arc_UtilitiesToTest_tst.crearArceAnalysis('testName', null, acc.Id);
    insert analysis;
    arce__Account_has_Analysis__c aHa = arce.Arc_UtilitiesToTest_tst.crearAccHasAnalysis(null, analysis.Id, acc.Id, null);
    aHa.arce__group_asset_header_type__c = arce.Arc_Gen_Constants.GROUP_ASSET_HEADER_TYPE_HEADER;
    insert aHa;
    final arce__rating__c rating = arce.Arc_UtilitiesToTest_tst.createRatingObj('RatingId', 'AAA', 'AAA', '2');
    insert rating;
    final arce__Financial_Statements__c ffss = arce.Arc_UtilitiesToTest_tst.crearFinStatement(acc.id, aha.id, rating.Id, null);
    insert ffss;
    aha.arce__ffss_for_rating_id__c = ffss.id;
    aha.arce__financial_statement_id__c = ffss.id;
    update aha;
    arce__Traceability_Event__c te = new arce__Traceability_Event__c();
    te.arce__analysis_id__c = analysis.Id;
    te.arce__current_event__c = true;
    te.arce__gc_trcblty_internal_code_id__c = 'xx2';
    insert te;

    Test.startTest();
    resp = Arc_Gen_ValidateRatingBy_Controller.validateRating(aHa.Id, rating.Id, 'committee', 'example description');
    System.assertEquals(true, resp.success, 'Test passed OK');
    Test.stopTest();

  }


  /**
  *-------------------------------------------------------------------------------
  * @Description Tests a KO case for Arc_Gen_ValidateRatingBy_Controller.validateRating method
  *--------------------------------------------------------------------------------
  * @ Author jose.hijar.contactor@bbva.com
  * @ Date 2021-05-21
  *--------------------------------------------------------------------------------
  **/
  @isTest
  public static void validateRatingTestKO1(){
    Arc_Gen_ValidateRatingBy_Controller.ValidatedByResponse resp;

    final Account acc = arce.Arc_UtilitiesToTest_tst.crearCuenta('ES', null, null, 'CAONlXcCA_uxyJ402AA_xw');
    insert acc;
    arce__Analysis__c analysis = arce.Arc_UtilitiesToTest_tst.crearArceAnalysis('testName', null, acc.Id);
    insert analysis;
    arce__Account_has_Analysis__c aHa = arce.Arc_UtilitiesToTest_tst.crearAccHasAnalysis(null, analysis.Id, acc.Id, null);
    insert aHa;
    final arce__rating__c rating = arce.Arc_UtilitiesToTest_tst.createRatingObj('RatingId', 'AAA', 'AAA', '2');
    insert rating;
    final arce__Financial_Statements__c ffss = arce.Arc_UtilitiesToTest_tst.crearFinStatement(acc.id, aha.id, rating.Id, null);
    insert ffss;
    aha.arce__ffss_for_rating_id__c = ffss.id;
    aha.arce__financial_statement_id__c = ffss.id;
    update aha;
    arce__Traceability_Event__c te = new arce__Traceability_Event__c();
    te.arce__analysis_id__c = analysis.Id;
    te.arce__current_event__c = true;
    te.arce__gc_trcblty_internal_code_id__c = 'xx2';
    insert te;

    Test.startTest();
    try{
      resp = Arc_Gen_ValidateRatingBy_Controller.validateRating(aHa.Id, rating.Id, 'committee', 'example description');
    }catch(Exception e){
      System.assertEquals(true, e.getTypeName().equals('System.AuraHandledException'), 'Test passed KO');
    }
    Test.stopTest();
  }

}