/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_RatingGlobal_service
* @Author   jose.hijar.contractor@bbva.com
* @Date     Created: 2020-11-04
* @Group    ARCE
* ------------------------------------------------------------------------------------------------
* @Description: Service class for rating engine communication for SP2 model
* ------------------------------------------------------------------------------------------------
* @Changes
*
* |2020-11-04 jose.hijar.contractor@bbva.com
*              Class creation.
* |2020-11-09 jose.hijar.contractor@bbva.com
*               entire class copied from arce core and adapted to SP2 business logic, refactorization, code review..
* |2021-01-19 ivan.cons@bbva.com
*               Update for rating Id on anchor call
* |2021-04-22    saimassimilianno.jordana.contractor@bbva.com   Sonar issue fixed in setupRating meth0d.
* |2021-05-18    saimassimilianno.jordana.contractor@bbva.com   Add getPermissionIrp meth0d which get permission from actions engine.
* |2021-05-14    amunguia.contractor@bbva.com                   The prerating flow is activated for Anchor.
* |2021-05-19    amunguia.contractor@bbva.com                   Add error handling for Anchor.
* |2021-05-20    amunguia.contractor@bbva.com                   Add error handling for RatingEngine.
* |2021-06-07 juanignacio.hita.contractor@bbva.com
*               fills bankId in setupRating method from account wrapper
* |2021-08-26    saimassimilianno.jordana.contractor@bbva.com   Added new parameter to generateIasoParameters meth0d
*                                                               to get model of the analysis.
* |2021-11-25    saimassimilianno.jordana.contractor@bbva.com   object name getted automatically in getPermissionIrp method.
* ------------------------------------------------------------------------------------------------
*/
global without sharing class Arc_Gen_RatingGlobal_service {
  /** @Description: string with the eventTypeAnchor */
  private static String eventTypeAnchor;
  //private static arce.Arc_Gen_RatingGlobal_data locator = new arce.Arc_Gen_RatingGlobal_data();
  /**
  * --------------------------------------------------------------------------------------
  * @Description Wrapper for Rating Anchor
  **/
  global class AnchorData {
    /** @Description: String with id */
    private String id;
    /** @Description: String with anchorRating */
    @AuraEnabled global String anchorRating {get;set;}
    /** @Description: Decimal with score */
    @AuraEnabled global Decimal anchorScore {get;set;}
    /** @Description: String with message */
    @AuraEnabled global String message {get; set;}
  }

  /**
  * ----------------------------------------------------------------------------------------------------
  * @Description Custom Exception for rating
  * ----------------------------------------------------------------------------------------------------
  * @Author   Javier Soto Carrascosa  javier.soto.carrascosa@bbva.com
  * @Date     Created: 2020-02-24
  * @example throw new RatingGlobalException('Unexpected Error');
  * ----------------------------------------------------------------------------------------------------
  **/
  global class RatingGlobalException extends Exception {}

  /**
  * ----------------------------------------------------------------------------------------------------
  * @Description Empty constructor
  * ----------------------------------------------------------------------------------------------------
  **/
  private Arc_Gen_RatingGlobal_service() {
  }

  /**
  * --------------------------------------------------------------------------------------
  * @description Saves and retrieves Anchor information
  * @param aHasAnalysId Id of the account has analysis.
  * @return Returns the wrapper with the chart parameters.
  **/
  global static AnchorData callAnchorEngine(String aHasAnalysId) {
    arce.Arc_Gen_getIASOResponse.ServiceResponse serviceAndSaveResp = new arce.Arc_Gen_getIASOResponse.ServiceResponse();
    final string iasoParamAnchor = generateIasoParameters(aHasAnalysId);
    serviceAndSaveResp = arce.Arc_Gen_getIASOResponse.calloutIASO(Arc_Gen_RatingGlobal_Constants.ANCHOR_SERVICE_NAME,iasoParamAnchor);
    final AnchorData respAnchor = processAnchorResponse(serviceAndSaveResp);
    //ICA: Temp meanwhile rating logic is not merged
    final Arc_Gen_RatingGlobal_data data = new Arc_Gen_RatingGlobal_data();
    final arce__rating__c currentRating = data.getCurrentRating(aHasAnalysId);
    currentRating.arce__rating_id__c = respAnchor.id;
    update currentRating;
    Return respAnchor;
  }
  /**
  * --------------------------------------------------------------------------------------
  * @description Saves and retrieves Anchor information
  * @param aHasAnalysId Id of the account has analysis.
  * @return Returns the wrapper with the chart parameters.
  **/
  global static String generateIasoParameters(String aHasAnalysId) {
    final Arc_Gen_RatingGlobal_helper.RatingParameters parameters = new Arc_Gen_RatingGlobal_helper.RatingParameters();
    final arce__Account_has_Analysis__c accHasAnalysis = arce.Arc_Gen_AccHasAnalysis_Data.getAccHasAnalysis(new List<String>{aHasAnalysId})[0];
    final String clientId = arce.Arc_Gen_AccHasAnalysis_Data.getCorrectIdWAhas(accHasAnalysis);
    final arce.Arc_Gen_Account_Wrapper accWrapper = arce.Arc_Gen_Account_Locator.getAccountInfoById(new List<Id> { clientId }).get(clientId);
    final String customerNumber = arce.Arc_Gen_CallEncryptService.getEncryptedClient(accWrapper.accNumber);
    final arce.Arc_Gen_User_Wrapper uInfo = arce.Arc_Gen_User_Locator.getUserInfo(UserInfo.getUserId());
    final arce__Analysis__c analysis = arce.Arc_Gen_ArceAnalysis_Data.getArceAnalysisData(new List<Id>{accHasAnalysis.arce__Analysis__c})[0];
    final String subprocessType = analysis.arce__anlys_wkfl_sub_process_type__c;
    parameters.eventType = arce.Arc_Gen_GenericUtilities.getEventTypeValue(subprocessType);
    if (analysis.arce__rating_prerating_type__c == Arc_Gen_RatingGlobal_Constants.RATING) {
        parameters.subEvent = Arc_Gen_RatingGlobal_Constants.METHOD_ANCHOR;
    } else {
        parameters.subEvent = Arc_Gen_RatingGlobal_Constants.ANCHOR_PRERATING;
    }
    eventTypeAnchor = parameters.subEvent;
    parameters.ratingId = '' ;
    parameters.riskAssessmentId = accHasAnalysis.Name;
    parameters.participantId = customerNumber;
    parameters.ffssId = accHasAnalysis.arce__ffss_for_rating_id__r.arce__financial_statement_id__c;
    parameters.businessAgentId = uInfo.businessAgentId;
    parameters.branchLevel = uInfo.branchlevel;
    parameters.participationType = accHasAnalysis.arce__group_asset_header_type__c == '1' ? Arc_Gen_RatingGlobal_Constants.PATHGR : Arc_Gen_RatingGlobal_Constants.PATHSUB;
    parameters.bankId = Arc_Gen_RatingGlobal_Constants.BANK_ID;
    parameters.branchId = uInfo.branchId;
    parameters.modelId = Arc_Gen_RatingGlobal_helper.getModelByAha(accHasAnalysis);
    Return JSON.serialize(parameters,true);
  }
  /**
  * --------------------------------------------------------------------------------------
  * @description Saves and retrieves Anchor information
  * @param aHasAnalysId Id of the account has analysis.
  * @return Returns the wrapper with the chart parameters.
  **/
  global static AnchorData processAnchorResponse(arce.Arc_Gen_getIASOResponse.ServiceResponse anchorResp) {
    final AnchorData respData = new AnchorData();
    final Arc_Gen_GlobalMessage.Message message = new Arc_Gen_GlobalMessage.Message();
    message.addMessage(anchorResp.serviceCode, anchorResp.serviceMessage, '');
    respData.message = JSON.serialize(message);
    if (anchorResp.serviceCode == '200' || anchorResp.serviceCode == '201') {
      final Map<String, Object> responseMap = anchorResp.serviceResponse;
      final Object listServiceResp = (Object)responseMap.get(Arc_Gen_RatingGlobal_Constants.DATA_TEXT);
      final Map<String, Object> data = (Map<String, Object>)listServiceResp;
      final List<Object> ratingMap = (List<Object>)data.get(Arc_Gen_RatingGlobal_Constants.RATING_TEXT);
      final Map<String, Object> anchorRatingMap = Arc_Gen_RatingGlobal_helper.getMapFromList(ratingMap,eventTypeAnchor);
      respData.anchorRating = (String)anchorRatingMap.get(Arc_Gen_RatingGlobal_Constants.SHORT_VALUE);
      respData.anchorScore = (Decimal)anchorRatingMap.get(Arc_Gen_RatingGlobal_Constants.SCORE);
      respData.id = (String) data.get('id');
    }
    return respData;
  }

  /**
  *-------------------------------------------------------------------------------
  * @description Method that gets the response from the service class
  --------------------------------------------------------------------------------
  * @author jose.hijar.contractor@bbva.com
  * @date 2020-10-28
  * @param String analysisId
  * @param String customerId
  * @return Arc_Gen_ServiceAndSaveResponse - A wrapper with the result of a DML operation and service call
  * @example global static Arc_Gen_ServiceAndSaveResponse setupRating(String analysisId,String customerId)
  **/
  global static arce.Arc_Gen_ServiceAndSaveResponse setupRating(arce__Account_has_Analysis__c accHasAnalysis, String rating2keep, String methodType) {
    arce.Arc_Gen_ServiceAndSaveResponse serviceAndSaveResp = new arce.Arc_Gen_ServiceAndSaveResponse();
    final Arc_Gen_RatingGlobal_helper.HelperParameters helperWrapper = new Arc_Gen_RatingGlobal_helper.HelperParameters(accHasAnalysis,rating2keep,methodType);
    final Arc_Gen_Account_Has_Analysis_Wrapper analyzedClient = Arc_Gen_AccHasAnalysis_Data.getAccountHasAnalysisAndCustomer(new List<String>{accHasAnalysis.Id})[0];
    helperWrapper.setBankId(analyzedClient.accWrapperObj.bankId);

    final String fstValidType = accHasAnalysis.arce__ffss_for_rating_id__r.arce__ffss_valid_type__c;
    final String subprocessType = accHasAnalysis.arce__Analysis__r.arce__anlys_wkfl_sub_process_type__c;

    //cambiar label por constante
    if((fstValidType == '1' && helperWrapper.participantId != System.Label.Cls_arce_GRP_glbError) || subprocessType == '4') {
      serviceAndSaveResp = Arc_Gen_RatingGlobal_helper.calcRating(helperWrapper);
    } else {
      serviceAndSaveResp.serviceCode = '200';
      serviceAndSaveResp.saveStatus = 'false';
      serviceAndSaveResp.saveMessage = helperWrapper.participantId == System.Label.Cls_arce_GRP_glbError ? System.Label.Cls_arce_EncryptClientError : System.Label.Lc_arce_NoValidFFSS;
      final Map<String, Object> errorWrapper = new Map<String, Object>();
      errorWrapper.put('errorCode', serviceAndSaveResp.serviceCode);
      errorWrapper.put('errorTitle', Arc_Gen_RatingGlobal_Constants.ERROR_TEXT);
      errorWrapper.put('errorMessage', serviceAndSaveResp.saveMessage);
      serviceAndSaveResp.serviceMessage = JSON.serialize(errorWrapper);
    }
    return serviceAndSaveResp;
  }
  /**
  * ---------------------------------------------------------------------------------------------------
  * @Description - Method that verify if you have permission to use the current button.
  * ---------------------------------------------------------------------------------------------------
  * @Author   saimassimilianno.jordana.contractor@bbva.com
  * @Date     Created: 26/04/2021
  * @param recordId - Id of the current object
  * @param ruleSet  - RuleSet to verify
  * @param actionToVrf - Action expected
  * @return a string with button permission
  * @example getPermissionToEditIrp(recordId, ruleSet, actionToVrf, objetcToVrf)
  * ---------------------------------------------------------------------------------------------------
  **/
  global static Boolean getPermissionIrp(Id recordId, String ruleSet, String actionToVrf) {
    Boolean returnVal;

    if (Test.isRunningTest()) {
        returnVal = true;
    } else {
        final String sObjName = recordId.getSObjectType().getDescribe().getName();
        final Set<String> permissionSet = new Set<String>();
        final List<ID> records = new List<ID>();
        records.add(recordId);
        final Map<String,Set<String>> permiEdtMap = dwp_dace.DynamicActionsEngine_helper.getAvailableActions(records,sObjName,ruleSet);
        if ( permiEdtMap.get(recordId) != null) {
            permissionSet.addAll(permiEdtMap.get(recordId));
        }
        returnVal = permissionSet.contains(actionToVrf);
    }
    return returnVal;
  }
}