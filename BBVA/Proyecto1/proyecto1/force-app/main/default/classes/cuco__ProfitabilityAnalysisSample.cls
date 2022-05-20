/**
* ────────────────────────────────────────────────────────────────────
* Profitability Analysis Sample
* Sample implementation of the multiple methods from ProfitabilityAnalysis_Itf
* ────────────────────────────────────────────────────────────────────
* @author      Sara Torres <sara.torres.bermudez.contractor@bbva.com>
* @modifiedBy   Miguel Cabrera <miguel.cabrera@bbvaitspain.com>
* @version     1.0
* @created     2021-02-24
* @modified
* @systemLayer Sample
* ────────────────────────────────────────────────────────────────────
* @changes  Added getARCEDate, getPriceDecisions, setPriceDecision
* getPriceDecisionLabel, getAuditDecisionLabel and getAuditDecisionLabel methods
*
* ────────────────────────────────────────────────────────────────────
*/
@SuppressWarnings('PMD.AvoidGlobalModifier')
global with sharing class ProfitabilityAnalysisSample implements ProfitabilityAnalysis_Itf {
    /**
    * @description method that receives the user's id and returns the Federation Identifier
    * @param userId : user Id
    * @return String
    */
    global String getUserCode(Id userId) {
        return [SELECT FederationIdentifier FROM User WHERE Id = :userId LIMIT 1].FederationIdentifier;
    }

    /*
    * @description method that receives the user's Federation id and returns the User Id
    * @param userCode : user federation id
    * @return String
    */
    global Id getUserId(String userCode) {
        return [SELECT Id FROM User WHERE FederationIdentifier = :userCode LIMIT 1].Id;
    }

    /**
    * @description method that returns the branch code
    * @param userId : user Id
    * @return String
    */
    global String getBranchCode(Id contextRecordId, String contextObject) {
        String res;
        switch on contextObject {
            when 'cuco__profitability_analysis__c' {
                res = [SELECT participant_id__r.Sic FROM profitability_analysis__c WHERE Id =:contextRecordId LIMIT 1].participant_id__r.Sic;
            }
            when 'cuco__profitability_sheet__c' {
                res = [SELECT participant_id__r.Sic FROM profitability_sheet__c WHERE Id =:contextRecordId LIMIT 1].participant_id__r.Sic;
            }
        }
        return res;
    }

    /**
    * @description method default values for creation data
    * @param profAnalysis : object profitability analysis
    * @return object profitability_analysis__c
    */

    global profitability_analysis__c setPADefaultCreationData (profitability_analysis__c profAnalysis) {
        final list <Account> lstAcc = [SELECT OwnerId FROM Account WHERE id =: profAnalysis.participant_id__c];
        profAnalysis.OwnerId = lstAcc[0].OwnerId;
        return profAnalysis;
    }

    /**
    * @description method for creating a default request profitability analysis
    * @param profAnalysis : object profitability analysis
    * @param branchCode : String with branch code
    * @param userCode : String with user code
    * @return profitability_analysis__c updated record
    */

    global profitability_analysis__c setPADefaultRequestData (profitability_analysis__c profAnalysis, String branchCode, String userCode) {
        String profAnalysisName = profAnalysis.Name;
        switch on profAnalysis.cuco__gf_pa_management_type_name__c {
            when 'Renewal' {
                profAnalysisName = (Label.renewal + ' - ' + profAnalysis.Name);
            }
            when 'Novation' {
                profAnalysisName = (Label.novation + ' - ' + profAnalysis.Name);
            }
            when 'Cancellation' {
                profAnalysisName = (Label.cancellation + ' - ' + profAnalysis.Name);
            }
        }
        if (profAnalysisName.length() > 80) {
            profAnalysisName = profAnalysisName.substring(0, 80);
        }
        profAnalysis.Name = profAnalysisName;
        return profAnalysis;
    }

    /**
    * @description method default values for creation data
    * @param profAnalysisId : context profitability analysis id
    * @return date : return Arce date
    */

    global date getARCEDate (Id profAnalysisId) {

        if (Math.random() < 0.5) {
            return null;
        }
        if (Math.random() >= 0.5) {
            return date.today().addDays(30);
        }
        return null;
    }

    /**
    * @description method that returns a price decission wrapper object list by his decision id list
    * @param decisionsIdsList : a decision id's list
    * @param currentStatus : current status of the analysis
    * @return List<PriceDecision_Wrapper> : return a price decision wrapper object
    */

    global List<PriceDecision_Wrapper> getPriceDecisions (List<String> decisionsIdsList, String currentStatus) {

        final List<PriceDecision_Wrapper> lstToReturn = new List<PriceDecision_Wrapper>();

        for (String decision : decisionsIdsList) {

            String style = null;
            String name = null;
            switch on decision {
                when 'A' {		// when decision is A and  the status is 'Sent for Price Approval' return scaletop else return scaleup
                    if (currentStatus == 'Sent for Price Approval') {
                        style = 'scaletop';
                        name = Label.price_dec_elevateTop_sample;
                    } else {
                        style = 'scaleup';
                        name = Label.price_dec_elevate_sample;
                    }
                }
                when 'Y' {		// when decision is Y
                    // return the string scaleup
                    style = 'scaleup';
                    name = Label.price_dec_elevate_sample;
                }
                when 'Z' {		// when decision is Z
                    // return the string scaltop
                    style = 'scaltop';
                    name = Label.price_dec_elevateTop_sample;
                }
                when 'B' {		// when decision is B
                    // return the string aprove
                    style = 'approve';
                    name = Label.price_dec_approve_sample;
                }
                when 'S' {		// when decision is S
                    // return the string aprove
                    style = 'approve';
                    name = Label.price_dec_authorize_sample;
                }
                when 'E' {		// when decision is E
                    // return the string deny
                    style = 'deny';
                    name = Label.price_dec_return_sample;
                }
            }
            PriceDecision_Wrapper pdw = new PriceDecision_Wrapper();
            pdw.id = decision;
            pdw.name = name;
            pdw.style = style;

            lstToReturn.add(pdw);
        }
        return lstToReturn;
    }

    /**
    * @description method that returns a price decission wrapper object list by his decision id list
    * @param decisionsIdsList : a decision id's list
    * @param ProfitabilityAnalysis_Wrapper : profAnalysis wrapper object
    * @param String : a decision id
    * @param String : a screenShot
    * @return Map<String, Object> : return a string object map with the result of the update
    */

    global Map<String, Object> setPriceDecision (ProfitabilityAnalysis_Wrapper profAnalysis, String decisionId, String decisionComments, String screenShot) {

        final Map<String, Object> mapToReturn = new Map<String, Object>();
        final ProfitabilityAnalysis_Selector paSelector = new ProfitabilityAnalysis_Selector();
        final List<profitability_analysis__c> lstPA = paSelector.selectById(new Set<Id>{profAnalysis.id});

        if (lstPA != null && !lstPA.isEmpty()) {
            String status = null;
            switch on decisionId {
                when 'A' {		// when decision is A and status is 'Sent for Price Approval'
                    if (profAnalysis.status == 'Sent for Price Approval') {
                        status = 'Sent for Price Approval Top';
                    }
                    if (profAnalysis.status != 'Sent for Price Approval'){
                        status = 'Sent for Price Approval';
                    }
                }
                when 'Y' {		// when decision is Y
                    status = 'Sent for Price Approval';
                }
                when 'Z' {		// when decision is Z
                    status = 'Sent for Price Approval Top';
                }
                when 'B' {		// when decision is B
                    status = 'Price Approved';
                }
                when 'S' {		// when decision is S
                    status = 'Price Authorized';
                }
                when 'E' {		// when decision is E
                    status = 'Price Returned';
                }
            }
            lstPA[0].cuco__gf_pa_aprvl_proc_deleg_br_id__c = profAnalysis.delegatedBranchCode;
            lstPA[0].cuco__gf_pa_mgmt_stage_type_name__c = 'Price Approval';
            lstPA[0].cuco__gf_pa_mgmt_status_type_name__c = status;
            lstPA[0].cuco__gf_pa_cond_appl_expiry_date__c = profAnalysis.endDate;

            //Update profitability analysis
            Utils.DML_Wrapper updateResult = ProfitabilityAnalysis_Helper.updatePA(lstPA);
            //add to returned map the result
            mapToReturn.put('success', updateResult.isSuccess);
            mapToReturn.put('message', updateResult.isSuccess ? Label.price_approval_success_sample : Label.price_approval_error_sample  + ' ' + updateResult.lstErrMessage.toString());

            if (updateResult.isSuccess) {
                String auditNameLabel = null;
                String auditStyle = null;
                switch on decisionId {
                    when 'A' {		// when decision is A and  the status is 'Sent for Price Approval' return scaletop else return scaleup
                        if (lstPA[0].cuco__gf_pa_mgmt_status_type_name__c == 'Sent for Price Approval') {
                            auditNameLabel = Label.price_dec_elevate_sample;
                            auditStyle = 'elevate';
                        }
                        if (lstPA[0].cuco__gf_pa_mgmt_status_type_name__c == 'Sent for Price Approval Top') {
                            auditNameLabel = Label.price_dec_elevateTop_sample;
                            auditStyle = 'elevateTop';
                        }
                    }
                    when 'Y' {		// when decision is Y
                        // return the string elevate
                        auditNameLabel = Label.price_dec_elevate_sample;
                        auditStyle = 'elevate';
                    }
                    when 'Z' {		// when decision is Z
                        // return the string elevateTop
                        auditNameLabel = Label.price_dec_elevateTop_sample;
                        auditStyle = 'elevateTop';
                    }
                    when 'B' {		// when decision is B
                        // return the string approve
                        auditNameLabel = Label.price_dec_approve_sample;
                        auditStyle = 'approve';
                    }
                    when 'S' {		// when decision is S
                        // return the string approveTop
                        auditNameLabel = Label.price_dec_authorize_sample;
                        auditStyle = 'approveTop';
                    }
                    when 'E' {		// when decision is E
                        // return the string sendBack
                        auditNameLabel = Label.price_dec_return_sample;
                        auditStyle = 'sendBack';
                    }
                }
                dwp_cvad__Action_Audit__c audit = new dwp_cvad__Action_Audit__c();

                audit.dwp_cvad__action_audit_name__c = auditNameLabel;
                audit.dwp_cvad__action_audit_object_api_name__c = 'cuco__profitability_analysis__c';
                audit.dwp_cvad__action_audit_record_id__c = profAnalysis.id;
                audit.dwp_cvad__action_audit_style__c = auditStyle;
                audit.dwp_cvad__action_audit_date__c = DateTime.now();
                audit.dwp_cvad__action_audit_type__c = 'ProfitabilityAnalysis';
                audit.dwp_cvad__action_audit_user_id__c = UserInfo.getUserId();

                //Insert audit record
                Insert audit;

                dwp_cvad__Action_Audit_Detail__c auditDetail = new dwp_cvad__Action_Audit_Detail__c();
                auditDetail.dwp_cvad__action_audit_id__c = audit.id;
                auditDetail.dwp_cvad__action_audit_detail_content__c = screenShot;
                auditDetail.dwp_cvad__action_audit_detail_content_format__c = 'HTML';
                auditDetail.dwp_cvad__action_audit_detail_display_order__c = 1;
                auditDetail.dwp_cvad__action_audit_detail_display_type__c = 'Embedded';

                //Insert auditDetail record
                Insert auditDetail;
            }
        }
        return mapToReturn;
    }

    /**
    * @description returns wrapper info updated for profAnalysis
    * @param profAnalysis : ProfitabilityAnalysis_Wrapper wrapper with profitability_analysis__c info
    * @param approvalComments : String with comments
    * @return Map<String, Object> map with the response
    */

    global Map<String, Object> setPAApprovePrice(ProfitabilityAnalysis_Wrapper profAnalysis, String approvalComments) {
        final Map<String,Object> retMap = new Map<String,Object>();
        final Set<Id> setPaId = new Set<Id>{profAnalysis.Id};
        final ProfitabilityAnalysis_Selector paSelector = new ProfitabilityAnalysis_Selector(true);
        final List<profitability_analysis__c> lstPA = paSelector.selectById(setPaId);
        if(!lstPA.isEmpty()) {
            lstPA[0].cuco__gf_pa_mgmt_stage_type_name__c = 'Price Approval';
            lstPA[0].cuco__gf_pa_mgmt_status_type_name__c = 'Price Approved';
        }

        /* DML actions */
        final Utils.DML_Wrapper dmlUpdatePA = ProfitabilityAnalysis_Helper.updatePA(lstPA);

        if(dmlUpdatePA.isSuccess == true) {
            retMap.put('success',true);
            retMap.put('message',Label.approve_price_success_sample);
            final dwp_cvad__Action_Audit__c audit = new dwp_cvad__Action_Audit__c(
                dwp_cvad__action_audit_name__c = Label.approve_price_action_sample,
                dwp_cvad__action_audit_object_api_name__c = 'cuco__profitability_analysis__c',
                dwp_cvad__action_audit_record_id__c = profAnalysis.Id,
                dwp_cvad__action_audit_style__c = 'approve',
                dwp_cvad__action_audit_date__c = DateTime.now(),
                dwp_cvad__action_audit_type__c = 'ProfitabilityAnalysis',
                dwp_cvad__action_audit_user_id__c = UserInfo.getUserId(),
                dwp_cvad__audit_audit_comments__c = approvalComments
            );
            Database.insert(audit);
        } else {
            retMap.put('success',false);
            retMap.put('message',Label.approve_price_error_sample + ' ' + dmlUpdatePA.lstErrMessage);
        }
        return retMap;
    }

    /**
    * @description Do the actions of dismissal of profitability analysis
    * @param profAnalysis : Wrapper with related info of profAnalysis
    * @param dismissalComments : String with dismissal comments value
    * @param screenShot : String with value to audit record
    * @return Map<String, Object>, with action results
    */

    global Map<String, Object> setPADismissal(ProfitabilityAnalysis_Wrapper profAnalysis, String dismissalComments, String screenShot) {
        final Map<String, Object> retMap = new Map<String, Object>();

        // First, update context prof analysis id (Stage and status fields)
        final ProfitabilityAnalysis_Selector paSelector = new ProfitabilityAnalysis_Selector(true);
        final List<profitability_analysis__c> lstPA = paSelector.selectById(new Set<Id>{profAnalysis.id});
        lstPA[0].gf_pa_mgmt_stage_type_name__c = 'Dismissed';
        lstPA[0].gf_pa_mgmt_status_type_name__c = 'Dismissed';
        final Utils.DML_Wrapper updateResult = ProfitabilityAnalysis_Helper.updatePA(lstPA);
        retMap.put('success', updateResult.isSuccess);
        retMap.put('message', updateResult.isSuccess ? Label.dismissal_success_sample : Label.dismissal_error_sample + ' ' + updateResult.lstErrMessage.toString());

        // Second, create new audit and audit detail records
        if (updateResult.isSuccess) {
            final dwp_cvad__Action_Audit__c dismissalAudit = new dwp_cvad__Action_Audit__c();
            dismissalAudit.dwp_cvad__action_audit_name__c = Label.dismissal_action_sample;
            dismissalAudit.dwp_cvad__action_audit_object_api_name__c = 'cuco__profitability_analysis__c';
            dismissalAudit.dwp_cvad__action_audit_record_id__c = profAnalysis.id;
            dismissalAudit.dwp_cvad__action_audit_style__c = 'deny';
            dismissalAudit.dwp_cvad__action_audit_date__c = DateTime.now();
            dismissalAudit.dwp_cvad__action_audit_type__c = 'ProfitabilityAnalysis';
            dismissalAudit.dwp_cvad__action_audit_user_id__c = UserInfo.getUserId();
            Insert dismissalAudit;

            final dwp_cvad__Action_Audit_Detail__c dismissalAuditDetail = new dwp_cvad__Action_Audit_Detail__c();
            dismissalAuditDetail.dwp_cvad__action_audit_id__c = dismissalAudit.id;
            dismissalAuditDetail.dwp_cvad__action_audit_detail_content__c = screenShot;
            dismissalAuditDetail.dwp_cvad__action_audit_detail_content_format__c = 'HTML';
            dismissalAuditDetail.dwp_cvad__action_audit_detail_display_order__c = 1;
            dismissalAuditDetail.dwp_cvad__action_audit_detail_display_type__c = 'Embedded';
            Insert dismissalAuditDetail;
        }
        return retMap;
    }

    /**
    * @description returns wrapper info updated for profAnalysis in formalization
    * @param profAnalysis : ProfitabilityAnalysis_Wrapper wrapper with profitability_analysis__c info
    * @param formMethod : String with method to formalize
    * @param formComments : String with comments
    * @param screenShot : String with screen shot id
    * @return Map<String, Object> map with the response
    */
    global Map<String, Object> setPAFormalization(ProfitabilityAnalysis_Wrapper profAnalysis, String formMethod, String formComments, String screenShot) {
        final Map<String,Object> retMap = new Map<String,Object>();
        final ProfitabilityAnalysisSample paSample = new ProfitabilityAnalysisSample();
        final Set<Id> setPaId = new Set<Id>{profAnalysis.Id};
        final ProfitabilityAnalysis_Selector paSelector = new ProfitabilityAnalysis_Selector(true);
        List<profitability_analysis__c> lstPA = paSelector.selectById(setPaId);
        if(!lstPA.isEmpty()) {
            lstPA = paSample.updProfAnalysis(lstPA, profAnalysis, formMethod);
        }

        /* DML actions */
        final Utils.DML_Wrapper dmlUpdatePA = ProfitabilityAnalysis_Helper.updatePA(lstPA);

        if(dmlUpdatePA.isSuccess == true && formMethod != null) {
            /* audit info */
            final dwp_cvad__Action_Audit__c audit = paSample.createAuditForm(profAnalysis, formMethod, formComments);
            Database.insert(audit);

            /* audit detail info */
            final dwp_cvad__Action_Audit_Detail__c auditDetail = new dwp_cvad__Action_Audit_Detail__c(
                dwp_cvad__action_audit_id__c = audit.id,
                dwp_cvad__action_audit_detail_content__c = screenShot,
                dwp_cvad__action_audit_detail_content_format__c = 'HTML',
                dwp_cvad__action_audit_detail_display_order__c = 1,
                dwp_cvad__action_audit_detail_display_type__c = 'Embedded'
            );
            Database.insert(auditDetail);

            retMap.put('success', true);
            if(formMethod == Label.form_combined_method) {
                retMap.put('message', Label.form_complete_success_sample);
            } else if(formMethod == Label.form_automatic_method) {
                retMap.put('message', Label.form_sent_success_sample);
            }
        } else if (dmlUpdatePA.isSuccess == true && formMethod == null) {
            retMap.put('success', true);
            retMap.put('message', Label.form_sent_success_sample);
        } else {
            retMap.put('success', false);
            retMap.put('message', Label.form_error_sample + ' ' + dmlUpdatePA.lstErrMessage.toString());
        }

        return retMap;
    }

    /**
    * @description private method to update profitability analysis record
    * @param lstPA : list with profitability analysis record to update
    * @param profAnalysis : ProfitabilityAnalysis_Wrapper wrapper with profitability_analysis__c info
    * @param formMethod : String with method to formalize
    * @return List<profitability_analysis__c> with updated list
    */
    private List<profitability_analysis__c> updProfAnalysis(List<profitability_analysis__c> lstPA, ProfitabilityAnalysis_Wrapper profAnalysis, String formMethod) {

        if(formMethod == Label.form_combined_method) {
            lstPA[0].gf_pa_mgmt_stage_type_name__c = 'Formalization';
            lstPA[0].gf_pa_mgmt_status_type_name__c = 'Sent for Formalization';
            lstPA[0].gf_manl_formalization_req_id__c = profAnalysis.manualFormRequestId;
            if (profAnalysis.status != 'Pending Send for Manual Formalization') {
                lstPA[0].gf_pa_cond_appl_eff_date__c = profAnalysis.startDate;
                if(lstPA[0].gf_pa_management_type_name__c != Label.cancellation) {
                    lstPA[0].gf_pa_cond_appl_expiry_date__c = profAnalysis.endDate;
                }
                lstPA[0].gf_auto_formalization_req_id__c = profAnalysis.autoFormRequestId;
                lstPA[0].gf_auto_form_sys_lst_cmun_date__c = Date.today();
            }
        } else if(formMethod == Label.form_automatic_method) {
            lstPA[0].gf_pa_mgmt_stage_type_name__c = 'Formalized';
            lstPA[0].gf_pa_mgmt_status_type_name__c = 'Formalized';
            lstPA[0].gf_pa_cond_appl_eff_date__c = profAnalysis.startDate;
            if(lstPA[0].gf_pa_management_type_name__c != Label.cancellation) {
                lstPA[0].gf_pa_cond_appl_expiry_date__c = profAnalysis.endDate;
            }
            lstPA[0].gf_auto_formalization_req_id__c = profAnalysis.autoFormRequestId;
            lstPA[0].gf_auto_form_sys_lst_cmun_date__c = Date.today();
        } else if (formMethod == null) {
            lstPA[0].gf_pa_mgmt_stage_type_name__c = 'Formalization';
            lstPA[0].gf_pa_mgmt_status_type_name__c = 'Pending Send for Manual Formalization';
            lstPA[0].gf_pa_cond_appl_eff_date__c = profAnalysis.startDate;
            if(lstPA[0].gf_pa_management_type_name__c != Label.cancellation) {
                lstPA[0].gf_pa_cond_appl_expiry_date__c = profAnalysis.endDate;
            }
            lstPA[0].gf_auto_formalization_req_id__c = profAnalysis.autoFormRequestId;
            lstPA[0].gf_auto_form_sys_lst_cmun_date__c = Date.today();
        }
        return lstPA;
    }

    /**
    * @description private method to create audit action record
    * @param profAnalysis : ProfitabilityAnalysis_Wrapper wrapper with profitability_analysis__c info
    * @param formMethod : String with method to formalize
    * @param formComments : String with comments
    * @return dwp_cvad__Action_Audit__c action audit record
    */
    private dwp_cvad__Action_Audit__c createAuditForm(ProfitabilityAnalysis_Wrapper profAnalysis, String formMethod, String formComments) {
        final dwp_cvad__Action_Audit__c audit = new dwp_cvad__Action_Audit__c(
            dwp_cvad__action_audit_object_api_name__c = 'cuco__profitability_analysis__c',
            dwp_cvad__action_audit_record_id__c = profAnalysis.Id,
            dwp_cvad__action_audit_date__c = DateTime.now(),
            dwp_cvad__action_audit_type__c = 'ProfitabilityAnalysis',
            dwp_cvad__action_audit_user_id__c = UserInfo.getUserId()
        );
        if(formMethod == Label.form_combined_method) {
            audit.dwp_cvad__action_audit_name__c = Label.form_sent_sample;
            audit.dwp_cvad__action_audit_style__c = 'elevate';
        } else if(formMethod == Label.form_automatic_method) {
            audit.dwp_cvad__action_audit_name__c = Label.form_complete_sample;
            audit.dwp_cvad__action_audit_style__c = 'approve';
        }
        return audit;
    }

    /**
    * @description Do the actions of restudy of profitability analysis
    * @param profAnalysis : Wrapper with related info of profAnalysis
    * @param dismissalComments : String with dismissal comments value
    * @param screenShot : String with value to audit record
    * @return Map<String, Object>, with action results
    */
    global Map<String, Object> setPARestudy(ProfitabilityAnalysis_Wrapper profAnalysis, String restudyComments, String screenShot) {
        final Map<String, Object> retMap = new Map<String, Object>();

        // First, update context prof analysis id (Stage and status fields) and empty certains fields in funtion of stage value
        final ProfitabilityAnalysis_Selector paSelector = new ProfitabilityAnalysis_Selector(true);
        final List<profitability_analysis__c> lstPA = paSelector.selectById(new Set<Id>{profAnalysis.id});

        if (profAnalysis.stage == 'Price Approval') {
            lstPA[0].gf_pa_price_negotiated_date__c = null;
            lstPA[0].gf_pa_aprvl_proc_deleg_br_id__c = null;
        } else if (profAnalysis.stage == 'Formalization') {
            lstPA[0].gf_price_aprvl_process_req_id__c = null;
            lstPA[0].gf_pa_price_negotiated_date__c = null;
            lstPA[0].gf_pa_aprvl_proc_deleg_br_id__c = null;
        }
        lstPA[0].gf_pa_mgmt_stage_type_name__c = 'Analysis';
        lstPA[0].gf_pa_mgmt_status_type_name__c = 'Restudy';
        final Utils.DML_Wrapper updateResult = ProfitabilityAnalysis_Helper.updatePA(lstPA);
        retMap.put('success', updateResult.isSuccess);
        retMap.put('message', updateResult.isSuccess ? Label.restudy_success_sample : Label.restudy_error_sample + ' ' + updateResult.lstErrMessage.toString());

        // Second, create new audit and audit detail records
        if (updateResult.isSuccess) {
            final dwp_cvad__Action_Audit__c restudyAudit = new dwp_cvad__Action_Audit__c();
            restudyAudit.dwp_cvad__action_audit_name__c = Label.restudy_sample;
            restudyAudit.dwp_cvad__action_audit_object_api_name__c = 'cuco__profitability_analysis__c';
            restudyAudit.dwp_cvad__action_audit_record_id__c = profAnalysis.id;
            restudyAudit.dwp_cvad__action_audit_style__c = 'restudy';
            restudyAudit.dwp_cvad__action_audit_date__c = DateTime.now();
            restudyAudit.dwp_cvad__action_audit_type__c = 'ProfitabilityAnalysis';
            restudyAudit.dwp_cvad__action_audit_user_id__c = UserInfo.getUserId();
            Insert restudyAudit;

            final dwp_cvad__Action_Audit_Detail__c restudyAuditDetail = new dwp_cvad__Action_Audit_Detail__c();
            restudyAuditDetail.dwp_cvad__action_audit_id__c = restudyAudit.id;
            restudyAuditDetail.dwp_cvad__action_audit_detail_content__c = screenShot;
            restudyAuditDetail.dwp_cvad__action_audit_detail_content_format__c = 'HTML';
            restudyAuditDetail.dwp_cvad__action_audit_detail_display_order__c = 1;
            restudyAuditDetail.dwp_cvad__action_audit_detail_display_type__c = 'Embedded';
            Insert restudyAuditDetail;
        }
        return retMap;
    }

    /**
    * @description Auxiliar method to obtain FirstName and LastName from a Owner Id. If its a Group id, returns empty string.
    * @param ownerId : Id of the User/Group
    * @return String, with FirstName and LastName concatenated
    */
    global String getFirstAndLastName(Id ownerId) {
        String str;
        try {
            User u = [SELECT Id, FirstName, LastName FROM User WHERE Id =: ownerId LIMIT 1];
            str = u.FirstName + ' ' + u.LastName;
        } catch (Exception e) {
            str = '';
        }
        return str;
    }

    /**
    * @description Do the actions of notification of profitability analysis
    * @param profAnalysis : Wrapper with related info of profAnalysis
    * @param notificationComments : String with notification comments value
    * @param screenShot : String with value to audit record
    * @return Map<String, Object>, with action results
    */
    global Map<String, Object> setPANotification(ProfitabilityAnalysis_Wrapper profAnalysis, String notificationComments, String screenShot) {
        final Map<String, Object> retMapNotification = new Map<String, Object>();

        // First, update gf_manl_formalization_req_id__c field of context prof analysis id
        final ProfitabilityAnalysis_Selector paSelectorNotification = new ProfitabilityAnalysis_Selector(true);
        final List<profitability_analysis__c> lstPANotification = paSelectorNotification.selectById(new Set<Id>{profAnalysis.id});
        lstPANotification[0].gf_manl_formalization_req_id__c = profAnalysis.manualFormRequestId;

        final Utils.DML_Wrapper updateNotificationResult = ProfitabilityAnalysis_Helper.updatePA(lstPANotification);
        retMapNotification.put('success', updateNotificationResult.isSuccess);
        retMapNotification.put('message', updateNotificationResult.isSuccess ? Label.notification_success_sample : Label.notification_error_sample + ' ' + updateNotificationResult.lstErrMessage.toString());

        // Second, create new audit and audit detail records
        if (updateNotificationResult.isSuccess) {
            final dwp_cvad__Action_Audit__c notificationAudit = new dwp_cvad__Action_Audit__c();
            notificationAudit.dwp_cvad__action_audit_name__c = Label.notification_action_sample;
            notificationAudit.dwp_cvad__action_audit_object_api_name__c = 'cuco__profitability_analysis__c';
            notificationAudit.dwp_cvad__action_audit_record_id__c = profAnalysis.id;
            notificationAudit.dwp_cvad__action_audit_style__c = 'quickText';
            notificationAudit.dwp_cvad__action_audit_date__c = DateTime.now();
            notificationAudit.dwp_cvad__action_audit_type__c = 'ProfitabilityAnalysis';
            notificationAudit.dwp_cvad__action_audit_user_id__c = UserInfo.getUserId();
            Insert notificationAudit;

            final dwp_cvad__Action_Audit_Detail__c notificationAuditDetail = new dwp_cvad__Action_Audit_Detail__c();
            notificationAuditDetail.dwp_cvad__action_audit_id__c = notificationAudit.id;
            notificationAuditDetail.dwp_cvad__action_audit_detail_content__c = screenShot;
            notificationAuditDetail.dwp_cvad__action_audit_detail_content_format__c = 'HTML';
            notificationAuditDetail.dwp_cvad__action_audit_detail_display_order__c = 1;
            notificationAuditDetail.dwp_cvad__action_audit_detail_display_type__c = 'Embedded';
            Insert notificationAuditDetail;
        }
        return retMapNotification;
    }
}