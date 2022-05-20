/**
* ────────────────────────────────────────────────────────────────────
* ListProposalNotebookConditions_Helper
* ────────────────────────────────────────────────────────────────────
* @author      Sara Torres <sara.torres.bermudez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-03-04
* @modified
* @systemLayer Domain
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
public class ListProposalNotebookConditions_Helper {
    /**
    * @description Private constructor to avoid sonar err
    */
    public String profSheetCode {get;set;}

    /**
    * @description Private constructor to avoid sonar err
    */
    public String userId {get;set;}

    /**
    * @description Private constructor to avoid sonar err
    */
    public Date conditionsDate {get;set;}

    /**
    * @description constructor ListProposalNotebookConditions_Helper
    * @param profSheetCode user code
    * @param conditionsDate date conditions
    */
    public ListProposalNotebookConditions_Helper (String profSheetCode, Date conditionsDate) {
        this.userId = ProfitabilityAnalysis_Service.obtainUserInfo((Id)UserInfo.getUserId());
        this.conditionsDate = conditionsDate;
        this.profSheetCode = profSheetCode;
    }

    /**
    * @description Service invocation with call to cs
    */
    public String generateRequest() {
        return JSON.serialize(this);
    }

    /**
    * @description Service invocation with call to cs
    */
    public HttpResponse callWs() {
        HttpResponse response;
        final iaso__GBL_integration_service__mdt serviceProp = iaso__GBL_integration_service__mdt.getInstance('listProposalNotebookConditions');
        if (serviceProp.iaso__Retrieve_Mock_LTA__c) {
            response = Utils.getResponseMock('listProposalNotebookConditions', null);
        } else {
            response = Utils.callWServices('listProposalNotebookConditions', generateRequest());
        }
        return response;
    }
}