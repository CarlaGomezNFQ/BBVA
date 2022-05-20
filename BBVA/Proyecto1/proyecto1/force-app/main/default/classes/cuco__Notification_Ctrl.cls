/**
* ────────────────────────────────────────────────────────────────────
* Notification_Ctrl
* Controller class for notification_cmp Lightning Component
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
@SuppressWarnings('sf:AvoidHardCodedError')
public with sharing class Notification_Ctrl {

    /**
    * @description Private constructor to avoid sonar err
    */
    @TestVisible
    private Notification_Ctrl() {}

    /**
    * @description Do the post save actions on notification cmp
    * @param profAnalysisId : Id of the context profitability analysis record
    * @param notificationComments : Notifications comments value from the form
    * @param screenShot : String with the html screenshot to audit detail records
    * @return Map<String, Object>, with response
    */
    @AuraEnabled
    public static Map<String, Object> doNotificationSave(Id profAnalysisId, String notificationComments, String screenShot) {
        Map<String, Object> mapRetNotificationSave = new Map<String, Object>();
        try {
            mapRetNotificationSave = Utils.checkAvailableAction('PA_Notification', profAnalysisId);
        } catch (Exception e) { // NOSONAR
            throw new AuraHandledException(Label.generic_error + ' ' + e.getMessage()); // NOSONAR
        }

        if(mapRetNotificationSave.get('success') == false) {
            throw new AuraHandledException((String) mapRetNotificationSave.get('message'));
        } else {
            try {
                return Notification_Service.doSave(profAnalysisId, notificationComments, screenShot);
            } catch (Exception e) { // NOSONAR
                throw new AuraHandledException(Label.generic_error + ' ' + e.getMessage()); // NOSONAR
            }
        }
    }
}