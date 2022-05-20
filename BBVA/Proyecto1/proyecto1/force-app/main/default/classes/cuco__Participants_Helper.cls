/**
* ────────────────────────────────────────────────────────────────────
* Participants_Helper
* Helper class for Participants_Service apex class
* ────────────────────────────────────────────────────────────────────
* @author      Diego Arias <diego.arias.fernandez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-02-11
* @modified
* @systemLayer Any
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@SuppressWarnings('sf:DMLWithoutSharingEnabled')
public class Participants_Helper {

    /**
    * @description Private constructor to avoid sonar err
    */
    @TestVisible
    private Participants_Helper() {}

    /**
    * @description Returns the related account Id of the context record
    * @param recordId : Id of the context record
    * @param sObjectName : String with the api SObject Name of the context record
    * @return Id, with the related account id of the context record
    */
    public static Id getRelatedAccountId(Id recordId, String sObjectName) {
        Id accountId;
        if (sObjectName == 'cuco__profitability_sheet__c') {
            final ProfitabilitySheet_Selector psSelector = new ProfitabilitySheet_Selector();
            final List<profitability_sheet__c> lstPS = psSelector.selectById(new Set<Id>{recordId});
            accountId = lstPS[0].participant_id__c;
        } else if (sObjectName == 'cuco__profitability_analysis__c') {
            final ProfitabilityAnalysis_Selector paSelector = new ProfitabilityAnalysis_Selector();
            final List<profitability_analysis__c> lstPA = paSelector.selectById(new Set<Id>{recordId});
            accountId = lstPA[0].participant_id__c;
        }
        return accountId;
    }

    /**
    * @description Returns the related hierarchy of the related accountId context record
    * @param genConfig : Metadata record with the general configuration of classes
    * @param accountId : Id of the related account record of the context record
    * @return ParticipantHierarchy_Wrapper, with the participant hierarchy info
    */
    public static ParticipantHierarchy_Wrapper getParticipantHierarchy(pa_general_configuration__mdt genConfig, Id accountId) {
        final Type participantClass = Type.forName(genConfig.participants_itf_name__c);
        final Participant_itf participantItf = (Participant_itf) participantClass.newInstance();
        return participantItf.getParticipantHierarchy(accountId);
    }

    /**
    * @description Returns a wrapper with the info of each account of set
    * @param genConfig : Metadata record with the general configuration of classes
    * @param accountId : Id of the related account record of the context record
    * @return Map<String, Object>, with the participant hierarchy info
    */
    public static List<Participant_Wrapper> getParticipantDetails(pa_general_configuration__mdt genConfig, Set<Id> accIdSet) {
        final Type permissionsClass = Type.forName(genConfig.participants_itf_name__c);
        final Participant_itf participantItf = (Participant_itf) permissionsClass.newInstance();
        return participantItf.getParticipantDetails(accIdSet);
    }

    /**
    * @description Returns a wrapper with the info of each account of set
    * @param genConfig : Metadata record with the general configuration of classes
    * @param accountId : Id of the related account record of the context record
    * @return Map<String, Object>, with the participant hierarchy info
    */
    public static List<Participant_Wrapper> getParticipantsToSelect(pa_general_configuration__mdt genConfig, Set<Id> accIdSet) {
      final Type permissionsClass = Type.forName(genConfig.participants_itf_name__c);
      final Participant_itf participantItf = (Participant_itf) permissionsClass.newInstance();
      return participantItf.getParticipantsToSelect(accIdSet, UserInfo.getUserId());
    }

    /**
    * @description Build the initial map to return to lightning component
    * @param profRecordId: Context record Id
    * @param partHierWrapp: Wrapper with the related hierarchy of the related accountId context record
    * @param sObjectName: sObject Name of the context record
    * @param genConfig : Metadata record with the general configuration of classes
    * @return Map<String, Object>, fill with info in function of logic
    */
    public static Map<String, Object> buildInitResponse(Id profRecordId, ParticipantHierarchy_Wrapper partHierWrapp, String sObjectName, pa_general_configuration__mdt genConfig) {
        Map<String, Object> retMap = new Map<String, Object>();
        final String participantType = partHierWrapp.type;
        switch on participantType {
            when 'group' {
                retMap = getParticipantsInfo(profRecordId, sObjectName, genConfig);
            }
            when 'orphan', 'subsidiary' {
                retMap.put('showInfo', false);
            }
        }
        return retMap;
    }

    /**
    * @description Helper method to obtain participants info related to current record
    * @param profRecordId : Id of context record
    * @param sObjectName : String of sObject Name of context record
    * @param genConfig : Metadata record with the general configuration of classes
    * @return Map<String, Object>, with the participants info
    */
    private static Map<String, Object> getParticipantsInfo(Id profRecordId, String sObjectName, pa_general_configuration__mdt genConfig) {
        final Map<String, Object> retMap = new Map<String, Object>();
        Boolean showAddButton = false;
        Boolean showRemoveButton = false;
        retMap.put('showInfo', true);
        if (sObjectName == 'cuco__profitability_sheet__c') {
            retMap.put('tableTitle', Label.included_subsidiaries_ps);
            final ProfitabilitySheetParticipant_Selector pspSelector = new ProfitabilitySheetParticipant_Selector(true);
            final List<profitability_sheet_participant__c> lstPSP = pspSelector.selectByProfSheet(new Set<Id>{profRecordId});
            if (lstPSP.isEmpty()) {
                retMap.put('lstEmpty', true);
                retMap.put('errMessage', Label.no_subs_ps);
            } else {
                retMap.put('lstEmpty', false);
                retMap.put('lstParticipantsDetails', getParticipantsDetails(lstPSP, sObjectName, genConfig));
            }
        } else if (sObjectName == 'cuco__profitability_analysis__c') {
            retMap.put('tableTitle', Label.included_subsidiaries_pa);
            final PAParticipant_Selector papSelector = new PAParticipant_Selector(true);
            final List<profitability_analysis_participant__c> lstPAP = papSelector.selectByProfAnalysis(new Set<Id>{profRecordId});
            if (lstPAP.isEmpty()) {
                retMap.put('lstEmpty', true);
                retMap.put('errMessage', Label.no_subs_pa);
            } else {
                retMap.put('lstEmpty', false);
                retMap.put('lstParticipantsDetails', getParticipantsDetails(lstPAP, sObjectName, genConfig));
            }
            final Type permissionsClass = Type.forName(genConfig.permissions_itf_name__c);
            final Permissions_itf permissionsItf = (Permissions_itf) permissionsClass.newInstance();
            final Map<String, Object> retMapPermissions = permissionsItf.canManageParticipants(profRecordId, UserInfo.getUserId());
            showAddButton = (Boolean) retMapPermissions.get('add');
            showRemoveButton = (Boolean) retMapPermissions.get('remove');
        }
        retMap.put('showAddButton', showAddButton);
        retMap.put('showRemoveButton', showRemoveButton);
        return retMap;
    }

    /**
    * @description Helper method to obtain participants details from the participant itf implementation
    * @param lstParticipants : List of Objects of PSParticipant or PAParticipant records
    * @param sObjectName : String of sObject Name of context record
    * @param genConfig : Metadata record with the general configuration of classes
    * @return List<Participant_Wrapper>, with the participants wrapper info
    */
    private static List<ProfitabilityParticipant_Wrapper> getParticipantsDetails(List<Object> lstParticipants, String sObjectName, pa_general_configuration__mdt genConfig) {
        final Set<Id> accIdSet = new Set<Id>();
        final Map<Id, Id> mapRelatedAccWithPart = new Map<Id, Id>();
        for (Object objPS : lstParticipants) {
            if (sObjectName == 'cuco__profitability_sheet__c') {
                final profitability_sheet_participant__c pspObj = (profitability_sheet_participant__c) objPS;
                accIdSet.add((Id) pspObj.participant_id__c);
                mapRelatedAccWithPart.put(pspObj.participant_id__c, pspObj.Id);
            } else if (sObjectName == 'cuco__profitability_analysis__c') {
                final profitability_analysis_participant__c papObj = (profitability_analysis_participant__c) objPS;
                accIdSet.add((Id) papObj.participant_id__c);
                mapRelatedAccWithPart.put(papObj.participant_id__c, papObj.Id);
            }
        }

        final List<Participant_Wrapper> lstPW = getParticipantDetails(genConfig, accIdSet);
        final List<ProfitabilityParticipant_Wrapper> lstPPWrapp = new List<ProfitabilityParticipant_Wrapper>();
        for (Participant_Wrapper pw : lstPW) {
            final ProfitabilityParticipant_Wrapper ppWrapp = new ProfitabilityParticipant_Wrapper();
            ppWrapp.profAnalysisParticipantId = mapRelatedAccWithPart.get(pw.participantId);
            ppWrapp.partWrapper = pw;
            lstPPWrapp.add(ppWrapp);
        }

        return lstPPWrapp;
    }

    /**
    * @description Build the initial map to return to lightning component
    * @param profAnalysisId: Context prof analysis record Id
    * @param partHierWrapp: Wrapper with the related hierarchy of the related accountId context record
    * @param genConfig : Metadata record with the general configuration of classes
    * @return Map<String, Object>, fill with info in function of logic
    */
    public static Map<String, Object> buildParticipantsAddResponse(profitability_analysis__c profAnalysis, ParticipantHierarchy_Wrapper partHierWrapp, pa_general_configuration__mdt genConfig) {
      Map<String, Object> retMap = new Map<String, Object>();

      final String participantType = partHierWrapp.type;
      switch on participantType {
          when 'group' {
              final Set<Id> setAcc = partHierWrapp.childIdsSet;
              retMap = retrieveAccsInTable(setAcc, genConfig, profAnalysis.gf_profitability_sheet_id__r.gf_profitability_sheet_id__c);
              retMap.put('profAccName', profAnalysis.participant_id__r.Name);
          }
          when 'orphan', 'subsidiary' {
              retMap.put('showTable', false);
              retMap.put('errMessage', Label.not_allow_add_participants);
              retMap.put('profAccName', profAnalysis.participant_id__r.Name);
          }
      }
      return retMap;
    }

    /**
    * @description Filter the acc id at param to get the current accs to show on table
    * @param childIds: List of accs to get filter
    * @param genConfig : Metadata record with the general configuration of classes
    * @param profSheetCode: Prof sheet code
    * @return Map<String, Object>, fill with info in function of logic
    */
    private static Map<String, Object> retrieveAccsInTable(Set<Id> childIds, pa_general_configuration__mdt genConfig, String profSheetCode) {
        final Map<String, Object> retMap = new Map<String, Object>();
        final Set<Id> childIdsSet = new Set<Id>();
        childIdsSet.addAll(childIds);

        // First step. Obtain PSheet actives relateds to this childIdsSet of accs at psparticipants
        final ProfitabilitySheetParticipant_Selector pspSelector = new ProfitabilitySheetParticipant_Selector(true);

        // If profSheetCode is filled, dont get the prof sheet participants of the prof sheet associated to profSheetCode
        List<profitability_sheet_participant__c> lstPSP = new List<profitability_sheet_participant__c>();
        if (profSheetCode == null) {
            lstPSP = pspSelector.selectAccsByStatusPS(childIdsSet,  new List<String>{'Valid'});
        } else {
            lstPSP = pspSelector.selectAccsByStatusAndPSCode(childIdsSet,  new List<String>{'Valid'}, new List<String>{profSheetCode});
        }

        for (profitability_sheet_participant__c psParticiapnt : lstPSP) {
            childIdsSet.remove(psParticiapnt.participant_id__c);
        }

        // Second step. Obtain PAnalysis actives relateds to the childIdsSet of accs at paparticipant
        final PAParticipant_Selector papSelector = new PAParticipant_Selector(true);
        final List<profitability_analysis_participant__c> lstPAP = papSelector.selectAccsWithActivePA(childIdsSet);

        for (profitability_analysis_participant__c paParticipant : lstPAP) {
            childIdsSet.remove(paParticipant.participant_id__c);
        }

        // Third filter. Obtain the related accs which owner id meet context user id
        final List<Participant_Wrapper> lstAccWrpp = getParticipantsToSelect(genConfig, childIdsSet);
        if (lstAccWrpp.isEmpty()) {
          retMap.put('showTable', false);
          retMap.put('errMessage', Label.not_available_group_ps);
        } else {
          retMap.put('showTable', true);
          retMap.put('tableInfo', lstAccWrpp);
        }
        return retMap;
    }

    /**
    * @description Create the new prof. ana. participants related to profAnalysis and remove cancellation pkg request related
    * @param profAnalysisId: Context prof analysis record Id
    * @param lstAccId : List of accs ids ready to include as participants at the related prof analysis
    * @return Map<String, Object>, fill with info in function of logic
    */
    public static Map<String, Object> createNewProfAnParcicipants(Id profAnalysisId, List<Id> lstAccsId) {
        final Map<String, Object> retMap = new Map<String, Object>();

        final Savepoint savePoint = Database.setSavepoint();

        // First create the new prof analysis participant
        final List<profitability_analysis_participant__c> lstPAP = new List<profitability_analysis_participant__c>();
        for (Id accId : lstAccsId) {
            lstPAP.add(new profitability_analysis_participant__c(participant_id__c = accId, gf_profitablity_analysis_id__c = profAnalysisId));
        }

        final Utils.DML_Wrapper retDMLInsertPAP = PAPackage_Service.insertPAP(lstPAP);
        retMap.put('isSuccess', retDMLInsertPAP.isSuccess);
        retMap.put('errMessage', retDMLInsertPAP.lstErrMessage);

        // Map to step 2.3 (Key with acc Id, value as pap id)
        final Map<Id, Id> mapAcc2PAP = new Map<Id, Id>();
        for (profitability_analysis_participant__c pap : lstPAP) {
            mapAcc2PAP.put(pap.participant_id__c, pap.Id);
        }

        // Second step. Remove the cancellation request related to forfait or gip packages for prof. ana. participants of this prof. ana.
        // 2.1 Get client package related to selected acc ids
        final ClientPackage_Selector cpSelector = new ClientPackage_Selector();
        final Set<Id> setAccId = new Set<Id>();
        setAccId.addAll(lstAccsId);
        final List<client_package__c> lstCP = cpSelector.selectPkgByAccIdAndStatus(setAccId, new List<String>{'Valid'});
        if (!lstCP.isEmpty()) {
            // 2.2 Get Prof Analysis Pkg Req cancellation related to prof analysis id and to client package lst
            final Set<Id> setCP = new Set<Id>();
            for (client_package__c cPkg : lstCP) {
                setCP.add(cPkg.Id);
            }
            final PAPackageRequest_Selector pkgReqSelector = new PAPackageRequest_Selector(true);
            final List<profitability_analysis_pkg_request__c>  lstPAPRCancellation = pkgReqSelector.selectPkgReqByReqType(setCP, profAnalysisId, new List<String>{'Cancellation'});
            if (!lstPAPRCancellation.isEmpty()) {
                final Utils.DML_Wrapper retDMLDeletePAPR = PAPackage_Service.deletePAPR(lstPAPRCancellation);
                retMap.put('isSuccess', retDMLDeletePAPR.isSuccess);
                retMap.put('errMessage', retDMLDeletePAPR.lstErrMessage);
            }

            // 2.3 Update current prof analysis pkg req to fill new participant_id related to current acc on 'Extension'
            final List<profitability_analysis_pkg_request__c>  lstPAPRExtension = pkgReqSelector.selectPkgReqByReqType(setCP, profAnalysisId, new List<String>{'Extension'});
            if (!lstPAPRExtension.isEmpty()) {
                for (profitability_analysis_pkg_request__c paprUpdate : lstPAPRExtension) {
                    paprUpdate.participant_id__c = mapAcc2PAP.get(paprUpdate.gf_cust_package_id__r.participant_id__c);
                }
                final Utils.DML_Wrapper retDMLUpsertPAPR = PAPackage_Service.upsertPAPR(lstPAPRExtension);
                retMap.put('isSuccess', retDMLUpsertPAPR.isSuccess);
                retMap.put('errMessage', retDMLUpsertPAPR.lstErrMessage);
            }
        }

        if (!(Boolean) retMap.get('isSuccess')) {
            Database.rollback(savePoint);
        }

        return retMap;
    }

    /**
    * @description Method that checks if there exist any extended package to a PAP of a Profitability Analysis
    * @param profAnalysisId: Profitability Analysis Id
    * @param accId: Account id related to the profitability analysis participant
    * @return Map<String, Object>, with the response of the delete
    */
    public static Map<String, Object> retrieveExtendedPkgOfAnAcc(Id profAnalysisId, Id accId) {
        final Map<String, Object> retMap = new Map<String, Object>();
        retMap.put('hasExtPkg', false);

        // Get all the extended pkg for the param prof analysis
        final Map<String, Set<String>> mapExtendedPkg = ProfitabilityAnalysis_Helper.getExtendedPkgOfProfAnalysis(profAnalysisId);
        if (!mapExtendedPkg.isEmpty()) {
            // Get the current active version of general config mtd
            final pa_general_configuration__mdt genConfig = Utils.getGeneralConfiguration();

            // Get current acc param details
            List<Participant_Wrapper> lstWrp = getParticipantDetails(genConfig, new Set<Id>{accId});

            if (mapExtendedPkg.containsKey(lstWrp[0].participantCode)) {
                final PsCatalogPackage_Selector psCatPkgSelector = new PsCatalogPackage_Selector();
                final List<ps_catalog_package__c> lstCatPkg = psCatPkgSelector.selectByPkgCode(mapExtendedPkg.get(lstWrp[0].participantCode));
                retMap.put('hasExtPkg', true);
                retMap.put('extPkgName', lstCatPkg[0].gf_psc_package_name__c);
                retMap.put('conditionIdentifier', lstWrp[0].participantCode + lstCatPkg[0].gf_psc_package_id__c);
            }
        }

        return retMap;
    }

    /**
    * @description Method that has the logic to desextend a pkg from a PAP
    * @param currentPAP : Current PAP which gonna be remove
    * @param genConfig : Metadata record with the general configuration of classes
    * @return Map<String, Object>, with the response of the dml operations
    */
    public static Map<String, Object> handleDesextendPkg(profitability_analysis_participant__c currentPAP, pa_general_configuration__mdt genConfig) {
        final Map<String, Object> retMap = new Map<String, Object>();
        retMap.put('isSuccess', true); // To avoid excesive cognitive complexity, it would be true or overwrite if false

        // Get participant details
        final List<Participant_Wrapper> lstWrp = getParticipantDetails(genConfig, new Set<Id>{currentPAP.participant_id__c});

        // Step 1.1 Check if pap has an extended package. If exist, remove.
        final ProfitabilityAnalysisCondition_Selector pacSelector = new ProfitabilityAnalysisCondition_Selector();
        final List<profitability_analysis_condition__c> lstPAC = pacSelector.selectByProfitabilityAnalysisIdAndSourceType(new Set<Id>{currentPAP.gf_profitablity_analysis_id__c}, new List<String>{'COMMERCIAL_PACKAGE', 'FORFAIT'});

        final List<profitability_analysis_condition__c> lst2Delete = new List<profitability_analysis_condition__c>();
        String pkgCodeId;
        for (profitability_analysis_condition__c pac : lstPAC) {
            final String sourceClientPkg = pac.gf_pa_source_cust_package_id__c;
            final String accIdentifier = sourceClientPkg.substring(0, sourceClientPkg.length() - 5);
            if (accIdentifier == lstWrp[0].participantCode) {
                lst2Delete.add(pac);
                pkgCodeId = pac.gf_pa_source_cust_package_id__c.substring(sourceClientPkg.length() - 5, sourceClientPkg.length());
            }
        }

        if (!lst2Delete.isEmpty()) {
            final Utils.DML_Wrapper retDMLDeletePAC = PAPackage_Service.deleteExtendedPkg(lstPAC);
            if (retDMLDeletePAC.isSuccess) {
                // Step 1.2 Check if is any Prof Analysis Pkg Req related with context pAnalysis with request type = 'Extension'
                final Map<String, Object> retMapPkgReqExt = handlePkgReqRelatedWithExtPkg(currentPAP, pkgCodeId);
                if (!(Boolean) retMapPkgReqExt.get('isSuccess')) {
                    retMap.put('isSuccess', false);
                    retMap.put('errMessage', retMapPkgReqExt.get('errMessage'));
                }
            } else {
                retMap.put('isSuccess', false);
                retMap.put('errMessage', retDMLDeletePAC.lstErrMessage);
            }
        }
        return retMap;
    }

    /**
    * @description Helper method due to cyclomatic complexity. This method delete the related Pkg Req with certain filters if exist, if not create a new one.
    * @param currentPAP : Current PAP which gonna be remove
    * @param pkgCodeId : Id of pkg code to filter search
    * @return Map<String, Object>, with the response of the dml operations
    */
    public static Map<String, Object> handlePkgReqRelatedWithExtPkg(profitability_analysis_participant__c currentPAP, String pkgCodeId) {
        final Map<String, Object> retMap = new Map<String, Object>();
        final PAPackageRequest_Selector pkgReqSelector = new PAPackageRequest_Selector(true);
        final List<profitability_analysis_pkg_request__c>  lstPAPR = pkgReqSelector.selectPkgReqByAccAndReqType(new Set<Id>{currentPAP.Id}, new List<String>{'Extension'});

        // If exist and extension req type = 'Add', delete record, if not exist create a new one with request type Extension
        Boolean hasReqToExtPkg = false;
        if (!lstPAPR.isEmpty() && lstPAPR[0].gf_pa_pkg_ext_req_st_type_name__c == 'Add') {
            hasReqToExtPkg = true;
        }

        if (hasReqToExtPkg) {
            final Utils.DML_Wrapper retDMLDeletePAPR = PAPackage_Service.deletePAPR(new List<profitability_analysis_pkg_request__c>{lstPAPR[0]});
            retMap.put('isSuccess', retDMLDeletePAPR.isSuccess);
            retMap.put('errMessage', retDMLDeletePAPR.lstErrMessage);
        } else {
            // Obtain the related client_package record related with the previous extension pkg. It ll be match 1 to 1.
            final ClientPackage_Selector cpSelector = new ClientPackage_Selector(true);
            List<client_package__c> lstCP = new List<client_package__c>();
            lstCP = cpSelector.selectPkgByStatusAndPkgIdAndPkgType(new List<String>{'Valid'}, new Set<String>{pkgCodeId}, new Set<Id>{currentPAP.participant_id__c});
            if (lstCP.isEmpty()) {
                lstCP = cpSelector.selectPkgByStatusAndPkgIdAndPkgType(new List<String>{'Cancelled'}, new Set<String>{pkgCodeId}, new Set<Id>{currentPAP.participant_id__c});
            }
            final List<profitability_analysis_pkg_request__c> lstPAPR2Insert = new List<profitability_analysis_pkg_request__c>();
            final profitability_analysis_pkg_request__c newPAPR = new profitability_analysis_pkg_request__c(
                gf_profitablity_analysis_id__c = currentPAP.gf_profitablity_analysis_id__c,
                gf_cust_package_id__c = lstCP[0].Id,
                gf_pa_pkg_request_type_name__c = 'Extension',
                gf_psc_package_id__c = lstCP[0].gf_psc_package_code_id__r.Id,
                gf_pa_pkg_ext_req_st_type_name__c = 'Remove',
                gf_pa_pkg_req_comments_desc__c = Label.remove_pkg_remove_ext_comm
            );
            lstPAPR2Insert.add(newPAPR);
            final Utils.DML_Wrapper retDMLInsertPAPR = PAPackage_Service.insertPAPR(lstPAPR2Insert);
            retMap.put('isSuccess', retDMLInsertPAPR.isSuccess);
            retMap.put('errMessage', retDMLInsertPAPR.lstErrMessage);
        }
        return retMap;
    }

    /**
    * @description Method that in function of the modal selection, do some dml operations
    * @param firstStageSelection : Selection of the first modal stage by the user
    * @param currentPAP : Current PAP which gonna be remove
    * @param lstClientPkg : List of client_package records related to this PAP
    * @return Map<String, Object>, with the response of the dml operations
    */
    public static Map<String, Object> doActionsWithRelatedPkg(String firstStageSelection, profitability_analysis_participant__c currentPAP, List<client_package__c> lstClientPkg) {
        final Map<String, Object> retMap = new Map<String, Object>();
        retMap.put('isSuccess', true); // To avoid excesive cognitive complexity, it would be true or overwrite if false
        Boolean hasError = false;

        // Delete all Pkg Req related to the client_package of this PAP with type 'New' or 'Extension' or 'Modification'
        final PAPackageRequest_Selector pkgReqSelector = new PAPackageRequest_Selector(true);
        final List<profitability_analysis_pkg_request__c>  lstPAPR = pkgReqSelector.selectPkgReqByAccAndReqType(new Set<Id>{currentPAP.Id}, new List<String>{'New','Extension','Modification','Cancellation'});

        // Check if is extension, if add type only delete. If remove type, dont delete it
        List<profitability_analysis_pkg_request__c>  lstPAPR2Delete = filterRecordsInPAPRList(lstPAPR);

        if (!lstPAPR2Delete.isEmpty()) {
            final Utils.DML_Wrapper retDMLDeletePAPR = PAPackage_Service.deletePAPR(lstPAPR2Delete);
            retMap.put('isSuccess', retDMLDeletePAPR.isSuccess);
            retMap.put('errMessage', retDMLDeletePAPR.lstErrMessage);
            if (!retDMLDeletePAPR.isSuccess) {
                hasError = true;
            }
        }

        // If the selection is delete permanently, make a new Pkg Req of Cancellation type for this client_package
        if (!hasError && firstStageSelection == 'permanently') {
            final List<profitability_analysis_pkg_request__c> lstNewPAPR = new List<profitability_analysis_pkg_request__c>();
            for (client_package__c cp : lstClientPkg) {
                final profitability_analysis_pkg_request__c newPAPR = new profitability_analysis_pkg_request__c(
                    gf_pa_pkg_request_type_name__c = 'Cancellation',
                    gf_cust_package_id__c = cp.Id,
                    gf_psc_package_id__c = cp.gf_psc_package_code_id__r.Id,
                    gf_profitablity_analysis_id__c = currentPAP.gf_profitablity_analysis_id__c
                );
                lstNewPAPR.add(newPAPR);
            }
            if (!lstNewPAPR.isEmpty()) {
                final Utils.DML_Wrapper retDMLInsertPAPR = PAPackage_Service.insertPAPR(lstNewPAPR);
                retMap.put('isSuccess', retDMLInsertPAPR.isSuccess);
                retMap.put('errMessage', retDMLInsertPAPR.lstErrMessage);
            }
        }

        return retMap;
    }

    /**
    * @description Method to filter and dont return Extension with Remove type of papr
    * @param originalLstPAPR : List of current PAPR of the analysis
    * @return List<profitability_analysis_pkg_request__c>, with the records to delete
    */
    private static List<profitability_analysis_pkg_request__c> filterRecordsInPAPRList(List<profitability_analysis_pkg_request__c> originalLstPAPR) {
        final List<profitability_analysis_pkg_request__c> lstPAPR2Delete = new List<profitability_analysis_pkg_request__c>();
        for (profitability_analysis_pkg_request__c papr : originalLstPAPR) {
            if (papr.gf_pa_pkg_request_type_name__c != 'Extension' || (papr.gf_pa_pkg_request_type_name__c == 'Extension' && papr.gf_pa_pkg_ext_req_st_type_name__c != 'Remove')) {
                lstPAPR2Delete.add(papr);
            }
        }
        return lstPAPR2Delete;
    }

    /**
    * @description Method where if there is only one more participant on the analysis, do some checks
    * @param lstPAP : List of current PAP of the analysis
    * @param currentPAP : PAP which gonna be remove
    * @return Map<String, Object>, with the response of the dml operations
    */
    public static Map<String, Object> handleLastPAPInAnalysis(List<profitability_analysis_participant__c> lstPAP, profitability_analysis_participant__c currentPAP) {
        final Map<String, Object> retMap = new Map<String, Object>();
        // If in the analysis there are now only two PAP (The one to be deleted and other one), there ll be necessary to do some checks in that which stays.
        if (lstPAP.size() == 2) {
            Id lstPAPAccId;
            profitability_analysis_participant__c lastPAP;
            for (profitability_analysis_participant__c pap : lstPAP) {
                if (pap.Id != currentPAP.Id) {
                    lstPAPAccId = pap.participant_id__c;
                    lastPAP = pap;
                }
            }

            // For the last PAP on a prof analysis, check if is the main participant of an extended pkg. If is, need delete.
            final Map<String, Object> retMapExtPkg = retrieveExtendedPkgOfAnAcc(currentPAP.gf_profitablity_analysis_id__c, lstPAPAccId);
            if ((Boolean) retMapExtPkg.get('hasExtPkg')) {
                final String conditionIdentifier = (String) retMapExtPkg.get('conditionIdentifier');
                final ProfitabilityAnalysisCondition_Selector pacSelector = new ProfitabilityAnalysisCondition_Selector();
                final List<profitability_analysis_condition__c> lstPAC = pacSelector.selectByProfitabilityAnalysisIdAndSourceClientPkg(new Set<String>{conditionIdentifier});

                // Call helper method to delete extended pkg and create new pkg req, if needed
                final Map<String, Object> retMapLastPAP = manageLastPAP(lstPAC, lastPAP);
                retMap.put('isSuccess', retMapLastPAP.get('isSuccess'));
                retMap.put('errMessage', retMapLastPAP.get('errMessage'));
            } else {
                retMap.put('isSuccess', true);
            }
        } else {
            retMap.put('isSuccess', true);
        }

        return retMap;
    }

    /**
    * @description Helper method which manage Method where if there is only one more participant on the analysis, do some checks
    * @param lstPAC : List of profitability analysis conditions to delete
    * @param lastPAP : Current record of last profitability analysis participant on the profitability analysis
    * @return Map<String, Object>, with the response of the dml operations
    */
    public static Map<String, Object> manageLastPAP(List<profitability_analysis_condition__c> lstPAC, profitability_analysis_participant__c lastPAP) {
        final Map<String, Object> retMap = new Map<String, Object>();
        final Utils.DML_Wrapper retDMLDeleteExtPkg = PAPackage_Service.deleteExtendedPkg(lstPAC);
        String pkgCodeId = lstPAC[0].gf_pa_source_cust_package_id__c.substring(lstPAC[0].gf_pa_source_cust_package_id__c.length() - 5, lstPAC[0].gf_pa_source_cust_package_id__c.length());
        if (retDMLDeleteExtPkg.isSuccess) {
            final Map<String, Object> extPkg = handlePkgReqRelatedWithExtPkg(lastPAP, pkgCodeId);
            retMap.putAll(extPkg);
        } else {
            retMap.put('isSuccess', false);
            retMap.put('errMessage', retDMLDeleteExtPkg.lstErrMessage);
        }
        return retMap;
    }
}