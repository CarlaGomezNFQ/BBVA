/**
* ____________________________________________________________________________
* Profitability Sheet Condition Attribute Helper
* Helper class for PsCatalogConditionAttribute_Service
* ____________________________________________________________________________
* @author      Torcuato Tejada <torcuato.tejada.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-02-17
* @modified
* @systemLayer Service
* ____________________________________________________________________________
* @changes
*
* ____________________________________________________________________________
*/
@SuppressWarnings('sf:DMLWithoutSharingEnabled')
public class PsCatalogConditionAttribute_Helper {

    /**
    * @description private constructor.
    */
    @TestVisible
    private PsCatalogConditionAttribute_Helper() {}

    /**
    * @description returns Condition Attributes from Profitability Analysis/Sheet Condition Ids
    * @param conditionIds : List of Profitability Analysis/Sheet Condition Ids
    * @return List<ps_catalog_condition_attribute__c> : List of Condition Attribute
    */
    public static List<ps_catalog_condition_attribute__c> getConditionAttributesFromConditionIds(Set<Id> conditionIds) {
        final PsCatalogConditionAttribute_Selector selector = new PsCatalogConditionAttribute_Selector(true);
        final List<ps_catalog_condition_attribute__c> pscConditionAttributes = selector.selectConditionAttributesFromConditionIds(conditionIds);
        return pscConditionAttributes;
    }

    /**
    * @description returns Condition Attributes from attribute Ids
    * @param attributeIds : List of Attribute Ids
    * @return List<ps_catalog_condition_attribute__c> : List of Condition Attribute
    */
    public static List<ps_catalog_condition_attribute__c> getConditionAttributesFromIds(Set<Id> attributeIds) {
        final PsCatalogConditionAttribute_Selector selector = new PsCatalogConditionAttribute_Selector(true);
        final List<ps_catalog_condition_attribute__c> pscConditionAttributes = selector.selectById(attributeIds);
        return pscConditionAttributes;
    }

    /**
    * @description returns Condition Attributes from Attribute Canonical names
    * @param attributeNames : List of Attribute Ids
    * @param conditionIds : Set<Id> filter by conditionIds
    * @return List<ps_catalog_condition_attribute__c> : List of Condition Attribute
    */
    public static List<ps_catalog_condition_attribute__c> getConditionAttributesFromCanonicalNames(Set<Id> conditionIds, Set<String> attributeNames) {
        final PsCatalogConditionAttribute_Selector selector = new PsCatalogConditionAttribute_Selector(true);
        final List<ps_catalog_condition_attribute__c> pscConditionAttributes = selector.selectConditionAttributesByCanonicalName(conditionIds, attributeNames);
        return pscConditionAttributes;
    }

    /**
    * @description returns Condition Attributes from Profitability Analysis Conditions
    * @param paConditions : List of Profitability Analysis Conditions
    * @return List<ps_catalog_condition_attribute__c> : List of Condition Attribute
    */
    public static List<ps_catalog_condition_attribute__c> getConditionAttributesFromProfitabilityAnalysisConditions(List<profitability_analysis_condition__c> paConditions) {
        final Set<Id> paConditionIds = new Set<Id>();
        for( profitability_analysis_condition__c paCondition : paConditions ) {
            paConditionIds.add(paCondition.gf_psc_condition_id__c);
        }
        return getConditionAttributesFromConditionIds(paConditionIds);
    }

    /**
    * @description returns Condition Attributes from Profitability Sheet Conditions
    * @param psConditions : List of Profitability Sheet Conditions
    * @return List<ps_catalog_condition_attribute__c> : List of Condition Attribute
    */
    public static List<ps_catalog_condition_attribute__c> getConditionAttributesFromProfitabilitySheetConditions(List<profitability_sheet_condition__c> psConditions) {
        final Set<Id> psConditionIds = new Set<Id>();
        for( profitability_sheet_condition__c psCondition : psConditions ) {
            psConditionIds.add(psCondition.gf_psc_condition_id__c);
        }
        return getConditionAttributesFromConditionIds(psConditionIds);
    }

}