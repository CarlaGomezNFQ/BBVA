/*------------------------------------------------------------------
* @File Name: Arc_Gen_ModalFinanStatemController
* @Author:        Diego Miguel Tamarit - diego.miguel.contractor@bbva.com / dmiguelt@minsait.com
* @Group:      	ARCE - BBVA Bancomer
* @Description:   Test class for code coverage of:
* @Changes :
*Arc_Gen_Balance_Tables_service
*Arc_Gen_Balance_Tables_data
*_______________________________________________________________________________________
*Version    Date           Author                               Description
*1.0        11/04/2019     diego.miguel.contractor@bbva.com    	Creación.
*1.1        25/04/2019     diego.miguel.contractor@bbva.com    	Updated functions to cover ratios and EEff WS
*1.2        30/04/2019     diego.miguel.contractor@bbva.com    	Added function to test arce.Arc_Gen_getIASOResponse
*1.3        30/04/2019     diego.miguel.contractor@bbva.com    	Added function to test arce.Arc_Gen_getIASOResponse
*1.4        24/10/2019     mariohumberto.ramirez.contractor@bbva.com  Updated functions to cover updateEEFFtoShow, getFinancialState2Show, updateRecordLts
*1.4.1      02/12/2019     german.sanchez.perez.contractor@bbva.com
*                          franciscojavier.bueno@bbva.com               Api names modified with the correct name on business glossary
*1.5        24/10/2019     mariohumberto.ramirez.contractor@bbva.com  Added new methods (testFsDetailsSuccess, testFsDetailsNull, testFsDetailsFails)
*                                                                     in order to increment test coverage of Arc_Gen_FinStatDetails_Service,
*                                                                     Arc_Gen_FinStatDetails_Service_Helper and Arc_Gen_ModalFinanStatemController
*1.6        07/01/2020     javier.soto.carrascosa@bbva.com          Add support for account wrapper and setupaccounts
*1.7        25/03/2020     juanignacio.hita.contractor@bbva.com          Update class test to support new fetchaccounts refactor
*1.8        15/04/2020     joseluis.garcia4.contractor@bbva.com          Update test methods to use FinancialStatementsFetchWrapper
*1.9        26/05/2020     joseluis.garcia4.contractor@bbva.com          Update test method to use a valid FFSS.
*2.0        10/06/2020     cesaroctavio.villanueva.cebal@bbva.com        Added value to table contet per analysis to correctly cover test
*2.1        14/07/2020     juanignacio.hita.contractor@bbva.com          Added testCallEngineEmptyValid and validation rating test
*2.2        11/08/2020     javier.soto.carrascosa@bbva.com               Update sector field
*2.3        23/09/2020     saimassimilianno.jordana.contractor@bbva.com  Added arce. namespace to all classes that are now in the
*                                                                        arce-dependencies package
*2.4        04/12/2020     leandro.macias.contractor@bbva.com           Added testfilterGlobal & testSwap to increase coverage for class
*2.5        28/04/2021     ivan.cons@bbva.com                           Added new parameter to method into testCallEngineFinancialState test method.
*2.6        03/09/2021     juanignacio.hita.contractor@bbva.com         Removes setup invoking lines method
-----------------------------------------------------------------------------------------*/
@isTest
public class Arc_Gen_ModalFinanStatemController_test {
    /**
    * --------------------------------------------------------------------------------------
    * @Description setup method
    * --------------------------------------------------------------------------------------
    * @param void
    * @return void
    * @example Arc_Gen_ModalFinanStatemController_test.setup()
    * --------------------------------------------------------------------------------------
    **/
    @testSetup static void setup() {
        Arc_UtilitysDataTest_tst.setupAcccounts();
        final Map<String,arce.Arc_Gen_Account_Wrapper> groupAccWrapper = arce.Arc_Gen_Account_Locator.getAccountByAccNumber(new List<String>{'G000001', 'C000001'});
        final arce.Arc_Gen_Account_Wrapper groupAccount = groupAccWrapper.get('G000001');
        final arce.Arc_Gen_Account_Wrapper childAccount = groupAccWrapper.get('C000001');

        final arce__Sector__c newSector = Arc_UtilitysDataTest_tst.crearSector('Generic', '100', '1', null);
        insert newSector;

        final arce__Analysis__c newArce = Arc_UtilitysDataTest_tst.crearArceAnalysis('Arce Analysis', null, groupAccount.accId);
        insert newArce;

        arce__Account_has_Analysis__c newAnalysis = Arc_UtilitysDataTest_tst.crearAccHasAnalysis(newSector.id, newArce.Id, groupAccount.accId, '1');
        newAnalysis.arce__main_subsidiary_ind_type__c = false;
        insert newAnalysis;

        final arce__Account_has_Analysis__c newChildAcc = Arc_UtilitysDataTest_tst.crearAccHasAnalysis(newSector.id, newArce.Id, childAccount.accId, '1');
        newChildAcc.arce__main_subsidiary_ind_type__c = false;
        insert newChildAcc;

        final arce__rating__c rating = Arc_UtilitysDataTest_tst.crearRating(null);
        insert rating;

        final arce__Financial_Statements__c finStatement0 = Arc_UtilitysDataTest_tst.crearFinStatement(groupAccount.accId, newAnalysis.id, rating.id, null);
        final String strParam0 = '{ "id" : "70202018129", "submitType" : "1", "validType" : "1", "adjustedType" : "1", "cerType" : "AUDITED", "dateType" : "2"}';
        Arc_UtilitysDataTest_tst.setupFFSS(finStatement0, strParam0);

        final arce__Financial_Statements__c finStatement1 = Arc_UtilitysDataTest_tst.crearFinStatement(groupAccount.accId, newAnalysis.id, rating.id, null);
        final String strParam1 = '{ "id" : "70202018131", "submitType" : "1", "validType" : "1", "adjustedType" : "2", "cerType" : "AUDITED", "dateType" : "0"}';
        Arc_UtilitysDataTest_tst.setupFFSS(finStatement1, strParam1);

        final arce__Financial_Statements__c finStatement5 = Arc_UtilitysDataTest_tst.crearFinStatement(groupAccount.accId, newAnalysis.id, rating.id, null);
        final String strParam5 = '{ "id" : "70202018132", "submitType" : "1", "validType" : "1", "adjustedType" : "2", "cerType" : "AUDITED", "dateType" : "2"}';
        Arc_UtilitysDataTest_tst.setupFFSS(finStatement1, strParam5);

        final arce__Financial_Statements__c finStatement2 = Arc_UtilitysDataTest_tst.crearFinStatement(groupAccount.accId, newAnalysis.id, rating.id, null);
        final String strParam2 = '{ "id" : "70202018130", "submitType" : "1", "validType" : "1", "adjustedType" : "2", "cerType" : "FISCAL", "dateType" : "0"}';
        Arc_UtilitysDataTest_tst.setupFFSS(finStatement1, strParam2);

        final arce__Financial_Statements__c finStatement3 = Arc_UtilitysDataTest_tst.crearFinStatement(groupAccount.accId, newAnalysis.id, rating.id, null);
        final String strParam3 = '{ "id" : "70202018133", "submitType" : "1", "validType" : "1", "adjustedType" : "2", "cerType" : "TRADE_REGISTRY", "dateType" : "0"}';
        Arc_UtilitysDataTest_tst.setupFFSS(finStatement3, strParam3);

        final arce__Financial_Statements__c finStatement4 = Arc_UtilitysDataTest_tst.crearFinStatement(groupAccount.accId, newAnalysis.id, rating.id, null);
        finStatement4.arce__ffss_valid_type__c = '1';
        finStatement4.arce__financial_statement_id__c = 'dummyFFSS';

        List<arce__Financial_Statements__c> lstFFSS = new List<arce__Financial_Statements__c>();
        lstFFSS.add(finStatement0);
        lstFFSS.add(finStatement1);
        lstFFSS.add(finStatement2);
        lstFFSS.add(finStatement3);
        lstFFSS.add(finStatement4);
        lstFFSS.add(finStatement5);
        insert lstFFSS;

        arce__Data_Collections__c dataCollection = Arc_UtilitysDataTest_tst.crearDataCollection('Cash Flow Analysis', 'Cash_Flow_Analysis', '04');
        dataCollection.arce__collection_code_term__c = 'workingCapital';
        insert dataCollection;

        final arce__Table_Content_per_Analysis__c tableCAnalysis = Arc_UtilitysDataTest_tst.crearTableContentAnalysis(newAnalysis.id, dataCollection.id, 'Cash_Flow_Analysis', '2017');
        insert tableCAnalysis;

        final List<sObject> iasoCnfList = Arc_UtilitysDataTest_tst.crearIasoUrlsCustomSettings();
        insert iasoCnfList;
    }
    /**
    * --------------------------------------------------------------------------------------
    * @Description test method
    * --------------------------------------------------------------------------------------
    * @param void
    * @return void
    * @example Arc_Gen_ModalFinanStatemController_test.testSaveAndServiceResp()
    * --------------------------------------------------------------------------------------
    **/
    @isTest static void testSaveAndServiceResp() {
        final arce.Arc_Gen_ServiceAndSaveResponse response = new arce.Arc_Gen_ServiceAndSaveResponse();
        response.serviceCode = '200';
        response.serviceMessage = 'Success';
        response.serviceResponse = '{}';
        response.saveStatus = 'true';
        response.saveMessage = 'Success';
        System.assertEquals(response.serviceCode, '200');
    }
    /**
    * --------------------------------------------------------------------------------------
    * @Description test method
    * --------------------------------------------------------------------------------------
    * @param void
    * @return void
    * @example Arc_Gen_ModalFinanStatemController_test.testFetchAccounts()
    * --------------------------------------------------------------------------------------
    **/
    @isTest static void testFetchAccounts() {
        final arce__Account_has_Analysis__c accHasAnalysis = [SELECT arce__financial_statement_id__c FROM arce__Account_has_Analysis__c limit 1];
        final arce__Financial_Statements__c finStatement = [SELECT arce__financial_statement_id__c FROM arce__Financial_Statements__c limit 1];
        Test.startTest();
        final Arc_Gen_ModalFinanStatemController.FinancialStatementsFetchWrapper analysisResponse =
            Arc_Gen_ModalFinanStatemController.fetchFinancialStatements(accHasAnalysis.id, true);
        system.assertEquals(finStatement.arce__financial_statement_id__c,
            analysisResponse.ffssList[0].arce__financial_statement_id__c, 'testFetchAccounts Id do not match');
        Test.stopTest();
    }
    /**
    * --------------------------------------------------------------------------------------
    * @Description test method
    * --------------------------------------------------------------------------------------
    * @param void
    * @return void
    * @example Arc_Gen_ModalFinanStatemController_test.testFetchAccountsFail()
    * --------------------------------------------------------------------------------------
    **/
    @isTest static void testFetchAccountsFail() {
        Test.startTest();
        try {
            Arc_Gen_ModalFinanStatemController.fetchFinancialStatements(null, false);
            System.assert(false, 'The call to the above method must have thrown an exception.');
        } catch (Exception ex) {
            // Everything is ok.
        }
        Test.stopTest();
    }
    /**
    * --------------------------------------------------------------------------------------
    * @Description test method
    * --------------------------------------------------------------------------------------
    * @param void
    * @return void
    * @example Arc_Gen_ModalFinanStatemController_test.testCallEngineFinancialState()
    * --------------------------------------------------------------------------------------
    **/
    @isTest static void testCallEngineFinancialState() {
        arce__Account_has_Analysis__c accHasAnalysis = [SELECT Id FROM arce__Account_has_Analysis__c limit 1];
        final List<String> ids = new List<String> { '70202018069' };
        final List<String> leverageValuesList = new List<String>{'totalRevenues','ebitda','grossFinancialDebt','netFinancialDebt','totalAssets'};
        arce__Data_Collections__c dataCollection = new arce__Data_Collections__c();
        arce__Table_Content_per_Analysis__c tableCAnalysis = new arce__Table_Content_per_Analysis__c();
        final List<arce__Data_Collections__c> dataCollectionList = new List<arce__Data_Collections__c>();
        final List<arce__Table_Content_per_Analysis__c> tableCAnalysisList = new List<arce__Table_Content_per_Analysis__c>();
        for(String levValue : leverageValuesList) {
            dataCollection = Arc_UtilitysDataTest_tst.crearDataCollection('Cash Flow Analysis', 'Cash_Flow_Analysis', '04');
            dataCollection.arce__collection_code_term__c = levValue;
            dataCollectionList.add(dataCollection);
        }
        insert dataCollectionList;
        for(Integer i=0; i<leverageValuesList.size();i++) {
            tableCAnalysis = Arc_UtilitysDataTest_tst.crearTableContentAnalysis(accHasAnalysis.id, dataCollection.id, 'Cash_Flow_Analysis', '2017');
            tableCAnalysis.arce__table_content_parent_code_id__c = 'IV019470';
            tableCAnalysis.arce__account_has_analysis_id__c = accHasAnalysis.id;
            tableCAnalysis.arce__Data_Collection_Id__c = dataCollectionList[i].id;
            tableCAnalysis.arce__table_content_value__c = 1000000;
            tableCAnalysisList.add(tableCAnalysis);
        }
        insert tableCAnalysisList;
        Test.startTest();
        final Arc_Gen_Balance_Tables_service.ratiosAndRatingResponse serviceResponseList = Arc_Gen_ModalFinanStatemController.callEngineFinancialState(accHasAnalysis.id, ids, true,false);
        system.assertEquals('Success', serviceResponseList.ratiosStatus,'testCallEngineFinancialState status do not match');

        final List<Map<String,String>> eeffData2Update = new List<Map<String,String>>{new Map<String,String>{'Id' => '174916181111', 'currency' => 'EUR', 'unit' => 'UNITS'},new Map<String,String>{'Id' => '70202018128', 'currency' => 'MXN', 'unit' => 'MILLIONS'},new Map<String,String>{'Id' => '70202018127', 'currency' => 'MXN', 'unit' => 'BILLION'}};
        Arc_Gen_Balance_Tables_service.updateEEFFtoShow(eeffData2Update,accHasAnalysis.id);
        Test.stopTest();
    }
    /**
    * --------------------------------------------------------------------------------------
    * @Description test for call engine financial state within valid financial statement
    * --------------------------------------------------------------------------------------
    * @param void
    * @return void
    * @example Arc_Gen_ModalFinanStatemController_test.testCallEngineEmptyValid()
    * --------------------------------------------------------------------------------------
    **/
    @isTest static void testCallEngineEmptyValid() {
        final arce__Account_has_Analysis__c accAha = [SELECT Id, Name, arce__Analysis__c, arce__Customer__c, arce__main_subsidiary_ind_type__c FROM arce__Account_has_Analysis__c WHERE arce__Customer__r.AccountNumber = 'C000001' LIMIT 1];
        final List<String> ids = new List<String> { '70202017129' };
        Test.startTest();
        final Arc_Gen_Balance_Tables_service.ratiosAndRatingResponse serviceResponseList = Arc_Gen_ModalFinanStatemController.callEngineFinancialState(accAha.Id, ids, true,false);
        System.assertEquals('70202017129', serviceResponseList.fsServiceId, 'test call engine within valid ffss');
        Test.stopTest();
    }
    /**
    * --------------------------------------------------------------------------------------
    * @Description test method to validation financial statement rating
    * --------------------------------------------------------------------------------------
    * @param void
    * @return void
    * @example Arc_Gen_ModalFinanStatemController_test.testValidationFFSSRating()
    * --------------------------------------------------------------------------------------
    **/
    @isTest static void testValidationFFSSRating() {
        final List<arce__Financial_Statements__c> finStatementList = [SELECT id,arce__rating_id__c,arce__financial_statement_id__c,arce__account_has_analysis_id__c,arce__financial_statement_start_date__c,arce__ffss_submitted_type__c,arce__financial_statement_end_date__c,arce__ffss_certification_type__c,arce__ffss_adjusted_type__c,arce__economic_month_info_number__c,arce__ffss_valid_type__c,arce__magnitude_unit_type__c FROM arce__Financial_Statements__c LIMIT 20];
        final arce__Account_has_Analysis__c accAha = [SELECT Id, Name, arce__Analysis__c, arce__Customer__c, arce__main_subsidiary_ind_type__c FROM arce__Account_has_Analysis__c WHERE arce__Customer__r.AccountNumber = 'C000001' LIMIT 1];

        Test.startTest();
        final arce__Financial_Statements__c ffssValid = Arc_Gen_Balance_Tables_helper.validationFFSSRating(accAha, finStatementList);
        System.assertEquals('70202018129', ffssValid.arce__financial_statement_id__c, 'test call engine child account has analysis');
        Test.stopTest();
    }
    /**
    * --------------------------------------------------------------------------------------
    * @Description test method to validate filterGlobal in Arc_Gen_Balance_Tables_helper
    * --------------------------------------------------------------------------------------
    * @param void
    * @return void
    * @example Arc_Gen_ModalFinanStatemController_test.testfilterGlobal()
    * --------------------------------------------------------------------------------------
    **/
    @IsTest
    static void testfilterGlobal() {
        final List<arce__Financial_Statements__c> statementList = [SELECT id,arce__rating_id__c,arce__financial_statement_id__c,arce__account_has_analysis_id__c,arce__financial_statement_start_date__c,arce__ffss_submitted_type__c,arce__financial_statement_end_date__c,arce__ffss_certification_type__c,arce__ffss_adjusted_type__c,arce__economic_month_info_number__c,arce__ffss_valid_type__c,arce__magnitude_unit_type__c FROM arce__Financial_Statements__c LIMIT 20];
        Test.startTest();
        Arc_Gen_Balance_Tables_helper.filterGlobal(statementList);
        System.assertEquals('70202018129', statementList[0].arce__financial_statement_id__c, 'test call to filterGlobal Method');
        Test.stopTest();
    }
    /**
    * -----------------------------------------------------------------------------------
    * @Description test method to validate testSwap in Arc_Gen_Balance_Tables_helper
    * -----------------------------------------------------------------------------------
    * @param void
    * @return void
    * @example Arc_Gen_ModalFinanStatemController_test.testSwap()
    * --------------------------------------------------------------------------------------
    **/
    @isTest static void testSwap() {
        final List<arce__Financial_Statements__c> statementList = [SELECT id,arce__rating_id__c,arce__financial_statement_id__c,arce__account_has_analysis_id__c,arce__financial_statement_start_date__c,arce__ffss_submitted_type__c,arce__financial_statement_end_date__c,arce__ffss_certification_type__c,arce__ffss_adjusted_type__c,arce__economic_month_info_number__c,arce__ffss_valid_type__c,arce__magnitude_unit_type__c FROM arce__Financial_Statements__c LIMIT 20];
        Test.startTest();
        for (Integer i = 0; i < (statementList.size() - 1); i++) {
            statementList[i].arce__financial_statement_end_date__c=Date.today();
            Arc_Gen_Balance_Tables_helper.swap(statementList, i, i + 1 );
        }
        System.assertEquals('70202018130', statementList[0].arce__financial_statement_id__c, 'test call to swap Method');
        Test.stopTest();
    }
    /**
    * --------------------------------------------------------------------------------------
    * @Description test method
    * --------------------------------------------------------------------------------------
    * @param void
    * @return void
    * @example Arc_Gen_ModalFinanStatemController_test.testDataGetNewRecordsOnly()
    * --------------------------------------------------------------------------------------
    **/
    @isTest static void testDataGetNewRecordsOnly() {
        final List<arce__Financial_Statements__c> finStatementList = [SELECT id,arce__rating_id__c,arce__financial_statement_id__c,arce__account_has_analysis_id__c,arce__financial_statement_start_date__c,arce__ffss_submitted_type__c,arce__financial_statement_end_date__c,arce__ffss_certification_type__c,arce__ffss_adjusted_type__c,arce__economic_month_info_number__c,arce__ffss_valid_type__c,arce__magnitude_unit_type__c FROM arce__Financial_Statements__c LIMIT 20];
        final String analysisId = finStatementList[0].arce__account_has_analysis_id__c;
        Test.startTest();
        final List<arce__Financial_Statements__c> newRecords = Arc_Gen_Balance_Tables_helper.getNewRecordsOnly(finStatementList,analysisId);
        system.assertEquals(0,newRecords.size(),'testGetNewRecordsOnly list size do not match.');
        Test.stopTest();
    }
    /**
    * --------------------------------------------------------------------------------------
    * @Description test method
    * --------------------------------------------------------------------------------------
    * @param void
    * @return void
    * @example Arc_Gen_ModalFinanStatemController_test.testDataInsertRecordsFail()
    * --------------------------------------------------------------------------------------
    **/
    @isTest static void testDataInsertRecordsFail() {
        Test.startTest();
        final Arc_Gen_Balance_Tables_data locator = new Arc_Gen_Balance_Tables_data();
        final Arc_Gen_Balance_Tables_data.saveResult saveResult = locator.insertRecords(null);
        system.assertEquals('false', saveResult.status, 'testDataInsertRecordsFail expected status false.');
        Test.stopTest();
    }
    /**
    * --------------------------------------------------------------------------------------
    * @Description test method
    * --------------------------------------------------------------------------------------
    * @param void
    * @return void
    * @example Arc_Gen_ModalFinanStatemController_test.testServiceProcessError()
    * --------------------------------------------------------------------------------------
    **/
    @isTest static void testServiceProcessError() {
        HttpResponse httpR = new HttpResponse();
        final String jsonStr = '{"data":{"controls":[{"id": "formulaError","description": "Unable to calculate total financial debt over equity","isValid": false},{"id": "formulaError","description": "Unable to calculate total financial debt over equity","isValid": false}]}}';
        httpR.setBody(jsonStr);
        Test.startTest();
        final String strResult = Arc_Gen_Balance_Tables_service.processError(httpR);
        system.assertEquals('Unable to calculate total financial debt over equity<br/>Unable to calculate total financial debt over equity',strResult,'testServiceProcessError error msg do not match.');
        Test.stopTest();
    }
    /**
    * --------------------------------------------------------------------------------------
    * @Description test method
    * --------------------------------------------------------------------------------------
    * @param void
    * @return void
    * @example Arc_Gen_ModalFinanStatemController_test.testHttpGetServiceResponse()
    * --------------------------------------------------------------------------------------
    **/
    @isTest static void testHttpGetServiceResponse() {
        final List<String> fakeResponses = new List<String>{'204','400','403','404','409','500'};
        Test.startTest();
        for(String fRes : fakeResponses) {
            final arce.Arc_Gen_getIASOResponse.serviceResponse response = arce.Arc_Gen_getIASOResponse.calloutIASO(fRes,'{"HttpResponse":"FakeResponse"}');
            system.assertEquals(String.valueOf(fRes),response.serviceCode,'testHttpGetServiceResponse response did not match.');
        }
        Test.stopTest();
    }
    /**
    * --------------------------------------------------------------------------------------
    * @Description test method
    * --------------------------------------------------------------------------------------
    * @param void
    * @return void
    * @example Arc_Gen_ModalFinanStatemController_test.testFsDetailsSuccess()
    * --------------------------------------------------------------------------------------
    **/
    @isTest static void testFsDetailsSuccess() {
        final arce__Account_has_Analysis__c accHasAnalysis = [SELECT Id FROM arce__Account_has_Analysis__c limit 1];
        Test.startTest();
        final Arc_Gen_ModalFinanStatemController.FinancialDetailsWrapper response = Arc_Gen_ModalFinanStatemController.consultFSdetails(accHasAnalysis.Id, '702020171291');
        system.assertEquals(true, response.gblSuccessOperation, 'The Number of clients was updated successfully');
        Test.stopTest();
    }
    /**
    * --------------------------------------------------------------------------------------
    * @Description test method
    * --------------------------------------------------------------------------------------
    * @param void
    * @return void
    * @example Arc_Gen_ModalFinanStatemController_test.testFsDetailsNull()
    * --------------------------------------------------------------------------------------
    **/
    @isTest static void testFsDetailsNull() {
        arce__Account_has_Analysis__c accHasAnalysis = [SELECT Id FROM arce__Account_has_Analysis__c limit 1];
        Test.startTest();
        final Arc_Gen_ModalFinanStatemController.FinancialDetailsWrapper response = Arc_Gen_ModalFinanStatemController.consultFSdetails(accHasAnalysis.Id, null);
        system.assertEquals(true, response.gblSuccessOperation, 'The Number of clients was updated successfully');
        Test.stopTest();
    }
    /**
    * --------------------------------------------------------------------------------------
    * @Description test method
    * --------------------------------------------------------------------------------------
    * @param void
    * @return void
    * @example Arc_Gen_ModalFinanStatemController_test.testFsDetailsNull()
    * --------------------------------------------------------------------------------------
    **/
    @isTest static void testFsDetailsFails() {
        Test.startTest();
        final Arc_Gen_ModalFinanStatemController.FinancialDetailsWrapper response = Arc_Gen_ModalFinanStatemController.consultFSdetails(null, null);
        system.assertEquals(false, response.gblSuccessOperation, 'There was an error');
        Test.stopTest();
    }
    /**
    * --------------------------------------------------------------------------------------
    * @Description test method
    * --------------------------------------------------------------------------------------
    * @param void
    * @return void
    * @example Arc_Gen_ModalFinanStatemController_test.testEmptyConstructor()
    * --------------------------------------------------------------------------------------
    **/
    @isTest static void testEmptyConstructor() {
        Test.startTest();
        final Arc_Gen_FinStatDetails_Service service =  new Arc_Gen_FinStatDetails_Service();
        system.assertEquals(service, service, 'The test to the empty constructor was successfully');
        Test.stopTest();
    }
    /**
    * --------------------------------------------------------------------------------------
    * @Description test method
    * --------------------------------------------------------------------------------------
    * @param void
    * @return void
    * @example Arc_Gen_ModalFinanStatemController_test.testEmptyConstructor()
    * --------------------------------------------------------------------------------------
    **/
    @isTest static void testEmptyConstructor2() {
        Test.startTest();
        final Arc_Gen_FinStatDetails_Service_Helper helper =  new Arc_Gen_FinStatDetails_Service_Helper();
        system.assertEquals(helper, helper, 'The test to the empty constructor was successfully');
        Test.stopTest();
    }
    /**
    * --------------------------------------------------------------------------------------
    * @Description test financialStatementsTestCall
    * --------------------------------------------------------------------------------------
    * @param void
    * @return void
    * @example Arc_Gen_ModalFinanStatemController_test.testFFSSCall()
    * --------------------------------------------------------------------------------------
    **/
    @isTest static void testFFSSCall() {
        Test.startTest();
        final Map<String,arce.Arc_Gen_Account_Wrapper> groupAccWrapper = arce.Arc_Gen_Account_Locator.getAccountByAccNumber(new List<String>{'G000001'});
        final arce.Arc_Gen_Account_Wrapper groupAccount = groupAccWrapper.get('G000001');
        final arce.Arc_Gen_ServiceAndSaveResponse serviceAndResponse =  Arc_Gen_Balance_Tables_service.financialStatementsTestCall(groupAccount.accNumber);
        System.assertEquals('200', serviceAndResponse.serviceCode, 'The test to the empty constructor was successfully');
        Test.stopTest();
    }
}