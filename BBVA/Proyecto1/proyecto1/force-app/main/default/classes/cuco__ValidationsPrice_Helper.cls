/**
* ────────────────────────────────────────────────────────────────────
* ValidationsPrice_Helper
* Helper class for ValidationsPrice_Service
* ────────────────────────────────────────────────────────────────────
* @author      Fernando Elizalde <fernando.elizalde.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-05-14
* @modified
* @systemLayer Business Logic
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@SuppressWarnings('PMD.AvoidGlobalModifier')
global class ValidationsPrice_Helper {

    /**
    * @description Private constructor to avoid sonar err
    */
    @TestVisible
    private ValidationsPrice_Helper() {}

    /**
    * @description check validations for prices
    * @param profAnalysis : ProfitabilityAnalysis_Wrapper
    * @return List<String> with info for passing to the next step
    */
    global static List<String> checkNegValidity(ProfitabilityAnalysis_Wrapper profAnalysis, pa_general_configuration__mdt genConfig) {
        final List<String> returnList = new List<String>();
        if(profAnalysis.priceNegDate != null){
            final Date today = date.today();
            final Date appPriceDate = profAnalysis.priceNegDate.addDays(Integer.valueOf(genConfig.cuco__price_auth_max_validity_term__c));
            if (genConfig.cuco__price_approval_type__c && profAnalysis.typology != 'Cancellation' && today > appPriceDate) {
                returnList.add(Label.error_price_app_validity);
            }
        }

        return returnList;
    }
}