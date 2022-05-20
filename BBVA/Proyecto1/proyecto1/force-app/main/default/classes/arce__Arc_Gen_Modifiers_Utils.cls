/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_Geographies_Util
* @Author   jorge.diaz-blanco.contractor@bbva.com
* @Date     Created: 2020-09-24
* @Group    ARCE
* ------------------------------------------------------------------------------------------------
* @Description: Utilities for the arce__Geographic_Split__c object.
* ------------------------------------------------------------------------------------------------
* @Changes
*
* |2020-09-24 jorge.diaz-blanco.contractor@bbva.com
*              Class creation.
* ------------------------------------------------------------------------------------------------
*/
global without sharing class Arc_Gen_Modifiers_Utils {
    /**
    * --------------------------------------------------------------------------------------
    * Constructor
    **/
    @TestVisible
    private Arc_Gen_Modifiers_Utils() {}
    /**
    * --------------------------------------------------------------------------------------
    * @description Search modifiers by arce__Account_has_Analysis__c id.
    * @param ahaIdId of arce__Account_has_Analysis__c.
    * @return Returns modifier object
    **/
    global static List<arce__Modifier__c> getModifierInfo(Set<String> parentIdSet) {
        String queryString = 'SELECT ' + Arc_Gen_GenericUtilities.getAllFields('arce__Modifier__c');
        queryString += ' FROM arce__Modifier__c where arce__Account_has_AnalysisId__c IN: parentIdSet';
        List<arce__Modifier__c> lstMod = Database.query(String.escapeSingleQuotes(queryString));
        return lstMod;
    }
}