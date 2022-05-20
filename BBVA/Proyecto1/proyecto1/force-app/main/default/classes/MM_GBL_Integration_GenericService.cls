public with sharing class MM_GBL_Integration_GenericService implements Database.AllowsCallouts{


    public static MM_GBL_Application_Log__c resetToken(String serviceName) {
        // ResetToken
        MM_GBL_Authentication_Service__mdt authenticationConfig = MM_GBL_Integration_Util.getAuthenticationConfigFromService(serviceName);
        System.Type objType = Type.forName(authenticationConfig.Apex_Class__c);
        MM_GBL_Integration_Authentication authenticationService = (MM_GBL_Integration_Authentication)objType.newInstance();
        return authenticationService.resetToken(authenticationConfig);
    }

    public static Boolean isAuthenticated(String serviceName) {
        // ResetToken
        MM_GBL_Authentication_Service__mdt authenticationConfig = MM_GBL_Integration_Util.getAuthenticationConfigFromService(serviceName);
        System.Type objType = Type.forName(authenticationConfig.Apex_Class__c);
        MM_GBL_Integration_Authentication authenticationService = (MM_GBL_Integration_Authentication)objType.newInstance();
        return authenticationService.isAuthenticated(authenticationConfig);
    }

    static HttpRequest applySecurity(HttpRequest request, String serviceName) {
        // Apply security
        MM_GBL_Authentication_Service__mdt authenticationConfig = MM_GBL_Integration_Util.getAuthenticationConfigFromService(serviceName);
        System.Type objType = Type.forName(authenticationConfig.Apex_Class__c);
        MM_GBL_Integration_Authentication authenticationService = (MM_GBL_Integration_Authentication)objType.newInstance();
        request = authenticationService.applySecurity(request, authenticationConfig);
        System.debug('>>>>>>>> XXX request.Security Applied');
        System.debug('>>>>>>>> XXX request.tsec added: ' + request.getHeader('tsec'));
        System.debug('>>>>>>>> XXX request.content-type: ' +  request.getHeader('Content-Type'));
        System.debug('>>>>>>>> XXX request.body: ' + request.getBody());
        System.debug('>>>>>>>> XXX request.endPoint: ' + request.getEndpoint());
        System.debug('>>>>>>>> XXX request: ' + request);
        return request;
    }

    public static MM_GBL_Integration_Response callout(String serviceName, Map<String, Object> placeholderMap) {
        // Get service configuration
        // from serviceName in Custom Metadata Type we can get the url of the service and the method
        MM_GBL_integration_service__mdt serviceConfig = null;

        serviceConfig = [select Retrieve_Mock_LTA__c, Mock_LTA__c, Http_Headers_LTA__c, Querystring_Input_Template_LTA__c, Http_Method__c, Custom_Setting__c, DeveloperName, Json_Input_Template_LTA__c, Authentication_Service__c from MM_GBL_integration_service__mdt
                         where DeveloperName = :serviceName limit 1];
        String url = MM_GBL_Integration_Util.getUrlFromCustomSettings(serviceConfig.Custom_Setting__c);
        String jsonTemplate = serviceConfig.Json_Input_Template_LTA__c;
        String queryStringTemplate = serviceConfig.Querystring_Input_Template_LTA__c;

        System.debug('>>>>>>>>>>>> XXXXX url: ' + url);
        System.debug('>>>>>>>>>>>> XXXXX JSON Template: ' + jsonTemplate);
        System.debug('>>>>>>>>>>>> XXXXX JSON Parameters: ' + placeholderMap);

        // Replace in jsonTemplate and queryString the placeholders
        for (String key : placeholderMap.keySet()) {
            placeholderMap.get(key);
            System.debug('>>>>>>>>>>>> XXXXX ' + key + ': ' + (String)placeholderMap.get(key));
            if (jsonTemplate != null && !jsonTemplate.equals(''))
                jsonTemplate = jsonTemplate.replace('#' + key + '#', (String)placeholderMap.get(key));
            if (queryStringTemplate != null && !queryStringTemplate.equals(''))
                queryStringTemplate = queryStringTemplate.replace('#' + key + '#', (String)placeholderMap.get(key));
        }

        System.debug('>>>>>>>>>>>> XXXXX JSON Template Filled: ' + jsonTemplate);
        System.debug('>>>>>>>>>>>> XXXXX QUERYSTRING Template Filled ' + queryStringTemplate);

        // Callout the service
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        if (queryStringTemplate != null && !queryStringTemplate.equals(''))
            url = url + queryStringTemplate;
        request.setEndpoint(url);
        System.debug(url);
        request.setMethod(serviceConfig.Http_Method__c);
        request.setTimeout(60000);
        System.debug(serviceConfig.Http_Headers_LTA__c);
        if (serviceConfig.Http_Headers_LTA__c != null && !serviceConfig.Http_Headers_LTA__c.equals('')) {
            Map <String, Object> headerMap = (Map <String, Object>)JSON.deserializeUntyped(serviceConfig.Http_Headers_LTA__c);
            // Add all the configured headers
            for (String headerKey : headerMap.keySet()) {
                request.setHeader(headerKey, (String)headerMap.get(headerKey));
            }
        }
        if (jsonTemplate != null && !jsonTemplate.equals(''))
            request.setBody(jsonTemplate);

        request = applySecurity(request, serviceName);

        Datetime init = Datetime.now();

        HttpResponse response = null;
        // Return the response from the service configuration Mock
        if (serviceConfig.Retrieve_Mock_LTA__c == true) {
            System.debug('>>>>>>>> XXX Retornando mock');
            response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody(serviceConfig.Mock_LTA__c);
            response.setStatusCode(200);
        } else {
            response = http.send(request);
        }
        System.debug(response.getStatus());
        System.debug(response.getBody());
        MM_GBL_Integration_Response intResponse = new MM_GBL_Integration_Response();
        // log request headers
        String headerStr = 'Accept-Language: ' + request.getHeader('Accept-Language');
        headerStr += '\n' + 'Content-Type: ' +  + request.getHeader('Content-Type');
        headerStr += '\n' + 'ContactId: ' +  + request.getHeader('ContactId');
        String respHeaderStr = '';
        for (String respHeader : response.getHeaderKeys()) {
            if (respHeader != 'tsec') respHeaderStr += respHeader + ': ' + response.getHeader(respHeader) + '\n';
        }
        intResponse.log = new MM_GBL_Application_Log__c(    Start_Time__c = init,
                                                            End_Time__c = Datetime.now(), 
                                                            Message__c = 'REQUEST: ' + request.getEndpoint() + '\n' + headerStr + '\n\n'+ request.getBody() + '\n--\n--\n\nRESPONSE:\nHTTP/1.1 ' + response.getStatusCode() + ' ' + response.getStatus() + '\n' + respHeaderStr + response.getBody(), 
                                                            Name = serviceName, 
                                                            Type__c = 'Integration', 
                                                            User__c = UserInfo.getUserId());
        intResponse.response = response;
        return intResponse ;
    }


    public static HttpResponse invoke(String serviceName, Map<String, Object> placeholderMap) {
        List<MM_GBL_Application_Log__c> logList = new List<MM_GBL_Application_Log__c>();
 
        // First check the cache and if not set invoke to validation (this will earn the first wrong
        // call for all the sessions)
        System.debug('JCT - NOMBRE DE SERVICIO : '+serviceName);
        MM_GBL_integration_service__mdt serviceConfig = null;
        serviceConfig = [select Retrieve_Mock_LTA__c, Mock_LTA__c, Http_Headers_LTA__c, Querystring_Input_Template_LTA__c, Http_Method__c, Custom_Setting__c, DeveloperName, Json_Input_Template_LTA__c, Authentication_Service__c from MM_GBL_integration_service__mdt
                         where DeveloperName = :serviceName limit 1];
        if (!isAuthenticated(serviceName) && !serviceConfig.Retrieve_Mock_LTA__c) {
            logList.add(resetToken(serviceName));
        }
        // Enable logs if configured
        Boolean isLogActivated = false;
        System.debug('JCT - CSR NAME : '+serviceConfig.Custom_Setting__c);
        Boolean logActivation = MM_GBL_Integration_Util.isLogEnabledFromCustomSettings(serviceConfig.Custom_Setting__c);
        if (logActivation != null) isLogActivated = logActivation;
        MM_GBL_Integration_Response intResponse = callout(serviceName, placeholderMap);

        HttpResponse response = intResponse.response;
        logList.add(intResponse.log);

        // First Error Response
        if (response.getStatusCode() == 403) {
            System.debug('The status code returned was not expected: ' +
                         response.getStatusCode() + ' ' + response.getStatus());
            // error management
            //
            // RESET THE TOKEN IN CASE ANY VALIDATION RELATED ERROR
            MM_GBL_Application_Log__c resetTokenLog = resetToken(serviceName);
            logList.add(resetTokenLog);

            // TRY TO CALL THE SERVICE AGAIN
            intResponse = callout(serviceName, placeholderMap);
            response = intResponse.response;
            logList.add(intResponse.log);

            if (response.getStatusCode() == 403) {
                System.debug('The status code returned was not expected: ' +
                             response.getStatusCode() + ' ' + response.getStatus());
            }
        // First OK Response
        }
        System.debug(response.getBody());
        System.debug('JCT - LOG ACTIVADO : '+isLogActivated);
        if (isLogActivated) MM_GBL_Logger_Service.flushLogList(logList);
        return response;          

    }


    public static HttpResponse invoke(String serviceName, String jsonInput) {
        // Parse Json input and replace the placeholders with the input data
        Map <String, Object> plmap = (Map <String, Object>)JSON.deserializeUntyped(jsonInput);
        return invoke(serviceName, plmap);
    }


}