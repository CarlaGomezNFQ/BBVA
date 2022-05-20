/**
* ────────────────────────────────────────────────────────────────────
* Participants_Ctrl
* Controller class for participants_cmp Lightning Component
* ────────────────────────────────────────────────────────────────────
* @author      Diego Arias <diego.arias.fernandez.contractor@bbva.com>
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
public with sharing class Participants_Ctrl {

    /**
    * @description Private constructor to avoid sonar err
    */
    @TestVisible
    private Participants_Ctrl() {}

    /**
    * @description Returns the participants info to show on table
    * @param recordId : Id of the context record
    * @param sObjectName : String with the api SObject Name of the context record
    * @return Map<String, Object>, with info of table params and table info
    */
    @AuraEnabled
    public static Map<String, Object> retrieveParticipantsInfo(Id recordId, String sObjectName) {
        try {
            return Participants_Service.obtainParticipantsInfo(recordId, sObjectName);
        } catch (Exception e) { // NOSONAR
            throw new AuraHandledException(Label.generic_error + ' ' + e.getMessage()); // NOSONAR
        }
    }

    /**
    * @description Check if current user can perform the add action
    * @param recordId : Id of the context record
    * @return Map<String, Object>, with info related to perform the action and err message if needed
    */
    @AuraEnabled
    public static Map<String, Object> handleAddAction(Id recordId) {
        try {
            return Permissions_Service.checkAddPermissions(recordId);
        } catch (Exception e) { // NOSONAR
            throw new AuraHandledException(Label.generic_error + ' ' + e.getMessage()); // NOSONAR
        }
    }

    /**
    * @description Check if current user can perform the remove action
    * @param recordId : Id of the context record
    * @param accountId: Id of the related account id to the context record
    * @return Map<String, Object>, with info related to perform the action and err message if needed
    */
    @AuraEnabled
    public static Map<String, Object> handleRemoveAction(Id recordId, Id accountId) {
        try {
            return Permissions_Service.checkRemovePermissions(recordId, accountId);
        } catch (Exception e) { // NOSONAR
            throw new AuraHandledException(Label.generic_error + ' ' + e.getMessage()); // NOSONAR
        }
    }
}