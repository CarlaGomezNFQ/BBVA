/**
* ────────────────────────────────────────────────────────────────────
* Participant Wrapper
* Contains the participant details
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
@SuppressWarnings('PMD.AvoidGlobalModifier')
global class Participant_Wrapper {

    /**
    * @Description: Id with participant Id
    */
    @AuraEnabled
    global Id participantId {get; set;}

    /**
    * @Description: String with participant name
    */
    @AuraEnabled
    global String participantName {get; set;}

    /**
    * @Description: String with document number
    */
    @AuraEnabled
    global String documentNumber {get; set;}

    /**
    * @Description: String with document type
    */
    @AuraEnabled
    global String documentType {get; set;}

    /**
    * @Description: String with document type code
    */
    @AuraEnabled
    global String documentTypeCode {get; set;}

    /**
    * @Description: String with participant code
    */
    @AuraEnabled
    global String participantCode {get; set;}

    /**
    * @Description: String with participant integration id
    */
    @AuraEnabled
    global String participantIntegrationId {get; set;}

    /**
    * @Description: Boolean with is customer question value
    */
    @AuraEnabled
    global Boolean isCustomer {get; set;}

    /**
    * @Description: String with rating
    */
    @AuraEnabled
    global String rating {get; set;}

}