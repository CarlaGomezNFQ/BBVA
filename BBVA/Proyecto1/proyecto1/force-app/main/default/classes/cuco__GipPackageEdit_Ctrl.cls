/**
* ────────────────────────────────────────────────────────────────────
* GipPackageEdit_Ctrl
* Controller class for gip_package_edit_cmp Lightning Component
* ────────────────────────────────────────────────────────────────────
* @author      Diego Arias <diego.arias.fernandez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-05-04
* @modified
* @systemLayer
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
public with sharing class GipPackageEdit_Ctrl {

    /**
    * @description Private constructor to avoid sonar err
    */
    @TestVisible
    private GipPackageEdit_Ctrl() {}

    /**
    * @description Do previous checks to save and if have permissions do save actions
    * @param strPkgWrapper : String with the serialize package wrapper to edit
    * @param profAnalysisId : Id of the context profitability analysis record
    * @param formParams: Map with form values
    * @return Map<String, Object>, with the result of the checks
    */
    @AuraEnabled
    public static Map<String, Object> doPostGipEditActions(String strPkgWrapper, Id profAnalysisId, Map<String, Object> formParams) {
        try {
            final Package_Wrapper packageWrapper = (Package_Wrapper) JSON.deserialize(strPkgWrapper, Package_Wrapper.class);
            return PackagesGip_Service.doPostGipEditActions(packageWrapper, profAnalysisId, formParams);
        } catch (Exception e) { // NOSONAR
            throw new AuraHandledException(Label.generic_error + ' ' + e.getMessage()); // NOSONAR
        }
    }
}