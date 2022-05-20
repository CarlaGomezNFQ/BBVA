/**
* ────────────────────────────────────────────────────────────────────
* Permissions_Service
* Service class for Permissions_Itf implementation apex class
* ────────────────────────────────────────────────────────────────────
* @author      Diego Arias <diego.arias.fernandez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-02-18
* @modified
* @systemLayer Business Logic
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
public class Permissions_Service {

    /**
    * @description Private constructor to avoid sonar err
    */
    @TestVisible
    private Permissions_Service() {}

    /**
    * @description Check if current user can do add action
    * @param recordId : Current record Id
    * @return Map<String, Object>, with the response
    */
    public static Map<String, Object> checkAddPermissions(Id recordId) {
        Map<String, Object> retMap = new Map<String, Object>();

        // Obtain the current active version of general config mtd
        pa_general_configuration__mdt genConfig = Utils.getGeneralConfiguration();

        // Check Add permissions to current user
        retMap = Permissions_Helper.checkAddPermissions(genConfig, recordId);

        return retMap;
    }

    /**
    * @description Check if current user can do remove action
    * @param recordId : Current record Id
    * @param accountId : Id of the related account record of the context record
    * @return Map<String, Object>, with the response
    */
    public static Map<String, Object> checkRemovePermissions(Id recordId, Id accountId) {
        Map<String, Object> retMap = new Map<String, Object>();

        // Obtain the current active version of general config mtd
        final pa_general_configuration__mdt genConfig = Utils.getGeneralConfiguration();

        // Check Add permissions to current user
        retMap = Permissions_Helper.checkRemovePermissions(genConfig, recordId, accountId);

        return retMap;
    }

    /**
    * @description Check if current user have manage package permissions of a profitability analysis
    * @param profAnalysisId : Current profitability analysis record id
    * @param packageWrapper : Wrapper with the package info
    * @return Map<String, Object>, with the response
    */
    public static Map<String, Object> checkManagePkgPermissions(Id profAnalysisId) {
        Map<String, Object> retMap = new Map<String, Object>();

        // Obtain the current active version of general config mtd
        final pa_general_configuration__mdt genConfig = Utils.getGeneralConfiguration();

        // Check manage package permissions to current user
        retMap = Permissions_Helper.checkManagePkgPermissions(genConfig, profAnalysisId);

        return retMap;
    }

    /**
    * @description Check if current user have add package permissions of a profitability analysis
    * @param profAnalysisId : Current profitability analysis record id
    * @param packageWrapper : Wrapper with the package info
    * @return Map<String, Object>, with the response
    */
    public static Map<String, Object> checkAddPkgPermissions(Id profAnalysisId, String pkgType) {
        Map<String, Object> retMap = new Map<String, Object>();

        // Obtain the current active version of general config mtd
        final pa_general_configuration__mdt genConfig = Utils.getGeneralConfiguration();

        // Check manage package permissions to current user
        retMap = Permissions_Helper.checkAddPkgPermissions(genConfig, profAnalysisId, pkgType);

        return retMap;
    }

    /**
    * @description Check if current user can edit package of a profitability analysis
    * @param profAnalysisId : Current profitability analysis record id
    * @param packageWrapper : Wrapper with the package info
    * @return Map<String, Object>, with the response
    */
    public static Map<String, Object> checkEditPkgPermissions(Id profAnalysisId, Package_Wrapper packageWrapper) {
        Map<String, Object> retMap = new Map<String, Object>();

        // Obtain the current active version of general config mtd
        final pa_general_configuration__mdt genConfig = Utils.getGeneralConfiguration();

        // Check edit package permissions to current user
        retMap = Permissions_Helper.checkEditPkgPermissions(genConfig, profAnalysisId, packageWrapper);

        return retMap;
    }

    /**
    * @description Check if current user can cancel package of a profitability analysis
    * @param profAnalysisId : Current profitability analysis record id
    * @param packageWrapper : Wrapper with the package info
    * @return Map<String, Object>, with the response
    */
    public static Map<String, Object> checkCancelPkgPermissions(Id profAnalysisId, Package_Wrapper packageWrapper) {
        Map<String, Object> retMap = new Map<String, Object>();

        // Obtain the current active version of general config mtd
        final pa_general_configuration__mdt genConfig = Utils.getGeneralConfiguration();

        // Check edit package permissions to current user
        retMap = Permissions_Helper.checkCancelPkgPermissions(genConfig, profAnalysisId, packageWrapper);

        return retMap;
    }

    /**
    * @description Check if current user have manage flat rates permissions on a profitability analysis
    * @param profAnalysisId : Current profitability analysis record id
    * @return Map<String, Object>, with the response
    */
    public static Map<String, Object> checkManageFlatRatesPermissions(Id profAnalysisId) {
        Map<String, Object> retMap = new Map<String, Object>();

        // Obtain the current active version of general config mtd
        final pa_general_configuration__mdt genConfig = Utils.getGeneralConfiguration();

        // Check manage flat rates permissions to current user
        retMap = Permissions_Helper.checkManageFlatRatesPermissions(genConfig, profAnalysisId);

        return retMap;
    }

    /**
    * @description Check if current user have setup flat rates permissions on a profitability analysis
    * @param profAnalysisId : Current profitability analysis record id
    * @return Map<String, Object>, with the response
    */
    public static Map<String, Object> checkSetupFlatRatesPermissions(Id profAnalysisId) {
        Map<String, Object> retMap = new Map<String, Object>();

        // Obtain the current active version of general config mtd
        final pa_general_configuration__mdt genConfig = Utils.getGeneralConfiguration();

        // Check setup flat rates permissions to current user
        retMap = Permissions_Helper.checkSetupFlatRatesPermissions(genConfig, profAnalysisId);

        return retMap;
    }

    /**
    * @description Check if current user have remove flat rates permissions on a profitability analysis
    * @param profAnalysisId : Current profitability analysis record id
    * @return Map<String, Object>, with the response
    */
    public static Map<String, Object> checkRemoveFlatRatesPermissions(Id profAnalysisId) {
        Map<String, Object> retMap = new Map<String, Object>();

        // Obtain the current active version of general config mtd
        final pa_general_configuration__mdt genConfig = Utils.getGeneralConfiguration();

        // Check remove flat rates permissions to current user
        retMap = Permissions_Helper.checkRemoveFlatRatesPermissions(genConfig, profAnalysisId);

        return retMap;
    }

    /**
    * @description Returns whether the user can create requests for a Profitability Analysis
    * @param profSheet : Wrapper with Profitability information
    * @param userId : Id of the User
    * @param typology : String with profSheet typology
    * @return Map<String, Object> map with the actions and permissions
    */
    public static Map<String, Object> checkCreateRequestPermissions(ProfitabilitySheet_Wrapper profSheet, Id userId, String typology) {
        final pa_general_configuration__mdt genConfig = Utils.getGeneralConfiguration();
        return Permissions_Helper.checkCreateRequestPermissions(genConfig, profSheet, userId, typology);
    }

    /**
    * @description Returns whether the user can manage a Profitability Analysis
    * @param profAnalysisId : Id of the profitability analysis context
    * @param userId : Id of the User
    * @return Map<String, Object> map with the permissions
    */
    public static Map<String, Object> checkManagePAPermissions(Id profAnalysisId, Id userId) {
        final pa_general_configuration__mdt genConfig = Utils.getGeneralConfiguration();
        return Permissions_Helper.checkManagePAPermissions(genConfig, profAnalysisId, userId);
    }
}