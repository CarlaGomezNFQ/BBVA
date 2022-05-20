/**
* ────────────────────────────────────────────────────────────────────
* PackagesForfait_Service
* Service class for forfait packages
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
public class PackagesForfait_Service {

    /**
    * @description Private constructor to avoid sonar err
    */
    @TestVisible
    private PackagesForfait_Service() {}

    /**
    * @description Method to get initial data to forfait add component
    * @param profAnalysisId : Id of the related Profitability Analysis
    * @return Map<String, Object>, with the result of the method
    */
    public static Map<String, Object> retrieveForfaitAddData(Id profAnalysisId) {
        final Map<String, Object> retMap = new Map<String, Object>();

        // First, get all active forfait catalog pkg
        final PsCatalogPackage_Selector psCatalogPkgSelector = new PsCatalogPackage_Selector(true);
        List<ps_catalog_package__c> lstPsCatPkg = psCatalogPkgSelector.selectByPkgTypeAndActiveRecord(new Set<String>{'F'});
        retMap.put('lstPsCatPkg', lstPsCatPkg);

        // Second, get detail of Profitability Analysis Participant of param profitability analysis
        List<Participant_Wrapper> lstPW = PackagesForfait_Helper.getRelatedParticipantsOfAnalysis(profAnalysisId);
        retMap.put('lstPW', lstPW);

        // Third, get picklist labels of periodicity field of prof analysis pkg req
        List<Utils.Picklist_Wrapper> lstPicklistValue = Utils.getPicklistLabels('cuco__profitability_analysis_pkg_request__c', 'cuco__gf_pa_pkg_charge_pdicy_type__c');
        retMap.put('lstChargePeriodicity', lstPicklistValue);

        return retMap;
    }

    /**
    * @description Get initial data to forfait edit component
    * @param profAnalysisId : Id of the context profitability analysis record
    * @param pkgCatalogId : Id of the catalog pkg of the current forfait pkg
    * @param isExtended : Boolean to indicate if the pkg is extended
    * @return Map<String, Object>, with the initial data needed to forfait edit form
    */
    public static Map<String, Object> retrieveInitialDataForfaitEdit(Id profAnalysisId, Id pkgCatalogId, Boolean isExtended) {
        final Map<String, Object> retMap = new Map<String, Object>();

        // First, get chargePeriodicity picklist values
        final List<Utils.Picklist_Wrapper> lstPicklistValue = Utils.getPicklistLabels('cuco__profitability_analysis_pkg_request__c', 'cuco__gf_pa_pkg_charge_pdicy_type__c');
        retMap.put('lstChargePeriodicity', lstPicklistValue);

        // Second, if isExtended is false, make previous checks. Otherwise, return true
        if (isExtended) {
            retMap.put('showExtendedSection', true);
        } else {
            final Boolean showExtended = PackagesForfait_Helper.doPreviousChecksExtendedPkg(profAnalysisId, pkgCatalogId);
            retMap.put('showExtendedSection', showExtended);
        }
        return retMap;
    }

    /**
    * @description Do previous checks to save and if have permissions do save actions
    * @param packageWrapper : Package wrapper with the related package info
    * @param params: Map with rest of params to do logic
    * @return Map<String, Object>, with the result of the checks
    */
    public static Map<String, Object> doPostForfaitEditActions(Package_Wrapper packageWrapper, Map<String, Object> params, Map<String, Object> formParams) {
        final Map<String, Object> retMap = new Map<String, Object>();
        final Boolean doExtensionActions = (Boolean) params.get('makeExtensionActions');
        Id profAnalysisId = (Id) params.get('profAnalysisId');
        Boolean doRollBack = false;
        final Savepoint savePoint = Database.setSavepoint();

        // First check if current user for current comm pkg on current prof analysis Id have edit permissions
        final Map<String, Object> mapEditPermissions = Permissions_Service.checkEditPkgPermissions(profAnalysisId, packageWrapper);
        if ((Boolean) mapEditPermissions.get('edit')) {
            // Second, do extension pkg actions if needed
            if (doExtensionActions) {
                final Map<String, Object> retMapExtension = Packages_Service.doExtensionPkgActions(packageWrapper, params);
                if (!(Boolean)retMapExtension.get('isSuccess')) {
                    doRollBack = true;
                    retMap.putAll(retMapExtension);
                }
            }

            if (!doRollBack) {
                // Third, update current client package or profitability analysis pkg record
                final Map<String, Object> retUpdateRecordMap = PackagesForfait_Helper.updateForfaitEditRecord(packageWrapper, params, formParams);
                retMap.putAll(retUpdateRecordMap);
                if (!(Boolean)retUpdateRecordMap.get('isSuccess')) {
                    doRollBack = true;
                }
            }

            if (doRollBack) {
                Database.rollback(savePoint);
            }
        } else {
            retMap.put('isSuccess', false);
            retMap.put('errMessage', mapEditPermissions.get('editMessage'));
            retMap.put('toastType', 'warning');
        }
        return retMap;
    }

    /**
    * @description Do post actions from confirm cancelation of forfait pkg
    * @param profAnalysisId : Id of the context profitability analysis record
    * @param pkgWrapper : Package wrapper to cancel
    * @return Map<String, Object>, with the result of the checks
    */
    public static Map<String, Object> doRemoveForfaitCancelActions(Id profAnalysisId, Package_Wrapper pkgWrapper) {
        Map<String, Object> retMap = new Map<String, Object>();
        // First, check if have cancel pkg permissions
        final Map<String, Object> retMapCancelPermissions = Permissions_Service.checkCancelPkgPermissions(profAnalysisId, pkgWrapper);
        if ((Boolean) retMapCancelPermissions.get('cancel')) {
            // If have cancel permissions, make forfait pkg cancel actions in funcion of pkg req record
            retMap = Packages_Helper.doPkgCancelActions(profAnalysisId, pkgWrapper);
            if (!(Boolean) retMap.get('isSuccess')) {
                retMap.put('errMessage', Label.forfait_pkg_cancel_error + ': ' + retMap.get('errMessage'));
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