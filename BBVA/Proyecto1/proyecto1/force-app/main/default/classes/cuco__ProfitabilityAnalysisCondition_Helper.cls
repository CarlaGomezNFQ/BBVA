/**
* ____________________________________________________________________________
* Profitability Analysis Condition Helper
* Helper class for ProfitabilityAnalysisCondition_Service
* ____________________________________________________________________________
* @author      Torcuato Tejada <torcuato.tejada.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-02-12
* @modified
* @systemLayer Service
* ____________________________________________________________________________
* @changes
*
* ____________________________________________________________________________
*/
@SuppressWarnings('sf:DMLWithoutSharingEnabled')
public class ProfitabilityAnalysisCondition_Helper {

    /**
    * @description private constructor.
    */
    @TestVisible
    private ProfitabilityAnalysisCondition_Helper() {}

    /**
    * @description returns conditions from a Profitability Analysys
    * @param contextIds : Ids of Profitability Analysis
    * @return List<profitability_analysis_condition__c>, list of profitability_analysis_conditions
    */
    public static List<profitability_analysis_condition__c> getConditionsFromProfitabilityAnalysis(Set<Id> contextIds) {
        final ProfitabilityAnalysisCondition_Selector selector = new ProfitabilityAnalysisCondition_Selector(true);
        final List<profitability_analysis_condition__c> paConditions = selector.selectByProfitabiliyAnalysisId(contextIds);
        return paConditions;
    }

    /**
    * @description returns flat conditions from a Profitability Analysys
    * @param contextIds : Ids of Profitability Analysis
    * @return List<profitability_analysis_condition__c>, list of profitability_analysis_conditions
    */
    public static List<profitability_analysis_condition__c> getFlatConditionsFromProfitabilityAnalysis(Set<Id> contextIds) {
        final ProfitabilityAnalysisCondition_Selector selector = new ProfitabilityAnalysisCondition_Selector(true);
        final List<profitability_analysis_condition__c> paConditions = selector.selectFlatByProfitabiliyAnalysisId(contextIds);
        return paConditions;
    }

    /**
    * @description returns conditions
    * @param profAnalysisId : Id of the prof analysis id
    * @param familyId : Set of Ids of Profitability Analysis Conditions from a family
    * @return List<profitability_analysis_condition__c>, list of profitability_analysis_conditions
    */
    public static List<profitability_analysis_condition__c> getConditionsFromFamilyId(Id profAnalysisId, Id familyId) {
        final ProfitabilityAnalysisCondition_Selector selector = new ProfitabilityAnalysisCondition_Selector(true);
        final List<profitability_analysis_condition__c> paConditions = selector.selectByFamilyId(profAnalysisId, familyId);
        return paConditions;
    }

    /**
    * @description returns profitability analysis conditions from catalogIds
    * @param profAnalysisId : Id of the prof analysis id
    * @param pscConditionIds : Set catalgo condition Ids,
    * @return List<profitability_analysis_condition__c>, list of profitability_analysis_conditions
    */
    public static List<profitability_analysis_condition__c> getConditionsFromCatalogIds(Id profAnalysisId, Set<Id> pscConditionIds) {
        final ProfitabilityAnalysisCondition_Selector selector = new ProfitabilityAnalysisCondition_Selector(true);
        final List<profitability_analysis_condition__c> paConditions = selector.selectByPsCatalogConditionId(profAnalysisId, pscConditionIds);
        return paConditions;
    }

    /**
    * @description returns conditions from a Profitability Analysis
    * @param conditionIds : Ids of Profitability Ananlysis conditions
    * @return List<profitability_analysis_condition__c>, list of Profitability Analysis Conditions
    */
    public static List<profitability_analysis_condition__c> getConditionsFromIds(Set<Id> conditionIds) {
        final ProfitabilityAnalysisCondition_Selector selector = new ProfitabilityAnalysisCondition_Selector(true);
        final List<profitability_analysis_condition__c> paConditions = selector.selectById(conditionIds);
        return paConditions;
    }

    /**
    * @description returns Profitability Analysis Conditions in a Wrapper
    * @param paConditions : List of ProfAnalysis Conditions
    * @param conditionAttributes: List of attributes that belong to the paConditions
    * @return List<Conditions_Wrapper>, list of profitability_analysis_conditions wrappers
    */
    public static List<Conditions_Wrapper> getProfitabilityAnalysisConditionWrapper(List<profitability_analysis_condition__c> paConditions,  List<ps_catalog_condition_attribute__c> conditionAttributes) {

        List<Conditions_Wrapper> conditions = new List<Conditions_Wrapper>();

        for (profitability_analysis_condition__c paCondition : paConditions) {

            Conditions_Wrapper condition = new Conditions_Wrapper();
            condition.productName = paCondition.gf_psc_condition_id__r.gf_psc_family_id__r.gf_psc_family_product_name__c;
            condition.familyId    = paCondition.gf_psc_condition_id__r.gf_psc_family_id__c;
            condition.familyName  = paCondition.gf_psc_condition_id__r.gf_psc_family_id__r.Name;
            condition.familyOrder = (Integer)paCondition.gf_psc_condition_id__r.gf_psc_family_id__r.gf_psc_fmly_visual_ord_number__c;
            condition.id = paCondition.Id;
            condition.catalogConditionId = paCondition.gf_psc_condition_id__c;
            condition.profitabilityAnalysisId = (String)paCondition.gf_profitablity_analysis_id__c;
            condition.name = paCondition.gf_psc_condition_id__r.Name;
            condition.order = (Integer)paCondition.gf_psc_condition_id__r.gf_psc_cond_visual_ord_number__c;
            condition.familyLevel = (Boolean)paCondition.gf_psc_condition_id__r.gf_psc_cond_fmly_lvl_ind_type__c;
            condition.source = paCondition.gf_pa_cond_atrb_source_type__c;

            condition.attributes = new List<Conditions_Wrapper.ConditionAttribute>();
            for (ps_catalog_condition_attribute__c conditionAttribute : conditionAttributes ) {
                if (conditionAttribute.gf_psc_condition_id__c ==  paCondition.gf_psc_condition_id__c && conditionAttribute.gf_psc_atribute_id__r.gf_psc_atrb_visible_ind_type__c) {
                    Conditions_Wrapper.ConditionAttribute attribute = new Conditions_Wrapper.ConditionAttribute();

                    attribute.id = conditionAttribute.gf_psc_atribute_id__c;
                    if (condition.familyLevel) {
                        attribute.name = condition.name;
                    } else {
                        attribute.name = conditionAttribute.gf_psc_atribute_id__r.Name;
                    }
                    attribute.visible = (Boolean)conditionAttribute.gf_psc_atribute_id__r.gf_psc_atrb_visible_ind_type__c;
                    attribute.type = conditionAttribute.gf_psc_atribute_id__r.gf_attribute_value_type_name__c;
                    attribute.order = (Integer)conditionAttribute.gf_psc_atribute_id__r.gf_psc_atrb_vslztn_ord_number__c;
                    attribute.unitType = conditionAttribute.gf_psc_atribute_id__r.gf_psc_bknd_svc_fmt_unit_type__c;
                    attribute.formatType = conditionAttribute.gf_psc_atribute_id__r.gf_psc_bknd_svc_format_type__c;
                    attribute.fieldName = conditionAttribute.gf_psc_atribute_id__r.gf_stored_prps_atrb_field_name__c;
                    if (attribute.type == 'List') {
                        String fieldName = (attribute.fieldName.substring(0,6) != 'cuco__') ? 'cuco__' + attribute.fieldName : attribute.fieldName;
                        attribute.value = (paCondition.get(attribute.fieldName) != null) ? Utils.getPicklistLabel('cuco__profitability_analysis_condition__c', fieldName, String.valueOf(paCondition.get(attribute.fieldName))) : '-' ;
                    } else {
                        attribute.value = (paCondition.get(attribute.fieldName) != null) ? String.valueOf(paCondition.get(attribute.fieldName)) : '-' ;
                    }
                    condition.attributes.add(attribute);
                }
            }
            conditions.add(condition);
        }
        return conditions;
    }

    /**
    * @description Delete Condition from profitability Analysis
    * @param paConditions List<profitability_analysis_condition__c> : conditions to be deleted
    * @return Utils.DML_Wrapper with the response of the DML operation
    */
    public static Utils.DML_Wrapper deleteProfitabilityAnalysisCondition(List<profitability_analysis_condition__c> paConditions) {

        final List<String> errors = new List<String>();

        final List<Database.DeleteResult> responses = Database.delete(paConditions, true);
        for (Database.DeleteResult response : responses) {
            if (!response.isSuccess()) {
                for (Database.Error error : response.getErrors()) {
                    errors.add(error.getMessage());
                    System.debug('Delete profitability_analysis_condition__c ERROR: ' + userInfo.getUserName() + ', ' + error.getStatusCode() + ': ' + error.getMessage());
                }
            }
        }
        return new Utils.DML_Wrapper(errors.isEmpty(), errors);
    }

    /**
    * @description Update Conditions
    * @param paConditions List<profitability_analysis_condition__c> : conditions to be updated
    * @return Utils.DML_Wrapper with the response of the DML operation
    */
    public static Utils.DML_Wrapper updateProfitabilityAnalysisCondition(List<profitability_analysis_condition__c> paConditions) {
        final List<String> errors = new List<String>();
        final List<Database.UpsertResult> responses = Database.upsert(paConditions, false);
        for (Database.UpsertResult response : responses) {
            if (!response.isSuccess()) {
                for (Database.Error error : response.getErrors()) {
                    errors.add(error.getMessage());
                    System.debug('update profitability_analysis_condition__c ERROR: ' + userInfo.getUserName() + ', ' + error.getStatusCode() + ': ' + error.getMessage());
                }
            }
        }
        return new Utils.DML_Wrapper(errors.isEmpty(), errors);
    }
}