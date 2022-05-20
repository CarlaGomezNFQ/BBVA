/**
  * ____________________________________________________________________________
  * Profitability Sheet Helper
  * Helper class for ProfitabilitySheet_Service
  * ____________________________________________________________________________
  * @author      Torcuato Tejada <torcuato.tejada.contractor@bbva.com>
  * @modifiedBy
  * @version     1.0
  * @created     2021-02-18
  * @modified
  * @systemLayer Service
  * ____________________________________________________________________________
  * @changes
  *
  * ____________________________________________________________________________
  */
  @SuppressWarnings('sf:DMLWithoutSharingEnabled')public class ProfitabilitySheet_Helper {
    /**
    * @description private constructor.
    */
    @TestVisible
    private ProfitabilitySheet_Helper() {
    }

    /**
    * @description returns wrapper with Profitability Sheet info
    * @param profSheetId : profitability sheet Id
    * @param psParticipants : List of profitability_sheet_participant__c
    * @param psConditions : List of profitability_sheet_condition__c
    * @return Map<String,Object>, wrapper with Profitability Sheet info
    */
    public static Map<String, Object> getProfSheetFullDetails(Id profSheetId) {

        Map<String, Object> res = new Map<String, Object>();
        final Set<Id> profSheetIds = new Set<Id>{profSheetId};

        final ProfitabilitySheet_Selector selectorProfSheet = new ProfitabilitySheet_Selector(true);
        final List<profitability_sheet__c> profSheets = selectorProfSheet.selectById(profSheetIds);

        final ProfitabilitySheetParticipant_Selector selectorParticipants = new ProfitabilitySheetParticipant_Selector(true);
        final List<profitability_sheet_participant__c> psParticipants = selectorParticipants.selectByProfSheet(profSheetIds);

        final PSFlatRates_Selector selectorFlatRate = new PSFlatRates_Selector(true);
        final List<profitability_sheet_flat_rates__c> psFlatRates = selectorFlatRate.selectByProfSheet(profSheetIds);

        if (profSheets.size() == 0 || psParticipants.size() == 0) {
            res.put('success', false);
            res.put('errorMessage', Label.no_ps_details);
        } else if (psFlatRates.size() > 1) {
            res.put('success', false);
            res.put('errorMessage', Label.ps_flat_rates_error);
        } else {
            final List<profitability_sheet_condition__c> psConditions = ProfitabilitySheetCondition_Service.getAllConditionsFromProfitabilitySheet(profSheetIds);
            final List<ps_catalog_condition_attribute__c> conditionAttributes = PsCatalogConditionAttribute_Service.getConditionAttributesFromProfitabilitySheetConditions(psConditions);
            ProfitabilitySheet_Wrapper wrapper = new ProfitabilitySheet_Wrapper();
            List<ProfitabilitySheet_Wrapper.Participant> participantsList = new List<ProfitabilitySheet_Wrapper.Participant>();
            wrapper.id = profSheets[0].Id;
            wrapper.code = profSheets[0].gf_profitability_sheet_id__c;
            wrapper.name = profSheets[0].Name;
            wrapper.groupId = profSheets[0].participant_id__c;
            wrapper.status = profSheets[0].gf_prftbly_sheet_stt_desc__c;
            wrapper.branchCode = ProfitabilityAnalysis_Service.getBranchCode(profSheets[0].Id);
            wrapper.segment = profSheets[0].gf_prftbly_sheet_seg_type_name__c;
            wrapper.startDate = profSheets[0].gf_prftbly_sheet_start_date__c;
            wrapper.endDate = profSheets[0].gf_prftbly_sheet_end_date__c;
            wrapper.ownerCode = ProfitabilityAnalysis_Service.obtainUserInfo(profSheets[0].OwnerId);
            wrapper.isSpecificContractsScope = profSheets[0].gf_all_ct_apply_cond_ind_type__c;
            wrapper.isForcedManualManagement = profSheets[0].gf_ps_forced_mf_mgmt_ind_type__c;

            for (profitability_sheet_participant__c participant : psParticipants){
                ProfitabilitySheet_Wrapper.Participant wrapperParticipant = new ProfitabilitySheet_Wrapper.Participant();
                wrapperParticipant.id = participant.participant_id__c;
                participantsList.add(wrapperParticipant);
            }
            wrapper.participantsList = participantsList;
            wrapper.conditionsList = getConditionsWrapper(psConditions, conditionAttributes);

            /* logic for packages */
            final List<Package_Wrapper> lstPackages = ProfitabilitySheet_Helper.includePackages(wrapper);
            if(!lstPackages.isEmpty()) {
                wrapper.packagesList = lstPackages;
            }

            if (psFlatRates.size() == 1){
                wrapper.flatRates = fillFlatWrapper(psFlatRates[0]);
            }

            res.put('success', true);
            res.put('profSheetDetails', wrapper);
        }
        return res;
    }

    /**
    * @description returns wrapper with Profitability Sheet Conditions info
    * @param psConditions : List of profitability_sheet_condition__c
    * @param conditionAttributes : List of ps_catalog_condition_attribute__c
    * @return ProfitabilitySheet_Wrapper.Condition, wrapper with Profitability Sheet Conditions
    */
    public static List<ProfitabilitySheet_Wrapper.Condition> getConditionsWrapper(List<profitability_sheet_condition__c> psConditions, List<ps_catalog_condition_attribute__c> conditionAttributes){

        List<ProfitabilitySheet_Wrapper.Condition> conditionsWrapper = new List<ProfitabilitySheet_Wrapper.Condition>();

        for (profitability_sheet_condition__c condition : psConditions){
            ProfitabilitySheet_Wrapper.Condition conditionWrapper = new ProfitabilitySheet_Wrapper.Condition();
            conditionWrapper.id = condition.gf_psc_condition_id__c;
            conditionWrapper.familyId = condition.gf_psc_condition_id__r.gf_psc_family_id__c;
            conditionWrapper.source = condition.gf_ps_cond_atrb_srce_type_name__c;
            conditionWrapper.sourceCode = condition.gf_ps_source_cust_package_id__c;
            conditionWrapper.attributesList = getAttributesWrapper(condition, conditionAttributes);
            conditionsWrapper.add(conditionWrapper);
        }
        return conditionsWrapper;
    }

    /**
    * @description returns wrapper with Profitability Sheet Condition Attributes info
    * @param condition : profitability_sheet_condition__c
    * @param conditionAttributes : List of ps_catalog_condition_attribute__c
    * @return ProfitabilitySheet_Wrapper.Attribute, wrapper with Profitability Sheet Condition Attributes info
    */
    public static List<ProfitabilitySheet_Wrapper.Attribute> getAttributesWrapper(profitability_sheet_condition__c condition, List<ps_catalog_condition_attribute__c> conditionAttributes){

        List<ProfitabilitySheet_Wrapper.Attribute> attributesWrapper = new List<ProfitabilitySheet_Wrapper.Attribute>();

        for (ps_catalog_condition_attribute__c conditionAttribute : conditionAttributes){

            if (conditionAttribute.gf_psc_condition_id__c == condition.gf_psc_condition_id__c && conditionAttribute.gf_psc_atribute_id__r.gf_psc_atrb_visible_ind_type__c){
                ProfitabilitySheet_Wrapper.Attribute attributeWrapper = new ProfitabilitySheet_Wrapper.Attribute();
                String attrFieldName = conditionAttribute.gf_psc_atribute_id__r.gf_stored_fnl_atrb_field_name__c;
                String attributeType = conditionAttribute.gf_psc_atribute_id__r.gf_attribute_value_type_name__c;

                if (condition.get(attrFieldName) != null) {
                    attributeWrapper.id = conditionAttribute.gf_psc_atribute_id__c;
                    attributeWrapper.condAttrId = conditionAttribute.Id;
                    attributeWrapper.canonicalId = conditionAttribute.gf_psc_condition_attribute_id__c;
                    if (attributeType == 'List'){
                        String fieldName = (attrFieldName.substring(0, 6) != 'cuco__') ? 'cuco__' + attrFieldName : attrFieldName;
                        attributeWrapper.value = Utils.getPicklistLabel('cuco__profitability_sheet_condition__c', fieldName, String.valueOf(condition.get(attrFieldName)));
                    } else{
                        attributeWrapper.value = String.valueOf(condition.get(attrFieldName));
                    }
                    attributesWrapper.add(attributeWrapper);
                }
            }
        }
        return attributesWrapper;
    }

    /**
    * @description returns Flat Rates Wrapper List
    * @param flat : profitability_sheet_flat_rates__c
    * @return FlatRates_Wrapper
    */
    public static FlatRates_Wrapper fillFlatWrapper(profitability_sheet_flat_rates__c flat){

        FlatRates_Wrapper wrapperFlat = new FlatRates_Wrapper();
        wrapperFlat.priceType = flat.gf_ps_fr_price_type__c;
        wrapperFlat.fixedAmount = flat.gf_ps_fr_fixed_annual_amount__c;
        wrapperFlat.variableAmountDesc = flat.gf_ps_fr_variable_amount_desc__c;
        wrapperFlat.chargeType = flat.gf_ps_fr_charge_type__c;
        wrapperFlat.periodicityChageType = flat.gf_ps_fr_charge_pdicy_type__c;
        wrapperFlat.currencyType = flat.gf_ps_fr_currency_type__c;
        wrapperFlat.chargeDay = flat.gf_ps_fr_charge_date_type__c;
        wrapperFlat.nonWorkingDayChargeMethod = flat.gf_ps_fr_no_wrkdy_ch_meth_type__c;
        wrapperFlat.accWithoutBalanceMethod = flat.gf_ps_fr_ac_no_bal_method_type__c;
        Set<Id> flatIds = new Set<Id>{flat.Id};

        final PSFlatRatesAccounts_Selector selectorFlatRateAccount = new PSFlatRatesAccounts_Selector(true);
        final List<profitability_sheet_flat_rates_accounts__c> psFlRtAccList = selectorFlatRateAccount.selectByFlatRateId(flatIds);

        if (!psFlRtAccList.isEmpty()){
            List<FlatRates_Wrapper.FlatRatesAccount> flatRatesAccountList = new List<FlatRates_Wrapper.FlatRatesAccount>();
            for (profitability_sheet_flat_rates_accounts__c flatRtAcc : psFlRtAccList){
                FlatRates_Wrapper.FlatRatesAccount fWrap = new FlatRates_Wrapper.FlatRatesAccount();
                fWrap.Id = flatRtAcc.gf_psc_flat_rate_ac_svc_id__c;
                fWrap.usePercent = flatRtAcc.gf_ps_fr_ac_use_per__c;
                flatRatesAccountList.add(fWrap);
            }
            wrapperFlat.flatRatesAccountList = flatRatesAccountList;
        }
        PSFlatRatesDP_Selector psFalRtDpSelector = new PSFlatRatesDP_Selector(true);
        List<profitability_sheet_flat_rates_dp__c> lstPsFlatDp = psFalRtDpSelector.selectByFlatId(flatIds);

        if (lstPsFlatDp.size() > 0){
            PSCatalogAttributesFlatRatesDpSelector dpSelector = new PSCatalogAttributesFlatRatesDpSelector(true);
            List<ps_catalog_flat_rates_dp_attribute__c> dpAttributeList = dpSelector.selectAll();
            Map<Id, List<ps_catalog_flat_rates_dp_attribute__c>> mapAttr = new Map<Id, List<ps_catalog_flat_rates_dp_attribute__c>>();

            for (ps_catalog_flat_rates_dp_attribute__c dpa : dpAttributeList){
                if (mapAttr.containsKey(dpa.gf_psc_fr_dynamic_pricing_id__c)){
                    mapAttr.get(dpa.gf_psc_fr_dynamic_pricing_id__c).add(dpa);
                } else{
                    mapAttr.put(dpa.gf_psc_fr_dynamic_pricing_id__c, new List<ps_catalog_flat_rates_dp_attribute__c>{dpa});
                }
            }

            List<FlatRates_Wrapper.FlatRatesDP> flatRatesDPList =  getFlatRatesDPList(lstPsFlatDp, mapAttr);

            if (flatRatesDPList.size() > 0){
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
    public static List<FlatRates_Wrapper.FlatRatesDP> getFlatRatesDPList(List<profitability_sheet_flat_rates_dp__c> lstPsFlatDp,Map<Id, List<ps_catalog_flat_rates_dp_attribute__c>>  mapAttr){
        List<FlatRates_Wrapper.FlatRatesDP> flatRatesDPList = new List<FlatRates_Wrapper.FlatRatesDP>();
        for (profitability_sheet_flat_rates_dp__c psFlatDp : lstPsFlatDp){
            if (mapAttr.containsKey(psFlatDp.gf_dynamic_pricing_item_id__c)){
                FlatRates_Wrapper.FlatRatesDP fDp = new FlatRates_Wrapper.FlatRatesDP();
                fDp.Id = psFlatDp.gf_dynamic_pricing_item_id__c;
                fDp.visualizOrder = psFlatDp.gf_dynamic_pricing_item_id__r.gf_psc_fr_dp_visual_ord_number__c;
                List<FlatRates_Wrapper.DPAttribute> lstAtt = new List<FlatRates_Wrapper.DPAttribute>();
                for (ps_catalog_flat_rates_dp_attribute__c attr : mapAttr.get(psFlatDp.gf_dynamic_pricing_item_id__c)){
                    FlatRates_Wrapper.DPAttribute wrapAtt = new FlatRates_Wrapper.DPAttribute();
                    wrapAtt.Id = attr.gf_psc_atribute_id__c;
                    wrapAtt.canonicalId = attr.gf_psc_dynamic_pricing_atrb_id__c;
                    wrapAtt.visualizOrder = attr.gf_psc_atribute_id__r.gf_psc_atrb_vslztn_ord_number__c;
                    wrapAtt.destinyApiName = attr.gf_psc_atribute_id__r.gf_stored_prps_atrb_field_name__c;
                    wrapAtt.valueTypeName = attr.gf_psc_atribute_id__r.gf_attribute_value_type_name__c;
                    final List<String> decimalLstValuesFlat = new List<String>{'Number', 'Currency', 'Percent'};
                    if (psFlatDp.get(attr.gf_psc_atribute_id__r.gf_stored_fnl_atrb_field_name__c) != null){
                        wrapAtt.value = String.valueOf(psFlatDp.get(attr.gf_psc_atribute_id__r.gf_stored_fnl_atrb_field_name__c));
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
                if (lstAtt.size() > 0){
                    fDp.dpAttributeList = lstAtt;
                    flatRatesDPList.add(fDp);
                }
            }
        }
        return flatRatesDPList;
    }

    /**
    * @description method to implement the logic for packages
    * @param wrapper : ProfitabilitySheet_Wrapper
    * @return List<Package_Wrapper>
    */
    public static List<Package_Wrapper> includePackages(ProfitabilitySheet_Wrapper wrapper) {
        final List<Package_Wrapper> lstPackages = new List<Package_Wrapper>();
        final Set<String> packageTypes = new Set<String>{'COMMERCIAL_PACKAGE','GIP_PACKAGE','FORFAIT'};
        final List<String> sources = new List<String>(packageTypes);

        /* get extended packages info from condition */
        final Map<String,Set<String>> extendedPackage = ProfitabilitySheet_Helper.pickExtendexPckgs(wrapper,sources);

        final Map<String,List<Package_Wrapper>> mapPackages = Packages_Helper.getPackages(wrapper.Id, packageTypes, extendedPackage);
        final List<Package_Wrapper> commercialPackage = mapPackages.get('COMMERCIAL_PACKAGE');
        final List<Package_Wrapper> gipPackage = mapPackages.get('GIP_PACKAGE');
        final List<Package_Wrapper> forfait = mapPackages.get('FORFAIT');
        if(commercialPackage != null) {
            lstPackages.addAll(commercialPackage);
        }
        if(gipPackage != null) {
            lstPackages.addAll(gipPackage);
        }
        if(forfait != null) {
            lstPackages.addAll(forfait);
        }
        return lstPackages;
    }

    /**
    * @description method to get extended packages
    * @param wrapper : ProfitabilitySheet_Wrapper
    * @param sources : List<String> list with possible sources
    * @return List<Package_Wrapper>
    */
    private static Map<String,Set<String>> pickExtendexPckgs(ProfitabilitySheet_Wrapper wrapper, List<String> sources) {
        final Map<String,Set<String>> extendedPackage = new Map<String,Set<String>>();
        for (ProfitabilitySheet_Wrapper.Condition condition : wrapper.conditionsList) {
            if(condition.sourceCode != null && sources.contains(condition.source)) {
                final Integer length = condition.sourceCode.length();
                final String key = condition.sourceCode.substring(0, length-5);
                final String value = condition.sourceCode.substring(length-5,length);
                if(extendedPackage.get(key) == null) {
                    extendedPackage.put(key, new Set<String>{value});
                } else {
                    extendedPackage.get(key).add(value);
                }
            }
        }
        return extendedPackage;
    }
}