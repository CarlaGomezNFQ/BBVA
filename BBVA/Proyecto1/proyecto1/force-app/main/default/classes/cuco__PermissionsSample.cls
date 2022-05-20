/**
* ____________________________________________________________________________
* profitabilityAnalysis Permissions Sample
* Sample implementation of the interface Permissions_itf to determine
* whether the user can perform the different typologies of profitability
* analysis: create, edit and delete.
* ____________________________________________________________________________
* @author      Torcuato Tejada <torcuato.tejada.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-02-04
* @modified
* @systemLayer Sample
* ____________________________________________________________________________
* @changes
*
* ____________________________________________________________________________
*/
@SuppressWarnings('PMD.AvoidGlobalModifier')
global with sharing class PermissionsSample implements Permissions_itf {

    /**
    * @description Returns user permissions to manage conditions in the specified Profitability Ananlysis
    * @param profAnalysisId : Id of the Profitability Analysis
    * @param userId : Id of the User
    * @return Map<String, Object> map with the actions and permissions
    */
    global Map<String, Boolean> canManageConditions(Id profAnalysisId, Id userId) {

        final Set<Id> ids = new Set<Id>{profAnalysisId};
        final Map<String, Boolean> res = new Map<String, Boolean>();
        final List<String> validStatus = new List<String>{'Analysis', 'Restudy', 'Sent for Price Approval', 'Sent for Price Approval Top'};
        Boolean canAdd = false;
        Boolean canEdit = false;
        Boolean canRemove = false;

        final ProfitabilityAnalysis_Selector selector = new ProfitabilityAnalysis_Selector(true);
        final List<profitability_analysis__c> pa = selector.selectById(ids);

        if (pa.size() > 0) {
            canAdd = validStatus.indexOf(pa[0].gf_pa_mgmt_status_type_name__c) > -1 &&  pa[0].gf_pa_management_type_name__c != 'Cancellation';
        }
        canEdit = canAdd;
        canRemove = canAdd;

        res.put('add', canAdd);
        res.put('edit', canEdit);
        res.put('remove', canRemove);

        return res;
    }

    /**
    * @description Returns whether the user can add conditions in the Profitability Ananlysis
    * @param profAnalysisId : Id of the Profitability Analysis
    * @param userId : Id of the User
    * @return Map<String, Object> map with the actions and permissions
    */
    global Map<String, Object> canAddConditions(Id profAnalysisId, Id userId) {

        final Set<Id> ids = new Set<Id>{profAnalysisId};
        final Map<String, Object> res = new Map<String, Object>();
        final List<String> validStatus = new List<String>{'Analysis', 'Restudy', 'Sent for Price Approval', 'Sent for Price Approval Top'};
        Boolean canAdd = false;

        final ProfitabilityAnalysis_Selector selector = new ProfitabilityAnalysis_Selector(true);
        final List<profitability_analysis__c> pa = selector.selectById(ids);

        if (pa.size() > 0) {
            canAdd = validStatus.indexOf(pa[0].gf_pa_mgmt_status_type_name__c) > -1 &&  pa[0].gf_pa_management_type_name__c != 'Cancellation';
        }
        res.put('add', canAdd);

        if (!canAdd) {
            res.put('addMessage', Label.add_cond_perm_error_sample);
        }

        return res;
    }

    /**
    * @description Returns whether the user can edit a family of conditions in the Profitability Ananlysis
    * @param profAnalysisId : Id of the Profitability Analysis
    * @param userId : Id of the User
    * @param familyId : Id of the Family
    * @return Map<String, Object> map with the actions and permissions
    */
    global Map<String, Object> canEditConditions(Id profAnalysisId, Id userId, Id familyId) {

        final Set<Id> ids = new Set<Id>{profAnalysisId};
        final Map<String, Object> res = new Map<String, Object>();
        final List<String> validStatus = new List<String>{'Analysis', 'Restudy', 'Sent for Price Approval', 'Sent for Price Approval Top'};
        Boolean canEdit = false;

        final ProfitabilityAnalysis_Selector selector = new ProfitabilityAnalysis_Selector(true);
        final List<profitability_analysis__c> pa = selector.selectById(ids);

        if (pa.size() > 0) {
            canEdit = validStatus.indexOf(pa[0].gf_pa_mgmt_status_type_name__c) > -1 &&  pa[0].gf_pa_management_type_name__c != 'Cancellation';
        }
        res.put('edit', canEdit);

        if (!canEdit) {
            res.put('editMessage', Label.edit_cond_perm_error_sample);
        }

        return res;
    }

    /**
    * @description Returns whether the user can remove a specific condition in the Profitability Ananlysis
    * @param profAnalysisId : Id of the Profitability Analysis
    * @param userId : Id of the User
    * @param conditionId : Id of the Condition
    * @return Map<String, Object> map with the actions and permissions
    */
    global Map<String, Object> canRemoveCondition(Id profAnalysisId, Id userId, Id paConditionId) {

        final Set<Id> ids = new Set<Id>{profAnalysisId};
        final Map<String, Object> res = new Map<String, Object>();
        final List<String> validStatus = new List<String>{'Analysis', 'Restudy', 'Sent for Price Approval', 'Sent for Price Approval Top'};
        Boolean canRemove = false;

        final ProfitabilityAnalysis_Selector selector = new ProfitabilityAnalysis_Selector(true);
        final List<profitability_analysis__c> pa = selector.selectById(ids);

        if (pa.size() > 0) {
            canRemove = validStatus.indexOf(pa[0].gf_pa_mgmt_status_type_name__c) > -1 &&  pa[0].gf_pa_management_type_name__c != 'Cancellation';
        }
        res.put('remove', canRemove);

        if (!canRemove) {
            res.put('removeMessage', Label.remove_cond_perm_error_sample);
        }

        return res;
    }

    /**
    * @description Returns whether the user has available the specific actions Add/Remove on a Profitability Analysis record
    * @param profAnalysisId : Id of the Profitability Analysis
    * @param userId : Id of the User
    * @return Map<String, Object> map with the actions and permissions
    */
    global Map<String, Object> canManageParticipants(Id profAnalysisId, Id userId) {

        final Set<Id> setIdsCanManage = new Set<Id>{profAnalysisId};
        final Map<String, Object> retMapCanManage = new Map<String, Object>();
        final List<String> lstValidStatusManage = new List<String>{'Analysis', 'Restudy', 'Sent for Price Approval', 'Sent for Price Approval Top'};
        Boolean canAddManage = false;
        Boolean canRemoveManage = false;

        final ProfitabilityAnalysis_Selector paSelectorManage = new ProfitabilityAnalysis_Selector(true);
        final List<profitability_analysis__c> lstPAManage = paSelectorManage.selectById(setIdsCanManage);

        if (!lstPAManage.isEmpty()) {
            canAddManage = lstValidStatusManage.indexOf(lstPAManage[0].gf_pa_mgmt_status_type_name__c) > -1 &&  lstPAManage[0].gf_pa_management_type_name__c != 'Cancellation';
        }
        canRemoveManage = canAddManage;

        retMapCanManage.put('add', canAddManage);
        retMapCanManage.put('remove', canRemoveManage);

        return retMapCanManage;
    }

    /**
    * @description Returns whether the user can use the specific action Add on a Profitability Analysis record
    * @param profAnalysisId : Id of the Profitability Analysis
    * @param userId : Id of the User
    * @return Map<String, Object> map with the actions and permissions
    */
    global Map<String, Object> canAddParticipants(Id profAnalysisId, Id userId) {

      final Set<Id> setIdsAdd = new Set<Id>{profAnalysisId};
      final Map<String, Object> retMapAdd = new Map<String, Object>();
      final List<String> lstValidStatusAdd = new List<String>{'Analysis', 'Restudy', 'Sent for Price Approval', 'Sent for Price Approval Top'};
      Boolean canAdd = false;

      final ProfitabilityAnalysis_Selector paSelectorAdd = new ProfitabilityAnalysis_Selector(true);
      final List<profitability_analysis__c> lstPAAdd = paSelectorAdd.selectById(setIdsAdd);

      if (!lstPAAdd.isEmpty()) {
          canAdd = lstValidStatusAdd.indexOf(lstPAAdd[0].gf_pa_mgmt_status_type_name__c) > -1 &&  lstPAAdd[0].gf_pa_management_type_name__c != 'Cancellation';
      }

      retMapAdd.put('add', canAdd);

      if (!canAdd) {
        retMapAdd.put('addMessage', Label.add_subs_perm_error_sample);
      }

      return retMapAdd;
    }

    /**
    * @description Returns whether the user can use the specific action Remove on a Profitability Analysis record
    * @param profAnalysisId : Id of the Profitability Analysis
    * @param userId : Id of the User
    * @param accountId : Id of the Account
    * @return Map<String, Object> map with the actions and permissions
    */
    global Map<String, Object> canRemoveParticipant(Id profAnalysisId, Id userId, Id accountId) {

      final Set<Id> setIdsRemove = new Set<Id>{profAnalysisId};
      final Map<String, Object> retMapRemove = new Map<String, Object>();
      final List<String> lstValidStatusRemove = new List<String>{'Analysis', 'Restudy', 'Sent for Price Approval', 'Sent for Price Approval Top'};
      Boolean canRemove = false;

      final ProfitabilityAnalysis_Selector paSelectorRemove = new ProfitabilityAnalysis_Selector(true);
      final List<profitability_analysis__c> lstPARemove = paSelectorRemove.selectById(setIdsRemove);

      if (lstPARemove.size() > 0) {
          canRemove = lstValidStatusRemove.indexOf(lstPARemove[0].gf_pa_mgmt_status_type_name__c) > -1 &&  lstPARemove[0].gf_pa_management_type_name__c != 'Cancellation';
      }
      retMapRemove.put('remove', canRemove);

      if (!canRemove) {
        retMapRemove.put('removeMessage', Label.remove_subs_perm_error_sample);
      }

      return retMapRemove;
    }

    /**
    * @description Returns whether the user can create a specific condition in the Profitability Ananlysis
    * @param accountId : Id of the Account
    * @param userId : Id of the User
    * @return Map<String, Object> map with the actions and permissions
    */
    global Map<String, Object> canCreateNewPA(Id accountId, Id userId) {

        final Map<String, Object> res = new Map<String, Object>();
        final ParticipantHierarchy_Wrapper resPartHierarchy = new ParticipantSample().getParticipantHierarchy(accountId);

        final List<Account> lstAcc = [SELECT Id, OwnerId, parentId FROM Account WHERE Id = :accountId];
        Boolean canCreate = false;
        final String participantType = resPartHierarchy.type;

        if (participantType == 'group' || participantType == 'orphan') {
            if (lstAcc[0].OwnerId == userId) {
                canCreate = true;
            }
        }
        if (participantType == 'subsidiary') {
            final List<Account> lstAccParent = [SELECT Id, OwnerId FROM Account WHERE parentId = :lstAcc[0].parentId];
            if (lstAccParent[0].OwnerId == userId) {
                canCreate = true;
            }
        }
        res.put('create', canCreate);
        if (!canCreate) {
            res.put('createMessage', Label.creation_perm_error_sample);
        }
        return res;
    }

    /**
    * @description Returns user permissions to manage package in the specified Profitability Analysis
    * @param profAnalysisId : Id of the Profitability Analysis
    * @param userId : Id of the User
    * @return Map<String, Boolean> map with the actions and permissions
    */
    global Map<String, Object> canManagePackages(Id profAnalysisId, Id userId) {
        final Map<String, Object> retMapManagePkg = new Map<String, Object>();
        final Set<Id> setProfAnId = new Set<Id>{profAnalysisId};
        final List<String> validStatus = new List<String>{'Analysis', 'Restudy', 'Sent for Price Approval', 'Sent for Price Approval Top'};

        Boolean canAddManagePkg = false;
        Boolean canEditManagePkg = false;
        Boolean canCancelManagePkg = false;

        final ProfitabilityAnalysis_Selector paSelector = new ProfitabilityAnalysis_Selector(true);
        final List<profitability_analysis__c> lstPA = paSelector.selectById(setProfAnId);

        if (!lstPA.isEmpty()) {
            canAddManagePkg = validStatus.indexOf(lstPA[0].gf_pa_mgmt_status_type_name__c) > -1 && lstPA[0].gf_pa_management_type_name__c != 'Cancellation';
        }
        canEditManagePkg = canAddManagePkg;
        canCancelManagePkg = canAddManagePkg;

        retMapManagePkg.put('add', canAddManagePkg);
        retMapManagePkg.put('edit', canEditManagePkg);
        retMapManagePkg.put('cancel', canCancelManagePkg);

        return retMapManagePkg;
    }

    /**
    * @description Returns whether the user can add a package to a Profitability Analysis
    * @param profAnalysisId : Id of the Profitability Analysis
    * @param userId : Id of the User
    * @param pkgType : String with the pkg type to be added
    * @return Map<String, Boolean> map with the actions and permissions
    */
    global Map<String, Object> canAddPackage(Id profAnalysisId, Id userId, String pkgType) {
        final Map<String, Object> retMapAddPkg = new Map<String, Object>();
        final Set<Id> setProfAnId = new Set<Id>{profAnalysisId};
        final List<String> validStatus = new List<String>{'Analysis', 'Restudy', 'Sent for Price Approval', 'Sent for Price Approval Top'};

        Boolean canAddPkg = false;

        final ProfitabilityAnalysis_Selector paSelector = new ProfitabilityAnalysis_Selector(true);
        final List<profitability_analysis__c> lstPA = paSelector.selectById(setProfAnId);

        if (!lstPA.isEmpty()) {
            canAddPkg = validStatus.indexOf(lstPA[0].gf_pa_mgmt_status_type_name__c) > -1 && lstPA[0].gf_pa_management_type_name__c != 'Cancellation';
        }

        retMapAddPkg.put('add', canAddPkg);

        if (!canAddPkg) {
            retMapAddPkg.put('addMessage', Label.pkg_add_perm_error_sample);
        }

        return retMapAddPkg;
    }

    /**
    * @description Returns whether the user can edit a package from a Profitability Analysis
    * @param profAnalysisId : Id of the Profitability Analysis
    * @param userId : Id of the User
    * @param package : Wrapper with package values to edit
    * @return Map<String, Boolean> map with the actions and permissions
    */
    global Map<String, Object> canEditPackage(Id profAnalysisId, Id userId, Package_Wrapper packageWrapper) {
        final Map<String, Object> retMapEditPkg = new Map<String, Object>();
        final Set<Id> setProfAnId = new Set<Id>{profAnalysisId};
        final List<String> validStatus = new List<String>{'Analysis', 'Restudy', 'Sent for Price Approval', 'Sent for Price Approval Top'};

        Boolean canEditPkg = false;

        final ProfitabilityAnalysis_Selector paSelector = new ProfitabilityAnalysis_Selector(true);
        final List<profitability_analysis__c> lstPA = paSelector.selectById(setProfAnId);

        if (!lstPA.isEmpty()) {
            canEditPkg = validStatus.indexOf(lstPA[0].gf_pa_mgmt_status_type_name__c) > -1 && lstPA[0].gf_pa_management_type_name__c != 'Cancellation';
        }

        retMapEditPkg.put('edit', canEditPkg);

        if (!canEditPkg) {
            retMapEditPkg.put('editMessage', Label.pkg_edit_perm_error_sample);
        }

        return retMapEditPkg;
    }

    /**
    * @description Returns whether the user can cancel a package from a Profitability Analysis
    * @param profAnalysisId : Id of the Profitability Analysis
    * @param userId : Id of the User
    * @param package : Wrapper with package values to cancel
    * @return Map<String, Boolean> map with the actions and permissions
    */
    global Map<String, Object> canCancelPackage(Id profAnalysisId, Id userId, Package_Wrapper packageWrapper) {
        final Map<String, Object> retMapCancelPkg = new Map<String, Object>();
        final Set<Id> setProfAnId = new Set<Id>{profAnalysisId};
        final List<String> validStatus = new List<String>{'Analysis', 'Restudy', 'Sent for Price Approval', 'Sent for Price Approval Top'};

        Boolean canCancelPkg = false;

        final ProfitabilityAnalysis_Selector paSelector = new ProfitabilityAnalysis_Selector(true);
        final List<profitability_analysis__c> lstPA = paSelector.selectById(setProfAnId);

        if (!lstPA.isEmpty()) {
            canCancelPkg = validStatus.indexOf(lstPA[0].gf_pa_mgmt_status_type_name__c) > -1 && lstPA[0].gf_pa_management_type_name__c != 'Cancellation';
        }

        retMapCancelPkg.put('cancel', canCancelPkg);

        if (!canCancelPkg) {
            retMapCancelPkg.put('cancelMessage', Label.pkg_cancel_perm_error_sample);
        }

        return retMapCancelPkg;
    }
    /**
    * @description Returns whether the user can manage a Profitability Analysis
    * @param profAnalysisId : Id of the Profitability Analysis
    * @param userId : Id of the User
    * @return Map<String, Object> map with the actions and permissions
    */
    global Map<String, Object> canManageAnalysis(Id profAnalysisId, Id userId) {
        final Map<String, Object> retMapManAnalysis= new Map<String, Object>();
        final Set<Id> setProfAnId = new Set<Id>{profAnalysisId};
        final ProfitabilityAnalysis_Selector paSelector = new ProfitabilityAnalysis_Selector(true);
        final List<profitability_analysis__c> lstPA = paSelector.selectById(setProfAnId);
        Boolean canManageAnalys = false;

        if (!lstPA.isEmpty()) {
            final List<String> validStatus = new List<String>{'Analysis', 'Restudy', 'Sent for Price Approval', 'Sent for Price Approval Top'};
            canManageAnalys = validStatus.indexOf(lstPA[0].gf_pa_mgmt_status_type_name__c) > -1 && lstPA[0].gf_pa_management_type_name__c != 'Cancellation';
        }

        retMapManAnalysis.put('manage', canManageAnalys);

        if (!canManageAnalys) {
            retMapManAnalysis.put('manageMessage', Label.manage_analysis_perm_error_sample);
        }

        return retMapManAnalysis;
    }
    /**
    * @description Returns whether the user can create requests for a Profitability Analysis
    * @param profAnalysisId : Wrapper with Profitability information
    * @param userId : Id of the User
    * @param typology : typology of profSheet
    * @return Map<String, Object> map with the actions and permissions
    */
    global Map<String, Object> canCreateRequestPA(ProfitabilitySheet_Wrapper profSheet, Id userId, String typology) {
        final Map<String, Object> retMapCrReq= new Map<String, Object>();
        Boolean canCreateRequest = false;
        final List<Account> accs = [SELECT Id, OwnerId FROM Account WHERE Id =: profSheet.groupId];

        if(!accs.isEmpty() && userId == accs[0].OwnerId) {
            canCreateRequest = true;
            retMapCrReq.put('canCreate',canCreateRequest);
        } else {
            if(typology	 == Label.renewal) {
                retMapCrReq.put('message',Label.creation_perm_error_sample);
            } else if(typology == Label.novation) {
                retMapCrReq.put('message',Label.novation_perm_error_sample);
            } else if(typology == Label.cancellation) {
                retMapCrReq.put('message',Label.cancellation_perm_error_sample);
            }
        }
        return retMapCrReq;
    }

    /**
    * @description Returns whether the user can manage a Flat Rates
    * @param profAnalysisId : Id of the Profitability Analysis
    * @param userId : Id of the User
    * @return Map<String, Object> map with the actions and permissions
    */
    global Map<String, Object> canManageFlatRates(Id profAnalysisId, Id userId) {
        final Map<String, Object> retMapManageFlatRates = new Map<String, Object>();
        final Set<Id> setProfAnId = new Set<Id>{profAnalysisId};
        final ProfitabilityAnalysis_Selector paSelector = new ProfitabilityAnalysis_Selector(true);
        final List<profitability_analysis__c> lstPA = paSelector.selectById(setProfAnId);
        Boolean canManageFlatRates = false;
        if (!lstPA.isEmpty()) {
            final List<String> validStatus = new List<String>{'Analysis', 'Restudy', 'Sent for Price Approval', 'Sent for Price Approval Top'};
            canManageFlatRates = validStatus.indexOf(lstPA[0].gf_pa_mgmt_status_type_name__c) > -1 && lstPA[0].gf_pa_management_type_name__c != 'Cancellation';
        }
        retMapManageFlatRates.put('setup', canManageFlatRates);
        retMapManageFlatRates.put('remove', canManageFlatRates);
        return retMapManageFlatRates;
    }

    /**
    * @description Returns whether the user can setup a flat rates
    * @param profAnalysisId : Id of the Profitability Analysis
    * @param userId : Id of the User
    * @return Map<String, Object> map with the actions and permissions
    */
    global Map<String, Object> canSetupFlatRates(Id profAnalysisId, Id userId) {
        final Map<String, Object> retMapSetupFlatRates = new Map<String, Object>();
        final Set<Id> setProfAnId = new Set<Id>{profAnalysisId};
        final ProfitabilityAnalysis_Selector paSelector = new ProfitabilityAnalysis_Selector(true);
        final List<profitability_analysis__c> lstPA = paSelector.selectById(setProfAnId);
        Boolean canSetupFlatRates  = false;

        if (!lstPA.isEmpty()) {
            final List<String> validStatus = new List<String>{'Analysis', 'Restudy', 'Sent for Price Approval', 'Sent for Price Approval Top'};
            canSetupFlatRates  = validStatus.indexOf(lstPA[0].gf_pa_mgmt_status_type_name__c) > -1 && lstPA[0].gf_pa_management_type_name__c != 'Cancellation';
        }

        retMapSetupFlatRates.put('setup', canSetupFlatRates);

        if(!canSetupFlatRates){
            retMapSetupFlatRates.put('setupMessage', Label.setup_fr_perm_error_sample);
        }

        return retMapSetupFlatRates;
    }

    /**
    * @description Returns whether the user can remove a Flat Rate
    * @param profAnalysisId : Id of the Profitability Analysis
    * @param userId : Id of the User
    * @return Map<String, Object> map with the actions and permissions
    */
    global Map<String, Object> canRemoveFlatRates(Id profAnalysisId, Id userId) {
        final Map<String, Object> retMapRemoveFlatRates = new Map<String, Object>();
        final Set<Id> setProfAnId = new Set<Id>{profAnalysisId};
        final ProfitabilityAnalysis_Selector paSelector = new ProfitabilityAnalysis_Selector(true);
        final List<profitability_analysis__c> lstPA = paSelector.selectById(setProfAnId);
        Boolean canRemoveFlatRates  = false;

        if (!lstPA.isEmpty()) {
            final List<String> validStatus = new List<String>{'Analysis', 'Restudy', 'Sent for Price Approval', 'Sent for Price Approval Top'};
            canRemoveFlatRates  = validStatus.indexOf(lstPA[0].gf_pa_mgmt_status_type_name__c) > -1 && lstPA[0].gf_pa_management_type_name__c != 'Cancellation';
        }

        retMapRemoveFlatRates.put('remove', canRemoveFlatRates);

        if(!canRemoveFlatRates){
            retMapRemoveFlatRates.put('removeMessage', Label.remove_fr_perm_error_sample);
        }

        return retMapRemoveFlatRates;
    }
}