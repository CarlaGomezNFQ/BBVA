/*------------------------------------------------------------------
*Author:        ARCE Team
*Project:      	ARCE - BBVA Bancomer
*Description:   Service class to get and process FinancialStatemnt FROM ASO
Controller class: Arc_Gen_ModalFinanStatem
Data class: Arc_Gen_Balance_Tables_data
*_______________________________________________________________________________________
* @Changes
*Version    Date           Author                                       Description
*1.0        11/04/2019     ARCE TEAM   							        Creación.
*1.1		24/04/2019	   diego.miguel.contractor@bbva.com		        Modified ratios function to parse Json response properly
*1.2		25/04/2019	   diego.miguel.contractor@bbva.com 	        Modified ratios and eeff functions to handle error messages and display to users
*1.3		17/05/2019	   diego.miguel.contractor@bbva.com 	        Modify function to handle 3 calls to WS
*1.4		29/05/2019	   eduardoefrain.hernandez.contractor@bbva.com 	Modify function buildTables to fix the errors managing
*1.5		17/07/2019	   ricardo.almanza.contractor@bbva.com      	Modify method listToInsertMethod to set arce__table_content_year__c adding full
*                                                                       date and arce__ffss_certification_type__c
*1.6		20/09/2019	   eduardoefrain.hernandez.contractor@bbva.com 	Fix managing error incidence
*1.7		26/09/2019	   javier.soto.carrascosa@bbva.com 	            Remove mock
*1.8        23/10/2019     mariohumberto.ramirez.contractor@bbva.com    Added new method updateEEFFtoShow
*1.8.1      02/12/2019     german.sanchez.perez.contractor@bbva.com
*                          franciscojavier.bueno@bbva.com               Api names modified with the correct name on business glossary
*1.8.2      06/12/2019     jhovanny.delacruz.cruz@bbva.com              Encryption funcionality enabled
*1.9        19/12/2019     mariohumberto.ramirez.contractor@bbva.com    Modified funcionality for HU "Aprovisionamiento numero de empleados en Front"
*1.10       30/01/2020     juanmanuel.perez.ortiz.contractor@bbva.com   Add missing custom labels
*1.11       20/02/2020     juanmanuel.perez.ortiz.contractor@bbva.com   Fix incidence, geography data was deleted when loading another financial statement
*1.12       09/03/2020     eduardoefrain.hernandez.contractor@bbva.com  adedd methods because of Indepentent Rating (RAIP)
*1.13       23/03/2020     eduardoefrain.hernandez.contractor@bbva.com  Reorder validate actions in buildTables method
*1.14       01/04/2020     juanmanuel.perez.ortiz.contractor@bbva.com   Modify method 'buildTables' to convert eventType in dynamic value
*1.15       26/03/2020     juanignacio.hita.contractor@bbva.com         Refactoring
*1.16       17/04/2020     mariohumberto.ramirez.contractor@bbva.com    Add new logic in order to mark the ratios of the valid FS and previous year FS inside the methods callProcessData and listToInsertMethod
*1.16       26/03/2020     joseluis.garcia4.contractor@bbva.com         Shows the correct error when ratios engine call fails.
*1.17       26/05/2020     joseluis.garcia4.contractor@bbva.com         FFSS test call + Service distinction for group and client.
*1.18       08/06/2020     mariohumberto.ramirez.contractor@bbva.com    Corrected error message in the modal when valid financial statements are not selected
*1.19       15/06/2020     juanignacio.hita.contractor@bbva.com         Add non mandatory percentage and unexisting balances getPercentFromMap method
*1.20       25/06/2020     mariohumberto.ramirez.contractor@bbva.com    Fix cpu limit apex error
*1.21       25/06/2020     joseluis.garcia4.contractor@bbva.com         Clear Leveraged Test results when financial statements change.
*1.22       07/07/2020     juanignacio.hita.contractor@bbva.com         Added validation before call to rating engine and translatePicklistValues method
*1.23       08/07/2020     juanignacio.hita.contractor@bbva.com         Add submit_type field in the ffss table header and abbreviate the types
*1.24       24/07/2020     joseluis.garcia4.contractor@bbva.com         Use field label for certification type of FFSS.
*1.25       15/09/2020     joseluis.garcia4.contractor@bbva.com         Performance improvement on listToInsertMethod method.
*1.26       23/09/2020     saimassimilianno.jordana.contractor@bbva.com Added arce. namespace to all classes that are now in
*                                                                        the arce-dependencies package
*1.27       29/10/2020     joseluis.garcia4.contractor@bbva.com         If a data collection element is not found in the ratios response, don't log the exception.
*1.28       04/11/2020     joseluis.garcia4.contractor@bbva.com         Include new parameter participantType in ratios request.
*1.29       23/12/2020     juanignacio.hita.contractor@bbva.com         Changes the mapping of the risk AssessmentId parameter of the service
*1.30       05/01/2021     joseluis.garcia4.contractor@bbva.com         Performance improvement on listToInsertMethod method (include improvements from R3).
*1.31       29/01/2021     joseluis.garcia4.contractor@bbva.com         Force re-validation when financial statements change.
*1.32       03/03/2021     ivan.cons@bbva.com                           Overloaded processRatioDataValues to accept API update with
                                                                        specificRatiosMagnitudes param. If this param comes, it will ignore others
*1.33       15/03/2021     ivan.cons@bbva.com                           When method is called from IPR flow in financial risk tab, EEFF is not updated.
*1.33       21/04/2021     ivan.cons@bbva.com                           Gets column field from arceConfig to improve tables flexibility
*1.34       30/04/2021     otiliaramona.veres.contractor@bbva.com       Added an empty constructor method.
*1.35       04/05/2021     otiliaramona.veres.contractor@bbva.com       Added annotation '@testVIsible' to the empty constructor method.
*1.36       06/05/2021     otiliaramona.veres.contractor@bbva.com       Cleared unsued variable 'messageReturn'  of the method 'callProcessData'.
*1.37       23/08/2021     amunguia.contractor@bbva.com                 Multiple ratios can be created in different positions
-----------------------------------------------------------------------------------------*/
@SuppressWarnings('PMD.ExcessivePublicCount')
public with sharing class Arc_Gen_Balance_Tables_service {
    /*
    * @Description map with the picklist values and labels of arce__collection_table__c
    */
    static final Map<String,String> COLLECTION_MAP = arce.Arc_Gen_GenericUtilities.getMapLabelFromValue('arce__Table_Content_per_Analysis__c','arce__collection_table__c');
    /*
    * @Description Group participant type.
    */
    private static final String PART_TYPE_GROUP = 'GROUP';
    /*
    * @Description Name of the financial statements service for clients.
    */
    private static final String FFSS_SERVICE_NAME_CLIENT = 'financialStatements';
    /*
    * @Description Name of the financial statements service for groups.
    */
    private static final String FFSS_SERVICE_NAME_GROUP = 'financialStatementsGroup';
    /**
    *-------------------------------------------------------------------------------
    * @description Empty constructor method
    *-------------------------------------------------------------------------------
    *@author otiliaramona.veres.contractor@bbva.com
    *@Date   Created:2021-04-30
    */
    @TestVisible
    private Arc_Gen_Balance_Tables_service() { }
    /**
    *-------------------------------------------------------------------------------
    * @description Enum that lists the possible reasons there are no FFSS for a
    * given participant.
    *-------------------------------------------------------------------------------
    */
    public enum NoFinancialStatementReason { NO_FFSS_EMPTY_LIST, NO_FFSS_NO_SERVICE }

    /**
    *-------------------------------------------------------------------------------
    * @description Exception used to signal the lack of financial statement data, either because
    * there is no available service for the group or because the service did not return
    * any financial statements.
    *-------------------------------------------------------------------------------
    * @author   José Luis García    joseluis.garcia4.contractor@bbva.com
    * @date     25/05/2020
    */
    public class NoFinancialStatementDataException extends Exception {
        /**
        * @Description The reason for the exception.
        */
        public NoFinancialStatementReason reason { get; set; }

        /**
        * @description Constructor.
        */
        public NoFinancialStatementDataException(NoFinancialStatementReason reason) {
            this.reason = reason;
        }
    }

    /**
    *-------------------------------------------------------------------------------
    * @description class used to handle aso responses in this wrapper
    *--------------------------------------------------------------------------------
    * @author   ARCE TEAM
    * @date     11/04/2019
    * @param null
    * @return null
    * @example public class RatiosAndRatingResponse {
    **/
    public class RatiosAndRatingResponse {
        /*
        * @Description String with the ratiosStatus
        */
        @AuraEnabled public String ratiosStatus {get;set;}
        /*
        * @Description String with the ratingValidFFSS
        */
        @AuraEnabled public String ratingValidFFSS {get;set;}
        /*
        * @Description String with the ratingValidatedFS
        */
        @AuraEnabled public String ratingValidatedFS {get;set;}
        /*
        * @Description String with the ratiosErrorMsg
        */
        @AuraEnabled public String ratiosErrorMsg {get;set;}
        /*
        * @Description String with the Id of the Financial Statement
        */
        @AuraEnabled public String fsServiceId {get;set;}
    }
    /**
    *-------------------------------------------------------------------------------
    * @description class used to provide callRatiosEngine method the needed arguments
    * to call the ratios engine
    *--------------------------------------------------------------------------------
    * @author   ARCE TEAM
    * @date     09/03/2020
    **/
    class RatiosServiceParameters {
        /*
        * @Description Federation Id.
        */
        public String federationId { get; set; }
        /*
        * @Description Customer Id.
        */
        public String customerId { get; set; }
        /*
        * @Description Customer number.
        */
        public String customerNumber { get; set; }
        /*
        * @Description Id of the analysis in the service.
        */
        public String analysisIdToSend { get; set; }
        /*
        * @Description Event type.
        */
        public String eventType { get; set; }
        /*
        * @Description Participant type (group or subsidiary).
        */
        public String participantType { get; set; }
    }
    /**
    *-------------------------------------------------------------------------------
    * @description class used to retrieve information generated by the
    * callRatiosEngine method.
    *--------------------------------------------------------------------------------
    * @author   ARCE TEAM
    * @date     09/03/2020
    **/
    class RatiosResponse {
        /*
        * @Description Status code returned by the service.
        */
        public Integer serviceStatusCode { get; set; }
        /*
        * @Description FFSS that have been persisted successfully.
        */
        public List<arce__Financial_Statements__c> ffssToProcess { get; set; }
        /*
        * @Description HTTP responses from the service.
        */
        public List<HttpResponse> validHttpResponses { get; set; }
        /*
        * @Description Processed FFSS that are valid for rating.
        */
        public List<arce__Financial_Statements__c> validFFSS { get; set; }
        /*
        * @Description Error messages from the service.
        */
        public String globalResponseErrorMessage { get; set; }
        /*
        * @Description Indicates whether there is a valid FFSS for rating.
        */
        public Boolean atLeastOneValid { get { return !validFFSS.isEmpty(); } set; }
        /*
        * @Description RatiosResponse
        */
        public RatiosResponse() {
            this.ffssToProcess = new List<arce__Financial_Statements__c>();
            this.validHttpResponses = new List<HttpResponse>();
            this.validFFSS = new List<arce__Financial_Statements__c>();
        }
    }

    /**
    *-------------------------------------------------------------------------------
    * @description Performs a test call to the correct financial statements service to check
    * that (1) the service to call is available and (2) the service returns any financial
    * statement. This method is to be called before the RAIP is created so the creation process
    * is prevented if no financial statements can be retrieved.
    *--------------------------------------------------------------------------------
    * @author  joseluis.garcia4.contractor@bbva.com
    * @date     25/05/2020
    * @param accountNumber account number of the account to perform the test for.
    * @return arce.Arc_Gen_ServiceAndSaveResponse
    * 		if OK serviceCode = 200, other case controller will format serviceCode and
    * 		if not OK serviceCode = 'Error - MessageError' to be displayed to user
    * 		Exceptions calling WS will return 'Error calling service'
    **/
    public static arce.Arc_Gen_ServiceAndSaveResponse financialStatementsTestCall(String accountNumber) {
        final arce.Arc_Gen_ServiceAndSaveResponse response = new arce.Arc_Gen_ServiceAndSaveResponse();

        try {
            final arce.Arc_Gen_Account_Wrapper accountInfo = arce.Arc_Gen_Account_Locator.getAccountByAccNumber(new List<String> { accountNumber }).get(accountNumber);
            final String customerNumber = arce.Arc_Gen_CallEncryptService.getEncryptedClient(accountNumber);

            // Get financial statements service name depending on whether the account is a group or a client.
            final String ffssServiceName = getServiceNameByParticipantType(accountInfo.participantType);

            // Call service
            final arce.Arc_Gen_getIASOResponse.serviceResponse iasoResp = arce.Arc_Gen_getIASOResponse.calloutIASO(ffssServiceName,'{"customerId":"'+customerNumber+'"}');
            response.serviceCode = iasoResp.serviceCode;
            response.serviceMessage = iasoResp.serviceMessage;

            // Check if there is any FFSS in the response.
            final List<Object> listServiceResp = (List<Object>)iasoResp.serviceResponse.get('data');
            if (listServiceResp.isEmpty()) {
                throw new NoFinancialStatementDataException(NoFinancialStatementReason.NO_FFSS_EMPTY_LIST);
            }
        } catch (NoFinancialStatementDataException ex) {
            String message = System.Label.Arc_Gen_ErrorService;
            if (ex.reason == NoFinancialStatementReason.NO_FFSS_EMPTY_LIST) {
                message = System.Label.Arc_Gen_NoReturnedFFSS;
            } else if (ex.reason == NoFinancialStatementReason.NO_FFSS_NO_SERVICE) {
                message = System.Label.Lc_arce_RAIP_CannotExecuteGroup;
            }
            response.serviceCode = '404';
            response.serviceMessage = message;
        } catch (Exception ex) {
            response.serviceCode = response.serviceCode == null || response.serviceCode == '200' ? '500' : response.serviceCode;
        }

        return response;
    }
    /**
    *-------------------------------------------------------------------------------
    * @description call financialStatement aso service and insert into salesforce.
    * 		This method will only get the new FFSS, old FFSS will not be updated
    *--------------------------------------------------------------------------------
    * @author  ARCE TEAM
    * @date     11/04/2019
    * @param analysisId recordId of the account_has_analysis.
    * @param translatePicklistValues modifies values of picklist fields on returned records
    *   so they contain picklist value labels instead of picklist values.
    * @return arce.Arc_Gen_ServiceAndSaveResponse
    * 		if OK serviceCode = 200, other case controller will format serviceCode and
    * 		if not OK serviceCode = 'Error - MessageError' to be displayed to user
    * 		Exceptions calling WS will return 'Error calling service'
    * @example public static arce.Arc_Gen_ServiceAndSaveResponse setupFFSSHeaders(String analysisId, Boolean translatePicklistValues) {
    **/
    public static List<arce__Financial_Statements__c> setupFFSSHeaders(String analysisId, Boolean translatePicklistValues) {
        final arce.Arc_Gen_CustomServiceMessages serviceMessage = new arce.Arc_Gen_CustomServiceMessages();
        final Arc_Gen_Balance_Tables_data locator = new Arc_Gen_Balance_Tables_data();
        final arce.Arc_Gen_Account_Wrapper accountInfo = locator.getCustomerData(analysisId);
        final String customerNumber = arce.Arc_Gen_CallEncryptService.getEncryptedClient(accountInfo.accNumber);

        // Get financial statements service name depending on whether the account is a group or a client.
        final String ffssServiceName = getServiceNameByParticipantType(accountInfo.participantType);

        // Call Financial Statements service to get FS data.
        final arce.Arc_Gen_getIASOResponse.serviceResponse response = arce.Arc_Gen_getIASOResponse.calloutIASO(ffssServiceName,'{"customerId":"'+customerNumber+'"}');
        if (response.serviceCode != String.valueOf(serviceMessage.CODE_200)) {
            throw new AuraHandledException(String.format('{0} - {1}', new List<String> { response.serviceCode, response.serviceMessage })); // NOSONAR
        }

        return Arc_Gen_Balance_Tables_helper.processFinancialStatements(analysisId, response, translatePicklistValues, accountInfo);
    }
    /**
    *-------------------------------------------------------------------------------
    * @description This method filters the list of provided FFSS by returning only
    * the ones whose Financial Statement ID matches any from the list of IDs provided as
    * argument.
    *--------------------------------------------------------------------------------
    * @author  ARCE TEAM
    * @date    04/03/2019
    * @param ffssList list to filter
    * @param ffssServiceIds IDs of the FFSS that need to be filtered.
    * @return List<arce__Financial_Statements__c> the list of FFSS whose service IDs match any of
    **/
    public static List<arce__Financial_Statements__c> filterFFSSByServiceId(List<arce__Financial_Statements__c> ffssList, List<String> ffssServiceIds) {
        final List<arce__Financial_Statements__c> filteredFfssList = new List<arce__Financial_Statements__c>();
        for (arce__Financial_Statements__c ffss : ffssList) {
            if (ffssServiceIds.contains(ffss.arce__financial_statement_id__c)) {
                filteredFfssList.add(ffss);
            }
        }

        return filteredFfssList;
    }
    /**
    *-------------------------------------------------------------------------------
    * @description call ratiosEngine aso service and insert into salesforce.
    *       Previous ratios will be deleted FROM system
    *       Only the most recent FFSS will be sent (this may change in the future)
    *--------------------------------------------------------------------------------
    * @author  ARCE TEAM
    * @date     11/04/2019
    * @param recordId recordId of the account_has_analysis
    * @param selectedFfssList list of financial statements
    * @param isRAIP boolean if is RAIP
    * @return RatiosAndRatingResponse
    *       if OK serviceCode = 200,
    *           ratiosErrorMsg will cointain error messages formated to be displayed
    *       if not OK serviceCode = 'Error - MessageError' to be displayed to user
    *       Exceptions calling WS will return 'Error calling service'
    * @example public static RatiosAndRatingResponse buildTables(String recordId, List<arce__Financial_Statements__c> selectedFfssList, Boolean isRAIP) {
    **/
    public static RatiosAndRatingResponse buildTables(String recordId, List<arce__Financial_Statements__c> selectedFfssList, Boolean isRAIP, Boolean isFinancialRAIP) {
        List<arce__Table_Content_per_Analysis__c> listToClean = new List<arce__Table_Content_per_Analysis__c>();
        Arc_Gen_Balance_Tables_data dataAccess = new Arc_Gen_Balance_Tables_data();

        List<String> filterValues = new List<String>{'02','03','04','07'};

        for (arce__Table_Content_per_Analysis__c recordToClean : dataAccess.getRecordsToClean(recordId, filterValues)) {
            listToClean.add(recordToClean);
        }

        // Get Account_has_analysis__c record.
        List<arce__Account_has_Analysis__c> analyzedClient = dataAccess.getAccountHasAnalysis(recordId);
        String subprocessType = analyzedClient[0].arce__Analysis__r.arce__anlys_wkfl_sub_process_type__c;


        // Get parameters to be sent to the service.
        final arce.Arc_Gen_User_Wrapper wrapperUser = arce.Arc_Gen_User_Locator.getUserInfo(UserInfo.getUserId());

        final RatiosServiceParameters ratiosParams = new RatiosServiceParameters();
        ratiosParams.federationId = wrapperUser.businessAgentId;
        ratiosParams.customerId = dataAccess.getCustomerData(recordId).accNumber;
        ratiosParams.customerNumber = arce.Arc_Gen_CallEncryptService.getEncryptedClient(ratiosParams.customerId);
        ratiosParams.analysisIdToSend = dataAccess.getAccountHasAnalysis(recordId)[0].Name;
        ratiosParams.eventType = arce.Arc_Gen_GenericUtilities.getEventTypeValue(subprocessType);
        ratiosParams.participantType = getParticipantType(analyzedClient[0].arce__group_asset_header_type__c);

        // Call ratios engine for each selected financial statement.
        final RatiosResponse response = callRatiosEngine(selectedFfssList, ratiosParams, isRAIP);

        // Sync financial statements:
        // - Delete existing FFSS that were not selected
        // - Update existing FFSS that were selected
        // - Insert new FFSS
        Boolean ffssChanged = false;
        if(!isFinancialRAIP) {
            ffssChanged = dataAccess.persistProcessedFfss(analyzedClient[0].Id, response.ffssToProcess);
        }
        // Logical validation of the valid financial statements to save rating
        final arce__Financial_Statements__c finStateValidObj = response.validFFSS.isEmpty() ? new arce__Financial_Statements__c() : Arc_Gen_Balance_Tables_helper.validationFFSSRating(analyzedClient[0], response.validFFSS);
        // Generates arce__Table_Content_per_Analysis__c records from engine response.
        final Arc_Gen_Balance_Tables_data.SaveResult saveRes = callProcessData(response.ffssToProcess, response.validHttpResponses, recordId, finStateValidObj);
        final RatiosAndRatingResponse resp = setResults(saveRes, response.atLeastOneValid, response.globalResponseErrorMessage, response.serviceStatusCode);

        // Set "new FFSS" indicator on Account_has_analysis__c record. This indicator
        // means the rating engine has not been called yet with this subset of FFSS.
        if(isFinancialRAIP) {
            resp.fsServiceId = finStateValidObj.arce__financial_statement_id__c;
        } else {
            analyzedClient[0].arce__newFFSS_ind__c = 'YES';
            analyzedClient[0].arce__ffss_for_rating_id__c = null;     // NOSONAR
            dataAccess.updateRecords(analyzedClient);

            // Reinitialize Leveraged Test fields.
            Arc_Gen_TestLeverage_service.clearTestLeveragedResults(recordId);

            // Choose a valid financial statement to use for rating (if any).
            Arc_Gen_Balance_Tables_helper.saveRatingFfss(analyzedClient[0], response.validFFSS, resp, finStateValidObj);
        }

        // [DMT] We are deleting previosList even if the WS fail (if there were any info, user will lose it until WS problem get solved)
        if (listToClean.size() > 0) {
            dataAccess.deletePrevious(listToClean);
        }

        // If FFSS have changed, force the user to validate the AHAs again.
        if (ffssChanged) {
            final arce__Analysis__c updatedArce = new arce__Analysis__c(Id = analyzedClient[0].arce__Analysis__c, arce__Temporal_status__c = false);
            arce.Arc_Gen_ArceAnalysis_Data.updateArce(new List<arce__Analysis__c> { updatedArce });
        }

        return resp;
    }
    /**
    *-------------------------------------------------------------------------------
    * @description Gets value for participant type field.
    *--------------------------------------------------------------------------------
    * @author  joseluis.garcia4.contractor@bbva.com
    * @date    29/01/2021
    * @param String participantTypeVal Participant type of the account
    * @return 'GROUP' or 'SUBSIDIARY'
    **/
    private static String getParticipantType(String participantTypeVal) {
        return participantTypeVal == arce.Arc_Gen_Constants.GROUP_ASSET_HEADER_TYPE_HEADER ? 'GROUP' : 'SUBSIDIARY';
    }
    /**
    *-------------------------------------------------------------------------------
    * @description Gets the name of the financial statements service to call for a
    * given participant type.
    *--------------------------------------------------------------------------------
    * @author  joseluis.garcia4.contractor@bbva.com
    * @date    25/05/2020
    * @param String participantType Participant type of the account
    * @return String Name of the service to call.
    **/
    private static String getServiceNameByParticipantType(String participantType) {
        if (participantType == PART_TYPE_GROUP) {
            // Check availability of financial statements service for groups.
            final List<arce__Arce_Config__mdt> configs = arce.Arc_Gen_Arceconfigs_locator.getConfigurationInfo('GroupFFSSServicesAvailable');

            if (configs.isEmpty() || configs[0].arce__Value1__c == null || !Boolean.valueOf(configs[0].arce__Value1__c)) {
                throw new NoFinancialStatementDataException(NoFinancialStatementReason.NO_FFSS_NO_SERVICE);
            }
        }
        return participantType == PART_TYPE_GROUP ? FFSS_SERVICE_NAME_GROUP : FFSS_SERVICE_NAME_CLIENT;
    }
    /**
    *-------------------------------------------------------------------------------
    * @description calls ratiosEngine aso service and returns the result (correctly
    * processed FFSS, HTTP responses and valid FFSS).
    *--------------------------------------------------------------------------------
    * @author  ARCE TEAM
    * @date     09/03/2020
    * @param List selectedFfssList List of selected financial statements
    * @param ratiosParams object that contains parameters to provide to FFSS.
    * @return RatiosResponse aggregated response obtained from ratios service calls
    **/
    private static RatiosResponse callRatiosEngine(List<arce__Financial_Statements__c> selectedFfssList, RatiosServiceParameters ratiosParams, Boolean isRAIP) {
        final arce.Arc_Gen_CustomServiceMessages serviceMessage = new arce.Arc_Gen_CustomServiceMessages();
        final Arc_Gen_Balance_Tables_data dataAccess = new Arc_Gen_Balance_Tables_data();
        RatiosResponse ratiosResponse = new RatiosResponse();

        for (arce__Financial_Statements__c financialItem : selectedFfssList) {
            try {
                // Call ratios engine.
                String financialStatementId = financialItem.arce__financial_statement_id__c;
                final String params =
                    '{"riskAssessmentId":"' + ratiosParams.analysisIdToSend +
                    '","customerId":"' + ratiosParams.customerNumber +
                    '","federationId":"'+ ratiosParams.federationId +
                    '","financialStatementId":"' + financialStatementId +
                    '","participantType":"' + ratiosParams.participantType +
                    '","evenType":"' + ratiosParams.eventType + '"}';
                final HttpResponse response = dataAccess.callEngine(params);
                // Process response.
                if (response.getStatusCode() == serviceMessage.CODE_200) {
                    // check if response contains error (data->controls)
                    ratiosResponse.globalResponseErrorMessage += processError(response);

                    // Add to correctly processed FFSS. If valid, record it.
                    ratiosResponse.ffssToProcess.add(financialItem);
                    ratiosResponse.validHttpResponses.add(response);
                    //ratiosResponse.atLeastOneValid = false;

                    if (financialItem.arce__ffss_valid_type__c == '1' || isRAIP) {
                        ratiosResponse.atLeastOneValid = true;
                        ratiosResponse.validFFSS.add(financialItem);
                    }
                    ratiosResponse.serviceStatusCode = response.getStatusCode();
                } else {
                    ratiosResponse.globalResponseErrorMessage += '<br/>' + financialStatementId + ': ' + System.Label.Arc_Gen_ErrorRatios + ': ' + response.getStatusCode() + ' - ' + response.getBody();
                    ratiosResponse.serviceStatusCode = response.getStatusCode();
                }
            } catch(Exception e) {
                ratiosResponse.globalResponseErrorMessage += '<br/>' + System.Label.Arc_Gen_ErrorParsingEngine + ': ' + e;
                ratiosResponse.serviceStatusCode = 500;
            }
        }
        return ratiosResponse;
    }
    /**
    *-------------------------------------------------------------------------------
    * @description Sets the results of the ratios engine and save records
    *--------------------------------------------------------------------------------
    * @author  ARCE TEAM
    * @date     20/09/2019
    * @param Arc_Gen_Balance_Tables_data.SaveResult saveRes - Result of the database insert
    * @param Arc_Gen_Balance_Tables_data.SaveResult saveRes
    * @param String atLeastOneValid - Indicate if there is at least one valid FFSS for rating
    * @param String globalResponseErrorMessage - Error string
    * @return RatiosAndRatingResponse - Wrapper
    * @example public static RatiosAndRatingResponse setResults(Arc_Gen_Balance_Tables_data.SaveResult saveRes, Boolean atLeastOneValid, String globalResponseErrorMessage)
    **/
    private static RatiosAndRatingResponse setResults(Arc_Gen_Balance_Tables_data.SaveResult saveRes, Boolean atLeastOneValid, String globalResponseErrorMessage, Integer ratiosStatusCode) {
        final arce.Arc_Gen_CustomServiceMessages serviceMessage = new arce.Arc_Gen_CustomServiceMessages();
        final RatiosAndRatingResponse resp = new RatiosAndRatingResponse();
        resp.ratiosStatus = saveRes.status == 'true' && ratiosStatusCode == serviceMessage.CODE_200 ? System.Label.Cls_arce_Success200 : System.Label.Cls_arce_GRP_glbError;
        resp.ratingValidFFSS = atLeastOneValid == true ? 'yes' : 'no';
        resp.ratiosErrorMsg = saveRes.status == 'true' ? globalResponseErrorMessage : saveRes.message;
        return resp;
    }
    /**
    *-------------------------------------------------------------------------------
    * @description call function to process data
    *--------------------------------------------------------------------------------
    * @author ARCE TEAM
    * @date   11/04/2019
    * @param  List<arce__Financial_Statements__c> ffssToProcess
    * @param  List<HttpResponse> validHttpResponses
    * @param  String recordId
    * @param  FinancialStatement valid ffss chosen
    * @return Arc_Gen_Balance_Tables_data.SaveResult
    * @example public static void callProcessData(ffssToProcess, validHttpResponses, recordId) {
    **/
    public static Arc_Gen_Balance_Tables_data.SaveResult callProcessData(List<arce__Financial_Statements__c> ffssToProcess, List<HttpResponse> validHttpResponses, String recordId, arce__Financial_Statements__c validFs) {
        List<Map<String,String>> eeffData2Update = new List<Map<String,String>>();
        Arc_Gen_Balance_Tables_data dataAccess = new Arc_Gen_Balance_Tables_data();
        Arc_Gen_Balance_Tables_data.SaveResult saveRes = new Arc_Gen_Balance_Tables_data.SaveResult();
        List<sObject> listToInsert = new List<sObject>();

        List<arce__Financial_Statements__c> finStatePrevYearLts = Arc_Gen_Balance_Tables_helper.checkEeffPreviousValid(ffssToProcess, validFs);
        Map<String,arce__Financial_Statements__c> ffssImportantMap = new Map<String,arce__Financial_Statements__c>();
        ffssImportantMap.put('valFS', validFs);
        ffssImportantMap.put('prevFS', finStatePrevYearLts.isEmpty() ? new arce__Financial_Statements__c() : finStatePrevYearLts[0]);


        for (Integer i=0; i<ffssToProcess.size(); i++) {
            arce__Financial_Statements__c financialItem = ffssToProcess[i];
            HttpResponse response = validHttpResponses[i];
            try {
                Map<String, arce__Table_Content_per_Analysis__c> completeResponsetMap = new Map<String, arce__Table_Content_per_Analysis__c>();
                eeffData2Update.add(processData(response,completeResponsetMap));
                listToInsert.addAll(listToInsertMethod(ffssImportantMap,financialItem,recordId,completeResponsetMap));
            } catch(Exception e) {
                saveRes.status = System.Label.Cls_arce_GRP_glbError;
                saveRes.message = e.getMessage();
                break;
            }
        }
        updateEEFFtoShow(eeffData2Update,recordId);
        dataAccess.updateRecords(finStatePrevYearLts);
        saveRes = dataAccess.insertRecords(listToInsert);
        return saveRes;
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Update the all the eeff
    *-------------------------------------------------------------------------------
    * @author  mariohumberto.ramirez.contractor@bbva.com
    * @date     23/10/2019
    * @param eeffData2Update List of map with the data to update
    * @param recordId - id of the account has analysis object
    * @return void
    * @example updateEEFFtoShow(eeffData2Update)
    *-------------------------------------------------------------------------------
    **/
    public static void updateEEFFtoShow(List<Map<String,String>> eeffData2Update, String recordId) {
        List<String> eeffIdsLts = new List<String>();
        List<String> unitLts = new List<String>();
        List<String> currencyEeff = new List<String>();
        for (Map<String,String> eeffData: eeffData2Update) {
            eeffIdsLts.add(eeffData.get('Id'));
            currencyEeff.add(eeffData.get('currency'));
            switch on eeffData.get('unit') {
                when 'UNITS' {
                    unitLts.add('1');
                }
                when 'THOUSANDS' {
                    unitLts.add('2');
                }
                when 'MILLIONS' {
                    unitLts.add('3');
                }
                when 'BILLION' {
                    unitLts.add('4');
                }
            }
        }
        List<arce__Financial_Statements__c> financialSLts = Arc_Gen_Balance_Tables_data.getFinancialState2Show(eeffIdsLts,recordId);
        for (arce__Financial_Statements__c finaStat: financialSLts) {
            for (integer i = 0; i < eeffIdsLts.size(); i++) {
                if (finaStat.arce__financial_statement_id__c == eeffIdsLts[i]) {
                    finaStat.arce__magnitude_unit_type__c = unitLts[i];
                    finaStat.CurrencyIsoCode = currencyEeff[i];
                }
            }
        }
        Arc_Gen_Balance_Tables_data.updateRecordLts(financialSLts);
    }
    /**
    *-------------------------------------------------------------------------------
    * @description retrieve error FROM Ratios WS response
    *--------------------------------------------------------------------------------
    * @author  ARCE TEAM
    * @date     11/04/2019
    * @param HttpResponse retrieved FROM Ratios WS
    * @return String
    *       Blank string if no error
    *       Parsed error string if some error
    * @example public static String processError(HttpResponse response) {
    **/
    public static String processError(HttpResponse response) {
        Map<String, Object> mapResponse = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
        Map<String, Object> data = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(mapResponse.get('data')));
        List<Object> controls = ( List<Object>)data.get('controls');
        String responseErrorMessage = '';
        for(Object controlDataL : controls) {
            Map<String, Object> controlData = (Map<String, Object>)controlDataL;
            Boolean isValid = (Boolean)controlData.get('isValid');
            if (!isValid) {
                if (responseErrorMessage == '' ) {
                    responseErrorMessage += (String)controlData.get('description');
                } else {
                    responseErrorMessage +='<br/>' + (String)controlData.get('description');
                }
            }
        }
        return responseErrorMessage;
    }
    /**
    *-------------------------------------------------------------------------------
    * @description process WS response to format data
    *--------------------------------------------------------------------------------
    * @author  ARCE TEAM
    * @date     11/04/2019
    * @param HttpResponse retrieved FROM Ratios WS
    * @param Map<String, arce__Table_Content_per_Analysis__c> completeResponsetMap
    * @return Map<String,String>
    * @example public static void processData(HttpResponse response, Map<String, arce__Table_Content_per_Analysis__c> completeResponsetMap) {
    **/
    public static Map<String,String> processData(HttpResponse response, Map<String, arce__Table_Content_per_Analysis__c> completeResponsetMap) {
        Map<String,String> eeffData = new Map<String,String>();
        Map<String, Object> mapResponse = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
        Map<String, Object> data = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(mapResponse.get('data')));
        Map<String, Object> calculations = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(data.get('calculations')));
        Map<String, Object> balanceFs = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(data.get('financialStatement')));
        List<Object> specificMagnitudes;
        if(calculations.containsKey('specificRatiosMagnitudes')) {
            specificMagnitudes = (List<Object>)JSON.deserializeUntyped(JSON.serialize(calculations.get('specificRatiosMagnitudes')));
        }
        List<String> ratioMetricsSpecialKeys = new List<String>{'netPayback', 'averageCollectionPeriod', 'stockTurnover', 'averagePayingPeriod'}; // this keys of ratioMetrics have 'number' instead of 'ammount / ammount'
        List<String> globalSynthesisOnlyPercentKeys = new List<String>{'variationOnSales'};
        String parentId = (String)balanceFs.get('id');
        eeffData.put('Id',parentId);
        eeffData.put('currency',(String)balanceFs.get('currency'));
        eeffData.put('unit',(String)balanceFs.get('unit'));
        if(calculations.containsKey('specificRatiosMagnitudes')) {
            for(Object element: specificMagnitudes) {
                final Map<String,Object> data1 = (Map<String,Object>) element;
                final arce__Table_Content_per_Analysis__c recordToInsert = processRatioDataValues(data1, parentId);
                completeResponsetMap.put(String.valueOf(data1.get('id')), recordToInsert);
            }
        } else {
            Map<String, Object> globalSynthesis = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(calculations.get('globalSynthesis')));
            Map<String, Object> cashFlow = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(calculations.get('cashFlow')));
            Map<String, Object> ratiosMetrics = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(calculations.get('ratiosMetrics')));
            for(Object element: globalSynthesis.keyset()) {
                arce__Table_Content_per_Analysis__c recordToInsert = processRatioDataValues(element, globalSynthesis, 'globalSynthesis', parentId);
                completeResponsetMap.put(String.valueOf(element), recordToInsert);
            }
            for(Object element: cashFlow.keyset()) {
                arce__Table_Content_per_Analysis__c recordToInsert = processRatioDataValues(element, cashFlow, 'cashFlow', parentId);
                completeResponsetMap.put(String.valueOf(element), recordToInsert);
            }
            for(Object element: ratiosMetrics.keyset()) {
                arce__Table_Content_per_Analysis__c recordToInsert = processRatioDataValues(element, ratiosMetrics, 'ratiosMetrics', parentId);
                completeResponsetMap.put(String.valueOf(element), recordToInsert);
            }
        }
        return eeffData;
    }
    /**
    *-------------------------------------------------------------------------------
    * @description process WS Data for each section
    *--------------------------------------------------------------------------------
    * @author  ARCE TEAM
    * @date     11/04/2019
    * @param Object "Element" to be proccessed
    * @param Map<String,Object> of the section
    * @param String "dataType" ratiosMetrics / cashFlow / globalSynthesis
    * @return record arce__Table_Content_per_Analysis__c with data
    * @example private static arce__Table_Content_per_Analysis__c processRatioDataValues(Object element, Map<String, Object> dataMap, string dataType, String parentId) {
    **/
    private static arce__Table_Content_per_Analysis__c processRatioDataValues(Object element, Map<String, Object> dataMap, string dataType, String parentId) {
        List<String> ratioMetricsSpecialKeys = new List<String>{'netPayback', 'averageCollectionPeriod', 'stockTurnover', 'averagePayingPeriod'}; // this keys of ratioMetrics have 'number' instead of 'ammount / ammount'
        List<String> ratioMetricsDirectKeys = new List<String>{'financialDebtOverEquity', 'interestCoverageWithEbitda', 'grossFinancialDebtOverEbitda', 'netFinancialDebtOverEbitda', 'returnOnAssets'}; // this keys are mapped directly to decimal
        List<String> globalSynthesisOnlyPercentKeys = new List<String>{'variationOnSales'};
        arce__Table_Content_per_Analysis__c recordToInsert = new arce__Table_Content_per_Analysis__c();
        try {
            switch on dataType {
                when 'ratiosMetrics' {
                    if(ratioMetricsDirectKeys.contains(String.valueOf(element))) {
                        // element contains decimal value
                        recordToInsert.arce__table_content_value__c = Decimal.valueOf(String.valueOf(dataMap.get(String.valueOf(element))));
                    } else {
                        Map<String, Object> elemntMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(dataMap.get(String.valueOf(element))));
                        if(ratioMetricsSpecialKeys.contains(String.valueOf(element))) {
                            // element / number
                            recordToInsert.arce__table_content_value__c = Decimal.valueOf(String.valueOf(elemntMap.get('number')));
                        } else {
                            // element / ammount / ammount
                            Map<String, Object> amountMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(elemntMap.get('amount')));
                            recordToInsert.arce__table_content_value__c = getAmount(amountMap);
                            recordToInsert.CurrencyIsoCode = getCurrency(amountMap);
                        }
                    }
                }
                when 'cashFlow' {
                    Map<String, Object> elemntMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(dataMap.get(String.valueOf(element))));
                    Map<String, Object> amountMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(elemntMap.get('amount')));
                    recordToInsert.arce__table_content_value__c = getAmount(amountMap);
                    recordToInsert.CurrencyIsoCode = getCurrency(amountMap);
                }
                when 'globalSynthesis' {
                    Map<String, Object> elemntMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(dataMap.get(String.valueOf(element))));
                    if(! globalSynthesisOnlyPercentKeys.contains(String.valueOf(element))) {
                        // if element is in list means that only contains percentage, so we cant map ammount
                        Map<String, Object> amountMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(elemntMap.get('amount')));
                        recordToInsert.arce__table_content_value__c = getAmount(amountMap);
                        recordToInsert.CurrencyIsoCode = getCurrency(amountMap);
                    }
                    recordToInsert.arce__table_content_percentage__c = Arc_Gen_Balance_Tables_helper.getPercentFromMap(elemntMap);
                }
            }
            recordToInsert.arce__table_content_parent_code_id__c = parentId;
        } catch(Exception e) {
            /*This error should not be presented to the user, but it is important to determinate if the errors came FROM WS */
            System.debug('Excpetion while parsing json response (' + dataType + ' element: ' + String.valueOf(element) + ' ) Exception: ' + e );
        }
        return recordToInsert;
    }

    /**
    *-------------------------------------------------------------------------------
    * @description process WS Data for each section
    *--------------------------------------------------------------------------------
    * @Author  ARCE TEAM
    * @Date     03/03/2021
    * @param Map<String,Object> element - Data for Balante Table Helper.
    * @param String parentId - Parent Id of currect client.
    * @return record arce__Table_Content_per_Analysis__c with data
    * @example private static arce__Table_Content_per_Analysis__c processRatioDataValues(Map<String, Object> dataMap, String parentId) {
    * -------------------------------------------------------------------------------
    **/
    private static arce__Table_Content_per_Analysis__c processRatioDataValues(Map<String, Object> element, String parentId) {
        final arce__Table_Content_per_Analysis__c recordToInsert = new arce__Table_Content_per_Analysis__c();
        try {
            recordToInsert.arce__table_content_percentage__c = Arc_Gen_Balance_Tables_helper.getPercentFromMap(element);
            if(element.containsKey('totalAmount')) {
                final Map<String, Object> amountMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(element.get('totalAmount')));
                recordToInsert.arce__table_content_value__c = getAmount(amountMap);
                recordToInsert.CurrencyIsoCode = getCurrency(amountMap);
            }
            recordToInsert.arce__table_content_parent_code_id__c = parentId;
        } catch(Exception e) {
            /*This error should not be presented to the user, but it is important to determinate if the errors came FROM WS */
            System.debug('Excpetion while parsing json response (specificRatiosMagnitudes element: ' + String.valueOf(element.get('description')) + ' ) Exception: ' + e );
        }
        return recordToInsert;
    }

    /**
    *-------------------------------------------------------------------------------
    * @description get currency FROM map
    *--------------------------------------------------------------------------------
    * @author  ARCE TEAM
    * @date     11/04/2019
    * @param Map<String, Object> amountMap map of ammounts
    * @return String currency for map
    * @example private static String getCurrency(Map<String, Object> amountMap) {
    **/
    private static String getCurrency(Map<String, Object> amountMap) {
        return String.valueOf(String.valueOf(amountMap.get('currency')));
    }
    /**
    *-------------------------------------------------------------------------------
    * @description get amount FROM map
    *--------------------------------------------------------------------------------
    * @author  ARCE TEAM
    * @date     11/04/2019
    * @param Map<String, Object> amountMap to reviw
    * @return String amount to validate
    * @example private static Decimal getAmount(Map<String, Object> amountMap) {
    **/
    private static Decimal getAmount(Map<String, Object> amountMap) {
        return Decimal.valueOf(String.valueOf(amountMap.get('amount')));
    }

    /**
    *-------------------------------------------------------------------------------
    * @description insert WS response into Salesforce
    *--------------------------------------------------------------------------------
    * @author  ARCE TEAM
    * @date     11/04/2019
    * @param Arc_Gen_Balance_Tables_data dataAccess
    * @param arce__Financial_Statements__c ffss financial statement
    * @param String recordId  id of analysis
    * @param Map<String, arce__Table_Content_per_Analysis__c> cmpltRespMap (records to be inserted)
    * @return void (insert data)
    * @example public static void listToInsertMethod(Arc_Gen_Balance_Tables_data dataAccess, Date year, String recordId, Map<String, arce__Table_Content_per_Analysis__c> completeResponsetMap ) {
    **/
    public static List<sObject> listToInsertMethod(Map<String,arce__Financial_Statements__c> ffssImportantMap, arce__Financial_Statements__c ffss, String recordId, Map<String, arce__Table_Content_per_Analysis__c> cmpltRespMap ) {
        Arc_Gen_Balance_Tables_data dataAccess = new Arc_Gen_Balance_Tables_data();
        final arce__Arce_Config__mdt orderTableField = Arc_Gen_Balance_Tables_data.orderTableField();
        List<arce__Table_Content_per_Analysis__c> listToInsert = new List<arce__Table_Content_per_Analysis__c>();
        List<String> tablesList = new List<String>{'07','02','03','04'};

        // Get table header maximum text size for truncation.
        final Schema.DescribeFieldResult describe = arce__Table_Content_per_Analysis__c.arce__table_content_year__c.getDescribe();
        final Integer headerMaxLength = describe.getLength();

        // Label maps.
        final Map<String, String> adjustedTypeMap = arce.Arc_Gen_GenericUtilities.getMapLabelFromValue('arce__Financial_Statements__c', 'arce__ffss_adjusted_type__c');
        final Map<String, String> certTypeMap = arce.Arc_Gen_GenericUtilities.getMapLabelFromValue('arce__Financial_Statements__c', 'arce__ffss_certification_type__c');
        final Map<String, String> submTypeMap = arce.Arc_Gen_GenericUtilities.getMapLabelFromValue('arce__Financial_Statements__c', 'arce__ffss_submitted_type__c');

        // Labels.
        final String adjustedLabel = adjustedTypeMap.get(ffss.arce__ffss_adjusted_type__c);
        final String certLabel = certTypeMap.get(ffss.arce__ffss_certification_type__c);
        final String submLabel = submTypeMap.get(ffss.arce__ffss_submitted_type__c);
        String tableHeader = Datetime.newInstance(ffss.arce__financial_statement_end_date__c, Time.newInstance(0,0,0,0)).format('yyyy-MM-dd') + ' ' + certLabel + ' ' + submLabel + ' ' + adjustedLabel  + ' (' + ffss.arce__financial_statement_id__c.replaceFirst('^0+(?!$)', '') + ')';
        tableHeader = tableHeader.abbreviate(headerMaxLength);

        // Build record type table.
        final Schema.DescribeFieldResult fieldResult = arce__Table_Content_per_Analysis__c.arce__collection_table__c.getDescribe();
        final List<Schema.PicklistEntry> picklisValue = fieldResult.getPicklistValues();
        final Map<String, Schema.RecordTypeInfo> recordTypeInfos = Schema.SObjectType.arce__Table_Content_per_Analysis__c.getRecordTypeInfosByName();
        final Map<String, String> rtIdsByLabel = buildRecordTypeIdsByLabel(recordTypeInfos, picklisValue);

        for(arce__Data_Collections__c dataCollectionElement : dataAccess.getRecordsToInsert(tablesList)) {
            // If element is not found in ratios response, skip it.
            if (!cmpltRespMap.containsKey(dataCollectionElement.arce__collection_code_term__c)) {
                continue;
            }

            arce__Table_Content_per_Analysis__c recordToInsert = new arce__Table_Content_per_Analysis__c();
            try {
                recordToInsert.CurrencyIsoCode = cmpltRespMap.get(dataCollectionElement.arce__collection_code_term__c).CurrencyIsoCode;
                recordToInsert.arce__table_content_value__c = cmpltRespMap.get(dataCollectionElement.arce__collection_code_term__c).arce__table_content_value__c;
                recordToInsert.arce__table_content_percentage__c = cmpltRespMap.get(dataCollectionElement.arce__collection_code_term__c).arce__table_content_percentage__c;
                recordToInsert.arce__table_content_parent_code_id__c = cmpltRespMap.get(dataCollectionElement.arce__collection_code_term__c).arce__table_content_parent_code_id__c;
                recordToInsert.RecordTypeId = rtIdsByLabel.get(dataCollectionElement.arce__collection_table__c);
                recordToInsert.arce__collection_table__c = dataCollectionElement.arce__collection_table__c;
                recordToInsert.arce__table_content_year__c = tableHeader;
                recordToInsert.arce__account_has_analysis_id__c = recordId;
                recordToInsert.arce__Data_Collection_Id__c = dataCollectionElement.id;
                recordToInsert.put(orderTableField.arce__Value1__c, String.valueof(dataCollectionElement.arce__collection_order_number__c)); // PARCE
                recordToInsert.arce__valid_fin_statement__c = ffssImportantMap.get('valFS').Id == ffss.Id ? true : false;
                recordToInsert.arce__previous_valid__c = ffssImportantMap.get('prevFS').Id == ffss.Id ? true : false;
            } catch(Exception e) {
                /*This error should not be presented to the user, but it is important to determinate if the errors came FROM WS */
                system.debug('Exception: ' + e.getMessage() + ' | Stack trace: ' + e.getStackTraceString());
            }
            if(recordToInsert != null) {
                listToInsert.add(recordToInsert);
            }
        }
        return listToInsert;
    }
    /**
    *-------------------------------------------------------------------------------
    * @description Return the list of financial statements with the translated labels.
    *--------------------------------------------------------------------------------
    * @author  juanignacio.hita.contractor@bbva.com
    * @date    26/06/2020
    * @param   List<arce__Financial_Statements__c> list of financial statements
    * @return  List<arce__Financial_Statements__c> list of financial statements with the labels translated
    * @example List<arce__Financial_Statements__c> list = Arc_Gen_Balance_Tables_service.translatePicklistValues(ffssList);
    **/
    public static List<arce__Financial_Statements__c> translatePicklistValues(List<arce__Financial_Statements__c> ffssList) {
        List<arce__Financial_Statements__c> ffssListRet = ffssList.deepClone();
        Arc_Gen_Balance_Tables_helper.translatePicklistValues(ffssListRet);
        return ffssListRet;
    }
    /**
    *-------------------------------------------------------------------------------
    * @description Builds a map of record type IDs for data collections.
    *--------------------------------------------------------------------------------
    * @author  joseluis.garcia4.contractor@bbva.com
    * @date    05/01/2021
    * @param   recordTypeInfos - Record type metadata
    * @param   picklisValue - Picklist value metadata
    * @return  the map matching labels (from picklist) to record type IDs.
    **/
    private static Map<String, String> buildRecordTypeIdsByLabel(Map<String, Schema.RecordTypeInfo> recordTypeInfos, List<Schema.PicklistEntry> picklisValue) {
        final Map<String, String> rtIdsByLabel = new Map<String, String>();
        for( Schema.PicklistEntry element : picklisValue) {
            rtIdsByLabel.put(element.getValue(), recordTypeInfos.get(element.getLabel()).getRecordTypeId());
        }
        return rtIdsByLabel;
    }
}