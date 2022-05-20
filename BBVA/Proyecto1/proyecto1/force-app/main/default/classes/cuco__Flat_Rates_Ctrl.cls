/**
* ────────────────────────────────────────────────────────────────────
* Flat_Rates_Ctrl
* Controller class for flat_rates_cmp Lightning Component
* ────────────────────────────────────────────────────────────────────
* @author      Diego Arias <diego.arias.fernandez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-05-10
* @modified
* @systemLayer
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
public with sharing class Flat_Rates_Ctrl {

    /**
    * @description Private constructor to avoid sonar err
    */
    @TestVisible
    private Flat_Rates_Ctrl() {}

    /**
    * @description Returns the participants info to show on table
    * @param recordId : Id of the context record
    * @return Map<String, Object>, with info of table params and table info
    */
    @AuraEnabled
    public static Map<String, Object> getFlatRatesInfo(Id recordId) {
        try {
            return Flat_Rates_Service.getFlatRatesInfo(recordId);
        } catch (Exception e) { // NOSONAR
            throw new AuraHandledException(Label.generic_error + ' ' + e.getMessage()); // NOSONAR
        }
    }

    /**
    * @description Check if current user have setup flat rates permissions on a profitability analysis
    * @param profAnalysisId : Current profitability analysis record id
    * @return Map<String, Object>, with the response
    */
    @AuraEnabled
    public static Map<String, Object> checkSetupFlatRatesPermissions(Id profAnalysisId) {
        try {
            return Permissions_Service.checkSetupFlatRatesPermissions(profAnalysisId);
        } catch (Exception e) { // NOSONAR
            throw new AuraHandledException(Label.generic_error + ' ' + e.getMessage()); // NOSONAR
        }
    }

    /**
    * @description Check if current user have remove flat rates permissions on a profitability analysis
    * @param profAnalysisId : Current profitability analysis record id
    * @return Map<String, Object> with the response
    */
    @AuraEnabled
    public static Map<String, Object> checkRemoveFlatRatesPermissions(Id profAnalysisId) {
        try {
            return Permissions_Service.checkRemoveFlatRatesPermissions(profAnalysisId);
        } catch (Exception e) { // NOSONAR
            throw new AuraHandledException(Label.generic_error + ' ' + e.getMessage()); // NOSONAR
        }
    }
}