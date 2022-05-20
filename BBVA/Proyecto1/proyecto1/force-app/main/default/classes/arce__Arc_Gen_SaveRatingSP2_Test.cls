/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_SaveRatingSP2_Test
* @Author   jose.hijar.contractor@bbva.com
* @Date     Created: 19/05/2021
* @Group    ARCE
* -----------------------------------------------------------------------------------------------
* @Description Tests methods of Arc_Gen_SaveRatingSP2 class
* -----------------------------------------------------------------------------------------------
* @Changes
*
* |19-05-2021 jose.hijar.contractor@bbva.com
*             Class creation.
* -----------------------------------------------------------------------------------------------
*/
@isTest
public class Arc_Gen_SaveRatingSP2_Test {


  /**
  *-------------------------------------------------------------------------------
  * @Description Tests a OK case for Arc_Gen_SaveRatingSP2.save method
  *--------------------------------------------------------------------------------
  * @ Author jose.hijar.contactor@bbva.com
  * @ Date 2021-05-21
  *--------------------------------------------------------------------------------
  **/
  @isTest
  public static void saveTestOK1() {

    final Account acc = Arc_UtilitiesToTest_tst.crearCuenta('ES', null, null, 'CAONlXcCA_uxyJ402AA_xw');
    insert acc;
    final arce__Analysis__c analysis = Arc_UtilitiesToTest_tst.crearArceAnalysis('Test Analysis', null, acc.Id);
    analysis.arce__Stage__c = '2';
    //analysis.arce__Stage__c = '1'; other test
    insert analysis;
    final arce__Sector__c sect = Arc_UtilitiesToTest_tst.crearSector('Executive Summ', '500', 'ExecSumm', null);
    insert sect;
    final  arce__Account_has_Analysis__c aha = Arc_UtilitiesToTest_tst.crearAccHasAnalysis(sect.Id, analysis.Id, acc.Id, ' s-01');
    aha.arce__IRP_Workflow__c = System.Label.Arc_Gen_NewRaipOverrideApi;
    insert aha;
    final arce__rating__c rating = Arc_UtilitiesToTest_tst.createRatingObj(null, 'AAA', 'AAA', '2');
    insert rating;
    final arce__Financial_Statements__c ffss = Arc_UtilitiesToTest_tst.crearFinStatement(acc.id, aha.id, rating.Id, null);
    insert ffss;
    aha.arce__ffss_for_rating_id__c = ffss.id;
    aha.arce__financial_statement_id__c = ffss.id;
    update aha;
    final arce__rating_variables_detail__c rvdOver = setRatingVariable(aha.Id, rating.Id, 'OVERRIDE');
    rvdOver.arce__adj_long_rating_value_type__c = 'AAA';
    rvdOver.arce__adj_short_rating_value_type__c = 'AAA';
    insert rvdOver;

    final List<sObject> param = new List<sObject>{aha,rvdOver};

    Test.startTest();
    final Arc_Gen_SaveRatingSP2 saveImpl = new Arc_Gen_SaveRatingSP2();
    final String resp = saveImpl.save(param);
    System.assert(resp.containsIgnoreCase('"validated":true'), 'response must contains a "validated":true as a sign of successful execution');
    Test.stopTest();
  }


  /**
  *-------------------------------------------------------------------------------
  * @Description Tests a OK case for Arc_Gen_SaveRatingSP2.save method
  *--------------------------------------------------------------------------------
  * @ Author jose.hijar.contactor@bbva.com
  * @ Date 2021-05-21
  *--------------------------------------------------------------------------------
  **/
  @isTest
  public static void saveTestOK2() {

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
    insert ffss;
    aha.arce__ffss_for_rating_id__c = ffss.id;
    aha.arce__financial_statement_id__c = ffss.id;
    update aha;
    final arce__rating_variables_detail__c rvdOver = setRatingVariable(aha.Id, rating.Id, 'OVERRIDE');
    insert rvdOver;

    final List<sObject> param = new List<sObject>{aha,rvdOver};

    Test.startTest();
    final Arc_Gen_SaveRatingSP2 saveImpl = new Arc_Gen_SaveRatingSP2();
    final String resp = saveImpl.save(param);
    System.assert(resp.containsIgnoreCase('"validated":true'), 'response must contains a "validated":true as a sign of successful execution');
    Test.stopTest();
  }

  /**
  *-------------------------------------------------------------------------------
  * @Description creates a arce__rating_variables_detail__c object for test purposes
  *--------------------------------------------------------------------------------
  * @ Author jose.hijar.contactor@bbva.com
  * @ Date 2021-05-21
  *--------------------------------------------------------------------------------
  **/
  private static arce__rating_variables_detail__c setRatingVariable(String analysisId,String ratingId, String modifierType) {
    return new arce__rating_variables_detail__c(
        arce__account_has_analysis_id__c = analysisId,
        arce__rating_id__c = ratingId,
        arce__rating_modifier_adj_type__c = modifierType //'OVERRIDE'
    );
  }
}