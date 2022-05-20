/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_GBL_ValidationRating_Corp_Test
* @Author   jose.hijar.contractor@bbva.com
* @Date     Created: 19/05/2021
* @Group    ARCE
* -----------------------------------------------------------------------------------------------
* @Description Tests methods of Arc_GBL_ValidationRating_Service_Corp class
* -----------------------------------------------------------------------------------------------
* @Changes
*
* |19-05-2021 jose.hijar.contractor@bbva.com
*             Class creation.
* -----------------------------------------------------------------------------------------------
*/
@isTest
public with sharing class Arc_GBL_ValidationRating_Corp_Test {

  /**
  *-------------------------------------------------------------------------------
  * @Description Tests a OK case for Arc_GBL_ValidationRating_Service_Corp.validateQualitativeQuestion method
  *--------------------------------------------------------------------------------
  * @ Author jose.hijar.contactor@bbva.com
  * @ Date 2021-05-21
  *--------------------------------------------------------------------------------
  **/
  @isTest
  public static void validateQualitativeQuestionTestOk() {
    final Account acc = Arc_UtilitiesToTest_tst.crearCuenta('ES', null, null, 'CAONlXcCA_uxyJ402AA_xw');
    insert acc;
    final arce__Analysis__c analisis = Arc_UtilitiesToTest_tst.crearArceAnalysis('TestAna', 'Arce', acc.id);
    insert analisis;
    final arce__Sector__c sector = Arc_UtilitiesToTest_tst.crearSector('g-01', '100', 'g-01', null);
    insert sector;
    final arce__Account_has_Analysis__c aha = Arc_UtilitiesToTest_tst.crearAccHasAnalysis(sector.Id, analisis.Id, acc.id, 'g-01');
    insert aha;

    final dyfr__Template__c template = new dyfr__Template__c();
    template.Name = 's-01-100';
    insert template;
    final dyfr__Tab__c tab =new dyfr__Tab__c();
    tab.name = 'Basic Data';
    tab.dyfr__Template__c = template.id;
    tab.dyfr__Tab_Code__c = 'BasicData';
    insert tab;

    Test.StartTest();
    final List<String> ret = Arc_GBL_ValidationRating_Service_Corp.validateQualitativeQuestion(aha.Id,'s-01-100');
    System.assert(ret.isEmpty(), 'object returned must be empty');
    Test.StopTest();
  }

    /**
  *-------------------------------------------------------------------------------
  * @Description Covers a variety of lines skipped during previous tests
  *--------------------------------------------------------------------------------
  * @ Author jose.hijar.contactor@bbva.com
  * @ Date 2021-05-21
  *--------------------------------------------------------------------------------
  **/
  @isTest
  public static void coverSingleLines() {
    Test.StartTest();
    final Arc_GBL_ValidationRating_Service_Corp.CompletionResult obj = new Arc_GBL_ValidationRating_Service_Corp.CompletionResult();
    obj.getResultCompletion();
    System.assert(obj != null, 'Object returned must not be null');

    final Arc_GBL_ValidationRating_Service_Corp.TabCompletionInfo obj2 = new Arc_GBL_ValidationRating_Service_Corp.TabCompletionInfo();
    final Decimal dec1 = obj2.fieldsComplete;
    final Decimal dec2 = obj2.fieldsVisible;
    final Decimal dec3 = obj2.percentComplete;
    final String str1 = obj2.nameTab;
    System.assertEquals(null, dec1, 'dec1 argument will be null due to an unasigned value from TabCompletionInfo Constructor, this may change');
    System.assertEquals(null, dec2, 'dec2 argument will be null due to an unasigned value from TabCompletionInfo Constructor, this may change');
    System.assertEquals(null, dec3, 'dec3 argument will be null due to an unasigned value from TabCompletionInfo Constructor, this may change');
    System.assertEquals(null, str1, 'str1 argument will be null due to an unasigned value from TabCompletionInfo Constructor, this may change');
    Test.StopTest();
  }


  /**
  *-------------------------------------------------------------------------------
  * @Description Tests a OK case for Arc_GBL_ValidationRating_Service_Corp.userValidate method
  *--------------------------------------------------------------------------------
  * @ Author jose.hijar.contactor@bbva.com
  * @ Date 2021-05-21
  *--------------------------------------------------------------------------------
  **/
  @isTest
  public static void userValidateTestOK() {

    Test.startTest();
    final String ret = Arc_GBL_ValidationRating_Service_Corp.userValidate(null);
    System.assert('OK'.equals(ret), 'Expected value OK. This may change as the method implamentation changes too.');
    Test.stopTest();
  }
}