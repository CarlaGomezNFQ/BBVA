/**
* ────────────────────────────────────────────────────────────────────
* PackagesComm_Helper
* Helper class for PackagesComm_Service apex class to commercial packages
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
public class PackagesComm_Helper {

    /**
    * @description Private constructor to avoid sonar err
    */
    @TestVisible
    private PackagesComm_Helper() {}

    /**
    * @description Helper method to check if the package was marked as extensible in the catalog
    * @param pkgCode : String with pkg code to check
    * @return Map<String, Object>, with the result of the check
    */
    public static Map<String, Object> checkIfPkgCanExtend(String pkgCode) {
        final Map<String, Object> retMap = new Map<String, Object>();
        final PsCatalogPackage_Selector psCatalogPkgSelector = new PsCatalogPackage_Selector();
        final List<ps_catalog_package__c> lstPSCPkg = psCatalogPkgSelector.selectByPkgCode(new Set<String>{pkgCode});
        if (lstPSCPkg[0].gf_psc_extended_pkg_ind_type__c) {
            retMap.put('isSuccess', true);
        } else {
            retMap.put('isSuccess', false);
            retMap.put('errMessage', Label.pkg_no_extension_allowed);
        }
        return retMap;
    }

    /**
    * @description Helper method to check if profitability analysis param record has only one profitability analysis participant
    * @param profAnalysisId : Current profitability analysis id
    * @return Map<String, Object>, with the result of the check
    */
    public static Map<String, Object> checkIfOnlyOnePAP(Id profAnalysisId) {
        final Map<String, Object> retMap = new Map<String, Object>();
        final PAParticipant_Selector papSelector = new PAParticipant_Selector();
        final List<profitability_analysis_participant__c> lstPAP = papSelector.selectByProfAnalysis(new Set<Id>{profAnalysisId});
        if (lstPAP.size() == 1) {
            retMap.put('isSuccess', false);
            retMap.put('errMessage', Label.pkg_one_participant_error);
        } else {
            retMap.put('isSuccess', true);
        }
        return retMap;
    }

    /**
    * @description Helper method to check if current profitability analysis context record already have an extended pkg
    * @param profAnalysisId : Current profitability analysis id
    * @param pkgCode : String with pkg code
    * @return Map<String, Object>, with the result of the check
    */
    public static Map<String, Object> checkIfAlreadyVeCommExtPkg(Id profAnalysisId, String pkgCode) {
        final Map<String, Object> retMap = new Map<String, Object>();
        final Map<String, Set<String>> extendedPkgs = ProfitabilityAnalysis_Helper.getExtendedPkgOfProfAnalysis(profAnalysisId);

        if (extendedPkgs.isEmpty()) {
            retMap.put('isSuccess', true);
        } else {
            retMap.put('isSuccess', false);
            retMap.put('errMessage', Label.pkg_only_one_extended_error);
        }
        return retMap;
    }
}