/**
* ────────────────────────────────────────────────────────────────────
* ProfitabilityAnalysisFlat_Helper
* Helper class for Flat_Rates_Service apex class
* ────────────────────────────────────────────────────────────────────
* @author      Diego Arias <diego.arias.fernandez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-05-10
* @modified
* @systemLayer
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
public class ProfitabilityAnalysisFlat_Helper {

    /**
    * @description Private constructor to avoid sonar err
    */
    @TestVisible
    private ProfitabilityAnalysisFlat_Helper() {}

    /**
    * @description returns wrapper with Profitability Analysis info
    * @param recordId : profitability analysis Id
    * @return Map<String,Object>, wrapper with Profitability Analysis info
    */
    public static Map<String, Object> getPAFlatRates(Id recordId){
        Map<String, Object> retMap = new Map<String, Object>();

        final ProfitabilityAnalysis_Selector selectorProfAnalys = new ProfitabilityAnalysis_Selector(true);
        final List<profitability_analysis__c> profAnalys = selectorProfAnalys.selectById(new Set<Id>{recordId});

        final ProfitabilityAnalysisFlatRates_Selector selectorFlatRate = new ProfitabilityAnalysisFlatRates_Selector(true);
        final List<profitability_analysis_flat_rates__c> psFlatRates = selectorFlatRate.selectByProfAnalysis(new Set<Id>{recordId});

        if (!psFlatRates.isEmpty()) {
            if (psFlatRates.size() > 1) {
                retMap.put('errorMessage', Label.flat_rates_display_error);
            } else {
                FlatRates_Wrapper flatRates = fillFlatWrapper(psFlatRates[0]);
                retMap.put('flatRates', flatRates);
            }
        }

        retMap.put('success', psFlatRates.size() > 1 ? false : true);
        return retMap;
    }

    /**
    * @description returns Flat Rates Wrapper List
    * @param flat : profitability_analysis_flat_rates__c
    * @return FlatRates_Wrapper
    */
    public static FlatRates_Wrapper fillFlatWrapper(profitability_analysis_flat_rates__c flat){
        FlatRates_Wrapper wrapperFlat = new FlatRates_Wrapper();
        wrapperFlat.priceType = flat.gf_pa_fr_price_type__c;
        wrapperFlat.fixedAmount = flat.gf_pa_fr_fixed_annual_amount__c;
        wrapperFlat.variableAmountDesc = flat.gf_pa_fr_variable_amount_desc__c;
        wrapperFlat.chargeType = flat.gf_pa_fr_charge_type__c;
        wrapperFlat.periodicityChageType = flat.gf_pa_fr_charge_pdicy_type__c;
        wrapperFlat.currencyType = flat.gf_pa_fr_currency_type__c;
        wrapperFlat.chargeDay = flat.gf_pa_fr_charge_date_type__c;
        wrapperFlat.nonWorkingDayChargeMethod = flat.gf_pa_fr_pv_wrkdy_ch_meth_type__c;
        wrapperFlat.accWithoutBalanceMethod = flat.gf_pa_fr_ac_no_bal_method_type__c;
        wrapperFlat.invoceComments = flat.gf_pa_fr_invoice_comments_desc__c;
        wrapperFlat.accountComments = flat.gf_pa_fr_ac_comments_desc__c;
        wrapperFlat.requestType = flat.gf_pa_fr_request_type__c;
        Set<Id> flatIds = new Set<Id>{flat.Id};

        final ProfitabilityAnalysFlatRateAcc_Selector selectorFlatRateAccount = new ProfitabilityAnalysFlatRateAcc_Selector(true);
        final List<profitability_analysis_flatrates_account__c> paFlRtAccList = selectorFlatRateAccount.selectByProfAnalFlatRates(flatIds);

        if (!paFlRtAccList.isEmpty()){
            List<FlatRates_Wrapper.FlatRatesAccount> flatRatesAccountList = new List<FlatRates_Wrapper.FlatRatesAccount>();
            for (profitability_analysis_flatrates_account__c flatRtAcc : paFlRtAccList) {
                FlatRates_Wrapper.FlatRatesAccount fWrap = new FlatRates_Wrapper.FlatRatesAccount();
                fWrap.Id = flatRtAcc.gf_pa_flat_rate_account_id__c;
                fWrap.usePercent = flatRtAcc.gf_pa_fr_ac_use_per__c;
                flatRatesAccountList.add(fWrap);
            }
            wrapperFlat.flatRatesAccountList = flatRatesAccountList;
        }


        ProfitabilityAnalysiFlatRateDp_Selector psFalRtDpSelector = new ProfitabilityAnalysiFlatRateDp_Selector(true);
        List<profitability_analysis_flat_rates_dp__c> lstPsFlatDp = psFalRtDpSelector.selectByProfAnalysisFlatRate(flatIds);


        if (lstPsFlatDp.size() > 0) {

            PSCatalogAttributesFlatRatesDpSelector dpSelector = new PSCatalogAttributesFlatRatesDpSelector(true);
            List<ps_catalog_flat_rates_dp_attribute__c> dpAttributeList = dpSelector.selectAll();

            Map<Id, List<ps_catalog_flat_rates_dp_attribute__c>> mapAttr = new Map<Id, List<ps_catalog_flat_rates_dp_attribute__c>>();

            for (ps_catalog_flat_rates_dp_attribute__c dpa : dpAttributeList) {
                if (mapAttr.containsKey(dpa.gf_psc_fr_dynamic_pricing_id__c)) {
                    mapAttr.get(dpa.gf_psc_fr_dynamic_pricing_id__c).add(dpa);
                } else {
                    mapAttr.put(dpa.gf_psc_fr_dynamic_pricing_id__c, new List<ps_catalog_flat_rates_dp_attribute__c>{dpa});
                }
            }

            List<FlatRates_Wrapper.FlatRatesDP> flatRatesDPList = getFlatRatesDPList(lstPsFlatDp, mapAttr);

            if (flatRatesDPList.size() > 0) {
                wrapperFlat.flatRatesDPList = flatRatesDPList;
            }
        }
        return wrapperFlat;
    }

    /**
    * @description returns Flat Rates Wrapper List
    * @param flat : profitability_sheet_flat_rates__c
    * @param flat : mapAttr
    * @return FlatRates_Wrapper
    */
    public static List<FlatRates_Wrapper.FlatRatesDP> getFlatRatesDPList(List<profitability_analysis_flat_rates_dp__c> lstPsFlatDp, Map<Id, List<ps_catalog_flat_rates_dp_attribute__c>> mapAttr) {
        List<FlatRates_Wrapper.FlatRatesDP> flatRatesDPList = new List<FlatRates_Wrapper.FlatRatesDP>();
        for (profitability_analysis_flat_rates_dp__c psFlatDp : lstPsFlatDp) {
            if (mapAttr.containsKey(psFlatDp.gf_fr_dynamic_pricing_item_id__c)) {
                FlatRates_Wrapper.FlatRatesDP fDp = new FlatRates_Wrapper.FlatRatesDP();
                fDp.Id = psFlatDp.gf_fr_dynamic_pricing_item_id__c;
                fDp.visualizOrder = psFlatDp.gf_fr_dynamic_pricing_item_id__r.gf_psc_fr_dp_visual_ord_number__c;
                List<FlatRates_Wrapper.DPAttribute> lstAtt = new List<FlatRates_Wrapper.DPAttribute>();
                for (ps_catalog_flat_rates_dp_attribute__c attr : mapAttr.get(psFlatDp.gf_fr_dynamic_pricing_item_id__c)) {
                    FlatRates_Wrapper.DPAttribute wrapAtt = new FlatRates_Wrapper.DPAttribute();
                    wrapAtt.Id = attr.gf_psc_atribute_id__c;
                    wrapAtt.canonicalId = attr.gf_psc_dynamic_pricing_atrb_id__c;
                    wrapAtt.visualizOrder = attr.gf_psc_atribute_id__r.gf_psc_atrb_vslztn_ord_number__c;
                    wrapAtt.destinyApiName = attr.gf_psc_atribute_id__r.gf_stored_prps_atrb_field_name__c;
                    wrapAtt.valueTypeName = attr.gf_psc_atribute_id__r.gf_attribute_value_type_name__c;
                    final List<String> decimalLstValuesFlat = new List<String>{'Number', 'Currency', 'Percent'};
                    if (psFlatDp.get(attr.gf_psc_atribute_id__r.gf_stored_prps_atrb_field_name__c) != null) {
                        wrapAtt.value = String.valueOf(psFlatDp.get(attr.gf_psc_atribute_id__r.gf_stored_prps_atrb_field_name__c));
                        if (decimalLstValuesFlat.contains(attr.gf_psc_atribute_id__r.gf_attribute_value_type_name__c)) {
                            final Integer lengthValue = Schema.getGlobalDescribe().get('cuco__profitability_analysis_flat_rates_dp__c').getDescribe().fields.getMap().get('cuco__' + attr.gf_psc_atribute_id__r.gf_stored_prps_atrb_field_name__c).getDescribe().getPrecision();
                            final Integer decimalValue = Schema.getGlobalDescribe().get('cuco__profitability_analysis_flat_rates_dp__c').getDescribe().fields.getMap().get('cuco__' + attr.gf_psc_atribute_id__r.gf_stored_prps_atrb_field_name__c).getDescribe().getScale();
                            wrapAtt.lengthValue = String.valueOf(lengthValue);
                            wrapAtt.decimalValue = String.valueOf(decimalValue);
                            wrapAtt.isDecimal = true;
                        } else {
                            wrapAtt.isDecimal = false;
                        }
                        lstAtt.add(wrapAtt);
                    }
                }
                if (lstAtt.size() > 0) {
                    fDp.dpAttributeList = lstAtt;
                    flatRatesDPList.add(fDp);
                }
            }
        }
        return flatRatesDPList;
    }

    /**
    * @description returns conditions from a Profitability Sheet
    * @param profSheetId : Ids of Profitability Sheet
    * @return Map<String,Set<String>> lwith details
    */
    public static List<profitability_sheet_flat_rates_accounts__c> getFlatAcc(Id profSheetId) {
        PSFlatRatesAccounts_Selector selector = new PSFlatRatesAccounts_Selector(true);
        Set<Id> profSheetSet = new Set<Id>{profSheetId};
        List<profitability_sheet_flat_rates_accounts__c> lstAcc = selector.selectByProfSheet(profSheetSet);
        return lstAcc;
    }
}