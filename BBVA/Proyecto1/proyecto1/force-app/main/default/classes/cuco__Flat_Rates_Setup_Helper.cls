/**
* ────────────────────────────────────────────────────────────────────
* Flat_Rates_Setup_Helper
* Helper class for Flat_Rates_Setup_Ctrl apex class
* ────────────────────────────────────────────────────────────────────
* @author      Diego Arias <diego.arias.fernandez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-05-15
* @modified
* @systemLayer
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
public class Flat_Rates_Setup_Helper {

    /**
    * @description Private constructor to avoid sonar err
    */
    @TestVisible
    private Flat_Rates_Setup_Helper() {}

    /**
    * @description Auxiliar method to get all needed info to first section form
    * @param profAnalysis : Profitability analysis context record
    * @return Map<String, Object>, with info to fill first section form
    */
    public static Map<String, Object> fillFirstSectionFRSetup(profitability_analysis__c profAnalysis) {
        Map<String, Object> retMap = new Map<String, Object>();

        // Get actual flat rates info
        final ProfitabilityAnalysisFlatRates_Selector paFlatRatesSelector = new ProfitabilityAnalysisFlatRates_Selector(true);
        final List<profitability_analysis_flat_rates__c> lstPAFlatRate = paFlatRatesSelector.selectByProfAnalysis(new Set<Id>{profAnalysis.Id});
        if (!lstPAFlatRate.isEmpty()) {
            retMap.put('paFlatRateId', lstPAFlatRate[0].Id);
            retMap.put('accountComments',lstPAFlatRate[0].gf_pa_fr_ac_comments_desc__c);
            retMap.put('requestedFlatRate', ProfitabilityAnalysisFlat_Helper.fillFlatWrapper(lstPAFlatRate[0]));
        }

        // Get flatRates info in function of prof analysis typology
        if (profAnalysis.gf_pa_management_type_name__c == 'Renewal' || profAnalysis.gf_pa_management_type_name__c == 'Novation') {
            final Map<String,Object> profSheetDetailsMap = ProfitabilitySheet_Service.getProfSheetFullDetails(profAnalysis.gf_profitability_sheet_id__c);
            final ProfitabilitySheet_Wrapper psWrapp = (ProfitabilitySheet_Wrapper) profSheetDetailsMap.get('profSheetDetails');
            retMap.put('currentPSFlatRate', psWrapp.flatRates);
        }

        // Get field labels
        Map<String, String> labelsPAFlatRatesMap = Utils.getLabelFields('cuco__profitability_analysis_flat_rates__c');
        retMap.put('labelsFlatRate', retrieveObjectLabelsAsWrapperVariables(labelsPAFlatRatesMap));

        // Get piclist api-label value
        retMap.put('picklistFlatRate', retrievePicklistValuesAsWrapperVariables());
        return retMap;
    }

    /**
    * @description Auxiliar method to get all needed info to second section form
    * @param profAnalysis : Profitability analysis context record
    * @param paFlatRateId : Id of related profitability analysis flat rates, if have
    * @return Map<String, Object>, with info to fill second section form
    */
    public static Map<String, Object> fillSecondSectionFRSetup(profitability_analysis__c profAnalysis, Id paFlatRateId) {
        Map<String, Object> retMap = new Map<String, Object>();

        // Get records from Profitability Analysis FlatRates Account
        if (paFlatRateId != null) {
            final ProfitabilityAnalysFlatRateAcc_Selector paFlatRateAccSelector = new ProfitabilityAnalysFlatRateAcc_Selector(true);
            final List<profitability_analysis_flatrates_account__c> lstProfAnFlatRatesAcc = paFlatRateAccSelector.selectByProfAnalFlatRates(new Set<Id>{paFlatRateId});
            retMap.put('paFlatRateAcc', lstProfAnFlatRatesAcc);
        }

        // Get record from ps catalog flat rates account
        final PSCatalogFlatRatesAccount_Selector psCatFlatRatesAccSelector = new PSCatalogFlatRatesAccount_Selector(true);
        final List<ps_catalog_flat_rates_account__c> lstPsCatFlatRatesAcc = psCatFlatRatesAccSelector.selectAll(200);
        retMap.put('psCatFlatRatesAcc', lstPsCatFlatRatesAcc);

        return retMap;
    }

    /**
    * @description Auxiliar method to get all needed info to third section form
    * @param profAnalysis : Profitability analysis context record
    * @param lstConditions : Set of conditions ids to filter search
    * @return Map<String, Object>, with info to fill third section form
    */
    public static Map<String, Object> fillThirdSectionFRSetup(profitability_analysis__c profAnalysis, Set<Id> lstConditions) {
        Map<String, Object> retMap = new Map<String, Object>();
        List<FlatCondition_Wrapper> lstFlatCondition = new List<FlatCondition_Wrapper>();

        // Get info of param conditions
        final PsCatalogCondition_Selector psCatCondSelector = new PsCatalogCondition_Selector(true);
        final List<ps_catalog_condition__c> lstPsCatCond = psCatCondSelector.selectById(lstConditions);

        final ProfitabilityAnalysisCondition_Selector pacSelector = new ProfitabilityAnalysisCondition_Selector(true);
        final List<profitability_analysis_condition__c> lstPAC = pacSelector.selectByPsCatalogConditionIdAndSource(profAnalysis.Id, lstConditions, new Set<String>{'COMMISSIONS_FLAT'});

        Map<Id, Decimal> mapConditions = new Map<Id, Decimal>();
        for (profitability_analysis_condition__c pac : lstPAC) {
            mapConditions.put(pac.gf_psc_condition_id__c, pac.gf_pa_cnd_fr_est_op_vol_amount__c);
        }

        for (ps_catalog_condition__c psCatCond : lstPsCatCond) {
            FlatCondition_Wrapper fcw;
            if (mapConditions.get(psCatCond.Id) == null) {
                fcw = new FlatCondition_Wrapper(psCatCond.Id, psCatCond.Name);
            } else {
                fcw = new FlatCondition_Wrapper(psCatCond.Id, psCatCond.Name, mapConditions.get(psCatCond.Id));
            }
            lstFlatCondition.add(fcw);
        }

        retMap.put('lstConditions', lstFlatCondition);
        return retMap;
    }

    /**
    * @description Auxiliar method to obtain needed label values
    * @param labelsMap : Map with all object labels
    * @return Map<String, String>, with labels values
    */
    public static Map<String, String> retrieveObjectLabelsAsWrapperVariables(Map<String, String> labelsMap) {
        final Map<String, String> retMap = new Map<String, String>();
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
        return retMap;
    }

    /**
    * @description Auxiliar method to obtain picklist api-label values
    * @return Map<String, List<Utils.Picklist_Wrapper>>, picklist api-label labels values
    */
    public static Map<String, List<Utils.Picklist_Wrapper>> retrievePicklistValuesAsWrapperVariables() {
        Map<String, List<Utils.Picklist_Wrapper>> retMap = new Map<String, List<Utils.Picklist_Wrapper>>();
        retMap.put('priceType', Utils.getPicklistLabels('cuco__profitability_analysis_flat_rates__c', 'cuco__gf_pa_fr_price_type__c'));
        retMap.put('chargeType', Utils.getPicklistLabels('cuco__profitability_analysis_flat_rates__c', 'cuco__gf_pa_fr_charge_type__c'));
        retMap.put('periodicityChageType', Utils.getPicklistLabels('cuco__profitability_analysis_flat_rates__c', 'cuco__gf_pa_fr_charge_pdicy_type__c'));
        retMap.put('currencyType', Utils.getPicklistLabels('cuco__profitability_analysis_flat_rates__c', 'cuco__gf_pa_fr_currency_type__c'));
        retMap.put('chargeDay', Utils.getPicklistLabels('cuco__profitability_analysis_flat_rates__c', 'cuco__gf_pa_fr_charge_date_type__c'));
        retMap.put('nonWorkingDayChargeMethod', Utils.getPicklistLabels('cuco__profitability_analysis_flat_rates__c', 'cuco__gf_pa_fr_pv_wrkdy_ch_meth_type__c'));
        retMap.put('accWithoutBalanceMethod', Utils.getPicklistLabels('cuco__profitability_analysis_flat_rates__c', 'cuco__gf_pa_fr_ac_no_bal_method_type__c'));
        return retMap;
    }

    /**
    * @description Method to do flat rates save actions
    * @param profAnalysisId : Id of the profitability analysis context record
    * @param mapData : Map with save data from flat rates setup form
    * @return Map<String, Object>, with dml responses
    */
    public static Map<String, Object> doFlatRatesActions(Id profAnalysisId, Map<String, Object> mapData) {
        final Map<String, Object> retMap = new Map<String, Object>();
        final Map<String, Object> flatRatesFormInfo = (Map<String, Object>) mapData.get('flatRates');
        final String priceType = (String) flatRatesFormInfo.get('priceType');

        // Get actual flat rates info (If have)
        final ProfitabilityAnalysisFlatRates_Selector paFlatRatesSelector = new ProfitabilityAnalysisFlatRates_Selector(true);
        final List<profitability_analysis_flat_rates__c> lstPAFlatRate = paFlatRatesSelector.selectByProfAnalysis(new Set<Id>{profAnalysisId});

        final profitability_analysis_flat_rates__c profAnalysisFlatRates = new profitability_analysis_flat_rates__c();

        // Fill with form and needed info
        if (lstPAFlatRate.isEmpty()) {
            profAnalysisFlatRates.gf_pa_fr_request_type__c = 'New';
            profAnalysisFlatRates.gf_profitablity_analysis_id__c = profAnalysisId;
        } else {
            profAnalysisFlatRates.Id = lstPAFlatRate[0].Id;
            if (lstPAFlatRate[0].gf_pa_fr_request_type__c == null) {
                profAnalysisFlatRates.gf_pa_fr_request_type__c = 'Modification';
            }
        }

        if (priceType == 'EF') { // Variable
            profAnalysisFlatRates.gf_pa_fr_variable_amount_desc__c = (String) flatRatesFormInfo.get('variableAmountDesc');
            profAnalysisFlatRates.gf_pa_fr_fixed_annual_amount__c = null;
        } else if (priceType == 'IF') { // Fixed
            profAnalysisFlatRates.gf_pa_fr_fixed_annual_amount__c = Decimal.valueOf(String.valueOf(flatRatesFormInfo.get('fixedAmount')));
            profAnalysisFlatRates.gf_pa_fr_variable_amount_desc__c = null;
        }

        profAnalysisFlatRates.gf_pa_fr_price_type__c = priceType;
        profAnalysisFlatRates.gf_pa_fr_charge_type__c = (String) flatRatesFormInfo.get('chargeType');
        profAnalysisFlatRates.gf_pa_fr_charge_pdicy_type__c = (String) flatRatesFormInfo.get('periodicityChageType');
        profAnalysisFlatRates.gf_pa_fr_currency_type__c = (String) flatRatesFormInfo.get('currencyType');
        profAnalysisFlatRates.gf_pa_fr_charge_date_type__c = (String) flatRatesFormInfo.get('chargeDay');
        profAnalysisFlatRates.gf_pa_fr_pv_wrkdy_ch_meth_type__c = (String) flatRatesFormInfo.get('nonWorkingDayChargeMethod');
        profAnalysisFlatRates.gf_pa_fr_ac_no_bal_method_type__c = (String) flatRatesFormInfo.get('accWithoutBalanceMethod');
        profAnalysisFlatRates.gf_pa_fr_invoice_comments_desc__c = (String) flatRatesFormInfo.get('invoceComments');
        profAnalysisFlatRates.gf_pa_fr_ac_comments_desc__c = (String) flatRatesFormInfo.get('accountComments');

        // Do the DML operation
        final Utils.DML_Wrapper retDMLUpsertPAFlatRate = PAPackage_Service.upsertPAFlatRates(new List<profitability_analysis_flat_rates__c>{profAnalysisFlatRates});
        retMap.put('isSuccess', retDMLUpsertPAFlatRate.isSuccess);
        retMap.put('errMessage', retDMLUpsertPAFlatRate.lstErrMessage.toString());
        if (retDMLUpsertPAFlatRate.isSuccess) {
            retMap.put('profAnalysisFlatRateId', profAnalysisFlatRates.Id);
        }
        return retMap;
    }

    /**
    * @description Method to do flat rates account save actions
    * @param profAnalysisId : Id of the profitability analysis context record
    * @param paFlatRateId : Id of the profitability analysis flat rate related to context record
    * @param mapData : Map with save data from flat rates setup form
    * @return Map<String, Object>, with dml responses
    */
    public static Map<String, Object> doFlatRatesAccActions(Id profAnalysisId, Id paFlatRateId, Map<String, Object> mapData) {
        final Map<String, Object> retMap = new Map<String, Object>();
        final List<Object> flatRatesAccountsFormLst = (List<Object>) mapData.get('flatRatesAccounts');

        // Get records from Profitability Analysis FlatRates Account
        Map<Id, Id> mapAccToFlatRateAcc = new Map<Id, Id>();
        final ProfitabilityAnalysFlatRateAcc_Selector paFlatRateAccSelector = new ProfitabilityAnalysFlatRateAcc_Selector(true);
        final List<profitability_analysis_flatrates_account__c> lstProfAnFlatRatesAcc = paFlatRateAccSelector.selectByProfAnalFlatRates(new Set<Id>{paFlatRateId});
        for (profitability_analysis_flatrates_account__c pafrAcc : lstProfAnFlatRatesAcc) {
            mapAccToFlatRateAcc.put(pafrAcc.gf_pa_flat_rate_account_id__r.Id, pafrAcc.Id);
        }

        final List<profitability_analysis_flatrates_account__c> lstPAFlatRatesAcc2Upsert = new List<profitability_analysis_flatrates_account__c>();
        final List<profitability_analysis_flatrates_account__c> lstPAFlatRatesAcc2Delete = new List<profitability_analysis_flatrates_account__c>();
        for (Object accObj : flatRatesAccountsFormLst) {
            final Map<String, Object> accMap = (Map<String, Object>) accObj;
            final Id accId = (Id) accMap.get('accId');
            final Decimal usePercent = Decimal.valueOf(String.valueOf(accMap.get('usePercent')));
            if (mapAccToFlatRateAcc.get(accId) == null) {
                // Dont exist record
                final profitability_analysis_flatrates_account__c paFlatRateAcc2Insert = new profitability_analysis_flatrates_account__c(
                    gf_pa_fr_ac_use_per__c = usePercent,
                    gf_pa_flat_rate_account_id__c = accId,
                    gf_pa_flat_rate_id__c = paFlatRateId
                );
                lstPAFlatRatesAcc2Upsert.add(paFlatRateAcc2Insert);
            } else {
                // Exits record
                final Id flatRateAccId = mapAccToFlatRateAcc.get(accId);
                final profitability_analysis_flatrates_account__c paFlatRateAcc2Update = new profitability_analysis_flatrates_account__c(
                    Id = flatRateAccId,
                    gf_pa_fr_ac_use_per__c = usePercent
                );
                lstPAFlatRatesAcc2Upsert.add(paFlatRateAcc2Update);
                mapAccToFlatRateAcc.remove(accId);
            }
        }

        // Delete flatRateAccs records which dont come from form data
        if (!mapAccToFlatRateAcc.isEmpty()) {
            for (Id accId : mapAccToFlatRateAcc.keySet()) {
                lstPAFlatRatesAcc2Delete.add(new profitability_analysis_flatrates_account__c(Id = (Id) mapAccToFlatRateAcc.get(accId)));
            }
        }

        // Do DML upsert and delete ops
        if (!lstPAFlatRatesAcc2Upsert.isEmpty()) {
            final Utils.DML_Wrapper retDMLUpsertPAFlatRatesAcc = PAPackage_Service.upsertPAFlatAcc(lstPAFlatRatesAcc2Upsert);
            retMap.put('isSuccess', retDMLUpsertPAFlatRatesAcc.isSuccess);
            retMap.put('errMessage', retDMLUpsertPAFlatRatesAcc.lstErrMessage.toString());
        }

        if (!lstPAFlatRatesAcc2Delete.isEmpty() && (Boolean) retMap.get('isSuccess')) {
            final Utils.DML_Wrapper retDMLDeletePAFlatRatesAcc = PAPackage_Service.deletePAFlatAcc(lstPAFlatRatesAcc2Delete);
            retMap.put('isSuccess', retDMLDeletePAFlatRatesAcc.isSuccess);
            retMap.put('errMessage', retDMLDeletePAFlatRatesAcc.lstErrMessage.toString());
        }
        return retMap;
    }

    /**
    * @description Method to do flat rates condition save actions
    * @param profAnalysisId : Id of the profitability analysis context record
    * @param mapData : Map with save data from flat rates setup form
    * @return Map<String, Object>, with dml responses
    */
    public static Map<String, Object> doFlatRatesCondActions(Id profAnalysisId, Map<String, Object> mapData) {
        final Map<String, Object> retMap = new Map<String, Object>();
        retMap.put('isSuccess', true); // Avoid errs setting isSuccess into true and no records to upsert/delete
        final List<Object> flatRatesConditionLst = (List<Object>) mapData.get('flatRatesConditions');
        List<profitability_analysis_condition__c> lstPAC2Upsert = new List<profitability_analysis_condition__c>();
        List<profitability_analysis_condition__c> lstPAC2Delete = new List<profitability_analysis_condition__c>();

        // Make condition with value
        final Map<Id, Decimal> conditionsMap = new Map<Id, Decimal>();
        for (Object condObj : flatRatesConditionLst) {
            final Map<String, Object> condMap = (Map<String, Object>) condObj;
            conditionsMap.put((Id) condMap.get('conditionId'), String.isEmpty(String.valueOf(condMap.get('estOpVol'))) ? null : Decimal.valueOf(String.valueOf(condMap.get('estOpVol'))));
        }

        // Selected current prof analysis conditions
        final ProfitabilityAnalysisCondition_Selector pacSelector = new ProfitabilityAnalysisCondition_Selector(true);
        final List<profitability_analysis_condition__c> lstPAC = pacSelector.selectBySourceWithEmptyValues(profAnalysisId, new Set<String>{'COMMISSIONS_FLAT'});
        final Map<Id, profitability_analysis_condition__c> mapCondition2PAC = new Map<Id, profitability_analysis_condition__c>();
        for (profitability_analysis_condition__c pac : lstPAC) {
            mapCondition2PAC.put(pac.gf_psc_condition_id__c, pac);
        }

        // Filter which records need to insert or update
        lstPAC2Upsert = filterConditionsRecordsToUpsertPAC(conditionsMap, mapCondition2PAC, profAnalysisId);

        // Delete records on PAC map
        if (!mapCondition2PAC.isEmpty()) {
            lstPAC2Delete = filterConditionsRecordsToDeletePAC(mapCondition2PAC);
        }

        // Update new and current pac with attbs values
        final Map<String, List<ps_catalog_condition_attribute__c>> mapCondAttbs = getAttributesFromConditions(conditionsMap.keySet());
        for (profitability_analysis_condition__c pac2Upsert : lstPAC2Upsert) {
            pac2Upsert = setAttributeFieldsValueToProfAnCond(mapCondAttbs.get(pac2Upsert.gf_psc_condition_id__c), pac2Upsert);
        }

        // Update records
        if (!lstPAC2Upsert.isEmpty()) {
            final Utils.DML_Wrapper retDMLUpsertPAC = PAPackage_Service.upsertExtendedPkg(lstPAC2Upsert);
            retMap.put('isSuccess', retDMLUpsertPAC.isSuccess);
            retMap.put('errMessage', retDMLUpsertPAC.lstErrMessage.toString());
        }

        // Delete records
        if (!lstPAC2Delete.isEmpty() && (Boolean) retMap.get('isSuccess')) {
            final Utils.DML_Wrapper retDMLDeletePAC = PAPackage_Service.deleteExtendedPkg(lstPAC2Delete);
            retMap.put('isSuccess', retDMLDeletePAC.isSuccess);
            retMap.put('errMessage', retDMLDeletePAC.lstErrMessage.toString());
        }

        return retMap;
    }

    /**
    * @description Auxiliar method to filter which records need to insert or update
    * @param conditionsMap : Map of conditions selected from form
    * @param mapCondition2PAC : Map of current conditions related with prof analysis conditions records
    * @param profAnalysisId : Id of the profitability analysis context record
    * @return List<profitability_analysis_condition__c>, with the prof analysis conditions lst ready to upsert
    */
    private static List<profitability_analysis_condition__c> filterConditionsRecordsToUpsertPAC(Map<Id, Decimal> conditionsMap, Map<Id, profitability_analysis_condition__c> mapCondition2PAC, Id profAnalysisId) {
        final List<profitability_analysis_condition__c> lstPAC2Upsert = new List<profitability_analysis_condition__c>();
        for (Id condId : conditionsMap.keySet()) {
            if (mapCondition2PAC.get(condId) == null) {
                lstPAC2Upsert.add(
                    new profitability_analysis_condition__c(
                        gf_psc_condition_id__c = condId,
                        gf_pa_cnd_fr_est_op_vol_amount__c = conditionsMap.get(condId) == null ? null : Double.valueOf(conditionsMap.get(condId)),
                        gf_pa_cond_atrb_source_type__c = 'COMMISSIONS_FLAT',
                        gf_profitablity_analysis_id__c = profAnalysisId
                    )
                );
            } else {
                lstPAC2Upsert.add(
                    new profitability_analysis_condition__c(
                        Id = mapCondition2PAC.get(condId).Id,
                        gf_psc_condition_id__c = mapCondition2PAC.get(condId).gf_psc_condition_id__c,
                        gf_pa_cnd_fr_est_op_vol_amount__c = conditionsMap.get(condId) == null ? null : Double.valueOf(conditionsMap.get(condId)),
                        gf_pa_cond_atrb_source_type__c = 'COMMISSIONS_FLAT',
                        gf_profitablity_analysis_id__c = profAnalysisId
                    )
                );
                mapCondition2PAC.remove(condId);
            }
        }
        return lstPAC2Upsert;
    }

    /**
    * @description Auxiliar method to filter which records need to delete
    * @param mapCondition2PAC : Map of conditions selected from form
    * @return List<profitability_analysis_condition__c>, with the prof analysis conditions lst ready to delete
    */
    private static List<profitability_analysis_condition__c> filterConditionsRecordsToDeletePAC(Map<Id, profitability_analysis_condition__c> mapCondition2PAC) {
        final List<profitability_analysis_condition__c> lstPAC2Delete = new List<profitability_analysis_condition__c>();
        for (profitability_analysis_condition__c pac : mapCondition2PAC.values()) {
            if (pac.gf_pa_cond_atrb_source_type__c != null) {
                lstPAC2Delete.add(pac);
            }
        }
        return lstPAC2Delete;
    }

    /**
    * @description Helper method to get PS Catalog Cond Attributes related to condition params
    * @param setIdConditions : Set of conditions Ids
    * @return Map<String, Object>, with the attbs related to each cond
    */
    private static Map<String, List<ps_catalog_condition_attribute__c>> getAttributesFromConditions(Set<Id> setIdConditionsFlat) {
        final Map<String, List<ps_catalog_condition_attribute__c>> retMap = new Map<String, List<ps_catalog_condition_attribute__c>>();
        final List<ps_catalog_condition_attribute__c> lstCatCondAttbFlat = PsCatalogConditionAttribute_Helper.getConditionAttributesFromConditionIds(setIdConditionsFlat);
        for (ps_catalog_condition_attribute__c psCatCondAttbFlat : lstCatCondAttbFlat) {
            if (retMap.get(psCatCondAttbFlat.gf_psc_condition_id__c) == null) {
                final List<ps_catalog_condition_attribute__c> lstPSCAFlat = new List<ps_catalog_condition_attribute__c>{psCatCondAttbFlat};
                retMap.put(psCatCondAttbFlat.gf_psc_condition_id__c, lstPSCAFlat);
            } else {
                final List<ps_catalog_condition_attribute__c> lstPSCAFlat = retMap.get(psCatCondAttbFlat.gf_psc_condition_id__c);
                lstPSCAFlat.add(psCatCondAttbFlat);
                retMap.put(psCatCondAttbFlat.gf_psc_condition_id__c, lstPSCAFlat);
            }
        }
        return retMap;
    }

    /**
    * @description Helper method to set dynamically falues from attributes to conditions
    * @param lstPsCatCondAttb : List of records which relate attributes with conditions
    * @param mapAttbsInfo : Map with info of each attribute
    * @param currentPAC: Current record to fill with new values
    * @return profitability_analysis_condition__c, fill with the new values
    */
    private static profitability_analysis_condition__c setAttributeFieldsValueToProfAnCond(List<ps_catalog_condition_attribute__c> lstPsCatCondAttbFlat, profitability_analysis_condition__c currentFlatPAC) {
        for (ps_catalog_condition_attribute__c psCatCondAttbFlat : lstPsCatCondAttbFlat) {
            if (psCatCondAttbFlat.gf_psc_ca_exemption_name__c == null) {
                currentFlatPAC.put(String.valueof(psCatCondAttbFlat.gf_psc_atribute_id__r.gf_stored_prps_atrb_field_name__c), null);
            } else {
                Schema.SObjectType schemaType = Schema.getGlobalDescribe().get('cuco__profitability_analysis_condition__c');
                Schema.DescribeSObjectResult schemaSObjectResult = schemaType.getDescribe();
                Schema.DescribeFieldResult fieldResult = schemaSObjectResult.fields.getMap().get(String.valueOf('cuco__' + psCatCondAttbFlat.gf_psc_atribute_id__r.gf_stored_prps_atrb_field_name__c)).getDescribe();
                final String currentType = String.valueOf(fieldResult.getType());
                switch on currentType {
                    when 'CURRENCY', 'DECIMAL' {
                        currentFlatPAC.put(String.valueof(psCatCondAttbFlat.gf_psc_atribute_id__r.gf_stored_prps_atrb_field_name__c),  Decimal.valueof(psCatCondAttbFlat.gf_psc_ca_exemption_name__c));
                    }
                    when 'DOUBLE' {
                        currentFlatPAC.put(String.valueof(psCatCondAttbFlat.gf_psc_atribute_id__r.gf_stored_prps_atrb_field_name__c), Double.valueof(psCatCondAttbFlat.gf_psc_ca_exemption_name__c));
                    }
                    when 'BOOLEAN' {
                        currentFlatPAC.put(String.valueof(psCatCondAttbFlat.gf_psc_atribute_id__r.gf_stored_prps_atrb_field_name__c), Boolean.valueof(psCatCondAttbFlat.gf_psc_ca_exemption_name__c));
                    }
                    when else {
                        currentFlatPAC.put(String.valueof(psCatCondAttbFlat.gf_psc_atribute_id__r.gf_stored_prps_atrb_field_name__c),  String.valueof(psCatCondAttbFlat.gf_psc_ca_exemption_name__c));
                    }
                }
            }
        }
        return currentFlatPAC;
    }

    /**
    * @description Wrapper use to return info on conditions
    */
    public class FlatCondition_Wrapper {

        /**
        * @description String with condition id value
        */
        @AuraEnabled
        public String id {get; set;}

        /**
        * @description String with condition name
        */
        @AuraEnabled
        public String name {get; set;}

        /**
        * @description Decimal variable with estimated operation volume value
        */
        @AuraEnabled
        public Decimal estOpVol {get; set;}

        /**
          * @description First constructor of FlatCondition_Wrapper class
          */
          public FlatCondition_Wrapper(String conditionId, String name, Decimal estOpVol) {
            this.id = conditionId;
            this.name = name;
            this.estOpVol = estOpVol;
        }

        /**
          * @description Second constructor of FlatCondition_Wrapper class
          */
          public FlatCondition_Wrapper(String conditionId, String name) {
            this.id = conditionId;
            this.name = name;
        }

    }
}