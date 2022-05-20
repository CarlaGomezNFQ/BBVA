/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_RAIPButtons_Test
* @Author   Sai Jordana - saimassimilianno.jordana.contractor@bbva.com / BBVA ARCE
* @Date     Created: 29/10/2020
* @Group    ARCE
* -----------------------------------------------------------------------------------------------
* @Description test for method class Arc_Gen_RatingErrorManagement.
* -----------------------------------------------------------------------------------------------
* @Changes
*
* |29-10-2020 Sai Jordana
*             Class creation.
*/
@isTest
public with sharing class Arc_Gen_RatingErrorManagement_Test {

    /**
    * @Description: String with literal CALCULATION
    */
    public static final string CALCULATION = 'CALCULATION';
    /**
    * @Description: String with literal 500
    */
    public static final string RESPONSE_500 = '500';
    /**
    * @Description: String with Error JSON FFSS
    */
    public static final String FFSS = '{"messages":[{"code":"missingData","message":"Unable to call detail of financial statement service","parameters":[],"type":"CRITICAL"}]}';
    /**
    * @Description: String with Error JSON TIMEOUT
    */
    public static final String TIMEOUT = '{"messages":[{"code":"errorRestConnector","message":"Se ha producido un error en el conector REST: Hard timeout reached. Request aborted [Service execution timeout: 120000 ms - Elapsed time: 10046 ms - Remaining time: 109954 ms - Min remaining time: 5 ms][Invocation timeout: 10000 ms].","parameters":[{"name":"Hard timeout reached. Request aborted [Service execution timeout: 120000 ms - Elapsed time: 10046 ms - Remaining time: 109954 ms - Min remaining time: 5 ms][Invocation timeout: 10000 ms]"}],"type":"FATAL"}]}';
    /**
    * @Description: String with Error JSON RISK
    */
    public static final String RISK = '{"messages":[{"code":"missingData","message":"Unable to call risk-assessment service","parameters":[],"type":"CRITICAL"}]}';
    /**
    * @Description: String with Error JSON CUSTOMER
    */
    public static final String CUSTOMER = '{"messages":[{"code":"missingData","message":"Unable to call customer service","parameters":[],"type":"CRITICAL"},{"code":"invalidLocalCalculation","message":"Unable to call local services","parameters":[],"type":"CRITICAL"}]}';
    /**
    * @Description: String with Error JSON PERSIST
    */
    public static final String PERSIST = '{"messages":[{"code":"missingData","message":"Unable to persist rating","parameters":[],"type":"CRITICAL"}]}';
    /**
    * @Description: String with Error JSON BUSSAGENT
    */
    public static final String BUSSAGENT = '{"messages":[{"code":"mandatoryParametersMissingExplicit","message":"Parámetros obligatorios no informados: businessAgent.id","parameters":[{"name":"businessAgent.id"}],"type":"FATAL"}]}';
    /**
    * @Description: String with Error JSON BRANCHID
    */
    public static final String BRANCHID = '{"messages":[{"code":"mandatoryParametersMissingExplicit","message":"Parámetros obligatorios no informados: bank.branch.id","parameters":[{"name":"bank.branch.id"}],"type":"FATAL"}]}';
    /**
    * @Description: String with Error JSON BRACHLV
    */
    public static final String BRACHLV = '{"messages":[{"code":"mandatoryParametersMissingExplicit","message":"Parámetros obligatorios no informados: bank.branch.level.id","parameters":[{"name":"bank.branch.level.id"}],"type":"FATAL"}]}';
    /**
    * @Description: String with Error JSON BANKID
    */
    public static final String BANKID = '{"messages":[{"code":"mandatoryParametersMissingExplicit","message":"Parámetros obligatorios no informados: bank.id","parameters":[{"name":"bank.id"}],"type":"FATAL"}]}';
    /**
    * @Description: String with Error JSON OTHER
    */
    public static final String OTHER = '{"messages":[{"code":"mandatoryParametersMissingExplicit","message":"Parámetros obligatorios no informados: bank.id","parameters":[{"name":"sector.id"}],"type":"FATAL"}]}';
    /**
    * @Description: String with Error JSON OVERIDE
    */
    public static final String OVERIDE = '{"messages":[{"code":"invalidLocalCalculation","message":"Unable to calculate override","parameters":[],"type":"CRITICAL"}]}';


    /**
    * --------------------------------------------------------------------------------------
    * @Description Test setup method
    * --------------------------------------------------------------------------------------
    * @Author   eduardoefrain.hernandez.contractor@bbva.com
    * @param void
    * @return void
    * @example Arc_Gen_RatingErrorManagement_Test.errorManagementTest()
    * --------------------------------------------------------------------------------------
    **/
    @isTest
    public static void errorManagementTest() {
        new Arc_Gen_RatingErrorManagement();

        test.startTest();
        final String response = JSON.serialize(Arc_Gen_RatingErrorManagement.processErrorData(setResponse(RESPONSE_500, (Map<String, Object>)JSON.deserializeUntyped(FFSS)), CALCULATION));
        Arc_Gen_RatingErrorManagement.processErrorData(setResponse(RESPONSE_500, (Map<String, Object>)JSON.deserializeUntyped(TIMEOUT)), CALCULATION);
        Arc_Gen_RatingErrorManagement.processErrorData(setResponse(RESPONSE_500, (Map<String, Object>)JSON.deserializeUntyped(RISK)), CALCULATION);
        Arc_Gen_RatingErrorManagement.processErrorData(setResponse(RESPONSE_500, (Map<String, Object>)JSON.deserializeUntyped(CUSTOMER)), CALCULATION);
        Arc_Gen_RatingErrorManagement.processErrorData(setResponse(RESPONSE_500, (Map<String, Object>)JSON.deserializeUntyped(PERSIST)), CALCULATION);
        Arc_Gen_RatingErrorManagement.processErrorData(setResponse(RESPONSE_500, (Map<String, Object>)JSON.deserializeUntyped(BUSSAGENT)), CALCULATION);
        Arc_Gen_RatingErrorManagement.processErrorData(setResponse(RESPONSE_500, (Map<String, Object>)JSON.deserializeUntyped(BRANCHID)), CALCULATION);
        Arc_Gen_RatingErrorManagement.processErrorData(setResponse(RESPONSE_500, (Map<String, Object>)JSON.deserializeUntyped(BRACHLV)), CALCULATION);
        Arc_Gen_RatingErrorManagement.processErrorData(setResponse(RESPONSE_500, (Map<String, Object>)JSON.deserializeUntyped(BANKID)), CALCULATION);
        Arc_Gen_RatingErrorManagement.processErrorData(setResponse(RESPONSE_500, (Map<String, Object>)JSON.deserializeUntyped(OTHER)), 'VALIDATION');
        Arc_Gen_RatingErrorManagement.processErrorData(setResponse(RESPONSE_500, (Map<String, Object>)JSON.deserializeUntyped(OVERIDE)), 'OVERRIDE');
        Arc_Gen_RatingErrorManagement.processErrorData(setResponse(RESPONSE_500, (Map<String, Object>)JSON.deserializeUntyped(OVERIDE)), 'TRIAGE');
        System.assertNotEquals('', response, 'Error message that the user views');
        test.stopTest();
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
}