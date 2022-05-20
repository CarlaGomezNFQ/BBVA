/*---------------------------------------------------------------------------------------
    Company:       BBVA.
    Description:   MM_GBL_Integration_GrantingTickets.
---------------------------------------------------------------------------------------*/
public with sharing class MM_GBL_Integration_GrantingTickets implements MM_GBL_Integration_Authentication {
    /* token */
    private static String token = '';

    /*---------------------------------------------------------------------------------------
        Company:       BBVA.
        Description:   isAuthenticated.

        IN:            MM_GBL_Authentication_Service__mdt authentConfig.
        OUT:           Boolean.
    ---------------------------------------------------------------------------------------*/
    public static Boolean isAuthenticated(MM_GBL_Authentication_Service__mdt authentConfig) {
        if(System.isFuture()) {
            if(String.isNotBlank(token)) {
                return true; //NOSONAR
            }
        } else {
            // Check if the session is stored in the cache
            Cache.SessionPartition sessionPart;
            sessionPart = Cache.Session.getPartition(authentConfig.Cache_Partition__c);
            // Retrieve cache value from the partition
            Map < String, String > credentials;
            credentials = (Map < String, String > ) sessionPart.get(authentConfig.Cache_Key__c);
            // if credentials are not set in the cache, reset
            if (credentials != null && credentials.get('tsec') != null) {
                return true;
            }
        }
        return false;
    }

    /*---------------------------------------------------------------------------------------
        Company:       BBVA.
        Description:   resetToken.

        IN:            MM_GBL_Authentication_Service__mdt authentConfig.
        OUT:           MM_GBL_Application_Log__c.
    ---------------------------------------------------------------------------------------*/
    public static MM_GBL_Application_Log__c resetToken(MM_GBL_Authentication_Service__mdt authentConfig) {
        Datetime initTime;
        initTime = Datetime.now();
        Http http;
        http = new Http();
        HttpRequest validationRequest;
        validationRequest = new HttpRequest();
        validationRequest.setEndpoint(MM_GBL_Integration_Util.getUrlFromCustomSettings(authentConfig.Custom_Setting__c));
        validationRequest.setMethod('POST');
        validationRequest.setHeader('Content-Type', 'application/json;charset=UTF-8');
        String validateRBody;
        validateRBody = '{"authentication":{"consumerID":"' +
            MM_GBL_Integration_Util.getSimpleParamFromJSON(authentConfig.Service_Parameters__c, 'consumerID') + '",' +
            '"authenticationData":[{"authenticationData":["' +
            MM_GBL_Integration_Util.getPassword(authentConfig) +
            '"],"idAuthenticationData":"' +
            MM_GBL_Integration_Util.getSimpleParamFromJSON(authentConfig.Service_Parameters__c, 'idAuthenticationData') + '"}]' +
            ',"authenticationType":"' +
            MM_GBL_Integration_Util.getSimpleParamFromJSON(authentConfig.Service_Parameters__c, 'authenticationType') +
            '","userID":"' + authentConfig.User__c + '"}}';
        System.debug('>>>>>>>> XXX validateRBody: ' + validateRBody);
        validationRequest.setBody(validateRBody);

        HttpResponse response;
        response = http.send(validationRequest);
        // Parse the JSON response
        System.debug('JCT - RESPONSE HEADERS : '+response.getHeaderKeys());
        System.debug('JCT - RESPONSE TSEC VALUE : '+response.getHeader('tsec'));
        System.debug('JCT - RESPONSE BODY : '+response.getBody());
        if (response.getStatusCode() != 200 && response.getStatusCode() != 202) { //NOSONAR
            System.debug('>>>>>>>> XXX Integration_GrantingTickets - The status code returned was not expected: ' +
                response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug('>>>>>>>> XXX Integration_GrantingTickets - response status code: ' + response.getStatusCode() + ' ' + response.getStatus());
            System.debug('>>>>>>>> XXX Integration_GrantingTickets - response Body: ' + response.getBody());
            String jsonResponse;
            jsonResponse = response.getBody();
            String tsec;
            tsec = response.getHeader(authentConfig.Header_Token__c);
            Map < String, Object > responseMap;
            responseMap = (Map < String, Object > ) JSON.deserializeUntyped(jsonResponse);
            System.debug(responseMap);
            //Map < String, Object > user = (Map < String, Object > ) m.get('user');
            //Map<String, Object> person = (Map<String, Object>) user.get('person');
            //System.debug(person);
            //String clientId = (String) person.get('id');
            System.debug('>>>>>>>> XXX tsec: ' + tsec);
            //System.debug('>>>>>>>> XXX clientId: ' + clientId);
            if(System.isFuture()) {
                token = tsec;
            } else {
                Map < String, String > credentials;
                credentials = new Map < String, String > ();
                // Add cache value to the partition
                credentials.put('tsec', tsec);
                //credentials.put('clientId', clientId);
                Cache.SessionPartition sessionPart;
                sessionPart = Cache.Session.getPartition(authentConfig.Cache_Partition__c);
                sessionPart.put(authentConfig.Cache_Key__c, credentials);
            }
            System.debug('>>>>>>>> XXX Credentials stored in cache');
        }

        return new MM_GBL_Application_Log__c(Start_Time__c = initTime,
            End_Time__c = Datetime.now(),
            Message__c = 'REQUEST: ' + validationRequest.getEndpoint() + '\n' + validationRequest.getBody() + '\n--\n--\n\nRESPONSE:\n' + response.getBody(),
            Name = 'GrantingTickets',
            Type__c = 'Integration',
            User__c = UserInfo.getUserId());
    }

    /*---------------------------------------------------------------------------------------
        Company:       BBVA.
        Description:   applySecurity.

        IN:            HttpRequest request.
        IN:            MM_GBL_Authentication_Service__mdt authentConfig.
        OUT:           HttpRequest.
    ---------------------------------------------------------------------------------------*/
    public static HttpRequest applySecurity(HttpRequest request, MM_GBL_Authentication_Service__mdt authentConfig) {
        System.debug('>>>>>>>>> XXX MM_GBL_Integration_GrantingTickets.applySecurity');
        System.debug('>>>>>>>>> XXX Header_Token__c: ' + authentConfig.Header_Token__c); //NOSONAR
        System.debug('>>>>>>>>> XXX url: ' + MM_GBL_Integration_Util.getUrlFromCustomSettings(authentConfig.Custom_Setting__c)); //NOSONAR

        if(System.isFuture() && String.isNotBlank(token)) {
            request.setHeader(authentConfig.Header_Token__c, token);
        } else {
            // Check if the session is stored in the cache
            Cache.SessionPartition sessionPart;
            sessionPart = Cache.Session.getPartition(authentConfig.Cache_Partition__c);
            // Retrieve cache value from the partition
            Map < String, String > credentials;
            credentials = (Map < String, String > ) sessionPart.get(authentConfig.Cache_Key__c);
            // if credentials are not set in the cache, reset
            if (credentials != null && credentials.get('tsec') != null) {
                //resetToken(authentConfig);
                //credentials = (Map <String, String>) sessionPart.get(authentConfig.Cache_Key__c);      
                request.setHeader(authentConfig.Header_Token__c, credentials.get('tsec'));
                System.debug('>>>>>>>> XXX tsec: ' + credentials.get('tsec'));
            }
        }

        // Add the user and locale information in the request headers
        String userCode = [Select ID_User__c From User Where Id = :UserInfo.getUserId()][0].ID_User__c;
        if (userCode == null) {
            userCode = '';
        }
        request.setHeader('ContactId', userCode);
        System.debug('>>>>>>>> XXX ContactId: ' + userCode);
        request.setHeader('Accept-Language', UserInfo.getLocale().replace('_', '-'));
        System.debug('>>>>>>>> XXX Accept-Language' + request.getHeader('Accept-Language'));
        //request.setEndPoint(request.getEndPoint().replace('#clientId#', credentials.get('clientId')));

        //System.debug('>>>>>>>> XXX clientId: ' + credentials.get('clientId'));
        System.debug('>>>>>>>> XXX Security Applied: Request modified');
        return request;
    }


}