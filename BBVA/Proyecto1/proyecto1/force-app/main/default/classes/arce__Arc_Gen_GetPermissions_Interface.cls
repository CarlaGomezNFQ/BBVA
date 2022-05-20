/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_GetPermissions_Interface
* @Author   juanignacio.hita.contractor@bbva.com
* @Date     Created: 26/11/2021
* @Group    ARCE
* -----------------------------------------------------------------------------------------------
* @Description Interface "Arc_Gen_GetPermissions_Interface"
* -----------------------------------------------------------------------------------------------
* @Changes
*
* |2021-11-26 saimassimilianno.jordana.contractor@bbva.com
*             Interface creation.
* -----------------------------------------------------------------------------------------------
*/
global interface Arc_Gen_GetPermissions_Interface {
    /**
    *
    * @Description : Method 'getPermissionToEdit' retrieves permissions to allow edition or not.
    */
    Boolean getPermissionToEdit(Id recordId);

}