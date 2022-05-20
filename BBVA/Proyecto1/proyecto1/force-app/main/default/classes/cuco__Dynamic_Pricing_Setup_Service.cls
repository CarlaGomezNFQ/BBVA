/**
* ────────────────────────────────────────────────────────────────────
* Dynamic_Pricing_Setup_Service
* Service class for Dynamic_Pricing_Setup_Ctrl
* ────────────────────────────────────────────────────────────────────
* @author     Diego Arias <diego.arias.fernandez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-05-25
* @modified
* @systemLayer
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
public class Dynamic_Pricing_Setup_Service {

    // Private constructor to avoid sonar err
    @TestVisible
    private Dynamic_Pricing_Setup_Service() {}

    /**
    * @description Gets dynamic pricing data to form
    * @param flatRateId : Context record id of flat rates received in the component
    * @return Map<String, Object>, with needed info
    */
    public static Map<String, Object> getDPData(String flatRateId) {
        Map<String, Object> retMap = new Map<String, Object>();

        // 1. Get all cuco__ps_catalog_flat_rates_dp__c records order by visualization number
        final PSCatalogFlatRatesDpSelector psCatalogSelector = new PSCatalogFlatRatesDpSelector(true);
        final List<ps_catalog_flat_rates_dp__c> psCatalogRates = psCatalogSelector.selectAllOrder();
        final Set<Id> setIds = new Set<Id>();
        for(ps_catalog_flat_rates_dp__c psCatalogRate: psCatalogRates) {
            setIds.add(psCatalogRate.Id);
        }

        // 2. Get all ps_catalog_flat_rates_dp_attribute__c records related to each cuco__ps_catalog_flat_rates_dp__c order by visualization number
        final PSCatalogAttributesFlatRatesDpSelector psCatAttDPSelect = new PSCatalogAttributesFlatRatesDpSelector(true);
        final List<ps_catalog_flat_rates_dp_attribute__c> psCatalogAttDP = psCatAttDPSelect.selectDPById(setIds);

        // 3. Get all profitability_analysis_flat_rates_dp__c records related to param flat rate id
        final ProfitabilityAnalysiFlatRateDp_Selector paFlatDpSelector = new ProfitabilityAnalysiFlatRateDp_Selector(true);
        final List<profitability_analysis_flat_rates_dp__c> paFlatDP = paFlatDpSelector.selectByProfAnalysisFlatRate(new Set<Id>{flatRateId});

        final Map<Id, profitability_analysis_flat_rates_dp__c> mapFlatRate = new Map<Id, profitability_analysis_flat_rates_dp__c>();
        for(profitability_analysis_flat_rates_dp__c paFlat: paFlatDP) {
            mapFlatRate.put(paFlat.cuco__gf_fr_dynamic_pricing_item_id__c, paFlat);
        }

        // 4. Call helper method to obtain certain json format to get back to front
        retMap = Dynamic_Pricing_Setup_Helper.formatDataToDynamicSetupForm(psCatalogAttDP, psCatalogRates, mapFlatRate);

        // 5. Get related info of prof analysis flat rate param
        final ProfitabilityAnalysisFlatRates_Selector profAnalFlatRatesSelector = new ProfitabilityAnalysisFlatRates_Selector(true);
        final List<profitability_analysis_flat_rates__c> lstProfAnalFlatRates = profAnalFlatRatesSelector.byIdWithFields(new Set<Id>{flatRateId});
        retMap.put('flatRate', lstProfAnalFlatRates[0]);

        return retMap;
    }

    /**
    * @description Do save actions with the dynamic setup form values
    * @param strValues : String with info for operate
    * @param profAnFlatRateId : String with id of the record
    * @return Map<String,Object>, with DML Responses
    */
    public static Map<String, Object> doSaveActions(String strValues, String profAnFlatRateId) {
        Map<String, Object> retMap = new Map<String, Object>();

        // Get map with attb id as key, attb api name to prof analysis flat rate as value
        final PSCatalogAttributesFlatRatesDpSelector psCatAttDPSelect = new PSCatalogAttributesFlatRatesDpSelector(true);
        final List<ps_catalog_flat_rates_dp_attribute__c> psCatalogAttDP = psCatAttDPSelect.selectAll();
        final Map<Id, String> mapAttbId2Api = new Map<Id, String>();
        for (ps_catalog_flat_rates_dp_attribute__c attb : psCatalogAttDP) {
            mapAttbId2Api.put(attb.cuco__gf_psc_atribute_id__c, attb.cuco__gf_psc_atribute_id__r.cuco__gf_stored_prps_atrb_field_name__c);
        }

        // Do save actions
        retMap = Dynamic_Pricing_Setup_Helper.doSaveActions(strValues, profAnFlatRateId, mapAttbId2Api);

        return retMap;
    }
}