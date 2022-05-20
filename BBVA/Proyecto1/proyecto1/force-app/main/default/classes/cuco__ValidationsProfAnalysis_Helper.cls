/**
* ────────────────────────────────────────────────────────────────────────────────────
* ValidationsProfAnalysis_Helper
* ValidationsProfAnalysis_Helper apex class
* ────────────────────────────────────────────────────────────────────────────────────
* @author      Giancarlo Mastrogiorgio <giancarlo.Mastrogiorigo.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-05-19
* @modified
* @systemLayer Presentation
* ────────────────────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────────────────────
*/
@SuppressWarnings('PMD.AvoidGlobalModifier')
global class ValidationsProfAnalysis_Helper {
    /**
    * @description Returns list string with error check Branch
    * @param pawrapper : Id of the context record
    * @return List<String>, with error labels
    */
    global static  List<String> checkBranch (ProfitabilityAnalysis_Wrapper pawrapper) {
        List<String> resp = new List<String>();
        if(pawrapper.branchCode == null || pawrapper.branchCode == '') {
            resp.add(Label.error_missing_branch);
        }
        return resp;
    }

    /**
    * @description Returns list string with error check Main Participant
    * @param pawrapper : Id of the context record
    * @return List<String>, with error labels
    */
    global static List<String> checkMainParticipant (ProfitabilityAnalysis_Wrapper pawrapper) {
        List<String> resp = new List<String>();
        if(pawrapper.mainParticipant == null || pawrapper.mainParticipant.accountid == null) {
            resp.add(Label.error_missing_main_participant);
        }
        return resp;
    }

    /**
    * @description Returns list string with error check Segment
    * @param pawrapper : Id of the context record
    * @return List<String>, with error labels
    */
    global static List<String> checkSegment(ProfitabilityAnalysis_Wrapper pawrapper, pa_general_configuration__mdt genConfig) {
        List<String> resp = new List<String>();
        if (pawrapper.segment == null || pawrapper.segment == '') {
            resp.add(Label.error_missing_segment);
        } else if (pawrapper.segment != genConfig.cuco__segment_type__c) {
            resp.add(Label.error_non_valid_segment);
        }
        return resp;
    }

    /**
    * @description Returns list string with error check Renewal Margin
    * @param pawrapper : Id of the context record
    * @return List<String>, with error labels
    */
    global static List<String> checkRenewalMargin(ProfitabilityAnalysis_Wrapper pawrapper, pa_general_configuration__mdt genConfig) {
        List<String> resp = new List<String>();
        if (pawrapper.originEndDate != null) {
            decimal maxdays = genConfig.cuco__renewals_form_max_due_term__c;
            date cdate = pawrapper.originEndDate.addDays(integer.valueof(maxdays));
            if ((pawrapper.typology == 'Renewal' || pawrapper.typology == 'Novation') && date.TODAY() > cdate) {
                resp.add(Label.error_renewal_margin);
            }
        }
        return resp;
    }

    /**
    * @description Returns list string with error check Backend LastDate
    * @param pawrapper : Id of the context record
    * @return List<String>, with error labels
    */
    global static List<String> checkBackendLastDate (ProfitabilityAnalysis_Wrapper pawrapper) {
        List<String> resp = new List<String>();
        if(pawrapper.lastAutoFormDate !=null && date.TODAY() ==  pawrapper.lastAutoFormDate ){
            resp.add(Label.error_backend_date);
        }
        return resp;
    }

    /**
    * @description Check if the participants hierarchy is valid
    * @param paWrapper : Prof analysis wrapper info
    * @param genConfig : Metadata record with the general configuration of classes
    * @return List<String>, with check errors
    */
    global static List<String> checkParticipant(ProfitabilityAnalysis_Wrapper paWrapper, pa_general_configuration__mdt genConfig) {
        final List<String> retList = new List<String>();
        final ParticipantHierarchy_Wrapper partHierWrapp = Participants_Helper.getParticipantHierarchy(genConfig, paWrapper.mainParticipant.accountid);
        final Integer numParticipants = (paWrapper.participantsList != null ? paWrapper.participantsList.size() : 0);
        switch on partHierWrapp.type {
            when 'group' {
                if (numParticipants == 0) {
                    retList.add(Label.error_group_participant_num);
                } else if (!allPartChildOfMain(paWrapper.participantsList, partHierWrapp.childIdsSet)) {
                    retList.add(Label.error_group_participants_childs);
                }
            } when 'orphan' {
                if (numParticipants > 1) {
                    retList.add(Label.error_orphan_participant_num);
                } else if (numParticipants == 1 && paWrapper.participantsList[0].accountid != paWrapper.mainParticipant.accountid) {
                    retList.add(Label.error_orphan_participant_match);
                }
            } when else {
                retList.add(Label.error_main_participant_type);
            }
        }
        return retList;
    }

    /**
    * @description return if all participants are children of main participant
    */
    private static Boolean allPartChildOfMain(List<ProfitabilityAnalysis_Wrapper.Participants> participantsList, Set<Id> childIdsSet) {
        Boolean allChildren = true;
        for (ProfitabilityAnalysis_Wrapper.Participants participant : participantsList) {
            if (!childIdsSet.contains(participant.accountid)) {
                allChildren = false;
                break;
            }
        }
        return allChildren;
    }
}