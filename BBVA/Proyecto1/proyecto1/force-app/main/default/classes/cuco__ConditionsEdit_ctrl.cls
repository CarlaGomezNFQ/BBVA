/**
* ────────────────────────────────────────────────────────────────────
* ConditionsEdit_Ctrl
* Controller class for conditions_edit_cmp Aura Component
* ────────────────────────────────────────────────────────────────────
* @author      Torcuato Tejada <torcuato.tejada.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-04-22
* @modified
* @systemLayer Presentation
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
public with sharing class ConditionsEdit_ctrl {

    /*
    * @description constructor
    */
    @TestVisible
    private ConditionsEdit_ctrl() {}

    /**
    * private getConditions
    */
    private static List<Map<String, Object>> getConditions(List<profitability_analysis_condition__c> paConditions, List<Id> conditionsIncluded) {
        List<Map<String, Object>> conditions = new List<Map<String, Object>>();
        for (profitability_analysis_condition__c paCondition : paConditions) {
            conditions.add(new Map<String, Object>{'id' => paCondition.gf_psc_condition_id__r.Id, 'isIncluded' => conditionsIncluded.contains(paCondition.gf_psc_condition_id__r.Id)});
        }
        return conditions;
    }

    /**
    * private getConditionIds
    */
    private static Set<Id> getConditionIds(List<profitability_analysis_condition__c> paConditions) {
        Set<Id> conditionIds = new Set<Id>();
        for (profitability_analysis_condition__c paCondition : paConditions) {
            conditionIds.add(paCondition.gf_psc_condition_id__r.Id);
        }
        return conditionIds;
    }

    /**
    * private getDelegation
    */
    private static List<Map<String, Object>> getDelegation(Id profAnalysisId, List<String> lAttributes) {
        List<Map<String,Object>> delegatedValues = Price_Helper.getDelegatedValues(profAnalysisId);
        List<Map<String, Object>> delegation = new List<Map<String, Object>>();
        for (Map<String, Object> delegatedValue : delegatedValues) {
            if (lAttributes.contains((String)delegatedValue.get('id'))) {
            delegation.add(new Map<String, Object>{'id' => (String)delegatedValue.get('id'), 'value' => (String)delegatedValue.get('value')});
            }
        }
        return delegation;
    }

    /**
    * private getActualValues
    */
    private static List<Map<String, Object>> getActualValues(profitability_analysis__c profitabilityAnalysis, List<String> lAttributes) {
        List<Map<String, Object>> actual = new List<Map<String, Object>>();
        if (!String.isEmpty(profitabilityAnalysis.gf_profitability_sheet_id__c)) {
            final Map<String,Object> profSheetFullDetails = ProfitabilitySheet_Service.getProfSheetFullDetails(profitabilityAnalysis.gf_profitability_sheet_id__c);
            final List<Map<String, Object>> actualValuesMap = ProfitabilitySheet_Service.getPSActualValuesMap(profSheetFullDetails);
            for (Map<String, Object> actualValue : actualValuesMap) {
                if (lAttributes.contains((String)actualValue.get('id'))) {
                    actual.add(new Map<String, Object>{'id' => (String)actualValue.get('id'), 'value' => (String)actualValue.get('value')});
                }
            }
        }
        return actual;
    }

    /**
    * private getStandardValues
    */
    private static List<Map<String, Object>> getStandardValues(List<String> lAttributes) {
        List<Map<String, Object>> standard = new List<Map<String, Object>>();
        final List<ps_catalog_condition_standard__c> catalogConditionsStandard = Catalog_Helper.getActiveStandardValues();
        for (ps_catalog_condition_standard__c standardValue : catalogConditionsStandard) {
            if (lAttributes.contains(standardValue.gf_psc_condition_attribute_id__r.gf_psc_condition_attribute_id__c)) {
                standard.add(new Map<String, Object>{'id' => (String)standardValue.gf_psc_condition_attribute_id__r.gf_psc_condition_attribute_id__c, 'value' => (String)standardValue.gf_cond_atrb_standard_val_name__c, 'min' => (String)standardValue.gf_cond_atrb_min_val_name__c, 'max' => (String)standardValue.gf_cond_atrb_max_val_name__c});
            }
        }
        return standard;
    }

    /**
    * private getAttributes
    */
    private static List<String> getAttributes(Set<Id> conditionIds) {
        List<String> attributes = new List<String>();
        List<ps_catalog_condition_attribute__c> pscConditionAttributes = PsCatalogConditionAttribute_Service.getConditionAttributesFromConditionIds(conditionIds);
        for(ps_catalog_condition_attribute__c pscConditionAttribute : pscConditionAttributes) {
            attributes.add(pscConditionAttribute.gf_psc_condition_attribute_id__c);
        }
        return attributes;
    }

    /**
    * @description read from configuration
    * @return Boolean
    */
    private static Boolean retrieveStandardValues() {
        final pa_general_configuration__mdt config = Utils.getGeneralConfiguration();
        return (Boolean)config.retrieve_standard_values_type__c;
    }

    /**
    * @description read from configuration
    * @return Boolean
    */
    private static Boolean retrieveDelegatedValues() {
        final pa_general_configuration__mdt config = Utils.getGeneralConfiguration();
        return (Boolean)config.retrieve_delegated_values_type__c;
    }

    /**
    * @description get Conditions name from id
    * @param conditionId Id of condition
    * @return String
    */
    @AuraEnabled
    public static String getConditionsValues(Id profAnalysisId, Id familyId, List<Id> conditionsIncluded) {

        final Map<String, Object> res = new Map<String, Object>();
        final profitability_analysis__c profitabilityAnalysis = ProfitabilityAnalysis_Service.getProfitabilityAnalysisInfo(profAnalysisId);

        try {
            List<profitability_analysis_condition__c> paConditions = ProfitabilityAnalysisCondition_Service.getConditionsFromCatalogIds(profAnalysisId, new Set<Id>(conditionsIncluded));
            Set<Id> conditionIds = getConditionIds(paConditions);
            List<String> lAttributes = getAttributes(conditionIds);
            List<Map<String, Object>> conditions = getConditions(paConditions, conditionsIncluded);
            List<Map<String, Object>> actual = new  List<Map<String, Object>>();

            res.put('profAnalysisId', profAnalysisId);
            res.put('familyId', familyId);
            res.put('conditions', conditions);

            if (retrieveStandardValues()) {
                List<Map<String, Object>> standard = getStandardValues(lAttributes);
                res.put('standard', standard);
            }

            if (retrieveDelegatedValues()) {
                List<Map<String, Object>> delegation = getDelegation(profAnalysisId, lAttributes);
                res.put('delegation', delegation);
            }

            if (profitabilityAnalysis.gf_pa_management_type_name__c != 'New') {
                actual = getActualValues(profitabilityAnalysis, lAttributes);
            }
            res.put('actual', actual);

        } catch (Exception e) { //NOSONAR
            throw new AuraHandledException(e.getMessage()); //NOSONAR
        }

        return JSON.serialize(res);
    }
}