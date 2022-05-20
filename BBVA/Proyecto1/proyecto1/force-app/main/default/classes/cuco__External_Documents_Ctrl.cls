/**
* ────────────────────────────────────────────────────────────────────
* External_Documents_Ctrl
* Controller class for External_Documents_cmp Lightning Component
* ────────────────────────────────────────────────────────────────────
* @author      Fernando Elizalde <fernando.elizalde.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-05-28
* @modified
* @systemLayer
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
public with sharing class External_Documents_Ctrl {

    /**
    * @description Private constructor to avoid sonar err
    */
    @TestVisible
    private External_Documents_Ctrl() {}

    /**
    * @description Returns the external documents info to show
    * @param recordId : Id of the prof analysis context record
    * @return List<ExternalDocument_Wrapper>, wrapper with external documents info, if have
    */
    @AuraEnabled
    public static List<ExternalDocument_Wrapper> getExternalDocumentInfo(Id recordId) {
        try {
            return External_Documents_Service.getExtDocsInfo(recordId);
        } catch (Exception e) { // NOSONAR
            throw new AuraHandledException(Label.generic_error + ' ' + e.getMessage()); // NOSONAR
        }
    }

    /**
    * @description: Method to do picasso ws call
    * @param operationId : External operation id
    * @param docId : External document id
    * @return Map<String, Object>: with the operation response
    */
    @AuraEnabled
    public static Map<String, Object> getPicassoWSResponse(String operationId, String docId) {
        try {
            return External_Documents_Service.getPicassoWSResponse(operationId, docId);
        } catch (Exception e) { // NOSONAR
            throw new AuraHandledException(Label.generic_error + ' ' + e.getMessage()); // NOSONAR
        }
    }
}