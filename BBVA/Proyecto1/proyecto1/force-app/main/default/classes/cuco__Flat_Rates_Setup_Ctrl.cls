/**
* ────────────────────────────────────────────────────────────────────
* Flat_Rates_Setup_Ctrl
* Controller class for flat_rates_setup_cmp Lightning Component
* ────────────────────────────────────────────────────────────────────
* @author      Diego Arias <diego.arias.fernandez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-05-15
* @modified
* @systemLayer
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
public with sharing class Flat_Rates_Setup_Ctrl {

    /**
    * @description Private constructor to avoid sonar err
    */
    @TestVisible
    private Flat_Rates_Setup_Ctrl() {}

    /**
    * @description Retrieve the needed info of flat rates setup to fill form
    * @param recordId : Id of the profitability analysis context record
    * @param lstConditions : List of conditions ids of selected conditions on the previous wizard step
    * @return Map<String, Object>, with info to fill form
    */
    @AuraEnabled
    public static Map<String, Object> getFlatRatesSetupInfo(Id recordId, List<Id> lstConditions) {
        try {
            return Flat_Rates_Service.getFlatRatesSetupInfo(recordId, lstConditions);
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
    public static Map<String, Object> checkSetupFlatRatesSetupPermissions(Id profAnalysisId) {
        try {
            return Permissions_Service.checkSetupFlatRatesPermissions(profAnalysisId);
        } catch (Exception e) { // NOSONAR
            throw new AuraHandledException(Label.generic_error + ' ' + e.getMessage()); // NOSONAR
        }
    }

    /**
    * @description Do save actions with form data
    * @param profAnalysisId : Id of the profitability analysis context record
    * @param mapData : Map with data to save from form
    * @return Map<String, Object>, with info to fill form
    */
    @AuraEnabled
    public static Map<String, Object> doFlatRatesSetupSave(Id profAnalysisId, String mapData) {
        try {
            final Map<String, Object> flatRatesFormInfo = (Map<String, Object>)JSON.deserializeUntyped(mapData);
            return Flat_Rates_Service.doFlatRatesSetupSave(profAnalysisId, flatRatesFormInfo);
        } catch (Exception e) { // NOSONAR
            throw new AuraHandledException(Label.generic_error + ' ' + e.getMessage()); // NOSONAR
        }
    }
}