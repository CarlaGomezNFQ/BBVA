/**
* ____________________________________________________________________________
* Profitability Sheet Wrapper
* Wrapper class for the object profitability_sheet__c
* ____________________________________________________________________________
* @author      DWP ES Developers
* @modifiedBy
* @version     1.0
* @created     2021-02-07
* @modified
* @systemLayer
* ____________________________________________________________________________
* @changes
*
* ____________________________________________________________________________
*/
@SuppressWarnings('PMD.AvoidGlobalModifier')
global class ProfitabilitySheet_Wrapper {
  /**
  * @Description: String with pa sheet id
  */
  @AuraEnabled
  global String id {get; set;}
  /**
  * @Description: String with pa sheet code
  */
  @AuraEnabled
  global String code {get; set;}
  /**
  * @Description: String with pa sheet name
  */
  global String name {get; set;}
  /**
  * @Description: String with pa sheet group Id
  */
  @AuraEnabled
  global String groupId {get; set;}
  /**
  * @Description: String with pa sheet status
  */
  @AuraEnabled
  global String status {get; set;}
  /**
  * @Description: String with pa sheet branch code
  */
  @AuraEnabled
  global String branchCode {get; set;}
  /**
  * @Description: String with pa sheet segment
  */
  @AuraEnabled
  global String segment {get; set;}
  /**
  * @Description: String with pa sheet start date
  */
  @AuraEnabled
  global Date startDate {get; set;}
  /**
  * @Description: String with pa sheet end date
  */
  @AuraEnabled
  global Date endDate {get; set;}
  /**
  * @Description: String with pa sheet owner's code
  */
  @AuraEnabled
  global String ownerCode {get; set;}
  /**
  * @Description: Boolean with pa sheet value for specific contract indicator
  */
  @AuraEnabled
  global Boolean isSpecificContractsScope {get; set;}
  /**
  * @Description: Boolean with pa sheet value for forced manual management
  */
  @AuraEnabled
  global Boolean isForcedManualManagement {get; set;}
  /**
  * @Description: List of Participants for the pa sheet
  */
  @AuraEnabled
  global List<Participant> participantsList {get; set;}
  /**
  * @Description: List of Conditons for the pa sheet
  */
  @AuraEnabled
  global List<Condition> conditionsList {get; set;}
  /**
  * @Description: List of Packages for the pa sheet
  */
  @AuraEnabled
  global List<Package_Wrapper> packagesList {get; set;}
  /**
  * @Description: Wrapper for participant object
  */
  global class Participant {
    /**
    * @Description: String with id of the participant
    */
    @AuraEnabled
    global String id {get; set;}
  }
  /**
  * @Description: Wrapper for condition object
  */
  global class Condition {
    /**
    * @Description: String with id of the condition
    */
    @AuraEnabled
    global String id {get; set;}
    /**
    * @Description: String with id of the family
    */
    @AuraEnabled
    global String familyId {get; set;}
    /**
    * @Description: String with the source information
    */
    @AuraEnabled
    global String source {get; set;}
    /**
    * @Description: String with the source code
    */
    @AuraEnabled
    global String sourceCode {get; set;}
    /**
    * @Description: List of Attributes for the condition
    */
    @AuraEnabled
    global List<Attribute> attributesList {get; set;}
  }
  /**
  * @Description: Wrapper for attribute object
  */
  global class Attribute {
    /**
    * @Description: String with the id of the attribute
    */
    @AuraEnabled
    global String id {get; set;}
    /**
    * @Description: String with the id of the attribute
    */
    @AuraEnabled
    global String condAttrId {get; set;}
    /**
    * @Description: String with the canonical id of the attribute
    */
    @AuraEnabled
    global String canonicalId {get; set;}
    /**
    * @Description: String with the value of the attribute
    */
    @AuraEnabled
    global String value {get; set;}
  }
  /**
  * @Description: wrapper with flat rates
  */
  @AuraEnabled
  global FlatRates_Wrapper flatRates {get; set;}
}