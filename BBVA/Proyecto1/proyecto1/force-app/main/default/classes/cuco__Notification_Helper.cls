/**
* ────────────────────────────────────────────────────────────────────
* Notification_Helper
* Helper class for Notification_Service apex class
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
public class Notification_Helper {

    /**
    * @description Private constructor to avoid sonar err
    */
    @TestVisible
    private Notification_Helper() {}

    /**
    * @description Helper method to call picasso ws on notification methods
    * @param profAnalysisWrapp : Wrapper with prof analysis id info
    * @param picassoNotificationId : Picasso notification id to include on ws call
    * @param picassoNotificationComments : Picasso notification comments to include on ws call
    * @return Map<String, Object>, with response
    */
    public static Map<String, Object> callPicassoWS(ProfitabilityAnalysis_Wrapper profAnalysisWrapp, String picassoNotificationId, String picassoNotificationComments) {
        final Map<String, Object> retMap = new Map<String, Object>();
        final RequestPicasso_Helper requestPicassoHelper = new RequestPicasso_Helper(profAnalysisWrapp, picassoNotificationId, picassoNotificationComments);
        final HttpResponse responsePicassoNotification = requestPicassoHelper.callWs();
        switch on responsePicassoNotification.getStatusCode() {
            when 200 {
                final List<Map<String, Object>> res = new List<Map<String, Object>>();
                final Map<String, Object> mapValues = (Map<String, Object>) JSON.deserializeUntyped(responsePicassoNotification.getBody());
                for (Object elem : (List<Object>)mapValues.get('request')) {
                    final Map<String, Object> mapRequest = (Map<String, Object>)elem;
                    res.add(mapRequest);
                }
                retMap.put('manualFormRequestId', (String) res[0].get('operationId'));
                retMap.put('isSuccess', true);
            }
            when else {
                retMap.put('isSuccess', false);
                if (responsePicassoNotification.getBody() == null) {
                    retMap.put('errMessage', Label.manual_notification_error_generic);
                } else {
                    final Map<String, Object> mapValuesNotificationErr = (Map<String, Object>) JSON.deserializeUntyped(responsePicassoNotification.getBody());
                    String errMessage;
                    if (mapValuesNotificationErr.get('error-message') == null) {
                        errMessage = Label.manual_notification_error_generic;
                    } else {
                        errMessage = Label.manual_notification_error_detail  + ' ' + (String) mapValuesNotificationErr.get('error-message');
                    }
                    retMap.put('errMessage', errMessage);
                }
            }
        }
        return retMap;
    }
}