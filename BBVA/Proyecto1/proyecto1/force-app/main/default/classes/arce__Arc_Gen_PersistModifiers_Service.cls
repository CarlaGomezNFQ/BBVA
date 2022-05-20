/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_PersistModifiers_Service
* @Author   jorge.diaz-blanco.contractor@bbva.com
* @Date     Created: 21/09/2020
* @Group    ARCE
* ------------------------------------------------------------------------------------------------
* @Description Class that interfaces with the qualitative blocks service to persist
* qualitative variables.
* -----------------------------------------------------------------------------------------------
* @Changes
*
* |2020-10-20 ivan.cons@bbva.com
*             Class refactor to be instantiable.
* 2020-10-29    alexander.munguia.contractor@bbva.com   the parameter passed from method persistVariablesOfAnalysis is passed to type string
*             Class refactor to be instantiable.
* 2021-01-19    ivan.cons@bbva.com   refactor wrapper due to API change
* 2021-03-24    juanpedro.benito.contractor@bbva.com   add debug in callouts
* |2021-04-14 joseluis.garcia4.contractor@bbva.com
*             Class renaming for dependencies package.
* |2020-05-20    amunguia.contractor@bbva.com                   Add error handling for RatingEngine.
* --------------------------------------------------------------------------------------------------------
*/
global class Arc_Gen_PersistModifiers_Service {
    /**
    * @Description: Name of the service to be called.
    */
    final String SERVICENAME;
    /**
    * @Description: Name of the Service_Persistence config to be used.
    */
    final String CONFIGNAME;
    /**
    * @Description: Whether legacy mode is enabled. When enabled, uses riskAssessmentId as qualitativeBlockId.
    */
    final Boolean LEGACYMODE;
    /**
    *-------------------------------------------------------------------------------
    * @description Wrapper used to return the results from the variable persistence.
    *-------------------------------------------------------------------------------
    **/
    global class VariablePersistenceResult {
        /**
        * @Description: Code returned by the service.
        */
        @AuraEnabled
        global String serviceCode { get; set; }
        /**
        * @Description: Response returned by the service.
        */
        @AuraEnabled
        global String serviceMessage { get; set; }
    }
    /**
    *-------------------------------------------------------------------------------
    * @description Wrapper used to describe a financialStatement in the same format
    * as required by the service.
    *-------------------------------------------------------------------------------
    **/
    private class FinancialStatementWrapper {
        /**
        * @Description: Unique identification of the financialStatement.
        */
        private String id { get; set; }
    }
    /**
    *-------------------------------------------------------------------------------
    * @description Wrapper used to describe a businessAgent in the same format
    * as required by the service.
    *-------------------------------------------------------------------------------
    **/
    private class BusinessAgentWrapper {
        /**
        * @Description: Unique identification of the businessAgent.
        */
        private String id { get; set; }
    }
    /**
    *-------------------------------------------------------------------------------
    * @description Wrapper used to describe a qualitative variable in the same format
    * as required by the service.
    *-------------------------------------------------------------------------------
    **/
    private class QualitativeVariableWrapper {
        /**
        * @Description: Unique identification of the qualitative variable in the rating model.
        */
        private String id { get; set; }
        /**
        * @Description: Value of the variable used within the rating.
        */
        private String value { get; set; }
        /**
        * @Description: Specifies if the data is a block or a factor within a rating model.
        */
        private String variableType { get; set; }
        /**
        * @Description: Specifies if the data is a block or a factor within a rating model.
        */
        private String parentCode { get; set; }
    }
    /**
    *-------------------------------------------------------------------------------
    * @description Wrapper used to describe the parameters to be provided to the service.
    *-------------------------------------------------------------------------------
    **/
    private class QualitativeBlocksParamSet {
        /**
        * @Description: Unique risk assessment identifier.
        */
        private String riskAssessmentId { get; set; }
        /**
        * @Description: Unique participant identifier.
        */
        private String participantId { get; set; }
        /**
        * @Description: Unique identification of the qualitative block (the same ID as the risk
        * assessment will be used).
        */
        private String qualitativeBlockId { get; set; }
        /**
        * @Description: JSON object to be provided to the service in the request body.
        */
        private String jsonIn { get; set; }
    }

    /**
    *-------------------------------------------------------------------------------
    * @description Constructor. If no config name is provided, it defaults to the service name.
    *-------------------------------------------------------------------------------
    **/
    global Arc_Gen_PersistModifiers_Service(String servicename) {
        this.SERVICENAME = servicename;
        this.CONFIGNAME = servicename;
        this.LEGACYMODE = false;
    }

    /**
    *-------------------------------------------------------------------------------
    * @description Constructor.
    *-------------------------------------------------------------------------------
    **/
    global Arc_Gen_PersistModifiers_Service(String servicename, String configname) {
        this.SERVICENAME = servicename;
        this.CONFIGNAME = configname;
        this.LEGACYMODE = false;
    }

    /**
    *-------------------------------------------------------------------------------
    * @description Constructor.
    *-------------------------------------------------------------------------------
    **/
    global Arc_Gen_PersistModifiers_Service(String servicename, String configname, Boolean legacy) {
        this.SERVICENAME = servicename;
        this.CONFIGNAME = configname;
        this.LEGACYMODE = legacy;
    }

    /**
    *-------------------------------------------------------------------------------
    * @description Persists the qualitative variables of the fields filled in the
    * Account_has_Analysis__c record.
    *-------------------------------------------------------------------------------
    * @author jorge.diaz-blanco.contractor@bbva.com
    * @date 21/09/2020
    * @param arce__Account_has_Analysis__c ahaObject - AHA object the variables with the variables to be persisted.
    * @return arce.Arc_Gen_ServiceAndSaveResponse - Service response.
    **/
    global VariablePersistenceResult persistVariablesOfAnalysis(String ahaObjectId) {

        // Get all the information about the AHA.
        final arce.Arc_Gen_Account_Has_Analysis_Wrapper ahaFullObject = arce.Arc_Gen_AccHasAnalysis_Data.getAccountHasAnalysisAndCustomer(new List<String> { ahaObjectId })[0];
        final arce__Account_has_Analysis__c accHasAnalysis = arce.Arc_Gen_AccHasAnalysis_Data.getAccHasAnalysis(new List<String>{ahaObjectId})[0];
        final String clientId = arce.Arc_Gen_AccHasAnalysis_Data.getCorrectIdWAhas(accHasAnalysis);
        final arce.Arc_Gen_Account_Wrapper accWrapper = arce.Arc_Gen_Account_Locator.getAccountInfoById(new List<Id> { clientId }).get(clientId);
        final String customerNumber = arce.Arc_Gen_CallEncryptService.getEncryptedClient(accWrapper.accNumber);
        final List<arce__Modifier__c> lstMod =  Arc_Gen_Modifiers_Utils.getModifierInfo(new Set<String>{ahaObjectId});
        if(!lstMod.isEmpty()) {
            ahaFullObject.modifierObj = lstMod[0];
        }
        final List<arce__Overlay__c> overlayList =  Arc_Gen_Overlays_Utils.getOverlaysByAha(new Set<String>{ahaObjectId});
        if(!overlayList.isEmpty()) {
            ahaFullObject.overlayObj = overlayList[0];
        }
        // Get variables that need to be persisted.
        final List<QualitativeVariableWrapper> varToPersist = getVariablesToPersist(ahaFullObject);
        // Call service.
        final arce.Arc_Gen_ServiceAndSaveResponse resp = persistQualitativeVariables(ahaFullObject.ahaObj.Name, customerNumber, varToPersist, ahaObjectId);
        // Return response.
        final VariablePersistenceResult result = new VariablePersistenceResult();
        result.serviceCode = resp.serviceCode;
        result.serviceMessage = resp.serviceMessage;
        return result;
    }

    /**
    *-------------------------------------------------------------------------------
    * @description Gets the list of variables to persist from the provided AHA.
    *-------------------------------------------------------------------------------
    * @author jorge.diaz-blanco.contractor@bbva.com
    * @date 21/09/2020
    * @param arce__Account_has_Analysis__c ahaObject - AHA object the variables with the variables to be persisted.
    * @return List<QualitativeVariableWrapper> - The variables to be persisted.
    **/
    private List<QualitativeVariableWrapper> getVariablesToPersist(arce.Arc_Gen_Account_Has_Analysis_Wrapper ahaObject) {
      final Map<String, Arc_Gen_PersistModifiers_Data.ModifierVariableDefinition> varByApiName =
      Arc_Gen_PersistModifiers_Data.getModifierVariablesDefinition(CONFIGNAME);
      final List<QualitativeVariableWrapper> varToPersist = new List<QualitativeVariableWrapper>();

      for(String elem: varByApiName.keySet()) {
        Map<String,Object> param = ahaObject.getX(elem.split('\\.')[0]);
        if(param != null && param.get(elem.split('\\.')[1]) != null) {
          final QualitativeVariableWrapper variableToPersist = new QualitativeVariableWrapper();
          variableToPersist.id = varByApiName.get(elem).id;
          variableToPersist.variableType = varByApiName.get(elem).type;
          variableToPersist.value = String.valueOf(param.get(elem.split('\\.')[1]));
          variableToPersist.parentCode = varByApiName.get(elem).parentCode;
          varToPersist.add(variableToPersist);
        }
      }
      return varToPersist;
    }

    /**
    *-------------------------------------------------------------------------------
    * @description Calls the qualitativeBlocks persistence service to save the provided qualitative
    * variables of an ARCE.
    *-------------------------------------------------------------------------------
    * @author jorge.diaz-blanco.contractor@bbva.com
    * @date 21/09/2020
    * @param String riskAssessmentId - Risk assessment ID.
    * @param String customerNumber - Participant ID.
    * @param List<QualitativeVariableWrapper> varToPersist - List of variables to be persisted.
    * @return arce.Arc_Gen_ServiceAndSaveResponse - Wrapper that contains the response of the called service.
    **/
    private arce.Arc_Gen_ServiceAndSaveResponse persistQualitativeVariables(String riskAssessmentId,
        String customerNumber, List<QualitativeVariableWrapper> varToPersist, id ahaId) {
        final arce.Arc_Gen_ServiceAndSaveResponse serviceAndSaveResp = new arce.Arc_Gen_ServiceAndSaveResponse();
        if (varToPersist.isEmpty()) {
            serviceAndSaveResp.serviceCode = '200';
            final Map<String, Object> errWrapper = new Map<String, Object>();
            errWrapper.put('errorCode', '200');
            errWrapper.put('errorTitle', Arc_Gen_RatingGlobal_Constants.ERROR_TEXT);
            errWrapper.put('errorMessage', 'No variables persisted');
            serviceAndSaveResp.serviceMessage = JSON.serialize(errWrapper);
        } else {
            // Set service parameters.
            Arc_Gen_RatingGlobal_data dataClass = new Arc_Gen_RatingGlobal_data();
            arce__rating__c currentRating = LEGACYMODE ? null : dataClass.getCurrentRating(ahaId);  // NOSONAR
            final Map<String, Object> outerVarMap = new Map<String, Object>();
            outerVarMap.put('qualitativeVariables', varToPersist);
            final QualitativeBlocksParamSet serviceParams = new QualitativeBlocksParamSet();
            serviceParams.riskAssessmentId = riskAssessmentId;
            serviceParams.participantId = customerNumber;
            serviceParams.qualitativeBlockId = LEGACYMODE ? riskAssessmentId : currentRating.arce__rating_id__c;
            serviceParams.jsonIn = JSON.serialize(outerVarMap);
            // Call service.
            final String jsonInput = JSON.serialize(serviceParams);
            final arce.Arc_Gen_getIASOResponse.serviceResponse response = arce.Arc_Gen_getIASOResponse.calloutIASO(SERVICENAME, jsonInput);
            serviceAndSaveResp.serviceCode = response.serviceCode;
            final Map<String, Object> errWrapper = new Map<String, Object>();
            errWrapper.put('errorCode', response.serviceCode);
            errWrapper.put('errorTitle', Arc_Gen_RatingGlobal_Constants.ERROR_TEXT);
            errWrapper.put('errorMessage', response.serviceMessage);
            serviceAndSaveResp.serviceMessage = JSON.serialize(errWrapper);
            System.debug('persistenceModifiers/persistenceOverlays jsonInput ' + jsonInput);
            System.debug('persistenceModifiers/persistenceOverlays response ' + response);
            System.debug('persistenceModifiers/persistenceOverlays jsonInput ' + jsonInput);
            System.debug('persistenceModifiers/persistenceOverlays response ' + response);
        }
        return serviceAndSaveResp;
    }
}