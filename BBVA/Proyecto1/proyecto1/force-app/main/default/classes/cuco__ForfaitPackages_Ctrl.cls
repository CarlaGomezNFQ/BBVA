/**
* ────────────────────────────────────────────────────────────────────
* ForfaitPackages_Ctrl
* Controller class for forfait_packages_cmp Lightning Component
* ────────────────────────────────────────────────────────────────────
* @author      Diego Arias <diego.arias.fernandez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-04-13
* @modified
* @systemLayer
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
public with sharing class ForfaitPackages_Ctrl {

    /**
    * @description Private constructor to avoid sonar err
    */
    @TestVisible
    private ForfaitPackages_Ctrl() {}

    /**
    * @description Returns the participants info to show on table (forfait pkgs)
    * @param recordId : Id of the context record
    * @param sObjectName : String with the api SObject Name of the context record
    * @return Map<String, Object>, with info of table params and table info
    */
    @AuraEnabled
    public static Map<String, Object> getForfaitPackages(Id recordId) {
        try {
            return Packages_Service.getInitialInfoPackages(recordId, 'FORFAIT');
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
    public static Map<String, Object> checkForfaitAddPermissions(Id profAnalysisId) {
        try {
            return Permissions_Service.checkAddPkgPermissions(profAnalysisId, 'FORFAIT');
        } catch (Exception e) { // NOSONAR
            throw new AuraHandledException(Label.generic_error + ' ' + e.getMessage()); // NOSONAR
        }
    }
}