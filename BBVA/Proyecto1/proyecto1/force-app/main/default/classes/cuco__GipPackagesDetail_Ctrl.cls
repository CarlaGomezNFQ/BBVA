/**
* ────────────────────────────────────────────────────────────────────
* GipPackagesDetail_Ctrl
* Controller class for gip_packages_detail_cmp Lightning Component
* ────────────────────────────────────────────────────────────────────
* @author      Diego Arias <diego.arias.fernandez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-04-29
* @modified
* @systemLayer
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
public with sharing class GipPackagesDetail_Ctrl {

    /**
    * @description Private constructor to avoid sonar err
    */
    @TestVisible
    private GipPackagesDetail_Ctrl() {}

    /**
    * @description Check if current user can add package of a profitability analysis
    * @param profAnalysisId : Current profitability analysis record id
    * @return Map<String, Object>, with the response
    */
    @AuraEnabled
    public static Map<String, Object> checkGipAddPermissions(Id profAnalysisId) {
        try {
            return Permissions_Service.checkAddPkgPermissions(profAnalysisId, 'GIP_PACKAGE');
        } catch (Exception e) { // NOSONAR
            throw new AuraHandledException(Label.generic_error + ' ' + e.getMessage()); // NOSONAR
        }
    }

    /**
    * @description Check if current user can add package of a profitability analysis
    * @param profAnalysisId : Current profitability analysis record id
    * @return Map<String, Object>, with the response
    */
    @AuraEnabled
    public static Map<String, Object> checkGipEditPermissions(Id profAnalysisId, String strPkgWrapper) {
        try {
            final Package_Wrapper packageWrapper = (Package_Wrapper) JSON.deserialize(strPkgWrapper, Package_Wrapper.class);
            return Permissions_Service.checkEditPkgPermissions(profAnalysisId, packageWrapper);
        } catch (Exception e) { // NOSONAR
            throw new AuraHandledException(Label.generic_error + ' ' + e.getMessage()); // NOSONAR
        }
    }

    /**
    * @description Check if current user can add package of a profitability analysis
    * @param profAnalysisId : Current profitability analysis record id
    * @return Map<String, Object>, with the response
    */
    @AuraEnabled
    public static Map<String, Object> checkGipCancelPermissions(Id profAnalysisId, String strPkgWrapper) {
        try {
            final Package_Wrapper packageWrapper = (Package_Wrapper) JSON.deserialize(strPkgWrapper, Package_Wrapper.class);
            return Permissions_Service.checkCancelPkgPermissions(profAnalysisId, packageWrapper);
        } catch (Exception e) { // NOSONAR
            throw new AuraHandledException(Label.generic_error + ' ' + e.getMessage()); // NOSONAR
        }
    }
}