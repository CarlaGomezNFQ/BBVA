/*------------------------------------------------------------------
* @File Name: Arc_Gen_ModalFinanStatemController.cls
* @Author:        ARCE Team
* @Group:      	ARCE - BBVA Bancomer
* @Description:   Controller to modal Arc_Gen_ModalFinanStatem.
* @Changes :
* Methods to get and process FinancialStatemnt from ASO

Service class: Arc_Gen_Balance_Tables_Service
Data class: Arc_Gen_Balance_Tables_data
*_______________________________________________________________________________________
*Version    Date           Author                               Description
*1.0        11/04/2019     ARCE TEAM   							Creación.
*1.1		24/04/2019	   diego.miguel.contractor@bbva.com		        Modified ratios function to parse Json response properly
*1.2		25/04/2019	   diego.miguel.contractor@bbva.com	            Modified ratios and eeff functions to handle error messages and display to users
*1.3		20/12/2019	   mariohumberto.ramirez.contractor@bbva.com    Added new wrapper FinancialDetailsWrapper and new method consultFSdetails
*1.4		30/01/2020	   juanmanuel.perez.ortiz.contractor@bbva.com	Add missing custom labels
*1.5        09/03/2020     eduardoefrain.hernandez.contractor@bbva.com  adedd methods because of Indepentent Rating (RAIP)
*1.6        26/03/2020     juanignacio.hita.contractor@bbva.com         Refactoring
*1.7        15/04/2020     joseluis.garcia4.contractor@bbva.com         Implement FinancialStatementsFetchWrapper to provide label to frontend
*1.8        26/05/2020     joseluis.garcia4.contractor@bbva.com         Error messages when no FFSS are found.
*1.9        16/06/2020     joseluis.garcia4.contractor@bbva.com         Prevent call to ratios engine if user has no edit permission on analysis.
*1.10       07/07/2020     juanignacio.hita.contractor@bbva.com         Add translatePicklistValues list for save ffss list with labels translated from service.
*1.11       10/01/2021     ivan.cons@bbva.com                           Added isPreselected feature for retrieve the preselected FFSS.
*1.12       15/03/2021     ivan.cons@bbva.com                           Added isFinancialRAIP param to callEngineFinancialState
                                                                        for differenciate flows.
+1.13       22/06/2021     ivan.cons@bbva.com                           Added empty constructor
-----------------------------------------------------------------------------------------*/
public with sharing class Arc_Gen_ModalFinanStatemController {

    /**
    * Empty constructor to avoid static code analysis tool warnings.
    */
    private Arc_Gen_ModalFinanStatemController() {

    }
    /**
    * @Description Value of the "Valid" picklist entry of the ffss_valid_type field.
    */
    private static final String FFSS_VALID_TYPE_VALUE = '1';
    /**
    * -----------------------------------------------------------------------------------------------
    * @Description Wrapper that contain all the information to create the component
    * -----------------------------------------------------------------------------------------------
    * @param void
    * @return all the information to create the component
    * @example TabsWrapper tabswrapper = new TabsWrapper()
    * -----------------------------------------------------------------------------------------------
    **/
    public class FinancialDetailsWrapper {
        /**
        * @Description: Contain a message of error
        */
        @AuraEnabled public String gblResulError {get;set;}
        /**
        * @Description: Boolean to manage the result of an operation
        */
        @AuraEnabled public Boolean gblSuccessOperation {get;set;}
        /**
        * @Description: String to manage the servicecode of a service
        */
        @AuraEnabled public Integer gblRespServiceCode {get;set;}
        /**
        * @Description: Integer that contains the employess number
        */
        @AuraEnabled public Integer employeesNumber {get;set;}
    }
    /**
    * -----------------------------------------------------------------------------------------------
    * @Description Wrapper that contains a list of FFSS, as well as the label of the valid picklist type
    * for comparison
    * -----------------------------------------------------------------------------------------------
    **/
    public class FinancialStatementsFetchWrapper {
        /**
        * @Description: List of financial statements.
        */
        @AuraEnabled public List<arce__Financial_Statements__c> ffssList { get; set; }

        /**
        * @Description: List of financial statements with labels translated.
        */
        @AuraEnabled public List<arce__Financial_Statements__c> ffssListLabel { get; set; }

        /**
        * @Description: Label of the valid picklist value of the ffss_valid_type field.
        */
        @AuraEnabled public String validLabel { get; set; }

        /**
        * @Description: Label of the valid picklist value of the ffss_valid_type field.
        */
        @AuraEnabled public Set<String> preselected { get; set; }
    }
    /**
    *-------------------------------------------------------------------------------
    * @description method that draw the table of financial statements.
    *--------------------------------------------------------------------------------
    * @author diego.miguel.contractor@bbva.com
    * @date 2019-04-11
    * @param varRecord recordId of the account_has_analysis.
    * @return list from financial statements.
    * @example public static List <arce__Financial_Statements__c> fetchAccounts(String varRecord) {
    **/
    @AuraEnabled
    public static FinancialStatementsFetchWrapper fetchFinancialStatements(String varRecord, Boolean isFinancialRAIP) {
        try {
            final FinancialStatementsFetchWrapper wrapper = new FinancialStatementsFetchWrapper();
            wrapper.ffssList = Arc_Gen_Balance_Tables_service.setupFFSSHeaders(varRecord, false);
            wrapper.ffssListLabel = Arc_Gen_Balance_Tables_Service.translatePicklistValues(wrapper.ffssList);
            if(isFinancialRAIP) {
                final Set<String> preselectedFFSS = new Set<String>();
                for(arce__Account_has_Analysis__c aHa : arce.Arc_Gen_AccHasAnalysis_Data.getAccHasAnalysis(new List<String>{varRecord})) {
                    preselectedFFSS.add(aHa.arce__ffss_for_rating_id__r.arce__financial_statement_id__c);
                }
                wrapper.preselected = preselectedFFSS;
            }
            // Get label for "Valid" value of ffss_valid_type field
            final List<Schema.PicklistEntry> picklistEntries =
                arce__Financial_Statements__c.arce__ffss_valid_type__c.getDescribe().getPicklistValues();
            for (Schema.PicklistEntry entry : picklistEntries) {
                if (entry.getValue() == FFSS_VALID_TYPE_VALUE) {
                    wrapper.validLabel = entry.getLabel();
                }
            }

            return wrapper;
        } catch (Arc_Gen_Balance_Tables_service.NoFinancialStatementDataException ex) {
            throw new AuraHandledException(System.Label.Arc_Gen_NoReturnedFFSS);   // NOSONAR
        } catch (Exception ex) {
            throw new AuraHandledException(System.Label.Arc_Gen_ErrorService);   // NOSONAR
        }
    }
    /**
    *-------------------------------------------------------------------------------
    * @description method that call callEngineFinancialState and return the status of engine.
    *--------------------------------------------------------------------------------
    * @author diego.miguel.contractor@bbva.com
    * @date 2019-04-11
    * @param recordId - recordId of the account_has_analysis and the list of elements selected from the table.
    * @param financialIdList - List<String> data for the tables
    * @param isRAIP - Boolean - check if it comes from a RAIP.
    * @param isFinancialRAIP - Boolean - check if it comes from a Financial RAIP.
    * @return Arc_Gen_Balance_Tables_service.ratiosAndRatingResponse
    * @example public static Arc_Gen_Balance_Tables_service.ratiosAndRatingResponse callEngineFinancialState(String recordId,String lista) {
    **/
    @AuraEnabled
    public static Arc_Gen_Balance_Tables_service.ratiosAndRatingResponse callEngineFinancialState(String recordId, List<String> financialIdList, Boolean isRAIP, Boolean isFinancialRAIP) {
        final Boolean hasPermissions = Arc_Gen_TabSet_service.getPermissionToEdit(recordId) == 'true';
        if (!hasPermissions) {
            throw new AuraHandledException(System.Label.Arc_Gen_Generic_NotAllowed);
        }

        try {
            final List<arce__Financial_Statements__c> financialStatements = Arc_Gen_Balance_Tables_service.setupFFSSHeaders(recordId, false);
            final List<arce__Financial_Statements__c> selectedFinancialStatements = Arc_Gen_Balance_Tables_service.filterFFSSByServiceId(financialStatements, financialIdList);
            final Arc_Gen_Balance_Tables_service.RatiosAndRatingResponse resp = Arc_Gen_Balance_Tables_service.buildTables(recordId, selectedFinancialStatements, isRAIP, isFinancialRAIP);
            return resp;
        } catch (Arc_Gen_Balance_Tables_service.NoFinancialStatementDataException ex) {
            throw new AuraHandledException(System.Label.Arc_Gen_NoReturnedFFSS);   // NOSONAR
        } catch (Exception ex) {
            throw new AuraHandledException(System.Label.Arc_Gen_ErrorService);   // NOSONAR
        }
    }
    /**
    *----------------------------------------------------------------------------------------------------------------------------------------
    * @Description method that consult the financial statement details service and set the number of employess of the subsidiary
    *----------------------------------------------------------------------------------------------------------------------------------------
    * @Author   mariohumberto.ramirez.contractor@bbva.com
    * @Date     Created: 2019-12-19
    * @param recordId - Id of the account_has_analysis
    * @param fsServiceId - Id of the financial statement
    * @return FinancialDetailsWrapper - wrapper with the result of the operation
    * @example consultFSdetails(recordId, fsServiceId) {
    * ---------------------------------------------------------------------------------------------------------------------------------------
    **/
    @AuraEnabled
    public static FinancialDetailsWrapper consultFSdetails(String recordId, String fsServiceId) {
        FinancialDetailsWrapper response =  new FinancialDetailsWrapper();
        try {
            response = Arc_Gen_FinStatDetails_Service.setNumberOfEmployees(recordId, fsServiceId);
            response.gblSuccessOperation = true;
        } catch (Exception e) {
            response.gblSuccessOperation = false;
            response.gblResulError = e.getMessage() + ' : ' + e.getLineNumber();
        }
        return response;
    }
}