/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_ActionsPersistence_Data
* @Author   José Luis García    joseluis.garcia4.contractor@bbva.com
* @Date     Created: 2021-02-17
* @Group    ARCE
* ------------------------------------------------------------------------------------------------
* @Description Implements data access functions for the Arc_Gen_ActionsPersistence_Service class.
* ------------------------------------------------------------------------------------------------
* @Changes
*
* |2021-02-11 joseluis.garcia4.contractor@bbva.com
*             Class creation.
* -----------------------------------------------------------------------------------------------
*/
public without sharing class Arc_Gen_ActionsPersistence_Data {
    /**
    *-------------------------------------------------------------------------------
    * @description Empty constructor to avoid sonar major issue.
    --------------------------------------------------------------------------------
    * @author joseluis.garcia4.contractor@bbva.com
    * @date 17/02/2021
    **/
    @TestVisible
    private Arc_Gen_ActionsPersistence_Data() {
    }

    /**
    *-------------------------------------------------------------------------------
    * @description Obtains the rating records of a list of AHAs.
    *-------------------------------------------------------------------------------
    * @author joseluis.garcia4.contractor@bbva.com
    * @date 17/02/2021
    * @param ahaList List of arce__Account_has_Analysis__c of the ARCE.
    * @return A map that matches AHA Ids to rating records.
    **/
    public static Map<Id, arce__rating__c> getRatingsByAhaId(List<arce__Account_has_Analysis__c> ahaList) {
        // Build list of rating IDs.
        final List<String> ratingIds = new List<String>();
        for (arce__Account_has_Analysis__c aha : ahaList) {
            if (aha.arce__ffss_for_rating_id__r != null) {
                ratingIds.add(aha.arce__ffss_for_rating_id__r.arce__rating_id__c);
            }
        }

        // Fetch ratings and build map.
        final Map<Id, arce__rating__c> ratingsById = new Map<Id, arce__rating__c>([
            SELECT arce__rating_id__c, arce__status_type__c FROM arce__rating__c WHERE Id IN: ratingIds]);
        final Map<Id, arce__rating__c> ratingsByAhaId = new Map<Id, arce__rating__c>();
        for (arce__Account_has_Analysis__c aha : ahaList) {
            if (aha.arce__ffss_for_rating_id__r != null && ratingsById.containsKey(aha.arce__ffss_for_rating_id__r.arce__rating_id__c)) {
                ratingsByAhaId.put(aha.Id, ratingsById.get(aha.arce__ffss_for_rating_id__r.arce__rating_id__c));
            }
        }

        return ratingsByAhaId;
    }
}