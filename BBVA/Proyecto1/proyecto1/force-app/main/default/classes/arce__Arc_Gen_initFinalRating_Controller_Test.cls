/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_initFinalRating_Controller_Test
* @Author   saimassimilianno.jordana.contractor@bbva.com
* @Date     Created: 01/09/2021
* @Group    ARCE
* -----------------------------------------------------------------------------------------------
* @Description Tests methods of Arc_Gen_initFinalRating_Controller_Test class
* -----------------------------------------------------------------------------------------------
* @Changes
*
* |01-09-2021 saimassimilianno.jordana.contractor@bbva.com
*             Class creation.
* -----------------------------------------------------------------------------------------------
*/
@isTest
public with sharing class Arc_Gen_initFinalRating_Controller_Test {
  /**
  * @description testSetup
  * @author saimassimilianno.jordana.contractor@bbva.com | 01-09-2021
  **/
  @TestSetup
  public static void makeData() {

    // All basic data inserted.
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
    final arce__Activity_Split_2012__c actSplt2012 = new arce__Activity_Split_2012__c();
    actSplt2012.arce__Account_has_Analysis__c = aha.Id;
    actSplt2012.arce__sector_id__c = 'B';
    actSplt2012.arce__Subsector_id__c = 'BE';
    actSplt2012.arce__gf_company_economic_actvy_id__c = 'BEB';
    actSplt2012.arce__gf_subactivity_id__c = 'BEB1';
    actSplt2012.arce__Country__c = 'AU';
    actSplt2012.arce__Template_type__c = '107';
    insert actSplt2012;

    // List of rating var detail created.
    final List<arce__rating_variables_detail__c> listVarDet = makeDataHelper(rating.id,aha.Id);

    // all the ratDet inserted
    insert listVarDet;
  }

  /**
  * @description testSetupHelper
  * @author saimassimilianno.jordana.contractor@bbva.com | 06-09-2021
  **/
  public static List<arce__rating_variables_detail__c> makeDataHelper(String ratingId, String ahasId) {

    final List<arce__rating_variables_detail__c> listVar = new List<arce__rating_variables_detail__c>();

    final arce__rating_variables_detail__c ratDet1 = new arce__rating_variables_detail__c();
    ratDet1.arce__rating_id__c = ratingId;
    ratDet1.arce__rating_variable_large_id__c = '0BEB102000AU';
    ratDet1.arce__rating_var_score_number__c = 3;
    ratDet1.arce__rating_modifier_adj_type__c = 'DATA_2012';
    ratDet1.arce__account_has_analysis_id__c = ahasId;
    listVar.add(ratDet1);

    final arce__rating_variables_detail__c ratDet2 = new arce__rating_variables_detail__c();
    ratDet2.arce__rating_id__c = ratingId;
    ratDet2.arce__rating_variable_large_id__c = '0BEB101000AU';
    ratDet2.arce__rating_var_score_number__c = 5;
    ratDet2.arce__rating_modifier_adj_type__c = 'DATA_2012';
    ratDet2.arce__account_has_analysis_id__c = ahasId;
    listVar.add(ratDet2);

    final arce__rating_variables_detail__c ratDet4 = new arce__rating_variables_detail__c();
    ratDet4.arce__rating_id__c = ratingId;
    ratDet4.arce__rating_variable_large_id__c = 'DA00002001';
    ratDet4.arce__rating_var_score_number__c = 1;
    ratDet4.arce__rating_modifier_adj_type__c = 'DATA_2012';
    ratDet4.arce__account_has_analysis_id__c = ahasId;
    listVar.add(ratDet4);

    final arce__rating_variables_detail__c ratDet3 = new arce__rating_variables_detail__c();
    ratDet3.arce__rating_id__c = ratingId;
    ratDet3.arce__rating_variable_large_id__c = '0BEB101000';
    ratDet3.arce__activity_sub_industry_id__c = 'BEB1';
    ratDet3.arce__rating_var_score_number__c = 5;
    ratDet3.arce__activity_country__c = 'AU';
    ratDet3.arce__activity_template__c = '107';
    ratDet3.arce__adj_short_rating_value_type__c = 'BBB';
    ratDet3.arce__rating_modifier_adj_type__c = 'ACTIVITY_TEMPLATE';
    ratDet3.arce__account_has_analysis_id__c = ahasId;
    listVar.add(ratDet3);

    return listVar;

  }

  /**
  *-------------------------------------------------------------------------------
  * @Description Tests a OK case for Arc_Gen_initAdjustment_Controller.clientInfo method
  *--------------------------------------------------------------------------------
  * @ Author saimassimilianno.jordana.contractor@bbva.com
  * @ Date 2021-09-01
  *--------------------------------------------------------------------------------
  **/
  @isTest
  public static void updtActSplt2012Test() {
    final arce__Account_has_Analysis__c aha = [SELECT Id FROM arce__Account_has_Analysis__c LIMIT 1];
    Test.startTest();
    final String testResult = Arc_Gen_initFinalRating_Controller.updateActSplit2012(aha.Id);
    final Map<String, Object> mapRes = (Map<String, Object>) JSON.deserializeUntyped(testResult);
    System.assert(Boolean.valueOf(mapRes.get('status')), 'saveStatus expected to be true');
    Test.stopTest();

  }
}