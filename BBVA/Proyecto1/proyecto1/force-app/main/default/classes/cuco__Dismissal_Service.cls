/**
* ────────────────────────────────────────────────────────────────────
* Dismissal_Service
* Service class for Dismissal apex ctrl classes
* ────────────────────────────────────────────────────────────────────
* @author      Diego Arias <diego.arias.fernandez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-05-06
* @modified
* @systemLayer
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
public class Dismissal_Service {

    /**
    * @description Private constructor to avoid sonar err
    */
    @TestVisible
    private Dismissal_Service() {}

    /**
    * @description Returns the dismissal base info to initial modal config
    * @param profAnalysisId : Id of the context profitability analysis record
    * @return Map<String, Object>, with needed info
    */
    public static Map<String, Object> getDismissalBaseInfo(Id profAnalysisId) {
        Map<String, Object> retMap = new Map<String, Object>();

        // Get Profitability Analysis Wrapper
        final ProfitabilityAnalysis_Wrapper paWrapper = ProfitabilityAnalysis_Helper.getProfAnalysis(profAnalysisId);

        // Obtain the current active version of general config mtd
        final pa_general_configuration__mdt genConfig = Utils.getGeneralConfiguration();

        // Fill return map in funcion of values
        retMap = Dismissal_Helper.fillDismissalBaseInfo(genConfig, paWrapper);

        return retMap;
    }

    /**
    * @description Do the post save actions on dismissal cmp
    * @param profAnalysisId : Id of the context profitability analysis record
    * @param dismissalComments : Dismissal comments value from the form
    * @param screenShot : String with the html screenshot to audit detail records
    * @return Map<String, Object>, with response
    */
    public static Map<String, Object> doDismissalSave(Id profAnalysisId, String dismissalComments, String screenShot) {
        Map<String, Object> retMap = new Map<String, Object>();

        // Get Profitability Analysis Wrapper
        final ProfitabilityAnalysis_Wrapper paWrapper = ProfitabilityAnalysis_Helper.getProfAnalysis(profAnalysisId);

        // Obtain the current active version of general config mtd
        final pa_general_configuration__mdt genConfig = Utils.getGeneralConfiguration();

        // If has price approval checked and price approval id filled, call price services first and setPADismissal
        // method on ProfitabilityAnalisis_itf after.
        // Otherwise, only do the call setPADismissal method on ProfitabilityAnalisis_itf
        if (genConfig.price_approval_type__c && paWrapper.priceApprovalId != null) {
            retMap = Dismissal_Helper.callPriceDecisionWS(paWrapper, dismissalComments, screenShot);
        } else {
            retMap = Dismissal_Helper.callSetPADismissal(paWrapper, dismissalComments, screenShot);
        }

        return retMap;
    }
}