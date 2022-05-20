/**
* ────────────────────────────────────────────────────────────────────
* Restudy_Ctrl
* Controller class for restudy_cmp Lightning Component
* ────────────────────────────────────────────────────────────────────
* @author      Diego Arias <diego.arias.fernandez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-05-08
* @modified
* @systemLayer
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@SuppressWarnings('sf:AvoidHardCodedError')
public with sharing class Restudy_Ctrl {

    /**
    * @description Private constructor to avoid sonar err
    */
    @TestVisible
    private Restudy_Ctrl() {}

    /**
    * @description Returns the restudy base info to initial modal config
    * @param profAnalysisId : Id of the context profitability analysis record
    * @return Map<String, Object>, with needed info
    */
    @AuraEnabled
    public static Map<String, Object> getRestudyBaseInfo(Id profAnalysisId) {
        try {
            return Restudy_Service.getRestudyBaseInfo(profAnalysisId);
        } catch (Exception e) { // NOSONAR
            throw new AuraHandledException(Label.generic_error + ' ' + e.getMessage()); // NOSONAR
        }
    }

    /**
    * @description Do the post save actions on restudy cmp
    * @param profAnalysisId : Id of the context profitability analysis record
    * @param restudyComments : Restudy comments value from the form
    * @param screenShot : String with the html screenshot to audit detail records
    * @return Map<String, Object>, with response
    */
    @AuraEnabled
    public static Map<String, Object> doRestudySave(Id profAnalysisId, String restudyComments, String screenShot) {
        Map<String, Object> mapRetRestudySave = new Map<String, Object>();
        try {
            mapRetRestudySave = Utils.checkAvailableAction('PA_Restudy', profAnalysisId);
        } catch (Exception e) { // NOSONAR
            throw new AuraHandledException(Label.generic_error + ' ' + e.getMessage()); // NOSONAR
        }

        if(mapRetRestudySave.get('success') == false) {
            throw new AuraHandledException((String) mapRetRestudySave.get('message'));
        } else {
            try {
                return Restudy_Service.doRestudySave(profAnalysisId, restudyComments, screenShot);
            } catch (Exception e) { // NOSONAR
                throw new AuraHandledException(Label.generic_error + ' ' + e.getMessage()); // NOSONAR
            }
        }
    }
}