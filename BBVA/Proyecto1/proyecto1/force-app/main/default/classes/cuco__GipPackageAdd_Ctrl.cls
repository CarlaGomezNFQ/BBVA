/**
* ────────────────────────────────────────────────────────────────────
* GipPackageAdd_Ctrl
* Controller class for gip_package_add_cmp Lightning Component
* ────────────────────────────────────────────────────────────────────
* @author      Diego Arias <diego.arias.fernandez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-05-01
* @modified
* @systemLayer
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
public with sharing class GipPackageAdd_Ctrl {

    /**
    * @description Private constructor to avoid sonar err
    */
    @TestVisible
    private GipPackageAdd_Ctrl() {}

    /**
    * @description Get initial data to gip add component
    * @param profAnalysisId : Id of the context profitability analysis record
    * @return Map<String, Object>, with the data required of prof analysis participants
    */
    @AuraEnabled
    public static Map<String, Object> retrieveGipAddData(Id profAnalysisId) {
        try {
            return PackagesGip_Service.retrieveGipAddData(profAnalysisId);
        } catch (Exception e) { // NOSONAR
            throw new AuraHandledException(Label.generic_error + ' ' + e.getMessage()); // NOSONAR
        }
    }

    /**
    * @description Make previous comprobations and, if ve permissions, add new gip pkg
    * @param profAnalysisId : Id of the context profitability analysis record,
    * @param strValues: String with map values of form
    * @param mode: String with form mode (add or edit)
    * @return Map<String, Object>, with the data required of forfait catalog pkg and participants of related analysis
    */
    @AuraEnabled
    public static Map<String, Object> addNewGipPkg(Id profAnalysisId, Map<String, Object> formParams, String mode) {
        try {
            final Map<String, Object> gipParams = new Map<String, Object>();
            gipParams.put('mode', mode);
            gipParams.put('pkgType', 'G');
            Map<String, Object> retMap = Packages_Service.addNewPkg(profAnalysisId, formParams, gipParams);
            if (!(Boolean) retMap.get('isSuccess')) {
                switch on mode {
                    when 'add' {
                        retMap.put('errMessage', Label.gip_pkg_add_error + ' ' + (String) retMap.get('errMessage'));
                    }
                    when 'edit' {
                        retMap.put('errMessage', Label.gip_pkg_edit_error + ' ' + (String) retMap.get('errMessage'));
                    }
                }
            }
            return retMap;
        } catch (Exception e) { // NOSONAR
            throw new AuraHandledException(Label.generic_error + ' ' + e.getMessage()); // NOSONAR
        }
    }
}