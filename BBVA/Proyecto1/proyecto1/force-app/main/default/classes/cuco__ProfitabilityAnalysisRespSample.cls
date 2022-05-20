/**
* ────────────────────────────────────────────────────────────────────
* ProfitabilityAnalysisRespSample
* Wrapper class for with the actions to perform based on a profitability
* analysis Picasso response
* ────────────────────────────────────────────────────────────────────
* @author
* @modifiedBy
* @version     1.0
* @created
* @modified
* @systemLayer Domain
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
public with sharing class ProfitabilityAnalysisRespSample {

    /**
    * @description Perform actions base on a Profitability Analysis Picasso Response
    * @param inputResponse : Picasso response input information
    * @return PicassoResponseError_Wrapper
    */
    public static PicassoResponseError_Wrapper setPicassoProfAnalysisResponse(PicassoResponse_Wrapper inputResponse) {

        PicassoResponseError_Wrapper returnError = new PicassoResponseError_Wrapper();

        ProfitabilityAnalysis_Selector paSelector = new ProfitabilityAnalysis_Selector(true);
        List<profitability_analysis__c> paList = paSelector.selectByIdAndManualReqId(new Set<Id>{inputResponse.externalId}, new Set<String>{inputResponse.operationId});

        if(!paList.isEmpty()){
            Map<String,Object> checkReturnMap = checkResponse(inputResponse, paList.get(0));
            if((Boolean)checkReturnMap.get('success')) {
                Map<String,Object> actionsReturnMap = performActions(inputResponse, paList.get(0));
                returnError.statusCode = (Integer)actionsReturnMap.get('statusCode');
                PicassoResponseError_Wrapper.ErrorDetail errorDetail = new PicassoResponseError_Wrapper.ErrorDetail();
                errorDetail.errorCode = (String)actionsReturnMap.get('errorCode');
                errorDetail.message = (String)actionsReturnMap.get('message');
                returnError.errorDetail = errorDetail;
            } else {
                returnError.statusCode = (Integer)checkReturnMap.get('statusCode');
                PicassoResponseError_Wrapper.ErrorDetail errorDetail = new PicassoResponseError_Wrapper.ErrorDetail();
                errorDetail.errorCode = (String)checkReturnMap.get('errorCode');
                errorDetail.message = (String)checkReturnMap.get('message');
                returnError.errorDetail = errorDetail;
            }
        } else {
            returnError.statusCode = 409;
            PicassoResponseError_Wrapper.ErrorDetail errorDetail = new PicassoResponseError_Wrapper.ErrorDetail();
            errorDetail.errorCode = Label.picasso_response_not_found_code;
            errorDetail.message = Label.picasso_response_not_found_sample;
            returnError.errorDetail = errorDetail;
        }

        return returnError;
    }

    /**
    * @description Checks if the input Picasso response meets the required criteria
    * @param inputResponse : Picasso response input information
    * @return Map<String,Object>
    */
    public static Map<String,Object> checkResponse(PicassoResponse_Wrapper inputResponse, profitability_analysis__c paRecord) {

        Map<String,Object> returnMap = new Map<String,Object>();

        Map<String,Object> channelMap =  checkResponseChannel(inputResponse);

        if ((Boolean)channelMap.get('success')) {

            Map<String,Object> statusMap = checkResponseStatus(inputResponse, paRecord);

            returnMap  = statusMap;

        } else {
            returnMap  = channelMap;
        }

        return returnMap;
    }

    /**
    * @description Checks if the input Picasso response channel match the one in the general configuration
    * @param inputResponse : Picasso response input information
    * @return Map<String,Object>
    */
    public static Map<String,Object> checkResponseChannel(PicassoResponse_Wrapper inputResponse) {

        Map<String,Object> returnMap = new Map<String,Object>();

        pa_general_configuration__mdt configMtd = Utils.getGeneralConfiguration();
        if(inputResponse.channelId == configMtd.picasso_channel_id__c) {
            returnMap.put('success',true);
        } else {
            returnMap.put('success',false);
            returnMap.put('statusCode',409);
            returnMap.put('errorCode',Label.picasso_response_wrong_channel_code);
            returnMap.put('message',Label.picasso_response_wrong_channel_sample);
        }

        return returnMap;
    }

    /**
    * @description Checks if the input Picasso response action match the prof analysis status
    * @param inputResponse : Picasso response input information
    * @param paRecord : target profitability analysis record
    * @return Map<String,Object>
    */
    public static Map<String,Object> checkResponseStatus(PicassoResponse_Wrapper inputResponse, profitability_analysis__c paRecord) {

        Map<String,Object> returnMap = new Map<String,Object>();

        Boolean success = false;

        switch on inputResponse.action.id {
            when '01','02','06' {
                if (paRecord.gf_pa_mgmt_status_type_name__c == 'Sent for Formalization') {
                    success = true;
                }
            }
            when '05' {
                if (paRecord.gf_pa_mgmt_status_type_name__c == 'Sent for Formalization' && paRecord.gf_pa_management_type_name__c != 'Cancellation') {
                    success = true;
                }
            }
            when '03','04' {
                success = true;
            }
        }

        if (success) {
            returnMap.put('success',true);
        } else {
            returnMap.put('success',false);
            returnMap.put('statusCode',409);
            returnMap.put('errorCode',Label.picasso_response_wrong_status_code);
            returnMap.put('message',Label.picasso_response_wrong_status_sample);
        }

        return returnMap;
    }

    /**
    * @description Perform the actions based on the input response
    * @param inputResponse : Picasso response input information
    * @param paRecord : target profitability analysis record
    * @return Map<String,Object>
    */
    public static Map<String,Object> performActions(PicassoResponse_Wrapper inputResponse, profitability_analysis__c paRecord) {
        Map<String,Object> returnMap = new Map<String,Object>();

        try {
            switch on inputResponse.action.id {
                when '01','02','06','05' {
                    updateProfAnalysis(inputResponse, paRecord);
                    saveDocuments(inputResponse, paRecord);
                    createResponseAudit(inputResponse, paRecord);
                }
                when '03','04' {
                    updateProfAnalysis(inputResponse, paRecord);
                }
            }

            returnMap.put('statusCode',200);
            returnMap.put('errorCode',Label.picasso_response_ok_code);
            returnMap.put('message',Label.picasso_response_ok_sample);

        } catch (Exception e) {
            returnMap.put('statusCode',409);
            returnMap.put('errorCode',Label.picasso_response_process_error_code);
            returnMap.put('message',Label.picasso_response_process_error_sample + e.getMessage());
        }

        return returnMap;
    }

    /**
    * @description Updates the target profitability analysis record based on the input response
    * @param inputResponse : Picasso response input information
    * @param paRecord : target profitability analysis record
    * @return Map<String,Object>
    */
    public static void saveDocuments(PicassoResponse_Wrapper inputResponse, profitability_analysis__c paRecord) {

        List<profitability_analysis_external_document__c> extDocsToCreateList = new List<profitability_analysis_external_document__c>();

        Map<String, profitability_analysis_external_document__c> currentDocsMap = getCurrentDocs(paRecord);

        if (inputResponse.documents != null && inputResponse.documents.size() >0) {
            for(PicassoResponse_Wrapper.Document inputDocument : inputResponse.documents){
                extDocsToCreateList.add(checkDocExists(inputResponse.operationId, inputDocument, currentDocsMap, paRecord));
            }
            if (!extDocsToCreateList.isEmpty()) {
                PAExternalDocument_Selector.upsertPAED(extDocsToCreateList);
            }
        }

    }

    /**
    * @description Obtains the target profitability analysis external documents
    * @param paRecord : target profitability analysis record
    * @return Map<String, profitability_analysis_external_document__c>
    */
    public static Map<String, profitability_analysis_external_document__c> getCurrentDocs(profitability_analysis__c paRecord) {

        Map<String, profitability_analysis_external_document__c> paCurrentDocsMap = new Map<String, profitability_analysis_external_document__c>();

        PAExternalDocument_Selector paExternalDocSelector = new PAExternalDocument_Selector(true);
        List<profitability_analysis_external_document__c> paCurrentDocsList = paExternalDocSelector.selectByProfAnalysis(new Set<Id>{paRecord.Id});

        for(profitability_analysis_external_document__c currentDoc : paCurrentDocsList) {
            paCurrentDocsMap.put(currentDoc.gf_external_operation_id__c + '_' + currentDoc.gf_document_id__c, currentDoc);
        }

        return paCurrentDocsMap;
    }

    /**
    * @description Checks if the input document alreday exists in the target profitability analysis
    * @param operationId: picasso request id
    * @param inputDocument : Picasso response input document
    * @param currentDocsMap : map with the target profitability analysis current documents
    * @param paRecord : target profitability analysis record
    * @return profitability_analysis_external_document__c
    */
    public static profitability_analysis_external_document__c checkDocExists(String operationId, PicassoResponse_Wrapper.Document inputDocument, Map<String, profitability_analysis_external_document__c> currentDocsMap, profitability_analysis__c paRecord) {

        profitability_analysis_external_document__c returnDoc;

        if (currentDocsMap != null && currentDocsMap.containsKey(operationId + '_' + inputDocument.id)) {
            returnDoc = currentDocsMap.get(operationId + '_' + inputDocument.id);
            returnDoc.gf_document_update_date__c = Date.today();

        } else {
            returnDoc = new profitability_analysis_external_document__c();
            returnDoc.gf_document_name__c = inputDocument.name;
            returnDoc.gf_document_id__c = inputDocument.id;
            returnDoc.gf_document_format_type__c = inputDocument.format;
            returnDoc.gf_profitablity_analysis_id__c = paRecord.Id;
            returnDoc.gf_external_operation_id__c = operationId;
            returnDoc.gf_document_update_date__c = Date.today();
        }

        return returnDoc;
    }

    /**
    * @description Updates the target profitability analysis record based on the input response
    * @param inputResponse : Picasso response input information
    * @param paRecord : target profitability analysis record
    */
    public static void updateProfAnalysis(PicassoResponse_Wrapper inputResponse, profitability_analysis__c paRecord) {

        Boolean toUpdate = false;

        switch on inputResponse.action.id {
            when '02','06' {
                paRecord.gf_pa_mgmt_stage_type_name__c = 'Formalized';
                paRecord.gf_pa_mgmt_status_type_name__c = 'Formalized';
                toUpdate = true;
            }
            when '05' {
                paRecord.gf_pa_mgmt_status_type_name__c = 'Formalization Returned';
                toUpdate = true;
            }
            when '03','04' {
                paRecord.gf_manl_formalization_req_id__c = null;
                toUpdate = true;
            }
        }

        if(toUpdate){
            ProfitabilityAnalysis_Helper.updatePA(new List<profitability_analysis__c>{paRecord});
        }
    }

    /**
    * @description Creates the audit records based on the Picasso input response
    * @param inputResponse : Picasso response input information
    * @param paRecord : target profitability analysis record
    */
    public static void createResponseAudit(PicassoResponse_Wrapper inputResponse, profitability_analysis__c paRecord) {

        Boolean toCreate = false;

        String auditNameLabel = null;
        String auditStyle = null;

        switch on inputResponse.action.id {
            when '01' {
                auditNameLabel = Label.notification_request_sample;
                auditStyle = 'infoAlt';
                toCreate = true;
            }
            when '02' {
                auditNameLabel = Label.formalization_request_sample;
                auditStyle = 'approveTop';
                toCreate = true;
            }
            when '05' {
                auditNameLabel = Label.restudy_request_sample;
                auditStyle = 'sendBack';
                toCreate = true;
            }
            when '06' {
                auditNameLabel = Label.partial_form_request_sample;
                auditStyle = 'approve';
                toCreate = true;
            }
        }

        if(toCreate) {
            dwp_cvad__Action_Audit__c audit = new dwp_cvad__Action_Audit__c();

            audit.dwp_cvad__action_audit_name__c = auditNameLabel;
            audit.dwp_cvad__action_audit_object_api_name__c = 'cuco__profitability_analysis__c';
            audit.dwp_cvad__action_audit_record_id__c = paRecord.id;
            audit.dwp_cvad__action_audit_style__c = auditStyle;
            audit.dwp_cvad__action_audit_date__c = DateTime.now();
            audit.dwp_cvad__action_audit_type__c = 'ProfitabilityAnalysis';
            audit.dwp_cvad__action_audit_user_id__c = UserInfo.getUserId();

            //Insert audit record
            Insert audit;

            dwp_cvad__Action_Audit_Detail__c auditDetail = new dwp_cvad__Action_Audit_Detail__c();
            auditDetail.dwp_cvad__action_audit_id__c = audit.id;
            auditDetail.dwp_cvad__action_audit_detail_content__c = setResponseHTML(inputResponse);
            auditDetail.dwp_cvad__action_audit_detail_content_format__c = 'HTML';
            auditDetail.dwp_cvad__action_audit_detail_display_order__c = 1;
            auditDetail.dwp_cvad__action_audit_detail_display_type__c = 'Embedded';

            //Insert auditDetail record
            Insert auditDetail;
        }
    }

    /**
    * @description Set the the input response information on an html format
    * @param inputResponse : Picasso response input information
    * @return String
    */
    public static String setResponseHTML(PicassoResponse_Wrapper inputResponse) {

        String html = '<p>&nbsp;</p><p>' + Label.request_description_sample + '</p><p>' + inputResponse.action.description + '</p><p>&nbsp;</p>';

        if(inputResponse.documents != null && inputResponse.documents.size()>0) {
            html = html + '<p>' + Label.request_documents_sample + '</p><ul>';

            for (PicassoResponse_Wrapper.Document inputDoc : inputResponse.documents) {
                html = html + '<li>' + inputDoc.name + '.' + inputDoc.format + '</li>';
            }

            html = html + '</ul><p>&nbsp;</p>';
        }

        return html;
    }
}