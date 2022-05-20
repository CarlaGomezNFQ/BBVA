/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_GBL_SampleRatingDetailsMapping
* @Author   joseluis.garcia4.contractor@bbva.com
* @Date     Created: 2021-03-10
* @Group    ARCE
* ------------------------------------------------------------------------------------------------
* @Description: Sample class for test execution.
* ------------------------------------------------------------------------------------------------
* @Changes
*
* |2021-03-10 joseluis.garcia4.contractor@bbva.com
*             Class creation
*
* ------------------------------------------------------------------------------------------------
*/
public with sharing class Arc_GBL_SampleRatingDetailsMapping implements Arc_GBL_RatingDetailsMapping_Interface {
    public arce__rating_variables_detail__c setRatingVariable(Map<String, Object> ratingVariablesMap,String aHaId,arce__rating__c rating) {
        return new arce__rating_variables_detail__c();
    }

    public arce__rating_variables_detail__c setRatingModifier(Map<String, Object> ratingAdjustmentsMap,String aHaId,arce__rating__c rating) {
        return new arce__rating_variables_detail__c();
    }

    public void updateOverlayObj(Map<String, Object> ratingAdjustmentsMap, String modifierId, arce__Overlay__c overlayOb) {
        // Sample method for testing.
    }

    public void setRating(Map<String, Object> ratingMap, String ratingType, arce__Account_has_Analysis__c accHasAnalysis, arce__rating__c rating) {
        // Sample method for testing.
    }

    @SuppressWarnings('PMD.ExcessiveParameterList')
    public arce__rating_variables_detail__c setRatingCombinedRating(Map<String, Object> ratingAdjustmentsMap, String templateId, Decimal wheight, String aHaId, String ratingId) {
        return new arce__rating_variables_detail__c();
    }

    public List<AggregateResult> getActivitiesWeightByTemplate(String parentId, Set<String> templates) {
        return new List<AggregateResult>();
    }

    public AggregateResult getRelativeWeightSum(String parentId) {
        return null;
    }
}