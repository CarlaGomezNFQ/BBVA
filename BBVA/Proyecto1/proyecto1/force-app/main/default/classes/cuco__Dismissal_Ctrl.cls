/**
* ────────────────────────────────────────────────────────────────────
* Dismissal_Ctrl
* Controller class for dismissal_cmp Lightning Component
* ────────────────────────────────────────────────────────────────────
* @author      Diego Arias <diego.arias.fernandez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-05-06
* @modified
* @systemLayer
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@SuppressWarnings('sf:AvoidHardCodedError')
public with sharing class Dismissal_Ctrl {

    /**
    * @description Private constructor to avoid sonar err
    */
    @TestVisible
    private Dismissal_Ctrl() {}

    /**
    * @description Returns the dismissal base info to initial modal config
    * @param profAnalysisId : Id of the context profitability analysis record
    * @return Map<String, Object>, with needed info
    */
    @AuraEnabled
    public static Map<String, Object> getDismissalBaseInfo(Id profAnalysisId) {
        try {
            return Dismissal_Service.getDismissalBaseInfo(profAnalysisId);
        } catch (Exception e) { // NOSONAR
            throw new AuraHandledException(Label.generic_error + ' ' + e.getMessage()); // NOSONAR
        }
    }

    /**
    * @description Do the post save actions on dismissal cmp
    * @param profAnalysisId : Id of the context profitability analysis record
    * @param dismissalComments : Dismissal comments value from the form
    * @param screenShot : String with the html screenshot to audit detail records
    * @return Map<String, Object>, with response
    */
    @AuraEnabled
    public static Map<String, Object> doDismissalSave(Id profAnalysisId, String dismissalComments, String screenShot) {
        Map<String, Object> mapRetDismissalSave = new Map<String, Object>();
        try {
            mapRetDismissalSave = Utils.checkAvailableAction('PA_Dismiss', profAnalysisId);
        } catch (Exception e) { // NOSONAR
            throw new AuraHandledException(Label.generic_error + ' ' + e.getMessage()); // NOSONAR
        }

        if(mapRetDismissalSave.get('success') == false) {
            throw new AuraHandledException((String) mapRetDismissalSave.get('message'));
        } else {
            try {
                return Dismissal_Service.doDismissalSave(profAnalysisId, dismissalComments, screenShot);
            } catch (Exception e) { // NOSONAR
                throw new AuraHandledException(Label.generic_error + ' ' + e.getMessage()); // NOSONAR
            }
        }
    }
}