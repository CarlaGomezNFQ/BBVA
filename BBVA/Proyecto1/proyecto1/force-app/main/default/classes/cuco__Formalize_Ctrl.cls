/**
* ────────────────────────────────────────────────────────────────────
* Formalize_Ctrl
* Controller class for formalize_cmp Lightning Component
* ────────────────────────────────────────────────────────────────────
* @author      Oscar Gomez <oscar.gomez.arqueros.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-05-09
* @modified
* @systemLayer Presentation
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@SuppressWarnings('PMD.ExcessiveParameterList')
public with sharing class Formalize_Ctrl {

// Private constructor to avoid sonar err
@TestVisible
private Formalize_Ctrl() {}

    /**
    * @description Returns the needed info to display
    * @param profAnalysisId: String with profitability analysis id
    * @return Map<String, Object> with the response
    */
    @AuraEnabled
    public static Map<String, Object> formalize(String profAnalysisId) {
        try {
            return Formalize_Service.formalize(profAnalysisId);
        } catch (Exception e) { // NOSONAR
            throw new AuraHandledException(Label.generic_error + ' ' + e.getMessage()); // NOSONAR
        }
    }

    /**
    * @description Returns the needed info to display
    * @param profAnalysisId : id of profitability analysis
    * @param source : source of operation
    * @param startDate : start date set on component
    * @param expiryDate : expiry date set on component
    * @param comments : comments written by user
    * @param screenShot : copy of current html
    * @return ProfitabilityAnalysis_Wrapper with the response
    */
    @AuraEnabled
    public static Map<String,Object> callService(String profAnalysisId, Date startDate, Date expiryDate, String comments, String screenShot) {
        try {
            final Map<String, Object> mapReturn = Utils.checkAvailableAction('PA_Formalization', profAnalysisId);
            if(mapReturn.get('success') == false) {
                return mapReturn;
            } else {
                final ProfitabilityAnalysis_Wrapper profAnalysis = ProfitabilityAnalysis_Helper.getProfAnalysis(profAnalysisId);
                final Map<String, Object> mapParameters = new Map<String, Object>();
                mapParameters.put('startDate', startDate);
                mapParameters.put('expiryDate', expiryDate);
                mapParameters.put('comments', comments);
                mapParameters.put('screenShot', screenShot);
                return Formalization_Helper.callService(profAnalysis, mapParameters);
            }
        } catch (Exception e) { // NOSONAR
            throw new AuraHandledException(Label.generic_error + ' ' + e.getMessage()); // NOSONAR
        }
    }
}