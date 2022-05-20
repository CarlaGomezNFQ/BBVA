/*------------------------------------------------------------------
*Author:        bbva.com developers
*Project:      	ARCE - BBVA Bancomer
*Description:   Test class for Arc_Gen_getIASOResponse
*_______________________________________________________________________________________
*Versión    Date           	Author                              Description
*1.0        14/09/2020      ARCE's TEAM                         Created.
-----------------------------------------------------------------------------------------*/
@isTest
global with sharing class Arc_Gen_getIASOResponse_Test {
    /**
    *-------------------------------------------------------------------------------
    * @Description Testing calloutIASO
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-09-14
    *--------------------------------------------------------------------------------
    **/
    @isTest
    global static void calloutIASOTest() {
        Test.startTest();
        final String serviceName = 'TestMock';
        //String jsonInput = '{"subEvent":"ANCHOR","riskAssessmentId":"0000000000","ratingId":"","participationType":"SUBSIDIARY","participantId":"85936670","ffssId":"70202018129","eventType":"RATING","branchLevel":"10","branchId":"0000","bankId":"0001"}';
        final String jsonInput = '{}';
        final Arc_Gen_getIASOResponse.ServiceResponse sResp = Arc_Gen_getIASOResponse.calloutIASO(serviceName, jsonInput);
        final Map<String, Object> mapExpected = new Map<String, Object>();
        mapExpected.put('foo', 'bar');
        System.assertEquals(mapExpected, sResp.serviceResponse, 'Error calloutIASOTest');
        Test.stopTest();
    }
        /**
    *-------------------------------------------------------------------------------
    * @Description Testing calloutIASO
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-10-22
    *--------------------------------------------------------------------------------
    **/
    @isTest
    global static void calloutIASO204Test() {
        Test.startTest();
        final String serviceName = '400';
        final String jsonInput = '{}';
        final Arc_Gen_getIASOResponse.ServiceResponse sResp = Arc_Gen_getIASOResponse.calloutIASO(serviceName, jsonInput);
        System.assertEquals(serviceName, sResp.serviceCode, 'Error calloutIASOTest');
        Test.stopTest();
    }
}