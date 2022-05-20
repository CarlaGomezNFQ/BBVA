global class Arc_Gen_RatingGlobal_Constants {

  /** @Description: string with the service name */
  global final static String OVERRIDE_SERVICE_NAME = 'overRating';
  /** @Description: string with the service name */
  global final static String RATING = 'Rating';
  /** @Description: string with the service name */
  global final static String CRP_SERVICE_NAME = 'overRatingCRP';
  /** @Description: string with the service name */
  global final static String ANCHOR_SERVICE_NAME = 'ratingAnchor';
  /** @Description: subevent to send preratings to prologis */
  global final static String FINALIZATION = 'FINALIZATION';
  /** @Description: string with the success code 200 */
  global final static String SUCC1 = '200';
  /** @Description: string with the success code 204 */
  global final static String SUCC2 = '204';
  /** @Description: string with the success code 201 */
  global final static String SUCC3 = '201';
  /** @Description: string with the error code 400 */
  global final static String KO400 = '400';
  /** @Description: string with the error code 403 */
  global final static String KO403 = '403';
  /** @Description: string with the error code 500 */
  global final static String KO500 = '500';
  /** @Description: Service response path group */
  global final static String PATHGR = 'GROUP';
  /** @Description: Service responsepath subsidiary */
  global final static String PATHSUB = 'SUBSIDIARY';
  /** @Description: Name of the bankId custom setting */
  global final static String BANK_ID = '0001';
  /** @Description: Service response rating method type override */
  global final static String METHOD_OVERRIDE = 'OVERRIDE';
  /** @Description: Service response rating method type overlay */
  global final static String METHOD_OVERLAY = 'OVERLAY';
  /** @Description: Service response rating method type anchor */
  global final static String METHOD_ANCHOR = 'ANCHOR';
  /** @Description: Service response rating method type anchor */
  global final static String ACTIVITY_TEMPLATE = 'ACTIVITY_TEMPLATE';
  /** @Description: List of rating values in short scale */
  global final static List<String> SHORT_RATING_LIST = Arc_Gen_GenericUtilities.getValuesPickList('arce__rating__c', 'arce__rating_short_value_type__c');
  /** @Description: List of rating values in long scale */
  global final static List<String> LONG_RATING_LIST = Arc_Gen_GenericUtilities.getValuesPickList('arce__rating__c', 'arce__rating_long_value_type__c');
  /** @Description: Name of the EncryptionFlag custom metadata */
  global final static String ENCRYPTION_FLAG = 'EncryptionFlag';
  /** @Description: Overlay rating type */
  global final static String FINANCIAL_ALERT = 'FINANCIAL_ALERT';
  /** @Description: Indicate if the overlay is Finacial alert */
  global final static String FINANCIAL_ALERT_IND = 'FINANCIAL_ALERT_INDICATOR';
  /** @Description: If the variable does not have any value */
  global final static String NOT_APPLY = 'NA';
  /** @Description: Financial alert type 2 */
  global final static String OVERLAY_02 = '02-OVERLAY';
  /** @Description: Financial alert type 3 */
  global final static String OVERLAY_03 = '03-OVERLAY';
  /** @Description: Financial alert type 4 */
  global final static String OVERLAY_04 = '04-OVERLAY';
  /** @Description: Long value indicator */
  global final static String LONG_TEXT = 'long';
  /** @Description: Short value indicator */
  global final static String SHORT_TEXT = 'short';
  /** @Description: Score value indicator */
  global final static String SCORE_TEXT = 'score';
  /** @Description: No value */
  global final static String NONE_TEXT = 'NONE';
  /** @Description: Service response identificator */
  global final static String SCORE = 'score';
  /** @Description: Service response identificator */
  global final static String LEVEL = 'level';
  /** @Description: Service response identificator */
  global final static String VARIABLE_TYPE = 'variableType';
  /** @Description: Service response identificator */
  global final static String PARENT_LEVEL = 'parentLevel';
  /** @Description: Service response identificator */
  global final static String PARENT_CODE = 'parentCode';
  /** @Description: Service response identificator */
  global final static String BLOCK_TYPE = 'blockType';
  /** @Description: Service response identificator */
  global final static String VALUE_TEXT = 'value';
  /** @Description: Service response identificator */
  global final static String ADJUSTED_VALUE = 'adjustedValue';
  /** @Description: Service response identificator */
  global final static String ADJUSTED_SCORE = 'adjustedScore';
  /** @Description: Service response identificator */
  global final static String MAXIMUM_SCORE = 'maximumScore';
  /** @Description: Service response identificator */
  global final static String MINIMUM_SCORE = 'minimumScore';
  /** @Description: Service response identificator */
  global final static String MODIFIER = 'modifier';
  /** @Description: Service response identificator */
  global final static String MODIFIER_TYPE = 'modifierType';
  /** @Description: Service response identificator */
  global final static String OVERLAY_PARAM = '999';
  /** @Description: Service response identificator */
  global final static String SHORT_VALUE = 'shortScaleValue';
  /** @Description: Service response identificator */
  global final static String LONG_VALUE = 'longScaleValue';
  /** @Description: Service response identificator */
  global final static String LARGE_VALUE = 'largeScaleValue';
  /** @Description: Service response identificator */
  global final static String DESCRIPTION = 'description';
  /** @Description: Service response identificator */
  global final static String ADJUSTMENT_TYPE = 'adjustmentType';
  /** @Description: Service response identificator */
  global final static String DEFAULT_PROBABILITY = 'defaultProbability';
  /** @Description: Service response identificator */
  global final static String DATA_TEXT = 'data';
  /** @Description: Service response identificator */
  global final static String RATING_TEXT = 'ratings';
  /** @Description: Service response identificator */
  global final static String COMBINED_RATING_TEXT = 'combinedRating';
  /** @Description: Service response identificator */
  global final static String TOOL_TEXT = 'tool';
  /** @Description: Service response identificator */
  global final static String TEMPLATE_TEXT = 'template';
  /** @Description: Service response identificator */
  global final static String ANCHORS_TEXT = 'anchors';
  /** @Description: Service response identificator */
  global final static String RISK_SCORE_TEXT = 'businessRiskScore';
  /** @Description: Service response identificator */
  global final static String FINAL_RATING = 'FINAL';
  /** @Description: Service response identificator */
  global final static String STANDALONE_RATING = 'STANDALONE';
  /** @Description: Service response identificator */
  global final static String ANCHOR_RATING = 'ANCHOR';
  /** @Description: Service response identificator */
  global final static String FINAL_PRERATING = 'PRERATING_FINAL';
  /** @Description: Service response identificator */
  global final static String STNDLN_PRERATING = 'PRERATING';
  /** @Description: Service response identificator */
  global final static String ANCHOR_PRERATING = 'PRERATING_ANCHOR';
  /** @Description: Service response identificator */
  global final static String OVERLAY_PRERATING = 'PRERATING_OVERLAY';
  /** @Description: Service response identificator */
  global final static String INDUSTRY_RISK_RATING = 'INDUSTRY_RISK_RATING';
  /** @Description: Service response identificator */
  global final static String SME_INDICATOR = 'isSmallMediumEnterprise';
  /** @Description: Service response identificator */
  global final static String ID_TEXT = 'id';
  /** @Description: Service response identificator */
  global final static String VARIABLES = 'variables';
  /** @Description: Service response identificator */
  global final static String ADJUSTMENTS = 'adjustments';
  /** @Description: Service response identificator */
  global final static String CODE_TEXT = 'code';
  /** @Description: Service response evaluationDate */
  global final static String EVALDATE = 'evaluationDate';
  /** @Description: Service response rating type */
  global final static String RATINGTYPE = 'ratingType';
  /** @Description: Service response rating method type validation */
  global final static String RATINGVAL = 'VALIDATION';
  /** @Description: Service response rating method type calculation */
  global final static String RATINGCAL = 'CALCULATION';
  /** @Description: Service response rating method type calculation */
  global final static String RATINGPRE = 'PRERATING';
  /** @Description: Parent code number for qualitative variables. */
  global final static String QUALITATIVE_VAR_CODE = '2';
  /** @Description: Error Literal */
  global final static String ERROR_TEXT = 'Error';
  /** @Description: False Literal */
  global final static String FALSE_TEXT = 'false';
  /** @Description: Permisson error Literal */
  global final static String PERM_ERROR = 'You do not have permission to edit this analysis.';
  /** @Description: Fatal error Literal */
  global final static String FATAL_ERROR = 'An unexpected error occurred: could not save to the database. Please contact your system administrator or try again later';

  private Arc_Gen_RatingGlobal_Constants() {}
}