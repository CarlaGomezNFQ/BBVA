/**
* ────────────────────────────────────────────────────────────────────
* ProfitabilityAnalysis_Wrapper
* Wrapper class for for Profitability Analysis Wrapper
* ────────────────────────────────────────────────────────────────────
* @author      Carlos Pisador
* @modifiedBy
* @version     1.0
* @created     2021-04-07
* @modified
* @systemLayer Domain
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@SuppressWarnings('PMD.AvoidGlobalModifier, PMD.TooManyFields')
global class ProfitabilityAnalysis_Wrapper {
    /**
    * @Description : id
    */
    @AuraEnabled
    global String id {get; set;}
    /**
    * @Description : name
    */
    @AuraEnabled
    global String name {get; set;}
    /**
    * @Description : typology
    */
    @AuraEnabled
    global String typology {get; set;}
    /**
    * @Description : code
    */
    @AuraEnabled
    global String code {get; set;}
    /**
    * @Description : originStartDate
    */
    @AuraEnabled
    global Date originStartDate {get; set;}
    /**
    * @Description : originEndDate
    */
    @AuraEnabled
    global Date originEndDate {get; set;}
    /**
    * @Description : mainParticipant
    */
    @AuraEnabled
    global MainParticipant mainParticipant {get; set;}
    /**
    * @Description : stage
    */
    @AuraEnabled
    global String stage {get; set;}
    /**
    * @Description : status
    */
    @AuraEnabled
    global String status {get; set;}
    /**
    * @Description : branchCode
    */
    @AuraEnabled
    global String branchCode {get; set;}
    /**
    * @Description : delegatedBranchCode
    */
    @AuraEnabled
    global String delegatedBranchCode {get; set;}
    /**
    * @Description : segment
    */
    @AuraEnabled
    global String segment {get; set;}
    /**
    * @Description : startDate
    */
    @AuraEnabled
    global Date startDate {get; set;}
    /**
    * @Description : endDate
    */
    @AuraEnabled
    global Date endDate {get; set;}
    /**
    * @Description : ownerId
    */
    @AuraEnabled
    global String ownerId {get; set;}
    /**
    * @Description : ownerCode
    */
    @AuraEnabled
    global String ownerCode {get; set;}
    /**
    * @Description : ownerName
    */
    @AuraEnabled
    global String ownerName {get; set;}
    /**
    * @Description : isSpecificContractsScope
    */
    @AuraEnabled
    global Boolean isSpecificContractsScope {get; set;}
    /**
    * @Description : contractsScopeDesc
    */
    @AuraEnabled
    global String contractsScopeDesc {get; set;}
    /**
    * @Description : isForcedManualManagement
    */
    @AuraEnabled
    global Boolean isForcedManualManagement {get; set;}
    /**
    * @Description : comments
    */
    @AuraEnabled
    global String comments {get; set;}
    /**
    * @Description : autoFormRequestId
    */
    @AuraEnabled
    global String autoFormRequestId {get; set;}
    /**
    * @Description : manualFormRequestId
    */
    @AuraEnabled
    global String manualFormRequestId {get; set;}
    /**
    * @Description : priceApprovalId
    */
    @AuraEnabled
    global String priceApprovalId {get; set;}
    /**
    * @Description : priceAuthDate
    */
    @AuraEnabled
    global Date priceNegDate {get; set;}
    /**
    * @Description : lastAutoFormDate
    */
    @AuraEnabled
    global Date lastAutoFormDate {get; set;}
    /**
    * @Description : participantsList
    */
    @AuraEnabled
    global List<Participants> participantsList {get; set;}
    /**
    * @Description : conditionsList
    */
    @AuraEnabled
    global List<Condition> conditionsList {get; set;}
    /**
    * @Description : flatRate
    */
    @AuraEnabled
    global FlatRate flatRate {get; set;}
    /**
    * @Description : packages
    */
    @AuraEnabled
    global Packages packages {get; set;}
    /**
    * @Description : originName
    */
    @AuraEnabled
    global String originName {get; set;}
    /**
    * @Description : originTransOffer
    */
    @AuraEnabled
    global String originTransOffer {get; set;}
    /**
    * ------------------------------------------------------------------------------------------------
    * @Name     MainParticipant
    * @Author   Carlos Pisador
    * -----------------------------------------------------------------------------------------------
    * @Description Class with data
    */
    global class MainParticipant {
        @AuraEnabled
        global String name {get; set;}
        /**
        * @Description : integrationId
        */
        @AuraEnabled
        global String integrationId {get; set;}
        /**
        * @Description : type
        */
        @AuraEnabled
        global String type {get; set;}
        /**
        * @Description : accountid
        */
        @AuraEnabled
        global String accountid {get; set;}
    }
    /**
    * ------------------------------------------------------------------------------------------------
    * @Name     Participants
    * @Author   Carlos Pisador
    * -----------------------------------------------------------------------------------------------
    * @Description Class with data
    */
    global class Participants {
        /**
        * @Description : id
        */
        @AuraEnabled
        global String id {get; set;}
        /**
        * @Description : name
        */
        @AuraEnabled
        global String name {get; set;}
        /**
        * @Description : code
        */
        @AuraEnabled
        global String code {get; set;}
        /**
        * @Description : integrationId
        */
        @AuraEnabled
        global String integrationId {get; set;}
        /**
        * @Description : documentNum
        */
        @AuraEnabled
        global String documentNum {get; set;}
        /**
        * @Description : documentType
        */
        @AuraEnabled
        global String documentType {get; set;}
        /**
        * @Description : accountid
        */
        @AuraEnabled
        global String accountid {get; set;}
        /**
        * @Description : documentTypeCode
        */
        @AuraEnabled
        global String documentTypeCode {get; set;}
    }
    /**
    * ------------------------------------------------------------------------------------------------
    * @Name     Condition
    * @Author   Carlos Pisador
    * -----------------------------------------------------------------------------------------------
    * @Description Class with data
    */
    global class Condition {
        /**
        * @Description : id
        */
        @AuraEnabled
        global String id {get; set;}
        /**
        * @Description : name
        */
        @AuraEnabled
        global String name {get; set;}
        /**
        * @Description : familyName
        */
        @AuraEnabled
        global String family {get; set;}
        /**
        * @Description : product
        */
        @AuraEnabled
        global String product {get; set;}
        /**
        * @Description : source
        */
        @AuraEnabled
        global String source {get; set;}
        /**
        * @Description : sourceCode
        */
        @AuraEnabled
        global String sourceCode {get; set;}
        /**
        * @Description : formMethod
        */
        @AuraEnabled
        global String formMethod {get; set;}
        /**
        * @Description : requiredManualReview
        */
        @AuraEnabled
        global Boolean requiredManualReview {get; set;}
        /**
        * @Description : attributesList
        */
        @AuraEnabled
        global List<Attribute> attributesList {get; set;}
        /**
        * @Description : pkgInternationalScopeReview
        */
        @AuraEnabled
        global Boolean pkgInternationalScopeReview {get; set;}
        /**
        * @Description : canonicalId
        */
        @AuraEnabled
        global String canonicalId {get; set;}
        /**
        * @Description : familyCanonicalId
        */
        @AuraEnabled
        global String familyCanonicalId {get; set;}
    }
    /**
    * ------------------------------------------------------------------------------------------------
    * @Name     Attribute
    * @Author   Carlos Pisador
    * -----------------------------------------------------------------------------------------------
    * @Description Class with data
    */
    global class Attribute{
        /**
        * @Description : canonicalId
        */
        @AuraEnabled
        global String canonicalId {get; set;}
        /**
        * @Description : value
        */
        @AuraEnabled
        global String value {get; set;}
        /**
        * @Description : valueId
        */
        @AuraEnabled
        global String valueId {get; set;}
        /**
        * @Description : valueType
        */
        @AuraEnabled
        global String valueType {get; set;}
        /**
        * @Description : name
        */
        @AuraEnabled
        global String name {get; set;}
        /**
        * @Description : origin
        */
        @AuraEnabled
        global String origin {get; set;}
        /**
        * @Description : formType
        */
        @AuraEnabled
        global String formType {get; set;}
        /**
        * @Description : isPriceAtt
        */
        @AuraEnabled
        global Boolean isPriceAtt {get; set;}
        /**
        * @Description : formatType
        */
        @AuraEnabled
        global String formatType {get; set;}
        /**
        * @Description : formatUnitType
        */
        @AuraEnabled
        global String formatUnitType {get; set;}
        /**
        * @Description : attCanonicalId
        */
        @AuraEnabled
        global String attCanonicalId {get; set;}
    }
    /**
    * ------------------------------------------------------------------------------------------------
    * @Name     FlatRate
    * @Author   Carlos Pisador
    * -----------------------------------------------------------------------------------------------
    * @Description Class with data
    */
    global class FlatRate {
        /**
        * @Description : id
        */
        @AuraEnabled
        global String id {get; set;}
        /**
        * @Description : requestType
        */
        @AuraEnabled
        global String requestType {get; set;}
        /**
        * @Description : flatRatesInfoAttList
        */
        @AuraEnabled
        global List<Attribute> flatRatesInfoAttList {get; set;}
        /**
        * @Description : flatRateAccountsList
        */
        @AuraEnabled
        global List<FlatRteAccount> flatRateAccountsList {get; set;}
        /**
        * @Description : dpItemList
        */
        @AuraEnabled
        global List<DpItem> dpItemList {get; set;}
        /**
        * @Description : flatConditionsList
        */
        @AuraEnabled
        global List<FlatCondition> flatConditionsList {get; set;}
    }
    /**
    * ------------------------------------------------------------------------------------------------
    * @Name     Packages
    * @Author   Carlos Pisador
    * -----------------------------------------------------------------------------------------------
    * @Description Class with data
    */
    global class Packages {
        /**
        * @Description : extendedPackages
        */
        @AuraEnabled
        global List<String> extendedPackages {get; set;}
        /**
        * @Description : commPackageList
        */
        @AuraEnabled
        global List<Package_Wrapper> commPackageList {get; set;}
        /**
        * @Description : forfaitPackageList
        */
        @AuraEnabled
        global List<Package_Wrapper> forfaitPackageList {get; set;}
        /**
        * @Description : gipPackageList
        */
        @AuraEnabled
        global List<Package_Wrapper> gipPackageList {get; set;}
    }
    /**
    * ------------------------------------------------------------------------------------------------
    * @Name     FlatRteAccount
    * @Author   Carlos Pisador
    * -----------------------------------------------------------------------------------------------
    * @Description Class with data
    */
    global class FlatRteAccount {
        /**
        * @Description : id
        */
        @AuraEnabled
        global String id {get; set;}
        /**
        * @Description : code
        */
        @AuraEnabled
        global String code {get; set;}
        /**
        * @Description : name
        */
        @AuraEnabled
        global String name {get; set;}
        /**
        * @Description : accountAttribute
        */
        @AuraEnabled
        global Attribute accountAttribute {get; set;}
    }
    /**
    * ------------------------------------------------------------------------------------------------
    * @Name     FlatCondition
    * @Author   Carlos Pisador
    * -----------------------------------------------------------------------------------------------
    * @Description Class with data
    */
    global class FlatCondition {
        /**
        * @Description : id
        */
        @AuraEnabled
        global String id {get; set;}
        /**
        * @Description : name
        */
        @AuraEnabled
        global String name {get; set;}
        /**
        * @Description : family
        */
        @AuraEnabled
        global String family {get; set;}
        /**
        * @Description : product
        */
        @AuraEnabled
        global String product {get; set;}
        /**
        * @Description : estimatedVolume
        */
        @AuraEnabled
        global Integer estimatedVolume {get; set;}
        /**
        * @Description : canonicalId
        */
        @AuraEnabled
        global String canonicalId {get; set;}
    }
    /**
    * ------------------------------------------------------------------------------------------------
    * @Name     DpItem
    * @Author   Carlos Pisador
    * -----------------------------------------------------------------------------------------------
    * @Description Class with data
    */
    global class DpItem {
        /**
        * @Description : id
        */
        @AuraEnabled
        global String id {get; set;}
        /**
        * @Description : classification
        */
        @AuraEnabled
        global String classification {get; set;}
        /**
        * @Description : name
        */
        @AuraEnabled
        global String name {get; set;}
        /**
        * @Description : dpAttList
        */
        @AuraEnabled
        global List<Attribute> dpAttList {get; set;}
        /**
        * @Description : canonicalId
        */
        @AuraEnabled
        global String canonicalId {get; set;}
        /**
        * @Description : cross
        */
        @AuraEnabled
        global Boolean cross {get; set;}
    }
}