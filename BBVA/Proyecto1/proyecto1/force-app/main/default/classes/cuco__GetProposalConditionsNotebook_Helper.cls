/**
* ────────────────────────────────────────────────────────────────────
* GetProposalConditionsNotebook_Helper
* ────────────────────────────────────────────────────────────────────
* @author      Sara Torres <sara.torres.bermudez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-02-25
* @modified
* @systemLayer Domain
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
public class GetProposalConditionsNotebook_Helper {
    /**
    * @description Private constructor to avoid sonar err
    */
    public String profSheetCode {get;set;}

    /**
    * @description Private constructor to avoid sonar err
    */
    public String userId {get;set;}

    /**
    * @description constructor GetProposalConditionsNotebook_Helper
    * @param profSheetCode user code
    */
    public GetProposalConditionsNotebook_Helper (String profSheetCode) {
        this.userId = ProfitabilityAnalysis_Service.obtainUserInfo((Id)UserInfo.getUserId());
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
        final iaso__GBL_integration_service__mdt serviceProp = iaso__GBL_integration_service__mdt.getInstance('getProposalConditionsNotebook');
        if (serviceProp.iaso__Retrieve_Mock_LTA__c) {
            response = Utils.getResponseMock('getProposalConditionsNotebook', null);
        } else {
            response = Utils.callWServices('getProposalConditionsNotebook', generateRequest());
        }
        return response;
    }
}