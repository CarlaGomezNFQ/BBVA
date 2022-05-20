/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_JsonBuilder_Corp_Test
* @Author   ivan.cons.contractor@bbva.com
* @Date     Created: 2020-07-09
* @Group    ARCE
* ------------------------------------------------------------------------------------------------
* @Description test class for Arc_Gen_JsonBuilder_Corp
* ------------------------------------------------------------------------------------------------
* @Changes
*
* |2020-07-09 ivan.cons.contractor@bbva.com.
*              Test Class creation.
* 2020-10-21  amunguia@bbva.com the picklist values ​​are updated with the new values
* ------------------------------------------------------------------------------------------------
*/
@isTest
public with sharing class Arc_Gen_Geography_TrgHandler_Test {
  @TestSetup
  static void testSetup(){
    arce__Analysis__c analisis = Arc_Gen_Testing_Util.createAnalisis();
    insert analisis;
    arce__Account_has_Analysis__c aha = Arc_Gen_Testing_Util.createAccountHasAnalisis(analisis.Id);
    insert aha;
    arce__Activity_Split__c activity1 = Arc_Gen_Testing_Util.createActivitySplit();
    activity1.arce__Account_has_Analysis__c = aha.Id;
    arce__Activity_Split__c activity2 = Arc_Gen_Testing_Util.createActivitySplit();
    activity2.arce__Account_has_Analysis__c = aha.Id;
    List<arce__Activity_Split__c> acttiesList = new List<arce__Activity_Split__c>{activity1,activity2};
    insert acttiesList;
    List<arce__Geographic_Split__c> geoList = new List<arce__Geographic_Split__c>();
    geoList.add(Arc_Gen_Testing_Util.createGeographicSplit('ES', 40, activity1.Id, '1'));
    geoList.add(Arc_Gen_Testing_Util.createGeographicSplit('FR', 40, activity2.Id, '1'));
    insert geoList;
  }

  @isTest
  public static void testInsert() {
    arce__Activity_Split__c activity = [Select Id from arce__Activity_Split__c Limit 1];
    Boolean testResult = true;
    arce__Geographic_Split__c geogr = Arc_Gen_Testing_Util.createGeographicSplit('ES', 40, activity.Id, '2');
    Test.startTest();
    insert geogr;
    List<arce__Geographic_Split__c> geoList = [Select Id,arce__gf_geography_split_per_type__c from arce__Geographic_Split__c];
    for(arce__Geographic_Split__c geo : [Select Id,arce__gf_geography_split_per_type__c from arce__Geographic_Split__c]) {
      if(geo.arce__gf_geography_split_per_type__c != '2') {
        testResult = false;
      }
    }
    System.assertEquals(true, testResult, 'Error jsonBuilder_Corp_Test');
    Test.stopTest();
  }

  @isTest
  public static void testUpdate() {
    arce__Geographic_Split__c geogr = [Select Id,arce__gf_geography_split_per_type__c from arce__Geographic_Split__c Limit 1];
    Boolean testResult = true;
    Test.startTest();
    geogr.arce__gf_geography_split_per_type__c = '2';
    update geogr;
    List<arce__Geographic_Split__c> geoList = [Select Id,arce__gf_geography_split_per_type__c from arce__Geographic_Split__c];
    for(arce__Geographic_Split__c geo : [Select Id,arce__gf_geography_split_per_type__c from arce__Geographic_Split__c]) {
      if(geo.arce__gf_geography_split_per_type__c != '2') {
        testResult = false;
      }
    }
    System.assertEquals(true, testResult, 'Error jsonBuilder_Corp_Test');
    Test.stopTest();
  }
}