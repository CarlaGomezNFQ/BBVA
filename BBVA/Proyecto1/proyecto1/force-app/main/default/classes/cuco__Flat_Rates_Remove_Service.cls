/**
* ────────────────────────────────────────────────────────────────────
* Flat_Rates_Remove_Service
* Service class for flat rates remove implementation apex classes
* ────────────────────────────────────────────────────────────────────
* @author      Miguel Cabrera <miguel.cabrera@bbvaitspain.com>
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
public class Flat_Rates_Remove_Service {

    /**
    * @description Private constructor to avoid sonar err
    */
    @TestVisible
    private Flat_Rates_Remove_Service() {}

    /**
    * @description Check if user can do request creation action
    * @param profAnalysisFlatRatesId : Current record Id
    * @return Map<String, Object> : A map with the response
    */
    public static Map<String, Object> getFlatRateToRemove (Id profAnalysisFlatRatesId) {

        final Map<String,Object> mapToReturn = new Map<String,Object>();

        //Obtain the input profitability analysis details
        final ProfitabilityAnalysisFlatRates_Selector profAnalFlatRatesSelector = new ProfitabilityAnalysisFlatRates_Selector(true);
        final List<profitability_analysis_flat_rates__c> lstProfAnalFlatRates = profAnalFlatRatesSelector.byIdWithFields(new Set<Id>{profAnalysisFlatRatesId});

        if (lstProfAnalFlatRates != null && !lstProfAnalFlatRates.isEmpty()) {
            mapToReturn.put('returnedFlatRateSize', lstProfAnalFlatRates.size());
            mapToReturn.put('returnedFlatRate', lstProfAnalFlatRates[0]);
            mapToReturn.put('canRemove', Flat_Rates_Remove_Helper.checkRemoveFlatRatesPermissions(lstProfAnalFlatRates[0].gf_profitablity_analysis_id__c));
            mapToReturn.put('contextProfAnal', Flat_Rates_Remove_Helper.getContextProfAnalysis(lstProfAnalFlatRates[0].gf_profitablity_analysis_id__c));
        }
        return mapToReturn;
    }

    /**
    * @description Do the modifications on bbdd of delete profitability analysis flat rate
    * @param profAnalysisFlatRates : Current profitability_analysis_flat_rates__c record
    * @return Map<String, Object> : A map with the response
    */
    public static Map<String, Object> persistData (profitability_analysis_flat_rates__c profAnalysisFlatRates) {

        final Map<String,Object> mapToReturn = new Map<String,Object>();
        final Map<String,Object> retMap = Flat_Rates_Remove_Helper.checkRequestType(profAnalysisFlatRates);
        if (!(Boolean) retMap.get('isSuccess')) {
            mapToReturn.put('isSuccess', false);
            String lstErrorStr = null;
            for (String error : (List<String>) retMap.get('lstErrMessage')) {
                lstErrorStr = lstErrorStr + error + '; ';
            }
            mapToReturn.put('errorMessage', lstErrorStr);
        } else {
            mapToReturn.put('isSuccess', true);
        }
        return mapToReturn;
    }
}