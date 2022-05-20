/**
* ────────────────────────────────────────────────────────────────────
* CommPackages_Ctrl
* Controller class for comm_packages_cmp Lightning Component
* ────────────────────────────────────────────────────────────────────
* @author      Diego Arias <diego.arias.fernandez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-03-25
* @modified
* @systemLayer Presentation
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
public with sharing class CommPackages_Ctrl {

    /**
    * @description Private constructor to avoid sonar err
    */
    @TestVisible
    private CommPackages_Ctrl() {}

    /**
    * @description Returns the participants info to show on table
    * @param recordId : Id of the context record
    * @param sObjectName : String with the api SObject Name of the context record
    * @return Map<String, Object>, with response of checks
    */
    @AuraEnabled
    public static Map<String, Object> getCommPackages(Id recordId) {
        try {
            return Packages_Service.getInitialInfoPackages(recordId, 'COMMERCIAL_PACKAGE');
        } catch (Exception e) { // NOSONAR
            throw new AuraHandledException(Label.generic_error + ' ' + e.getMessage()); // NOSONAR
        }
    }

}