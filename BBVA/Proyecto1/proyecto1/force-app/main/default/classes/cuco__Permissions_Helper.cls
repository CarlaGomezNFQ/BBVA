/**
* ────────────────────────────────────────────────────────────────────
* Permissions_Helper
* Helper class for Permissions_Service apex class
* ────────────────────────────────────────────────────────────────────
* @author      Diego Arias <diego.arias.fernandez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-02-18
* @modified
* @systemLayer Any
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
public class Permissions_Helper {

    /**
    * @description Private constructor to avoid sonar err
    */
    @TestVisible
    private Permissions_Helper() {}

    /**
    * @description Helper method to obtain if context user can do add action
    * @param genConfig : Metadata record with the general configuration of classes
    * @param recordId : Id of context record
    * @return Map<String, Object>, with the current info
    */
    public static Map<String, Object> checkAddPermissions(pa_general_configuration__mdt genConfig, Id recordId) {
      final Type permissionsClass = Type.forName(genConfig.permissions_itf_name__c);
      final Permissions_itf permissionsItf = (Permissions_itf) permissionsClass.newInstance();
      return permissionsItf.canAddParticipants(recordId, UserInfo.getUserId());
    }

    /**
    * @description Helper method to obtain if context user can do remove action
    * @param genConfig : Metadata record with the general configuration of classes
    * @param recordId : Id of context record
    * @param accountId : Id of the related account record of the context record
    * @return Map<String, Object>, with the current info
    */
    public static Map<String, Object> checkRemovePermissions(pa_general_configuration__mdt genConfig, Id recordId, Id accountId) {
        final Type permissionsClass = Type.forName(genConfig.permissions_itf_name__c);
        final Permissions_itf permissionsItf = (Permissions_itf) permissionsClass.newInstance();
        return permissionsItf.canRemoveParticipant(recordId, UserInfo.getUserId(), accountId);
    }

    /**
    * @description Helper method to obtain if context user can do remove action
    * @param genConfig : Metadata record with the general configuration of classes
    * @param recordId : Id of context record
    * @param accountId : Id of the related account record of the context record
    * @return Map<String, Object>, with the current info
    */
    public static Map<String, Object> checkCreatePermissions(pa_general_configuration__mdt genConfig, Id recordId) {
        final Type permissionsClass = Type.forName(genConfig.permissions_itf_name__c);
        final Permissions_itf permissionsItf = (Permissions_itf) permissionsClass.newInstance();
        return permissionsItf.canCreateNewPA(recordId, UserInfo.getUserId());
    }

    /**
    * @description Helper method to obtain if context user can edit certain package
    * @param genConfig : Metadata record with the general configuration of classes
    * @param recordId : Id of context record (Profitability analysis record)
    * @return Map<String, Object>, with the current info
    */
    public static Map<String, Object> checkManagePkgPermissions(pa_general_configuration__mdt genConfig, Id recordId) {
        final Type permissionsClass = Type.forName(genConfig.permissions_itf_name__c);
        final Permissions_itf permissionsItf = (Permissions_itf) permissionsClass.newInstance();
        return permissionsItf.canManagePackages(recordId, UserInfo.getUserId());
    }

    /**
    * @description Helper method to obtain if context user can add certain package type in a prof analysis
    * @param genConfig : Metadata record with the general configuration of classes
    * @param recordId : Id of context record (Profitability analysis record)
    * @param pkgType : String with the pkg type to evaluate add permissions
    * @return Map<String, Object>, with the current info
    */
    public static Map<String, Object> checkAddPkgPermissions(pa_general_configuration__mdt genConfig, Id recordId, String pkgType) {
        final Type permissionsClass = Type.forName(genConfig.permissions_itf_name__c);
        final Permissions_itf permissionsItf = (Permissions_itf) permissionsClass.newInstance();
        return permissionsItf.canAddPackage(recordId, UserInfo.getUserId(), pkgType);
    }

    /**
    * @description Helper method to obtain if context user can edit certain package
    * @param genConfig : Metadata record with the general configuration of classes
    * @param recordId : Id of context record (Profitability analysis record)
    * @param pkgWrapper : Wrapper with the package info
    * @return Map<String, Object>, with the current info
    */
    public static Map<String, Object> checkEditPkgPermissions(pa_general_configuration__mdt genConfig, Id recordId, Package_Wrapper pkgWrapper) {
        final Type permissionsClass = Type.forName(genConfig.permissions_itf_name__c);
        final Permissions_itf permissionsItf = (Permissions_itf) permissionsClass.newInstance();
        return permissionsItf.canEditPackage(recordId, UserInfo.getUserId(), pkgWrapper);
    }

    /**
    * @description Helper method to obtain if context user can cancel certain package
    * @param genConfig : Metadata record with the general configuration of classes
    * @param recordId : Id of context record (Profitability analysis record)
    * @param pkgWrapper : Wrapper with the package info
    * @return Map<String, Object>, with the current info
    */
    public static Map<String, Object> checkCancelPkgPermissions(pa_general_configuration__mdt genConfig, Id recordId, Package_Wrapper pkgWrapper) {
        final Type permissionsClass = Type.forName(genConfig.permissions_itf_name__c);
        final Permissions_itf permissionsItf = (Permissions_itf) permissionsClass.newInstance();
        return permissionsItf.canCancelPackage(recordId, UserInfo.getUserId(), pkgWrapper);
    }

    /**
    * @description Check if current user have manage flat rates permissions on a profitability analysis
    * @param genConfig : Metadata record with the general configuration of classes
    * @param recordId : Id of context record (Profitability analysis record)
    * @return Map<String, Object>, with the response
    */
    public static Map<String, Object> checkManageFlatRatesPermissions(pa_general_configuration__mdt genConfig, Id recordId) {
        final Type permissionsClass = Type.forName(genConfig.permissions_itf_name__c);
        final Permissions_itf permissionsItf = (Permissions_itf) permissionsClass.newInstance();
        return permissionsItf.canManageFlatRates(recordId, UserInfo.getUserId());
    }

    /**
    * @description Check if current user have setup flat rates permissions on a profitability analysis
    * @param genConfig : Metadata record with the general configuration of classes
    * @param recordId : Id of context record (Profitability analysis record)
    * @return Map<String, Object>, with the response
    */
    public static Map<String, Object> checkSetupFlatRatesPermissions(pa_general_configuration__mdt genConfig, Id recordId) {
        final Type permissionsClass = Type.forName(genConfig.permissions_itf_name__c);
        final Permissions_itf permissionsItf = (Permissions_itf) permissionsClass.newInstance();
        return permissionsItf.canSetupFlatRates(recordId, UserInfo.getUserId());
    }

    /**
    * @description Check if current user have remove flat rates permissions on a profitability analysis
    * @param genConfig : Metadata record with the general configuration of classes
    * @param recordId : Id of context record (Profitability analysis record)
    * @return Map<String, Object>, with the response
    */
    public static Map<String, Object> checkRemoveFlatRatesPermissions(pa_general_configuration__mdt genConfig, Id recordId) {
        final Type permissionsClass = Type.forName(genConfig.permissions_itf_name__c);
        final Permissions_itf permissionsItf = (Permissions_itf) permissionsClass.newInstance();
        return permissionsItf.canRemoveFlatRates(recordId, UserInfo.getUserId());
    }

    /**
    * @description Helper method to obtain if context user can create requests for a Profitability Analysis
    * @param genConfig : Metadata record with the general configuration of classes
    * @param profSheet : Wrapper with Profitability information
    * @param userId : Id of the User
    * @param typology : String with profSheet typology
    * @return Map<String, Object> map with the actions and permissions
    */
    public static Map<String, Object> checkCreateRequestPermissions(pa_general_configuration__mdt genConfig, ProfitabilitySheet_Wrapper profSheet, Id userId, String typology) {
        final Type permissionsClass = Type.forName(genConfig.permissions_itf_name__c);
        final Permissions_itf permissionsItf = (Permissions_itf) permissionsClass.newInstance();
        return permissionsItf.canCreateRequestPA(profSheet, userId, typology);
    }

    /**
    * @description Helper method to obtain context Profitability Analysis
    * @param recordId : Profitability Analysis record id
    * @return profitability_analysis__c context record
    */
    public static profitability_analysis__c getContextProfAnalysis(Id recordId) {
        ProfitabilityAnalysis_Selector paSelector = new ProfitabilityAnalysis_Selector(true);
        return paSelector.selectById(new Set<Id>{recordId}).get(0);
    }

    /**
    * @description Returns whether the user can manage a Profitability Analysis
    * @param genConfig : Metadata record with the general configuration of classes
    * @param profAnalysisId : Id of the profitability analysis context
    * @param userId : Id of the User
    * @return Map<String, Object> map with the permissions
    */
    public static Map<String, Object> checkManagePAPermissions(pa_general_configuration__mdt genConfig, Id profAnalysisId, Id userId) {
        final Type permissionsClass = Type.forName(genConfig.permissions_itf_name__c);
        final Permissions_itf permissionsItf = (Permissions_itf) permissionsClass.newInstance();
        return permissionsItf.canManageAnalysis(profAnalysisId, userId);
    }
}