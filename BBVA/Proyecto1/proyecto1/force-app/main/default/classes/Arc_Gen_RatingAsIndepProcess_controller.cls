/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_RatingAsIndepProcess_controller
* @Author   eduardoefrain.hernandez.contractor@bbva.com
* @Date     Created: 2019-04-30
* @Group    ARCE
* ------------------------------------------------------------------------------------------------
* @Description Controller of the new rating as independent process
* ------------------------------------------------------------------------------------------------
* @Changes
*
* |2019-08-01 eduardoefrain.hernandez.contractor@bbva.com
*             Class creation.
* |2020-03-30 eduardoefrain.hernandez.contractor@bbva.com
*             Update arce.Arc_Gen_AccHasAnalysis_Data.accHasAnByArce call method
* |2020-03-31 juanignacio.hita.contractor@bbva.com
*             Update class test to support new fetchaccounts refactor
* |2020-04-02 joseluis.garcia4.contractor@bbva.com
*             Refactor of New Analysis + RAIP modal.
* |2020-04-24 joseluis.garcia4.contractor@bbva.com
*             Implement call to triage engine.
* |2020-04-29 joseluis.garcia4.contractor@bbva.com
*             Check if client is not ARCE scope.
* |2020-05-07 joseluis.garcia4.contractor@bbva.com
*             Implement finalizePrerating() method.
* |2020-05-19 joseluis.garcia4.contractor@bbva.com
*             Include riskSegment in response.
* |2020-07-14 javier.soto.carrascosa@bbva.com
*             Use header method for risk assessment persistence
* |2020-09-23 saimassimilianno.jordana.contractor@bbva.com
*             Added arce. namespace to all classes that are now in the arce-dependencies package
* |2020-12-04 juanignacio.hita.contractor@bbva.com
*             Adds aha name (analysisId) param in traceability record
* |2020-12-18 juanignacio.hita.contractor@bbva.com
*             Add callRiskFilter method
* |2021-02-15 juanpedro.benito.contractor@bbva.com
*             Add getRAIPWfMetadata and picklistValueOfSelectWf methods
* |2021-02-24 saimassimilianno.jordana.contractor@bbva.com
*             Add newFFSSWAhas method
* |2021-03-30 saimassimilianno.jordana.contractor@bbva.com
*             Add new parameters to newFFSSWAhas meth0d.newFFSSWAhas
* |2021-04-27 antonio.munoz.perez.contractor@bbva.com
*             Add globalRunWayConfig() method
* |2021-04-28 antonio.munoz.perez.contractor@bbva.com
*             Add localURLs() method
* |2021-05-05 saimassimilianno.jordana.contractor@bbva.com
*             Add new parameters newFFSSWAhas meth0d.
* |2021-06-09 saimassimilianno.jordana.contractor@bbva.com
*             Modify picklistValueOfSelectWf meth0d and irpWfUpdt, model2012Active new meth0ds added.
* |2021-06-09 saimassimilianno.jordana.contractor@bbva.com
*             Group validation added to control ARP flow usage in picklistValueOfSelectWf meth0d.
* |2021-09-20 saimassimilianno.jordana.contractor@bbva.com
*             checkRatingType and addToWfValue meth0ds added to control rating types.
* |2021-10-28 amunguia.contractor@bbva.com
*             the call to the riskfilter service is controlled according to arce_Config.
* -----------------------------------------------------------------------------------------------
*/
@SuppressWarnings('PMD.ExcessivePublicCount, sf:TooManyMethods')
public class Arc_Gen_RatingAsIndepProcess_controller {
    /**
    *-------------------------------------------------------------------------------
    * @description empty constructor to sonar validations
    *--------------------------------------------------------------------------------
    * @date		27/01/2020
    * @author	eduardoefrain.hernandez.contractor@bbva.com
    */
    @testVisible
    private Arc_Gen_RatingAsIndepProcess_controller() {

    }
    /** ----------------------------------------------------------------------------------------------------
    * @Description False literal.
    * ---------------------------------------------------------------------------------------------------- **/
    private static final String FALSE_LITERAL = 'false';
    /** ----------------------------------------------------------------------------------------------------
    * @Description Label for Rating.
    * ---------------------------------------------------------------------------------------------------- **/
    private static final String RATING_LABEL = 'Rating';
    /** ----------------------------------------------------------------------------------------------------
    * @Description Label for Pre Rating.
    * ---------------------------------------------------------------------------------------------------- **/
    private static final String PRERATING_LABEL = 'Pre-Rating';
    /** ----------------------------------------------------------------------------------------------------
    * @Description value for Pre Rating.
    * ---------------------------------------------------------------------------------------------------- **/
    private static final String PRERATING_VALUE = 'Prerating';
    /** ----------------------------------------------------------------------------------------------------
    * @Description Wrapper class used to return options workflow to Aura component.
    * ----------------------------------------------------------------------------------------------------
    **/
    public class WfValue {
        /**
        * @Description: value for Workflow picklist.
        */
        @AuraEnabled
        public String value { get; set; }

        /**
        * @Description: label for Workflow picklist.
        */
        @AuraEnabled
        public String label { get; set; }

        /**
        * @Description: Constructor
        */
        public WfValue(String value, String label) {
            this.value = value;
            this.label = label;
        }
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Method that returns the response of the saved records of RAIP
    *-------------------------------------------------------------------------------
    * @Date 2020-08-01
    * @Author eduardoefrain.hernandez.contractor@bbva.com
    * @param String accHasAnalysisId - Standard Id of the current chrome
    * @param String ratingModelValue - Code of the rating model retrieved by Triage service
    * @return String - Wrapper that contains the status and the response of the updated
    * @example persistRatingModel(accHasAnalysisId, ratingModelValue)
    *-------------------------------------------------------------------------------
    */
    @AuraEnabled
    public static String persistRatingModel(String accHasAnalysisId, String ratingModelValue, String raipType) {
        Return Json.serialize(Arc_Gen_RatingAsIndepProcess_service.persistRatingModel(accHasAnalysisId, ratingModelValue, raipType));
    }
    /**
    *-------------------------------------------------------------------------------
    * @description method that call callEngineFinancialState and return the status of engine.
    *--------------------------------------------------------------------------------
    * @author eduardoefrain.hernandez.contractor@bbva.com
    * @date 2020-10-01
    * @param recordId recordId of the account_has_analysis and the list of elements selected from the table.
    * @param lista data for the tables
    * @return list with values of the response.
    * @example public static Arc_Gen_Balance_Tables_service.ratiosAndRatingResponse callEngineFinancialState(String recordId,String lista) {
    **/
    @AuraEnabled
    public static Arc_Gen_Balance_Tables_service.ratiosAndRatingResponse callRatiosEngine(String accHasAnalysisId, String ffssList, Boolean isRAIP) {
        Arc_Gen_Balance_Tables_service.ratiosAndRatingResponse resp = new Arc_Gen_Balance_Tables_service.ratiosAndRatingResponse();
        try {
            resp = new Arc_Gen_Balance_Tables_service.ratiosAndRatingResponse();
            resp.ratiosStatus = FALSE_LITERAL;
        } catch(Exception ex) {
            resp.ratiosStatus = FALSE_LITERAL;
            resp.ratiosErrorMsg = ex.getMessage() + ' - ' + ex.getLineNumber();
        }
        return resp;
    }
    /**
    *-------------------------------------------------------------------------------
    * @description Gets triage config (whether or not the triage engine should be called)
    * and list of rating tool IDs the user can select from.
    *--------------------------------------------------------------------------------
    * @author joseluis.garcia4.contractor@bbva.com
    * @date 2020-04-27
    * @return the triage configuration.
    **/
    @AuraEnabled
    public static Arc_Gen_RatingAsIndepProcess_service.TriageConfig getTriageConfig() {
        final Arc_Gen_RatingAsIndepProcess_service.TriageConfig triageConfig =
            new Arc_Gen_RatingAsIndepProcess_service.TriageConfig();

        // Get whether or not triage engine is called from config.
        final List<arce__Arce_Config__mdt> callTriageArceConf = arce.Arc_Gen_Arceconfigs_locator.getConfigurationInfo('RAIPCallTriageEngine');
        Boolean callTriageEngine = false;
        if (!callTriageArceConf.isEmpty()) {
            callTriageEngine = Boolean.valueOf(callTriageArceConf[0].arce__Value1__c);
        }
        triageConfig.triageCallEnabled = callTriageEngine;

        // If triage call will not be done, fetch list of rating tool ids the user will
        // be able to select from.
        if (!callTriageEngine) {
            triageConfig.ratingToolList = Arc_Gen_RatingAsIndepProcess_service.getUserSelectableRatingTools();
        }

        return triageConfig;
    }
    /**
    *-------------------------------------------------------------------------------
    * @description calls triage engine.
    *--------------------------------------------------------------------------------
    * @author joseluis.garcia4.contractor@bbva.com
    * @date 2020-04-23
    * @param analysisId ID of the analysis
    * @param customerId ID of customer
    * @return Service results
    **/
    @AuraEnabled
    public static arce.Arc_Gen_ServiceAndSaveResponse callTriage(String analysisId, String customerId) {
        arce.Arc_Gen_ServiceAndSaveResponse response = new arce.Arc_Gen_ServiceAndSaveResponse();
        try {
            final String param = Arc_Gen_Triage_service.setServiceParameters(analysisId, customerId, true);
            final Arc_Gen_Triage_helper.triageResponse resp = Arc_Gen_Triage_service.setupTriageService(analysisId, param, '');

            // Check if ARCE is in scope.
            final Boolean scopeArce = Boolean.valueOf(resp.groupInScope);
            if (!scopeArce) {
                // Client is not scope of ARCE, finalize raip.
                Arc_Gen_RatingAsIndepProcess_service.finalizeRaip(analysisId, resp.response);
            }

            // Build response.
            final Map<String, Object> responseMap = new Map<String, Object>();
            responseMap.put('arceInScope', scopeArce);
            responseMap.put('riskSegment', resp.riskSegment);
            resp.response.serviceMessage = JSON.serialize(responseMap);

            response = resp.response;
        } catch (Exception ex) {
            response.serviceMessage = System.Label.Lc_arce_NewARCE_UnexpectedError;
            response.saveStatus = '500';
        }
        return response;
    }
    /**
    *-------------------------------------------------------------------------------
    * @description set the analysis in the response
    *--------------------------------------------------------------------------------
    * @date 02/11/2019
    * @author luisarturo.parra.contractor@bbva.com
    * @param recordId recordId - id of the account_has_analysis
    * @param String analysisType (arce__anlys_wkfl_sub_process_type__c)
    * @return AnalysisResponse - Response of the created ARCE
    * @example setupAnalysis(String recordId, String analysisType) {
    */
    @AuraEnabled
    public static String setanalysis(Map<string,string> data) {
        Arc_Gen_NewAnalysis_Service.AnalysisResponse analysisresponse = new Arc_Gen_NewAnalysis_Service.AnalysisResponse();
        analysisresponse = Arc_Gen_NewAnalysis_Service.setanalysis(data);
        return JSON.serialize(analysisresponse);
    }
    /**
    *-------------------------------------------------------------------------------
    * @description Method that calls the Persistance service.
    *-------------------------------------------------------------------------------
    * @date 2020-10-01
    * @author eduardoefrain.hernandez.contractor@bbva.com
    * @param String analysisId - Analysis Id
    * @return arce.Arc_Gen_ServiceAndSaveResponse - Wrapper that contains the response of the called service and the DML operation
    * @example public static arce.Arc_Gen_ServiceAndSaveResponse callPersistence(String customerId, String analysisId)
    */
    @AuraEnabled
    public static arce.Arc_Gen_ServiceAndSaveResponse callPersistence(String analysisId, String customerId) {
        final Arc_Gen_PersistanceArceId_service service = new Arc_Gen_PersistanceArceId_service();
        arce.Arc_Gen_ServiceAndSaveResponse response = new arce.Arc_Gen_ServiceAndSaveResponse();
        try {
            response = service.setupRiskAssHeader(analysisId, Arc_Gen_SetFinancialSponsor_Service.FINANCIAL_SPONSOR_NO);
        } catch (QueryException ex) {
            response.serviceCode = '404';
            response.serviceMessage = ex.getMessage();
        }
        Return response;
    }
    /**
    *-------------------------------------------------------------------------------
    * @description Method that calls the Persistance service.
    *-------------------------------------------------------------------------------
    * @date 2020-10-01
    * @author eduardoefrain.hernandez.contractor@bbva.com
    * @param String analysisId - Analysis Id
    * @return arce.Arc_Gen_ServiceAndSaveResponse - Wrapper that contains the response of the called service and the DML operation
    * @example public static arce.Arc_Gen_ServiceAndSaveResponse callPersistence(String customerId, String analysisId)
    */
    @AuraEnabled
    public static String getRAIPData(String analysisId) {
        final arce.Arc_Gen_ServiceAndSaveResponse response = new arce.Arc_Gen_ServiceAndSaveResponse();
        try {
            final Map<String, String> responseMap = new Map<String, String>();
            final arce__Account_has_Analysis__c aha = arce.Arc_Gen_AccHasAnalysis_Data.accHasAnByArce(new List<String>{analysisId})[0];

            responseMap.put('accHasAnalysisId', aha.Id);
            responseMap.put('analysisId', analysisId);
            responseMap.put('customerId', aha.arce__Customer__c);
            response.serviceMessage = JSON.serialize(responseMap);
            response.saveStatus = 'true';
        } catch (ListException ex) {
            response.saveStatus = FALSE_LITERAL;
            response.serviceMessage = ex.getMessage();
        }
        Return JSON.serialize(response);
    }
    /**
    *-------------------------------------------------------------------------------
    * @description Method that finalizes a prerating.
    *-------------------------------------------------------------------------------
    * @date 2020-05-07
    * @author joseluis.garcia4.contractor@bbva.com
    * @param String arceId - ID of the ARCE record.
    */
    @AuraEnabled
    public static void finalizePrerating(String arceId) {
        try {
            // Finalize RAIP and set discard reason.
            final String discardReason = System.Label.Arc_Gen_FinalizePreratingDiscardReason;
            final arce__Analysis__c analysisToUpdate = new arce__Analysis__c(
                Id = arceId,
                arce__Stage__c = '3',
                arce__wf_status_id__c = '13',
                arce__anlys_wkfl_discard_reason_id__c = discardReason
            );
            arce.Arc_Gen_ArceAnalysis_Data.updateArce(new List<arce__Analysis__c> { analysisToUpdate });

            // Create traceability record.
            final List<arce__Account_has_Analysis__c> lstAccHas = arce.Arc_Gen_AccHasAnalysis_Data.getAccHasAnFromArce(arceId);
            final Map<String, String> auditAttr = Arc_Gen_Traceability.genAuditAttr(System.Label.Arc_Gen_Traceability_13, 'deny', discardReason, lstAccHas[0].Name);
            final Map<String, String> auditWF = new Map<String, String>();
            Arc_Gen_Traceability.saveTrace(arceId, auditAttr, auditWF);
        } catch (DmlException ex) {
            throw new AuraHandledException(System.Label.Arc_Gen_Generic_ErrorSumPersOR);  // NOSONAR
        } catch (Exception ex) {
            throw new AuraHandledException(System.Label.Lc_arce_NewARCE_UnexpectedError);  // NOSONAR
        }
    }
    /**
    *-------------------------------------------------------------------------------
    * @description Gets globalRunWay config (whether or not the globalRunWay step should be displayed).
    *--------------------------------------------------------------------------------
    * @author antonio.munoz.contractor@bbva.com
    * @date 2021-04-27
    * @return the globalRunWay configuration.
    **/
    @AuraEnabled
    public static Arc_Gen_RatingAsIndepProcess_service.GlobalRunWayConfig globalRunWayConfig() {
        final Arc_Gen_RatingAsIndepProcess_service.GlobalRunWayConfig globalRunWayStep = new  Arc_Gen_RatingAsIndepProcess_service.GlobalRunWayConfig();
        // Get whether or not globalRunWay step is displayed from config.
        final List<arce__Arce_Config__mdt> runWayConfig = arce.Arc_Gen_Arceconfigs_locator.getConfigurationInfo('RAIP_EnableGlobalRunway');
        // Get whether or not globalRunWay options from config.
        final List<arce__Arce_Config__mdt> blockLocalConfig = arce.Arc_Gen_Arceconfigs_locator.getConfigurationInfo('RAIP_BlockLocalRedirect');
        Boolean diplayRunWayStep = false;
        Boolean blockLocalOption= false;
        if (!runWayConfig.isEmpty()) {
            diplayRunWayStep = Boolean.valueOf(runWayConfig[0].arce__Value1__c);
        }
        if (!blockLocalConfig.isEmpty()) {
            blockLocalOption = Boolean.valueOf(blockLocalConfig[0].arce__Value1__c);
        }
        globalRunWayStep.gblRunWayEnabled = diplayRunWayStep;
        globalRunWayStep.blockLocalOption = blockLocalOption;
        return globalRunWayStep;
    }
    /**
    *-------------------------------------------------------------------------------
    * @description Gets globalRunWay url endpoints.
    *--------------------------------------------------------------------------------
    * @author antonio.munoz.contractor@bbva.com
    * @date 2021-04-27
    * @return the globalRunWay configuration.
    **/
    @AuraEnabled
    public static Arc_Gen_RatingAsIndepProcess_service.RunWayURLConfig localURLs() {
        //Get local class from config.
        final List<arce__Arce_Config__mdt> urlConfig = arce.Arc_Gen_Arceconfigs_locator.getConfigurationInfo('RAIP_RunWayLocalURLsClass');
        final String localClass = Test.isRunningTest() || urlConfig.isEmpty() ? 'Arc_GBL_RAIPRunWayURLs' : urlConfig[0].arce__Value1__c;
        final Type inter = Type.forName(localClass);
        final Arc_Gen_GetRAIPRunWayURLs_Interface urls = (Arc_Gen_GetRAIPRunWayURLs_Interface) inter.newInstance();
        return urls.urlsConfig();
    }
    /**
    *-------------------------------------------------------------------------------
    * @description Method that call local service risk filter
    *-------------------------------------------------------------------------------
    * @date   2020-12-18
    * @author juanignacio.hita.contractor@bbva.com
    * @param  String customerId
    * @param  String arceId
    * @return Arc_Gen_ServiceAndSaveResponse
    * @example Arc_Gen_ServiceAndSaveResponse callRiskFilter(customerId, arceId);
    */
    @AuraEnabled
    public static arce.Arc_Gen_ServiceAndSaveResponse callRiskFilter(String customerId, String arceId) {
        arce.Arc_Gen_ServiceAndSaveResponse response = new arce.Arc_Gen_ServiceAndSaveResponse();
        try {
          if(getRiskFiltersConfig()) {
            response = Arc_Gen_RiskFilters_Service.calloutService(new Map<String, Object> {'customerId' => customerId, 'analysisId' => arceId});
          }
        } catch (Exception e) {
            throw new AuraHandledException(System.Label.Lc_arce_NewARCE_UnexpectedError);  // NOSONAR
        }
        return response;
    }

    /**
    *---------------------------------------------------------------------------------------------------------------------
    * @Description Verify if the new IRP workflow is activated.
    *---------------------------------------------------------------------------------------------------------------------
    * @Date 15/02/2021
    * @author juanpedro.benito.contractor@bbva.com
    * @return true/false
    * @example isRAIPWfMetadata();
    *---------------------------------------------------------------------------------------------------------------------
    */
    @AuraEnabled
    public static Boolean isRAIPWfMetadata() {
        final List<arce__Arce_Config__mdt> configs = arce.Arc_Gen_Arceconfigs_locator.getConfigurationInfo('RAIPSelectWorkflow');
        Boolean result;

        if (configs.isEmpty()) {
            result = false;
        } else {
            final arce__Arce_Config__mdt config = configs[0];
            result = Boolean.valueOf(config.arce__Value1__c);
        }

        return result;
    }
    /**
    *---------------------------------------------------------------------------------------------------------------------
    * @Description get picklist values.
    *---------------------------------------------------------------------------------------------------------------------
    * @Date 2021-02-15
    * @author juanpedro.benito.contractor@bbva.com
    * @return WfValue
    * @example picklistValueOfSelectWf();
    *---------------------------------------------------------------------------------------------------------------------
    */
    @AuraEnabled
    public static List<WfValue> picklistValueOfSelectWf(String modelSelected, String actualClientNum) {
        final List<WfValue> wfValues = new List<WfValue>();
        final arce.Arc_Gen_Account_Wrapper actualClient = arce.Arc_Gen_Account_Locator.getAccountByAccNumber(new List<String> { actualClientNum }).get(actualClientNum);
        final Boolean groupClient = actualClient.participantType == 'GROUP';

        String optionsAct = 'empty';
        final String configs = arce.Arc_Gen_Arceconfigs_locator.getConfigurationInfo('IrpTypesFilterByModel')[0].arce__Value1__c;
        final Boolean filterOpts = String.isNotBlank(modelSelected) && configs != FALSE_LITERAL;
        if (filterOpts) {
            for (String current : configs.split(';')) {
                if (current.contains(modelSelected)) {
                    optionsAct = current;
                    break;
                }
            }
        }
        optionsAct = groupClient ? optionsAct.remove('ARP') : optionsAct;
        final List<Schema.PicklistEntry> pickvals = arce__Account_has_Analysis__c.arce__IRP_Workflow__c.getDescribe().getPicklistValues();
        for (Schema.PicklistEntry pickval : pickvals) {
            if (optionsAct.contains(String.valueOf(pickval.getValue())) || !filterOpts) {
                wfValues.add(new WfValue(pickval.getValue(), pickval.getLabel()));
            }
        }
        return wfValues;
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Method that create FFSS and asociate to Ahas in new IRP workflow
    *-------------------------------------------------------------------------------
    * @Date 2021-02-24
    * @Author saimassimilianno.jordana.contractor@bbva.com
    * @param String accHasAnalysisId - Standard Id of the current Ahas.
    * @param String analysisId - Standard Id of the current Analysis.
    * @param String flowSelected - Irp flow selected apiname.
    * @param String rarRatingTool - RarRatingTool selected on CRP flow.
    * @example newFFSSWAhas(accHasAnalysisId)
    *-------------------------------------------------------------------------------
    */
    @AuraEnabled
    public static void newFFSSWAhas(String accHasAnalysisId, String analysisId, String flowSelected, String rarRatingTool) {
        try {
            Arc_Gen_RatingAsIndepProcess_service.newFFSSWAhas(accHasAnalysisId, analysisId, flowSelected, rarRatingTool);
        } catch (Exception e) {
            throw new AuraHandledException(System.Label.Lc_arce_NewARCE_UnexpectedError);  // NOSONAR
        }

    }

    /**
    *-------------------------------------------------------------------------------
    * @Description Method that create FFSS and asociate to Ahas in new IRP workflow
    *-------------------------------------------------------------------------------
    * @Date 2021-06-09
    * @Author saimassimilianno.jordana.contractor@bbva.com
    * @param String accHasAnalysisId - Standard Id of the current ahas.
    * @param String flowSelected - Name of flow selected.
    * @example irpWfUpdt(accHasAnalysisId,flowSelected)
    *-------------------------------------------------------------------------------
    */
    @AuraEnabled
    public static void irpWfUpdt(String accHasAnalysisId, String flowSelected) {
        try {
            Arc_Gen_RatingAsIndepProcess_service.irpWfUpdt(accHasAnalysisId, flowSelected);
        } catch (Exception e) {
            throw new AuraHandledException(System.Label.Lc_arce_NewARCE_UnexpectedError);  // NOSONAR
        }

    }

    /**
    *---------------------------------------------------------------------------------------------------------------------
    * @Description Verify if the new SelectModel 2012 is activated and get options from it.
    *---------------------------------------------------------------------------------------------------------------------
    * @Date 01/06/2021
    * @author saimasimilianno.jordana.contractor@bbva.com
    * @return List<WfValue>
    * @example model2012Active();
    *---------------------------------------------------------------------------------------------------------------------
    */
    @AuraEnabled
    public static List<WfValue> model2012Active() {
        final List<WfValue> wfValues = new List<WfValue>();
        final List<arce__Arce_Config__mdt> configs = arce.Arc_Gen_Arceconfigs_locator.getConfigurationInfo('Model2012IRP');

        if (!configs.isEmpty() && configs[0].arce__Value1__c != FALSE_LITERAL) {
            final String configWf = configs[0].arce__Value1__c;
            for (String current : configWf.split(';')) {
                final List<String> keyValue = current.split(':');
                wfValues.add(new WfValue(keyValue[0], keyValue[1]));
            }
        }

        return wfValues;
    }

    /**
    *---------------------------------------------------------------------------------------------------------------------
    * @Description Check in RatingTypeByModel arceconfig which options are available for rating type.
    *---------------------------------------------------------------------------------------------------------------------
    * @Date 20/09/2021
    * @author saimasimilianno.jordana.contractor@bbva.com
    * @return List<WfValue>
    * @example checkRatingType(analysisId, modelSelec);
    *---------------------------------------------------------------------------------------------------------------------
    */
    @AuraEnabled
    public static List<WfValue> checkRatingType(String analysisId, String modelSelec, Boolean eeffButton) {
        final List<WfValue> wfValues = new List<WfValue>();
        final List<arce__Arce_Config__mdt> configs = arce.Arc_Gen_Arceconfigs_locator.getConfigurationInfo('RatingTypeByModel');
        final String modelToVerify = eeffButton ? arce.Arc_Gen_AccHasAnalysis_Data.getAccHasAnalysis(new List<String>{(String)analysisId})[0].arce__RAR_rating_tool_id__c : modelSelec;

        if (!configs.isEmpty() && configs[0].arce__Value1__c != FALSE_LITERAL && String.isNotBlank(modelToVerify)) {
            final String configWf = configs[0].arce__Value1__c;
            for (String current : configWf.split(';')) {
                final List<String> keyValue = current.split(':');

                if (modelToVerify.containsIgnoreCase(keyValue[0])) {
                    //final List<String> ratings = keyValue.split(',');
                    addToWfValue(wfValues, keyValue[1].split(','));
                }
                //wfValues.add(new WfValue(keyValue[0], keyValue[1]));
            }
        } else {
            wfValues.add(new WfValue(PRERATING_VALUE, PRERATING_LABEL));
            wfValues.add(new WfValue(RATING_LABEL, RATING_LABEL));
        }

        return wfValues;
    }

    /**
    *---------------------------------------------------------------------------------------------------------------------
    * @Description Helper method for checkRatingType.
    *---------------------------------------------------------------------------------------------------------------------
    * @Date 20/09/2021
    * @author saimasimilianno.jordana.contractor@bbva.com
    * @return List<WfValue>
    * @example checkRatingType(wfValues, ratings);
    *---------------------------------------------------------------------------------------------------------------------
    */
    @AuraEnabled
    public static void addToWfValue(List<WfValue> wfValues, List<String> ratings) {
        for (String current : ratings) {
            if(current.equalsIgnoreCase(RATING_LABEL)) {
                wfValues.add(new WfValue(RATING_LABEL, RATING_LABEL));
            } else if (current.equalsIgnoreCase(PRERATING_VALUE)) {
                wfValues.add(new WfValue(PRERATING_VALUE, PRERATING_LABEL));
            }
        }
    }
    /**
    *---------------------------------------------------------------------------------------------------------------------
    * @Description Method to retrieve Arce_config for riskFilters.
    *---------------------------------------------------------------------------------------------------------------------
    * @Date 28/10/2021
    * @author amunguia.contractor@bbva.com
    * @return Boolean
    * @example getRiskFiltersConfig();
    *---------------------------------------------------------------------------------------------------------------------
    */
    private static Boolean getRiskFiltersConfig() {
      final List<arce__Arce_Config__mdt> configs = arce.Arc_Gen_Arceconfigs_locator.getConfigurationInfo('RAIPRiskFilter');
      Boolean result;

      if (configs.isEmpty()) {
          result = false;
      } else {
          final arce__Arce_Config__mdt config = configs[0];
          result = Boolean.valueOf(config.arce__Value1__c);
      }

      return result;
  }
}