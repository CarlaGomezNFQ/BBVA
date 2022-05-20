/**
* ────────────────────────────────────────────────────────────────────
* Notification_Service
* Service class for Notification apex ctrl class
* ────────────────────────────────────────────────────────────────────
* @author      Diego Arias <diego.arias.fernandez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-06-10
* @modified
* @systemLayer
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
public class Notification_Service {

    /**
    * @description Private constructor to avoid sonar err
    */
    @TestVisible
    private Notification_Service() {}

    /**
    * @description Do the post save actions on notification cmp
    * @param profAnalysisId : Id of the context profitability analysis record
    * @param notificationComments : Notifications comments value from the form
    * @param screenShot : String with the html screenshot to audit detail records
    * @return Map<String, Object>, with response
    */
    public static Map<String, Object> doSave(Id profAnalysisId, String notificationComments, String screenShot) {
        final Map<String, Object> retMap = new Map<String, Object>();

        // Get active mtd record
        final pa_general_configuration__mdt genConfig = Utils.getGeneralConfiguration();

        // Get prof analysis wrapper
        final ProfitabilityAnalysis_Wrapper profAnalysisWrapp = ProfitabilityAnalysis_Helper.getProfAnalysis(profAnalysisId);

        // Call picasso service
        Map<String, Object> retMapPicassoCall = Notification_Helper.callPicassoWS(profAnalysisWrapp, genConfig.picasso_notification_id__c, notificationComments);
        if ((Boolean) retMapPicassoCall.get('isSuccess')) {
            // Call setPANotification on ProfitabilityAnalysis_Itf to update PA and create audit and audit detail
            profAnalysisWrapp.manualFormRequestId = (String) retMapPicassoCall.get('manualFormRequestId');
            Map<String, Object> retMapNotificationPA = ProfitabilityAnalysis_Helper.setPANotificationProfAnalysis(genConfig, profAnalysisWrapp, notificationComments, screenShot);
            if ((Boolean) retMapNotificationPA.get('success')) {
                retMap.put('isSuccess', true);
                retMap.put('message',(String) retMapNotificationPA.get('message'));
            } else {
                retMap.put('isSuccess', false);
                retMap.put('errMessage', (String) retMapNotificationPA.get('message'));
            }
        } else {
            retMap.put('isSuccess', false);
            retMap.put('errMessage', (String) retMapPicassoCall.get('errMessage'));
        }
        return retMap;
    }
}