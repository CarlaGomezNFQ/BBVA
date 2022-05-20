@isTest
global class MM_GBL_Integration_MockGenerator implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        if (req.getEndpoint().equals('https://validation/ok')) {
            System.assertEquals('https://validation/ok', req.getEndpoint());
            System.assertEquals('POST', req.getMethod());
            // Create a fake response
            res.setHeader('tsec', '**************sessionToken*************');
            res.setBody('{' +
                       '"authenticationData": [],' +
                       '"authenticationState": "OK",' +
                       '"user": {' +
                       '"id": "ES0182099802136C",' +
                       '"authenticationType": "02",' +
                       '"alias": "000000034B",' +
                       '"role": "O",' +
                       '"otherUserInfo": {' +
                       '"MEDICOS_BARCELONA": "N",' +
                       '"FILE_OPERATION": "N",' +
                       '"ORIGIN_CX": "N",' +
                       '"ORIGIN_UNNIM": "N",' +
                       '"COLLABORATOR": "N"' +
                        '},' +
                        '"personalization": {' +
                        '"channelCode": "04",' +
                        '"personalizationCode": "T"' +
                        '},' +
                        '"person": {' +
                        '"id": "ES0182099802136C"' +
                        '}' +
                        '}' +
                        '}');
            res.setStatusCode(200);
        } else if (req.getEndpoint().equals('https://service/ok')) {
            System.assertEquals('https://service/ok', req.getEndpoint());
            System.assertEquals('GET', req.getMethod());
            // Create a fake response
            res.setBody('{"foo":"bar"}');
            res.setStatusCode(200);
        } else if (req.getEndpoint().equals('https://service/ko')) {
            System.assertEquals('https://service/ko', req.getEndpoint());
            System.assertEquals('GET', req.getMethod());
            // Create a fake response
            res.setBody('{"error":"403"}');
            res.setStatusCode(403);
        } else if (req.getEndpoint().equals('https://validation/ko')) {
            System.assertEquals('https://validation/ko', req.getEndpoint());
            System.assertEquals('POST', req.getMethod());
            // Create a fake response
            res.setBody('{"error":"403"}');
            res.setStatusCode(403);
        }
        return res;

    }
}