/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_User_Wrapper
* @Author   javier.soto.carrascosa@bbva.com
* @Date     Created: 24/06/2019
* @Group    ARCE
* -----------------------------------------------------------------------------------------------
* @Description Arc_Gen_User_Wrapper getUserInfo that retrieves full user information
* -----------------------------------------------------------------------------------------------
* @Changes
*
* |2019-07-15 javier.soto.carrascosa@bbva.com
*             Class creation.
* |2020-03-30 mariohumberto.ramirez.contractor@bbva.com
*             Added new params
* |2021-02-23 juanignacio.hita.contractor@bbva.com
*             Added territory param
* -----------------------------------------------------------------------------------------------
*/
global class Arc_Gen_User_Wrapper {
    /**
    *
    * @Description : User object
    */
    global User userBasicInfo {get; set;}
    /**
    *
    * @Description : string with User branch id
    */
    global String branchId {get; set;}
    /**
    *
    * @Description : String Branch name
    */
    global String branchText {get; set;}
    /**
    *
    * @Description : String branch level id
    */
    global String branchlevel {get; set;}
    /**
    *
    * @Description : String user id
    */
    global String businessAgentId {get; set;}
    /**
    *
    * @Description : String user profile name
    */
    global String profileName {get; set;}
    /**
    *
    * @Description : String ambit user
    */
    global string ambitUser {get; set;}
    /**
    *
    * @Description : String user cr
    */
    global String cr {get; set;}
    /**
    *
    * @Description : String user office name
    */
    global String officeName {get; set;}
    /**
    *
    * @Description : String territory name
    */
    global String territory {get; set;}
}