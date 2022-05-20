/**
* ────────────────────────────────────────────────────────────────────────────────────
* AvailableActions_itf
* AvailableActions_itf apex class
* ────────────────────────────────────────────────────────────────────────────────────
* @author      Giancarlo Mastrogiorgio <giancarlo.Mastrogiorigo.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-05-21
* @modified
* @systemLayer Sample
* ────────────────────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────────────────────
*/
@SuppressWarnings('PMD.AvoidGlobalModifier, sf:DMLWithoutSharingEnabled ,sf:CyclomaticComplexity')
global with sharing class AvailableActionsSample implements AvailableActions_itf {

    global static Map<String,Object> checkAvailableAction(String action, Id profanalysisId) {

        final Map<String,object> mapResp = new Map<String,object>();
        final Set<Id> ids = new Set<Id>{profanalysisId};
        final ProfitabilityAnalysis_Selector profAnSelector = new ProfitabilityAnalysis_Selector(true);
        final List<profitability_analysis__c> currentpa = profAnSelector.selectById(ids);

        switch on action {
            when 'PA_Dismiss' {
                List<String> paDismissStatusLst = new List<String>{'Restudy', 'Price Approved', 'Price Authorized', 'Price Returned', 'Analysis'};
                if((currentpa[0].gf_pa_management_type_name__c == 'Cancellation' && currentpa[0].gf_pa_mgmt_status_type_name__c == 'Analysis')
                    || (currentpa[0].gf_pa_management_type_name__c  != 'Cancellation' && paDismissStatusLst.contains(currentpa[0].gf_pa_mgmt_status_type_name__c) && currentpa[0].gf_auto_formalization_req_id__c == null)) {
                    mapResp.put('success', true);
                } else {
                    mapResp.put('success', false);
                    mapResp.put('message', Label.action_not_available_sample);
                }
            }
            when 'PA_Price_Approval' {
                List<String> paPriceApprovalStatusLst = new List<String>{'Analysis', 'Restudy', 'Sent for Price Approval', 'Sent for Price Approval Top'};
                mapResp.put('success', true);
                if (currentpa[0].gf_pa_management_type_name__c == 'Cancellation' || !paPriceApprovalStatusLst.contains(currentpa[0].gf_pa_mgmt_status_type_name__c)) {
                    mapResp.put('success', false);
                    mapResp.put('message', Label.action_not_available_sample);
                }
            }
            when 'PA_Approve_Price' {
                mapResp.put('success', true);
                if(currentpa[0].gf_pa_management_type_name__c == 'Cancellation' || currentpa[0].gf_pa_mgmt_status_type_name__c != 'Price Authorized') {
                    mapResp.put('success', false);
                    mapResp.put('message', Label.action_not_available_sample);
                }
            }
            when 'PA_Restudy' {
                mapResp.put('success', true);
                List<String> paRestudySampleStatusLst = new List<String>{'Price Approved', 'Price Authorized', 'Price Returned', 'Formalization Returned'};
                if (currentpa[0].gf_pa_management_type_name__c == 'Cancellation' || !paRestudySampleStatusLst.contains(currentpa[0].gf_pa_mgmt_status_type_name__c)) {
                    mapResp.put('success', false);
                    mapResp.put('message', Label.action_not_available_sample);
                }
            }
            when 'PA_Formalization' {
                mapResp.put('success', true);
                if(currentpa[0].gf_pa_management_type_name__c != 'Cancellation' && (currentpa[0].gf_pa_mgmt_status_type_name__c != 'Price Approved' && currentpa[0].gf_pa_mgmt_status_type_name__c != 'Pending Send for Manual Formalization')) {
                    mapResp.put('success', false);
                    mapResp.put('message', Label.action_not_available_sample);
                } else if (currentpa[0].gf_pa_management_type_name__c == 'Cancellation' && currentpa[0].gf_pa_mgmt_status_type_name__c != 'Analysis') {
                    mapResp.put('success', false);
                    mapResp.put('message', Label.action_not_available_sample);
                }
            }
            when 'PA_Notification' {
                mapResp.put('success', true);
                if(currentpa[0].gf_pa_mgmt_status_type_name__c != 'Sent for Formalization') {
                    mapResp.put('success', false);
                    mapResp.put('message', Label.action_not_available_sample);
                }
            }
        }
        return mapResp;
    }
}