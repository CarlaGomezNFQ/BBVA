/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_GBL_RatingDetailsMapping_Interface
* @Author   jose.hijar.contractor@bbva.com
* @Date     Created: 2020-11-03
* @Group    ARCE
* ------------------------------------------------------------------------------------------------
* @Description: Interface for declaration of mandatory methods for fields mapping from variables and adjustments
* ------------------------------------------------------------------------------------------------
* @Changes
*
* |2020-10-28 jose.hijar.contractor@bbva.com
*               inteface creation
*
* ------------------------------------------------------------------------------------------------
*/
@SuppressWarnings('PMD.ExcessiveParameterList')
global interface Arc_GBL_RatingDetailsMapping_Interface {

  arce__rating_variables_detail__c setRatingVariable(Map<String, Object> ratingVariablesMap,String aHaId,arce__rating__c rating);

  arce__rating_variables_detail__c setRatingModifier(Map<String, Object> ratingAdjustmentsMap,String aHaId,arce__rating__c rating);

  void updateOverlayObj(Map<String, Object> ratingAdjustmentsMap, String modifierId, arce__Overlay__c overlayOb);

  void setRating(Map<String, Object> ratingMap, String ratingType, arce__Account_has_Analysis__c accHasAnalysis, arce__rating__c rating);

  arce__rating_variables_detail__c setRatingCombinedRating(Map<String, Object> ratingAdjustmentsMap, String templateId, Decimal wheight, String aHaId, String ratingId);

  List<AggregateResult> getActivitiesWeightByTemplate(String parentId, Set<String> templates);

  AggregateResult getRelativeWeightSum(String parentId);
}