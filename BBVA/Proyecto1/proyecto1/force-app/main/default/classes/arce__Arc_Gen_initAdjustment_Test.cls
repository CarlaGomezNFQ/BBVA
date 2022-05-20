/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_initAdjustment_Test
* @Author   jose.hijar.contractor@bbva.com
* @Date     Created: 19/05/2021
* @Group    ARCE
* -----------------------------------------------------------------------------------------------
* @Description Tests methods of Arc_Gen_initAdjustment_Controller class
* -----------------------------------------------------------------------------------------------
* @Changes
*
* |19-05-2021 jose.hijar.contractor@bbva.com
*             Class creation.
* |28-05-2021 amunguia.contractor@bbva.com  the testSetup has been added.
* |28-05-2021 amunguia.contractor@bbva.com  coverage is raised to 75%.
* -----------------------------------------------------------------------------------------------
*/
@isTest
public with sharing class Arc_Gen_initAdjustment_Test {

  /**
  * @description testSetup
  * @author amunguia.contractor@bbva.com | 05-28-2021
  **/
  @TestSetup
  public static void makeData() {
    final Account acc = Arc_UtilitiesToTest_tst.crearCuenta('ES', null, null, 'CAONlXcCA_uxyJ402AA_xw');
    acc.Site = 'ES';
    insert acc;
    final arce__Analysis__c analisis = Arc_UtilitiesToTest_tst.crearArceAnalysis('TestAna', 'Arce', acc.id);
    analisis.arce__anlys_wkfl_sub_process_type__c = '4';
    insert analisis;
    final arce__Sector__c sector = Arc_UtilitiesToTest_tst.crearSector('g-01', '100', 'g-01', null);
    insert sector;
    final arce__Account_has_Analysis__c aha = Arc_UtilitiesToTest_tst.crearAccHasAnalysis(sector.Id, analisis.Id, acc.id, 'g-01');
    aha.arce__group_asset_header_type__c = '1';
    aha.arce__analysis_template_id__c = 'Generic';
    aha.arce__InReview__c = true;
    aha.arce__IRP_Workflow__c = System.Label.Arc_Gen_NewRaipAdjustmentApi;
    insert aha;
    final arce__rating__c rating = Arc_UtilitiesToTest_tst.createRatingObj(null, 'AAA', 'AAA', '2');
    insert rating;
    final arce__Financial_Statements__c ffss = Arc_UtilitiesToTest_tst.crearFinStatement(acc.id, aha.id, rating.Id, null);
    insert ffss;
    aha.arce__ffss_for_rating_id__c = ffss.id;
    aha.arce__financial_statement_id__c = ffss.id;
    update aha;
  }
  /**
  *-------------------------------------------------------------------------------
  * @Description Tests a OK case for Arc_Gen_initAdjustment_Controller.clientInfo method
  *--------------------------------------------------------------------------------
  * @ Author jose.hijar.contactor@bbva.com
  * @ Date 2021-05-21
  *--------------------------------------------------------------------------------
  **/
  @isTest
  public static void clientInfoTestOK1() {
    final arce__Account_has_Analysis__c aha = [SELECT Id FROM arce__Account_has_Analysis__c LIMIT 1];
    Test.startTest();
    final Arc_Gen_initAdjustment_Service.AdjustResponse testResult = Arc_Gen_initAdjustment_Controller.clientInfo(aha.Id);
    System.assert(testResult.saveStatus, 'saveStatus expected to be true');
    Test.stopTest();

  }

    /**
  *-------------------------------------------------------------------------------
  * @Description Tests a OK case for Arc_Gen_initAdjustment_Controller.clientInfo method
  *--------------------------------------------------------------------------------
  * @ Author jose.hijar.contactor@bbva.com
  * @ Date 2021-05-21
  *--------------------------------------------------------------------------------
  **/
  @isTest
  public static void clientInfoTestOK2() {
    final arce__Account_has_Analysis__c aha = [SELECT Id FROM arce__Account_has_Analysis__c LIMIT 1];
    aha.arce__IRP_Workflow__c = System.Label.Arc_Gen_NewRaipOverrideApi;
    update aha;
    Test.startTest();
    final Arc_Gen_initAdjustment_Service.AdjustResponse testResult = Arc_Gen_initAdjustment_Controller.clientInfo(aha.Id);
    System.assert(testResult.saveStatus, 'saveStatus expected to be true');
    Test.stopTest();

  }
  /**
  * @description isNotESPClientTest
  * @author amunguia.contractor@bbva.com | 05-28-2021
  **/
  @isTest
  public static void isNotESPClientTest() {

    final arce__Account_has_Analysis__c aha = [SELECT Id FROM arce__Account_has_Analysis__c LIMIT 1];
    Test.startTest();
    final arce.Arc_Gen_ServiceAndSaveResponse testResult = Arc_Gen_initAdjustment_Controller.isNotESPClient(aha);
    System.assertEquals('200', testResult.serviceCode, 'Error call isNotEspClient');
    Test.stopTest();

  }
  /**
  * @description getRtngIdRiskAssTest
  * @author amunguia.contractor@bbva.com | 05-28-2021
  **/
  @isTest
  public static void getRtngIdRiskAssTest() {
    final arce__Account_has_Analysis__c aha = [SELECT Id FROM arce__Account_has_Analysis__c LIMIT 1];
    Test.startTest();
    final Arc_Gen_initAdjustment_Service.AdjustResponse testResult = Arc_Gen_initAdjustment_Controller.getRtngIdRiskAss(aha.Id);
    System.assert(testResult.saveStatus, 'Error call getRtngIdRiskAss');
    Test.stopTest();
  }
}