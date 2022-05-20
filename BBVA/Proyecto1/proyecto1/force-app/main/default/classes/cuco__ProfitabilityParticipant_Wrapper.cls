/**
* ────────────────────────────────────────────────────────────────────
* ProfitabilityParticipant_Wrapper
* Contains the profitability participant details
* ────────────────────────────────────────────────────────────────────
* @author      Diego Arias <diego.arias.fernandez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-03-08
* @modified
* @systemLayer Domain
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@SuppressWarnings('PMD.AvoidGlobalModifier')
global class ProfitabilityParticipant_Wrapper {

    /**
    * @Description: Id with profitability analysis participant id
    */
    @AuraEnabled
    global Id profAnalysisParticipantId {get; set;}

    /**
    * @Description: Participant_Wrapper with participant account id details
    */
    @AuraEnabled
    global Participant_Wrapper partWrapper {get; set;}
}