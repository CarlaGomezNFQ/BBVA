/**
* ────────────────────────────────────────────────────────────────────
* CommPackageEdit_Ctrl
* Controller class for comm_package_edit_cmp Lightning Component
* ────────────────────────────────────────────────────────────────────
* @author      Diego Arias <diego.arias.fernandez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-04-07
* @modified
* @systemLayer
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
public with sharing class CommPackageEdit_Ctrl {

    /**
    * @description Private constructor to avoid sonar err
    */
    @TestVisible
    private CommPackageEdit_Ctrl() {}

    /**
    * @description Do previous checks to edit a commercial pkg
    * @param profAnalysisId : Id of the context profitability analysis record
    * @param strPkgWrapper : String with the serialize package wrapper to edit
    * @return Map<String, Object>, with the result of the checks
    */
    @AuraEnabled
    public static Map<String, Object> doPreviousEditChecks(Id profAnalysisId, String strPkgWrapper) {
        try {
            final Package_Wrapper packageWrapper = (Package_Wrapper) JSON.deserialize(strPkgWrapper, Package_Wrapper.class);
            return PackagesComm_Service.doPreviousCommEditChecks(profAnalysisId, packageWrapper);
        } catch (Exception e) { // NOSONAR
            throw new AuraHandledException(Label.generic_error + ' ' + e.getMessage()); // NOSONAR
        }
    }

    /**
    * @description Update the edit record and make extension actions
    * @param profAnalysisId : Id of the context profitability analysis record
    * @param strPkgWrapper : String with the serialize package wrapper to edit
    * @param step: String to know in which step of the modal are
    * @return Map<String, Object>, with the result of the checks
    */
    @AuraEnabled
    public static Map<String, Object> doEditCommPkgActions(String strPkgWrapper, Map<String, Object> params) {
        try {
            final Package_Wrapper packageWrapper = (Package_Wrapper) JSON.deserialize(strPkgWrapper, Package_Wrapper.class);
            return PackagesComm_Service.doEditCommPkgActions(packageWrapper, params);
        } catch (Exception e) { // NOSONAR
            throw new AuraHandledException(Label.generic_error + ' ' + e.getMessage()); // NOSONAR
        }
    }
}