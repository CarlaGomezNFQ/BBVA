/**
* ────────────────────────────────────────────────────────────────────
* ForfaitPackageAdd_Ctrl
* Controller class for forfait_package_add_cmp Lightning Component
* ────────────────────────────────────────────────────────────────────
* @author      Diego Arias <diego.arias.fernandez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-04-19
* @modified
* @systemLayer
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
public with sharing class ForfaitPackageAdd_Ctrl {

    /**
    * @description Private constructor to avoid sonar err
    */
    @TestVisible
    private ForfaitPackageAdd_Ctrl() {}

    /**
    * @description Get initial data to forfait add component
    * @param profAnalysisId : Id of the context profitability analysis record
    * @return Map<String, Object>, with the data required of forfait catalog pkg and participants of related analysis
    */
    @AuraEnabled
    public static Map<String, Object> retrieveForfaitAddData(Id profAnalysisId) {
        try {
            return PackagesForfait_Service.retrieveForfaitAddData(profAnalysisId);
        } catch (Exception e) { // NOSONAR
            throw new AuraHandledException(Label.generic_error + ' ' + e.getMessage()); // NOSONAR
        }
    }

    /**
    * @description Make previous comprobations and, if ve permissions, add new forfait pkg
    * @param profAnalysisId : Id of the context profitability analysis record,
    * @param strValues: String with map values of form
    * @param mode: String with form mode (add or edit)
    * @return Map<String, Object>, with the data required of forfait catalog pkg and participants of related analysis
    */
    @AuraEnabled
    public static Map<String, Object> addNewForfaitPkg(Id profAnalysisId, Map<String, Object> formParams, String mode) {
        try {
            final Map<String, Object> forfaitParams = new Map<String, Object>();
            forfaitParams.put('mode', mode);
            forfaitParams.put('pkgType', 'F');
            Map<String, Object> retMap = Packages_Service.addNewPkg(profAnalysisId, formParams, forfaitParams);
            if (!(Boolean) retMap.get('isSuccess')) {
                switch on mode {
                    when 'add' {
                        retMap.put('errMessage', Label.forfait_pkg_add_error + ' ' + (String) retMap.get('errMessage'));
                    }
                    when 'edit' {
                        retMap.put('errMessage', Label.forfait_pkg_edit_error + ' ' + (String) retMap.get('errMessage'));
                    }
                }
            }
            return retMap;
        } catch (Exception e) { // NOSONAR
            throw new AuraHandledException(Label.generic_error + ' ' + e.getMessage()); // NOSONAR
        }
    }
}