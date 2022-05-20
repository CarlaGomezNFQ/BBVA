/* ────────────────────────────────────────────────────────────────────
* RequestCondNotebookCancellation_Helper
* Helper class for notebook cancellation web service call
* ────────────────────────────────────────────────────────────────────
* @author
* @modifiedBy
* @version     1.0
* @created
* @modified
* @systemLayer Service
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/

public with sharing class RequestCondNotebookCancellation_Helper   {

    /**
    * @description Cancellation WS configuration
    */
    private final static String CANCELLATION_WS = 'requestCondNotebookCancellation';

    /**
    * @Description : profitability sheet code
    */
    private String profSheetCode { get; set; }

    /**
    * @Description : context user code
    */
    private String userCode { get; set; }

    /**
    * @description Default public constructor to RequestCondNotebookCancellation_Helper
    * @param profAnalysis: Information of the profitability analysis record
    */
    public RequestCondNotebookCancellation_Helper(ProfitabilityAnalysis_Wrapper profAnalysis) {
        //Fill profitability sheet code to cancel
        this.profSheetCode = profAnalysis.code;
        //Fill user code to fill back-usercode header
        this.userCode = ProfitabilityAnalysis_Service.obtainUserInfo((Id) UserInfo.getUserId());
    }

    /**
    * @description Method to serialize values to call webservice
    */
    public String generateRequest() {
        return JSON.serialize(this, true);
    }

    /**
    * @description Method to invocate webdservice
    */
    public HttpResponse callWs() {
        HttpResponse response;
        final iaso__GBL_integration_service__mdt serviceProp = iaso__GBL_integration_service__mdt.getInstance(CANCELLATION_WS);
        if (serviceProp.iaso__Retrieve_Mock_LTA__c) {
            response = Utils.getResponseMock(CANCELLATION_WS, 204);
        } else {
            response = Utils.callWServices(CANCELLATION_WS, generateRequest());
        }
        return response;
    }
}