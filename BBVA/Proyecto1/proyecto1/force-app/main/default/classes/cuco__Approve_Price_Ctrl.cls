/**
* ────────────────────────────────────────────────────────────────────
* Approve_Price_Ctrl
* Controller class for approve_price_cmp Lightning Component
* ────────────────────────────────────────────────────────────────────
* @author      Oscar Gomez <oscar.gomez.arqueros.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-05-05
* @modified
* @systemLayer Presentation
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@SuppressWarnings('sf:AvoidHardCodedError')
public with sharing class Approve_Price_Ctrl {

  // Private constructor to avoid sonar err
  @TestVisible
  private Approve_Price_Ctrl() {}

    /**
    * @description Returns the needed info to display
    * @param profAnalysisId: String with profitability analysis id
    * @return Map<String, Object> with the response
    */
    @AuraEnabled
    public static Map<String, Object> approvePrice(String profAnalysisId) {
        Map<String, Object> mapRetApprovePrice = new Map<String, Object>();
        try {
            mapRetApprovePrice = Utils.checkAvailableAction('PA_Approve_Price', profAnalysisId);
        } catch (Exception e) { // NOSONAR
            throw new AuraHandledException(Label.generic_error + ' ' + e.getMessage()); // NOSONAR
        }

        if(mapRetApprovePrice.get('success') == false) {
            throw new AuraHandledException((String) mapRetApprovePrice.get('message'));
        } else {
            try {
                return Approve_Price_Service.approvePrice(profAnalysisId);
            } catch (Exception e) { // NOSONAR
                throw new AuraHandledException(Label.generic_error + ' ' + e.getMessage()); // NOSONAR
            }
        }
    }
}