/**
* ────────────────────────────────────────────────────────────────────
* Request_Ctrl
* Controller class for request_cmp Lightning Component
* ────────────────────────────────────────────────────────────────────
* @author      Oscar Gomez <oscar.gomez.arqueros.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-04-15
* @modified
* @systemLayer Presentation
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
public with sharing class Request_Ctrl {

    // Private constructor to avoid sonar err
    @TestVisible
    private Request_Ctrl() {}

    /**
    * @description Returns the needed info to display on table
    * @param profSheetId : profSheet id
    * @param typology : profSheet typology
    * @return Map<String, Object>, with info of table params and table info
    */
    @AuraEnabled
    public static Map<String, Object> requestData(Id profSheetId, String typology) {
        try {
            return Request_Service.requestData(profSheetId,typology);
        } catch (Exception e) { // NOSONAR
            throw new AuraHandledException(Label.generic_error + ' ' + e.getMessage()); // NOSONAR
        }
    }
}