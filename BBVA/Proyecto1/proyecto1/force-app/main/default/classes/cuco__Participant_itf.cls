/**
* ────────────────────────────────────────────────────────────────────
* Participant Interface
* Interface that will contains methods to determinte the account
* information
* ────────────────────────────────────────────────────────────────────
* @author      Diego Arias <diego.arias.fernandez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-02-09
* @modified
* @systemLayer Domain
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
global interface Participant_itf {

    /**
    * @description Returns a List of wrapper with the related info of each account id passed as a parameter in a Set
    * @param accountsIdsSet : Set of the related accounts Ids
    * @return List<Participants_Wrapper> fill with each participant info
    */
    List<Participant_Wrapper> getParticipantDetails(Set<Id> accountsIdsSet);

    /**
    * @description Get the participant hierarchy related to param accountId
    * @param accId : Id of the account
    * @return ParticipantHierarchy_Wrapper with the participant hierarchy info
    */
    ParticipantHierarchy_Wrapper getParticipantHierarchy(Id accId);

    /**
    * @description Returns a List of wrapper with the related info of each account id passed as a parameter in a Set
    * @param accountsIdsSet : Set of the related accounts Ids
    * @param userId: Context user id
    * @return List<Participants_Wrapper> fill with each participant info
    */
    List<Participant_Wrapper> getParticipantsToSelect(Set<Id> accountsIdsSet, Id userId);

    /**
    * @description Returns a Map with participant info
    * @param partIntegrationIds Set of the related accounts Ids
    * @return Map<String,Id> fill with each participant info
    */
    Map<String,Id> getParticipantsIds(Set<String> partIntegrationIds);
}