/**
* ____________________________________________________________________________
* Profitability Analysis Condition Service
* Service class for the object profitability_analysis_condition__c
* ____________________________________________________________________________
* @author      Torcuato Tejada <torcuato.tejada.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-02-10
* @modified
* @systemLayer Service
* ____________________________________________________________________________
* @changes
*
* ____________________________________________________________________________
*/
@SuppressWarnings('sf:DMLWithoutSharingEnabled')
global class ProfitabilityAnalysisCondition_Service {

    /**
    * @description private constructor
    */
    @TestVisible
    private ProfitabilityAnalysisCondition_Service() {}

    /**
    * @description returns conditions from a Profitability Analysys
    * @param contextIds : Ids of Profitability Analysis
    * @return List<profitability_analysis_condition__c>, list of profitability_analysis_conditions
    */
    global static List<profitability_analysis_condition__c> getConditionsFromProfitabilityAnalysis(Set<Id> contextIds) {
        return ProfitabilityAnalysisCondition_Helper.getConditionsFromProfitabilityAnalysis(contextIds);
    }

    /**
    * @description returns conditions
    * @param profAnalysisId : Id of the prof analysis id
    * @param familyId : Set of Ids of Profitability Analysis Conditions from a family
    * @return List<profitability_analysis_condition__c>, list of profitability_analysis_conditions
    */
    global static List<profitability_analysis_condition__c> getConditionsFromFamilyId(Id profAnalysisId, Id familyId) {
        return ProfitabilityAnalysisCondition_Helper.getConditionsFromFamilyId(profAnalysisId, familyId);
    }

    /**
    * @description returns profitability analysis conditions from catalogIds
    * @param profAnalysisId : Id of the prof analysis id
    * @param pscConditionIds : Set catalgo condition Ids,
    * @return List<profitability_analysis_condition__c>, list of profitability_analysis_conditions
    */
    global static List<profitability_analysis_condition__c> getConditionsFromCatalogIds(Id profAnalysisId, Set<Id> pscConditionIds) {
        return ProfitabilityAnalysisCondition_Helper.getConditionsFromCatalogIds(profAnalysisId, pscConditionIds);
    }

    /**
    * @description returns conditions
    * @param paConditionIds : Set of Ids of Profitability Analysis Conditions
    * @return List<profitability_analysis_condition__c>, list of profitability_analysis_conditions
    */
    global static List<profitability_analysis_condition__c> getConditionsFromIds(Set<Id> paConditionIds) {
        return ProfitabilityAnalysisCondition_Helper.getConditionsFromIds(paConditionIds);
    }

    /**
    * @description returns conditions from a Profitability Analysys
    * @param contextIds : Ids of Profitability Analysis
    * @return List<profitability_analysis_condition__c>, list of profitability_analysis_conditions
    */
    global static List<profitability_analysis_condition__c> getFlatConditionsFromProfitabilityAnalysis(Set<Id> contextIds) {
        return ProfitabilityAnalysisCondition_Helper.getFlatConditionsFromProfitabilityAnalysis(contextIds);
    }

    /**
    * @description returns Profitability Analysis Conditions in a Wrapper
    * @param paConditions : List of ProfAnalysis Conditions
    * @param conditionAttributes: List of attributes that belong to the paConditions
    * @return List<Conditions_Wrapper>, list of profitability_analysis_conditions wrappers
    */
    global static List<Conditions_Wrapper> getProfitabilityAnalysisConditionWrapper(List<profitability_analysis_condition__c> paConditions,  List<ps_catalog_condition_attribute__c> conditionAttributes) {
        return ProfitabilityAnalysisCondition_Helper.getProfitabilityAnalysisConditionWrapper(paConditions, conditionAttributes);
    }

    /**
    * @description returns Profitability Analysis Conditions in a Wrapper
    * @param Set<Id> contextIds : Ids of the Profitability Analysis
    * @return List<Conditions_Wrapper>, list of profitability_analysis_conditions wrappers
    */
    global static List<Conditions_Wrapper> getProfitabilityAnalysisConditions(Set<Id> contextIds) {
        final List<profitability_analysis_condition__c> paConditions = getConditionsFromProfitabilityAnalysis(contextIds);
        final  List<ps_catalog_condition_attribute__c> conditionAttributes = PsCatalogConditionAttribute_Service.getConditionAttributesFromProfitabilityAnalysisConditions(paConditions);
        return getProfitabilityAnalysisConditionWrapper(paConditions, conditionAttributes);
    }

    /**
    * @description returns Profitability Analysis Conditions in a Wrapper
    * @param Set<Id> contextIds : Ids of the Profitability Analysis
    * @return List<Conditions_Wrapper>, list of profitability_analysis_conditions wrappers
    */
    public static List<Conditions_Wrapper> getProfitabilityAnalysisFlatConditions(Set<Id> contextIds) {
        final List<profitability_analysis_condition__c> paConditions = getFlatConditionsFromProfitabilityAnalysis(contextIds);
        final  List<ps_catalog_condition_attribute__c> conditionAttributes = PsCatalogConditionAttribute_Service.getConditionAttributesFromProfitabilityAnalysisConditions(paConditions);
        return getProfitabilityAnalysisConditionWrapper(paConditions, conditionAttributes);
    }

    /**
    * @description Check whether user can perform action
    * @param action : The user tries to perform
    * @param profAnalysisId : Id of the profitability analysis
    * @param familyId : Id of the family to edit (edit action only)
    * @param conditionId : Id of the condition to remove (rmeove action only)
    * @return Map with the actions the user can perform in the Profitability Analysis
    */
    public static Map<String, Object> checkPermissions(String action, Id profAnalysisId, Id familyId, Id conditionId) {

        pa_general_configuration__mdt config = Utils.getGeneralConfiguration();
        final String className = config.permissions_itf_name__c;
        final Id userId = UserInfo.getUserId();
        Map<String, Object> res = new Map<String, Object>();

        try {
            final Permissions_itf instance = (Permissions_itf)Type.forName(className).newInstance();
            switch on action {
                when 'addConditions' {
                    res = instance.canAddConditions(profAnalysisId, userId);
                }
                when 'editConditions' {
                    res = instance.canEditConditions(profAnalysisId, userId, familyId);
                }
                when 'removeConditions' {
                    res = instance.canRemoveCondition(profAnalysisId, userId, conditionId);
                }
                when 'manageConditions' {
                    res = instance.canManageConditions(profAnalysisId, userId);
                }
            }
        } catch (Exception e) { //NOSONAR
            res.put('errorMessage', e.getMessage());
        }
        return res;
    }

    /**
    * @description Delete Condition from profitability Sheet
    * @param profAnalysisId : Id of the Profitability Sheet
    * @param conditions Set<Id> : conditions to be deleted
    * @return Utils.DML_Wrapper, with the response of the DML operation
    */
    public static Utils.DML_Wrapper deleteProfitabilityAnalysisCondition(Id profAnalysisId, Set<Id> conditions) {

        final List<profitability_analysis_condition__c> paConditions = ProfitabilityAnalysisCondition_Helper.getConditionsFromIds(conditions);
        final List<profitability_analysis_condition__c> lConditions = new List<profitability_analysis_condition__c>();

        for ( profitability_analysis_condition__c condition : paConditions ) {
            Map<String, Object> permission = checkPermissions('removeConditions', profAnalysisId, null, condition.Id);
            if ((Boolean)permission.get('remove')) {
                lConditions.add(condition);
            } else {
                System.debug(condition.Id + ' ' + permission.get('removeMessage'));
            }
        }
        return ProfitabilityAnalysisCondition_Helper.deleteProfitabilityAnalysisCondition(lConditions);
    }
}