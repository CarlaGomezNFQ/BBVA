/**
* ────────────────────────────────────────────────────────────────────
* Package Wrapper
* Contains the package wrapper
* ────────────────────────────────────────────────────────────────────
* @author      Diego Arias <diego.arias.fernandez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-03-11
* @modified
* @systemLayer Domain
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@SuppressWarnings('PMD.AvoidGlobalModifier, PMD.TooManyFields')
global class Package_Wrapper {

    /**
    * @Description: String with package type
    */
    @AuraEnabled
    global String type {get; set;}

    /**
    * @Description: String with client package id
    */
    @AuraEnabled
    global String clientPackageId {get; set;}

    /**
    * @Description: String with catalog Id
    */
    @AuraEnabled
    global String catalogId {get; set;}

    /**
    * @Description: String with package code
    */
    @AuraEnabled
    global String code {get; set;}

    /**
    * @Description: String with package description
    */
    @AuraEnabled
    global String description {get; set;}

    /**
    * @Description: Scope object
    */
    @AuraEnabled
    global Scope scope {get; set;}

    /**
    * @Description: Wrapper for Scope object
    */
    global class Scope {

        /**
        * @Description: String with scope id
        */
        @AuraEnabled
        global String id {get; set;}

        /**
        * @Description: String with scope value
        */
        @AuraEnabled
        global String value {get; set;}

        /**
        * @Description: Constructor for Scope object
        */
        global Scope(String id, String value) {
            this.id = id;
            this.value = value;
        }
    }

    /**
    * @Description: String with operation type
    */
    @AuraEnabled
    global String operationType {get; set;}

    /**
    * @Description: String with operational limit
    */
    @AuraEnabled
    global String operationalLimit {get; set;}

    /**
    * @Description: String with start date
    */
    @AuraEnabled
    global Date startDate {get; set;}

    /**
    * @Description: String with end date
    */
    @AuraEnabled
    global Date endDate {get; set;}

    /**
    * @Description: Status object
    */
    @AuraEnabled
    global Status status {get; set;}

    /**
    * @Description: Wrapper for Status object
    */
    global class Status {

        /**
        * @Description: String with status id
        */
        @AuraEnabled
        global String id {get; set;}

        /**
        * @Description: String with status value
        */
        @AuraEnabled
        global String value {get; set;}

        /**
        * @Description: Constructor for Status object
        */
        global Status(String id, String value) {
            this.id = id;
            this.value = value;
        }
    }

    /**
    * @Description: String with charge account
    */
    @AuraEnabled
    global String chargeAccount {get; set;}

    /**
    * @Description: Decimal with charge amount
    */
    @AuraEnabled
    global Decimal chargeAmount {get; set;}

    /**
    * @Description: ChargePeriodicity object
    */
    @AuraEnabled
    global ChargePeriodicity chargePeriodicity {get; set;}

    /**
    * @Description: Wrapper for Charge Periodicity object
    */
    global class ChargePeriodicity {

        /**
        * @Description: String with charge periodicity id
        */
        @AuraEnabled
        global String id {get; set;}

        /**
        * @Description: String with charge periodicity value
        */
        @AuraEnabled
        global String value {get; set;}

        /**
        * @Description: First constructor for ChargePeriodicity object
        */
        global ChargePeriodicity(String id, String value) {
            this.id = id;
            this.value = value;
        }
    }

    /**
    * @Description: String with client rep name
    */
    @AuraEnabled
    global String clientRepName {get; set;}

    /**
    * @Description: String with client rep document number
    */
    @AuraEnabled
    global String clientRepDocNumber {get; set;}

    /**
    * @Description: String with bank rep name
    */
    @AuraEnabled
    global String bankRepName {get; set;}

    /**
    * @Description: String with bank rep document number
    */
    @AuraEnabled
    global String bankRepDocNumber {get; set;}

    /**
    * @Description: String with signing location
    */
    @AuraEnabled
    global String signingLocation {get; set;}

    /**
    * @Description: String with comments
    */
    @AuraEnabled
    global String comments {get; set;}

    /**
    * @Description: Participant object
    */
    @AuraEnabled
    global Participant participant {get; set;}

    /**
    * @Description: Wrapper for participant object
    */
    global class Participant {

        /**
        * @Description: String with id of the participant
        */
        @AuraEnabled
        global String id {get; set;}

        /**
        * @Description: String with account code of the participant
        */
        @AuraEnabled
        global String accountCode {get; set;}

        /**
        * @Description: String with account id of the participant
        */
        @AuraEnabled
        global String accountId {get; set;}

        /**
        * @Description: String with name of the participant
        */
        @AuraEnabled
        global String name {get; set;}

        /**
        * @Description: String with document number of the participant
        */
        @AuraEnabled
        global String documentNumber {get; set;}
    }

    /**
    * @Description: Boolean with extended package value
    */
    @AuraEnabled
    global Boolean isExtended {get; set;}

    /**
    * @Description: String with extension request id
    */
    @AuraEnabled
    global String extensionRequestId {get; set;}

    /**
    * @Description: String with edit request id
    */
    @AuraEnabled
    global String editRequestId {get; set;}

    /**
    * @Description: String with cancellation request id
    */
    @AuraEnabled
    global String cancellationRequestId {get; set;}

    /**
    * @Description: String with new request id
    */
    @AuraEnabled
    global String newRequestId {get; set;}

    /**
    * @Description: RequestStatus object
    */
    @AuraEnabled
    global RequestStatus requestStatus {get; set;}

    /**
    * @Description: Wrapper for Request object
    */
    global class RequestStatus {

        /**
        * @Description: String with request id
        */
        @AuraEnabled
        global String id {get; set;}

        /**
        * @Description: String with request value
        */
        @AuraEnabled
        global String value {get; set;}

        /**
        * @Description: First constructor for RequestStatus object
        */
        global RequestStatus(String id, String value) {
            this.id = id;
            this.value = value;
        }

        /**
        * @Description: Second constructor for RequestStatus object
        */
        global RequestStatus(String id) {
            this.id = id;
        }
    }

    /**
    * @Description: Boolean with is visible package value
    */
    @AuraEnabled
    global Boolean isVisible {get; set;}
}