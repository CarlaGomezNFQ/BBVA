/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_GBL_RatingDetailsMapping_Test
* @Author   jose.hijar.contractor@bbva.com
* @Date     Created: 19/05/2021
* @Group    ARCE
* -----------------------------------------------------------------------------------------------
* @Description Tests methods of Arc_GBL_RatingDetailsMapping class
* -----------------------------------------------------------------------------------------------
* @Changes
*
* |19-05-2021 jose.hijar.contractor@bbva.com
*             Class creation.
* |11-06-2021 amunguia.contractor@bbva.com  the global classes of the dependency package are used
* |01-09-2021 saimassimilianno.jordana.contractor@bbva.com  meth0ds modified to keep correct funcionality.
* -----------------------------------------------------------------------------------------------
*/
@isTest
public with sharing class Arc_GBL_RatingDetailsMapping_Test {

  /**
  *-------------------------------------------------------------------------------
  * @Description Tests a OK case for Arc_GBL_RatingDetailsMapping.setRatingVariable method
  *--------------------------------------------------------------------------------
  * @ Author jose.hijar.contactor@bbva.com
  * @ Date 2021-05-21
  *--------------------------------------------------------------------------------
  **/
  @isTest
  public static void setRatingVariableTestOK1() {
    final Arc_GBL_RatingDetailsMapping testObj = new Arc_GBL_RatingDetailsMapping();
    arce__rating_variables_detail__c retObj;
    //
    final Map<String,Object> input = new Map<String,Object>{arce.Arc_Gen_RatingGlobal_Constants.ID_TEXT => 'DA00002001' , arce.Arc_Gen_RatingGlobal_Constants.SCORE => new Map<String, Object>{arce.Arc_Gen_RatingGlobal_Constants.VALUE_TEXT => '0.5'}};

    Test.startTest();
    retObj = testObj.setRatingVariable(input, null, new arce__rating__c());
    System.assert(retObj != null, 'Returned object must be non null');
    Test.stopTest();
  }

  /**
  *-------------------------------------------------------------------------------
  * @Description Tests a OK case for Arc_GBL_RatingDetailsMapping.updateOverlayObj method
  *--------------------------------------------------------------------------------
  * @ Author jose.hijar.contactor@bbva.com
  * @ Date 2021-05-21
  *--------------------------------------------------------------------------------
  **/
  @isTest
  public static void updateOverlayObjTestOK1() {
    final Arc_GBL_RatingDetailsMapping testObj = new Arc_GBL_RatingDetailsMapping();
    final String modifierTestId = '0101';
    final arce__Overlay__c overlayObj = new arce__Overlay__c();
    Test.startTest();
    final arce__overlay_custom_mapping__mdt overlayMappingConfig = testObj.modifierOverlayMapping.get(modifierTestId);
    if(overlayMappingConfig != null) {
      final Map<String,Object> input = new Map<String,Object>{arce.Arc_Gen_RatingGlobal_Constants.MODIFIER => new Map<String, Object>(), arce.Arc_Gen_RatingGlobal_Constants.SHORT_VALUE => 'AA'};
      testObj.updateOverlayObj(input, modifierTestId, overlayObj);
      System.assert(overlayObj.get(overlayMappingConfig.shortScale_fieldMap__c) != null, 'input map must have a value in a variable that is being saved in the overlay field mapped by arce__defProb_fieldMap__c field of CMDT. adjust on demand if current implementation changes.');
    } else {
      System.assert(false, 'arce__overlay_custom_mapping__mdt must have a a row with the same Id specified in modifierTestId param');
    }
    Test.stopTest();
  }


  /**
  *-------------------------------------------------------------------------------
  * @Description Tests a OK case for Arc_GBL_RatingDetailsMapping.setRating method
  *--------------------------------------------------------------------------------
  * @ Author jose.hijar.contactor@bbva.com
  * @ Date 2021-05-21
  *--------------------------------------------------------------------------------
  **/
  @isTest
  public static void setRatingTestOK1() {
    final Arc_GBL_RatingDetailsMapping testObj = new Arc_GBL_RatingDetailsMapping();
    final arce__rating__c ratingObj = new arce__rating__c();

    final Map<String,Object> inputMap = new Map<String,Object>{arce.Arc_Gen_RatingGlobal_Constants.SCORE_TEXT => '0.5'};

    Test.startTest();
    testObj.setRating(inputMap, arce.Arc_Gen_RatingGlobal_Constants.ANCHOR_RATING, null, ratingObj);
    System.assert(ratingObj.arce__anchor_score__c != null, 'arce__anchor_score__c field must be non null. This may change as implementation changes');
    Test.stopTest();
  }


  /**
  *-------------------------------------------------------------------------------
  * @Description Tests a OK case for Arc_GBL_RatingDetailsMapping.setRating method
  *--------------------------------------------------------------------------------
  * @ Author jose.hijar.contactor@bbva.com
  * @ Date 2021-05-21
  *--------------------------------------------------------------------------------
  **/
  @isTest
  public static void setRatingTestOK2() {
    final Arc_GBL_RatingDetailsMapping testObj = new Arc_GBL_RatingDetailsMapping();
    final arce__rating__c ratingObj = new arce__rating__c();

    final Map<String,Object> inputMap = new Map<String,Object>{arce.Arc_Gen_RatingGlobal_Constants.SCORE_TEXT => '0.5'};

    Test.startTest();
    testObj.setRating(inputMap, arce.Arc_Gen_RatingGlobal_Constants.METHOD_OVERLAY, null, ratingObj);
    System.assert(ratingObj.arce__overlay_score_number__c != null, 'arce__anchor_score__c field must be non null. This may change as implementation changes');
    Test.stopTest();
  }


  /**
  *-------------------------------------------------------------------------------
  * @Description Tests a OK case for Arc_GBL_RatingDetailsMapping.setRatingCombinedRating method
  *--------------------------------------------------------------------------------
  * @ Author jose.hijar.contactor@bbva.com
  * @ Date 2021-05-21
  *--------------------------------------------------------------------------------
  **/
  @isTest
  public static void setRatingCombinedRatingOK1() {
    final Arc_GBL_RatingDetailsMapping testObj = new Arc_GBL_RatingDetailsMapping();
    arce__rating_variables_detail__c retObj;

    final Map<String,Object> inputMap = new Map<String,Object>();

    Test.startTest();
    retObj = testObj.setRatingCombinedRating(inputMap, '23', 2.5, null, null);
    System.assert(retObj != null, 'Return object must not be null');
    Test.stopTest();
  }

  /**
  *-------------------------------------------------------------------------------
  * @Description Tests a OK case for Arc_GBL_RatingDetailsMapping.getActivitiesWeightByTemplate method
  *--------------------------------------------------------------------------------
  * @ Author jose.hijar.contactor@bbva.com
  * @ Date 2021-05-21
  *--------------------------------------------------------------------------------
  **/
  @isTest
  public static void activitiesWeightTest() {
    final Arc_GBL_RatingDetailsMapping testObj = new Arc_GBL_RatingDetailsMapping();
    List<AggregateResult> retObj;
    final Account acc = Arc_UtilitiesToTest_tst.crearCuenta('ES', null, null, 'CAONlXcCA_uxyJ402AA_xw');
    insert acc;
    final arce__Analysis__c analisis = Arc_UtilitiesToTest_tst.crearArceAnalysis('TestAna', 'Arce', acc.id);
    analisis.arce__anlys_wkfl_sub_process_type__c = '4';
    insert analisis;
    final arce__Sector__c sector = Arc_UtilitiesToTest_tst.crearSector('g-01', '100', 'g-01', null);
    insert sector;
    final arce__Account_has_Analysis__c aha = Arc_UtilitiesToTest_tst.crearAccHasAnalysis(sector.Id, analisis.Id, acc.id, 'g-01');
    aha.arce__RAR_rating_tool_id__c = '2019IRP';
    insert aha;

    final arce__Activity_Split__c act = Arc_Gen_Testing_Util.createActivitySplit('C', 'CB','CBA', '1331', '7', 90, '1');
    act.arce__Account_has_Analysis__c = aha.Id;
    insert act;

    Test.startTest();
    retObj = testObj.getActivitiesWeightByTemplate(aha.Id, new Set<String>());
    System.assertEquals(false, retObj.isEmpty(), 'Return list must not be empty');
    Test.stopTest();
  }


  /**
  *-------------------------------------------------------------------------------
  * @Description Tests a OK case for Arc_GBL_RatingDetailsMapping.getRelativeWeightSum method
  *--------------------------------------------------------------------------------
  * @ Author jose.hijar.contactor@bbva.com
  * @ Date 2021-05-21
  *--------------------------------------------------------------------------------
  **/
  @isTest
  public static void activitiesWeightSumTest() {
    final Arc_GBL_RatingDetailsMapping testObj = new Arc_GBL_RatingDetailsMapping();
    AggregateResult retObj;
    final Account acc = Arc_UtilitiesToTest_tst.crearCuenta('ES', null, null, 'CAONlXcCA_uxyJ402AA_xw');
    insert acc;
    final arce__Analysis__c analisis = Arc_UtilitiesToTest_tst.crearArceAnalysis('TestAna', 'Arce', acc.id);
    analisis.arce__anlys_wkfl_sub_process_type__c = '4';
    insert analisis;
    final arce__Sector__c sector = Arc_UtilitiesToTest_tst.crearSector('g-01', '100', 'g-01', null);
    insert sector;
    final arce__Account_has_Analysis__c aha = Arc_UtilitiesToTest_tst.crearAccHasAnalysis(sector.Id, analisis.Id, acc.id, 'g-01');
    aha.arce__RAR_rating_tool_id__c = '2019IRP';
    insert aha;

    final arce__Activity_Split__c act = Arc_Gen_Testing_Util.createActivitySplit('C', 'CB','CBA', '1331', '7', 90, '1');
    act.arce__Account_has_Analysis__c = aha.Id;
    insert act;

    Test.startTest();
    retObj = testObj.getRelativeWeightSum(aha.Id);
    System.assert(retObj != null, 'Return object must not be null');
    Test.stopTest();
  }

}