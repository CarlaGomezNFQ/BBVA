/**
* ────────────────────────────────────────────────────────────────────
* Restudy_Service
* Service class for Restudy apex ctrl classes
* ────────────────────────────────────────────────────────────────────
* @author      Diego Arias <diego.arias.fernandez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-05-08
* @modified
* @systemLayer
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
public class Restudy_Service {

    /**
    * @description Private constructor to avoid sonar err
    */
    @TestVisible
    private Restudy_Service() {}

    /**
    * @description Returns the restudy base info to initial modal config
    * @param profAnalysisId : Id of the context profitability analysis record
    * @return Map<String, Object>, with needed info
    */
    public static Map<String, Object> getRestudyBaseInfo(Id profAnalysisId) {
        Map<String, Object> retMap = new Map<String, Object>();

        // Get Profitability Analysis Wrapper
        final ProfitabilityAnalysis_Wrapper paWrapper = ProfitabilityAnalysis_Helper.getProfAnalysis(profAnalysisId);

        // Fill return map in funcion of values
        retMap = Restudy_Helper.fillRestudyBaseInfo(paWrapper);

        return retMap;
    }

    /**
    * @description Do the post save actions on restudy cmp
    * @param profAnalysisId : Id of the context profitability analysis record
    * @param restudyComments : Restudy comments value from the form
    * @param screenShot : String with the html screenshot to audit detail records
    * @return Map<String, Object>, with response
    */
    public static Map<String, Object> doRestudySave(Id profAnalysisId, String restudyComments, String screenShot) {
        Map<String, Object> retMap = new Map<String, Object>();

        // Get Profitability Analysis Wrapper
        final ProfitabilityAnalysis_Wrapper paWrapper = ProfitabilityAnalysis_Helper.getProfAnalysis(profAnalysisId);

        // Obtain the current active version of general config mtd
        final pa_general_configuration__mdt genConfig = Utils.getGeneralConfiguration();

        // If has price approval checked, price approval id filled and stage eq Price Approval,
        // call price services first and setPADismissal method on ProfitabilityAnalisis_itf after.
        // Otherwise, only do the call setPADismissal method on ProfitabilityAnalisis_itf
        if (genConfig.price_approval_type__c && paWrapper.priceApprovalId != null && paWrapper.stage == 'Price Approval') {
            retMap = Restudy_Helper.callPriceDecisionRestudyWS(paWrapper, restudyComments, screenShot);
        } else {
            retMap = Restudy_Helper.callSetPARestudy(paWrapper, restudyComments, screenShot);
        }

        return retMap;
    }

}