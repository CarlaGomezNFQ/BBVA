/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_RatingStudiosUpdateTable
* @Author   Eduardo Efraín Hernández Rendón  eduardoefrain.hernandez.contractor@bbva.com
* @Date     Created: 28/10/2019
* @Group    ARCE
* -----------------------------------------------------------------------------------------------
* @Description Tests the classes getRatingDataService and RatingVariablesTable
* -----------------------------------------------------------------------------------------------
* @Changes
*
* |28/10/2019 eduardoefrain.hernandez.contractor@bbva.com
*             Class creation.
* |23/7/2019 eduardoefrain.hernandez.contractor@bbva.com
*             Added comments, localism and updates test coverage
* |26/9/2019 javier.soto.carrascosa@bbva.com
*             Remove incorrect test method
* |21/10/2019 eduardoefrain.hernandez.contractor@bbva.com
*             Update test coverage for studies and overlay
* |28/10/2019 eduardoefrain.hernandez.contractor@bbva.com
*             Add static service parameters
* |2019-12-02 german.sanchez.perez.contractor@bbva.com | franciscojavier.bueno@bbva.com
*             Api names modified with the correct name on business glossary
* |2020-01-08 javier.soto.carrascosa@bbva.com
*             Adapt test classess with account wrapper and setupaccounts
* |24/01/2020 juanmanuel.perez.ortiz.contractor@bbva.com
*             Remove logic static parameters to ASO services
* |2020-04-03 cesaroctavio.villanueva.cebal@bbva.com
*             Added value to correctly validate service class
* |2020-04-14 mariohumberto.ramirez.contractor@bbva.com
*             update test class
* |2020-04-28 eduardoefrain.hernandez.contractor@bbva.com
*             Add testingNoAdjustments test method
* |2020-06-25 juanmanuel.perez.ortiz.contractor@bbva.com
*             Added test method called getOverrideVariableTest
* |2020-06-29 mariohumberto.ramirez.contractor@bbva.com
*             Deleted testingsetupRatingPrev2 and testingsetupRatingPrev3 methods
* |2020-07-02 eduardoefrain.hernandez.contractor@bbva.com
*             Add adjustments testing without iaso metadata mocks
* |2020-07-07 juanmanuel.perez.ortiz.contractor@bbva.com
*             Create constants called CALCULATION and RESPONSE500 and remove unused variables
* |17/09/2020 eduardoefrain.hernandez.contractor@bbva.com
*             Add testGetAnalysisError, testQualitativeQuestions methods
* |2021-03-12 eduardoefrain.hernandez.contractor@bbva.com
*             Add arce__rating_modifier_adj_type__c field in rating variable init
* -----------------------------------------------------------------------------------------------
*/
@SuppressWarnings('sf:TooManyMethods')
@isTest
public class Arc_Gen_getRatingDataService_test {
    /**
    * @Description: String with external id of test group
    */
    static final string GROUP_ID = 'G000001';
    /**
    * @Description: String with literal CALCULATION
    */
    static final string CALCULATION = 'CALCULATION';
    /**
    * @Description: String with literal 500
    */
    static final string RESPONSE_500 = '500';
    /**
    * @Description: String with literal TestAna
    */
    static final string ARCENAME = 'TestAna';
    /**
    * @Description: String with literal Arce
    */
    /**
    * @Description: String with literal Arce
    */
    static final string ARCE = 'Arce';
    /**
    * @Description: String with literal Arce
    */
    static final String FFSS_ERROR = '{"messages":[{"code":"missingData","message":"Unable to call detail of financial statement service","parameters":[],"type":"CRITICAL"}]}';
    /**
    * @Description: String with literal Arce
    */
    static final String TIMEOUT_ERROR = '{"messages":[{"code":"errorRestConnector","message":"Se ha producido un error en el conector REST: Hard timeout reached. Request aborted [Service execution timeout: 120000 ms - Elapsed time: 10046 ms - Remaining time: 109954 ms - Min remaining time: 5 ms][Invocation timeout: 10000 ms].","parameters":[{"name":"Hard timeout reached. Request aborted [Service execution timeout: 120000 ms - Elapsed time: 10046 ms - Remaining time: 109954 ms - Min remaining time: 5 ms][Invocation timeout: 10000 ms]"}],"type":"FATAL"}]}';
    /**
    * @Description: String with literal Arce
    */
    static final String RISK_ERROR = '{"messages":[{"code":"missingData","message":"Unable to call risk-assessment service","parameters":[],"type":"CRITICAL"}]}';
    /**
    * @Description: String with literal Arce
    */
    static final String CUST_ERROR = '{"messages":[{"code":"missingData","message":"Unable to call customer service","parameters":[],"type":"CRITICAL"},{"code":"invalidLocalCalculation","message":"Unable to call local services","parameters":[],"type":"CRITICAL"}]}';
    /**
    * @Description: String with literal Arce
    */
    static final String PERS_ERROR = '{"messages":[{"code":"missingData","message":"Unable to persist rating","parameters":[],"type":"CRITICAL"}]}';
    /**
    * @Description: String with literal Arce
    */
    static final String B_AG_ERROR = '{"messages":[{"code":"mandatoryParametersMissingExplicit","message":"Parámetros obligatorios no informados: businessAgent.id","parameters":[{"name":"businessAgent.id"}],"type":"FATAL"}]}';
    /**
    * @Description: String with literal Arce
    */
    static final String BR_ID_ERROR = '{"messages":[{"code":"mandatoryParametersMissingExplicit","message":"Parámetros obligatorios no informados: bank.branch.id","parameters":[{"name":"bank.branch.id"}],"type":"FATAL"}]}';
    /**
    * @Description: String with literal Arce
    */
    static final String BR_LV_ERROR = '{"messages":[{"code":"mandatoryParametersMissingExplicit","message":"Parámetros obligatorios no informados: bank.branch.level.id","parameters":[{"name":"bank.branch.level.id"}],"type":"FATAL"}]}';
    /**
    * @Description: String with literal Arce
    */
    static final String BANKID_ERROR = '{"messages":[{"code":"mandatoryParametersMissingExplicit","message":"Parámetros obligatorios no informados: bank.id","parameters":[{"name":"bank.id"}],"type":"FATAL"}]}';
    /**
    * @Description: String with literal Arce
    */
    static final String OP_ERROR = '{"messages":[{"code":"mandatoryParametersMissingExplicit","message":"Parámetros obligatorios no informados: bank.id","parameters":[{"name":"sector.id"}],"type":"FATAL"}]}';
    /**
    * @Description: String with literal Arce
    */
    static final String OV_ERROR = '{"messages":[{"code":"invalidLocalCalculation","message":"Unable to calculate override","parameters":[],"type":"CRITICAL"}]}';

    /**
    * --------------------------------------------------------------------------------------
    * @Description setup test
    * --------------------------------------------------------------------------------------
    * @Author   javier.soto.carrascosa@bbva.com
    * @Date     Created: 2020-01-08
    * @param void
    * @return void
    * @example setup()
    * --------------------------------------------------------------------------------------
    **/
    @testSetup
    public static void setup() {
        Arc_UtilitiesToTest_tst.setupAcccounts();
    }
    /**
    * --------------------------------------------------------------------------------------
    * @Description Method to setup a service response
    * --------------------------------------------------------------------------------------
    * @Author   eduardoefrain.hernandez.contractor@bbva.com
    * @Date     Created: 2020-06-09
    * @param void
    * @return void
    * @example setResponse()
    * --------------------------------------------------------------------------------------
    **/
    public static Arc_Gen_getIASOResponse.serviceResponse setResponse(String serviceCode, Map<String, Object> serviceResponse) {
        final Arc_Gen_getIASOResponse.serviceResponse response = new Arc_Gen_getIASOResponse.serviceResponse();
        response.serviceCode = serviceCode;
        response.serviceResponse = serviceResponse;
        Return response;
    }

    /**
    * --------------------------------------------------------------------------------------
    * @Description Test setup method
    * --------------------------------------------------------------------------------------
    * @Author   eduardoefrain.hernandez.contractor@bbva.com
    * @param String name - Name of the arce
    * @return  arce__Analysis__c
    * @example setAnalysis(String name)
    * --------------------------------------------------------------------------------------
    **/
    public static arce__Analysis__c setAnalysis(String name) {
        final arce__Analysis__c analysis = new arce__Analysis__c(
            Name = name
        );
        Insert analysis;
        Return analysis;
    }
    /**
    * --------------------------------------------------------------------------------------
    * @Description Test setup method
    * --------------------------------------------------------------------------------------
    * @Author   eduardoefrain.hernandez.contractor@bbva.com
    * @param String clientId - Id of the account
    * @param String analysisId - Id of the arce
    * @param String validFs - Id of valid FS
    * @return arce__Account_has_Analysis__c
    * @example setAnalyzedClient(String clientId,String analysisId,String validFs)
    * --------------------------------------------------------------------------------------
    **/
    public static arce__Account_has_Analysis__c setAnalyzedClient(String clientId,String analysisId,String validFs) {
        final arce__Account_has_Analysis__c analyzedClient = new arce__Account_has_Analysis__c(
            arce__Customer__c = clientId,
            arce__Analysis__c = analysisId,
            arce__ffss_for_rating_id__c = validFs,
            arce__branch_id__c = '0002'
        );
        Insert analyzedClient;
        Return analyzedClient;
    }
    /**
    * --------------------------------------------------------------------------------------
    * @Description Test setup method
    * --------------------------------------------------------------------------------------
    * @Author   eduardoefrain.hernandez.contractor@bbva.com
    * @param String accName - Name of the account
    * @param String accNumber - Number of the account
    * @param String analysisName - Name of the arce
    * @param String validFs - Id of valid FS
    * @return arce__Account_has_Analysis__c
    * @example getAnalyzedClient(String accName,String accNumber,String analysisName,String validFs)
    * --------------------------------------------------------------------------------------
    **/
    public static arce__Account_has_Analysis__c getAnalyzedClient(String accNumber,String analysisName,String validFs) {
        final Map<String,Arc_Gen_Account_Wrapper> groupAccWrapper = Arc_Gen_Account_Locator.getAccountByAccNumber(new List<String>{accNumber});
        final Arc_Gen_Account_Wrapper groupAccount = groupAccWrapper.get(accNumber);
        final arce__Analysis__c analysis = setAnalysis(analysisName);
        Return setAnalyzedClient(groupAccount.accId,analysis.Id,validFs);
    }
    /**
    * --------------------------------------------------------------------------------------
    * @Description Test setup method
    * --------------------------------------------------------------------------------------
    * @Author   eduardoefrain.hernandez.contractor@bbva.com
    * @param String ratingId - Id of the rating
    * @param String validInd - Valid indicator
    * @return arce__Financial_Statements__c
    * @example setFFSS(String ratingId, String validInd)
    * --------------------------------------------------------------------------------------
    **/
    public static arce__Financial_Statements__c setFFSS(String ratingId, String validInd) {
        final arce__Financial_Statements__c ffss = new arce__Financial_Statements__c(
            arce__ffss_valid_type__c = validInd,
            arce__ffss_valid_for_rating_type__c = validInd,
            arce__financial_statement_id__c = '70252018129',
            arce__rating_id__c = ratingId
        );
        Insert ffss;
        Return ffss;
    }
    /**
    * --------------------------------------------------------------------------------------
    * @Description Test setup method
    * --------------------------------------------------------------------------------------
    * @Author   eduardoefrain.hernandez.contractor@bbva.com
    * @param void
    * @return arce__rating__c
    * @example setRating()
    * --------------------------------------------------------------------------------------
    **/
    public static arce__rating__c setRating() {
        final arce__rating__c rating = new arce__rating__c();
        Insert rating;
        Return rating;
    }
    /**
    * --------------------------------------------------------------------------------------
    * @Description Test setup method
    * --------------------------------------------------------------------------------------
    * @Author   eduardoefrain.hernandez.contractor@bbva.com
    * @param String analysisId - arce id
    * @param String ratingId - id of the rating
    * @return arce__rating_variables_detail__c
    * @example setRatingVariable(String analysisId,String ratingId)
    * --------------------------------------------------------------------------------------
    **/
    public static arce__rating_variables_detail__c setRatingVariable(String analysisId,String ratingId) {
        final arce__rating_variables_detail__c ratingVariable = new arce__rating_variables_detail__c(
            arce__account_has_analysis_id__c = analysisId,
            arce__rating_id__c = ratingId,
            arce__rating_modifier_adj_type__c = 'OVERRIDE'
        );
        Insert ratingVariable;
        Return ratingVariable;
    }
    /**
    * --------------------------------------------------------------------------------------
    * @Description Test setup method
    * --------------------------------------------------------------------------------------
    * @Author   eduardoefrain.hernandez.contractor@bbva.com
    * @param void
    * @return void
    * @example testingDML()
    * --------------------------------------------------------------------------------------
    **/
    @isTest
    public static void testingDML() {
        final Arc_Gen_RatingGlobal_data locator = new Arc_Gen_RatingGlobal_data();
        Arc_Gen_RatingGlobal_data.saveResult result = new Arc_Gen_RatingGlobal_data.saveResult();
        final String longName = '12345678901234567890121234567890123456789012123456789012345678901212345678901234567890121234567890123456789012';
        final List<arce__analysis__c> arceIns = new List<arce__analysis__c>{new arce__analysis__c(Name = longName)};
        final List<arce__analysis__c> arceUpd = new List<arce__analysis__c>{new arce__analysis__c(Name='Test1')};
        Insert arceUpd;
        arceUpd[0].Name = longName;
        test.startTest();
        result = locator.insertRecords(arceIns);
        locator.updateRecords(arceUpd);
        System.assertEquals('false', result.status, 'The DML status is wrong because of null parameter, the response is false');
        test.stopTest();
    }
    /**
    * --------------------------------------------------------------------------------------
    * @Description Test setup method
    * --------------------------------------------------------------------------------------
    * @Author   eduardoefrain.hernandez.contractor@bbva.com
    * @param void
    * @return void
    * @example testingConstructor()
    * --------------------------------------------------------------------------------------
    **/
    @isTest
    public static void testingConstructor() {
        Test.startTest();
        final Arc_Gen_Rating_data constructor = new Arc_Gen_Rating_data();
        System.assertEquals(constructor, constructor,'Empty constructor');
        Test.stopTest();
    }
    /**
    * --------------------------------------------------------------------------------------
    * @Description Test setup method
    * --------------------------------------------------------------------------------------
    * @Author   eduardoefrain.hernandez.contractor@bbva.com
    * @param void
    * @return void
    * @example testingConstructor()
    * --------------------------------------------------------------------------------------
    **/
    @isTest
    public static void testingConstructorHelper() {
        Test.startTest();
        final Arc_Gen_RatingGlobal_helper constHelper = new Arc_Gen_RatingGlobal_helper();
        System.assertEquals(constHelper, constHelper,'Empty helper constructor');
        Test.stopTest();
    }
    /**
    * --------------------------------------------------------------------------------------
    * @Description Test setup method
    * --------------------------------------------------------------------------------------
    * @Author   eduardoefrain.hernandez.contractor@bbva.com
    * @param void
    * @return void
    * @example testingStageRating()
    * --------------------------------------------------------------------------------------
    **/
    @isTest
    public static void errorManagement() {

        test.startTest();
        final String response = JSON.serialize(Arc_Gen_RatingErrorManagement.processErrorData(setResponse(RESPONSE_500, (Map<String, Object>)JSON.deserializeUntyped(FFSS_ERROR)), CALCULATION));
        Arc_Gen_RatingErrorManagement.processErrorData(setResponse(RESPONSE_500, (Map<String, Object>)JSON.deserializeUntyped(TIMEOUT_ERROR)), CALCULATION);
        Arc_Gen_RatingErrorManagement.processErrorData(setResponse(RESPONSE_500, (Map<String, Object>)JSON.deserializeUntyped(RISK_ERROR)), CALCULATION);
        Arc_Gen_RatingErrorManagement.processErrorData(setResponse(RESPONSE_500, (Map<String, Object>)JSON.deserializeUntyped(CUST_ERROR)), CALCULATION);
        Arc_Gen_RatingErrorManagement.processErrorData(setResponse(RESPONSE_500, (Map<String, Object>)JSON.deserializeUntyped(PERS_ERROR)), CALCULATION);
        Arc_Gen_RatingErrorManagement.processErrorData(setResponse(RESPONSE_500, (Map<String, Object>)JSON.deserializeUntyped(B_AG_ERROR)), CALCULATION);
        Arc_Gen_RatingErrorManagement.processErrorData(setResponse(RESPONSE_500, (Map<String, Object>)JSON.deserializeUntyped(BR_ID_ERROR)), CALCULATION);
        Arc_Gen_RatingErrorManagement.processErrorData(setResponse(RESPONSE_500, (Map<String, Object>)JSON.deserializeUntyped(BR_LV_ERROR)), CALCULATION);
        Arc_Gen_RatingErrorManagement.processErrorData(setResponse(RESPONSE_500, (Map<String, Object>)JSON.deserializeUntyped(BANKID_ERROR)), CALCULATION);
        Arc_Gen_RatingErrorManagement.processErrorData(setResponse(RESPONSE_500, (Map<String, Object>)JSON.deserializeUntyped(OP_ERROR)), 'VALIDATION');
        Arc_Gen_RatingErrorManagement.processErrorData(setResponse(RESPONSE_500, (Map<String, Object>)JSON.deserializeUntyped(OV_ERROR)), 'OVERRIDE');
        System.assertNotEquals('', response, 'Error message that the user views');
        test.stopTest();
    }
    /**
    * --------------------------------------------------------------------------------------
    * @Description Test setup method
    * --------------------------------------------------------------------------------------
    * @Author   eduardoefrain.hernandez.contractor@bbva.com
    * @param void
    * @return void
    * @example testingConstructor()
    * --------------------------------------------------------------------------------------
    **/
    @isTest
    public static void errorManagmntConst() {
        Test.startTest();
        final Arc_Gen_RatingErrorManagement constructor = new Arc_Gen_RatingErrorManagement();
        System.assertEquals(constructor, constructor,'Empty helper constructor');
        Test.stopTest();
    }
    /**
    * --------------------------------------------------------------------------------------
    * @Description Test method for getOverrideVariable
    * --------------------------------------------------------------------------------------
    * @Author   juanmanuel.perez.ortiz.contractor@bbva.com
    * @param void
    * @return void
    * @example getOverrideVariableTest()
    * --------------------------------------------------------------------------------------
    **/
    @isTest
    public static void getOverrideVariableTest() {
        arce__rating_variables_detail__c testVariable = new arce__rating_variables_detail__c();
        final User userAdmin = Arc_UtilitiesToTest_tst.crearUsuario('UserAdmin','System Administrator','');
        userAdmin.federationIdentifier = 'XME0514';
        Insert userAdmin;
        final List<sObject> iasoCnfList = Arc_UtilitiesToTest_tst.crearIasoUrlsCustomSettings();
        insert iasoCnfList;
        final arce__rating__c rating = setRating();
        final arce__Financial_Statements__c ffss = setFFSS(rating.Id, '1');
        ffss.arce__previous_valid__c = false;
        final arce__Account_has_Analysis__c accHasAn = getAnalyzedClient(GROUP_ID,'54321',ffss.Id);
        ffss.arce__account_has_analysis_id__c = accHasAn.Id;
        update ffss;
        final arce__rating_variables_detail__c testVariable1 = setRatingVariable(accHasAn.Id,rating.Id);
        test.startTest();
        System.runAs(userAdmin) {
            testVariable = Arc_Gen_RatingGlobal_data.getOverrideVariable(accHasAn.Id);
        }
        system.assertEquals(testVariable1.Id, testvariable.Id, 'id match succesfully');
        Test.stopTest();
    }
    /**
    * --------------------------------------------------------------------------------------
    * @Description Test method to Arc_Gen_RatingGlobal_data
    * --------------------------------------------------------------------------------------
    * @Author   Sai Jordana - saimassimilianno.jordana.contractor@bbva.com / BBVA ARCE
    * @Date     Created: 29/10/2020
    * @param void
    * @return void
    * @example Arc_Gen_getRatingDataService_test.updateAndDeleteTest ()
    * --------------------------------------------------------------------------------------
    **/
    @isTest
    public static void updateAndDeleteTest () {
        final Arc_Gen_RatingGlobal_data locator = new Arc_Gen_RatingGlobal_data();
        final Account acc = new Account();
        acc.Name = 'TestAcc';
        acc.AccountNumber = 'CAONlXcCA_uxyJ402AA_xw';
        insert acc;

        acc.Name = 'AccNameTest';

        test.startTest();
        locator.updateRecord(acc);
        final List<sObject> recDel = new List<sObject>();
        recDel.add(acc);
        locator.deleteRecords(recDel);
        final Arc_Gen_RatingGlobal_data.saveResult updResult2 = locator.updateRecord(acc);
        System.assertEquals(updResult2.status, 'false', 'There is an error in this method: updateAndDeleteTest');
        Test.stopTest();

    }
    /**
    * --------------------------------------------------------------------------------------
    * @Description Test method to Arc_Gen_RatingGlobal_data
    * --------------------------------------------------------------------------------------
    * @Author   Sai Jordana - saimassimilianno.jordana.contractor@bbva.com / BBVA ARCE
    * @Date     Created: 29/10/2020
    * @param void
    * @return void
    * @example Arc_Gen_getRatingDataService_test.ratingVariableTest()
    * --------------------------------------------------------------------------------------
    **/
    @isTest
    public static void ratingVariableTest() {
        final Account acc = Arc_UtilitiesToTest_tst.crearCuenta('TestAcc', null, null, 'CAONlXcCA_uxyJ402AA_xw');
        insert acc;
        final arce__Analysis__c analisis = Arc_UtilitiesToTest_tst.crearArceAnalysis(ARCENAME, ARCE, acc.id);
        insert analisis;

        final arce__rating__c rating = new arce__rating__c();
        rating.arce__total_rating_score_number__c = 2547.25;
        insert rating;

        final arce__Financial_Statements__c ffss = new arce__Financial_Statements__c();
        ffss.arce__financial_statement_id__c = '70252018129';
        ffss.arce__rating_id__c = rating.Id;
        insert ffss;

        final arce__Account_has_Analysis__c aha = new arce__Account_has_Analysis__c();
        aha.arce__Analysis__c = analisis.id;
        aha.arce__Customer__c = acc.id;
        aha.arce__group_asset_header_type__c = '1';
        aha.arce__InReview__c = true;
        aha.arce__ffss_for_rating_id__r = ffss;
        insert aha;

        final Arc_Gen_RatingGlobal_data locator = new Arc_Gen_RatingGlobal_data();
        final sObject ratingVariable = locator.setRatingVariableObj();
        ratingVariable.put('arce__parent_code_number__c','2');
        ratingVariable.put('arce__account_has_analysis_id__c',aha.Id);
        ratingVariable.put('arce__rating_id__c',rating.Id);
        insert ratingVariable;

        test.startTest();
        final List<arce__rating_variables_detail__c> listToAssert = locator.getExistentVariables(aha.Id,rating.Id);
        System.assertEquals(listToAssert[0].arce__parent_code_number__c, '2', 'There is an error in this method: ratingVariableTest');
        Test.stopTest();
    }
    /**
    * --------------------------------------------------------------------------------------
    * @Description Test method to Arc_Gen_RatingGlobal_data
    * --------------------------------------------------------------------------------------
    * @Author   Sai Jordana - saimassimilianno.jordana.contractor@bbva.com / BBVA ARCE
    * @Date     Created: 29/10/2020
    * @param void
    * @return void
    * @example Arc_Gen_getRatingDataService_test.getCustomerDataTest()
    * --------------------------------------------------------------------------------------
    **/
    @isTest
    public static void getCustomerDataTest() {
        final Account acc = Arc_UtilitiesToTest_tst.crearCuenta('TestAcc', null, null, 'CAONlXcCA_uxyJ402AA_xw');
        insert acc;
        final arce__Analysis__c analisis = Arc_UtilitiesToTest_tst.crearArceAnalysis(ARCENAME, ARCE, acc.id);
        insert analisis;

        final arce__Account_has_Analysis__c aha = new arce__Account_has_Analysis__c();
        aha.arce__Analysis__c = analisis.id;
        aha.arce__Customer__c = acc.id;
        aha.arce__group_asset_header_type__c = '1';
        aha.arce__InReview__c = true;
        insert aha;

        test.startTest();
        final List<String> listToAssert = Arc_Gen_RatingGlobal_data.getCustomerData(aha.Id);
        System.assert(!listToAssert.isEmpty(), 'Error: the list is empty in this method: getCustomerDataTest');
        Test.stopTest();
    }
    /**
    * --------------------------------------------------------------------------------------
    * @Description Test method to Arc_Gen_RatingGlobal_data
    * --------------------------------------------------------------------------------------
    * @Author   Sai Jordana - saimassimilianno.jordana.contractor@bbva.com / BBVA ARCE
    * @Date     Created: 29/10/2020
    * @param void
    * @return void
    * @example Arc_Gen_getRatingDataService_test.getValidFFSSTest()
    * --------------------------------------------------------------------------------------
    **/
    @isTest
    public static void getValidFFSSTest() {
        final Arc_Gen_RatingGlobal_data locator = new Arc_Gen_RatingGlobal_data();
        final Account acc = Arc_UtilitiesToTest_tst.crearCuenta('TestAcc', null, null, 'CAONlXcCA_uxyJ402AA_xw');
        insert acc;
        final arce__Analysis__c analisis = Arc_UtilitiesToTest_tst.crearArceAnalysis(ARCENAME, ARCE, acc.id);
        insert analisis;

        final arce__Account_has_Analysis__c aha = new arce__Account_has_Analysis__c();
        aha.arce__Analysis__c = analisis.id;
        aha.arce__Customer__c = acc.id;
        aha.arce__group_asset_header_type__c = '1';
        aha.arce__InReview__c = true;
        insert aha;

        test.startTest();
        final List<arce__Financial_Statements__c> listToAssert = locator.getValidFFSS(aha.Id);
        System.assert(listToAssert.isEmpty(), 'There is an error in this method: getValidFFSSTest');
        Test.stopTest();
    }

    /**
    * --------------------------------------------------------------------------------------
    * @Description Test method to Arc_Gen_RatingGlobal_data
    * --------------------------------------------------------------------------------------
    * @Author   Sai Jordana - saimassimilianno.jordana.contractor@bbva.com / BBVA ARCE
    * @Date     Created: 29/10/2020
    * @param void
    * @return void
    * @example Arc_Gen_getRatingDataService_test.getCurrentRatingTest()
    * --------------------------------------------------------------------------------------
    **/
    @isTest
    public static void getCurrentRatingTest() {
        final Arc_Gen_RatingGlobal_data locator = new Arc_Gen_RatingGlobal_data();
        final Account acc = Arc_UtilitiesToTest_tst.crearCuenta('TestAcc', null, null, 'CAONlXcCA_uxyJ402AA_xw');
        insert acc;
        final arce__Analysis__c analisis = Arc_UtilitiesToTest_tst.crearArceAnalysis(ARCENAME, ARCE, acc.id);
        insert analisis;

        final arce__rating__c rating = new arce__rating__c();
        rating.arce__total_rating_score_number__c = 2547.25;
        insert rating;

        final arce__Financial_Statements__c ffss = new arce__Financial_Statements__c();
        ffss.arce__financial_statement_id__c = '70252018129';
        ffss.arce__rating_id__c = rating.Id;
        insert ffss;

        final arce__Account_has_Analysis__c aha = new arce__Account_has_Analysis__c();
        aha.arce__Analysis__c = analisis.id;
        aha.arce__Customer__c = acc.id;
        aha.arce__group_asset_header_type__c = '1';
        aha.arce__InReview__c = true;
        aha.arce__ffss_for_rating_id__c = ffss.Id;
        insert aha;

        test.startTest();
        final arce__rating__c ratingToAssert = locator.getCurrentRating(aha.Id);
        System.assertEquals(ratingToAssert.arce__total_rating_score_number__c, 2547.25, 'There is an error in this method: getCurrentRatingTest');
        Test.stopTest();
    }
}