/**
* ────────────────────────────────────────────────────────────────────
* GipPackages_Ctrl
* Controller class for gip_packages_cmp Lightning Component
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
public with sharing class GipPackages_Ctrl {

    /**
    * @description Private constructor to avoid sonar err
    */
    @TestVisible
    private GipPackages_Ctrl() {}

    /**
    * @description Returns the participants info to show on table (gip pkgs)
    * @param recordId : Id of the context record
    * @param sObjectName : String with the api SObject Name of the context record
    * @return Map<String, Object>, with info of table params and table info
    */
    @AuraEnabled
    public static Map<String, Object> getGipPackages(Id recordId) {
        try {
            return Packages_Service.getInitialInfoPackages(recordId, 'GIP_PACKAGE');
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
    public static Map<String, Object> checkGipAddPermissions(Id profAnalysisId) {
        try {
            return Permissions_Service.checkAddPkgPermissions(profAnalysisId, 'GIP_PACKAGE');
        } catch (Exception e) { // NOSONAR
            throw new AuraHandledException(Label.generic_error + ' ' + e.getMessage()); // NOSONAR
        }
    }
}