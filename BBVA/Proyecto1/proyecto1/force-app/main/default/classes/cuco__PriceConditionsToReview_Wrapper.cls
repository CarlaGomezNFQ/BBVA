/**
* ────────────────────────────────────────────────────────────────────
* PriceConditionsToReview_Wrapper
* Wrapper class for for Profitability Analysis Wrapper
* ────────────────────────────────────────────────────────────────────
* @author      Carlos Pisador
* @modifiedBy
* @version     1.0
* @created     2021-04-07
* @modified
* @systemLayer Domain
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@SuppressWarnings('PMD.AvoidGlobalModifier, PMD.ExcessivePublicCount, PMD.TooManyFields')
global class PriceConditionsToReview_Wrapper implements Comparable {
    /**
    * @Description : condition
    */
    @AuraEnabled
    public String condition {get; set;}
    /**
    * @Description : delegated
    */
    @AuraEnabled
    public String delegated {get; set;}
    /**
    * @Description : proposed
    */
    @AuraEnabled
    public String proposed {get; set;}
    /**
    * @Description : order condition
    */
    @AuraEnabled
    public Decimal orderCondition {get; set;}
    /**
    * @Description : order
    */
    @AuraEnabled
    public Decimal orderFamily {get; set;}
    /**
    * @Description : family
    */
    @AuraEnabled
    public String family {get; set;}

    global Integer compareTo(Object compareTo) {

        PriceConditionsToReview_Wrapper comparePriceCond = (PriceConditionsToReview_Wrapper) compareTo;
        if (orderFamily > comparePriceCond.orderFamily) {
            return 1;
        } else if (orderFamily == comparePriceCond.orderFamily) {
            if (orderCondition > comparePriceCond.orderCondition) {
                return 1;
            } else if (orderCondition == comparePriceCond.orderCondition) {
                return 0;
            }
        }
        return -1;
    }
}