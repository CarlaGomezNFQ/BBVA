/**
* ____________________________________________________________________________
* Price Decision Helper
* Name class: PriceDecision_Helper
* ____________________________________________________________________________
* @author      Miguel Cabrera <miguel.cabrera@bbvaitspain.com>
* @modifiedBy
* @version     1.0
* @created     2021-05-01
* @modified
* @systemLayer Service
* ____________________________________________________________________________
* @changes
*
* ____________________________________________________________________________
*/

    public with sharing class PriceDecision_Helper {

    /**
    * @Description : price negotiation id
    */
    private String negotiationId { get; set; }

    /**
    * @Description : context user code
    */
    private String userId { get; set; }

    /**
    * @Description : country code
    */
    private String countryCode { get; set; }

    /**
    * @Description : bank code
    */
    private String bankCode { get; set; }

    /**
    * @Description : negotiation branch code
    */
    private String branchCode { get; set; }

    /**
    * @Description : price decision code
    */
    private String decisionCode { get; set; }

    /**
    * @Description : price decision comments
    */
    private String decisionComments { get; set; }

    /**
    * @description Default public constructor to PriceDecision_Helper
    * @param profAnalysis: Information of the profitability analysis record
    * @param decisionCode: Price decision code
    * @param decisionComments: Price decision comments
    */
    public PriceDecision_Helper(ProfitabilityAnalysis_Wrapper profAnalysis, String decisionCode, String decisionComments) {

        //Fill basic information
        this.negotiationId = profAnalysis.priceApprovalId;
        this.userId = ProfitabilityAnalysis_Service.obtainUserInfo((Id) UserInfo.getUserId());
        this.countryCode = 'ES';
        this.bankCode = '0182';

        //Fill branch information
        if(profAnalysis.delegatedBranchCode != null) {
            this.branchCode = profAnalysis.delegatedBranchCode;
        } else {
            this.branchCode = profAnalysis.branchCode;
        }

        //Fill decision information
        this.decisionCode = decisionCode;
        this.decisionComments = decisionComments.replace('%','&#37;');
    }

    /**
    * @description Method to serialize values to call webservice
    */
    public String generateRequest() {
        return JSON.serialize(this);
    }

    /**
    * @description Method to invocate webdservice
    */
    public HttpResponse callWs() {
        HttpResponse response;
        final iaso__GBL_integration_service__mdt serviceProp = iaso__GBL_integration_service__mdt.getInstance('priceDecision');
        if (serviceProp.iaso__Retrieve_Mock_LTA__c) {
            response = Utils.getResponseMock('priceDecision', 200);
        } else {
            response = Utils.callWServices('priceDecision', generateRequest());
        }
        return response;
    }
}