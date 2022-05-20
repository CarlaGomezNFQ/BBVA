/**
* ────────────────────────────────────────────────────────────────────
* Dismissal_Helper
* Helper class for Dismissal_Service apex class
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
public class Dismissal_Helper {

    /**
    * @description Private constructor to avoid sonar err
    */
    @TestVisible
    private Dismissal_Helper() {}

    /**
    * @description Fill the dismissal base info  map
    * @param profAnalysisId : Id of the context profitability analysis record
    * @return Map<String, Object>, with needed info
    */
    public static Map<String, Object> fillDismissalBaseInfo(pa_general_configuration__mdt genConfig, ProfitabilityAnalysis_Wrapper paWrapper) {
        final Map<String, Object> retMap = new Map<String, Object>();
        String typologyMessage;

        switch on paWrapper.typology {
            when 'Renewal' {
                typologyMessage = Label.dismissal_renewal;
            }
            when 'Novation' {
                typologyMessage = Label.dismissal_novation;
            }
            when 'New' {
                typologyMessage = Label.dismissal_new;
            }
            when 'Cancellation' {
                typologyMessage = Label.dismissal_cancellation;
            }
        }

        retMap.put('confirmQuestion', Label.dismissal_confirm_pre + ' ' + typologyMessage + ' ' + Label.dismissal_confirm_post);
        retMap.put('hasPriceApproval', genConfig.price_approval_type__c);
        retMap.put('priceApprovalId', paWrapper.priceApprovalId);

        return retMap;
    }

    /**
    * @description Method to call price decision ws and call setPADismissal method from ProfitabilityAnalysis_Itf, if needed
    * @param paWrapper : ProfitabilityAnalysis_Wrapper with the prof analysis info
    * @param dismissalComments : Dismissal comments value from the form
    * @param screenShot : String with the html screenshot to audit detail records
    * @return Map<String, Object>, with response
    */
    public static Map<String, Object> callPriceDecisionWS(ProfitabilityAnalysis_Wrapper paWrapper, String dismissalComments, String screenShot) {
        Map<String, Object> retMap = new Map<String, Object>();

        // Obtain the current active version of general config mtd
        final pa_general_configuration__mdt genConfig = Utils.getGeneralConfiguration();

        final PriceDecision_Helper pdHelper = new PriceDecision_Helper(paWrapper, genConfig.price_dismissal_decision_id__c, dismissalComments);
        final HttpResponse respPriceDecision = pdHelper.callWs();

        switch on respPriceDecision.getStatusCode() {
            when 200 {
                retMap = callSetPADismissal(paWrapper, dismissalComments, screenShot);
            }
            when else {
                String error = null;
                Map<String,Object> errorMap = (Map<String,Object>) JSON.deserializeUntyped(respPriceDecision.getBody());
                if (errorMap.containsKey('error-message')) {
                    error = (String) errorMap.get('error-message');
                }
                if (error == null) {
                    retMap.put('isSuccess', false);
                    retMap.put('errMessage', Label.price_dismissal_error_generic);
                } else {
                    retMap.put('isSuccess', false);
                    retMap.put('errMessage', Label.price_dismissal_error_detail  + ' ' + error);
                }
            }
        }
        return retMap;
    }

    /**
    * @description Method to call setPADismissal method from ProfitabilityAnalysis_Itf
    * @param paWrapper : ProfitabilityAnalysis_Wrapper with the prof analysis info
    * @param dismissalComments : Dismissal comments value from the form
    * @param screenShot : String with the html screenshot to audit detail records
    * @return Map<String, Object>, with response
    */
    public static Map<String, Object> callSetPADismissal(ProfitabilityAnalysis_Wrapper paWrapper, String dismissalComments, String screenShot) {
        final Map<String, Object> retMap = new Map<String, Object>();
        final Map<String, Object>  retMapPADismissal = ProfitabilityAnalysis_Service.setPADismissalProfAnalysis(paWrapper, dismissalComments, screenShot);
        if ((Boolean) retMapPADismissal.get('success')) {
            retMap.put('isSuccess', true);
            retMap.put('message', retMapPADismissal.get('message'));
        } else {
            retMap.put('isSuccess', false);
            retMap.put('errMessage', retMapPADismissal.get('message'));
        }
        return retMap;
    }
}