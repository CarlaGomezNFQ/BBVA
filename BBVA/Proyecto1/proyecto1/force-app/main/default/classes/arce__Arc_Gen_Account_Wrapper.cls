/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_Account_Interface
* @Author   juanignacio.hita.contractor@bbva.com
* @Date     Created: 15/11/2019
* @Group    ARCE
* -----------------------------------------------------------------------------------------------
* @Description Arc_Gen_Account_Wrapper that retrieves full account information
* -----------------------------------------------------------------------------------------------
* @Example Arc_Gen_Account_Wrapper wrapper = new Arc_Gen_Account_Wrapper();
* @Changes
*
* |2019-11-14 juanignacio.hita.contractor@bbva.com
*             Interface creation.
* |2020-01-06 mariohumberto.ramirez.contractor@bbva.com
*             Added new param updateStructure
* |2020-01-25 mariohumberto.ramirez.contractor@bbva.com
*             Added new params
* |2020-01-29 juanmanuel.perez.ortiz.contractor@bbva.com
*             Remove companyEcoAct,accActivity,rtDevName from Account Wrapper
* |2020-03-30 ricardo.almanza.contractor@bbva.com
*             Added participantParentaccNumber to Account Wrapper
* |2020-05-12 cesaroctavio.villanueva.cebal@bbva.com
*             Added sponsorIndicator to Account Wrapper
* |2020-05-25 cesaroctavio.villanueva.cebal@bbva.com
*             Removed sponsorIndicator from Account Wrapper
* |2020-07-15 javier.soto.carrascosa@bbva.com
*             Add branch id for participant
* |2021-01-20 saimassimilianno.jordana.contractor@bbva.com
*             Add customAccount and lookupname
* |2021-02-23 ivan.cons@bbva.com
*             Add parent/subsidiary structure. '1' for parent, '2' for subsidiary
* |2021-04-19 manuelhugo.castillo.contractor@bbva.com
*             Add new param accountInfo
* |2021-05-06 antonio.munoz.perez.contractor@bbva.com
*             Add globalId for GDT redirection
* -----------------------------------------------------------------------------------------------
*/
@JsonAccess(serializable='always' deserializable='always')
@SuppressWarnings('PMD.ExcessiveglobalCount, PMD.TooManyFields')
global class Arc_Gen_Account_Wrapper {
    /**
    *
    * @Description : Account Id
    */
    @AuraEnabled global Id accId {get;set;}
    /**
    *
    * @Description : String Account Name
    */
    @AuraEnabled global String name {get;set;}
    /**
    *
    * @Description : Account Number
    */
    @AuraEnabled global String accNumber {get;set;}
    /**
    *
    * @Description : GDT Client Id
    */
    @AuraEnabled global String globalId {get;set;}
    /**
    *
    * @Description : Participant Type of the Account
    */
    @AuraEnabled global String participantType {get;set;}
    /**
    *
    * @Description : Participant Owner Id of the Account
    */
    @AuraEnabled global Id participantOwnerId {get;set;}
    /**
    *
    * @Description : Participant Parent Owner Id of the Account
    */
    @AuraEnabled global Id participantParentOwnerId {get;set;}
    /**
    *
    * @Description : Participant Parent Account Number
    */
    @AuraEnabled global String participantParentaccNumber {get;set;}
    /**
    *
    * @Description : Account Parent Id
    */
    @AuraEnabled global Id accParentId {get;set;}
    /**
    *
    * @Description : String Bank Id Account
    */
    @AuraEnabled global String bankId {get;set;}
    /**
    *
    * @Description : String Doc Number
    */
    @AuraEnabled global String docNumber {get;set;}
    /**
    *
    * @Description : String Doc Type
    */
    @AuraEnabled global String docType {get;set;}
    /**
    *
    * @Description : String Error
    */
    @AuraEnabled global String error {get;set;}
    /**
    *
    * @Description : Boolean to enable/disable the update of the group structure
    */
    @AuraEnabled global Boolean updateStructure {get;set;}
    /**
    *
    * @Description : value of the current limit amount
    */
    @AuraEnabled global Double currentLimit {get;set;}
    /**
    *
    * @Description : value of the commited omount
    */
    @AuraEnabled global Double commited {get;set;}
    /**
    *
    * @Description : value of non commited amount
    */
    @AuraEnabled global Double unCommited {get;set;}
    /**
    *
    * @Description : value of the outstanding amount
    */
    @AuraEnabled global Double outstanding {get;set;}
    /**
    *
    * @Description : value of the currency
    */
    @AuraEnabled global String currencyType {get;set;}
    /**
    *
    * @Description : value of the unit
    */
    @AuraEnabled global String unit {get;set;}
    /**
    *
    * @Description : value of the unit
    */
    @AuraEnabled global String branchId {get;set;}
    /**
    *
    * @Description : value of the unit
    */
    @AuraEnabled global String country {get;set;}
    /**
    *
    * @Description : Custom account
    */
    @AuraEnabled global Id customAccount {get;set;}
    /**
    *
    * @Description : lookup fieldName to CustomAccount
    */
    @AuraEnabled global String lookupName {get;set;}
    /**
    *
    * @Description : Is parent/subsidiary('1' or '2')
    */
    @AuraEnabled global String parentSubsidiary {get;set;}
    /**
    *
    * @Description : basic info account
    */
    @AuraEnabled global Account accountInfo {get;set;}
}