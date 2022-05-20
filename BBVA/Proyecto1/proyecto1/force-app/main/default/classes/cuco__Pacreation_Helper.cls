/**
* ───────────────────────────────────────────────────────────────────────────────────
* Pacreation_Helper
* Service class for Pacreation_Ctrl apex class
* ───────────────────────────────────────────────────────────────────────────────────
* @author      Giancarlo Mastrogiorgio <giancarlo.mastrogiorgio.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-03-08
* @modified
* @systemLayer Business Logic
* ───────────────────────────────────────────────────────────────────────────────────
* @changes
*
* ───────────────────────────────────────────────────────────────────────────────────
*/
public class Pacreation_Helper {
    /**
    * @description Private constructor to avoid sonar err
    */
    @TestVisible
    private Pacreation_Helper() {}
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
    public static List<Participant_Wrapper> getParticipantsToSelect(pa_general_configuration__mdt genConfig, Set<Id> accIdSet) {
      final Type permissionsClass = Type.forName(genConfig.participants_itf_name__c);
      final Participant_itf participantItf = (Participant_itf) permissionsClass.newInstance();
      return participantItf.getParticipantsToSelect(accIdSet, UserInfo.getUserId());
    }

    /**
    * @description Returns a object profitability_analysis__c with defaut values
    * @param genConfig : Metadata record with the general configuration of classes
    * @param profAnalysis : object profitability_analysis__c
    * @return object, with the ownerid of current particiant id
    */
    public static profitability_analysis__c getPSaDefault(pa_general_configuration__mdt genConfig, profitability_analysis__c profAnalysis ) {
        final Type permissionsClass = Type.forName(genConfig.cuco__prof_analysis_itf_name__c);
        final ProfitabilityAnalysis_Itf profitabiItf = (ProfitabilityAnalysis_Itf) permissionsClass.newInstance();
        return profitabiItf.setPADefaultCreationData(profAnalysis);
    }

    /**
    * @description Build the initial map to return to lightning component
    * @param participantid: Context prof analysis record Id
    * @param partHierWrapp: Wrapper with the related hierarchy of the related accountId context record
    * @param genConfig : Metadata record with the general configuration of classes
    * @return Map<String, Object>, fill with info in function of logic
    */
    public static Map<String, Object> buildParticipantsAddResponse(id participantid, ParticipantHierarchy_Wrapper partHierWrapp, pa_general_configuration__mdt genConfig) {
      Map<String, Object> retMap = new Map<String, Object>();

      final String participantType = partHierWrapp.type;
      switch on participantType {
          when 'group' {
              final Set<Id> setAcc = partHierWrapp.childIdsSet;
              retMap = retrieveAccsInTable(setAcc, genConfig,participantid);
              retMap.put('type',partHierWrapp.type);
              retMap.put('proSheetLabel', Label.ps_name);
              retMap.put('profAccName', partHierWrapp.Name);
          }
          when 'subsidiary' {
              final Set<Id> setAcc = partHierWrapp.childIdsSet;
              retMap = retrieveAccsInTable(setAcc, genConfig,participantid);
              retMap.put('type',partHierWrapp.type);
              retMap.put('proSheetLabel', Label.ps_name);
              retMap.put('profAccName', partHierWrapp.parentName);
          }
          when 'orphan' {
              retMap.put('proSheetLabel', Label.client);
              retMap.put('type',partHierWrapp.type);
              retMap.put('errMessage', Label.not_allow_add_participants);
              retMap.put('profAccName', partHierWrapp.Name);
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
    * @description Create the new prof. ana. participants related to profAnalysis
    * @param participantId: record Id
    * @param lstAccId : List of accs ids ready to include as participants at the related prof analysis
    * @return Map<String, Object>, fill with info in function of logic
    */
    public static Map<String, Object> createNewProfAnalisis(Id participantId, List<Id> lstAccsId, string pfAname, pa_general_configuration__mdt genConfig) {
        final Map<String, Object> retMap = new Map<String, Object>();

        final Savepoint savePoint = Database.setSavepoint();
        final list <profitability_analysis__c> lstPA = new list <profitability_analysis__c>();
        //Frist create the new prof analysis
        profitability_analysis__c paNew = new profitability_analysis__c();
        paNew.name = pfAname;
        paNew.participant_id__c = participantId;
        paNew.gf_pa_management_type_name__c ='New';
        paNew.segment_type__c = genConfig.segment_type__c;
        paNew.gf_pa_mgmt_stage_type_name__c ='Analysis';
        paNew.gf_pa_mgmt_status_type_name__c ='Analysis';

        profitability_analysis__c  padefault =  getPSaDefault(genConfig, paNew);

        lstPA.add(padefault);
        final Utils.DML_Wrapper retDMLInsertPA = ProfitabilityAnalysis_Service.insertPA(lstPA);
        retMap.put('isSuccess', retDMLInsertPA.isSuccess);
        retMap.put('errMessage', 'ok');
        retMap.put('newPfAnalisisid', padefault.Id);

        // Second create the new prof analysis participant
        final List<profitability_analysis_participant__c> lstPAP = new List<profitability_analysis_participant__c>();
        for (Id accId : lstAccsId) {
            lstPAP.add(new profitability_analysis_participant__c(participant_id__c = accId, gf_profitablity_analysis_id__c = padefault.Id));
        }

        final Utils.DML_Wrapper retDMLInsertPAP = PAPackage_Service.insertPAP(lstPAP);
        retMap.put('isSuccess', retDMLInsertPAP.isSuccess);
        retMap.put('errMessage', 'ok');

        if (!(Boolean) retMap.get('isSuccess')) {
            Database.rollback(savePoint);
        }
        return retMap;
    }
}