/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_initOverlay_Controller
* @Author   amunguia.contractor@bbva.com
* @Date     Created: 18/04/2021
* @Group    ARCE
* -----------------------------------------------------------------------------------------------
* @Description Arc_Gen_initOverlay_Controller
* -----------------------------------------------------------------------------------------------
* @Changes
*
* |18-04-2021 amunguia.contractor@bbva.com
*             Class creation.
* -----------------------------------------------------------------------------------------------
*/
public with sharing class Arc_Gen_initOverlay_Controller {
    /**
    * --------------------------------------------------------------------------------------
    * Constructor
    **/
    @TestVisible
    private Arc_Gen_initOverlay_Controller() {}
    /**
    * @Class: MessageResponse
    * @Description: Container that contains the message for the Lightning component as a response
    * @author BBVA
    */
    public class MessageResponse {
        /**
        * @Description: Indicates status
        */
        @AuraEnabled public String status {get;set;}
        /**
        * @Description: Indicates message
        */
        @AuraEnabled public String message {get;set;}
        /**
        * @Description: Indicates cclients
        */
        @AuraEnabled public String cclients {get;set;}

        /**
        * @description messageResponse
        * @author amunguia.contractor@bbva.com | 05-11-2021
        **/
        public MessageResponse() {
            status = 'Success';
            message = 'OK';
        }
    }
    /**
    * @description calculate parent ratings
    * @author amunguia.contractor@bbva.com | 05-11-2021
    * @param String aHasAnalysId
    * @return MessageResponse
    **/
    @AuraEnabled
    public static MessageResponse calculateParentRatings(String aHasAnalysId) {
        final MessageResponse response = new MessageResponse();
        final arce__Account_has_Analysis__c accHasAnalysis = arce.Arc_Gen_AccHasAnalysis_Data.getAccHasAnalysis(new List<String>{aHasAnalysId})[0];
        final arce__Overlay__c overlayObj = arce.Arc_Gen_Overlays_Utils.getOverlaysByAha(new Set<String>{accHasAnalysis.Id})[0];
        if(!String.isBlank(overlayObj.arce__Arc_Gen_LocalId_VC__c)) {
            final Set<String> cclients = new Set<String>();
            final List<dyfr__Dependent_value__c> localIdList = (List<dyfr__Dependent_value__c>) JSON.deserialize(overlayObj.arce__Arc_Gen_LocalId_VC__c, List<dyfr__Dependent_value__c>.class);
            for(dyfr__Dependent_value__c dependent : localIdList) {
                cclients.addAll(dependent.dyfr__LoV_values__c.split(','));
            }
            response.cclients = JSON.serialize(cclients);
            final Map<String, arce__Financial_Statements__c> childWrpMap = arce.Arc_Gen_Account_Locator.getRatingGCPByAccountNumber(new List<String>(cclients));
            if(childWrpMap.isEmpty() || String.isBlank(overlayObj.arce__Arc_Gen_GCP_Select_VC__c)) {
                response.status = 'WARNING';
                response.message = System.Label.Arc_Gen_GCP_should_be_updated;
            }
        }
        return response;
    }

    /**
    * --------------------------------------------------------------------------------------
    * @description recalculate ratings
    * @param aHasAnalysId Id of the account has analysis.
    * @param cclients clients Set.
    * @return Returns a list of missing elements to complete
    **/
    @AuraEnabled
    public static MessageResponse recalculateRating(String aHasAnalysId, String cclients) {
        final MessageResponse response = new MessageResponse();
        try {
            final arce__Overlay__c overlayObj = arce.Arc_Gen_Overlays_Utils.getOverlaysByAha(new Set<String>{aHasAnalysId})[0];
            arce.Arc_Gen_Overlays_Utils.updateOverlayObject(aHasAnalysId, cclients, overlayObj);
            if(String.isEmpty(overlayObj.arce__Arc_Gen_Parent_Short_Rating_GCP__c)) {
              response.status = 'Warning';
              response.message = System.Label.Arc_Gen_RecalculateRating;
            }
        } catch (Exception ex) {
            response.status = arce.Arc_Gen_RatingGlobal_Constants.ERROR_TEXT;
            response.message = ex.getMessage();
            System.debug('ERROR :: callOverlayRating :: '+ex.getMessage());
            System.debug('ERROR :: callOverlayRating :: '+ex.getStackTraceString());
        }
        return response;
    }
}