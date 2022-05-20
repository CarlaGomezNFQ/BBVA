/**
* ────────────────────────────────────────────────────────────────────
* ConditionsValidationErrors_Wrapper
* Wrapper class for for condition validation errors
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
global class ConditionsValidationErrors_Wrapper {

    /**
    * @description conditions
    */
    @AuraEnabled
    global List<Condition> conditions {get; set;}

    /**
    * @description Condition inner class
    */
    global class Condition {

        /**
        * @description condition name
        */
        @AuraEnabled
        global String title  {get; set;}

        /**
        * @description error messages
        */
        @AuraEnabled
        global List<String> messages {get; set;}
    }
}