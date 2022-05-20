/**
* ────────────────────────────────────────────────────────────────────
* Restudy_Helper
* Helper class for Restudy_Service apex class
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
public class Restudy_Helper {

    /**
    * @description Private constructor to avoid sonar err
    */
    @TestVisible
    private Restudy_Helper() {}

    /**
    * @description Fill the restudy base info map
    * @param profAnalysisId : Id of the context profitability analysis record
    * @return Map<String, Object>, with needed info
    */
    public static Map<String, Object> fillRestudyBaseInfo(ProfitabilityAnalysis_Wrapper paWrapper) {
        final Map<String, Object> retMap = new Map<String, Object>();
        String commentsLabel;
        Boolean requiredComments = false;

        switch on paWrapper.stage {
            when 'Price Approval' {
                commentsLabel = Label.restudy_price_comments;
                requiredComments = true;
            }
            when 'Formalization' {
                commentsLabel = Label.restudy_form_comments;
            }
        }

        retMap.put('commentsLabel', commentsLabel);
        retMap.put('requiredComments', requiredComments);

        return retMap;
    }

    /**
    * @description Method to call price decision ws and call setPADismissal method from ProfitabilityAnalysis_Itf, if needed
    * @param paWrapper : ProfitabilityAnalysis_Wrapper with the prof analysis info
    * @param restudyComments : Restudy comments value from the form
    * @param screenShot : String with the html screenshot to audit detail records
    * @return Map<String, Object>, with response
    */
    public static Map<String, Object> callPriceDecisionRestudyWS(ProfitabilityAnalysis_Wrapper paWrapper, String restudyComments, String screenShot) {
        Map<String, Object> retMap = new Map<String, Object>();

        // Obtain the current active version of general config mtd
        final pa_general_configuration__mdt genConfig = Utils.getGeneralConfiguration();

        final PriceDecision_Helper pdHelper = new PriceDecision_Helper(paWrapper, genConfig.price_restudy_decision_id__c, restudyComments);
        final HttpResponse respPriceDecision = pdHelper.callWs();

        switch on respPriceDecision.getStatusCode() {
            when 200 {
                retMap = callSetPARestudy(paWrapper, restudyComments, screenShot);
            }
            when else {
                String error = null;
                Map<String,Object> errorMap = (Map<String,Object>) JSON.deserializeUntyped(respPriceDecision.getBody());
                if (errorMap.containsKey('error-message')) {
                    error = (String) errorMap.get('error-message');
                }
                if (error == null) {
                    retMap.put('isSuccess', false);
                    retMap.put('errMessage', Label.price_restudy_error_generic);
                } else {
                    retMap.put('isSuccess', false);
                    retMap.put('errMessage', Label.price_restudy_error_detail  + ' ' + error);
                }
            }
        }
        return retMap;
    }

    /**
    * @description Method to call setPARestudy method from ProfitabilityAnalysis_Itf
    * @param paWrapper : ProfitabilityAnalysis_Wrapper with the prof analysis info
    * @param restudyComments : Restudy comments value from the form
    * @param screenShot : String with the html screenshot to audit detail records
    * @return Map<String, Object>, with response
    */
    public static Map<String, Object> callSetPARestudy(ProfitabilityAnalysis_Wrapper paWrapper, String restudyComments, String screenShot) {
        final Map<String, Object> retMap = new Map<String, Object>();
        final Map<String, Object>  retMapPARestudy = ProfitabilityAnalysis_Service.setPARestudyProfAnalysis(paWrapper, restudyComments, screenShot);
        if ((Boolean) retMapPARestudy.get('success')) {
            retMap.put('isSuccess', true);
            retMap.put('message', retMapPARestudy.get('message'));
        } else {
            retMap.put('isSuccess', false);
            retMap.put('errMessage', retMapPARestudy.get('message'));
        }
        return retMap;
    }
}