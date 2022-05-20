/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_Geography_TrgHandler
* @Author   ivan.cons.contractor@bbva.com
* @Date     Created: 2020-06-30
* @Group    ARCE
* ------------------------------------------------------------------------------------------------
* @Description: Handler for the arce__Geographic_Split__c object.
* ------------------------------------------------------------------------------------------------
* @Changes
*
* |2020-06-30 ivan.cons.contractor@bbva.com.
*              Class creation.
* ------------------------------------------------------------------------------------------------
*/
public with sharing class Arc_Gen_Geography_TrgHandler extends TriggerHandler_Corp{

  private Map<Id, arce__Geographic_Split__c> newMap;
  private Map<Id, arce__Geographic_Split__c> oldMap;
  private List<arce__Geographic_Split__c> newList;
  private List<arce__Geographic_Split__c> oldList;

  /**
  * --------------------------------------------------------------------------------------
  * @description Triguer constructor
  **/
  public Arc_Gen_Geography_TrgHandler() {
    this.newMap = (Map<Id, arce__Geographic_Split__c>) Trigger.newMap;
    this.oldMap = (Map<Id, arce__Geographic_Split__c>) Trigger.oldMap;
    this.newList = (List<arce__Geographic_Split__c>) Trigger.new;
    this.oldList = (List<arce__Geographic_Split__c>) Trigger.old;
  }

  /**
  * --------------------------------------------------------------------------------------
  * @description After Update trigger method
  * @param newList List of incoming records.
  * @param oldList List of the records before changes.
  * @param newMap Map of incoming records.
  * @param oldMap Map of the records before changes.
  **/
  public override void afterUpdate() {
    checkGeographiesWeightType(newList, newMap, oldMap);
  }

    /**
  * --------------------------------------------------------------------------------------
  * @description After Insert trigger method
  * @param newList List of incoming records.
  * @param newMap Map of incoming records.
  **/
  @SuppressWarnings()
  public override void afterInsert() {
    checkGeographiesWeightType(newList, newMap, null);
  }

  /**
  * --------------------------------------------------------------------------------------
  * @description Checks if a unit percentage type for a geography has been changed and updates all geographies for the same analysis if needed.
  * @param newList List of incoming records.
  * @param newMap Map of incoming records.
  * @param oldMap Map of the records before changes.
  **/
  @SuppressWarnings('PMD.ExcessiveParameterList')
  public static void checkGeographiesWeightType(List<arce__Geographic_Split__c> newList, Map<Id,arce__Geographic_Split__c> newMap, Map<Id,arce__Geographic_Split__c> oldMap) {
    Map<Id,String> geograWeightTypeByActivity = new  Map<Id,String>();
    Set<Id> acttyChangedSet = new Set<Id>();
    for(arce__Geographic_Split__c geogr : newList) {
      if(Trigger.isInsert || geogr.arce__gf_geography_split_per_type__c != oldMap.get(geogr.Id).arce__gf_geography_split_per_type__c) {
        acttyChangedSet.add(geogr.arce__Activity_Split__c);
        geograWeightTypeByActivity.put(geogr.arce__Activity_Split__c,geogr.arce__gf_geography_split_per_type__c);
      }
    }
    if(!geograWeightTypeByActivity.isEmpty()) {
      Arc_Gen_Geographies_Util.updateGeographiesWeightType(geograWeightTypeByActivity, newMap, acttyChangedSet);
    }
  }
}