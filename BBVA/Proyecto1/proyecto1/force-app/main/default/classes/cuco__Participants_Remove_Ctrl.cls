/**
* ────────────────────────────────────────────────────────────────────
* Participants_Remove_Ctrl
* Controller class for participants_remove_cmp Lightning Component
* ────────────────────────────────────────────────────────────────────
* @author      Diego Arias <diego.arias.fernandez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-03-01
* @modified
* @systemLayer Presentation
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
public with sharing class Participants_Remove_Ctrl {

    /**
    * @description Private constructor to avoid sonar err
    */
    @TestVisible
    private Participants_Remove_Ctrl() {}

    /**
    * @description Method that do previous checks to know which stage of modal flow show to the user
    * @param recordId : Id of the related profitability analysis participant
    * @return Map<String, Object>, with the needed info
    */
    @AuraEnabled
    public static Map<String, Object> doPreviousChecks(Id recordId) {
        try {
            return Participants_Service.doPreviousChecksDeletePAP(recordId);
        } catch (Exception e) { // NOSONAR
            throw new AuraHandledException(Label.generic_error + ' ' + e.getMessage()); // NOSONAR
        }
    }

    /**
    * @description Method that do post actions in function of selected in the modal
    * @param recordId : Id of the related profitability analysis participant
    * @param firstWarning : User selection of the first modal stage
    * @return Map<String, Object>, with the needed info
    */
    @AuraEnabled
    public static Map<String, Object> doRemoveActions(Id recordId, String firstWarning) {
        try {
            return Participants_Service.doRemoveActions(recordId, firstWarning);
        } catch (Exception e) { // NOSONAR
            throw new AuraHandledException(Label.generic_error + ' ' + e.getMessage()); // NOSONAR
        }
    }
}