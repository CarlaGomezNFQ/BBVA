/**
* ────────────────────────────────────────────────────────────────────
* CommPackagesDetail_Ctrl
* Controller class for comm_packages_detail_cmp Lightning Component
* ────────────────────────────────────────────────────────────────────
* @author      Diego Arias <diego.arias.fernandez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-03-26
* @modified
* @systemLayer Presentation
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
public with sharing class CommPackagesDetail_Ctrl {

    /**
    * @description Private constructor to avoid sonar err
    */
    @TestVisible
    private CommPackagesDetail_Ctrl() {}

    /**
    * @description Check if current user can edit package of a profitability analysis
    * @param profAnalysisId : Current profitability analysis record id
    * @param packageWrapper : Wrapper with the package info
    * @return Map<String, Object>, with the response
    */
    @AuraEnabled
    public static Map<String, Object> checkCommEditPermissions(Id profAnalysisId, String strPkgWrapper) {
        try {
            final Package_Wrapper packageWrapper = (Package_Wrapper) JSON.deserialize(strPkgWrapper, Package_Wrapper.class);
            return Permissions_Service.checkEditPkgPermissions(profAnalysisId, packageWrapper);
        } catch (Exception e) { // NOSONAR
            throw new AuraHandledException(Label.generic_error + ' ' + e.getMessage()); // NOSONAR
        }
    }
}