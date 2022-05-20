/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_ActionsPersistence_Service
* @Author   José Luis García    joseluis.garcia4.contractor@bbva.com
* @Date     Created: 2021-02-11
* @Group    ARCE
* ------------------------------------------------------------------------------------------------
* @Description Implements the call to the actions service to persist actions performed by the user
* in an ARCE analysis or IRP.
* ------------------------------------------------------------------------------------------------
* @Changes
*
* |2021-02-11 joseluis.garcia4.contractor@bbva.com
*             Class creation.
* |2021-11-11 juanignacio.htia.contractor@bbva.com
*             Refactoring account has analysis lists and In_review
* -----------------------------------------------------------------------------------------------
*/
global class Arc_Gen_ActionsPersistence_Service {
    /**
    * @Description: Literal for the "Propose" action.
    */
    global static final String ACTION_PROPOSE = 'PROPOSE';
    /**
    * @Description: Literal for the "Schedule" action.
    */
    global static final String ACTION_SCHEDULE = 'SCHEDULE';
    /**
    * @Description: Literal for the "Discard" action.
    */
    global static final String ACTION_DISCARD = 'DISCARD';
    /**
    * @Description: Literal for the "Return" action.
    */
    global static final String ACTION_RETURN = 'RETURN';
    /**
    * @Description: Literal for the "Sanction" action.
    */
    global static final String ACTION_SANCTION = 'SANCTION';

    /**
    * @Description: Name of the actions persistence service.
    */
    private static final String SERVICE_NAME = 'actions';
    /**
    * @Description: List of valid actions to persist.
    */
    private static final List<String> VALID_ACTIONS = new List<String> { ACTION_PROPOSE, ACTION_SCHEDULE, ACTION_DISCARD, ACTION_RETURN, ACTION_SANCTION };

    /**
    *-------------------------------------------------------------------------------
    * @description Exception that signal invalid parameters.
    --------------------------------------------------------------------------------
    * @author joseluis.garcia4.contractor@bbva.com
    * @date 11/02/2021
    * @example InvalidParametersException()
    **/
    global class InvalidParametersException extends Exception {}

    /**
    *-------------------------------------------------------------------------------
    * @description Exception that signal an error during the service call.
    --------------------------------------------------------------------------------
    * @author joseluis.garcia4.contractor@bbva.com
    * @date 11/02/2021
    * @example ServiceCallException()
    **/
    global class ServiceCallException extends Exception {}

    /**
    *-------------------------------------------------------------------------------
    * @description Empty constructor to avoid sonar major issue.
    --------------------------------------------------------------------------------
    * @author joseluis.garcia4.contractor@bbva.com
    * @date 17/02/2021
    **/
    @TestVisible
    private Arc_Gen_ActionsPersistence_Service() {
    }

    /**
    *-------------------------------------------------------------------------------
    * @description Calls action persistence service to persist an audit of an action
    * performed in a analysis or IRP
    --------------------------------------------------------------------------------
    * @author joseluis.garcia4.contractor@bbva.com
    * @date 17/02/2021
    * @param analysisId ID of the ARCE record
    * @param action Action to persist
    **/
    global static void persistArceAction(Id analysisId, String action) {
        // Check that action is one of the supported actions of the service.
        if (!VALID_ACTIONS.contains(action)) {
            throw new InvalidParametersException('An invalid action was provided.');
        }

        // Get account_has_analysis of group/orphan.
        final List<arce__Account_has_Analysis__c> ahaList = Arc_Gen_AccHasAnalysis_Data.accHasAnByArce(new List<String> { analysisId });
        final Map<String, arce__Account_has_Analysis__c> mapAccHas = getAhaFiltered(ahaList);
        final arce__Account_has_Analysis__c mainAha = mapAccHas.values()[0];

        // Check if action persistence is enabled for the type of analysis.
        final String subprocessType = mainAha.arce__Analysis__r.arce__anlys_wkfl_sub_process_type__c;
        final String arceConfigName = subprocessType == Arc_Gen_Constants.SUBPROCESS_RATING ? 'RAIPEnablePersistActions' : 'AnalysisEnablePersistActions';
        final List<arce__Arce_Config__mdt> config = Arc_Gen_Arceconfigs_locator.getConfigurationInfo(arceConfigName);

        if (!config.isEmpty() && config[0].arce__Value1__c == 'true') {
            // Get user information.
            final Arc_Gen_User_Wrapper userWrapper = Arc_Gen_User_Locator.getUserInfo(System.UserInfo.getUserId());

            // Get rating data.
            final Map<Id, arce__rating__c> ratingsByAhaId = Arc_Gen_ActionsPersistence_Data.getRatingsByAhaId(mapAccHas.values());

            // Get customer information.
            final List<String> customerIds = new List<String>(mapAccHas.keySet());
            final Map<Id, Arc_Gen_Account_Wrapper> accWrappersById = Arc_Gen_Account_Locator.getAccountInfoById(customerIds);

            // Populate parameters.
            final String riskAssessmentId = mainAha.Name;
            final String participantId = Arc_Gen_CallEncryptService.getEncryptedClient(accWrappersById.get(mainAha.arce__Customer__c).accNumber);
            final Map<String, Object> jsonInput = new Map<String, Object>();
            jsonInput.put('actionType', new Map<String, String> { 'id' => action });
            jsonInput.put('businessAgent', new Map<String, String> { 'id' => userWrapper.businessAgentId });
            jsonInput.put('economicGroupParticipants', buildEconomicGroupParts(mapAccHas.values(), ratingsByAhaId, accWrappersById));
            final String jsonInputStr = JSON.serialize(jsonInput);

            // Call service.
            final Map<String, String> serviceParameters = new Map<String, String>();
            serviceParameters.put('risk-assessment-id', riskAssessmentId);
            serviceParameters.put('participant-id', participantId);
            serviceParameters.put('JSONIN', jsonInputStr);

            final HttpResponse response = Arc_Gen_getIASOResponse.getServiceResponse(SERVICE_NAME, JSON.serialize(serviceParameters));
            if (response.getStatusCode() != 200 && response.getStatusCode() != 201) {
                throw new ServiceCallException(System.Label.Arc_Gen_DepServicePersistenceError + ' (Service returned code ' + response.getStatusCode() + ')');
            }
        }
    }

    /**
    *-------------------------------------------------------------------------------
    * @description Builds the economicGroupParticipants object to send to the service.
    *-------------------------------------------------------------------------------
    * @author joseluis.garcia4.contractor@bbva.com
    * @date 17/02/2021
    * @param ahaList List of arce__Account_has_Analysis__c of the ARCE.
    * @param ratingsByAhaId Map of rating records by the AHA Id.
    * @param accWrappersById Map of account wrappers by account id.
    **/
    private static List<Object> buildEconomicGroupParts(List<arce__Account_has_Analysis__c> ahaList,
            Map<Id, arce__rating__c> ratingsByAhaId, Map<Id, Arc_Gen_Account_Wrapper> accWrappersById) {
        final List<Object> listDataParts = new List<Object>();
        for (arce__Account_has_Analysis__c aha : ahaList) {
            final Map<String, Object> partData = new Map<String, Object>();
            partData.put('id', Arc_Gen_CallEncryptService.getEncryptedClient(accWrappersById.get(aha.arce__Customer__c).accNumber));
            partData.put('riskAssessment', new Map<String, Object> { 'id' => aha.Name });

            final Boolean hasRating = ratingsByAhaId.containsKey(aha.Id);
            if (hasRating) {
                final arce__rating__c ratingData = ratingsByAhaId.get(aha.Id);
                if (ratingData.arce__status_type__c == Arc_Gen_Rating_data.STATUS_CALCULATED || ratingData.arce__status_type__c == Arc_Gen_Rating_data.STATUS_VALIDATE) {
                    partData.put('rating', new Map<String, String> { 'id' => ratingData.arce__rating_id__c });
                }
            }
            listDataParts.add(partData);
        }
        return listDataParts;
    }

    /**
    *-------------------------------------------------------------------------------
    * @description Gets the main AHA of the analysis. This AHA is the one used to build
    * the resource URI for the service call.
    *-------------------------------------------------------------------------------
    * @author joseluis.garcia4.contractor@bbva.com
    * @date 17/02/2021
    * @param ahaList List of arce__Account_has_Analysis__c of the ARCE.
    * @return Map<String, arce__Account_has_Analysis__c>
    **/
    private static Map<String, arce__Account_has_Analysis__c> getAhaFiltered(List<arce__Account_has_Analysis__c> ahaList) {
        final Map<String, arce__Account_has_Analysis__c> mapAccAhaSubsi = new Map<String, arce__Account_has_Analysis__c>();
        final List<arce__Account_has_Analysis__c> lstAha = new List<arce__Account_has_Analysis__c>();
        arce__Account_has_Analysis__c mainAha;
        for (arce__Account_has_Analysis__c aha : ahaList) {
            if (aha.arce__group_asset_header_type__c == Arc_Gen_Constants.GROUP_ASSET_HEADER_TYPE_HEADER ||
                    aha.arce__Analysis__r.arce__analysis_customer_relation_type__c == Arc_Gen_Constants.CUSTOMER_RELATION_ORPHAN ||
                    aha.arce__Analysis__r.arce__anlys_wkfl_sub_process_type__c == Arc_Gen_Constants.SUBPROCESS_RATING) {
                mainAha = aha;
            } else if(aha.arce__InReview__c) {
                mapAccAhaSubsi.put(aha.arce__Customer__c, aha);
            }
        }
        final Map<String, arce__Account_has_Analysis__c> mapAccAha = new Map<String, arce__Account_has_Analysis__c> {
            mainAha.arce__Customer__c => mainAha
        };
        mapAccAha.putAll(mapAccAhaSubsi);
        return mapAccAha;
    }
}