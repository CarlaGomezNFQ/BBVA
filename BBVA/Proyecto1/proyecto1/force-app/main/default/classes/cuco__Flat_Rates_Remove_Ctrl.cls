/**
* ────────────────────────────────────────────────────────────────────
* Flat_Rates_Remove_Ctrl
* Controller class for Flat_Rates_Remove_Ctrl Lightning Component
* ────────────────────────────────────────────────────────────────────
* @author      Miguel Cabrera <miguel.cabrera@bbvaitspain.com>
* @modifiedBy
* @version     1.0
* @created     2021-05-14
* @modified
* @systemLayer Presentation
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
public with sharing class Flat_Rates_Remove_Ctrl {

    /**
    * @description Private constructor to avoid sonar err
    */
    @TestVisible
    private Flat_Rates_Remove_Ctrl() {}

    /**
    * @description get the profitability flat rate data to init component
    * @param profAnalysisFlatRatesId : context profitability flat rates id
    * @return HttpResponse, with the data response
    */
    @AuraEnabled
    public static Map<String, Object> requestData (Id profAnalysisFlatRatesId) {
        try {
            return Flat_Rates_Remove_Service.getFlatRateToRemove(profAnalysisFlatRatesId);
        } catch (Exception e) { // NOSONAR
            throw new AuraHandledException(Label.generic_error + ' ' + e.getMessage()); // NOSONAR
        }
    }

    /**
    * @description make the actions needed to delete the profitability analysis flat rates
    * @param profAnalysisFlatRates : context profitability_analysis_flat_rates__c record
    * @return HttpResponse, with the response
    */
    @AuraEnabled
    public static Map<String, Object> persistData (profitability_analysis_flat_rates__c profAnalysisFlatRates) {
        try {
            return Flat_Rates_Remove_Service.persistData(profAnalysisFlatRates);
        } catch (Exception e) { // NOSONAR
            throw new AuraHandledException(Label.generic_error + ' ' + e.getMessage()); // NOSONAR
        }
    }
}