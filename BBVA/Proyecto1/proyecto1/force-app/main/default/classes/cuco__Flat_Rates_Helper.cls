/**
* ────────────────────────────────────────────────────────────────────
* Flat_Rates_Helper
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
public class Flat_Rates_Helper {

    /**
    * @description Private constructor to avoid sonar err
    */
    @TestVisible
    private Flat_Rates_Helper() {}

    /**
    * @description Returns all needed info to flat rates form of prof sheet
    * @param profAnalysisId : Id of the context profitability sheet id record
    * @return Map<String, Object>, with needed info
    */
    public static Map<String, Object> getPSFlatRatesData(Id profSheetId) {
        Map<String, Object> retMap = new Map<String, Object>();
        // Get Flat Rates Wrapper
        final Map<String,Object> mapPSDetails = ProfitabilitySheet_Service.getProfSheetFullDetails(profSheetId);
        if ((Boolean) mapPSDetails.get('success') && mapPSDetails.get('profSheetDetails') != null) {
            retMap.put('success', true);
            final ProfitabilitySheet_Wrapper psWrapp = (ProfitabilitySheet_Wrapper) mapPSDetails.get('profSheetDetails');
            retMap.put('flatRatesWrapper', mapPSDetails);
            if (psWrapp.flatRates != null) {
            // Include field labels to fill form labels
            Map<String, String> labelsMap = Utils.getLabelFields('cuco__profitability_sheet_flat_rates__c');
            retMap.put('fieldLabelsMap', setLabelsEqAsWrapperVariables(labelsMap, 'cuco__profitability_sheet_flat_rates__c'));

            // Include label value from picklist api value
            retMap.put('picklistValuesMap', setPSPicklistValuesFromApi(psWrapp.flatRates, 'cuco__profitability_sheet_flat_rates__c'));

            // Get PyG table data
            retMap.put('pygData', psWrapp.flatRates.flatRatesAccountList == null ? new List<PyG_Wrapper>() : obtainFlatRatesAccountListData(psWrapp.flatRates.flatRatesAccountList));

            // Get conditions
            retMap.put('conditionsData', obtainProfitabilitySheetConditions(psWrapp.conditionsList));
            }
        } else {
            retMap.putAll(mapPSDetails);
        }

        return retMap;
    }

    /**
    * @description Returns all needed info to flat rates form of prof analysis
    * @param profAnalysisId : Id of the context profitability analysis id record
    * @return Map<String, Object>, with needed info
    */
    public static Map<String, Object> getPAFlatRatesData(Id profAnalysisId) {
        Map<String, Object> retMap = new Map<String, Object>();

        // Obtain manage flat rates permissions for current prof analysis and current user
        Map<String, Object> manageFlatRatesMap = Permissions_Service.checkManageFlatRatesPermissions(profAnalysisId);
        retMap.putAll(manageFlatRatesMap);

        // Get raw conditions to configure flat rates button
        retMap.put('rawConditions', ProfitabilityAnalysisCondition_Service.getProfitabilityAnalysisConditions(new Set<Id>{profAnalysisId}));

        // Get Flat Rates Wrapper
        final Map<String,Object> mapPADetails = ProfitabilityAnalysisFlat_Helper.getPAFlatRates(profAnalysisId);
        retMap.put('flatRatesWrapper', mapPADetails);
        if ((Boolean) mapPADetails.get('success') && mapPADetails.get('flatRates') != null) {

            //Get Prof Analysis typology
            final ProfitabilityAnalysis_Selector profAnSelector = new ProfitabilityAnalysis_Selector(true);
            final List<profitability_analysis__c> lstPA = profAnSelector.selectById(new Set<Id>{profAnalysisId});
            retMap.put('typology', lstPA[0].gf_pa_management_type_name__c);

            // Include field labels to fill form labels
            Map<String, String> labelsMap = Utils.getLabelFields('cuco__profitability_analysis_flat_rates__c');
            retMap.put('fieldLabelsMap', setLabelsEqAsWrapperVariables(labelsMap, 'cuco__profitability_analysis_flat_rates__c'));

            // Include label value from picklist api value
            retMap.put('picklistValuesMap', setPAPicklistValuesFromApi((FlatRates_Wrapper) mapPADetails.get('flatRates'), 'cuco__profitability_analysis_flat_rates__c'));

            // Get flat rate id
            final ProfitabilityAnalysisFlatRates_Selector flatRateSelector = new ProfitabilityAnalysisFlatRates_Selector();
            final List<profitability_analysis_flat_rates__c> lstFlatRate = flatRateSelector.selectByProfAnalysis(new Set<Id>{profAnalysisId});
            retMap.put('flatRatesId', lstFlatRate[0].Id);

            // Get PyG table data
            final FlatRates_Wrapper flatRateWrapper = (FlatRates_Wrapper) mapPADetails.get('flatRates');
            retMap.put('pygData', flatRateWrapper.flatRatesAccountList == null ? new List<PyG_Wrapper>() : obtainFlatRatesAccountListData(flatRateWrapper.flatRatesAccountList));

            // Get conditions
            retMap.put('conditionsData', obtainProfitabilityAnalysisConditions(profAnalysisId));
        }
        return retMap;
    }

    /**
    * @description Auxiliar method to obtain needed label values from api picklist values of form
    * @param labelsMap : Map with all object labels
    * @param sObjectName : sObjectName to distinguish in which object search
    * @return Map<String, String>, with labels values
    */
    public static Map<String, String> setLabelsEqAsWrapperVariables(Map<String, String> labelsMap, String sObjectName) {
        final Map<String, String> retMap = new Map<String, String>();
        if (sObjectName == 'cuco__profitability_sheet_flat_rates__c') {
            retMap.put('priceType', labelsMap.get('cuco__gf_ps_fr_price_type__c'));
            retMap.put('fixedAmount', labelsMap.get('cuco__gf_ps_fr_fixed_annual_amount__c'));
            retMap.put('variableAmountDesc', labelsMap.get('cuco__gf_ps_fr_variable_amount_desc__c'));
            retMap.put('chargeType', labelsMap.get('cuco__gf_ps_fr_charge_type__c'));
            retMap.put('periodicityChageType', labelsMap.get('cuco__gf_ps_fr_charge_pdicy_type__c'));
            retMap.put('currencyType', labelsMap.get('cuco__gf_ps_fr_currency_type__c'));
            retMap.put('chargeDay', labelsMap.get('cuco__gf_ps_fr_charge_date_type__c'));
            retMap.put('nonWorkingDayChargeMethod', labelsMap.get('cuco__gf_ps_fr_no_wrkdy_ch_meth_type__c'));
            retMap.put('accWithoutBalanceMethod', labelsMap.get('cuco__gf_ps_fr_ac_no_bal_method_type__c'));
        } else if (sObjectName == 'cuco__profitability_analysis_flat_rates__c') {
            retMap.put('priceType', labelsMap.get('cuco__gf_pa_fr_price_type__c'));
            retMap.put('fixedAmount', labelsMap.get('cuco__gf_pa_fr_fixed_annual_amount__c'));
            retMap.put('variableAmountDesc', labelsMap.get('cuco__gf_pa_fr_variable_amount_desc__c'));
            retMap.put('chargeType', labelsMap.get('cuco__gf_pa_fr_charge_type__c'));
            retMap.put('periodicityChageType', labelsMap.get('cuco__gf_pa_fr_charge_pdicy_type__c'));
            retMap.put('currencyType', labelsMap.get('cuco__gf_pa_fr_currency_type__c'));
            retMap.put('chargeDay', labelsMap.get('cuco__gf_pa_fr_charge_date_type__c'));
            retMap.put('nonWorkingDayChargeMethod', labelsMap.get('cuco__gf_pa_fr_pv_wrkdy_ch_meth_type__c'));
            retMap.put('accWithoutBalanceMethod', labelsMap.get('cuco__gf_pa_fr_ac_no_bal_method_type__c'));
            retMap.put('invoceComments', labelsMap.get('cuco__gf_pa_fr_invoice_comments_desc__c'));
            retMap.put('accountComments', labelsMap.get('cuco__gf_pa_fr_ac_comments_desc__c'));
        }
        return retMap;
    }

    /**
    * @description Auxiliar method to obtain needed label values from api picklist values of form (Profitability sheet)
    * @param flatRatesWrapper : Wrapper with flat rates info to know api picklist value
    * @param sObjectName : sObjectName to distinguish in which api object search
    * @return Map<String, String>, with picklist label value info
    */
    public static Map<String, String> setPSPicklistValuesFromApi(FlatRates_Wrapper flatRatesWrapper, String sObjectName) {
        final Map<String, String> retMap = new Map<String, String>();
        retMap.put('priceType', flatRatesWrapper.priceType != null ? Utils.getPicklistLabel('cuco__profitability_sheet_flat_rates__c','cuco__gf_ps_fr_price_type__c', flatRatesWrapper.priceType) : '');
        retMap.put('chargeType', flatRatesWrapper.chargeType != null ? Utils.getPicklistLabel('cuco__profitability_sheet_flat_rates__c','cuco__gf_ps_fr_charge_type__c', flatRatesWrapper.chargeType) : '');
        retMap.put('periodicityChageType', flatRatesWrapper.periodicityChageType != null ? Utils.getPicklistLabel('cuco__profitability_sheet_flat_rates__c','cuco__gf_ps_fr_charge_pdicy_type__c', flatRatesWrapper.periodicityChageType) : '');
        retMap.put('nonWorkingDayChargeMethod', flatRatesWrapper.nonWorkingDayChargeMethod != null ? Utils.getPicklistLabel('cuco__profitability_sheet_flat_rates__c','cuco__gf_ps_fr_no_wrkdy_ch_meth_type__c', flatRatesWrapper.nonWorkingDayChargeMethod) : '');
        retMap.put('accWithoutBalanceMethod', flatRatesWrapper.accWithoutBalanceMethod != null ? Utils.getPicklistLabel('cuco__profitability_sheet_flat_rates__c','cuco__gf_ps_fr_ac_no_bal_method_type__c', flatRatesWrapper.accWithoutBalanceMethod) : '');
        return retMap;
    }

    /**
    * @description Auxiliar method to obtain needed label values from api picklist values of form (Profitability analysis)
    * @param flatRatesWrapper : Wrapper with flat rates info to know api picklist value
    * @param sObjectName : sObjectName to distinguish in which api object search
    * @return Map<String, String>, with picklist label value info
    */
    public static Map<String, String> setPAPicklistValuesFromApi(FlatRates_Wrapper flatRatesWrapper, String sObjectName) {
        final Map<String, String> retMap = new Map<String, String>();
        retMap.put('priceType', flatRatesWrapper.priceType != null ? Utils.getPicklistLabel('cuco__profitability_analysis_flat_rates__c','cuco__gf_pa_fr_price_type__c', flatRatesWrapper.priceType) : '');
        retMap.put('chargeType', flatRatesWrapper.chargeType != null ? Utils.getPicklistLabel('cuco__profitability_analysis_flat_rates__c','cuco__gf_pa_fr_charge_type__c', flatRatesWrapper.chargeType) : '');
        retMap.put('periodicityChageType', flatRatesWrapper.periodicityChageType != null ? Utils.getPicklistLabel('cuco__profitability_analysis_flat_rates__c','cuco__gf_pa_fr_charge_pdicy_type__c', flatRatesWrapper.periodicityChageType) : '');
        retMap.put('nonWorkingDayChargeMethod', flatRatesWrapper.nonWorkingDayChargeMethod != null ? Utils.getPicklistLabel('cuco__profitability_analysis_flat_rates__c','cuco__gf_pa_fr_pv_wrkdy_ch_meth_type__c', flatRatesWrapper.nonWorkingDayChargeMethod) : '');
        retMap.put('accWithoutBalanceMethod', flatRatesWrapper.accWithoutBalanceMethod != null ? Utils.getPicklistLabel('cuco__profitability_analysis_flat_rates__c','cuco__gf_pa_fr_ac_no_bal_method_type__c', flatRatesWrapper.accWithoutBalanceMethod) : '');
        return retMap;
    }

    /**
    * @description Fill wrapper list from flat rates account info to pyg form table
    * @param lstFlatRatesAccount : Wrapper with flat rates account info
    * @return List<PyG_Wrapper>, with needed info to pyg form table
    */
    public static List<PyG_Wrapper> obtainFlatRatesAccountListData(List<FlatRates_Wrapper.FlatRatesAccount> lstFlatRatesAccount) {
        final List<PyG_Wrapper> retLst = new List<PyG_Wrapper>();
        final Map<Id, Decimal> mapData = new Map<Id, Decimal>();
        for (FlatRates_Wrapper.FlatRatesAccount flatRatesAccount : lstFlatRatesAccount) {
            mapData.put((Id) flatRatesAccount.id, (Decimal) flatRatesAccount.usePercent);
        }

        // Get data from those ids on keySet
        final PSCatalogFlatRatesAccount_Selector psCatFlatRatesAccSelector = new PSCatalogFlatRatesAccount_Selector();
        final List<ps_catalog_flat_rates_account__c> lstPsCatFlatRatesAcc = psCatFlatRatesAccSelector.selectById(mapData.keySet());

        for (ps_catalog_flat_rates_account__c psCatFlatRatesAcc : lstPsCatFlatRatesAcc) {
            retLst.add(new PyG_Wrapper(psCatFlatRatesAcc.Name, mapData.get(psCatFlatRatesAcc.Id)));
        }

        return retLst;
    }

    /**
    * @description Auxiliar method to obtain profitability analysis conditions related to prof analysis record
    * @param profAnalysisId : Id of the context profitability analysis id record
    * @return List<Conditions_Wrapper>, with needed info to condition form table
    */
    public static List<Conditions_Wrapper> obtainProfitabilityAnalysisConditions(Id profAnalysisId) {
        final List<Conditions_Wrapper> retLst = new List<Conditions_Wrapper>();
        final ProfitabilityAnalysisCondition_Selector pacSelector = new ProfitabilityAnalysisCondition_Selector(true);
        final List<profitability_analysis_condition__c> lstPac = pacSelector.selectByProfitabilityAnalysisIdAndSourceType(new Set<Id>{profAnalysisId}, new List<String>{'COMMISSIONS_FLAT'});
        for (profitability_analysis_condition__c pac : lstPac) {
            retLst.add(new Conditions_Wrapper(pac.gf_psc_condition_id__r.Name, pac.gf_pa_cnd_fr_est_op_vol_amount__c));
        }
        return retLst;
    }

    /**
    * @description Auxiliar method to obtain profitability sheet conditions related to prof sheet record
    * @param lstConditions : List of the profitability sheet conditions
    * @return List<Conditions_Wrapper>, with needed info to condition form table
    */
    public static List<Conditions_Wrapper> obtainProfitabilitySheetConditions(List<ProfitabilitySheet_Wrapper.Condition> lstConditions) {
        Set<Id> setIdCondition = new Set<Id>();
        for (ProfitabilitySheet_Wrapper.Condition psWrappCond : lstConditions) {
            if (String.valueOf(psWrappCond.source) == 'COMMISSIONS_FLAT') {
                setIdCondition.add(psWrappCond.id);
            }
        }
        final List<Conditions_Wrapper> retLst = new List<Conditions_Wrapper>();
        final PsCatalogCondition_Selector psCatSelector = new PsCatalogCondition_Selector(true);
        final List<ps_catalog_condition__c> lstPsCatCond = psCatSelector.selectById(setIdCondition);
        for (ps_catalog_condition__c psCatCond : lstPsCatCond) {
            retLst.add(new Conditions_Wrapper(psCatCond.Name));
        }
        return retLst;
    }

    /**
    * @description Wrapper use to return conditions info
    */
    public class Conditions_Wrapper {

        /**
          * @description String variable with ps catalog condition name related
          */
        @AuraEnabled
        public String name {get; set;}

        /**
          * @description Decimal value with estimated operations volume value
          */
        @AuraEnabled
        public Decimal estimatedOpVolume {get; set;}

        /**
          * @description Constructor of Conditions_Wrapper class
          */
        public Conditions_Wrapper(String name, Decimal estimatedOpVolume) {
            this.name = name;
            this.estimatedOpVolume = estimatedOpVolume;
        }

        /**
          * @description Constructor of Conditions_Wrapper class
          */
        public Conditions_Wrapper(String name) {
            this.name = name;
        }
    }

    /**
    * @description Wrapper use to return pyg info
    */
    public class PyG_Wrapper {

        /**
          * @description String variable with ps catalog flat rates account related
          */
        @AuraEnabled
        public String name {get; set;}

        /**
          * @description Decimal value with use percent value from wrapper
          */
        @AuraEnabled
        public Decimal usePercent {get; set;}

        /**
          * @description Constructor of PyG_Wrapper class
          */
        public PyG_Wrapper(String name, Decimal usePercent) {
            this.name = name;
            this.usePercent = usePercent;
        }
    }
}