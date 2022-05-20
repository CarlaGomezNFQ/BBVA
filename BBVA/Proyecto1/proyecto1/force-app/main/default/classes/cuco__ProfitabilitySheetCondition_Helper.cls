/**
* ____________________________________________________________________________
* Profitability Sheet Condition Helper
* Helper class for ProfitabilitySheetCondition_Service
* ____________________________________________________________________________
* @author      Torcuato Tejada <torcuato.tejada.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-02-22
* @modified
* @systemLayer Service
* ____________________________________________________________________________
* @changes
*
* ____________________________________________________________________________
*/
@SuppressWarnings('sf:DMLWithoutSharingEnabled')
public class ProfitabilitySheetCondition_Helper {

    /**
    * @description private constructor.
    */
    @TestVisible
    private ProfitabilitySheetCondition_Helper() {}

    /**
    * @description returns conditions from a Profitability Sheets where source = null
    * @param profSheetId : Ids of Profitability Sheets
    * @return List<profitability_sheet_condition__c>, list of Profitability Sheet Conditions
    */
    public static List<profitability_sheet_condition__c> getConditionsFromProfitabilitySheet(Set<Id> profSheetId) {
        final ProfitabilitySheetCondition_Selector selector = new ProfitabilitySheetCondition_Selector(true);
        final List<profitability_sheet_condition__c> psConditions = selector.selectByProfitabilitySheetId(profSheetId);
        return psConditions;
    }

    /**
    * @description returns conditions from a Profitability Sheets
    * @param profSheetId : Ids of Profitability Sheets
    * @return List<profitability_sheet_condition__c>, list of Profitability Sheet Conditions
    */
    public static List<profitability_sheet_condition__c> getAllConditionsFromProfitabilitySheet(Set<Id> profSheetId) {
        final ProfitabilitySheetCondition_Selector selector = new ProfitabilitySheetCondition_Selector(true);
        final List<profitability_sheet_condition__c> psConditions = selector.selectAllByProfitabilitySheetId(profSheetId);
        return psConditions;
    }

    /**
    * @description returns Profitability Sheet Conditions in a Wrapper
    * @param psConditions : List of Profitability Sheet Conditions
    * @param conditionAttributes: List of attributes that belong to the psConditions
    * @return List<Conditions_Wrapper>, list of Profitability Sheet Conditions wrappers
    */
    public static List<Conditions_Wrapper> getProfitabilitySheetConditionWrapper(List<profitability_sheet_condition__c> psConditions,  List<ps_catalog_condition_attribute__c> conditionAttributes) {

        List<Conditions_Wrapper> conditions = new List<Conditions_Wrapper>();

        for (profitability_sheet_condition__c psCondition : psConditions) {

            Conditions_Wrapper condition = new Conditions_Wrapper();
            condition.productName = psCondition.gf_psc_condition_id__r.gf_psc_family_id__r.gf_psc_family_product_name__c;
            condition.familyId    = psCondition.gf_psc_condition_id__r.gf_psc_family_id__c;
            condition.familyName  = psCondition.gf_psc_condition_id__r.gf_psc_family_id__r.Name;
            condition.familyOrder = (Integer)psCondition.gf_psc_condition_id__r.gf_psc_family_id__r.gf_psc_fmly_visual_ord_number__c;
            condition.id = psCondition.Id;
            condition.profitabilitySheetId = (String)psCondition.gf_profitability_sheet_id__c;
            condition.name = psCondition.gf_psc_condition_id__r.Name;
            condition.order = (Integer)psCondition.gf_psc_condition_id__r.gf_psc_cond_visual_ord_number__c;
            condition.familyLevel = (Boolean)psCondition.gf_psc_condition_id__r.gf_psc_cond_fmly_lvl_ind_type__c;
            condition.source = psCondition.gf_ps_cond_atrb_srce_type_name__c;

            condition.attributes = new List<Conditions_Wrapper.ConditionAttribute>();
            for (ps_catalog_condition_attribute__c conditionAttribute : conditionAttributes ) {
                if (conditionAttribute.gf_psc_condition_id__c ==  psCondition.gf_psc_condition_id__c && conditionAttribute.gf_psc_atribute_id__r.gf_psc_atrb_visible_ind_type__c) {
                    Conditions_Wrapper.ConditionAttribute attribute = new Conditions_Wrapper.ConditionAttribute();
                    attribute.id = conditionAttribute.gf_psc_atribute_id__c;
                    if (condition.familyLevel) {
                        attribute.name = condition.name;
                    } else {
                        attribute.name = conditionAttribute.gf_psc_atribute_id__r.Name;
                    }
                    attribute.visible = conditionAttribute.gf_psc_atribute_id__r.gf_psc_atrb_visible_ind_type__c;
                    attribute.type = conditionAttribute.gf_psc_atribute_id__r.gf_attribute_value_type_name__c;
                    attribute.order = (Integer)conditionAttribute.gf_psc_atribute_id__r.gf_psc_atrb_vslztn_ord_number__c;
                    attribute.unitType = conditionAttribute.gf_psc_atribute_id__r.gf_psc_bknd_svc_fmt_unit_type__c;
                    attribute.formatType = conditionAttribute.gf_psc_atribute_id__r.gf_psc_bknd_svc_format_type__c;
                    attribute.fieldName = conditionAttribute.gf_psc_atribute_id__r.gf_stored_fnl_atrb_field_name__c;
                    if (attribute.type == 'List') {
                        String fieldName = (attribute.fieldName.substring(0,6) != 'cuco__') ? 'cuco__' + attribute.fieldName : attribute.fieldName;
                        attribute.value = (psCondition.get(attribute.fieldName) != null) ? Utils.getPicklistLabel('cuco__profitability_sheet_condition__c', fieldName, String.valueOf(psCondition.get(attribute.fieldName))) : '-' ;
                    } else {
                        attribute.value = (psCondition.get(attribute.fieldName) != null) ? String.valueOf(psCondition.get(attribute.fieldName)) : '-' ;
                    }
                    condition.attributes.add(attribute);
                }
            }
            conditions.add(condition);
        }
        return conditions;
    }

    /**
    * @description returns Profitability Sheet Conditions in a Wrapper
    * @param profSheetId : Profitability Sheet Id
    * @return List<Conditions_Wrapper>, list of Profitability Sheet Conditions wrappers
    */
    public static List<Conditions_Wrapper> getProfitabilitySheetConditionWrapper(Id profSheetId) {

        final Set<Id> conditionIds = new Set<Id>();
        final Set<Id> attributeIds = new Set<Id>();
        final Map<String, Object> attributeMap = new Map<String, Object>();
        final Map<String, Object> psFullDetails = ProfitabilitySheet_Service.getProfSheetFullDetails(profSheetId);
        final ProfitabilitySheet_Wrapper psWrapper = (ProfitabilitySheet_Wrapper)psFullDetails.get('profSheetDetails');

        for (ProfitabilitySheet_Wrapper.Condition condition : psWrapper.conditionsList ) {
            if (condition.source == null || condition.source =='') {
                conditionIds.add(condition.id);
                for (ProfitabilitySheet_Wrapper.Attribute attribute : condition.attributesList ) {
                    attributeIds.add(attribute.condAttrId);
                    attributeMap.put(attribute.condAttrId, attribute);
                }
            }
        }

        List<ps_catalog_condition__c> pscConditions = PsCatalogCondition_Service.getCatalogConditionsFromIds(conditionIds);
        List<ps_catalog_condition_attribute__c> conditionAttributes = PsCatalogConditionAttribute_Service.getConditionAttributesFromIds(attributeIds);
        List<Conditions_Wrapper> conditions = new List<Conditions_Wrapper>();

        for (ps_catalog_condition__c pscCondition : pscConditions) {

            Conditions_Wrapper condition = new Conditions_Wrapper();
            condition.productName = pscCondition.gf_psc_family_id__r.gf_psc_family_product_name__c;
            condition.familyId    = pscCondition.gf_psc_family_id__c;
            condition.familyName  = pscCondition.gf_psc_family_id__r.Name;
            condition.familyOrder = (Integer)pscCondition.gf_psc_family_id__r.gf_psc_fmly_visual_ord_number__c;
            condition.id = pscCondition.Id;
            condition.name = pscCondition.Name;
            condition.profitabilitySheetId = profSheetId;
            condition.order = (Integer)pscCondition.gf_psc_cond_visual_ord_number__c;
            condition.familyLevel = (Boolean)pscCondition.gf_psc_cond_fmly_lvl_ind_type__c;
            condition.source = null;

            condition.attributes = new List<Conditions_Wrapper.ConditionAttribute>();
            for (ps_catalog_condition_attribute__c conditionAttribute : conditionAttributes ) {
                if (conditionAttribute.gf_psc_condition_id__c ==  pscCondition.Id && conditionAttribute.gf_psc_atribute_id__r.gf_psc_atrb_visible_ind_type__c) {

                    ProfitabilitySheet_Wrapper.Attribute attrFromService = (ProfitabilitySheet_Wrapper.Attribute)attributeMap.get(conditionAttribute.Id);
                    Conditions_Wrapper.ConditionAttribute attribute = new Conditions_Wrapper.ConditionAttribute();
                    attribute.id = conditionAttribute.gf_psc_atribute_id__c;
                    if (condition.familyLevel) {
                        attribute.name = condition.name;
                    } else {
                        attribute.name = conditionAttribute.gf_psc_atribute_id__r.Name;
                    }
                    attribute.visible = conditionAttribute.gf_psc_atribute_id__r.gf_psc_atrb_visible_ind_type__c;
                    attribute.type = conditionAttribute.gf_psc_atribute_id__r.gf_attribute_value_type_name__c;
                    attribute.order = (Integer)conditionAttribute.gf_psc_atribute_id__r.gf_psc_atrb_vslztn_ord_number__c;
                    attribute.unitType = conditionAttribute.gf_psc_atribute_id__r.gf_psc_bknd_svc_fmt_unit_type__c;
                    attribute.formatType = conditionAttribute.gf_psc_atribute_id__r.gf_psc_bknd_svc_format_type__c;
                    attribute.fieldName = conditionAttribute.gf_psc_atribute_id__r.gf_stored_fnl_atrb_field_name__c;
                    condition.attributes.add(attribute);
                    attribute.value = attrFromService.value;
                }
            }
            conditions.add(condition);
        }
        return conditions;
    }
}