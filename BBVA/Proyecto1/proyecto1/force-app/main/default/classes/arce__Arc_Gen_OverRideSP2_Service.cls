/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_OverRideSP2_Service
* @Author   jose.hijar.contractor@bbva.com
* @Date     Created: 2020-11-27
* @Group    ARCE
* ------------------------------------------------------------------------------------------------
* @Description: Class that get data and create json to persist.
* ------------------------------------------------------------------------------------------------
* @Changes
*
* |2020-11-27 jose.hijar.contractor@bbva.com
*              Class creation.
* |2021-05-06 saimassimilianno.jordana.contractor@bbva.com
*             Add new public String rarRatingTool, verify irpWorkflow field in persistOR meth0d to choose correct serviceName
*             and add new parameter to Arc_Gen_GenericUtilities.getEventTypeValue in setServiceParameters meth0d.
* |2021-05-13 saimassimilianno.jordana.contractor@bbva.com
*             Add ternary if to get correct value of ffssId.
* |2021-05-20 ivan.cons@bbva.com
*             Added override reason to persistence

* ------------------------------------------------------------------------------------------------
*/
@SuppressWarnings('PMD, sf:TooManyMethods')
public without sharing class Arc_Gen_OverRideSP2_Service {

  /**
  * @Class: OverRideParameters
  * @Description: Wrapper that contain all the rating override parameters
  * @author BBVA
  */
  public class OverRideParameters {
    /**
    * @Description: eventType identifier.
    */
    public String eventType {get;set;}
    /**
    * @Description: Business agent identifier that starts the rating study.
    */
    public String businessAgentId {get;set;}
    /**
    * @Description: Unique bank identifier.
    */
    public String bankId {get;set;}
    /**
    * @Description: Unique branch identifier when the assessment is created.
    */
    public String branchId {get;set;}
    /**
    * @Description: Unique level of branch identifier.
    */
    public String branchLevel {get;set;}
    /**
    * @Description: Indicates the participation type that the participant of the analysis
    * has within the Economic Group to which it belongs.
    */
    public String participationType {get;set;}
    /**
    * @Description: Identificator of the Financial Statement
    */
    public String ffssId {get;set;}
    /**
    * @Description: DateTime to call service
    */
    public String evaluationDate {get;set;}
    /**
    * @Description: Adjustment Description
    */
    public String adjDesc {get;set;}
    /**
    * @Description: Adjustment Value
    */
    public String adjValue {get;set;}
    /**
    * @Description: ratingScale Value
    */
    public String ratingScale {get;set;}
    /**
    * @Description: Identificator of the analyzed client (Not the standard Salesforce Id)
    */
    public String riskAssessmentId {get;set;}
    /**
    * @Description: Account Number of the Customer
    */
    public String participantId {get;set;}
    /**
    * @Description: Identificator of the rating in Salesforce
    */
    public String ratingid {get;set;}
    /**
    * @Description: Identificator of the rar rating tool
    */
    public String rarRatingTool {get;set;}
    /**
    * @Description: override reason.
    */
    public String reason {get;set;}
  }
  /*------------------------------------------------------------------------------------------------------
  *@Description Builder Arc_Gen_OverRideSP2_Service
  * -----------------------------------------------------------------------------------------------------
  * @Author   Ricardo Almanza
  * @Date     2020-06-02
  * @param    null
  * @return   Arc_Gen_OverRideSP2_Service
  * @example  new Arc_Gen_OverRideSP2_Service()
  * */
  @TestVisible
  private Arc_Gen_OverRideSP2_Service() {}
  /*------------------------------------------------------------------------------------------------------
  *@Description Method to persist persistOverRide
  * -----------------------------------------------------------------------------------------------------
  * @Author   Ricardo Almanza
  * @Date     2020-06-02
  * @param    List<String> ahaIdList Id's of account
  * @param    List<sObject> ahaList Accounts to persist
  * @return   boolean to confirm persistance
  * @example  succes = Arc_Gen_OverRideSP2_Service.persistOR(new List<String>(arcAcc),listAccs,rvdList)
  * */

  public static Arc_Gen_wrpSave persistOR(arce__Account_has_Analysis__c aha, List<arce__rating_variables_detail__c> rvdList) {
    return persistOR(aha, rvdList, false);
  }

  public static Arc_Gen_wrpSave persistOR(arce__Account_has_Analysis__c aha, List<arce__rating_variables_detail__c> rvdList, Boolean specifiedScale) {
    /*
    ahaIdList        ->      set de id's de accountHasAnalysis a procesar
    ahaList  ->      lista de objetos accountHasAnalysis a procesar
    rvdList      ->      lista de ratingVariablesDetail a procesar
    */
    final List<arce__rating_variables_detail__c> rvdsToPersist = new List<arce__rating_variables_detail__c>();
    Arc_Gen_getIASOResponse.serviceResponse response;
    Arc_Gen_ServiceAndSaveResponse response2;
    String errMsg;
    String parametersJson;
    Boolean result = true;
    final String irpWorkflow = aha.arce__IRP_Workflow__c;
    final String serviceName = irpWorkflow == System.Label.Arc_Gen_NewRaipOverrideApi ? arce.Arc_Gen_RatingGlobal_Constants.CRP_SERVICE_NAME : arce.Arc_Gen_RatingGlobal_Constants.OVERRIDE_SERVICE_NAME;

    for (arce__rating_variables_detail__c rvd : rvdList) {
      final boolean resultConditional = setConditionalResult(rvd,aha);
      if(resultConditional) {
        rvdsToPersist.add(rvd);
      }
    }

    for (arce__rating_variables_detail__c rvdToPers : rvdsToPersist) {
      parametersJson=setServiceParameters(aha, rvdToPers,specifiedScale);
      try {
        response = Arc_Gen_getIASOResponse.calloutIASO(serviceName, parametersJson);
        final Boolean responseCode = evaluateOverrideResponse(response.serviceCode);
        if(responseCode) {
          response2 = arce.Arc_Gen_RatingGlobal_service.setupRating(aha, (String)rvdToPers.Id, arce.Arc_Gen_RatingGlobal_Constants.METHOD_OVERRIDE);
          if(!evaluateRatingResponse(response2.serviceCode)) {
            Map<String, Object> errorMap = (Map<String, Object>)JSON.deserializeUntyped(response2.serviceMessage);
            result = false;
            errMsg = (String)errorMap.get('errorTitle') + (String)errorMap.get('errorMessage') + ' ' + (String)errorMap.get('errorCode');
          }
        } else {
          result = false;
          errMsg = arce.Arc_Gen_RatingGlobal_Constants.FATAL_ERROR;
        }
      } catch(CalloutException e) {
        result = false;
        errMsg = String.valueOf(e);
      }
    }
    return new Arc_Gen_wrpSave(result,errMsg,null);
  }

  /**
  *-------------------------------------------------------------------------------
  * @description Method that process the service response and assign the rating fields
  --------------------------------------------------------------------------------
  * @author ricardo.almanza.contractor@bbva.com
  * @date 19/2/2020
  * @param arce__Account_has_Analysis__c analyzedClient Account has analisis to call the WS
  * @param String customerId Account id to call WS
  * @param String methodType type of operation the service expects
  * @return String parameters for WS
  * @example setServiceParameters(arce__Account_has_Analysis__c analyzedClient,String customerId, String methodType)
  **/
  private static String setServiceParameters(arce__Account_has_Analysis__c analyzedClient, arce__rating_variables_detail__c rvd, Boolean specifiedScale) {
    final String irpWorkflow = analyzedClient.arce__IRP_Workflow__c;
    final String customerNumber = getCustomerNumber(analyzedClient.Id);
    final arce.Arc_Gen_RatingGlobal_data ratingSp2Data = new arce.Arc_Gen_RatingGlobal_data();
    final String customerId = Arc_Gen_CallEncryptService.getEncryptedClient(customerNumber);
    final Arc_Gen_User_Wrapper uInfo = Arc_Gen_User_Locator.getUserInfo(UserInfo.getUserId());
    final OverRideParameters parameters = new OverRideParameters();
    final String subprocessType = analyzedClient.arce__Analysis__r.arce__anlys_wkfl_sub_process_type__c;

    final String eventType = arce.Arc_Gen_GenericUtilities.getEventTypeValue(subprocessType, irpWorkflow);
    final String shortRating = String.isBlank(rvd.arce__adj_short_rating_value_type__c) ? '' : rvd.arce__adj_short_rating_value_type__c;
    final String longRating = String.isBlank(rvd.arce__adj_long_rating_value_type__c) ? '' : rvd.arce__adj_long_rating_value_type__c;
    final String ratingScale = specifiedScale ? analyzedClient.arce__rating_scale_type__c : '2';
    parameters.rarRatingTool = ratingSp2Data.getCurrentRating(analyzedClient.Id)?.arce__rar_rating_tool_id__c;
    parameters.eventType = eventType;
    parameters.businessAgentId = uInfo.businessAgentId;
    parameters.bankId = arce.Arc_Gen_RatingGlobal_Constants.BANK_ID;
    parameters.branchId = uInfo.branchId;
    parameters.branchLevel = uInfo.branchlevel;
    parameters.participationType = analyzedClient.arce__group_asset_header_type__c == '1' ? arce.Arc_Gen_RatingGlobal_Constants.PATHGR : arce.Arc_Gen_RatingGlobal_Constants.PATHSUB;
    parameters.ffssId = String.isBlank(analyzedClient.arce__ffss_for_rating_id__r.arce__financial_statement_id__c) ? '' : analyzedClient.arce__ffss_for_rating_id__r.arce__financial_statement_id__c;
    parameters.evaluationDate = String.valueOf(DateTime.now().format('yyyy-MM-dd\'T\'HH:mm:ss.SS'));
    parameters.adjValue = ratingScale == '1' ? shortRating : longRating;
    parameters.adjDesc = String.isBlank(rvd.arce__rating_override_comment__c) ? '' : rvd.arce__rating_override_comment__c;
    parameters.reason = String.isBlank(rvd.arce__rating_override_reason_desc__c) ? '' : rvd.arce__rating_override_reason_desc__c;
    parameters.ratingScale = ratingScale == '1' ? '3' : '4';
    parameters.riskAssessmentId = analyzedClient.Name;
    parameters.participantId = customerId;
    parameters.ratingid = Arc_Gen_Rating_data.generalRatingData(new List<String>{analyzedClient.arce__ffss_for_rating_id__r.arce__rating_id__c})[0].arce__rating_id__c;
    return JSON.serialize(parameters,true);
  }

  private static String getCustomerNumber(Id analysisId){
    List<String> customerData = arce.Arc_Gen_RatingGlobal_data.getCustomerData((String) analysisId);
    return customerData[1];
  }

  /**
  *-------------------------------------------------------------------------------
  * @description Method that return a boolean value
  --------------------------------------------------------------------------------
  * @author cesaroctavio.villanueva.cebal@bbva.com
  * @date  22/04/2020
  * @return Boolean
  * @example public static Boolean setConditionalResult(arce__rating_variables_detail__c rvd, arce__Account_has_Analysis__c aha)
  **/

  public static boolean setConditionalResult(arce__rating_variables_detail__c rvd, arce__Account_has_Analysis__c aha) {
    final boolean typeComp = rvd.arce__adj_long_rating_value_type__c != aha.arce__adj_long_rating_value_type__c;
    final boolean reasonComp = rvd.arce__rating_override_reason_desc__c != aha.arce__rating_override_reason_desc__c;
    return typeComp || reasonComp;
  }
  /**
  *-------------------------------------------------------------------------------
  * @description Method that evaluate service code response
  --------------------------------------------------------------------------------
  * @author juanmanuel.perez.ortiz.contractor@bbva.com
  * @date  09/07/2020
  * @return Boolean
  * @example public static Boolean evaluateCodeResponse(String responseCode)
  **/
  public static boolean evaluateOverrideResponse(String responseCode) {
    return arce.Arc_Gen_RatingGlobal_Constants.SUCC1.equals(responseCode) || arce.Arc_Gen_RatingGlobal_Constants.SUCC2.equals(responseCode) || arce.Arc_Gen_RatingGlobal_Constants.SUCC3.equals(responseCode);
  }
  public static boolean evaluateRatingResponse(String responseCode) {
    return arce.Arc_Gen_RatingGlobal_Constants.SUCC1.equals(responseCode) || arce.Arc_Gen_RatingGlobal_Constants.SUCC2.equals(responseCode);
  }
}