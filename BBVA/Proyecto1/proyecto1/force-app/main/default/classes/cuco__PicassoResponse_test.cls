/**
* ────────────────────────────────────────────────────────────────────
* PicassoResponsel_test
* Test class for PicassoResponse class
* ────────────────────────────────────────────────────────────────────
* @author
* @modifiedBy
* @version     1.0
* @created
* @modified
* @systemLayer Presentation
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@IsTest
public with sharing class PicassoResponse_test {
    static String inputWithoutDocs = '{"action": {"id": "#ACTION_ID#","source": "03","description": "Description"},"externalId": "#PA_ID#","documents": null,"operationId": "#PICASSO_ID#","channelId":"#CHANNEL#"}';
    static String inputWithDocs = '{"action": { "id": "#ACTION_ID#", "source": "03", "description": "Decription" }, "externalId": "#PA_ID#","documents": [{"name": "#DOC_NAME_1#","id": "#DOC_ID_1#","format": "txt"},{"name": "#DOC_NAME_2#","id": "#DOC_ID_2#","format": "pdf"}],"operationId": "#PICASSO_ID#","channelId":"#CHANNEL#"}';

    @TestSetup
    static void setupTestData() {
        //Generate Accounts
        List<Account> accList = Test_Utils.createAccounts(9);
        insert accList;
        // Generate Profitability Analysis
        List<profitability_analysis__c> paList = Test_Utils.createProfAnalysis(9, accList);
        for(Integer i=0; i<paList.size(); i++) {
            paList[i].gf_pa_mgmt_stage_type_name__c = 'Formalization';
            paList[i].gf_pa_mgmt_status_type_name__c = 'Sent for Formalization';
            paList[i].gf_pa_management_type_name__c = 'New';
            paList[i].gf_manl_formalization_req_id__c = '00000' + i;
        }
        paList[2].gf_pa_management_type_name__c = 'Cancellation';
        insert paList;
        //Set Documents
        List<profitability_analysis_external_document__c> docsList = new List<profitability_analysis_external_document__c>();
        profitability_analysis_external_document__c doc = new profitability_analysis_external_document__c();
        doc.gf_document_id__c = '000001';
        doc.gf_external_operation_id__c = '000005';
        doc.gf_document_name__c = 'Document 1';
        doc.gf_document_format_type__c = 'pdf';
        doc.gf_profitablity_analysis_id__c = paList[5].Id;
        docsList.add(doc);
    }
    //Test Wrong Object Type
    @IsTest
    static void wrongObjectTypeTest() {
        List<Account> accList = [SELECT Id FROM Account WHERE Name = 'Account Test 1'];
        String inputWrongObject = inputWithoutDocs;
        inputWrongObject = inputWrongObject.replace('#ACTION_ID#','01');
        inputWrongObject = inputWrongObject.replace('#PICASSO_ID#', '999999');
        inputWrongObject = inputWrongObject.replace('#PA_ID#', String.valueOf(accList[0].Id));
        inputWrongObject = inputWrongObject.replace('#CHANNEL#', '06');
        RestRequest request = new RestRequest();
        request.requestUri ='/services/apexrest/PicassoResponse/';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueof(inputWrongObject);
        RestContext.request = request;
        RestResponse response = new RestResponse();
        RestContext.response = response;
        PicassoResponse.setPicassoResponse();
        System.assertEquals(409, RestContext.response.statusCode, 'wrongObjectTypeTest - wrong status code');
    }

    //Test Operation Not Found
    @IsTest
    static void operationNotFoundTest() {
        ProfitabilityAnalysis_Selector paSelector = new ProfitabilityAnalysis_Selector(true);
        Set<String> paNamesSet = new Set<String>{'Prof Analysis Test 0'};
        List<profitability_analysis__c> paList = paSelector.selectByName(paNamesSet);
        String inputNotFound = inputWithoutDocs;
        inputNotFound = inputNotFound.replace('#ACTION_ID#','01');
        inputNotFound = inputNotFound.replace('#PICASSO_ID#', '999999');
        inputNotFound = inputNotFound.replace('#PA_ID#', String.valueOf(paList[0].Id));
        inputNotFound = inputNotFound.replace('#CHANNEL#', '06');
        RestRequest request = new RestRequest();
        request.requestUri ='/services/apexrest/PicassoResponse/';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueof(inputNotFound);
        RestContext.request = request;
        RestResponse response = new RestResponse();
        RestContext.response = response;
        PicassoResponse.setPicassoResponse();
        System.assertEquals(409, RestContext.response.statusCode, 'operationNotFoundTest - wrong status code');
    }

    //Test Wrong Channel
    @IsTest
    static void wrongChannelTest() {
        ProfitabilityAnalysis_Selector paSelector = new ProfitabilityAnalysis_Selector(true);
        Set<String> paNamesSet = new Set<String>{'Prof Analysis Test 1'};
        List<profitability_analysis__c> paList = paSelector.selectByName(paNamesSet);
        String inputWrongChannel = inputWithoutDocs;
        inputWrongChannel = inputWrongChannel.replace('#ACTION_ID#', '01');
        inputWrongChannel = inputWrongChannel.replace('#PICASSO_ID#', paList[0].gf_manl_formalization_req_id__c);
        inputWrongChannel = inputWrongChannel.replace('#PA_ID#', String.valueOf(paList[0].Id));
        inputWrongChannel = inputWrongChannel.replace('#CHANNEL#', '09');
        RestRequest request = new RestRequest();
        request.requestUri ='/services/apexrest/PicassoResponse/';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueof(inputWrongChannel);
        RestContext.request = request;
        RestResponse response = new RestResponse();
        RestContext.response = response;
        PicassoResponse.setPicassoResponse();
        System.assertEquals(409, RestContext.response.statusCode, 'wrongChannelTest - wrong status code');
    }

    //Test Wrong Status/Typology
    @IsTest
    static void wrongTypologyTest() {
        ProfitabilityAnalysis_Selector paSelector = new ProfitabilityAnalysis_Selector(true);
        Set<String> paNamesSet = new Set<String>{'Prof Analysis Test 2'};
        List<profitability_analysis__c> paList = paSelector.selectByName(paNamesSet);
        String inputWrongTypology = inputWithoutDocs;
        inputWrongTypology = inputWrongTypology.replace('#ACTION_ID#', '05');
        inputWrongTypology = inputWrongTypology.replace('#PICASSO_ID#', paList[0].gf_manl_formalization_req_id__c);
        inputWrongTypology = inputWrongTypology.replace('#PA_ID#', String.valueOf(paList[0].Id));
        inputWrongTypology = inputWrongTypology.replace('#CHANNEL#', '06');
        RestRequest request = new RestRequest();
        request.requestUri ='/services/apexrest/PicassoResponse/';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueof(inputWrongTypology);
        RestContext.request = request;
        RestResponse response = new RestResponse();
        RestContext.response = response;
        PicassoResponse.setPicassoResponse();
        System.assertEquals(409, RestContext.response.statusCode, 'wrongTypologyTest - wrong status code');
    }

    //Test Information Request
    @IsTest
    static void infoActionTest() {
        ProfitabilityAnalysis_Selector paSelector = new ProfitabilityAnalysis_Selector(true);
        Set<String> paNamesSet = new Set<String>{'Prof Analysis Test 3'};
        List<profitability_analysis__c> paList = paSelector.selectByName(paNamesSet);
        String inputInfoAction = inputWithoutDocs;
        inputInfoAction = inputInfoAction.replace('#ACTION_ID#', '01');
        inputInfoAction = inputInfoAction.replace('#PICASSO_ID#', paList[0].gf_manl_formalization_req_id__c);
        inputInfoAction = inputInfoAction.replace('#PA_ID#', String.valueOf(paList[0].Id));
        inputInfoAction = inputInfoAction.replace('#CHANNEL#', '06');
        RestRequest request = new RestRequest();
        request.requestUri ='/services/apexrest/PicassoResponse/';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueof(inputInfoAction);
        RestContext.request = request;
        RestResponse response = new RestResponse();
        RestContext.response = response;
        PicassoResponse.setPicassoResponse();
        System.assertEquals(200, RestContext.response.statusCode, 'infoActionTest - wrong status code');
    }

    //Test Complete Formalization With Documents
    @IsTest
    static void compFormActionTest() {
        ProfitabilityAnalysis_Selector paSelector = new ProfitabilityAnalysis_Selector(true);
        Set<String> paNamesSet = new Set<String>{'Prof Analysis Test 4'};
        List<profitability_analysis__c> paList = paSelector.selectByName(paNamesSet);
        String inputCompFormAction = inputWithDocs;
        inputCompFormAction = inputCompFormAction.replace('#ACTION_ID#', '02');
        inputCompFormAction = inputCompFormAction.replace('#PICASSO_ID#', paList[0].gf_manl_formalization_req_id__c);
        inputCompFormAction = inputCompFormAction.replace('#PA_ID#', String.valueOf(paList[0].Id));
        inputCompFormAction = inputCompFormAction.replace('#CHANNEL#', '06');
        inputCompFormAction = inputCompFormAction.replace('#DOC_ID_1#', '000001');
        inputCompFormAction = inputCompFormAction.replace('#DOC_NAME_1#', 'Document 1');
        inputCompFormAction = inputCompFormAction.replace('#DOC_ID_2#', '000002');
        inputCompFormAction = inputCompFormAction.replace('#DOC_NAME_2#', 'Document 1');
        RestRequest request = new RestRequest();
        request.requestUri ='/services/apexrest/PicassoResponse/';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueof(inputCompFormAction);
        RestContext.request = request;
        RestResponse response = new RestResponse();
        RestContext.response = response;
        PicassoResponse.setPicassoResponse();
        System.assertEquals(200, RestContext.response.statusCode, 'compFormActionTest - wrong status code');
    }

    //Test Partial Formalization With Documents That Already Exist
    @IsTest
    static void partTestActionTest() {
        ProfitabilityAnalysis_Selector paSelector = new ProfitabilityAnalysis_Selector(true);
        Set<String> paNamesSet = new Set<String>{'Prof Analysis Test 5'};
        List<profitability_analysis__c> paList = paSelector.selectByName(paNamesSet);
        String inputPartFormAction = inputWithDocs;
        inputPartFormAction = inputPartFormAction.replace('#ACTION_ID#', '06');
        inputPartFormAction = inputPartFormAction.replace('#PICASSO_ID#', paList[0].gf_manl_formalization_req_id__c);
        inputPartFormAction = inputPartFormAction.replace('#PA_ID#', String.valueOf(paList[0].Id));
        inputPartFormAction = inputPartFormAction.replace('#CHANNEL#', '06');
        inputPartFormAction = inputPartFormAction.replace('#DOC_ID_1#', '000001');
        inputPartFormAction = inputPartFormAction.replace('#DOC_NAME_1#', 'Document 1');
        inputPartFormAction = inputPartFormAction.replace('#DOC_ID_2#', '000002');
        inputPartFormAction = inputPartFormAction.replace('#DOC_NAME_2#', 'Document 1');
        RestRequest request = new RestRequest();
        request.requestUri ='/services/apexrest/PicassoResponse/';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueof(inputPartFormAction);
        RestContext.request = request;
        RestResponse response = new RestResponse();
        RestContext.response = response;
        PicassoResponse.setPicassoResponse();
        System.assertEquals(200, RestContext.response.statusCode, 'partTestActionTest - wrong status code');
    }

    //Test Restudy Request
    @IsTest
    static void restudyActionTest() {
        ProfitabilityAnalysis_Selector paSelector = new ProfitabilityAnalysis_Selector(true);
        Set<String> paNamesSet = new Set<String>{'Prof Analysis Test 6'};
        List<profitability_analysis__c> paList = paSelector.selectByName(paNamesSet);
        String inputRestudyAction = inputWithoutDocs;
        inputRestudyAction = inputRestudyAction.replace('#ACTION_ID#', '05');
        inputRestudyAction = inputRestudyAction.replace('#PICASSO_ID#', paList[0].gf_manl_formalization_req_id__c);
        inputRestudyAction = inputRestudyAction.replace('#PA_ID#', String.valueOf(paList[0].Id));
        inputRestudyAction = inputRestudyAction.replace('#CHANNEL#', '06');
        RestRequest request = new RestRequest();
        request.requestUri ='/services/apexrest/PicassoResponse/';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueof(inputRestudyAction);
        RestContext.request = request;
        RestResponse response = new RestResponse();
        RestContext.response = response;
        PicassoResponse.setPicassoResponse();
        System.assertEquals(200, RestContext.response.statusCode, 'restudyActionTest - wrong status code');
    }

    //Test Picasso Id expiration
    @IsTest
    static void expireActionTest() {
        ProfitabilityAnalysis_Selector paSelector = new ProfitabilityAnalysis_Selector(true);
        Set<String> paNamesSet = new Set<String>{'Prof Analysis Test 7'};
        List<profitability_analysis__c> paList = paSelector.selectByName(paNamesSet);
        String inputExpireAction = inputWithoutDocs;
        inputExpireAction = inputExpireAction.replace('#ACTION_ID#', '03');
        inputExpireAction = inputExpireAction.replace('#PICASSO_ID#', paList[0].gf_manl_formalization_req_id__c);
        inputExpireAction = inputExpireAction.replace('#PA_ID#', String.valueOf(paList[0].Id));
        inputExpireAction = inputExpireAction.replace('#CHANNEL#', '06');
        RestRequest request = new RestRequest();
        request.requestUri ='/services/apexrest/PicassoResponse/';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueof(inputExpireAction);
        RestContext.request = request;
        RestResponse response = new RestResponse();
        RestContext.response = response;
        PicassoResponse.setPicassoResponse();
        System.assertEquals(200, RestContext.response.statusCode, 'expireActionTest - wrong status code');
    }

    //Test Picasso Dismissal
    @IsTest
    static void dimissActionTest() {
        ProfitabilityAnalysis_Selector paSelector = new ProfitabilityAnalysis_Selector(true);
        Set<String> paNamesSet = new Set<String>{'Prof Analysis Test 7'};
        List<profitability_analysis__c> paList = paSelector.selectByName(paNamesSet);
        String inputDismissAction = inputWithoutDocs;
        inputDismissAction = inputDismissAction.replace('#ACTION_ID#', '03');
        inputDismissAction = inputDismissAction.replace('#PICASSO_ID#', paList[0].gf_manl_formalization_req_id__c);
        inputDismissAction = inputDismissAction.replace('#PA_ID#', String.valueOf(paList[0].Id));
        inputDismissAction = inputDismissAction.replace('#CHANNEL#', '06');
        RestRequest request = new RestRequest();
        request.requestUri ='/services/apexrest/PicassoResponse/';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueof(inputDismissAction);
        RestContext.request = request;
        RestResponse response = new RestResponse();
        RestContext.response = response;
        PicassoResponse.setPicassoResponse();
        System.assertEquals(200, RestContext.response.statusCode, 'dimissActionTest - wrong status code');
    }
}