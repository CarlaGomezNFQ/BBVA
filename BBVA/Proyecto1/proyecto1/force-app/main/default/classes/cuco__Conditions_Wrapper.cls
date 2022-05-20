/**
* ────────────────────────────────────────────────────────────────────
* Conditions_Wrapper
* Wrapper class for for Profitability Analysis and Profityability Sheet conditions
* ────────────────────────────────────────────────────────────────────
* @author      Torcuato Tejada <torcuato.tejada.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-02-10
* @modified
* @systemLayer Domain
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@SuppressWarnings('PMD.AvoidGlobalModifier, PMD.ExcessivePublicCount, PMD.TooManyFields')
global class Conditions_Wrapper {

    /* @description Product Name */
    @AuraEnabled
    global String productName {get; set;}

    /* @description Family Identifier  */
    @AuraEnabled
    global String familyId {get; set;}

    /* @description Family Name  */
    @AuraEnabled
    global String familyName {get; set;}

    /* @description Family Visualiztion Order */
    @AuraEnabled
    global Integer familyOrder {get; set;}

    /* @description Profitability Analysis Id */
    @AuraEnabled
    global String profitabilityAnalysisId {get; set;}

    /* @description Profitability Sheet Id */
    @AuraEnabled
    global String profitabilitySheetId {get; set;}

    /* @description Condition Id */
    @AuraEnabled
    global String id {get; set;}

    /* @description Condition Id */
    @AuraEnabled
    global String catalogConditionId {get; set;}

    /* @description Condition Name */
    @AuraEnabled
    global String name {get; set;}

    /* @description Condition Visualization Order */
    @AuraEnabled
    global Integer order {get; set;}

    /* @description Is Family Level condition? */
    @AuraEnabled
    global Boolean familyLevel {get; set;}

    /* @description Proposed Permillage */
    @AuraEnabled
    global Decimal pmg {get; set;}

    /* @description Proposed Minimum */
    @AuraEnabled
    global Decimal min {get; set;}

    /* @description Proposed Maximum */
    @AuraEnabled
    global Decimal max {get; set;}

    /* @description Proposed Fixed Rate */
    @AuraEnabled
    global Decimal fixed {get; set;}

    /* @description Proposed Percent Name */
    @AuraEnabled
    global String percent {get; set;}

    /* @description Proposed Postal Exemption */
    @AuraEnabled
    global Boolean mailExemption {get; set;}

    /* @description Proposed Postal Exemption */
    @AuraEnabled
    global Decimal mailExemptionAmount {get; set;}

    /* @description Proposed Exemption */
    @AuraEnabled
    global Boolean exemption {get; set;}

    /* @description Source */
    @AuraEnabled
    global String source {get; set;}

    /* @description Attributes */
    @AuraEnabled
    global List<ConditionAttribute> attributes {get; set;}

    /**
    * @description Condition attributes
    */
    global class ConditionAttribute {

        /* @description Attribute Id  */
        @AuraEnabled
        global String id {get; set;}

        /* @description Attribute Name  */
        @AuraEnabled
        global String name {get; set;}

        /* @description Attribute Type  */
        @AuraEnabled
        global String type {get; set;}

        /* @description Attribute Visible */
        @AuraEnabled
        global Boolean visible {get; set;}

        /* @description Attribute Order */
        @AuraEnabled
        global Integer order {get; set;}

        /* @description Attribute Unit Type */
        @AuraEnabled
        global String unitType {get; set;}

        /* @description Attribute Format Type  */
        @AuraEnabled
        global String formatType {get; set;}

        /* @description Attribute Field Name  */
        @AuraEnabled
        global String fieldName {get; set;}

        /* @description Attribute Proposed Field Name  */
        @AuraEnabled
        global String value {get; set;}
    }
}