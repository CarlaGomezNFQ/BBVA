/**
* ────────────────────────────────────────────────────────────────────
* Price_approval_Ctrl
* Controller class for Price_approval_cmp Lightning Component
* ────────────────────────────────────────────────────────────────────
* @author      Miguel Cabrera <miguel.cabrera@bbvaitspain.com>
* @modifiedBy
* @version     1.0
* @created     2021-05-06
* @modified
* @systemLayer Presentation
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@SuppressWarnings('sf:AvoidHardCodedError')
public with sharing class Price_approval_Ctrl {

    /**
    * @description Private constructor to avoid sonar err
    */
    @TestVisible
    private Price_approval_Ctrl() {}

    /**
    * @description Method that do the call to the price negotiation service and retrieve data
    * @param recordId : Id of the related profitability analysis participant
    * @return Map<String, Object>, with the needed info
    */
    @AuraEnabled
    public static Map<String, Object> requestData(Id recordId) {
        Map<String, Object> mapRetRequestData = new Map<String, Object>();
        try {
            mapRetRequestData = Utils.checkAvailableAction('PA_Price_Approval', recordId);
        } catch (Exception e) { // NOSONAR
            throw new AuraHandledException(Label.generic_error + ' ' + e.getMessage()); // NOSONAR
        }

        if(mapRetRequestData.get('success') == false) {
            throw new AuraHandledException((String) mapRetRequestData.get('message'));
        } else {
            try {
                return Price_approval_Service.requestData(recordId);
            } catch (Exception e) { // NOSONAR
                throw new AuraHandledException(Label.generic_error + ' ' + e.getMessage()); // NOSONAR
            }
        }
    }

    /**
    * @description Method that do the call to the price decision service and save data
    * @param recordId : Id of the related profitability analysis participant
    * @return Map<String, Object>, with the needed info
    */
    @AuraEnabled
    public static Map<String,Object> persistData(Map<String,Object> inputAttributes) {
        Map<String, Object> mapRetPersistData = new Map<String, Object>();
        try {
            mapRetPersistData = Utils.checkAvailableAction('PA_Price_Approval', (String)inputAttributes.get('profAnalId'));
        } catch (Exception e) { // NOSONAR
            throw new AuraHandledException(Label.generic_error + ' ' + e.getMessage()); // NOSONAR
        }

        if(mapRetPersistData.get('success') == false) {
            throw new AuraHandledException((String) mapRetPersistData.get('message'));
        } else {
            try {
                return Price_approval_Service.persistData(inputAttributes);
            } catch (Exception e) { // NOSONAR
                throw new AuraHandledException(Label.generic_error + ' ' + e.getMessage()); // NOSONAR
            }
        }
    }
}