/**
* ────────────────────────────────────────────────────────────────────
* Participants_Service
* Service class for Participants_Ctrl apex class
* ────────────────────────────────────────────────────────────────────
* @author      Diego Arias <diego.arias.fernandez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-02-11
* @modified
* @systemLayer Business Logic
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
public class Participants_Service {

    /**
    * @description Private constructor to avoid sonar err
    */
    @TestVisible
    private Participants_Service() {}

    /**
    * @description Returns the info to show on the table
    * @param profRecordId : Current record Id
    * @param sObjectName : String with the api SObject Name of the context record
    * @return Map<String, Object>, with the config info and info to build front
    */
    public static Map<String, Object> obtainParticipantsInfo(Id profRecordId, String sObjectName) {
        Map<String, Object> retMap = new Map<String, Object>();

        // Obtain the current active version of general config mtd
        final pa_general_configuration__mdt genConfig = Utils.getGeneralConfiguration();

        // Obtain the current accountId of the context sObject
        final Id accountId = Participants_Helper.getRelatedAccountId(profRecordId, sObjectName);
        if (accountId == null) {
            retMap.put('showInfo', true);
            retMap.put('lstEmpty', true);
            if (sObjectName == 'cuco__profitability_sheet__c') {
                retMap.put('errMessage', Label.no_group_ps);
            } else if (sObjectName == 'cuco__profitability_analysis__c') {
                retMap.put('errMessage', Label.no_group_pa);
            }
        } else {
            // Obtain the participant hierarchy related to the account Id
            final ParticipantHierarchy_Wrapper partHierWrapp = Participants_Helper.getParticipantHierarchy(genConfig, accountId);

            // Build the response to the lightning component
            retMap = Participants_Helper.buildInitResponse(profRecordId, partHierWrapp, sObjectName, genConfig);
        }
        return retMap;
    }

    /**
    * @description Returns the info to display on the table
    * @param recordId : Current prof analysis record Id
    * @return Map<String, Object>, with the config info and info to build front
    */
    public static Map<String, Object> retrieveParticipantsAddData(Id profAnalysisId) {
        Map<String, Object> retMap = new Map<String, Object>();

        // Obtain the current active version of general config mtd
        final pa_general_configuration__mdt genConfig = Utils.getGeneralConfiguration();

        // Obtain the info of the context prof analysis Id record
        final ProfitabilityAnalysis_Selector paSelector = new ProfitabilityAnalysis_Selector(true);
        final List<profitability_analysis__c> lstPA = paSelector.selectById(new Set<Id>{profAnalysisId});

        // Obtain the participant hierarchy related to the account Id
        final ParticipantHierarchy_Wrapper partHierWrapp = Participants_Helper.getParticipantHierarchy(genConfig, lstPA[0].participant_id__c);

        // Build the response to the lightning component
        retMap = Participants_Helper.buildParticipantsAddResponse(lstPA[0], partHierWrapp, genConfig);

        return retMap;
    }

    /**
    * @description Check add permissions, create new prof. ana. participants and remove cancellation pkg request related
    * @param profAnalysisId: Context prof analysis record Id
    * @param lstAccId : List of accs ids ready to include as participants at the related prof analysis
    * @return Map<String, Object>, fill with info in function of logic
    */
    public static Map<String, Object> manageAddNewParticipants(Id profAnalysisId, List<Id> lstAccsId) {
        Map<String, Object> retMap = new Map<String, Object>();

        // Obtain the current active version of general config mtd
        final pa_general_configuration__mdt genConfig = Utils.getGeneralConfiguration();

        // Check if the context user can add particiapnts (Has add permissions)
        final Map<String, Object> addMap = Permissions_Helper.checkAddPermissions(genConfig, profAnalysisId);
        if ((Boolean) addMap.get('add')) {
            // If ve add permissions, check if param list is filled
            if (lstAccsId.isEmpty()) {
                retMap.put('showEmptyErr', true);
                retMap.put('errMessage', Label.madatory_subsidiary_selection);
            } else {
                //  try to create and insert the new prof analysis participants
                retMap = Participants_Helper.createNewProfAnParcicipants(profAnalysisId, lstAccsId);
            }
        } else {
          // If cannot ve add permissions, returns the error message
          retMap.put('showToast', true);
          retMap.put('toastType', 'warning');
          retMap.put('errMessage', addMap.get('addMessage'));
        }

        return retMap;
    }

    /**
    * @description Check previous info needed to show info on delete PAP modal
    * @param papId: Prof analysis participant record id from which the modal was invoked
    * @return Map<String, Object>, fill with info in function of logic
    */
    public static Map<String, Object> doPreviousChecksDeletePAP(Id papId) {
        Map<String, Object> retMap = new Map<String, Object>();

        // Get info of current profitability analysis participant
        final PAParticipant_Selector papSelector = new PAParticipant_Selector(true);
        final List<profitability_analysis_participant__c> lstPAP = papSelector.selectById(new Set<Id>{papId});

        retMap.put('papName', lstPAP[0].participant_id__r.Name);
        retMap.put('profAnalysisId', lstPAP[0].gf_profitablity_analysis_id__c);

        // Check if the current profitability analysis participant have a GIP/Forfait pkg in Valid status
        final ClientPackage_Selector clientPkgSelector = new ClientPackage_Selector(true);
        final List<client_package__c> lstClientPkg = clientPkgSelector.selectPkgByAccIdAndStatusAndPkgType(new Set<Id>{lstPAP[0].participant_id__c}, new List<String>{'Valid'},  new List<String>{'G','F'});

        if (lstClientPkg.isEmpty()) {
            retMap.put('stage', 2);
        } else {
            retMap.put('stage', 1);
        }

        // Check if the current profitability analysis participant have a new or modification pkg request type
        final PAPackageRequest_Selector pkgReqSelector = new PAPackageRequest_Selector();
        final List<profitability_analysis_pkg_request__c>  lstPAPR = pkgReqSelector.selectPkgReqByAccAndReqType(new Set<Id>{papId}, new List<String>{'New', 'Modification'});

        if (lstPAPR.isEmpty()) {
            retMap.put('hasReqPkg', false);
        } else {
            retMap.put('hasReqPkg', true);
        }

        // Check if the current profitability analysis has an extended package
        final Map<String, Object> mapExtPkg = Participants_Helper.retrieveExtendedPkgOfAnAcc(lstPAP[0].gf_profitablity_analysis_id__c, lstPAP[0].participant_id__c);
        retMap.putAll(mapExtPkg);
        retMap.remove('conditionIdentifier'); // Only need on the remove part

        return retMap;
    }

    /**
    * @description Check if have remove permissions on that profAnalysis and call next method to do rest of logic
    * @param papId: Prof analysis participant record id from which the modal was invoked
    * @param firstSelection: Selection of the first stage of the remove PAP modal
    * @return Map<String, Object>, fill with info in function of logic
    */
    public static Map<String, Object> doRemoveActions(Id papId, String firstSelection) {
        Map<String, Object> retMap = new Map<String, Object>();

        // Obtain info of the related Profitability analysis participant
        final PAParticipant_Selector papSelector = new PAParticipant_Selector(true);
        final List<profitability_analysis_participant__c> lstPAP = papSelector.selectById(new Set<Id>{papId});

        // Obtain the current active version of general config mtd
        final pa_general_configuration__mdt genConfig = Utils.getGeneralConfiguration();

        // Check if the context user can add particiapnts (Has remove permissions)
        final Map<String, Object> removeMap = Permissions_Helper.checkRemovePermissions(genConfig, lstPAP[0].gf_profitablity_analysis_id__c, lstPAP[0].participant_id__c);
        if ((Boolean) removeMap.get('remove')) {
            retMap = doRemovePAPActions(lstPAP[0], genConfig, firstSelection); // If have permissions, do the rest of the business logic
        } else {
          // If cannot ve remove permissions, returns the error message
          retMap.put('showToast', true);
          retMap.put('toastType', 'warning');
          retMap.put('errMessage', removeMap.get('removeMessage'));
        }

        return retMap;
    }

    /**
    * @description Method that do all business logic related to remove a Profitability Analysis Participant from a Profitability Analysis
    * @param currentPAP: Prof analysis participant record to delete
    * @param genConfig : Metadata record with the general configuration of classes
    * @param firstSelection: Selection of the first stage of the remove PAP modal
    * @return Map<String, Object>, fill with info in function of logic
    */
    public static Map<String, Object> doRemovePAPActions(profitability_analysis_participant__c currentPAP, pa_general_configuration__mdt genConfig, String firstSelection) {
        Map<String, Object> retMap = new Map<String, Object>();

        // Error variables
        Boolean hasError = false;
        List<String> lstErr = new List<String>();

        // Set savepoint for rollback purposes if needed
        final Savepoint deleteSavePoint = Database.setSavepoint();

        // Step 1. Check if the participant has an extended package. If it has, delete related records.
        final Map<String, Object> mapExtPkg = Participants_Helper.handleDesextendPkg(currentPAP, genConfig);
        if (!(Boolean) mapExtPkg.get('isSuccess')) {
            hasError = true;
            lstErr.addAll((List<String>) mapExtPkg.get('errMessage'));
        }

        // Step 2. Check if the participant has any packakge, in function of the first stage selection, delete certain records
        final ClientPackage_Selector clientPkgSelector = new ClientPackage_Selector(true);
        final List<client_package__c> lstClientPkg = clientPkgSelector.selectPkgByAccIdAndStatusAndPkgType(new Set<Id>{currentPAP.participant_id__c}, new List<String>{'Valid'},  new List<String>{'G','F'});
        final Map<String, Object> retMapRelatedPkg = Participants_Helper.doActionsWithRelatedPkg(firstSelection, currentPAP, lstClientPkg);
        if (!(Boolean) retMapRelatedPkg.get('isSuccess')) {
            hasError = true;
            lstErr.addAll((List<String>) retMapRelatedPkg.get('errMessage'));
        }



        // Step 3. Check if after remove this participant, if there was only one more participant at the profitability analysis, check if it be the main acc of an extended package, delete this extension.
        final PAParticipant_Selector papSelector = new PAParticipant_Selector(true);
        final List<profitability_analysis_participant__c> lstPAP = papSelector.selectByProfAnalysis(new Set<Id>{currentPAP.gf_profitablity_analysis_id__c});
        Map<String, Object> retMapLastPAP = Participants_Helper.handleLastPAPInAnalysis(lstPAP, currentPAP);
        if (!(Boolean) retMapLastPAP.get('isSuccess')) {
            hasError = true;
            lstErr.addAll((List<String>) retMapLastPAP.get('errMessage'));
        }


        // Step 4. Delete this participant from the profitability analysis.
        Utils.DML_Wrapper retDMLDeletePAP = PAPackage_Service.deletePAP(new List<profitability_analysis_participant__c>{new profitability_analysis_participant__c(Id = currentPAP.Id)});
        if (!retDMLDeletePAP.isSuccess) {
            hasError = true;
            lstErr.addAll(retDMLDeletePAP.lstErrMessage);
        }

        if (hasError) {
            Database.rollback(deleteSavePoint);
            retMap.put('showToast', true);
            retMap.put('toastType', 'error');
            retMap.put('errMessage', Label.remove_participant_error + ' ' + lstErr.toString());
        }

        return retMap;
    }
}