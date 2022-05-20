/**
* ────────────────────────────────────────────────────────────────────
* PriceDecision_Wrapper
* Wrapper class for for Price Decision component
* ────────────────────────────────────────────────────────────────────
* @author      Miguel Cabrera <miguel.cabrera@bbvaitspain.com>
* @modifiedBy
* @version     1.0
* @created     2021-05-04
* @modified
* @systemLayer Domain
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@SuppressWarnings('PMD.AvoidGlobalModifier')
global class PriceDecision_Wrapper {

    /* @description id */
    @AuraEnabled
    global String id {get; set;}

    /* @description name  */
    @AuraEnabled
    global String name {get; set;}

    /* @description style  */
    @AuraEnabled
    global String style {get; set;}
}