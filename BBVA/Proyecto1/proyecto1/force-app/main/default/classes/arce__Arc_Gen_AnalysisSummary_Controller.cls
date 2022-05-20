/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_AnalysisSummary_Controller
* @Author   ivan.cons.contractor@bbva.com
* @Date     Created: 2020-05-20
* @Group    ARCE
* ------------------------------------------------------------------------------------------------
* @Description: Controller for the Arc_Gen_AnalysisSummary cmp.
* ------------------------------------------------------------------------------------------------
* @Changes
*
* |2020-05-20 ivan.cons.contractor@bbva.com.
*              Class creation.
* 2020-10-20 alexander.munguia.contractor@bbva.com  header is added to the template type.
* 2020-10-29 alexander.munguia.contractor@bbva.com new methods to check modifiers and callout
* |2020-11-25 jose.hijar.contractor@bbva.com
*               callRatingEngine method copied from arce core and adapted to sp2 business logic
* 2021-03-18 alexander.munguia.contractor@bbva.com method updates GCP rating values
* 2021-05-18 saimassimilianno.jordana.contractor@bbva.com Add checkPmnsAlon and checkPmnsOvrl meth0ds to get Actions engine permission.
* |2020-05-14 amunguia.contractor@bbva.com  the prerating flow is activated for Anchor.
* |2020-05-19 amunguia.contractor@bbva.com  add error handling for Anchor.
* |2020-05-20    amunguia.contractor@bbva.com Add error handling for RatingEngine.
* |2021-07-22 saimassimilianno.jordana.contractor@bbva.com getStatusAndStage method added to verify if the analysis is validated.
* |2021-07-29 saimassimilianno.jordana.contractor@bbva.com callMultitemplateCtrllr and callMultiPersistenceEngine methods modified for 2012 model.
* |2021-08-02 saimassimilianno.jordana.contractor@bbva.com getRtngId new meth0d added and checkCompletenessCtrl
* |                                                        meth0d modified to work with 2012 model.
* |2021-10-19 saimassimilianno.jordana.contractor@bbva.com checkPmnsOvrl meth0d modified to change the conditions behavior.
* |2021-11-24 saimassimilianno.jordana.contractor@bbva.com change logic in getBSbuttonsPerm method to use dynamic actions.
* ------------------------------------------------------------------------------------------------
*/
@SuppressWarnings('sf:TooManyMethods')
public with sharing class Arc_Gen_AnalysisSummary_Controller {

  /**
  * @Description: string with the service name
  */
  Static Final String MODEL_2019 = '2019';

  /**
  * @Description: Decimal with the percentage to use.
  */
  Static Final Decimal HUNDRED = 100;

  /**
  * @Description: Decimal with the percentage to use.
  */
  Static Final Decimal EIGHTYFIVE = 85;

  /**
  * @Description: Decimal with the percentage to use.
  */
  Static Final Decimal SEVENTYFIVE = 75;

  /**
  * @Class: ClientData
  * @Description: Wrapper that contain all the rating service parameters
  * @author BBVA
  */
  public class ClientData {
    /**
    * @Description: Indicates name of the customer
    */
    @AuraEnabled public String customerName {get;set;}
    /**
    * @Description: Indicates if the numeber of the customer
    */
    @AuraEnabled public String customerId {get;set;}
  }

  /**
  * --------------------------------------------------------------------------------------
  * @description Builds and returns the wrapper with the chart parameters.
  * @param collectionType Key word for the chart creation.
  * @param acttyId Id of the activity split.
  * @param aHasAnalysId Id of the account has analysis.
  * @return Returns the wrapper with the chart parameters.
  **/
  @AuraEnabled
  public static Arc_Gen_ChartWrapper getWrapper(String collectionType, String acttyId, String aHasAnalysId) {
    Arc_Gen_ChartWrapper wrapper = Arc_Gen_ChartBuilder.getChartWrapper(collectionType, acttyId, aHasAnalysId);
    return wrapper;
  }

  /**
  * --------------------------------------------------------------------------------------
  * @description Checks if the form for the tab business risk is complete.
  * @param aHasAnalysId Id of the account has analysis.
  * @return Returns a list of missing elements to complete
  **/
  @AuraEnabled
  public static List<String> checkCompletenessCtrl(String aHasAnalysId, String modelSelctd) {
    final String objectToUse = modelSelctd == MODEL_2019 ? 'arce__Activity_Split__c' : 'arce__Activity_Split_2012__c';

    List<String> response = new List<String>();
    List<String> responseCompletion = new List<String>();
    final Map<String,String> subacttiesPickMap = arce.Arc_Gen_GenericUtilities.getPicklistLabels(objectToUse, 'arce__gf_subactivity_id__c');

    if (modelSelctd == MODEL_2019) {
      final List<arce__Activity_Split__c> acttiesList = Arc_Gen_Activities_Util.getAllActivitiesAndChildsByParent(new Set<String>{aHasAnalysId});
      if (Arc_Gen_Activities_Util.getOveralActivitiesPercentage(acttiesList) < EIGHTYFIVE) {
        response.add(System.Label.Arc_Gen_ActtiesMissing);
      }
      for (arce__Activity_Split__c actty : acttiesList) {
        if (Arc_Gen_Geographies_Util.getOveralGeographiesPercentage(actty.arce__Geographic_Splits__r) < SEVENTYFIVE) {
          response.add(System.Label.Arc_Gen_GeosMissing.replace('[SUBACTIVITY]',subacttiesPickMap.get(actty.arce__gf_subactivity_id__c)));
        }
        final sObject clonedAccty = actty.clone(true, true, false, false);
        responseCompletion.addAll(rspnseCompletion(subacttiesPickMap, clonedAccty));
      }
    } else {
      final List<arce__Activity_Split_2012__c> acttiesList2012 = Arc_Gen_Activities_Util.getAllActByParent2012(new Set<String>{aHasAnalysId});
      if (Arc_Gen_Activities_Util.getOveralActivitiesPrcntg2012(acttiesList2012) < EIGHTYFIVE) {
        response.add(System.Label.Arc_Gen_ActtiesMissing);
      }
      for (arce__Activity_Split_2012__c actty : acttiesList2012) {
        final sObject clonedAccty = actty.clone(true, true, false, false);
        responseCompletion.addAll(rspnseCompletion(subacttiesPickMap, clonedAccty));
      }
    }
    response.addAll(responseCompletion);

    System.debug('DEBUG: Arc_Gen_AnalysisSummary_Controller:checkCompletenessCtrl BeforeReturn -> completionInfo: '+ responseCompletion);
    return response;
  }

  /**
  * --------------------------------------------------------------------------------------
  * @description Checks if the form for the tab business risk is complete.
  * @param aHasAnalysId Id of the account has analysis.
  * @return Returns a list of missing elements to complete
  **/
  public static List<String> rspnseCompletion (Map<String,String> subactPickMap, sObject actty) {
    final System.Type objType = Type.forName('dyfr.Dynamic_Form_Completion');
    final dyfr.Form_Completion_Interface formClass = (dyfr.Form_Completion_Interface)objType.newInstance();
    final List<String> rspnseCompl = new List<String>();

    final String retJSON = formClass.getInfoCompletion((Id)actty.get('Id'), 'dyfr__Important__c', 'SP2-IRP-'+(String)actty.get('arce__Template_type__c'), null, null);
    final Arc_GBL_ValidationRating_Service_Corp.CompletionResult completionInfo = (Arc_GBL_ValidationRating_Service_Corp.CompletionResult) JSON.deserialize(retJSON, Arc_GBL_ValidationRating_Service_Corp.CompletionResult.class);
    for (String keyMap: completionInfo.getResultCompletion().keySet()) {
      if (completionInfo.getResultCompletion().get(keyMap).percentComplete < HUNDRED) {
        rspnseCompl.add(System.Label.Arc_Gen_FormMissing.replace('[SUBACTIVITY]',subactPickMap.get((String)actty.get('arce__gf_subactivity_id__c'))));
      }
    }
    return rspnseCompl;
  }

  /**
  * ---------- ----------------------------------------------------------------------------
  * @description Call the multitemplate service to retrieve the answers options
  * @param aHasAnalysId Id of the account has analysis.
  * @return Returns a list of missing elements to complete
  **/
  @AuraEnabled
  public static arce.Arc_Gen_RatingGlobal_service.AnchorData callAnchorEngine(String aHasAnalysId) {
    arce.Arc_Gen_RatingGlobal_service.AnchorData response = new arce.Arc_Gen_RatingGlobal_service.AnchorData();
    try {
      response = Arc_Gen_RatingGlobal_service.callAnchorEngine(aHasAnalysId);
    } catch (Exception ex) {
      System.debug(ex.getMessage());
      final arce.Arc_Gen_GlobalMessage.Message message = new arce.Arc_Gen_GlobalMessage.Message();
      message.addMessage(arce.Arc_Gen_RatingGlobal_Constants.KO500, System.Label.Arc_Gen_HandleErrors_Ratings, '');
      response.message = JSON.serialize(message);
    }
    return response;
  }

  /**
  * ---------- ----------------------------------------------------------------------------
  * @description Call the multitemplate service to retrieve the answers options
  * @param aHasAnalysId Id of the account has analysis.
  * @return Returns a list of missing elements to complete
  **/
  @AuraEnabled
  public static Arc_Gen_initAdjustment_Service.AdjustResponse getRtngId(String aHasAnalysId) {
    return Arc_Gen_initAdjustment_Controller.getRtngIdRiskAss(aHasAnalysId);
  }

  /**
  * --------------------------------------------------------------------------------------
  * @description Call the multitemplate service to retrieve the answers options
  * @param aHasAnalysId Id of the account has analysis.
  **/
  @AuraEnabled
  public static void callMultitemplateCtrllr(String aHasAnalysId, String modelSlctd) {
      Arc_Gen_SP2_Multitemplate_Service.callMultitmpltEngn(aHasAnalysId, modelSlctd);
  }
  /**
  * --------------------------------------------------------------------------------------
  * @description Call the multitemplate engine
  * @param aHasAnalysId Id of the account has analysis.
  **/
  @AuraEnabled
  public static void callMultiPersistenceEngine(String aHasAnalysId, String modelSlctd) {
    try {
      Arc_Gen_SP2_MultiPersistence_Service.callMultitemplateEngine(aHasAnalysId, modelSlctd);
    } catch (Exception ex) {
      System.debug(ex.getMessage() + ' - ' + ex.getStackTraceString());
      throw new Arc_Gen_SP2_MultiPersistence_Service.SP2MultitemplateException('Error Calling MultiTemplate Engine: ' + ex.getMessage());//NOSONAR
    }
  }

  /**
  * --------------------------------------------------------------------------------------
  * @description Call the persistModifiers engine
  * @param aHasAnalysId Id of the account has analysis.
  * @param methodType persistence type name.
  **/
  @AuraEnabled
  public static arce.Arc_Gen_PersistModifiers_Service.VariablePersistenceResult callPersistModifiers(String aHasAnalysId, String methodType) {
    arce.Arc_Gen_PersistModifiers_Service.VariablePersistenceResult response = new arce.Arc_Gen_PersistModifiers_Service.VariablePersistenceResult();
    try {
      final arce.Arc_Gen_PersistModifiers_Service calloutService = new arce.Arc_Gen_PersistModifiers_Service(methodType);
      response = calloutService.persistVariablesOfAnalysis(aHasAnalysId);
    } catch (Exception ex) {
      System.debug(ex.getMessage());
      response.serviceCode = arce.Arc_Gen_RatingGlobal_Constants.KO403;
      response.serviceMessage = addMessage(arce.Arc_Gen_RatingGlobal_Constants.KO403, arce.Arc_Gen_RatingGlobal_Constants.ERROR_TEXT, System.Label.Arc_Gen_HandleErrors_PersistModifiers);
    }
    return response;
  }

  /**
  * --------------------------------------------------------------------------------------
  * @description Check modifiers fields
  * @param aHasAnalysId Id of the account has analysis.
  * @param templateName name of the template.
  **/
  @AuraEnabled
  public static List<String> checkModifiers(String aHasAnalysId, String templateName) {
    final System.Type objType = Type.forName('dyfr.Dynamic_Form_Completion');
    Arc_GBL_ValidationRating_Service_Corp.CompletionResult completionInfo;
    final List<String> tabNames = System.Label.Arc_Gen_ModifiersTab.split(',');
    final List<String> tabIds = new List<String>();
    final Map<String, dyfr__Tab__c> res = Arc_Gen_DynForm_Utils.getTabsByTemplate(new Set<String>{templateName}, tabNames);
    tabIds.addAll(res.keySet());
    final dyfr.Form_Completion_Interface formClass = (dyfr.Form_Completion_Interface) objType.newInstance();
    final String retJSON = formClass.getInfoCompletion(aHasAnalysId, 'dyfr__Important__c', templateName, null, tabIds);
    final List<String> allEmptyFields = new List<String>();
    if (retJSON != null) {
      completionInfo = (Arc_GBL_ValidationRating_Service_Corp.CompletionResult) JSON.deserialize(retJSON, Arc_GBL_ValidationRating_Service_Corp.CompletionResult.class);
      for (String keyMap: completionInfo.getResultCompletion().keySet()) {
        if (completionInfo.getResultCompletion().get(keyMap).percentComplete < 100) {
          allEmptyFields.add(System.Label.Arc_Gen_FormMissing.replace('[SUBACTIVITY]',completionInfo.getResultCompletion().get(keyMap).nameTab));
        }
      }
    }
    return allEmptyFields;
  }

  /**
  *-------------------------------------------------------------------------------
  * @description Method that gets the response FROM the service class
  --------------------------------------------------------------------------------
  * @author jose.hijar.contractor@bbva.com
  * @date 2020-10-28
  * @param String analysisId
  * @return Arc_Gen_ServiceAndSaveResponse - A wrapper with the result of a DML operation and service call
  * @example public static Arc_Gen_ServiceAndSaveResponse setupRating(String analysisId,String customerId)
  **/
  @SuppressWarnings('PMD.ExcessiveParameterList')
  @AuraEnabled
  public static arce.Arc_Gen_ServiceAndSaveResponse callRatingEngine(String analysisId) {

    arce.Arc_Gen_ServiceAndSaveResponse response = new arce.Arc_Gen_ServiceAndSaveResponse();
    final Boolean hasPermissions=true;
    arce__Account_has_Analysis__c accHasAnalysis = arce.Arc_Gen_AccHasAnalysis_Data.getAccHasAnalysis(new List<String>{analysisId})[0];

    String subEventType = arce.Arc_Gen_RatingGlobal_Constants.RATINGCAL;
    String subprocessType = accHasAnalysis.arce__Analysis__r.arce__anlys_wkfl_sub_process_type__c;
    String ratingPreratingType = accHasAnalysis.arce__Analysis__r.arce__rating_prerating_type__c;
    if (subprocessType == '4' && ratingPreratingType == 'Prerating') {
      subEventType = arce.Arc_Gen_RatingGlobal_Constants.RATINGPRE;
    }
    //final Boolean hasPermissions = arce.Arc_Gen_TabSet_service.getPermissionToEdit(analysisId) == 'true';
    if (hasPermissions) {
      try {
        response = arce.Arc_Gen_RatingGlobal_service.setupRating(accHasAnalysis, null, subEventType);
        if(checkForValidState(response.serviceCode)) {
          updateOverlayObject(accHasAnalysis);
        }
        //arce.Arc_Gen_RatingGlobal_helper.checkForOverlayObject(wrapper);
        // Clear Leveraged Test results.
        //arce.Arc_Gen_TestLeverage_service.clearTestLeveragedResults(analysisId);
      } catch(Exception ex) {
        response.saveStatus = arce.Arc_Gen_RatingGlobal_Constants.FALSE_TEXT;
        response.serviceCode = arce.Arc_Gen_RatingGlobal_Constants.KO500;
        response.serviceMessage = addMessage(arce.Arc_Gen_RatingGlobal_Constants.KO500, arce.Arc_Gen_RatingGlobal_Constants.ERROR_TEXT, System.Label.Arc_Gen_HandleErrors_Ratings);
        System.debug('ERROR :: arce.Arc_Gen_CalculateRatingSP2_controller.callRatingEngine :: '+ex.getMessage());
        System.debug('ERROR :: arce.Arc_Gen_CalculateRatingSP2_controller.callRatingEngine :: '+ex.getStackTraceString());
      }
    } else {
      response.serviceCode = arce.Arc_Gen_RatingGlobal_Constants.KO403;
      response.serviceMessage = addMessage(arce.Arc_Gen_RatingGlobal_Constants.KO403, arce.Arc_Gen_RatingGlobal_Constants.ERROR_TEXT, arce.Arc_Gen_RatingGlobal_Constants.PERM_ERROR);
    }
    return response;
  }

  /**
  * ---------- ----------------------------------------------------------------------------
  * @description Call the Persistence service to retrieve the answers options
  * @param aHasAnalysId Id of the account has analysis.
  * @return Returns a list of missing elements to complete
  **/
  @AuraEnabled
  public static arce.Arc_Gen_ServiceAndSaveResponse callOverlayRating(String aHasAnalysId) {
    arce.Arc_Gen_ServiceAndSaveResponse response = new arce.Arc_Gen_ServiceAndSaveResponse();
    try {
      final arce__Account_has_Analysis__c accHasAnalysis = arce.Arc_Gen_AccHasAnalysis_Data.getAccHasAnalysis(new List<String>{aHasAnalysId})[0];
      final arce__Analysis__c analysis = arce.Arc_Gen_ArceAnalysis_Data.getArceAnalysisData(new List<Id>{accHasAnalysis.arce__Analysis__c})[0];
      final String subEvent = analysis.arce__rating_prerating_type__c == 'Rating' ? arce.Arc_Gen_RatingGlobal_Constants.METHOD_OVERLAY : arce.Arc_Gen_RatingGlobal_Constants.OVERLAY_PRERATING;
      response = arce.Arc_Gen_RatingGlobal_service.setupRating(accHasAnalysis, null, subEvent);
    } catch (Exception ex) {
      response.saveStatus = arce.Arc_Gen_RatingGlobal_Constants.FALSE_TEXT;
      response.serviceCode = arce.Arc_Gen_RatingGlobal_Constants.KO500;
      response.serviceMessage = addMessage(arce.Arc_Gen_RatingGlobal_Constants.KO500, arce.Arc_Gen_RatingGlobal_Constants.ERROR_TEXT, System.Label.Arc_Gen_HandleErrors_Ratings);
      System.debug('ERROR :: callOverlayRating :: '+ex.getMessage());
      System.debug('ERROR :: callOverlayRating :: '+ex.getStackTraceString());
    }
    return response;
  }


  /**
  *-------------------------------------------------------------------------------
  * @description method updates GCP rating values
  --------------------------------------------------------------------------------
  * @author alexander.munguia.contractor@bbva.com
  * @date 18/03/2021
  * @param String aHaId
  * @return arce__Overlay__c object. overlay updated
  * @example  public static arce__Overlay__c checkForOverlayObject(arce__Account_has_Analysis__c aHa)
  **/
  private static void updateOverlayObject(arce__Account_has_Analysis__c aHa) {
    final arce__Overlay__c overlayObj = arce.Arc_Gen_Overlays_Utils.getOverlaysByAha(new Set<String>{aHa.Id})[0];
    if(!String.isBlank(overlayObj.arce__Arc_Gen_LocalId_VC__c)) {
      final Set<String> cclients = new Set<String>();
      final List<dyfr__Dependent_value__c> localIdList = (List<dyfr__Dependent_value__c>) JSON.deserialize(overlayObj.arce__Arc_Gen_LocalId_VC__c, List<dyfr__Dependent_value__c>.class);
      for(dyfr__Dependent_value__c dependent : localIdList) {
          cclients.addAll(dependent.dyfr__LoV_values__c.split(','));
      }
      arce.Arc_Gen_Overlays_Utils.updateOverlayObject(aHa.Id, JSON.serialize(cclients), overlayObj);
    }
  }
  /**
  * @description checkForValidState
  * @author amunguia.contractor@bbva.com | 05-17-2021
  * @param String statusCode
  * @return Boolean
  **/
  private static Boolean checkForValidState(String statusCode) {
    return statusCode == arce.Arc_Gen_RatingGlobal_Constants.SUCC1 || statusCode == arce.Arc_Gen_RatingGlobal_Constants.SUCC2 || statusCode == arce.Arc_Gen_RatingGlobal_Constants.SUCC3;
  }
  /**
  * --------------------------------------------------------------------------------------
  * @description Checks if the analysis have permission by action engine.
  * @param aHasAnalysId Id of the account has analysis.
  * @return Returns a Boolean.
  **/
  @AuraEnabled
  public static Boolean checkPmnsAlon(String aHasAnalysId) {
    Boolean toReturn = false;
    final arce.Arc_Gen_RatingGlobal_data dataClass = new arce.Arc_Gen_RatingGlobal_data();
    final arce__rating__c currentRating = dataClass.getCurrentRating(aHasAnalysId);
    if (currentRating != null) {
      toReturn = arce.Arc_Gen_RatingGlobal_service.getPermissionIrp(currentRating.Id, System.Label.Arc_Gen_RuleSetIRP, 'Arc_Gen_Anchor_True')
              || arce.Arc_Gen_RatingGlobal_service.getPermissionIrp(currentRating.Id, System.Label.Arc_Gen_RuleSetIRP, 'Arc_Gen_Standalone_True')
              || arce.Arc_Gen_RatingGlobal_service.getPermissionIrp(currentRating.Id, System.Label.Arc_Gen_RuleSetIRP, 'Arc_Gen_Overlay_True');
      final arce__Account_has_Analysis__c accHasAnalysis = arce.Arc_Gen_AccHasAnalysis_Data.getAccHasAnalysis(new List<String>{aHasAnalysId})[0];
      if (accHasAnalysis.arce__IRP_Workflow__c == System.Label.Arc_Gen_NewRaipOverrideApi || accHasAnalysis.arce__IRP_Workflow__c == System.Label.Arc_Gen_NewRaipAdjustmentApi) {
        toReturn = true;
      }
    }

    return toReturn;
  }
  /**
  * --------------------------------------------------------------------------------------
  * @description Checks if the analysis have permission by action engine.
  * @param aHasAnalysId Id of the account has analysis.
  * @return Returns a Boolean.
  **/
  @AuraEnabled
  public static String checkPmnsOvrl(String aHasAnalysId) {
    Boolean toReturn = false;
    String response = addMessage(arce.Arc_Gen_RatingGlobal_Constants.SUCC1, '', '');
    final arce__Overlay__c overlayObj = arce.Arc_Gen_Overlays_Utils.getOverlaysByAha(new Set<String>{aHasAnalysId})[0];
    final arce.Arc_Gen_RatingGlobal_data dataClass = new arce.Arc_Gen_RatingGlobal_data();
    final arce__rating__c currentRating = dataClass.getCurrentRating(aHasAnalysId);

    // Conditions to verify if overlay can be calculated depending on explicit_guarantee and Parent_Relationship
    final Boolean overlCondt1 = overlayObj.arce__Arc_Gen_explicit_guarantee__c == '1' && String.isEmpty(overlayObj.arce__Arc_Gen_Parent_Short_Rating_GCP__c);
    final Boolean overlCondt2 = overlayObj.arce__Arc_Gen_explicit_guarantee__c == '2' && overlayObj.arce__Arc_Gen_Parent_Relationship__c == '1' && String.isEmpty(overlayObj.arce__Arc_Gen_Parent_Short_Rating_GCP__c);

    if (currentRating != null) {
      final arce__Account_has_Analysis__c accHasAnalysis = arce.Arc_Gen_AccHasAnalysis_Data.getAccHasAnalysis(new List<String>{aHasAnalysId})[0];
      toReturn = arce.Arc_Gen_RatingGlobal_service.getPermissionIrp(currentRating.Id, System.Label.Arc_Gen_RuleSetIRP, 'Arc_Gen_Standalone_True')
              || arce.Arc_Gen_RatingGlobal_service.getPermissionIrp(currentRating.Id, System.Label.Arc_Gen_RuleSetIRP, 'Arc_Gen_Overlay_True')
              || accHasAnalysis.arce__IRP_Workflow__c == System.Label.Arc_Gen_NewRaipOverrideApi || accHasAnalysis.arce__IRP_Workflow__c == System.Label.Arc_Gen_NewRaipAdjustmentApi;


      if(!toReturn) {
        response = addMessage(arce.Arc_Gen_RatingGlobal_Constants.KO500, '', System.Label.Arc_Gen_StandaloneMissing);
      }
    }
    if(toReturn && (overlCondt1 || overlCondt2 )) {
      response = addMessage(arce.Arc_Gen_RatingGlobal_Constants.KO500, '', System.Label.Arc_Gen_RecalculateRating_Required);
    }
    return response;
  }
  /**
  * @description addMessage
  * @author amunguia.contractor@bbva.com | 05-21-2021
  * @param String errorCode
  * @param String errorTitle
  * @param String message
  * @return String
  **/
  private static String addMessage (String errorCode, String errorTitle, String message) {
    final Map<String, Object> errorWrapper = new Map<String, Object>();
    errorWrapper.put('errorCode', errorCode);
    errorWrapper.put('errorTitle', errorTitle);
    errorWrapper.put('errorMessage', message);
    return JSON.serialize(errorWrapper);
  }

  /**
  * --------------------------------------------------------------------------------------
  * @description Checks if the analysis is already validated.
  * @param aHasAnalysId Id of the account has analysis.
  * @return Returns a Boolean.
  **/
  @AuraEnabled
  public static Boolean getBSbuttonsPerm(String aHasAnalysId) {
    final arce__Account_has_Analysis__c accHasAnalysis = arce.Arc_Gen_AccHasAnalysis_Data.getAccHasAnalysis(new List<String>{aHasAnalysId})[0];
    return arce.Arc_Gen_GetPermissions_Locator.getPermissionToEdit(accHasAnalysis.Id);
  }
}