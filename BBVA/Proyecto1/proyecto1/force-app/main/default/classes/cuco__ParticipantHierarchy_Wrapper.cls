/**
* ─────────────────────────────────────────────────────────────────────────────────────
* ParticipantHierarchy Wrapper
* Contains the participant details
* ─────────────────────────────────────────────────────────────────────────────────────
* @author      Giancarlo Mastrogiorgio <Giancarlo.Mastrogiorgio.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-02-10
* @modified
* @systemLayer Domain
* ─────────────────────────────────────────────────────────────────────────────────────
* @changes
*
* ─────────────────────────────────────────────────────────────────────────────────────
*/
@SuppressWarnings('PMD.AvoidGlobalModifier')
global class ParticipantHierarchy_Wrapper {
    /**
    * @Description: Name of Account
    */
    global string name {get;set;}

    /**
    * @Description: Type of Account
    */
    global string type {get;set;}

    /**
    * @Description: Parent Id of Account
    */
    global Id parentId {get;set;}

    /**
    * @Description: Parent Name of Account
    */
    global string parentName {get;set;}

    /**
    * @Description: SetId of Child Accounts
    */
    global Set<id> childIdsSet {get;set;}

    /**
    * @Description: String of intregration id
    */
    global string integrationId {get;set;}
}