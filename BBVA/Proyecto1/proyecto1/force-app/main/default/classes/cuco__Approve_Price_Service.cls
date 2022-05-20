/**
* ────────────────────────────────────────────────────────────────────
* Approve_Price_Service
* Service class for approve price implementation apex classes
* ────────────────────────────────────────────────────────────────────
* @author      Oscar Gomez <oscar.gomez.arqueros.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-05-05
* @modified
* @systemLayer Business Logic
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
public class Approve_Price_Service {

  /**
  * @description Private constructor to avoid sonar err
  */
  @TestVisible
  private Approve_Price_Service() {}

  /**
  * @description Check if user can approve price
  * @param profAnalysis: ProfitabilityAnalysis_Wrapper with profitability analysis info
  * @return Map<String, Object> with the response
  */
  public static Map<String, Object> approvePrice (String profAnalysisId) {
    Map<String,Object> returnMap = new Map<String,Object>();

    /* create wrapper of pa */
    final ProfitabilityAnalysis_Wrapper profAnalysis = ProfitabilityAnalysis_Helper.getProfAnalysis(profAnalysisId);

    /* get general configuration */
    final cuco__pa_general_configuration__mdt cmt = Utils.getGeneralConfiguration();

    if(cmt.cuco__price_approval_type__c == true && profAnalysis.priceApprovalId != null) {
        final PriceDecision_Helper decision = new PriceDecision_Helper(profAnalysis, cmt.cuco__price_approval_decision_id__c, Label.price_approve_default_comments);
        final HttpResponse response = decision.callWs();

        switch on response.getStatusCode() {
            when 200 {
                returnMap = ProfitabilityAnalysis_Service.setPAApprovePrice(profAnalysis, Label.price_approve_default_comments);
                returnMap.put('status',true);
            }
            when else {
                returnMap.put('status',false);
            }
        }
    } else {
        returnMap = ProfitabilityAnalysis_Service.setPAApprovePrice(profAnalysis, '');
    }
    return returnMap;
  }
}