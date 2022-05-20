/**
* ────────────────────────────────────────────────────────────────────
* ProfitabilityList_Ctrl
* Controller class for profitabilityList_cmp Lightning Component
* ────────────────────────────────────────────────────────────────────
* @author      Giancarlo Mastrogiorgio
* @modifiedBy
* @version     1.0
* @created     2021-02-10
* @modified
* @systemLayer Presentation
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
public with sharing class ProfitabilityList_Ctrl {

    /**
    * @description Private constructor to avoid sonar err
    */
    @TestVisible
    private ProfitabilityList_Ctrl() {}

    /**
    * @description Returns the participants info to show on table
    * @param recordId : Id of the context record
    * @param sObjectName : String with the api SObject Name of the context record
    * @return Map<String, Object>, with info of table params and table info
    */
    @AuraEnabled
    public static Map<String, Object> getParticpantHrcy(Id recordId, String sObjectName) {
        try {
            return ProfitabilityList_Service.retriveParticipantHchy(recordId, sObjectName);
        } catch (Exception e) { // NOSONAR
            throw new AuraHandledException(Label.generic_error + ' ' + e.getMessage()); // NOSONAR
        }
    }

    /**
    * @description Check if current user can perform the create action
    * @param recordId : Id of the context record
    * @return Map<String, Object>, with info related to perform the action and err message if needed
    */
    @AuraEnabled
    public static Map<String, Object> handleCreatedAction(Id recordId) {
        try {
            return ProfitabilityList_Service.checkCreatePermissions(recordId);
        } catch (Exception e) { // NOSONAR
            throw new AuraHandledException(Label.generic_error + ' ' + e.getMessage()); // NOSONAR
        }
    }
}