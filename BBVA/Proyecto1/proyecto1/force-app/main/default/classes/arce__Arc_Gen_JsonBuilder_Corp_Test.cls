/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_JsonBuilder_Corp_Test
* @Author   BBVA Developers
* @Date     Created: 2020-07-01
* @Group    ARCE
* ------------------------------------------------------------------------------------------------
* @Description test class for Arc_Gen_JsonBuilder_Corp
* ------------------------------------------------------------------------------------------------
* @Changes
*
* |2020-07-01 BBVA Developers.
*              Test Class creation.
* |2020-07-09 BBVA Developers.
*              Test Class refact.
* ------------------------------------------------------------------------------------------------
*/
@isTest
public with sharing class Arc_Gen_JsonBuilder_Corp_Test {
  @TestSetup
  static void testSetup(){
    arce__Analysis__c analisis = Arc_Gen_Testing_Util.createAnalisis();
    insert analisis;
    arce__Account_has_Analysis__c aha = Arc_Gen_Testing_Util.createAccountHasAnalisis(analisis.Id);
    insert aha;
  }
  @isTest
  public static void jsonBuildercorpActtiestest() {
    arce__Account_has_Analysis__c aha =  [Select id from arce__Account_has_Analysis__c limit 1];
    String jsonInput = '{"apiNameObject":"arce__Activity_Split__c","collectionType":"Main_clients"}';
    Test.startTest();
    String jsonOutput = Arc_Gen_JsonBuilder_Corp.getComponents(aha.Id, jsonInput);
    Map<String, Object> jsonToMap = (Map<String, Object>) JSON.deserializeUntyped(jsonOutput);
    System.assertEquals(2, jsonToMap.keySet().size(), 'Error jsonBuilder_Corp_Test');
    Test.stopTest();
  }

  @isTest
  public static void jsonBuildercorpGeotest() {
    arce__Account_has_Analysis__c aha =  [Select id from arce__Account_has_Analysis__c limit 1];
    String jsonInput = '{"apiNameObject":"arce__Geographic_Split__c","collectionType":"Geographic_Splits"}';
    String jsonOutput = Arc_Gen_JsonBuilder_Corp.getComponents(aha.Id, jsonInput);
    Test.startTest();
    Map<String, Object> jsonToMap = (Map<String, Object>) JSON.deserializeUntyped(jsonOutput);
    System.assertEquals(2, jsonToMap.keySet().size(), 'Error jsonBuilder_Corp_Test');
    Test.stopTest();
  }
}