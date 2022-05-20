/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_User_Interface
* @Author   juanignacio.hita.contractor@bbva.com
* @Date     Created: 14/11/2019
* @Group    ARCE
* -----------------------------------------------------------------------------------------------
* @Description Interface "Arc_Gen_User_Interface"
* -----------------------------------------------------------------------------------------------
* @Changes
*
* |2019-11-14 juanignacio.hita.contractor@bbva.com
*             Interface creation.
* -----------------------------------------------------------------------------------------------
*/
global interface Arc_Gen_User_Interface {
    /**
    *
    * @Description : Retrieves information of a user given its id
    */
    Arc_Gen_User_Wrapper getUserInfo(Id userId);
    /**
    *
    * @Description : Retrieves list of users given an input term matching the name
    */
    List<Arc_Gen_User_Wrapper> getUsers(String inputTerm);
}