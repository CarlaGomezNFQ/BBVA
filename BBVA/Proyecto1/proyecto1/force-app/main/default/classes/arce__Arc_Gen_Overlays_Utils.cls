/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_Overlays_Utils
* @Author   amunguia.contractor@bbva.com
* @Date     Created: 2020-12-10
* @Group    ARCE
* ------------------------------------------------------------------------------------------------
* @Description: Utilities for the arce__Overlay__c object.
* ------------------------------------------------------------------------------------------------
* @Changes
*
* |2020-12-10 amunguia.contractor@bbva.com
*              Class creation.
* |2020-12-10 amunguia.contractor@bbva.com Logic is passed to calculate GCP rating.
* ------------------------------------------------------------------------------------------------
*/
global without sharing class Arc_Gen_Overlays_Utils {
    /**
    * --------------------------------------------------------------------------------------
    * Constructor
    **/
    @TestVisible
    private Arc_Gen_Overlays_Utils() {}
    /**
    * --------------------------------------------------------------------------------------
    * @description Search overlays by arce__Account_has_Analysis__c id.
    * @param ahaIdId of arce__Account_has_Analysis__c.
    * @return Returns overlay object
    **/
    global static List<arce__Overlay__c> getOverlaysByAha(Set<String> parentIdSet) {
        String queryString = 'SELECT ' + arce.Arc_Gen_GenericUtilities.getAllFields('arce__Overlay__c');
        queryString += ' FROM arce__Overlay__c where arce__Account_has_AnalysisId__c IN: parentIdSet';
        final List<arce__Overlay__c> lstMod = Database.query(String.escapeSingleQuotes(queryString));
        return lstMod;
    }

    /**
    * @description create overlay record
    * @author amunguia.contractor@bbva.com | 12-14-2020
    * @param String ahaId
    * @return arce__Overlay__c
    **/
    global static arce__Overlay__c createOverlay (String ahaId) {
        return createOverlay(ahaId,'');
    }

    /**
    * @description create overlay record
    * @author amunguia.contractor@bbva.com | 12-14-2020
    * @param String ahaId
    * @param String visibilityControl
    * @return arce__Overlay__c
    **/
    global static arce__Overlay__c createOverlay (String ahaId, String visibilityControl) {
        final arce__Overlay__c result = new arce__Overlay__c();
        result.arce__Account_has_AnalysisId__c = ahaId;
        result.arce__Arc_Gen_Type__c = '1';
        result.arce__Arc_Gen_Overlay_visibility_control__c = visibilityControl;
        return result;
    }
    /**
    * --------------------------------------------------------------------------------------
    * @description Search overlays by arce__Account_has_Analysis__c id.
    * @param ahaIdId of arce__Account_has_Analysis__c.
    * @return Returns overlay object
    **/
    global static Map<Id, List<arce__Overlay__c>> getOverlayMapByAha(Set<Id> parentIdSet) {
        final Map<Id, List<arce__Overlay__c>> result = new Map<Id, List<arce__Overlay__c>>();
        if(Schema.sObjectType.arce__Overlay__c.isAccessible() && !parentIdSet.isEmpty()) {
            String queryString = 'SELECT ' + arce.Arc_Gen_GenericUtilities.getAllFields('arce__Overlay__c');
            queryString += ' FROM arce__Overlay__c where arce__Account_has_AnalysisId__c IN: parentIdSet';
            for(arce__Overlay__c current :Database.query(String.escapeSingleQuotes(queryString))) {
                if(result.containsKey(current.arce__Account_has_AnalysisId__c)) {
                    result.get(current.arce__Account_has_AnalysisId__c).add(current);
                } else {
                    result.put(current.arce__Account_has_AnalysisId__c, new List<arce__Overlay__c>{current});
                }
            }
        }
        return result;
    }
    /**
    * --------------------------------------------------------------------------------------
    * @description update overlay with arce__Financial_Statements__c.
    * @param ffee of arce__Financial_Statements__c.
    * @param overlayObj of arce__Overlay__c.
    * @return Returns overlay object
    **/
    global static arce__Overlay__c updateGCPRating(arce__Financial_Statements__c ffee, arce__Overlay__c overlayObj) {
        overlayObj.arce__Arc_Gen_Parent_Long_Rating_GCP__c = ffee.arce__rating_id__r.arce__rating_long_value_type__c;
        overlayObj.arce__Arc_Gen_Parent_Short_Rating_GCP__c = ffee.arce__rating_id__r.arce__rating_short_value_type__c;
        overlayObj.arce__Arc_Gen_EE_FF_GCP_date__c = ffee.arce__financial_statement_end_date__c;
        overlayObj.arce__Arc_Gen_Total_rating_score_number__c = ffee.arce__total_rating_score_number__c;
        overlayObj.arce__Arc_Gen_Rating_Tool_Id__c = ffee.arce__rar_rating_tool_id__c;
        overlayObj.arce__Arc_Gen_Rating_Id__c = ffee.arce__rating_id__r.arce__rating_id__c;
        overlayObj.arce__Arc_Gen_Financial_Statement_Id__c = ffee.arce__financial_statement_id__c;
        return overlayObj;
    }

    /**
    * @description updateOverlayObject
    * @author amunguia.contractor@bbva.com | 05-17-2021
    * @param String aHasAnalysId
    * @param String cclients
    **/
    global static void updateOverlayObject(String aHasAnalysId, String cclients, arce__Overlay__c overlayObj) {
        final Set<String> cclientsSet = (Set<String>) JSON.deserialize(cclients, Set<String>.class);
        final arce__Account_has_Analysis__c accHasAnalysis = arce.Arc_Gen_AccHasAnalysis_Data.getAccHasAnalysis(new List<String>{aHasAnalysId})[0];
        final List<dyfr__Dependent_value__c> depValueByAha = new List<dyfr__Dependent_value__c>();

        final Map<String, arce__Financial_Statements__c> childWrpMap = arce.Arc_Gen_Account_Locator.getRatingGCPByAccountNumber(new List<String>(cclientsSet));
        for(String child : childWrpMap.keySet()) {
            depValueByAha.add(Arc_Gen_DependentValue_Utils.recalculateRating(childWrpMap.get(child), accHasAnalysis, child));
        }
        if(Schema.sObjectType.arce__Overlay__c.isUpdateable() && !depValueByAha.isEmpty()) {
            overlayObj.arce__Arc_Gen_GCP_Select_VC__c = JSON.serialize(depValueByAha);
            update overlayObj;
        }
    }
}