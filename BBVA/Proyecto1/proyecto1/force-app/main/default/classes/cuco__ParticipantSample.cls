/**
* ────────────────────────────────────────────────────────────────────
* Participant Sample
* Sample implementation of the multiple methods from Participant_itf
* ────────────────────────────────────────────────────────────────────
* @author      Diego Arias <diego.arias.fernandez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-02-09
* @modified
* @systemLayer Sample
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@SuppressWarnings('PMD.AvoidGlobalModifier, sf:DMLWithoutSharingEnabled')
global with sharing class ParticipantSample implements Participant_itf {

    /**
    * @description Returns a List of wrapper with the related info of each account id passed as a parameter in a Set
    * @param accountsIdsSet : Set of the related accounts Ids
    * @return List<Participants_Wrapper>
    */
    global List<Participant_Wrapper> getParticipantDetails(Set<Id> accountsIdsSet) {
        final List<Participant_Wrapper> lstPWrapp = new List<Participant_Wrapper>();
        if (!accountsIdsSet.isEmpty()) {
            // Following the usage of Separation of Concerns APEX Framework, all of SOQL queries must be on each selector class of each SObject
            // Due to need to use a SOQL query to a standard SObject, its implemented here. Please, use your local selector class to implement it.
            final List<Account> lstAcc = [SELECT Id, Name, AccountNumber, toLabel(Rating) FROM Account WHERE Id IN :accountsIdsSet ];
            if (!lstAcc.isEmpty()) {
                for (Account acc : lstAcc) {
                    final Participant_Wrapper pWrapp = new Participant_Wrapper();
                    pWrapp.participantId = acc.Id;
                    pWrapp.participantName = acc.Name;
                    pWrapp.documentNumber = acc.AccountNumber;
                    pWrapp.documentType = 'CIF';
                    pWrapp.documentTypeCode = '2';
                    pWrapp.participantCode = acc.AccountNumber;
                    pWrapp.participantIntegrationId = 'ES0182' + acc.AccountNumber + 'C';
                    pWrapp.rating = acc.Rating;
                    lstPWrapp.add(pWrapp);
                }
            }
        }
        return lstPWrapp;
    }

    /**
    * @description Get the participant hierarchy related to param accountId
    * @param accId : Id of the account
    * @return ParticipantHierarchy_Wrapper with the participant hierarchy info
    */
    global ParticipantHierarchy_Wrapper getParticipantHierarchy(Id accountId) {
        // Following the usage of Separation of Concerns APEX Framework, all of SOQL queries must be on each selector class of each SObject
        // Due to need to use a SOQL query to a standard SObject, its implemented here. Please, use your local selector class to implement it.
        final List<Account> lstAcc = [SELECT Id, Name, parentId, Parent.Name, AccountNumber FROM Account WHERE Id = :accountId];
        final List<Account> lstchilds = [SELECT Id, Name FROM Account WHERE parentId = :accountId];

        Set<Id> ids = new Set<Id>();
        ParticipantHierarchy_Wrapper participantHierarchy = new ParticipantHierarchy_Wrapper();
        if (lstAcc != null && !lstAcc.isEmpty()) {
            participantHierarchy.name = lstAcc[0].Name;
            participantHierarchy.parentId = lstAcc[0].parentId;
            participantHierarchy.parentName = lstAcc[0].Parent.Name;

            if(lstAcc[0].parentId == null && !lstchilds.isEmpty()) {
                participantHierarchy.type = 'group';
                for (Account acc : lstchilds) {
                    ids.add(acc.Id);
                }
            }
            if(lstAcc[0].parentId == null && lstchilds.isEmpty()) {
                participantHierarchy.type = 'orphan';
            }
            if(lstAcc[0].parentId != null) {
                participantHierarchy.type = 'subsidiary';
                final List<Account> lstallchilds = [SELECT Id FROM Account WHERE parentId = :lstAcc[0].parentId];
                for (Account acch : lstallchilds) {
                    ids.add(acch.Id);
                }
            }
            if (participantHierarchy.type != null && participantHierarchy.type != '' && participantHierarchy.type == 'group') {
                participantHierarchy.integrationId = 'ES0182' + lstAcc[0].AccountNumber + 'G';
            } else {
                participantHierarchy.integrationId = 'ES0182' + lstAcc[0].AccountNumber + 'C';
            }
            participantHierarchy.childIdsSet = ids;
        }
        return participantHierarchy;
    }

    /**
    * @description Returns a List of wrapper with the related info of each account id passed as a parameter in a Set
    * @param accountsIdsSet : Set of the related accounts Ids
    * @param userId: Context user id
    * @return List<Participants_Wrapper> fill with each participant info
    */
    global List<Participant_Wrapper> getParticipantsToSelect(Set<Id> accountsIdsSet, Id userId) {
      final List<Participant_Wrapper> lstPWrapp = new List<Participant_Wrapper>();
      if (!accountsIdsSet.isEmpty()) {
          // Following the usage of Separation of Concerns APEX Framework, all of SOQL queries must be on each selector class of each SObject
          // Due to need to use a SOQL query to a standard SObject, its implemented here. Please, use your local selector class to implement it.
          final List<Account> lstAcc = [SELECT Id, Name, AccountNumber, Rating FROM Account WHERE Id IN :accountsIdsSet AND OwnerId =: userId];
          if (!lstAcc.isEmpty()) {
              for (Account acc : lstAcc) {
                  final Participant_Wrapper pWrapp = new Participant_Wrapper();
                  pWrapp.participantId = acc.Id;
                  pWrapp.participantName = acc.Name;
                  pWrapp.documentNumber = acc.AccountNumber;
                  pWrapp.documentType = 'CIF';
                  pWrapp.documentTypeCode = '2';
                  pWrapp.participantCode = acc.AccountNumber;
                  pWrapp.participantIntegrationId = 'ES0182' + acc.AccountNumber + 'C';
                  pWrapp.isCustomer = true;
                  pWrapp.rating = acc.Rating;
                  lstPWrapp.add(pWrapp);
              }
          }
      }
      return lstPWrapp;
    }
    /**
    * @description Returns a List of wrapper with the related info of each account id passed as a parameter in a Set
    * @param accountsIdsSet : Set of the related accounts Ids
    * @param userId: Context user id
    * @return Map<String,Id> fill with each participant info
    */
    global static Map<String,Id> getParticipantsIds(Set<String> partIntegrationIds) {
      final Map<String,Id> mapAcc = new Map<String,Id>();
      final Set<String> parInteIdsSplit = new Set<String>();
      if (!partIntegrationIds.isEmpty()) {
          for (String inte: partIntegrationIds) {
              parInteIdsSplit.add(inte.substring(6,15));
          }
          if (!parInteIdsSplit.isEmpty()) {
              // Following the usage of Separation of Concerns APEX Framework, all of SOQL queries must be on each selector class of each SObject
              // Due to need to use a SOQL query to a standard SObject, its implemented here. Please, use your local selector class to implement it.
              final List<Account> lstAcc = [SELECT Id, AccountNumber FROM Account WHERE AccountNumber IN :parInteIdsSplit];
              for (Account acc: lstAcc) {
                  mapAcc.put(acc.AccountNumber, acc.Id);
              }
          }
      }
      return mapAcc;
    }
}