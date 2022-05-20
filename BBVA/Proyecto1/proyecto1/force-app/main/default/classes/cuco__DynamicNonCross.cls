/**
  * ────────────────────────────────────────────────────────────────────
  * Wrapper for dynamic pricing setup
  * ────────────────────────────────────────────────────────────────────
  * @author      Oscar Gomez <oscar.gomez.arqueros.contractor@bbva.com>
  * @modifiedBy
  * @version     1.0
  * @created     2021-05-19
  * @modified
  * @systemLayer Domain
  * ────────────────────────────────────────────────────────────────────
  * @changes
  *
  * ────────────────────────────────────────────────────────────────────
  */

  global class DynamicNonCross {

    /**
    * @Description: List with dynamic classification
    */
    @AuraEnabled
    global List<DynamicClassification> lstDynamicClass {get; set;}

    global class DynamicClassification {

        /**
        * @Description: String with name
        */
        @AuraEnabled
        global String name {get; set;}

        /**
        * @Description: List with condition
        */
        @AuraEnabled
        global List<DynamicCondition> lstDynamicCond {get; set;}
    }

    global class DynamicCondition {
        /**
        * @Description: String with id of flat rate dp
        */
        @AuraEnabled
        global String idFlat {get; set;}

        /**
        * @Description: String with dynamic pricing
        */
        @AuraEnabled
        global String idDynamicPricing {get; set;}

        /**
        * @Description: String with name
        */
        @AuraEnabled
        global String name {get; set;}

        /**
        * @Description: List with attributes
        */
        @AuraEnabled
        global List<DynamicAttribute> lstDynamicAttb {get; set;}
    }

    global class DynamicAttribute {

        /**
        * @Description: String with name
        */
        @AuraEnabled
        global String name {get; set;}

        /**
        * @Description: String with value
        */
        @AuraEnabled
        global String value {get; set;}

        /**
        * @Description: String with value type
        */
        @AuraEnabled
        global String valueType {get;set;}

        /**
        * @Description: String with api name of custom field
        */
        @AuraEnabled
        global String apiName {get;set;}

        /**
        * @Description: String with id
        */
        @AuraEnabled
        global String id {get;set;}

        /**
        * @Description: String with position
        */
        @AuraEnabled
        global Integer position {get;set;}

        /**
        * @Description: Integer with max length value (If decimal field)
        */
        @AuraEnabled
        global Integer maxLength {get;set;}

        /**
        * @Description: String with step (If decimal field)
        */
        @AuraEnabled
        global String step {get;set;}
    }

    global class CrossAttributes {
        /**
        * @Description: String with id of flat rate dp
        */
        @AuraEnabled
        global String flatId {get; set;}

        /**
        * @Description: String with name
        */
        @AuraEnabled
        global String name {get; set;}

        /**
        * @Description: String with value
        */
        @AuraEnabled
        global String value {get; set;}

        /**
        * @Description: String with value type
        */
        @AuraEnabled
        global String valueType {get;set;}

        /**
        * @Description: String with id api name of custom field
        */
        @AuraEnabled
        global String apiName {get;set;}

        /**
        * @Description: String with id
        */
        @AuraEnabled
        global String id {get; set;}

        /**
        * @Description: String with dynamic pricing
        */
        @AuraEnabled
        global String idDynamicPricing {get;set;}

        /**
        * @Description: Integer with max length value (If decimal field)
        */
        @AuraEnabled
        global Integer maxLength {get;set;}

        /**
        * @Description: String with step (If decimal field)
        */
        @AuraEnabled
        global String step {get;set;}
    }

    global class HeaderAttribute {
        /**
        * @Description: String with id
        */
        @AuraEnabled
        global String id {get; set;}

        /**
        * @Description: String with name
        */
        @AuraEnabled
        global String name {get; set;}
    }
}