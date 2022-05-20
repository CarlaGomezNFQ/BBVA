/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_Rating_Utils
* @Author   amunguia.contractor@bbva.com
* @Date     Created: 2021-05-13
* @Group    ARCE
* ------------------------------------------------------------------------------------------------
* @Description: Utilities for the Arc_Gen_Rating_Utils object.
* ------------------------------------------------------------------------------------------------
* @Changes
*
* |2021-05-13 amunguia.contractor@bbva.com
*              Class creation.
* ------------------------------------------------------------------------------------------------
*/
public with sharing class Arc_Gen_Rating_Utils {
    /**
    * --------------------------------------------------------------------------------------
    * Constructor
    **/
    @TestVisible
    private Arc_Gen_Rating_Utils() {}
    /**
    * --------------------------------------------------------------------------------------
    * @description Search overlays by arce__Account_has_Analysis__c id.
    * @param ahaIdId of arce__Account_has_Analysis__c.
    * @return Returns overlay object
    **/
    public static List<arce__rating_variables_detail__c> getRatingDetByAha(Set<String> parentIdSet, Set<String> modifierType) {
        List<arce__rating_variables_detail__c> lstMod = new List<arce__rating_variables_detail__c>();
        if(Schema.sObjectType.arce__rating_variables_detail__c.isAccessible() && !parentIdSet.isEmpty()) {
            String queryString = 'SELECT ' + Arc_Gen_Corporate_Utils.getAllFields('arce__rating_variables_detail__c');
            queryString += ' FROM arce__rating_variables_detail__c where arce__account_has_analysis_id__c IN: parentIdSet';
            if(!modifierType.isEmpty()) {
                queryString += ' AND arce__rating_modifier_adj_type__c IN: modifierType';
            }
            lstMod = Database.query(String.escapeSingleQuotes(queryString));
        }
        return lstMod;
    }
}