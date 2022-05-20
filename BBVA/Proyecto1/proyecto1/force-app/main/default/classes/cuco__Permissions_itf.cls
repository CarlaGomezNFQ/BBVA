/**
* ____________________________________________________________________________
* Permissions Interface
* Interface methods to determine whether the user can perform the  different
* typologies of profitability analysis: create, edit, delete...
* ____________________________________________________________________________
* @author      Torcuato Tejada <torcuato.tejada.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-02-04
* @modified
* @systemLayer Domain
* ____________________________________________________________________________
* @changes
*
* ____________________________________________________________________________
*/
@SuppressWarnings('PMD.AvoidGlobalModifier')
global interface Permissions_itf {

    /**
    * @description Returns user permissions to manage conditions in the specified Profitability Analysis
    * @param profAnalysisId : Id of the Profitability Analysis
    * @param userId : Id of the User
    * @return Map<String, Boolean> map with the actions and permissions
    */
    Map<String, Boolean> canManageConditions(Id profAnalysisId, Id userId);

    /**
    * @description Returns whether the user can add conditions in the Profitability Analysis
    * @param profAnalysisId : Id of the Profitability Analysis
    * @param userId : Id of the User
    * @return Map<String, Object> map with the actions and permissions
    */
    Map<String, Object> canAddConditions(Id profAnalysisId, Id userId);

    /**
    * @description Returns whether the user can edit a family of conditions in the Profitability Analysis
    * @param profAnalysisId : Id of the Profitability Analysis
    * @param userId : Id of the User
    * @param familyId : Id of the Family
    * @return Map<String, Object> map with the actions and permissions
    */
    Map<String, Object> canEditConditions(Id profAnalysisId, Id userId, Id familyId);

    /**
    * @description Returns whether the user can remove a specific condition in the Profitability Analysis
    * @param profAnalysisId : Id of the Profitability Analysis
    * @param userId : Id of the User
    * @param conditionId : Id of the Condition
    * @return Map<String, Object> map with the actions and permissions
    */
    Map<String, Object> canRemoveCondition(Id profAnalysisId, Id userId, Id paConditionId);

    /**
    * @description Returns whether the user has available the specific actions Add/Remove on a Profitability Analysis record
    * @param profAnalysisId : Id of the Profitability Analysis
    * @param userId : Id of the User
    * @return Map<String, Object> map with the actions and permissions
    */
    Map<String, Object> canManageParticipants(Id profAnalysisId, Id userId);

    /**
    * @description Returns whether the user can use the specific action Add on a Profitability Analysis record
    * @param profAnalysisId : Id of the Profitability Analysis
    * @param userId : Id of the User
    * @return Map<String, Object> map with the actions and permissions
    */
    Map<String, Object> canAddParticipants(Id profAnalysisId, Id userId);

    /**
    * @description Returns whether the user can use the specific action Remove on a Profitability Analysis record
    * @param profAnalysisId : Id of the Profitability Analysis
    * @param userId : Id of the User
    * @param accountId : Id of the Account
    * @return Map<String, Object> map with the actions and permissions
    */
    Map<String, Object> canRemoveParticipant(Id profAnalysisId, Id userId, Id accountId);

    /**
    * @description Returns whether the user can create a Profitability Analysis
    * @param accountId :  Id of the account
    * @param userId : Id of the User
    * @return Map<String, Object> map with the actions and permissions
    */
    Map<String, Object> canCreateNewPA(Id accountId, Id userId);

    /**
    * @description Returns user permissions to manage package in the specified Profitability Analysis
    * @param profAnalysisId : Id of the Profitability Analysis
    * @param userId : Id of the User
    * @return Map<String, Boolean> map with the actions and permissions
    */
    Map<String, Object> canManagePackages(Id profAnalysisId, Id userId);

    /**
    * @description Returns whether the user can add a package to a Profitability Analysis
    * @param profAnalysisId : Id of the Profitability Analysis
    * @param userId : Id of the User
    * @param pkgType : String with the pkg type to be added
    * @return Map<String, Boolean> map with the actions and permissions
    */
    Map<String, Object> canAddPackage(Id profAnalysisId, Id userId, String pkgType);

    /**
    * @description Returns whether the user can edit a package from a Profitability Analysis
    * @param profAnalysisId : Id of the Profitability Analysis
    * @param userId : Id of the User
    * @param package : Wrapper with package values to edit
    * @return Map<String, Boolean> map with the actions and permissions
    */
    Map<String, Object> canEditPackage(Id profAnalysisId, Id userId, Package_Wrapper packageWrapper);

    /**
    * @description Returns whether the user can cancel a package from a Profitability Analysis
    * @param profAnalysisId : Id of the Profitability Analysis
    * @param userId : Id of the User
    * @param package : Wrapper with package values to cancel
    * @return Map<String, Boolean> map with the actions and permissions
    */
    Map<String, Object> canCancelPackage(Id profAnalysisId, Id userId, Package_Wrapper packageWrapper);

    /**
    * @description Returns whether the user can manage a Profitability Analysis
    * @param profAnalysisId : Id of the Profitability Analysis
    * @param userId : Id of the User
    * @return Map<String, Object> map with the actions and permissions
    */
    Map<String, Object> canManageAnalysis(Id profAnalysisId, Id userId);

    /**
    * @description Returns whether the user can create requests for a Profitability Analysis
    * @param profSheet : Wrapper with Profitability information
    * @param userId : Id of the User
    * @param typology : String with profSheet typology
    * @return Map<String, Object> map with the actions and permissions
    */
    Map<String, Object> canCreateRequestPA(ProfitabilitySheet_Wrapper profSheet, Id userId, String typology);

    /**
    * @description Returns whether the user can manage a Flat Rates
    * @param profAnalysisId : Id of the Profitability Analysis
    * @param userId : Id of the User
    * @return Map<String, Object> map with the actions and permissions
    */
    Map<String, Object> canManageFlatRates(Id profAnalysisId, Id userId);

    /**
    * @description Returns whether the user can setup a flat rates
    * @param profAnalysisId : Id of the Profitability Analysis
    * @param userId : Id of the User
    * @return Map<String, Object> map with the actions and permissions
    */
    Map<String, Object> canSetupFlatRates(Id profAnalysisId, Id userId);

    /**
    * @description Returns whether the user can remove a Flat Rate
    * @param profAnalysisId : Id of the Profitability Analysis
    * @param userId : Id of the User
    * @return Map<String, Object> map with the actions and permissions
    */
    Map<String, Object> canRemoveFlatRates(Id profAnalysisId, Id userId);
}