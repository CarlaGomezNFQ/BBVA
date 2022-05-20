/**
* ____________________________________________________________________________
* Profitability Sheet Condition Attribute Service
* Service class for the object ps_catalog_condition_attribute__c
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
global class PsCatalogConditionAttribute_Service {

    /**
    * @description private constructor.
    */
    @TestVisible
    private PsCatalogConditionAttribute_Service() {}

    /**
    * @description returns Condition Attributes from Attribute Ids
    * @param attributeIds : List of Attribute Ids
    * @return List<ps_catalog_condition_attribute__c> : List of Condition Attribute
    */
    global static List<ps_catalog_condition_attribute__c> getConditionAttributesFromIds(Set<Id> attributeIds) {
        return PsCatalogConditionAttribute_Helper.getConditionAttributesFromIds(attributeIds);
    }

    /**
    * @description returns Condition Attributes from Attribute Canonical names
    * @param attributeNames : List of Attribute Ids
    * @param conditionIds : Set<Id> filter by conditionIds
    * @return List<ps_catalog_condition_attribute__c> : List of Condition Attribute
    */
    public static List<ps_catalog_condition_attribute__c> getConditionAttributesFromCanonicalNames(Set<Id> conditionIds, Set<String> attributeNames) {
        return PsCatalogConditionAttribute_Helper.getConditionAttributesFromCanonicalNames(conditionIds, attributeNames);
    }

    /**
    * @description returns Condition Attributes from Profitability Analysis Conditions
    * @param paConditions : List of Profitability Analysis Conditions
    * @return List<ps_catalog_condition_attribute__c> : List of Condition Attribute
    */
    global static List<ps_catalog_condition_attribute__c> getConditionAttributesFromProfitabilityAnalysisConditions(List<cuco__profitability_analysis_condition__c> paConditions) {
        return PsCatalogConditionAttribute_Helper.getConditionAttributesFromProfitabilityAnalysisConditions(paConditions);
    }

    /**
    * @description returns Condition Attributes from Profitability Sheet Conditions
    * @param psConditions : List of Profitability Sheet Conditions
    * @return List<ps_catalog_condition_attribute__c> : List of Condition Attribute
    */
    global static List<ps_catalog_condition_attribute__c> getConditionAttributesFromProfitabilitySheetConditions(List<cuco__profitability_sheet_condition__c> psConditions) {
        return PsCatalogConditionAttribute_Helper.getConditionAttributesFromProfitabilitySheetConditions(psConditions);
    }

    /**
    * @description returns Condition Attributes from Profitability Sheet Condition Ids
    * @param conditionIds : List of Profitability Sheet Condition Ids
    * @return List<ps_catalog_condition_attribute__c> : List of Condition Attribute
    */
    global static List<ps_catalog_condition_attribute__c> getConditionAttributesFromConditionIds(Set<Id> conditionIds) {
        return PsCatalogConditionAttribute_Helper.getConditionAttributesFromConditionIds(conditionIds);
    }

}