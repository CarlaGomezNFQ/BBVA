/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_RatingGlobal_helper
* @Author   jose.hijar.contractor@bbva.com
* @Date     Created: 2020-10-28
* @Group    ARCE
* ------------------------------------------------------------------------------------------------
* @Description: Contains the logic to assign the different rating variables to salesforce fields
* ------------------------------------------------------------------------------------------------
* @Changes
*
* |2020-10-28 jose.hijar.contractor@bbva.com
*              Entire class copied form Arce core and addapted to SP2 business logic, refactorization, code review.. etc
* |2020-10-29 jose.hijar.contractor@bbva.com
*              refactorization of processVariablesData method to allow geographies customize their own mapping of rating_variables_detail__c
* |2021-01-29 ivan.cons@bbva.com
*              sended ratingId parameter
* |2021-04-22    saimassimilianno.jordana.contractor@bbva.com
* |              get arce__IRP_Workflow__c field from ahas to pass as second parameter in Arc_Gen_GenericUtilities.getEventTypeValue meth0d,
* |              change variables names and verify value of ratingId of current rating object.
* |2020-05-13 amunguia.contractor@bbva.com  it is controlled that the override is not duplicated.
* |2020-05-14 amunguia.contractor@bbva.com  the prerating flow is activated for Anchor and Overlay.
* |2021-06-04 juanignacio.hita.contractor@bbva.com  adds setBankId method in RatingParameters class and setServiceParameters method.
* |2021-06-17 amunguia.contractor@bbva.com    fixes bug to select only variables from metadata
* |2021-06-17 amunguia.contractor@bbva.com the value to be added to the ffssId is controlled.
* |2021-06-23 amunguia.contractor@bbva.com the participantId is calculated for RatingVal.
* |2021-07-15 amunguia.contractor@bbva.com This is the response to the evaluation date to save it in a rating detail field..
* |2021-08-26 saimassimilianno.jordana.contractor@bbva.com Added new parameter modelId and new method to get it called getModelByAha().
* |2021-09-20 otiliaramona.veres.contractor@bbva.com
* |           Added new global string Industry Risk Rating and new condition on HelperParameters method
* |2021-11-30 saimassimilianno.jordana.contractor@bbva.com Added new condition to get customerNumber at HelperParameters meth0d.
* |2021-11-29 juanignacio.hita.contractor@bbva.com Change mapping arce__rating_user_id__c field
* ------------------------------------------------------------------------------------------------
*/
@SuppressWarnings('PMD.ExcessivePublicCount, PMD.ExcessiveClassLength, sf:TooManyMethods')
global class Arc_Gen_RatingGlobal_helper {

  /**
  * @Description: Instance of the data access class
  */
  private static Arc_Gen_RatingGlobal_data locator = new Arc_Gen_RatingGlobal_data();

  /**
  * @Class: RatingParameters
  * @Description: Wrapper that contain all the rating service parameters
  * @author BBVA
  */
  global class RatingParameters {
    /**
    * @Description: Indicates the service method
    */
    global String subEvent {get;set;}
    /**
    * @Description: Identificator of the rating in Salesforce
    */
    global String ratingId {get;set;}
    /**
    * @Description: Identificator of the analyzed client (Not the standard Salesforce Id)
    */
    global String riskAssessmentId {get;set;}
    /**
    * @Description: Account Number of the Customer
    */
    global String participantId {get;set;}
    /**
    * @Description: Identificator of the Financial Statement
    */
    global String ffssId {get;set;}
    /**
    * @Description: Indicates the participation type that the participant of the analysis
    * has within the Economic Group to which it belongs.
    */
    global String participationType {get;set;}
    /**
    * @Description: Business agent identifier that starts the rating study.
    */
    global String businessAgentId {get;set;}
    /**
    * @Description: Unique bank identifier.
    */
    global String bankId {get;set;}
    /**
    * @Description: Unique branch identifier when the assessment is created.
    */
    global String branchId {get;set;}
    /**
    * @Description: Unique level of branch identifier.
    */
    global String branchLevel {get;set;}
    /**
    * @Description: Indicates the subprocess value to eventType parameter value
    */
    global String eventType {get;set;}
    /**
    * @Description: Indicates the Analysis model that is executing.
    */
    global String modelId {get;set;}
  }
  /**
  * @Class: RatingParameters
  * @Description: Wrapper that contain the needed params to send the helper
  * @author BBVA
  */
  global class HelperParameters {
      /** @Description: Analyzed cient */
      global arce__Account_has_Analysis__c accHasAnalysis {get; set;}
      /** @Description: current rating object associated to Account_Has_Analysis */
      global arce__rating__c currentRating {get; set;}
      /** @Description: current overlay object associated to Account_Has_Analysis */
      global arce__Overlay__c currentOverlay {get; set;}
      /** @Description: Info about user in running context */
      global Arc_Gen_User_Wrapper userInfo {get; set;}
      /** @Description: Indicates the subprocess value to eventType parameter value */
      global String event {get; set;}
      /** @Description: Indicates if the service method is CALCULATION or VALIDATION */
      global String subEvent {get; set;}
      /** @Description: Calculated identificator of the rating in Salesforce */
      global String calcRatingId {get; set;}
      /** @Description: Account Number of the Customer */
      global String participantId {get; set;}
      /** @Description: Indicates the participation type that the participant of the analysis has within the Economic Group to which it belongs. */
      global String participationType {get; set;}
      /** @Description: If is not null means that the service will return the specified service code */
      global String rating2keep {get; set;}
      /** @Description: If is not null means that the service will return a previously configured mock */
      global String serviceMock {get; set;}
      /** @Description: If is not null means that the service will return the specified service code */
      global String mockCode {get; set;}
      /** @Description: Indicates bank id of the customer */
      global String bankId {get;set;}
      /** @Description: External class used to map the rating response on the datamodel */
      global arce.Arc_GBL_RatingDetailsMapping_Interface externalMappingClass {get; set;}

      global HelperParameters() {
      }

      global HelperParameters(arce__Account_has_Analysis__c aHa, String rating2keep, String subEventType) {
          this(aha, rating2keep, System.UserInfo.getUserId(), subEventType);
      }

      global HelperParameters(arce__Account_has_Analysis__c aHa, String rating2keep, String userId, String subEventType) {
          /*|||| rating ||||*/
          final arce__rating__c cRating = Arc_Gen_Rating_data.generalRatingData(new List<String>{aHa.arce__ffss_for_rating_id__r.arce__rating_id__c})[0];

          /*|||| overlay ||||*/
          final arce__Overlay__c cOverlay = Arc_Gen_RatingGlobal_data.getOverlayFromAhA(aHa.Id);

          /*|||| userInfo ||||*/
          final Arc_Gen_User_Wrapper uInfo = getUserInfo(userId);

          /*|||| Event type ||||*/
          final String subprocessType = aHa.arce__Analysis__r.arce__anlys_wkfl_sub_process_type__c;
          final String wfType = aHa.arce__IRP_Workflow__c;
          final String ratingEventType = arce.Arc_Gen_GenericUtilities.getEventTypeValue(subprocessType, wfType);

          /*|||| Custom Rating Id ||||*/
          final String ratingId = String.isBlank(cRating.arce__rating_id__c) ? '' : cRating.arce__rating_id__c;

          /*|||| Customer number ||||*/
          final String clientId = arce.Arc_Gen_AccHasAnalysis_Data.getCorrectIdWAhas(aha);
          final arce.Arc_Gen_Account_Wrapper accWrapper = arce.Arc_Gen_Account_Locator.getAccountInfoById(new List<Id> { clientId }).get(clientId);
          String customerNumber;
          if (subEventType == Arc_Gen_RatingGlobal_Constants.RATINGCAL || subEventType == Arc_Gen_RatingGlobal_Constants.RATINGPRE || subEventType == Arc_Gen_RatingGlobal_Constants.FINALIZATION || subEventType.contains(Arc_Gen_RatingGlobal_Constants.METHOD_OVERLAY)){
            Boolean encFlag = Boolean.valueOf(arce.Arc_Gen_Arceconfigs_locator.getConfigurationInfo(Arc_Gen_RatingGlobal_Constants.ENCRYPTION_FLAG)[0].Value1__c);
            customerNumber = encFlag ? arce.Arc_Gen_CallEncryptService.getEncryptedClient(accWrapper.accNumber) : accWrapper.accNumber;
          } else if (subEventType == Arc_Gen_RatingGlobal_Constants.METHOD_OVERRIDE || subEventType == Arc_Gen_RatingGlobal_Constants.RATINGVAL || subEventType == Arc_Gen_RatingGlobal_Constants.INDUSTRY_RISK_RATING) {
            customerNumber = arce.Arc_Gen_CallEncryptService.getEncryptedClient(accWrapper.accNumber);
          }

          /*|||| Participation type ||||*/
          final String participType = setClientType(aHa.arce__group_asset_header_type__c);

          /*:::: Service parameters::::*/
          this.accHasAnalysis = aHa;
          this.currentRating = cRating;
          this.currentOverlay = cOverlay;
          this.userInfo = uInfo;
          this.event = ratingEventType;
          this.subEvent = subEventType;
          this.calcRatingId = ratingId;
          this.participantId = customerNumber;
          this.participationType = participType;

          /*:::: Response processing parameters ::::*/
          this.rating2keep=rating2keep;

          /*:::: Mapping class ::::*/
          setMappingClass();

          /*:::: Testing variables ::::*/
          setMock(null,null);
      }

      global Arc_Gen_User_Wrapper getUserInfo(String userId) {
          Arc_Gen_User_Wrapper uInfo;
          if (userId.startsWith(User.sObjectType.getDescribe().getKeyPrefix())) {
              uInfo = arce.Arc_Gen_User_Locator.getUserInfo(userId);
          } else {
              uInfo = new Arc_Gen_User_Wrapper();
              uInfo.businessAgentId = userId;
              uInfo.branchlevel = '10';
              uInfo.branchId = '0000';
          }
          return uInfo;
      }

      global void setOverlay(arce__Overlay__c cOverlay) {
          this.currentOverlay = cOverlay;
      }

      global void setMock(String mockCode, String serviceMock) {
          this.mockCode = mockCode;
          this.serviceMock = serviceMock;
      }

      private void setMappingClass() {
          /*|||| External class which implements the methods for mapping data ||||*/
          arce__Arce_Config__mdt mappingConfig = Arc_Gen_RatingGlobal_data.getArceConfig('ratingExternalMapping');
          Boolean configFound = false;

          Type typeOfMapClass;
          if(mappingConfig != null){
              typeOfMapClass= Type.forName(mappingConfig.arce__Value1__c);
              if(typeOfMapClass != null){
                  this.externalMappingClass = (arce.Arc_GBL_RatingDetailsMapping_Interface)typeOfMapClass.newInstance();
                  configFound = true;
              }
          }

          if (!configFound) {
              // Set default (empty) class for tests.
              System.debug(System.LoggingLevel.ERROR, 'Critical error: A rating mapping class must be defined.');
              this.externalMappingClass = new Arc_GBL_SampleRatingDetailsMapping();
          }
      }

      global void setBankId(String bankId) {
        this.bankId = bankId;
      }
  }
  /**
  * @description: Empty constructor
  **/
  @TestVisible
  private Arc_Gen_RatingGlobal_helper() {

  }
  /**
  *-------------------------------------------------------------------------------
  * @description Method that process the service response and assign the rating fields
  --------------------------------------------------------------------------------
  * @author eduardoefrain.hernandez.contractor@bbva.com
  * @date 30/4/2019
  * @param arce__Account_has_Analysis__c analyzedClient Account has analisis to call the WS
  * @param String customerId Account id to call WS
  * @param String methodType type of operation the service expects
  * @return String parameters for WS
  * @example setServiceParameters(arce__Account_has_Analysis__c analyzedClient,String customerId, String methodType)
  **/
  global static String setServiceParameters(HelperParameters helperWrapper) {
    final RatingParameters parameters = new RatingParameters();

    parameters.eventType = helperWrapper.event;
    parameters.subEvent = helperWrapper.subEvent;
    parameters.ratingId = helperWrapper.calcRatingId;
    parameters.riskAssessmentId = helperWrapper.accHasAnalysis.Name;
    parameters.participantId = helperWrapper.participantId;
    parameters.ffssId = String.isBlank(helperWrapper.accHasAnalysis.arce__ffss_for_rating_id__r.arce__financial_statement_id__c) ? '' : helperWrapper.accHasAnalysis.arce__ffss_for_rating_id__r.arce__financial_statement_id__c;
    parameters.businessAgentId = helperWrapper.userInfo?.businessAgentId;
    parameters.branchLevel = helperWrapper.userInfo?.branchlevel;
    parameters.participationType = helperWrapper.participationType;
    parameters.bankId = helperWrapper.bankId;
    parameters.branchId = helperWrapper.userInfo?.branchId;
    parameters.modelId = getModelByAha(helperWrapper.accHasAnalysis);
    return JSON.serialize(parameters,true);
  }
  /**
  *-------------------------------------------------------------------------------
  * @description Method that process the service response codes
  --------------------------------------------------------------------------------
  * @author eduardoefrain.hernandez.contractor@bbva.com
  * @date 30/4/2019
  * @param Arc_Gen_getIASOResponse.serviceResponse response - Wrapper that contains the service response info
  * @param arce__Account_has_Analysis__c analysis - Analized Client record
  * @param List<arce__Financial_Statements__c> - Valid FFSS that will be used by the rating
  * @return Arc_Gen_ServiceAndSaveResponse - Wrapper that contains the process information
  * @example global static Arc_Gen_ServiceAndSaveResponse processResponse(Arc_Gen_getIASOResponse.serviceResponse response, List<arce__Financial_Statements__c> validFinancialSt)
  **/
  global static arce.Arc_Gen_ServiceAndSaveResponse processResponse(arce.Arc_Gen_getIASOResponse.serviceResponse response, HelperParameters wrapper) {
    arce__Financial_Statements__c validFinancialSt = wrapper.accHasAnalysis.arce__ffss_for_rating_id__r;
    arce.Arc_Gen_ServiceAndSaveResponse serviceAndSaveResp = new arce.Arc_Gen_ServiceAndSaveResponse();
    final arce.Arc_Gen_CustomServiceMessages serviceMessage = new arce.Arc_Gen_CustomServiceMessages();
    serviceAndSaveResp.serviceCode = response.serviceCode;
    serviceAndSaveResp.serviceMessage = response.serviceMessage;
    List<arce__rating_variables_detail__c> variablesList;
    if(response.serviceCode == String.valueOf(serviceMessage.CODE_200)) {
      Map<String, Object> responseMap = response.serviceResponse;
      variablesList = new List<arce__rating_variables_detail__c>();
      removePreviousVars(wrapper);
      processRatingData(responseMap, wrapper);
      List<arce__rating_variables_detail__c> varsFromCombined = processCombinedRatingData(responseMap,wrapper);
      variablesList.addAll(varsFromCombined);
      //locator.updateRecords(new List<sObject>{wrapper.accHasAnalysis,wrapper.currentRating});
      //locator.updateRecords(new List<sObject>{validFinancialSt});
      validFinancialSt.arce__rating_id__c = wrapper.currentRating.id;
      final List<arce__rating_variables_detail__c> varsFromModBlocks = processVariablesData(responseMap,wrapper);
      variablesList.addAll(varsFromModBlocks);
      final Arc_Gen_RatingGlobal_data.saveResult saveResultInsert = locator.insertRecords(variablesList);
      setOverlayValues(variablesList, wrapper);
      //setFinanAlertInd(wrapper.currentRating.Id, wrapper.accHasAnalysis.Id);//included in processVariablesData
      updateRecords(new List<sObject>{wrapper.accHasAnalysis, wrapper.currentRating, wrapper.currentOverlay, validFinancialSt});
      serviceAndSaveResp.saveStatus = saveResultInsert.status;
      serviceAndSaveResp.saveMessage = saveResultInsert.message;
    } else {
      serviceAndSaveResp.saveStatus = Arc_Gen_RatingGlobal_Constants.FALSE_TEXT;
      // serviceAndSaveResp.serviceMessage = response.serviceCode == String.valueOf(serviceMessage.CODE_400) ||
      // response.serviceCode == String.valueOf(serviceMessage.CODE_500) ?
      // JSON.serialize(Arc_Gen_RatingErrorManagement.processErrorData(response, Arc_Gen_RatingGlobal_Constants.RATINGCAL)) : response.serviceMessage;
      if(response.serviceCode == Arc_Gen_RatingGlobal_Constants.KO400 || response.serviceCode == Arc_Gen_RatingGlobal_Constants.KO500){
        serviceAndSaveResp.serviceMessage = JSON.serialize(Arc_Gen_RatingErrorManagement.processErrorData(response, Arc_Gen_RatingGlobal_Constants.RATINGCAL));
      }else{
        final Map<String, Object> errorWrapper = new Map<String, Object>();
        errorWrapper.put('errorCode', response.serviceCode);
        errorWrapper.put('errorTitle', Arc_Gen_RatingGlobal_Constants.ERROR_TEXT);
        errorWrapper.put('errorMessage', response.serviceMessage);
        serviceAndSaveResp.serviceMessage = JSON.serialize(errorWrapper);
      }
    }
    return serviceAndSaveResp;
  }

  /**
  *-------------------------------------------------------------------------------
  * @description Method that process the service error responses
  --------------------------------------------------------------------------------
  * @author eduardoefrain.hernandez.contractor@bbva.com
  * @date 30/10/2019
  * @param String analysisId - Id of the analyzed client
  * @param String customerNumber - Id of the client
  * @param List<arce__Financial_Statements__c> validFinancialSt - List of valid financial statements
  * @return Arc_Gen_ServiceAndSaveResponse - Wrapper that contains the result of the process
  * @example global static Arc_Gen_ServiceAndSaveResponse calcRating(String analysisId, String customerNumber,List<arce__Financial_Statements__c> validFinancialSt)
  **/
  global static arce.Arc_Gen_ServiceAndSaveResponse calcRating(HelperParameters helpWrapper) {
    arce.Arc_Gen_ServiceAndSaveResponse serviceAndSaveResp = new arce.Arc_Gen_ServiceAndSaveResponse();
    arce.Arc_Gen_getIASOResponse.serviceResponse response;

    if(helpWrapper.serviceMock == Arc_Gen_RatingGlobal_Constants.ERROR_TEXT) {
      throw new CalloutException();
    }

    String serviceName= Test.isRunningTest() ? 'ratingEngineForTest' : 'ratingEngine';
    String parameters = setServiceParameters(helpWrapper);

    if(String.isNotBlank(helpWrapper.mockCode)) {
      serviceName = helpWrapper.mockCode;
      parameters = '{"messages":[{"code":"connectionError","message":"Unable to call Passive Products service","parameters": []}]}';
    }

    response = locator.callRatingService(parameters, serviceName);
    response.serviceResponse = String.isBlank(helpWrapper.serviceMock) ? response.serviceResponse :
    (Map<String, Object>)JSON.deserializeUntyped(helpWrapper.serviceMock);
    try {
      serviceAndSaveResp = processResponse(response, helpWrapper);
      //serviceAndSaveResp = updateLeveragedVars(serviceAndSaveResp, helpWrapper);
    } catch(Exception ex) {
      final Map<String, Object> errorWrapper = new Map<String, Object>();
      errorWrapper.put('errorCode', response.serviceCode);
      errorWrapper.put('errorTitle', Arc_Gen_RatingGlobal_Constants.ERROR_TEXT);
      errorWrapper.put('errorMessage', ex.getMessage());
      serviceAndSaveResp.serviceMessage = JSON.serialize(errorWrapper);
      serviceAndSaveResp.saveStatus = 'false';
      serviceAndSaveResp.saveMessage = ex.getMessage();
      System.debug('ERROR :: arce.Arc_Gen_RatingGlobal_helper.calcRating :: '+ex.getMessage());
      System.debug('ERROR :: arce.Arc_Gen_RatingGlobal_helper.calcRating :: '+ex.getStackTraceString());
    }
    return serviceAndSaveResp;
  }




  /**
  *-------------------------------------------------------------------------------
  * @description Updates records safely preventing from undesired null sObjects and not inserted ones yet
  --------------------------------------------------------------------------------
  * @author jose.hijar.contractor@bbva.com
  * @date 12/02/2021
  * @param List<Object> sObject list which contains rows for being updated
  * @example  global static Map<String, Object> getMapFromList(List<Object> ratings,String typeratings)
  **/
  private static void updateRecords(List<sObject> sObjectList){
    List<sObject> tempList=new List<sObject>();

    for(sObject sObj : sObjectList){
      if(sObj != null && String.isNotBlank((String)sObj.get('Id'))){
        tempList.add(sObj);
      }
    }
    locator.updateRecords(tempList);
  }



  /**
  *-------------------------------------------------------------------------------
  * @description Method that return Map of specified rating type
  --------------------------------------------------------------------------------
  * @author ricardo.almanza.contractor@bbva.com
  * @date 28/1/2020
  * @param List<Object> ratings
  * @param String typeratings
  * @return Map<String, Object> RatingMap
  * @example  global static Map<String, Object> getMapFromList(List<Object> ratings,String typeratings)
  **/
  global static Map<String, Object> getMapFromList(List<Object> ratings,String typeratings) {
    Map<String, Object> rating;
    String ratingType;
    Integer i = 0;

    if(!ratings.isEmpty()){
      do{
        rating = (Map<String, Object>) ratings[i];
        Map<String, Object> rTypeMap = (Map<String, Object>)rating.get(Arc_Gen_RatingGlobal_Constants.RATINGTYPE);
        ratingType = (String)rTypeMap.get(Arc_Gen_RatingGlobal_Constants.ID_TEXT);
        i++;
      }while(ratingType != typeratings && i<ratings.size());
    }

    return ratingType != typeratings ? new Map<String, Object>() : rating;
  }
  /**
  *-------------------------------------------------------------------------------
  * @description Method that process the service response and assign the rating fields
  --------------------------------------------------------------------------------
  * @author eduardoefrain.hernandez.contractor@bbva.com
  * @date 30/4/2019
  * @param Map<String, Object> responseMap process response of the WS
  * @param arce__Account_has_Analysis__c analysis current analisis for rating
  * @return arce__rating__c current rating object
  * @example global static arce__rating__c processRatingData(Map<String, Object> responseMap,arce__Account_has_Analysis__c analysis)
  **/
  private static void processRatingData(Map<String, Object> responseMap, HelperParameters wrapper) {

    final arce__ratingOverlayMap__mdt ratingsConfig = Arc_Gen_RatingGlobal_data.getOverwriteMapConfig('ratings')?.get(0);
    final Set<String> filteredRatings = getFilteredConfig(ratingsConfig);

    final arce__rating__c rating = wrapper.currentRating;
    final arce__Account_has_Analysis__c aHa = wrapper.accHasAnalysis;

    final Map<String, Object> data = (Map<String, Object>)responseMap.get(Arc_Gen_RatingGlobal_Constants.DATA_TEXT);
    final List<Object> ratingListMap = (List<Object>)data.get(Arc_Gen_RatingGlobal_Constants.RATING_TEXT);
    final String ratingId = (String)data.get(Arc_Gen_RatingGlobal_Constants.ID_TEXT);

    final Arc_Gen_User_Wrapper userWrapper = Arc_Gen_User_Locator.getUserInfo(UserInfo.getUserId());

    arce.Arc_GBL_RatingDetailsMapping_Interface mappingClass = wrapper.externalMappingClass;

    rating.arce__rating_id__c = ratingId;
    rating.arce__status_type__c = '2';
    rating.arce__rating_user_id__c =  userWrapper.businessAgentId;
    // In bottom-up customers, SME indicator is calculated from input fields and not via rating.
    if (aHa.arce__anlys_wkfl_cnsld_ffss_type__c != arce.Arc_Gen_Constants.TDBU_BOTTOM_UP ||
    aHa.arce__Analysis__r.arce__analysis_customer_relation_type__c == arce.Arc_Gen_Constants.CUSTOMER_RELATION_ORPHAN) {
      aHa.arce__smes_eur_comuty_defn_type__c = (Boolean)data.get(Arc_Gen_RatingGlobal_Constants.SME_INDICATOR) == true ? '1' : '2';
    }
    aHa.newFFSS_ind__c = 'NO';

    for(Object ratingObj : ratingListMap){
      Map<String,Object> ratingMap = (Map<String,Object>) ratingObj;
      Map<String,Object> rTypeMap = (Map<String,Object>)ratingMap.get(Arc_Gen_RatingGlobal_Constants.RATINGTYPE);
      String ratingType = (String)rTypeMap.get(Arc_Gen_RatingGlobal_Constants.ID_TEXT);
      if(filteredRatings != null && (filteredRatings.isEmpty() || filteredRatings.contains(ratingType))){
        mappingClass.setRating(ratingMap, ratingType, aHa, rating);
      }
    }
  }

  /**
  *-------------------------------------------------------------------------------
  * @description Method that process the service response and assign the variables rating fields
  --------------------------------------------------------------------------------
  * @author eduardoefrain.hernandez.contractor@bbva.com
  * @date 30/4/2019
  * @param Map<String, Object> responseMap responseMap process response of the WS
  * @param String analysisId id of the account has analisis for rating
  * @param arce__rating__c rating current rating for account has analisis
  * @return List<arce__rating_variables_detail__c> list of  auxiliary variables for rating
  * @example global static List<arce__rating_variables_detail__c> processVariablesData(Map<String, Object> responseMap,String analysisId,arce__rating__c rating)
  **/
  private static List<arce__rating_variables_detail__c> processVariablesData(Map<String, Object> responseMap, HelperParameters wrapper) {
    final String accHasAnalysisId = wrapper.accHasAnalysis.Id;
    final List<arce__rating_variables_detail__c> variablesList = new List<arce__rating_variables_detail__c>();
    final arce__Overlay__c overlayObj = wrapper.currentOverlay;
    final arce__rating__c rating = wrapper.currentRating;
    arce.Arc_GBL_RatingDetailsMapping_Interface mappingClass = wrapper.externalMappingClass;

    final Map<String, Object> data = (Map<String, Object>)responseMap.get(Arc_Gen_RatingGlobal_Constants.DATA_TEXT);
    final List<Object> ratingVariablesList = (List<Object>)data.get(Arc_Gen_RatingGlobal_Constants.VARIABLES);
    final List<Object> ratingMap = (List<Object>)data.get(Arc_Gen_RatingGlobal_Constants.RATING_TEXT);
    final Map<String, Object> finalRating = getMapFromList(ratingMap,Arc_Gen_RatingGlobal_Constants.FINAL_RATING);
    final List<Object> ratingAdjustmentsList = (List<Object>)data.get(Arc_Gen_RatingGlobal_Constants.ADJUSTMENTS);

    final List<arce__ratingOverlayMap__mdt> adjustmentsConfig = Arc_Gen_RatingGlobal_data.getOverwriteMapConfig('adjustments');
    final arce__ratingOverlayMap__mdt variablesConfig = Arc_Gen_RatingGlobal_data.getOverwriteMapConfig('variables')?.get(0);

    final Map<String,List<String>> filteredAdjsMap = getFilteredAdjsMap(adjustmentsConfig);
    final Set<String> filteredVars = getFilteredConfig(variablesConfig);

    List<arce__rating_variables_detail__c> processedVariables = processVariables(ratingVariablesList, filteredVars, accHasAnalysisId, rating, mappingClass);
    variablesList.addAll(processedVariables);

    List<arce__rating_variables_detail__c> processedAdjustments = processAdjustments(ratingAdjustmentsList, filteredAdjsMap, accHasAnalysisId, rating, overlayObj, wrapper.subEvent, mappingClass, data);
    variablesList.addAll(processedAdjustments);

    wrapper.accHasAnalysis.arce__rating_adj_ind_type__c = ratingAdjustmentsList == null ? '2' : '1';

    List<arce__rating_variables_detail__c> overrideList = new List<arce__rating_variables_detail__c>([SELECT Id FROM arce__rating_variables_detail__c WHERE arce__account_has_analysis_id__c = :accHasAnalysisId AND arce__rating_modifier_adj_type__c = :Arc_Gen_RatingGlobal_Constants.METHOD_OVERRIDE]);
    if (overrideList.isEmpty()) {
        final arce__rating_variables_detail__c overrideVar = new arce__rating_variables_detail__c();
        overrideVar.arce__rating_id__c = rating.id;
        overrideVar.arce__account_has_analysis_id__c = accHasAnalysisId;
        overrideVar.arce__rating_modifier_id__c = '02';
        overrideVar.arce__rating_modifier_adj_type__c = Arc_Gen_RatingGlobal_Constants.METHOD_OVERRIDE;
        overrideVar.Id = wrapper.rating2Keep;
        variablesList.add(overrideVar);
    }

    final arce__rating_variables_detail__c variableFinal = locator.setRatingVariableObj();
    variableFinal.arce__rating_id__c = rating.id;
    variableFinal.arce__account_has_analysis_id__c = accHasAnalysisId;
    variableFinal.arce__pd_per__c = (Decimal)finalRating.get(Arc_Gen_RatingGlobal_Constants.DEFAULT_PROBABILITY);
    variableFinal.arce__rating_modifier_adj_type__c = Arc_Gen_RatingGlobal_Constants.FINAL_RATING;
    variablesList.add(variableFinal);

    final arce__rating_variables_detail__c finanAlertInd = new arce__rating_variables_detail__c();
    finanAlertInd.arce__rating_id__c = rating.id;
    finanAlertInd.arce__account_has_analysis_id__c = accHasAnalysisId;
    finanAlertInd.arce__rating_modifier_desc__c = Arc_Gen_RatingGlobal_Constants.NONE_TEXT;
    finanAlertInd.arce__rating_override_reason_desc__c = Arc_Gen_RatingGlobal_Constants.FINANCIAL_ALERT_IND;
    for (arce__rating_variables_detail__c var : variablesList) {
        if (var.arce__modifier_mix_type__c == Arc_Gen_RatingGlobal_Constants.OVERLAY_02 || var.arce__modifier_mix_type__c == Arc_Gen_RatingGlobal_Constants.OVERLAY_03 || var.arce__modifier_mix_type__c == Arc_Gen_RatingGlobal_Constants.OVERLAY_04) {
            finanAlertInd.arce__rating_modifier_desc__c = Arc_Gen_RatingGlobal_Constants.FINANCIAL_ALERT;
        }
    }
    variablesList.add(finanAlertInd);

    return variablesList;
  }

  /**
  *-------------------------------------------------------------------------------
  * @description Method for splitting logic from processVariablesData method
  --------------------------------------------------------------------------------
  * @author jose.hijar.contractor@bbva.com
  * @date 29/12/2020
  * @param List<Object> rVarList List of 'variables' returned by service data
  * @param Set<String> fVars List of ids which variables are being processed
  * @param String aHaId Account_has_Analysis__c object id where variables will be linked to
  * @param arce__rating__c rating rating__c object linked to the valid arce__Financial_Statements__c object lined to Account_has_Analysis__c object (AccHasAnalysis <- financialStatement <- rating )
  * @return List<arce__rating_variables_detail__c> resulting list of objects of processed variables
  * @example private static List<arce__rating_variables_detail__c> processVariables(List<Object> rVarList, Set<String> fVars)
  **/
  @SuppressWarnings('PMD.ExcessiveParameterList')
  private static List<arce__rating_variables_detail__c> processVariables(List<Object> rVarList, Set<String> fVars, String aHaId, arce__rating__c rating, arce.Arc_GBL_RatingDetailsMapping_Interface mappingClass){
    List<arce__rating_variables_detail__c> ret = new List<arce__rating_variables_detail__c>();
    arce__rating_variables_detail__c variable;
    Map<String, Object> variablesMap;
    String variableId;

    if(rVarList != null) {
      for(Object var : rVarList) {
        variablesMap = (Map<String, Object>)var;
        variableId = (String)variablesMap.get(Arc_Gen_RatingGlobal_Constants.ID_TEXT);
        if(fVars !=null && (fVars.isEmpty() || fVars.contains(variableId))) {
          variable = mappingClass.setRatingVariable(variablesMap, aHaId, rating);

          if (String.isNotBlank(variable.arce__account_has_analysis_id__c)) {
            ret.add(variable);
          }
        }
      }
    }
    return ret;
  }
  /**
  *-------------------------------------------------------------------------------
  * @description Method for splitting logic from processVariablesData method
  --------------------------------------------------------------------------------
  * @author jose.hijar.contractor@bbva.com
  * @date 29/12/2020
  * @param List<Object> rVarList List of 'adjustments' returned by service data
  * @param Set<String> fVars List of ids which variables are being processed
  * @param String aHaId Account_has_Analysis__c object id where variables will be linked to
  * @param arce__rating__c rating rating__c object linked to the valid arce__Financial_Statements__c object lined to Account_has_Analysis__c object (AccHasAnalysis <- financialStatement <- rating )
  * @param arce__Overlay__c overlayObj  Overlay object to potentially be edited by reference
  * @return List<arce__rating_variables_detail__c> resulting list of objects of processed adjustments
  * @example private static List<arce__rating_variables_detail__c> processAdjustments(List<Object>  rAdjsList, Map<String,List<String>> fAdjs, arce__Overlay__c overlayObj)
  **/
  @SuppressWarnings('PMD.ExcessiveParameterList')
  private static List<arce__rating_variables_detail__c> processAdjustments(List<Object>  rAdjsList, Map<String,List<String>> fAdjsMap, String aHaId, arce__rating__c rating,  arce__Overlay__c overlayObj, String ratingEvent, arce.Arc_GBL_RatingDetailsMapping_Interface mappingClass, Map<String, Object> data){
    List<arce__rating_variables_detail__c> ret= new List<arce__rating_variables_detail__c>();
    arce__rating_variables_detail__c adjustment;
    Map<String, Object> ratingAdjustmentsMap;
    Map<String,Object> adjustmentTypeMap;
    Map<String,Object> modifierMap;
    String adjustmentType;
    String modifierType;
    String modifierId;
    List<String> fAdjs;
    List<String> visibilityControlField;

    if(rAdjsList != null) {
      visibilityControlField=new List<String>();
      for(Object adj : rAdjsList) {
        ratingAdjustmentsMap = (Map<String, Object>)adj;
        adjustmentTypeMap = (Map<String, Object>)ratingAdjustmentsMap.get(Arc_Gen_RatingGlobal_Constants.ADJUSTMENT_TYPE);
        modifierMap = (Map<String, Object>)ratingAdjustmentsMap.get(Arc_Gen_RatingGlobal_Constants.MODIFIER);
        adjustmentType = (String)adjustmentTypeMap.get(Arc_Gen_RatingGlobal_Constants.ID_TEXT);
        modifierType = (String)modifierMap.get(Arc_Gen_RatingGlobal_Constants.MODIFIER_TYPE);
        modifierId = (String)modifierMap.get(Arc_Gen_RatingGlobal_Constants.ID_TEXT);
        fAdjs = fAdjsMap.get('all');
        if(fAdjs == null)
        fAdjs = fAdjsMap.get(adjustmentType);
        if(fAdjs !=null && (fAdjs.isEmpty() || fAdjs.contains(modifierId))) {
          if(modifierType != null && modifierType.equals(Arc_Gen_RatingGlobal_Constants.OVERLAY_PARAM) && ratingEvent.contains(Arc_Gen_RatingGlobal_Constants.METHOD_OVERLAY)) {
            mappingClass.updateOverlayObj(ratingAdjustmentsMap, modifierId, overlayObj);
          }else{
            adjustment = mappingClass.setRatingModifier(ratingAdjustmentsMap, aHaId, rating);
            adjustment.arce__rating_date__c = Date.valueOf(String.valueOf(data.get(Arc_Gen_RatingGlobal_Constants.EVALDATE)));
            ret.add(adjustment);
            if(adjustmentType.contains(Arc_Gen_RatingGlobal_Constants.METHOD_OVERLAY) && ratingEvent.contains(Arc_Gen_RatingGlobal_Constants.METHOD_OVERLAY)) {
              visibilityControlField.add(modifierId);
            }
          }
        }
      }
      if(overlayObj != null){
        overlayObj.arce__Arc_Gen_Overlay_visibility_control__c=String.join(visibilityControlField, ';');
      }
    }
    return ret;
  }

  private static List<arce__rating_variables_detail__c> processCombinedRatingData(Map<String, Object> responseMap, HelperParameters wrapper){
    List<arce__rating_variables_detail__c> ret= new List<arce__rating_variables_detail__c>();

    final String accHasAnalysisId = wrapper.accHasAnalysis.Id;
    final arce__rating__c rating = wrapper.currentRating;
    final arce__ratingOverlayMap__mdt combinedRatingConfig = Arc_Gen_RatingGlobal_data.getOverwriteMapConfig('combinedRating')?.get(0);
    final Set<String> filteredCombinedRatings = getFilteredConfig(combinedRatingConfig);

    final Map<String, Object> data = (Map<String, Object>)responseMap.get(Arc_Gen_RatingGlobal_Constants.DATA_TEXT);
    final Map<String, Object> combinedRating = (Map<String, Object>)data.get(Arc_Gen_RatingGlobal_Constants.COMBINED_RATING_TEXT);

    List<arce__rating_variables_detail__c> processedCombinedRating = processCombRating(combinedRating, filteredCombinedRatings, accHasAnalysisId, rating, wrapper.externalMappingClass);
    ret.addAll(processedCombinedRating);

    return ret;
  }

  /**
  *-------------------------------------------------------------------------------
  * @description Method for splitting logic from processVariablesData method
  --------------------------------------------------------------------------------
  * @author jose.hijar.contractor@bbva.com
  * @date 29/12/2020
  * @param Map<String,Object> rCombRating 'combinedRating' object returned by service data
  * @param Set<String> fCombR List of ids which variables are being processed
  * @param String aHaId Account_has_Analysis__c object id where variables will be linked to
  * @param arce__rating__c rating rating__c object linked to the valid arce__Financial_Statements__c object lined to Account_has_Analysis__c object (AccHasAnalysis <- financialStatement <- rating )
  * @return List<arce__rating_variables_detail__c> resulting list of objects of processed variables
  * @example private static List<arce__rating_variables_detail__c> processCombRating(List<Object> rVarList, Set<String> fVars, String aHaId)
  **/
  @SuppressWarnings('PMD.ExcessiveParameterList')
  private static List<arce__rating_variables_detail__c> processCombRating(Map<String,Object> rCombRating, Set<String> fCombR, String aHaId, arce__rating__c rating, arce.Arc_GBL_RatingDetailsMapping_Interface mappingClass){
    List<arce__rating_variables_detail__c> ret = new List<arce__rating_variables_detail__c>();
    arce__rating_variables_detail__c combinedRating;
    List<Object> anchorsList;
    Map<String, Object> anchorMap;
    Decimal riskScore;
    Map<String, Object> templateMap;
    String combRId;
    Decimal wheight;
    Decimal weightSum;
    Map<String, Decimal> weightsByTemplate;

    if(fCombR != null && rCombRating != null){

      List<AggregateResult> activities = mappingClass.getActivitiesWeightByTemplate(aHaId, fCombR);
      AggregateResult activityWeightsSum = mappingClass.getRelativeWeightSum(aHaId);

      if(activities != null && !activities.isEmpty() && activityWeightsSum != null) {

        weightSum = activityWeightsSum != null ? (Decimal)activityWeightsSum.get('relativeWeight') : weightSum;

        riskScore = (Decimal)rCombRating.get(Arc_Gen_RatingGlobal_Constants.RISK_SCORE_TEXT);
        anchorsList = (List<Object>)rCombRating.get(Arc_Gen_RatingGlobal_Constants.ANCHORS_TEXT);

        rating.arce__combined_risk_score__c = riskScore;

        weightsByTemplate = new Map<String, Decimal>();

        String templateId;
        Decimal templateWeight;
        Decimal relativeWeight;
        for(AggregateResult acti : activities){
          templateId = (String)acti.get('arce__Template_type__c');
          templateWeight = (Decimal)acti.get('weight');

          relativeWeight = templateWeight * 100 / weightSum;
          weightsByTemplate.put(templateId, relativeWeight);
        }

        for(Object anchor : anchorsList) {
          anchorMap = (Map<String, Object>)anchor;
          templateMap = (Map<String, Object>)anchorMap.get(Arc_Gen_RatingGlobal_Constants.TEMPLATE_TEXT);
          combRId = (String)templateMap.get(Arc_Gen_RatingGlobal_Constants.ID_TEXT);
          if(fCombR.isEmpty() || fCombR.contains(combRId)) {
            wheight = weightsByTemplate.get(combRId);
            combinedRating = mappingClass.setRatingCombinedRating(anchorMap, combRId, wheight, aHaId, (String)rating.Id);
            ret.add(combinedRating);
          }
        }
      }
    }
    return ret;
  }

  /**
  *-------------------------------------------------------------------------------
  * @description Gets a set of block modifiers id´s for processing, identified by adjustment type
  --------------------------------------------------------------------------------
  * @author jose.hijar.contractor@bbva.com
  * @date 2020-11-11
  * @param List<arce__ratingOverlayMap__mdt> variablesConfig
  * @return Map<String,List<String>>
  * @example getFilteredAdjsMap(List<arce__ratingOverlayMap__mdt> variablesConfig adjustmentConfig)
  **/
  private static Map<String,List<String>> getFilteredAdjsMap(List<arce__ratingOverlayMap__mdt> adjustmentsConfig) {
    Map<String,List<String>> ret= new Map<String,List<String>>();

    if(adjustmentsConfig != null) {
      for(arce__ratingOverlayMap__mdt adjConfig : adjustmentsConfig) {
        if(adjConfig.arce__entire_block__c){
          ret.put('all', new List<String>());
        }else{
          ret.put(adjConfig.arce__adjustment_type__c, adjConfig.arce__blockIds__c.split(';'));
        }

      }
    }
    return ret;
  }

  /**
  *-------------------------------------------------------------------------------
  * @description Gets a set of block variable id´s for processing
  --------------------------------------------------------------------------------
  * @author jose.hijar.contractor@bbva.com
  * @date 2020-21-12
  * @param arce__ratingOverlayMap__mdt blockConfig
  * @return Set<String>
  * @example getFilteredConfig(arce__ratingOverlayMap__mdt blockConfig)
  **/
  private static Set<String> getFilteredConfig(arce__ratingOverlayMap__mdt blockConfig) {
    Set<String> ret;
    if (blockConfig != null) {
      ret = blockConfig.arce__entire_block__c ? new Set<String>() : new Set<String>(blockConfig.arce__blockIds__c.split(';'));
    }
    return ret;
  }

  /**
  *-------------------------------------------------------------------------------
  * @description Method that sets a rating variable with the obtained data
  --------------------------------------------------------------------------------
  * @author eduardoefrain.hernandez.contractor@bbva.com
  * @date 30/4/2019
  * @param List<arce__rating_variables_detail__c> variablesList - List of rating variable records
  * @param String ratingId - id for the current rating
  * @param String analysisId - Id of the analyzed Client
  * @return void
  * @example setFinanAlertInd(List<arce__rating_variables_detail__c> variablesList, String ratingId, String analysisId)
  **/
  private static void setFinanAlertInd(String ratingId, String analysisId) {
    final List<arce__rating_variables_detail__c> existentVariables = locator.getExistentVariables(analysisId,ratingId);
    final arce__rating_variables_detail__c finanAlertInd = new arce__rating_variables_detail__c();
    finanAlertInd.arce__rating_id__c = ratingId;
    finanAlertInd.arce__account_has_analysis_id__c = analysisId;
    finanAlertInd.arce__rating_modifier_desc__c = Arc_Gen_RatingGlobal_Constants.NONE_TEXT;
    finanAlertInd.arce__rating_override_reason_desc__c = Arc_Gen_RatingGlobal_Constants.FINANCIAL_ALERT_IND;
    for(arce__rating_variables_detail__c var : existentVariables) {
      if(var.arce__modifier_mix_type__c == Arc_Gen_RatingGlobal_Constants.OVERLAY_02 || var.arce__modifier_mix_type__c == Arc_Gen_RatingGlobal_Constants.OVERLAY_03 || var.arce__modifier_mix_type__c == Arc_Gen_RatingGlobal_Constants.OVERLAY_04) {
        finanAlertInd.arce__rating_modifier_desc__c = Arc_Gen_RatingGlobal_Constants.FINANCIAL_ALERT;
      }
    }
    locator.insertRecords(new List<arce__rating_variables_detail__c>{finanAlertInd});
  }
  /**
  *-------------------------------------------------------------------------------
  * @description If a string is null returns empty
  --------------------------------------------------------------------------------
  * @author eduardoefrain.hernandez.contractor@bbva.com
  * @date 30/4/2019
  * @param String valueString - String to evaluate
  * @return String - If the parameter is null returns empty
  * @example private static String supressNulls(String valueString)
  **/
  global static Decimal supressDecimalNull(String valueString) {
    Decimal decimalValue;
    if(String.isBlank(valueString) || valueString == Arc_Gen_RatingGlobal_Constants.NOT_APPLY) {
      decimalValue = 0;
    } else {
      decimalValue = Decimal.valueOf(valueString);
    }
    Return decimalValue;
  }
  /**
  *-------------------------------------------------------------------------------
  * @description If a string is null returns empty
  --------------------------------------------------------------------------------
  * @author eduardoefrain.hernandez.contractor@bbva.com
  * @date 30/4/2019
  * @param String valueString - String to evaluate
  * @return String - If the parameter is null returns empty
  * @example private static String supressNulls(String valueString)
  **/
  global static String supressStringNull(String valueString) {
    Return valueString == null ? '' : valueString;
  }
  /**
  *-------------------------------------------------------------------------------
  * @description Method that sets a map of rating values
  --------------------------------------------------------------------------------
  * @author eduardoefrain.hernandez.contractor@bbva.com
  * @date 04/10/2019
  * @param List<String> ratingList - List of rating values
  * @return Boolean invertMap - Indicates if the map will be returned Map<Integer,String> if false or Map<String,Integer> if true
  * @example getRatingMap(List<String> ratingList, Boolean invertMap)
  **/
  private static Map<Integer,String> getRatingMap(List<String> ratingList) {
    final Map<Integer,String> ratingMap = new Map<Integer,String>();
    for(Integer i = 0; i < ratingList.size(); i++) {
      ratingMap.put(i, ratingList[i]);
    }
    Return ratingMap;
  }
  /**
  *-------------------------------------------------------------------------------
  * @description Method that sets a map of rating values
  --------------------------------------------------------------------------------
  * @author eduardoefrain.hernandez.contractor@bbva.com
  * @date 04/10/2019
  * @param List<String> ratingList - List of rating values
  * @return Boolean invertMap - Indicates if the map will be returned Map<Integer,String> if false or Map<String,Integer> if true
  * @example getRatingMap(List<String> ratingList, Boolean invertMap)
  **/
  private static Map<String,Integer> getInvertRatingMap(List<String> ratingList) {
    final Map<String,Integer> invRatingMap = new Map<String,Integer>();
    for(Integer i = 0; i < ratingList.size(); i++) {
      invRatingMap.put(ratingList[i], i);
    }
    Return invRatingMap;
  }
  /**
  *-------------------------------------------------------------------------------
  * @description Method that sets a the general overlay values on the front
  --------------------------------------------------------------------------------
  * @author eduardoefrain.hernandez.contractor@bbva.com
  * @date 04/10/2019
  * @param List<arce__rating_variables_detail__c> variablesList - List of all rating variables
  * @param arce__rating__c rating - actual calculated rating record
  * @param arce__Account_has_Analysis__c analysis - Analyzed client
  * @return void
  * @example setOverlayValues(List<arce__rating_variables_detail__c> variablesList, arce__rating__c rating, arce__Account_has_Analysis__c analysis)
  **/
  private static void setOverlayValues(List<arce__rating_variables_detail__c> variablesList, HelperParameters wrapper) {
    arce__rating__c rating = wrapper.currentRating;
    arce__Account_has_Analysis__c accountHasAnalysis = wrapper.accHasAnalysis;

    final List<arce__rating_variables_detail__c> overlayVars = new List<arce__rating_variables_detail__c>();
    for(arce__rating_variables_detail__c variable : variablesList) {
      if(variable.arce__rating_modifier_adj_type__c == Arc_Gen_RatingGlobal_Constants.METHOD_OVERLAY) {
        overlayVars.add(variable);
      }
    }
    Switch on overlayVars.size() {
      When 1 {
        rating.arce__adj_long_rating_value_type__c = overlayVars[0].arce__adj_long_rating_value_type__c;
        rating.arce__adj_short_rating_value_type__c = overlayVars[0].arce__adj_short_rating_value_type__c;
        rating.arce__adj_total_rating_score_number__c = overlayVars[0].arce__adj_total_rating_score_number__c;
        accountHasAnalysis.arce__adj_long_rating_value_type__c = overlayVars[0].arce__adj_long_rating_value_type__c;
        accountHasAnalysis.arce__adj_short_rating_value_type__c = overlayVars[0].arce__adj_short_rating_value_type__c;
        accountHasAnalysis.arce__adj_total_rating_score_number__c = overlayVars[0].arce__adj_total_rating_score_number__c;
      }
      When 2, 3, 4 {
        final Map<String,String> mostNegRatings = getMostNegRating(overlayVars);
        rating.arce__adj_long_rating_value_type__c = mostNegRatings.get(Arc_Gen_RatingGlobal_Constants.LONG_TEXT);
        rating.arce__adj_short_rating_value_type__c = mostNegRatings.get(Arc_Gen_RatingGlobal_Constants.SHORT_TEXT);
        rating.arce__adj_total_rating_score_number__c = Decimal.valueOf(mostNegRatings.get(Arc_Gen_RatingGlobal_Constants.SCORE_TEXT));
        accountHasAnalysis.arce__adj_long_rating_value_type__c = mostNegRatings.get(Arc_Gen_RatingGlobal_Constants.LONG_TEXT);
        accountHasAnalysis.arce__adj_short_rating_value_type__c = mostNegRatings.get(Arc_Gen_RatingGlobal_Constants.SHORT_TEXT);
        accountHasAnalysis.arce__adj_total_rating_score_number__c = Decimal.valueOf(mostNegRatings.get(Arc_Gen_RatingGlobal_Constants.SCORE_TEXT));
      }
      When else {
        rating.arce__adj_long_rating_value_type__c = '';
        rating.arce__adj_short_rating_value_type__c = '';
        rating.arce__adj_total_rating_score_number__c = null;
        accountHasAnalysis.arce__adj_long_rating_value_type__c = '';
        accountHasAnalysis.arce__adj_short_rating_value_type__c = '';
        accountHasAnalysis.arce__adj_total_rating_score_number__c = null;
      }
    }
  }
  /**
  *-------------------------------------------------------------------------------
  * @description Method that sets a the general overlay values on the front
  --------------------------------------------------------------------------------
  * @author eduardoefrain.hernandez.contractor@bbva.com
  * @date 04/10/2019
  * @param List<arce__rating_variables_detail__c> overlayVars - List of overlay rating modifier variables
  * @return Map<String,String> - The most negative rating values
  * @example getMostNegRating(List<arce__rating_variables_detail__c> overlayVars)
  **/
  private static Map<String,String> getMostNegRating(List<arce__rating_variables_detail__c> overlayVars) {

    final Map<String,Integer> shortInvRatingMap = getInvertRatingMap(Arc_Gen_RatingGlobal_Constants.SHORT_RATING_LIST);
    final Map<String,Integer> longInvRatingMap = getInvertRatingMap(Arc_Gen_RatingGlobal_Constants.LONG_RATING_LIST);
    final List<Integer> shortNumbers = new List<Integer>();
    final List<Integer> longNumbers = new List<Integer>();
    final List<Decimal> ratingScoreList = new List<Decimal>();
    for(arce__rating_variables_detail__c var : overlayVars) {
      shortNumbers.add(shortInvRatingMap.get(var.arce__adj_short_rating_value_type__c));
      longNumbers.add(longInvRatingMap.get(var.arce__adj_long_rating_value_type__c));
      if(var.arce__rating_var_score_number__c != null){
        ratingScoreList.add(var.arce__rating_var_score_number__c);
      }
    }
    Return calcMostNegRatings(shortNumbers, longNumbers, ratingScoreList);
  }
  /**
  *-------------------------------------------------------------------------------
  * @description Method that calculates the most negative rating
  --------------------------------------------------------------------------------
  * @author eduardoefrain.hernandez.contractor@bbva.com
  * @date 04/10/2019
  * @param List<Integer> shortNumbers - List of ratings in short scale
  * @param List<Integer> longNumbers - List of ratings in long scale
  * @param List<Decimal> ratingScoreList - List of rating scores
  * @return Map<String,String> - The most negative rating values
  * @example calcMostNegRatings(List<Integer> shortNumbers, List<Integer> longNumbers, List<Decimal> ratingScoreList)
  **/
  private static Map<String,String> calcMostNegRatings(List<Integer> shortNumbers, List<Integer> longNumbers, List<Decimal> ratingScoreList) {
    final Map<String,String> mostNegRatings = new Map<String,String>();
    final Map<Integer,String> shortRatingMap = getRatingMap(Arc_Gen_RatingGlobal_Constants.SHORT_RATING_LIST);
    final Map<Integer,String> longRatingMap = getRatingMap(Arc_Gen_RatingGlobal_Constants.LONG_RATING_LIST);
    Integer tempShortNumber = 0;
    for(Integer num : shortNumbers) {
      if(num > tempShortNumber) {
        tempShortNumber = num;
      }
    }
    Integer tempLongNumber = 0;
    for(Integer num : longNumbers) {
      if(num > tempLongNumber) {
        tempLongNumber = num;
      }
    }
    Decimal tempScore = 0;
    for(Decimal num : ratingScoreList) {
      if(tempScore == 0) {
        tempScore = num;
      } else if(num < tempScore) {
        tempScore = num;
      }
    }
    mostNegRatings.put(Arc_Gen_RatingGlobal_Constants.SHORT_TEXT,shortRatingMap.get(tempShortNumber));
    mostNegRatings.put(Arc_Gen_RatingGlobal_Constants.LONG_TEXT,longRatingMap.get(tempLongNumber));
    mostNegRatings.put(Arc_Gen_RatingGlobal_Constants.SCORE_TEXT,String.valueOf(tempScore));
    Return mostNegRatings;
  }
  /**
  *-------------------------------------------------------------------------------
  * @description Method that inicializes the leveraged variables in null
  --------------------------------------------------------------------------------
  * @author eduardoefrain.hernandez.contractor@bbva.com
  * @date 30/4/2019
  * @param Map<String, Object> responseMap
  * @return String - The error string
  * @example global static String processErrorData(Map<String, Object> responseMap)
  **/
  global static Arc_Gen_ServiceAndSaveResponse updateLeveragedVars(Arc_Gen_ServiceAndSaveResponse serviceAndSaveResp, arce__Account_has_Analysis__c accHasAn) {
    if(serviceAndSaveResp.saveStatus == 'true') {
      Arc_Gen_RatingGlobal_data locator = new Arc_Gen_RatingGlobal_data();
      accHasAn.arce__ll_before_adj_ind_type__c = null;
      accHasAn.arce__ll_before_adj_clsfn_type__c = null;
      accHasAn.arce__ll_after_adj_ind_type__c = null;
      accHasAn.arce__ll_after_adj_clsfn_type__c = null;
      locator.updateRecords(new List<sObject>{accHasAn});
    }
    return serviceAndSaveResp;
  }

  /**
  *-------------------------------------------------------------------------------
  * @description Method that inserts the rating variables
  --------------------------------------------------------------------------------
  * @author eduardoefrain.hernandez.contractor@bbva.com
  * @date 30/4/2019
  * @param List<arce__rating_variables_detail__c> recordsToInsert
  * @param String analysisId current account has analisis id
  * @param String ratingId current rating id
  * @return Arc_Gen_RatingGlobal_data.saveResult - A wrapper with the result of a DML operation
  * @example global static Arc_Gen_RatingGlobal_data.saveResult setRatingVariables(List<arce__rating_variables_detail__c> recordsToInsert,String analysisId,String ratingId)
  **/
  private static void removePreviousVars(HelperParameters wrapper) {
    String analysisId = wrapper.accHasAnalysis.Id;
    String prevRatingId = wrapper.accHasAnalysis.arce__ffss_for_rating_id__r.arce__rating_id__c;
    String rating2keep = wrapper.rating2Keep;

    List<arce__rating_variables_detail__c> prevVariables = locator.getExistentVariables(analysisId,prevRatingId);
    List<arce__rating_variables_detail__c> existentVariables = new List<arce__rating_variables_detail__c> ();
    if(rating2keep == null) {
      existentVariables = prevVariables;
    } else {
      for (arce__rating_variables_detail__c rvar : prevVariables) {
        if(!rating2keep.equals(String.valueOf(rvar.Id))) {
          existentVariables.add(rvar);
        }
      }
    }
    if(!existentVariables.isEmpty()) {
      locator.deleteRecords(existentVariables);
    }
  }
  /**
  *-------------------------------------------------------------------------------
  * @description Method that return value
  --------------------------------------------------------------------------------
  * @author juanmanuel.perez.ortiz.contractor@bbva.com
  * @param String value
  * @return String
  * @example setRatingValue(String value)
  **/
  global static String setRatingValue(String value) {
    String variableValue;
    variableValue = value == Arc_Gen_RatingGlobal_Constants.NOT_APPLY ? NULL : value;
    return variableValue;
  }
  /**
  *-------------------------------------------------------------------------------
  * @description Method that return client type
  --------------------------------------------------------------------------------
  * @author juanmanuel.perez.ortiz.contractor@bbva.com
  * @param String clientType
  * @return String
  * @example setClientType(String clientType)
  **/
  global static String setClientType(String clientType) {
    return clientType == '1' ? Arc_Gen_RatingGlobal_Constants.PATHGR : Arc_Gen_RatingGlobal_Constants.PATHSUB;
  }
  /**
  *-------------------------------------------------------------------------------
  * @description Method that return value
  --------------------------------------------------------------------------------
  * @author saimassimilianno.jordana.contractor@bbva.com
  * @param String value
  * @return String
  * @example getModelByAha(arce__Account_has_Analysis__c ahas)
  **/
  global static String getModelByAha(arce__Account_has_Analysis__c accHas) {
    String modelValue = '';
    final String sectorName = accHas.arce__RAR_rating_tool_id__c;

    arce__Arce_Config__mdt arceConfig = Arc_Gen_RatingGlobal_data.getArceConfig('Model2012IRP');

    if (arceConfig != null && arceConfig.arce__Value1__c != 'false' && String.isNotBlank(sectorName)) {
      final String configWf = arceConfig.arce__Value1__c;
      for (String current : configWf.split(';')) {
          final List<String> keyValue = current.split(':');
          Integer result = keyValue[0].length();
          if (sectorName.left(result) == keyValue[0]) {
            modelValue = keyValue[0];
            break;
          }
      }
    }

    return modelValue;
  }
  /**
  *-------------------------------------------------------------------------------
  * @description Method that update data from override rating variable
  --------------------------------------------------------------------------------
  * @author juanmanuel.perez.ortiz.contractor@bbva.com
  * @param Map<String, Object> ratingAdjMap map for adjustments for rating
  * @param String analysisId current analisis for rating
  * @param arce__rating__c rating current rating for analisis
  * @return arce__rating_variables_detail__c
  * @example updateRatVarOverride(Map<String, Object> ratingAdjMap,String analysisId,arce__rating__c rating)
  **/
  global static arce__rating_variables_detail__c updateRatVarOverride(Map<String, Object> ratingAdjMap,String analysisId,arce__rating__c rating) {
      final arce__rating_variables_detail__c variable = Arc_Gen_RatingGlobal_data.getOverrideVariable(analysisId);
      final Object modifierObj = (Object)ratingAdjMap.get(Arc_Gen_RatingGlobal_Constants.MODIFIER);
      final Map<String, Object> modifierMap = (Map<String, Object>)modifierObj;
      final String adjShortRating = (String)ratingAdjMap.get(Arc_Gen_RatingGlobal_Constants.SHORT_VALUE);
      final String adjLongRating = (String)ratingAdjMap.get(Arc_Gen_RatingGlobal_Constants.LONG_VALUE);
      variable.arce__rating_Id__c = rating.Id;
      variable.arce__account_has_analysis_id__c = analysisId;
      variable.arce__rating_variable_level_id__c = (String)ratingAdjMap.get(Arc_Gen_RatingGlobal_Constants.LEVEL);
      if(modifierMap != null) {
          variable.arce__rating_modifier_id__c = (String)modifierMap.get(Arc_Gen_RatingGlobal_Constants.ID_TEXT);
          variable.arce__rating_modifier_desc__c = (String)modifierMap.get(Arc_Gen_RatingGlobal_Constants.DESCRIPTION);
          variable.arce__rating_variable_name__c = (String)modifierMap.get(Arc_Gen_RatingGlobal_Constants.DESCRIPTION);
      }
      String adjustmentType = (String)((Map<String,Object>)ratingAdjMap.get(System.Label.Cls_arce_RatingRespAdjType)).get(System.Label.Cls_arce_RatingId);
      variable.arce__rating_modifier_adj_type__c = adjustmentType;
      variable.arce__rating_var_score_number__c = (Decimal)ratingAdjMap.get(System.Label.Cls_arce_RatingRespScore);
      variable.arce__adj_long_rating_value_type__c = Arc_Gen_RatingGlobal_helper.setRatingValue(adjLongRating);
      variable.arce__adj_short_rating_value_type__c = Arc_Gen_RatingGlobal_helper.setRatingValue(adjShortRating);
      variable.arce__PD_per__c = (Decimal)ratingAdjMap.get(Arc_Gen_RatingGlobal_Constants.DEFAULT_PROBABILITY);
      variable.arce__adj_total_rating_score_number__c = (Decimal)ratingAdjMap.get(Arc_Gen_RatingGlobal_Constants.SCORE);
      variable.arce__rating_override_reason_desc__c = adjustmentType == Arc_Gen_RatingGlobal_Constants.METHOD_OVERRIDE ? (String)modifierMap.get(Arc_Gen_RatingGlobal_Constants.DESCRIPTION) : '';
      Return variable;
  }
}