/**
* ────────────────────────────────────────────────────────────────────
* ForfaitPackageEdit_Ctrl
* Controller class for forfait_package_edit_cmp Lightning Component
* ────────────────────────────────────────────────────────────────────
* @author      Diego Arias <diego.arias.fernandez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-04-22
* @modified
* @systemLayer
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
public with sharing class ForfaitPackageEdit_Ctrl {

    /**
    * @description Private constructor to avoid sonar err
    */
    @TestVisible
    private ForfaitPackageEdit_Ctrl() {}

    /**
    * @description Get initial data to forfait edit component
    * @param profAnalysisId : Id of the context profitability analysis record
    * @param pkgCatalogId : Id of the catalog pkg of the current forfait pkg
    * @param isExtended : Boolean to indicate if the pkg is extended
    * @return Map<String, Object>, with the initial data needed to forfait edit form
    */
    @AuraEnabled
    public static Map<String, Object> doInitialActionsForfaitEdit(Id profAnalysisId, Id pkgCatalogId, Boolean isExtended) {
        try {
            return PackagesForfait_Service.retrieveInitialDataForfaitEdit(profAnalysisId, pkgCatalogId, isExtended);
        } catch (Exception e) { // NOSONAR
            throw new AuraHandledException(Label.generic_error + ' ' + e.getMessage()); // NOSONAR
        }
    }

    /**
    * @description Do previous checks to save and if have permissions do save actions
    * @param profAnalysisId : Id of the context profitability analysis record
    * @param strPkgWrapper : String with the serialize package wrapper to edit
    * @param step: String to know in which step of the modal are
    * @return Map<String, Object>, with the result of the checks
    */
    @AuraEnabled
    public static Map<String, Object> doPostForfaitEditActions(String strPkgWrapper, Map<String, Object> params, Map<String, Object> formParams) {
        try {
            final Package_Wrapper packageWrapper = (Package_Wrapper) JSON.deserialize(strPkgWrapper, Package_Wrapper.class);
            return PackagesForfait_Service.doPostForfaitEditActions(packageWrapper, params, formParams);
        } catch (Exception e) { // NOSONAR
            throw new AuraHandledException(Label.generic_error + ' ' + e.getMessage()); // NOSONAR
        }
    }
}