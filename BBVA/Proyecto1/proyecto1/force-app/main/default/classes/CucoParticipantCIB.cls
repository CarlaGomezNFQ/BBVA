/**
* ────────────────────────────────────────────────────────────────────
* Cuco Participants CIB
* Implementation of the Participant_itf interface methods for CIB
* ────────────────────────────────────────────────────────────────────
* @author      Torcuato tejada <torcuato.tejada.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-06-09
* @modified
* @systemLayer BusinessLogic
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@SuppressWarnings('PMD.AvoidGlobalModifier, sf:DMLWithoutSharingEnabled')
global with sharing class CucoParticipantCIB implements cuco.Participant_itf {

    /**
    * @description Returns a List of wrapper with the related info of each account id passed as a parameter in a Set
    * @param accountsIdsSet : Set of the related accounts Ids
    * @return List<cuco.Participants_Wrapper>
    */
    public List<cuco.Participant_Wrapper> getParticipantDetails(Set<Id> accountsIdsSet) {
        final List<cuco.Participant_Wrapper> participants = new List<cuco.Participant_Wrapper>();
        if (!accountsIdsSet.isEmpty()) {
            final List<Account> accounts = [SELECT Id, Name, AccountNumber, SER_CClient__c, DES_ID_Fiscal__c, toLabel(Rating) FROM Account WHERE Id IN :accountsIdsSet];
            if (!accounts.isEmpty()) {
                for (Account account : accounts) {
                    final cuco.Participant_Wrapper participant = new cuco.Participant_Wrapper();
                    participant.participantId = account.Id;
                    participant.participantName = account.Name;
                    participant.documentNumber = account.DES_ID_Fiscal__c;
                    participant.documentType = 'CIF';
                    participant.documentTypeCode = '2';
                    participant.participantCode = account.SER_CClient__c;
                    participant.participantIntegrationId = 'ES0182' + account.SER_CClient__c + 'C';
                    participant.rating = account.Rating;
                    participants.add(participant);
                }
            }
        }
        return participants;
    }

    /**
    * @description Get the participant hierarchy related to param accountId
    * @param accId : Id of the account
    * @return cuco.ParticipantHierarchy_Wrapper with the participant hierarchy info
    */
    public cuco.ParticipantHierarchy_Wrapper getParticipantHierarchy(Id accountId) {

        cuco.ParticipantHierarchy_Wrapper participantHierarchy = new cuco.ParticipantHierarchy_Wrapper();

        final Account client = [SELECT Id, Name, DES_Main_Parent__c, DES_Main_Parent__r.Name, DES_Structure_Type__c, parentId, Parent.Name, SER_CClient__c, DES_ID_Fiscal__c, DES_Main_Parent__r.DES_Group_Code__c, AccountNumber FROM Account WHERE Id = :accountId];

        final Set<Id> children = new Set<Id>();
        final List<String> groupNames = new List<String>{'Supragroup', 'Group', 'Subgroup', 'Shared Management Group'};
        participantHierarchy.name = client.Name;

        if (groupNames.contains(client.DES_Structure_Type__c)) {
            participantHierarchy.type = 'group';
            participantHierarchy.parentId = client.DES_Main_Parent__c;
            participantHierarchy.parentName = client.DES_Main_Parent__r.Name;
            participantHierarchy.integrationId = client.DES_Main_Parent__r.DES_Group_Code__c;

            final List<Account> accounts = [SELECT Id, SER_CClient__c, Name FROM Account WHERE DES_Structure_Type__c NOT IN ('Supragroup', 'Group', 'Subgroup', 'Shared Management Group') AND DES_Main_Parent__c = :client.Id];
            for (Account acc : accounts) {
                children.add(acc.Id);
            }

        } else {

            if (client.DES_Main_Parent__c == null) {
                participantHierarchy.type = 'orphan';
                participantHierarchy.parentId = accountId;
                participantHierarchy.parentName = client.Name;
                participantHierarchy.integrationId = 'ES0182' + client.SER_CClient__c + 'C';
            } else {
                participantHierarchy.type ='subsidiary';
                participantHierarchy.parentId = client.DES_Main_Parent__c;
                participantHierarchy.parentName = client.DES_Main_Parent__r.Name;
                participantHierarchy.integrationId = client.DES_Main_Parent__r.DES_Group_Code__c;
            }
            children.add(accountId);
        }

        participantHierarchy.childIdsSet = children;
        return participantHierarchy;
    }

    /**
    * @description Returns a List of wrapper with the related info of each account id passed as a parameter in a Set
    * @param accountsIdsSet : Set of the related accounts Ids
    * @param userId: Context user id
    * @return List<cuco.Participants_Wrapper> fill with each participant info
    */
    public List<cuco.Participant_Wrapper> getParticipantsToSelect(Set<Id> accountsIdsSet, Id userId) {
      final List<cuco.Participant_Wrapper> participants = new List<cuco.Participant_Wrapper>();

        if (!accountsIdsSet.isEmpty()) {
          final List<Account> accounts = [SELECT Id, Name, AccountNumber, SER_CClient__c, DES_ID_Fiscal__c, Rating FROM Account WHERE Id IN :accountsIdsSet];
          if (!accounts.isEmpty()) {
                for (Account account : accounts) {
                    final cuco.Participant_Wrapper participant = new cuco.Participant_Wrapper();
                    participant.participantId = account.Id;
                    participant.participantName = account.Name;
                    participant.documentNumber = account.DES_ID_Fiscal__c;
                    participant.documentType = 'CIF';
                    participant.documentTypeCode = '2';
                    participant.participantCode = account.SER_CClient__c;
                    participant.participantIntegrationId = 'ES0182' + account.SER_CClient__c + 'C';
                    participant.isCustomer = true;
                    participant.rating = account.Rating;
                    participants.add(participant);
                }
            }
        }
        return participants;
    }

    /**
    * @description Returns a List of wrapper with the related info of each account id passed as a parameter in a Set
    * @param accountsIdsSet : Set of the related accounts Ids
    * @param userId: Context user id
    * @return Map<String,Id> fill with each participant info
    */
    public static Map<String,Id> getParticipantsIds(Set<String> partIntegrationIds) {
        final Map<String,Id> mapAcc = new Map<String,Id>();
        final Set<String> parInteIdsSplit = new Set<String>();
        if (!partIntegrationIds.isEmpty()) {
            for (String inte: partIntegrationIds) {
                parInteIdsSplit.add(inte.substring(6,15));
            }
            if (!parInteIdsSplit.isEmpty()) {
                final List<Account> lstAcc = [SELECT Id, SER_CClient__c, AccountNumber FROM Account WHERE SER_CClient__c IN :parInteIdsSplit];
                for (Account account: lstAcc) {
                    mapAcc.put(account.SER_CClient__c, account.Id);
                }
            }
        }
        return mapAcc;
    }

    /**
    * @description Returns descendants recursively
    * @param accountsIdsSet : Set of the related accounts Ids
    * @return Set<Id> descendantIds
    */
    public static Set<Id> getDescendants(Set<Id> accountsIdsSet) {

        final Set<Id> res = new Set<Id>();
        final List<dwp_acmh__GBL_Account_Relationship__c> relationships = [SELECT Id, dwp_acmh__Child_Account__c, dwp_acmh__Child_Account__r.Name, dwp_acmh__Child_Account__r.Is_Group__c FROM dwp_acmh__GBL_Account_Relationship__c WHERE dwp_acmh__Parent_Account__c IN :accountsIdsSet AND dwp_acmh__Vision__c = 'Negocio'];

        for (dwp_acmh__GBL_Account_Relationship__c relationship : relationships) {

            if(relationship.dwp_acmh__Child_Account__r.Is_Group__c) {
                final Set<Id> descendants = getDescendants(new Set<Id>{relationship.dwp_acmh__Child_Account__c});
                for (Id descendant : descendants) {
                    res.add(descendant);
                }
            } else {
                res.add(relationship.dwp_acmh__Child_Account__c);
            }
        }
        return res;
    }
}