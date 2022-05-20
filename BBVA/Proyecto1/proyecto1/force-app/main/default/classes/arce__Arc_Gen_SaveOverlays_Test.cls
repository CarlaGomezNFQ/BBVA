/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_SaveOverlays_Test
* @Author   jose.hijar.contractor@bbva.com
* @Date     Created: 19/05/2021
* @Group    ARCE
* -----------------------------------------------------------------------------------------------
* @Description Tests methods of Arc_Gen_SaveOverlays class
* -----------------------------------------------------------------------------------------------
* @Changes
*
* |19-05-2021 jose.hijar.contractor@bbva.com
*             Class creation.
* -----------------------------------------------------------------------------------------------
*/
@isTest
public with sharing class Arc_Gen_SaveOverlays_Test {

  /**
  *-------------------------------------------------------------------------------
  * @Description Tests a OK case for Arc_Gen_SaveOverlays.save method
  *--------------------------------------------------------------------------------
  * @ Author jose.hijar.contactor@bbva.com
  * @ Date 2021-05-21
  *--------------------------------------------------------------------------------
  **/
  @isTest
  public static void testSaveOK1() {
    final Account acc = Arc_UtilitiesToTest_tst.crearCuenta('ES', null, null, 'CAONlXcCA_uxyJ402AA_xw');
    insert acc;
    final arce__Analysis__c analysis = Arc_UtilitiesToTest_tst.crearArceAnalysis('Test Analysis', null, acc.Id);
    analysis.arce__Stage__c = '1';
    insert analysis;
    final arce__Sector__c sect = Arc_UtilitiesToTest_tst.crearSector('Executive Summ', '500', 'ExecSumm', null);
    insert sect;
    final  arce__Account_has_Analysis__c aha = Arc_UtilitiesToTest_tst.crearAccHasAnalysis(sect.Id, analysis.Id, acc.Id, ' s-01');
    insert aha;
    final arce__rating__c rating = Arc_UtilitiesToTest_tst.createRatingObj(null, 'AAA', 'AAA', '2');
    insert rating;
    final arce__Financial_Statements__c ffss = Arc_UtilitiesToTest_tst.crearFinStatement(acc.id, aha.id, rating.Id, null);
    ffss.arce__ffss_submitted_type__c = '1';
    ffss.arce__ffss_valid_type__c = '1';
    insert ffss;
    aha.arce__ffss_for_rating_id__c = ffss.id;
    aha.arce__financial_statement_id__c = ffss.id;
    update aha;

    final arce__Overlay__c overlayObj = new arce__Overlay__c();
    overlayObj.arce__Arc_Gen_Local_Id__c = 'CAONlXcCA_uxyJ402AA_xw';
    insert overlayObj;

    final List<sObject> param = new List<sObject>{overlayObj};

    Test.startTest();
    final Arc_Gen_SaveOverlays saveImpl = new Arc_Gen_SaveOverlays();
    final String resp = saveImpl.save(param);
    System.assert(resp.containsIgnoreCase('"validated":true'), 'response must contains "validated":true as a sign of successful execution');
    Test.stopTest();
  }

  /**
  *-------------------------------------------------------------------------------
  * @Description Tests a OK case for Arc_Gen_SaveOverlays.save method
  *--------------------------------------------------------------------------------
  * @ Author jose.hijar.contactor@bbva.com
  * @ Date 2021-05-21
  *--------------------------------------------------------------------------------
  **/
  @isTest
  public static void testSaveOK2() {
    final Account acc = Arc_UtilitiesToTest_tst.crearCuenta('ES', null, null, 'CAONlXcCA_uxyJ402AA_xw');
    insert acc;
    final arce__Analysis__c analysis = Arc_UtilitiesToTest_tst.crearArceAnalysis('Test Analysis', null, acc.Id);
    analysis.arce__Stage__c = '1';
    insert analysis;
    final arce__Sector__c sect = Arc_UtilitiesToTest_tst.crearSector('Executive Summ', '500', 'ExecSumm', null);
    insert sect;
    final  arce__Account_has_Analysis__c aha = Arc_UtilitiesToTest_tst.crearAccHasAnalysis(sect.Id, analysis.Id, acc.Id, ' s-01');
    insert aha;
    final arce__rating__c rating = Arc_UtilitiesToTest_tst.createRatingObj(null, 'AAA', 'AAA', '2');
    insert rating;
    final arce__Financial_Statements__c ffss = Arc_UtilitiesToTest_tst.crearFinStatement(acc.id, aha.id, rating.Id, null);
    ffss.arce__ffss_submitted_type__c = '1';
    ffss.arce__ffss_valid_type__c = '1';
    insert ffss;
    aha.arce__ffss_for_rating_id__c = ffss.id;
    aha.arce__financial_statement_id__c = ffss.id;
    update aha;

    final arce__Overlay__c overlayObj = new arce__Overlay__c();
    overlayObj.arce__Arc_Gen_Local_Id__c = 'xxxxxxx';
    insert overlayObj;

    final List<sObject> param = new List<sObject>{overlayObj};

    Test.startTest();
    final Arc_Gen_SaveOverlays saveImpl = new Arc_Gen_SaveOverlays();
    final String resp = saveImpl.save(param);
    System.assert(resp.containsIgnoreCase('"validated":true'), 'response must contains "validated":true as a sign of successful execution');
    Test.stopTest();
  }
}