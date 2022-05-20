/**
* ────────────────────────────────────────────────────────────────────
* ConditionsRemove_Ctrl
* Controller class for conditions_remove_cmp Aura Component
* ────────────────────────────────────────────────────────────────────
* @author      Torcuato Tejada <torcuato.tejada.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-03-08
* @modified
* @systemLayer Presentation
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
public with sharing class ConditionsRemove_Ctrl {

    /*
    * @description constructor
    */
    @TestVisible
    private ConditionsRemove_Ctrl() {}

    /**
    * @description get Conditions name from id
    * @param conditionId Id of condition
    * @return Map<String, Object>
    */
    @AuraEnabled
    public static Map<String, Object> getConditionName(Id paConditionId) {
        final Map<String, Object> retMap = new Map<String, Object>();
        final Set<Id> paConditionIds = new Set<Id>{paConditionId};
        try {
            List<profitability_analysis_condition__c> conditions = ProfitabilityAnalysisCondition_Service.getConditionsFromIds(paConditionIds);
            retMap.put('name', conditions[0].gf_psc_condition_id__r.Name);
            retMap.put('formMethod', conditions[0].gf_psc_condition_id__r.cuco__gf_psc_fa_frmlz_proc_type_name__c);
        } catch (Exception e) { //NOSONAR
            throw new AuraHandledException(e.getMessage()); //NOSONAR
        }
        return retMap;
    }

    /**
    * @description getConditions from contextId.
    * @param profAnalysisId : Id Profitability Analysis
    * @param conditionId Id of condition to be deleted
    * @return Utils.DML_Wrapper
    */
    @AuraEnabled
    public static Utils.DML_Wrapper removeCondition(Id profAnalysisId, Id conditionId) {
        Utils.DML_Wrapper res;
        final Set<Id> conditionIds = new Set<Id>{conditionId};
        try {
            res = ProfitabilityAnalysisCondition_Service.deleteProfitabilityAnalysisCondition(profAnalysisId, conditionIds);
        } catch (Exception e) { //NOSONAR
            throw new AuraHandledException(e.getMessage()); //NOSONAR
        }
        return res;
    }

}