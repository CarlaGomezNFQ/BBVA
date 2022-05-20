/**
* ────────────────────────────────────────────────────────────────────
* PackagesGip_Service
* Service class for gip packages
* ────────────────────────────────────────────────────────────────────
* @author      Diego Arias <diego.arias.fernandez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-04-15
* @modified
* @systemLayer
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
public class PackagesGip_Service {

    /**
    * @description Private constructor to avoid sonar err
    */
    @TestVisible
    private PackagesGip_Service() {}

    /**
    * @description Method to get initial data to gip add component
    * @param profAnalysisId : Id of the related Profitability Analysis
    * @return Map<String, Object>, with the result of the method
    */
    public static Map<String, Object> retrieveGipAddData(Id profAnalysisId) {
        final Map<String, Object> retMap = new Map<String, Object>();

        // Get active mtd record
        final pa_general_configuration__mdt genConfig = Utils.getGeneralConfiguration();

        // Get all pap of param prof analysis id
        final PAParticipant_Selector papSelector = new PAParticipant_Selector(true);
        final List<profitability_analysis_participant__c> lstPAP = papSelector.selectByProfAnalysis(new Set<Id>{profAnalysisId});

        final Set<Id> setPAPId = new Set<Id>();
        for (profitability_analysis_participant__c pap : lstPAP) {
            setPAPId.add(pap.participant_id__c);
        }

        // Get details for each participant retrieve on query
        final List<Participant_Wrapper> lstPW = Participants_Helper.getParticipantDetails(genConfig, setPAPId);
        retMap.put('lstPW', lstPW);

        return retMap;
    }

    /**
    * @description Do previous checks to save and if have permissions do save actions
    * @param strPkgWrapper : String with the serialize package wrapper to edit
    * @param profAnalysisId : Id of the context profitability analysis record
    * @param formParams: Map with form values
    * @return Map<String, Object>, with the result of the checks
    */
    public static Map<String, Object> doPostGipEditActions(Package_Wrapper packageWrapper, Id profAnalysisId, Map<String, Object> formParams) {
        Map<String, Object> retMap = new Map<String, Object>();

        // First, check if have edit permissions
        Map<String, Object> retEditPermissionsMap = Permissions_Service.checkEditPkgPermissions(profAnalysisId, packageWrapper);

        if ((Boolean) retEditPermissionsMap.get('edit')) {
            // If have permissions, update current client package or profitability analysis pkg record
            retMap = PackagesGip_Helper.updateGipEditRecord(packageWrapper, profAnalysisId, formParams);
        } else {
            retMap.put('isSuccess', false);
            retMap.put('errMessage', retEditPermissionsMap.get('editMessage'));
            retMap.put('toastType', 'warning');
        }
        return retMap;
    }

    /**
    * @description Do post actions from confirm cancelation of gip pkg
    * @param profAnalysisId : Id of the context profitability analysis record
    * @param pkgWrapper : Package wrapper to cancel
    * @return Map<String, Object>, with the result of the checks
    */
    public static Map<String, Object> doRemoveGipCancelActions(Id profAnalysisId, Package_Wrapper pkgWrapper) {
        Map<String, Object> retMap = new Map<String, Object>();
        // First, check if have cancel pkg permissions
        final Map<String, Object> retMapCancelPermissions = Permissions_Service.checkCancelPkgPermissions(profAnalysisId, pkgWrapper);
        if ((Boolean) retMapCancelPermissions.get('cancel')) {
            // If have cancel permissions, make forfait pkg cancel actions in funcion of pkg req record
            retMap = Packages_Helper.doPkgCancelActions(profAnalysisId, pkgWrapper);
            if (!(Boolean) retMap.get('isSuccess')) {
                retMap.put('errMessage', Label.gip_pkg_cancel_error + ': ' + retMap.get('errMessage'));
                retMap.put('toastType', 'error');
            }
        } else {
            retMap.put('isSuccess', false);
            retMap.put('toastType', 'warning');
            retMap.put('errMessage', retMapCancelPermissions.get('cancelMessage'));
        }
        return retMap;
    }
}