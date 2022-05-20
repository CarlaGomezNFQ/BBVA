/**
* ────────────────────────────────────────────────────────────────────
* Conditions_Ctrl
* Controller class for conditions_cmp Aura Component
* ────────────────────────────────────────────────────────────────────
* @author      Torcuato Tejada <torcuato.tejada.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-02-10
* @modified
* @systemLayer Presentation
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
public with sharing class Conditions_Ctrl {

    /*
    * @description constructor
    */
    @TestVisible
    private Conditions_Ctrl() {}

    /**
    * @description getConditions from contextId.
    * @param contextId : Id of the Profitability Sheet or Profitability Analysis
    * @return String JSON
    */
    @AuraEnabled
    public static List<Conditions_Wrapper> getConditions(Id contextId) {
        List<Conditions_Wrapper> res = new List<Conditions_Wrapper>();
        try {
            final Set<Id> contextIds = new Set<Id>{contextId};
            final String sObjName = contextId.getSObjectType().getDescribe().getName();

            switch on sObjName {
                when 'cuco__profitability_analysis__c' {
                    res = ProfitabilityAnalysisCondition_Service.getProfitabilityAnalysisConditions(contextIds);
                }
                when 'cuco__profitability_sheet__c' {
                    res = ProfitabilitySheetCondition_Service.getProfitabilitySheetConditions(contextId);
                }
            }

        } catch (Exception e) { //NOSONAR
            throw new AuraHandledException(e.getMessage()); //NOSONAR
        }
        return res;
    }

    /**
    * @description getConditions from contextId.
    * @param contextId : Id of the Profitability Sheet or Profitability Analysis
    * @return String JSON
    */
    @AuraEnabled
    public static List<Conditions_Wrapper> getFlatConditions(Id contextId) {
        List<Conditions_Wrapper> res = new List<Conditions_Wrapper>();
        try {
            final Set<Id> contextIds = new Set<Id>{contextId};
            final String sObjName = contextId.getSObjectType().getDescribe().getName();

            switch on sObjName {
                when 'cuco__profitability_analysis__c' {
                    res = ProfitabilityAnalysisCondition_Service.getProfitabilityAnalysisFlatConditions(contextIds);
                }
                when 'cuco__profitability_sheet__c' {
                    res = ProfitabilitySheetCondition_Service.getProfitabilitySheetConditions(contextId);
                }
            }

        } catch (Exception e) { //NOSONAR
            throw new AuraHandledException(e.getMessage()); //NOSONAR
        }
        return res;
    }

    /**
    * @description Check whether user can perform action
    * @param action : The user tries to perform
    * @param profAnalysisId : Id of the profitability analysis
    * @param familyId : Id of the family to edit (edit action only)
    * @param conditionId : Id of the condition to remove (rmeove action only)
    * @return Map with the actions the user can perform in the Profitability Analysis
    */
    @AuraEnabled
    public static Map<String, Object> checkPermissions(String action, Id profAnalysisId, Id familyId, Id conditionId) {
        Map<String, Object> res = new Map<String, Object>();
        try {
            res = ProfitabilityAnalysisCondition_Service.checkPermissions(action, profAnalysisId, familyId, conditionId);
        } catch (Exception e) { //NOSONAR
            throw new AuraHandledException(e.getMessage()); //NOSONAR
        }
        return res;
    }

}