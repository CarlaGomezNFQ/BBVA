/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_Geographies_Util
* @Author   ivan.cons.contractor@bbva.com
* @Date     Created: 2020-06-30
* @Group    ARCE
* ------------------------------------------------------------------------------------------------
* @Description: Utilities for the arce__Geographic_Split__c object.
* ------------------------------------------------------------------------------------------------
* @Changes
*
* |2020-05-30 ivan.cons.contractor@bbva.com.
*              Class creation.
* ------------------------------------------------------------------------------------------------
*/
public without sharing class Arc_Gen_Geographies_Util {


  /**
  * --------------------------------------------------------------------------------------
  * @description If a geography unit contribution type has been changed, updates all the geographies of the same analysis
  * @param geograWeightTypeByActivity Map of unit contribution by activity split.
  * @param newMap Map of incoming values from de geography trigger.
  * @return Returns de List of geographies queried
  **/
  public static void updateGeographiesWeightType(Map<Id,String> geograWeightTypeByActivity, Map<Id,arce__Geographic_Split__c> newMap, Set<Id> acttyChangedSet) {
    List<arce__Geographic_Split__c> geoToUpdate = new List<arce__Geographic_Split__c>();
    Map<Id,String> geograWeightTypeByaHa = new Map<Id,String>();
    for(arce__Activity_Split__c actty : Arc_Gen_Activities_Util.getAllActivitiesById(geograWeightTypeByActivity.keySet())){
      if(geograWeightTypeByActivity.containsKey(actty.Id)){
        geograWeightTypeByaHa.put(actty.arce__Account_has_Analysis__c,geograWeightTypeByActivity.get(actty.Id));
      }
    }
    for(arce__Geographic_Split__c geo : [SELECT Id,arce__Activity_Split__c, arce__gf_geography_split_per_type__c, arce__Activity_Split__r.arce__Account_has_Analysis__c
                                          FROM arce__Geographic_Split__c
                                          WHERE arce__Activity_Split__r.arce__Account_has_Analysis__c IN: geograWeightTypeByaHa.keySet() AND arce__Activity_Split__c NOT IN: acttyChangedSet]){
      if(geo.arce__gf_geography_split_per_type__c != geograWeightTypeByaHa.get(geo.arce__Activity_Split__r.arce__Account_has_Analysis__c)){
        geo.arce__gf_geography_split_per_type__c = geograWeightTypeByaHa.get(geo.arce__Activity_Split__r.arce__Account_has_Analysis__c);
        geoToUpdate.add(geo);
      }
    }
    update geoToUpdate;
  }

  /**
    * --------------------------------------------------------------------------------------
    * @description Get the total percentage for a given activity split.
    * @param geoList Set with the geographic split Ids.
    * @return Returns the total percentage.
    **/
    public static Decimal getOveralGeographiesPercentage(List<arce__Geographic_Split__c > geoList) {
      Decimal percentage = 0;
      for(arce__Geographic_Split__c geo : geoList){
          percentage += geo.arce__gf_geography_weight_per__c;
      }
      return percentage;
  }
}