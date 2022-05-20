/**
* ────────────────────────────────────────────────────────────────────
* Packages_Service
* Service class for multiple apex ctrl classes
* ────────────────────────────────────────────────────────────────────
* @author      Diego Arias <diego.arias.fernandez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-03-25
* @modified
* @systemLayer
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
public class Packages_Service {

    /**
    * @description Private constructor to avoid sonar err
    */
    @TestVisible
    private Packages_Service() {}

    /**
    * @description Get packages to show
    * @param contextRecordId : Id of the related Profitability Sheet / Profitability Analysis
    * @param packageTypes : Set of packages types to obtain. Current values are COMMERCIAL_PACKAGE, GIP_PACKAGE and FORFAIT
    * @return List<Package_Wrapper>, with package info as a wrapper
    */
    public static List<Package_Wrapper> getPackagesToShow(Id contextRecordId, String packageType) {
        List<Package_Wrapper> lstPW = new List<Package_Wrapper>();

        // Get sObjectName from recordId
        final String sObjectName = Utils.getObjectAPIName(contextRecordId);

        // In funciton of sObjectName, get extended pkg
        Map<String, Set<String>> extendedPkgs = new Map<String, Set<String>>();
        if (sObjectName == 'cuco__profitability_sheet__c') {
            extendedPkgs = ProfitabilitySheet_Service.getPSExtendedPkgs(contextRecordId);
        } else if (sObjectName == 'cuco__profitability_analysis__c') {
            extendedPkgs = ProfitabilityAnalysis_Helper.getExtendedPkgOfProfAnalysis(contextRecordId);
        }

        // Get packages info
        final Map<String, List<Package_Wrapper>> mapPackages = Packages_Helper.getPackages(contextRecordId, new Set<String>{packageType}, extendedPkgs);
        if (mapPackages.get(packageType) != null) {
            lstPW = mapPackages.get(packageType);
        }
        return lstPW;
    }

    /**
    * @description Do previous checks to save and if have permissions do save actions
    * @param packageWrapper : Package wrapper with the related package info
    * @param params: Map with rest of params to do logic
    * @return Map<String, Object>, with the result of the checks
    */
    public static Map<String, Object> doExtensionPkgActions(Package_Wrapper packageWrapper, Map<String, Object> params) {
        Map<String, Object> retMap = new Map<String, Object>();
        Id profAnalysisId = (Id) params.get('profAnalysisId');
        String step = (String) params.get('step');
        String decision = (String) params.get('decision');

        // If it have, in funcion of related prof analysis conditions and modal wizard step, do previous comprobation or final edit actions
        // First get conditions related to current pkg
        PsCatalogPkgCondition_Selector psCatPkgCondSelector = new PsCatalogPkgCondition_Selector(true);
        List<ps_catalog_pkg_condition__c> lstPSCatPkgCond = psCatPkgCondSelector.retrieveConditionsOfPkg(new Set<String>{packageWrapper.type + packageWrapper.code});

        // Second get if already exist prof analysis conditions related to this previous conditions
        List<profitability_analysis_condition__c> lstPAC = PackageExtended_Helper.checkConditionsInProfAnalysis(profAnalysisId, lstPSCatPkgCond);

        switch on step {
            when '1' {
                if (lstPAC.isEmpty() || decision == 'deextend') {
                    // Aux step: Get PS Catalog Cond Attributes related to pkg conditions
                    Map<String, List<ps_catalog_condition_attribute__c>> mapCatCondAttb = PackageExtended_Helper.getAttributesFromConditions(lstPSCatPkgCond);
                    params.put('lstCatCond', lstPSCatPkgCond);
                    params.put('mapCatCondAttb', mapCatCondAttb);
                    Map<String, Object> retMapExtCommPkg1 = PackageExtended_Helper.doExtensionPkg(lstPAC, packageWrapper, params);
                    retMap.putAll(retMapExtCommPkg1);
                } else {
                    // If alreay have same conditions from current pkg on prof analysis conditions and stay on step 1 of wizard, show step 2
                    retMap.put('isSuccess', false);
                    retMap.put('lstPAC', lstPAC);
                }
            }
            when '2' {
                Map<String, List<ps_catalog_condition_attribute__c>> mapCatCondAttb = PackageExtended_Helper.getAttributesFromConditions(lstPSCatPkgCond);
                params.put('lstCatCond', lstPSCatPkgCond);
                params.put('mapCatCondAttb', mapCatCondAttb);
                Map<String, Object> retMapExtCommPkg2 = PackageExtended_Helper.doExtensionPkg(lstPAC, packageWrapper, params);
                retMap.putAll(retMapExtCommPkg2);
            }
        }

        return retMap;
    }

    /**
    * @description Method to get packages and check manage pkg permissions
    * @param contextRecordId : Id of the related Profitability Sheet / Profitability Analysis
    * @param pkgType : String packages types to obtain. Current values are COMMERCIAL_PACKAGE, GIP_PACKAGE and FORFAIT
    * @return Map<String, Object>, with the result of the method
    */
    public static Map<String, Object> getInitialInfoPackages(Id contextRecordId, String pkgType) {
        final Map<String, Object> retMap = new Map<String, Object>();

        // First, check if the prof analysis record has manage pkg permissions (Only if sObjectName is profitability_analysis__c)
        final String sObjectName = Utils.getObjectAPIName(contextRecordId);
        Map<String, Object> retManagePermissionsMap = new Map<String, Object>();
        if (sObjectName == 'cuco__profitability_analysis__c') {
            retManagePermissionsMap = Permissions_Service.checkManagePkgPermissions(contextRecordId);
        } else {
            retManagePermissionsMap.put('add', false);
            retManagePermissionsMap.put('edit', false);
            retManagePermissionsMap.put('cancel', false);
        }
        retMap.put('pkgPermissions', retManagePermissionsMap);

        //Second, get packages to show
        final List<Package_Wrapper> lstPW = getPackagesToShow(contextRecordId, pkgType);
        retMap.put('lstPW', lstPW);

        return retMap;
    }

    /**
    * @description Method to do previous checks and upsert records to add new forfait/gip pkg
    * @param profAnalysisId : Id of the related Profitability Analysis
    * @param formParams: Map with filled form info
    * @param params: Map with related info (edit mode and pkg type)
    * @return Map<String, Object>, with the result of the method
    */
    public static Map<String, Object> addNewPkg(Id profAnalysisId, Map<String, Object> formParams, Map<String, Object> params) {
        Map<String, Object> retMap = new Map<String, Object>();
        final String pkgType = (String) params.get('pkgType');
        // First, check if have permissions (canAddPackage)
        Map<String, Object> addPermissionsMap = Permissions_Service.checkAddPkgPermissions(profAnalysisId, pkgType);
        if ((Boolean) addPermissionsMap.get('add')) {
            final String mode = (String) params.get('mode');
            if (mode == 'add') {
                // Second, checks to selected participant
                Map<String, Object> participantChecksMap = Packages_Helper.checksSelectedParticipants(profAnalysisId, formParams);
                if ((Boolean) participantChecksMap.get('isSuccess')) {
                    // Third, upsert profitability analysis pkg request
                    retMap = upsertProfAnalysisPkgReq(profAnalysisId, formParams, params);
                } else {
                    retMap.putAll(participantChecksMap);
                    retMap.put('toastType', 'warning');
                }
            } else if (mode == 'edit') {
                // If mode == edit, only do upsert (dont do participants validations)
                retMap = upsertProfAnalysisPkgReq(profAnalysisId, formParams, params);
            }
        } else {
            retMap.put('isSuccess', false);
            retMap.put('errMessage', addPermissionsMap.get('addMessage'));
            retMap.put('toastType', 'warning');
        }
        return retMap;
    }

    /**
    * @description Method to call the upsert method records in function of pkg Type
    * @param profAnalysisId : Id of the related Profitability Analysis
    * @param formParams: Map with filled form info
    * @param params: Map with related info (edit mode and pkg type)
    * @return Map<String, Object>, with the result of the method
    */
    private static Map<String, Object> upsertProfAnalysisPkgReq(Id profAnalysisId, Map<String, Object> formParams, Map<String, Object> params) {
        Map<String, Object> retMap = new Map<String, Object>();
        final String mode = (String) params.get('mode');
        final String pkgType = (String) params.get('pkgType');

        switch on pkgType {
            when 'F' {
                retMap = PackagesForfait_Helper.upsertProfAnalysisPkgReq(profAnalysisId, formParams, mode);
            }
            when 'G' {
                retMap = PackagesGip_Helper.upsertProfAnalysisPkgReq(profAnalysisId, formParams, mode);
            }
        }

        return retMap;
    }

    /**
    * @description Check if package is not related with any prof analysis participant (Used in forfait and gip cancel pkg)
    * @param profAnalysisId : Id of the context profitability analysis record
    * @param catalogId : Id of the context package catalog record
    * @return Map<String, Object>, with the response
    */
    public static Map<String, Object> doPkgCancelChecks(Id profAnalysisId, Id catalogId) {
        Map<String, Object> retMap = new Map<String, Object>();

        // Check if exist any prof analysis pkg request related with catalogId and pap id field empty
        final PAPackageRequest_Selector paprSelector = new PAPackageRequest_Selector(true);
        final List<profitability_analysis_pkg_request__c> lstPAPR = paprSelector.selectPkgReqByCat(new Set<Id>{catalogId}, profAnalysisId);
        retMap.put('hasNotParticipant', lstPAPR.isEmpty());
        return retMap;
    }
}