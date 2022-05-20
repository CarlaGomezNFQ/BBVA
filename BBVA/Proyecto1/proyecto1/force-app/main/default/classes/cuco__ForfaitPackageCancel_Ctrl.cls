/**
* ────────────────────────────────────────────────────────────────────
* ForfaitPackageCancel_Ctrl
* Controller class for forfait_package_cancel_cmp Lightning Component
* ────────────────────────────────────────────────────────────────────
* @author      Diego Arias <diego.arias.fernandez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-04-27
* @modified
* @systemLayer
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
public with sharing class ForfaitPackageCancel_Ctrl {

    /**
    * @description Private constructor to avoid sonar err
    */
    @TestVisible
    private ForfaitPackageCancel_Ctrl() {}

    /**
    * @description Check if package is not related with any prof analysis participant
    * @param profAnalysisId : Id of the context profitability analysis record
    * @param catalogId : Id of the context package catalog record
    * @return Map<String, Object>, with the response
    */
    @AuraEnabled
    public static Map<String, Object> doForfaitCancelChecks(Id profAnalysisId, Id catalogId) {
        try {
            return Packages_Service.doPkgCancelChecks(profAnalysisId, catalogId);
        } catch (Exception e) { // NOSONAR
            throw new AuraHandledException(Label.generic_error + ' ' + e.getMessage()); // NOSONAR
        }
    }

    /**
    * @description Do post actions from confirm cancelation of forfait pkg
    * @param profAnalysisId : Id of the context profitability analysis record
    * @param strPkgWrapper : String with the serialize package wrapper to cancel
    * @return Map<String, Object>, with the result of the checks
    */
    @AuraEnabled
    public static Map<String, Object> doRemoveForfaitCancelActions(Id profAnalysisId, String strPkgWrapper) {
        try {
            final Package_Wrapper packageWrapper = (Package_Wrapper) JSON.deserialize(strPkgWrapper, Package_Wrapper.class);
            return PackagesForfait_Service.doRemoveForfaitCancelActions(profAnalysisId, packageWrapper);
        } catch (Exception e) { // NOSONAR
            throw new AuraHandledException(Label.generic_error + ' ' + e.getMessage()); // NOSONAR
        }
    }

}