/*------------------------------------------------------------------
*Author:        bbva.com developers
*Project:      	ARCE - BBVA Bancomer
*Description:   This is the service layer in the obtaining of Financial Statements headers FROM service
*_______________________________________________________________________________________
*Versión    Date           	Author                              Description
*1.0        11/04/2019      ARCE's TEAM                         Created.
*1.1        30/04/2019      diego.miguel.contractor@bbva.com    Added lines to pass test
*1.2        12/06/2019      diego.miguel.contractor@bbva.com    Process 204 responses
*1.3        26/09/2019      javier.soto.carrascosa@bbva.com     Add retrieve mock for tests
*1.4        29/01/2019      javier.soto.carrascosa@bbva.com     Retrieve 201 cod for POST
*1.5        12/04/2020      javier.soto.carrascosa@bbva.com     Add new getResponseAsMap method
*1.6        18/12/2020      juanignacio.hita.contractor@bbva.comClass changed to global
*1.7        22/07/2021      juanignacio.hita.contractor@bbva.comAdd status code encryptClients
-----------------------------------------------------------------------------------------*/
global with sharing class Arc_Gen_getIASOResponse {
    /**
    * --------------------------------------------------------------------------------------
    * @Description Class that will be used to save the result of the records insertion and the response of the service
    **/
    global class ServiceResponse{
        global String serviceCode {get;set;}
        global String serviceMessage {get;set;}
        global Map<String, Object> serviceResponse {get;set;}
        global Map<String, String> serviceHeaders {get;set;}
    }
    /**
    *-------------------------------------------------------------------------------
    * @description This method calls the service.
    --------------------------------------------------------------------------------
    * @author ARCE Team
    * @date 11/04/2019
    * @param serviceName The name of the custom metadata label of the iaso instance
    * @param jsonInput The body that will be send by the service
    * @return response An HTTP instance
    * @example global static HttpResponse getServiceResponse(String serviceName,String jsonInput) {
    **/
    global static HttpResponse getServiceResponse(String serviceName,String jsonInput) {
        HttpResponse response;

        // This lines are needed to provoke fake http responses
        // This is needed because we can not use Test.setMock to test managed package methods
        // Doc: https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_classes_restful_http_testing_httpcalloutmock.htm
        List<String> fakeResponses = new List<String>{'204','400','403','404','409','500'};
        if(Test.isRunningTest() && fakeResponses.contains(serviceName)) {
            response = new HttpResponse();
            response.setBody(jsonInput);
            response.setStatusCode(integer.valueof(serviceName));
        } else if(Test.isRunningTest()) {
            final iaso__GBL_integration_service__mdt serviceProp = getIntegrationServiceConfigFromServiceName(serviceName);
            response = new HttpResponse();
            response.setHeader('Content-Type','application/json');
            response.setBody(serviceProp.iaso__Mock_LTA__c);
            response.setStatusCode(serviceName == 'createCopyAssessments' ? 202 : serviceProp.iaso__Http_Method__c == 'POST' ? 201 : 200 );
            response.setStatusCode(serviceName == 'encryptClients' ? 200 : response.getStatusCode());
        } else {
            response = iaso.GBL_Integration_GenericService.invoke(serviceName, jsonInput);
        }

        Return response;
    }
    /**
    *-------------------------------------------------------------------------------
    * @description Retrieves mock configuration from IASO metadata
    --------------------------------------------------------------------------------
    * @author ARCE Team
    * @date 22/09/2019
    * @param serviceName The name of the metadata configuration
    * @return iaso__GBL_integration_service__mdt Corresponding metadata record
    * @example global static iaso__GBL_integration_service__mdt getIntegrationServiceConfigFromServiceName(String serviceName) {
    **/
    global static iaso__GBL_integration_service__mdt getIntegrationServiceConfigFromServiceName(String serviceName) {
    List<iaso__GBL_integration_service__mdt> lResult = [select Id, iaso__Mock_LTA__c, iaso__Http_Method__c from iaso__GBL_integration_service__mdt where DeveloperName = :serviceName limit 1];
        if ( lResult.isEmpty() ) {
            return null;
        } else {
            return lResult.get(0);
        }
    }
    /**
    *-------------------------------------------------------------------------------
    * @description It converts the service response JSON to a Salesforce Map.
    --------------------------------------------------------------------------------
    * @author ARCE Team
    * @date 11/04/2019
    * @param ServiceResponse The response of the service in JSON format
    * @return getResponseAsMap The response in salesforce map format
    * @example global static Map<String, Object> getResponseAsMap(String ServiceResponse) {
    **/
    global static Map<String, Object> getResponseAsMap(String serviceResponse) {
        Map<String, Object> responseAsMap = new Map<String, Object>();
        if (Arc_Gen_ValidateInfo_utils.isFilled(serviceResponse)) {
            responseAsMap = (Map<String, Object>)JSON.deserializeUntyped(serviceResponse);
        }
        Return responseAsMap;
    }

    /**
    *-------------------------------------------------------------------------------
    * @description get response headers and format to map
    --------------------------------------------------------------------------------
    * @author diego.miguel.contractor@bbva.com
    * @date 12/06/2019
    * @param HttpResponse response
    * @return Map<String, String> headers in salesforce map format
    * @example global static Map<String, String> getHeadersAsMap(HttpResponse response) {
    **/
    global static Map<String,String> getHeadersAsMap(HttpResponse response) {
        Map<String,String> headersMap = new Map<String,String>();
        for(String headKey : response.getHeaderKeys()) {
            headersMap.put(headKey, response.getHeader(headKey));
        }
        return headersMap;
    }

    /**
    *-------------------------------------------------------------------------------
    * @description This method is the central controller of the logic.
    --------------------------------------------------------------------------------
    * @author ARCE Team
    * @date 11/04/2019
    * @param analysisId Id of the Account_has_Analysis that we are working
    * @return result A serviceAndSaveResponse class instance
    * @example global static ServiceResponse calloutIASO(String serviceName,String jsonInput) {
    **/
    global static ServiceResponse calloutIASO(String serviceName,String jsonInput) {
        final Arc_Gen_CustomServiceMessages serviceMessages = new Arc_Gen_CustomServiceMessages();
        final ServiceResponse result = new ServiceResponse();
        final HttpResponse response = getServiceResponse(serviceName, jsonInput);
        result.serviceCode = String.valueOf(response.getStatusCode());

        if (response.getStatusCode() == serviceMessages.CODE_200) {
            result.serviceMessage = serviceMessages.SUCCESSFUL_200;
        } else if (response.getStatusCode() == serviceMessages.CODE_204) {
            result.serviceMessage = serviceMessages.SUCCESSFUL_204;
        } else if (response.getStatusCode() == serviceMessages.CODE_400) {
            result.serviceMessage = serviceMessages.ERROR_400;
        } else if (response.getStatusCode() == serviceMessages.CODE_403) {
            result.serviceMessage = serviceMessages.ERROR_403;
        } else if (response.getStatusCode() == serviceMessages.CODE_404) {
            result.serviceMessage = serviceMessages.ERROR_404;
        } else if (response.getStatusCode() == serviceMessages.CODE_409) {
            result.serviceMessage = serviceMessages.ERROR_409;
        } else if (response.getStatusCode() == serviceMessages.CODE_500) {
            result.serviceMessage = serviceMessages.ERROR_500;
        } else {
            result.serviceMessage = serviceMessages.ERROR_OTHER;
        }

        if(response.getStatusCode() != serviceMessages.CODE_204) {
            // Do not get body to http 204 no content
            result.ServiceResponse = getResponseAsMap(response.getBody());
        }

        result.serviceHeaders = getHeadersAsMap(response);
        Return result;
    }
}