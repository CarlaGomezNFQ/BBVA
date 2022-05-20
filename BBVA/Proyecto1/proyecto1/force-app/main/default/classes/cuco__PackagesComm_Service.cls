/**
* ────────────────────────────────────────────────────────────────────
* PackagesComm_Service
* Service class for commercial packages
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
public class PackagesComm_Service {

    /**
    * @description Private constructor to avoid sonar err
    */
    @TestVisible
    private PackagesComm_Service() {}

    /**
    * @description Do previous checks on the package to be edited
    * @param profAnalysisId : Id of the context profitability analysis record
    * @param packageWrapper : Package wrapper with the related package info
    * @return Map<String, Object>, with the result of the checks
    */
    public static Map<String, Object> doPreviousCommEditChecks(Id profAnalysisId, Package_Wrapper packageWrapper) {
        Map<String, Object> retMap = new Map<String, Object>();
        final String pkgCode = 'C' + packageWrapper.code;

        // Check if the package was marked as extensible in the catalog
        final Map<String, Object> retExtMap = PackagesComm_Helper.checkIfPkgCanExtend(pkgCode);
        if ((Boolean) retExtMap.get('isSuccess')) {
            // Check if profitability analysis context record has only one profitability analysis participant
            final Map<String, Object> retPAPMap = PackagesComm_Helper.checkIfOnlyOnePAP(profAnalysisId);
            if ((Boolean) retPAPMap.get('isSuccess')) {
                // Check if current profitability analysis context record already have an extended pkg
                final Map<String, object> retExtPkgsMap = PackagesComm_Helper.checkIfAlreadyVeCommExtPkg(profAnalysisId, pkgCode);
                retMap.putAll(retExtPkgsMap);
            } else {
                retMap.putAll(retPAPMap);
            }
        } else {
            retMap.putAll(retExtMap);
        }

        return retMap;
    }

    /**
    * @description Do previous checks to save and if have permissions do save actions
    * @param packageWrapper : Package wrapper with the related package info
    * @param params: Map with rest of params to do logic
    * @return Map<String, Object>, with the result of the checks
    */
    public static Map<String, Object> doEditCommPkgActions(Package_Wrapper packageWrapper, Map<String, Object> params) {
        Map<String, Object> retMap = new Map<String, Object>();
        Id profAnalysisId = (Id) params.get('profAnalysisId');

        // First check if current user for current comm pkg on current prof analysis Id have edit permissions
        final Map<String, Object> mapEditPermissions = Permissions_Service.checkEditPkgPermissions(profAnalysisId, packageWrapper);
        if ((Boolean) mapEditPermissions.get('edit')) {
            retMap = Packages_Service.doExtensionPkgActions(packageWrapper, params);
        } else {
            retMap.put('isSuccess', false);
            retMap.put('errMessage', mapEditPermissions.get('editMessage'));
            retMap.put('toastType', 'warning');
        }

        return retMap;
    }
}