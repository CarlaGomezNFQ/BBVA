/**
* ────────────────────────────────────────────────────────────────────
* ConditionsValidationInput_Wrapper
* Wrapper class for for conditions change cmp
* ────────────────────────────────────────────────────────────────────
* @author      Torcuato Tejada <torcuato.tejada.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-04-22
* @modified
* @systemLayer Domain
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@SuppressWarnings('PMD.AvoidGlobalModifier')
global class ConditionsValidationInput_Wrapper {

    /**
    * @description conditions
    */
    @AuraEnabled
    global List<Condition> conditions {get; set;}

    /**
    * @description condition inner class
    */
    global class Condition {

        /**
        * @description ps_catalog_condition__c.Id
        */
        @AuraEnabled
        global String id  {get; set;}

        /**
        * @description ps_catalog_condition__c.cuco__gf_psc_condition_id__c
        */
        @AuraEnabled
        global String canonicalId  {get; set;}

        /**
        * @description condition attributes
        */
        @AuraEnabled
        global List<Attribute> attributes {get; set;}
    }

    /***
    * @description: Attributes
    */
    global class Attribute {

        /**
        * @description cuco__ps_catalog_condition_attribute__c.cuco__gf_psc_atribute_id__c
        */
        @AuraEnabled
        global String id  {get; set;}

        /**
        * @description cuco__ps_catalog_condition_attribute__c.cuco__gf_psc_condition_attribute_id__c
        */
        @AuraEnabled
        global String canonicalId  {get; set;}

        /**
        * @description value proposed
        */
        @AuraEnabled
        global String proposed  {get; set;}
    }
}