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
global class PriceFamily_Wrapper {

    /* @description family */
    @AuraEnabled
    public String family {get; set;}

    /* @description conditionList  */
    @AuraEnabled
    public List<PriceConditionsToReview_Wrapper> conditionList {get; set;}
}