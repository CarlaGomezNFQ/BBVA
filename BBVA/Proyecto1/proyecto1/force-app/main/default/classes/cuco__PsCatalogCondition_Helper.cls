/**
* ____________________________________________________________________________
* Profitability Sheet Catalog Condition Helper
* Helper class for PsCatalogCondition_Service
* ____________________________________________________________________________
* @author      Torcuato Tejada <torcuato.tejada.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-03-08
* @modified
* @systemLayer Service
* ____________________________________________________________________________
* @changes
*
* ____________________________________________________________________________
*/
@SuppressWarnings('sf:DMLWithoutSharingEnabled')
public class PsCatalogCondition_Helper {

    /**
    * @description private constructor.
    */
    @TestVisible
    private PsCatalogCondition_Helper() {}

    /**
    * @description returns Condition from Profitability Analysis/Sheet Condition Ids
    * @param conditionIds : List of Profitability Analysis/Sheet Condition Ids
    * @return List<ps_catalog_condition__c> : List of Condition Attribute
    */
    public static List<ps_catalog_condition__c> getActiveCatalogConditions() {
        final PsCatalogCondition_Selector selector = new PsCatalogCondition_Selector(true);
        final List<ps_catalog_condition__c> catalogConditions = selector.selectActiveCatalogConditions();
        return catalogConditions;
    }

    /**
    * @description returns Condition from Profitability Analysis/Sheet Condition Ids
    * @param conditionIds : List of Profitability Analysis/Sheet Condition Ids
    * @return List<ps_catalog_condition__c> : List of Condition Attribute
    */
    public static List<ps_catalog_condition__c> getActiveFlatCatalogConditions() {
        final PsCatalogCondition_Selector selector = new PsCatalogCondition_Selector(true);
        final List<ps_catalog_condition__c> catalogConditions = selector.selectActiveFlatCatalogConditions();
        return catalogConditions;
    }

    /**
    * @description returns Catalog Conditions
    * @param pscConditionIds Set<Id> Set of Condition Ids
    * @return List<ps_catalog_condition__c> : List of Conditions
    */
    public static List<ps_catalog_condition__c> getCatalogConditionsFromIds(Set<Id> pscConditionIds) {
        final PsCatalogCondition_Selector selector = new PsCatalogCondition_Selector(true);
        final List<ps_catalog_condition__c> catalogConditions = selector.selectCatalogConditionsFromIds(pscConditionIds);
        return catalogConditions;
    }

    /**
    * @description returns Catalog Conditions from a Family Id
    * @param familyId familyId
    * @return List<ps_catalog_condition__c> : List of Conditions
    */
    public static List<ps_catalog_condition__c> getCatalogConditionsFromFamilyId(Id familyId) {
        final PsCatalogCondition_Selector selector = new PsCatalogCondition_Selector(true);
        final List<ps_catalog_condition__c> catalogConditions = selector.selectByFamily(familyId);
        return catalogConditions;
    }

    /**
    * @description returns Profitability Sheet Conditions in a Wrapper
    * @param psConditions : List of Profitability Sheet Conditions
    * @param conditionAttributes: List of attributes that belong to the psConditions
    * @return List<Conditions_Wrapper>, list of profitability_sheet_conditions wrappers
    */
    public static List<PsCatalogCondition_Wrapper> getCatalogConditionsWrapper(List<ps_catalog_condition__c> catalogConditions) {

        List<PsCatalogCondition_Wrapper> conditions = new List<PsCatalogCondition_Wrapper>();

        for (ps_catalog_condition__c catalogCondition : catalogConditions) {

            PsCatalogCondition_Wrapper condition = new PsCatalogCondition_Wrapper();
            condition.name = catalogCondition.Name;
            condition.id = catalogCondition.Id;
            condition.pscConditionId = catalogCondition.gf_psc_condition_id__c;
            condition.familyName = catalogCondition.gf_psc_family_id__r.Name;
            condition.familyId = catalogCondition.gf_psc_family_id__c;
            condition.familyOrder = (Integer)catalogCondition.gf_psc_family_id__r.gf_psc_fmly_visual_ord_number__c;
            condition.productName = catalogCondition.gf_psc_family_id__r.gf_psc_family_product_name__c;
            condition.allowFlatSel = catalogCondition.gf_psc_cond_flat_rate_ind_type__c;
            condition.priceClass = catalogCondition.gf_psc_cond_prc_class_ind_type__c;
            condition.familyLevel = catalogCondition.gf_psc_cond_fmly_lvl_ind_type__c;
            condition.manualIntl = catalogCondition.gf_psc_ca_mf_iscp_pkg_ind_type__c;
            condition.order = (Integer)catalogCondition.gf_psc_cond_visual_ord_number__c;
            conditions.add(condition);
        }
        return conditions;
    }
}