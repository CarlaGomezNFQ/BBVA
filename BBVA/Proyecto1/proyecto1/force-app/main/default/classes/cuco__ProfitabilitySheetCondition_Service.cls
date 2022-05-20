/**
* ____________________________________________________________________________
* Profitability Sheet Condition Service
* Service class for the object profitability_sheet_condition__c
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
@SuppressWarnings('sf:DMLWithoutSharingEnabled')
global class ProfitabilitySheetCondition_Service {

    /**
    * @description private constructor
    */
    @TestVisible
    private ProfitabilitySheetCondition_Service() {}

    /**
    * @description returns conditions from a Profitability Sheet with source = null
    * @param profSheetId : Ids of Profitability Sheet
    * @return List<profitability_sheet_condition__c>, list of Profitability Sheet Conditions
    */
    global static List<profitability_sheet_condition__c> getConditionsFromProfitabilitySheet(Set<Id> profSheetId) {
        return ProfitabilitySheetCondition_Helper.getConditionsFromProfitabilitySheet(profSheetId);
    }

    /**
    * @description returns conditions from a Profitability Sheet
    * @param profSheetId : Ids of Profitability Analysis
    * @return List<profitability_sheet_condition__c>, list of Profitability Sheet Conditions
    */
    global static List<profitability_sheet_condition__c> getAllConditionsFromProfitabilitySheet(Set<Id> profSheetId) {
        return ProfitabilitySheetCondition_Helper.getAllConditionsFromProfitabilitySheet(profSheetId);
    }

    /**
    * @description returns Profitability Sheet Conditions in a Wrapper
    * @param psConditions : List of Profitability Sheet Conditions
    * @param conditionAttributes: List of attributes that belong to the psConditions
    * @return List<Conditions_Wrapper>, list of profitability_sheet_conditions wrappers
    */
    global static List<Conditions_Wrapper> getProfitabilitySheetConditionWrapper(List<profitability_sheet_condition__c> psConditions,  List<ps_catalog_condition_attribute__c> conditionAttributes) {
        return ProfitabilitySheetCondition_Helper.getProfitabilitySheetConditionWrapper(psConditions, conditionAttributes);
    }

    /**
    * @description returns Profitability Sheet Conditions in a Wrapper
    * @param profSheetId : Id of the Profitability Sheets
    * @return List<Conditions_Wrapper>, list of profitability_sheet_conditions wrappers
    */
    global static List<Conditions_Wrapper> getProfitabilitySheetConditions(Id profSheetId) {
        return ProfitabilitySheetCondition_Helper.getProfitabilitySheetConditionWrapper(profSheetId);
    }

}