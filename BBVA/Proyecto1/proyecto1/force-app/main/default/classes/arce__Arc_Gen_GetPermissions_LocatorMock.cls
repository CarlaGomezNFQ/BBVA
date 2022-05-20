/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_GetPermissions_LocatorMock
* @Author   saimassimilianno.jordana.contractor@bbva.com
* @Date     Created: 26/11/2021
* @Group    ARCE
* -----------------------------------------------------------------------------------------------
* @Description Class "Arc_Gen_GetPermissions_LocatorMock"
* -----------------------------------------------------------------------------------------------
* @Changes
*
* |2021-11-26 saimassimilianno.jordana.contractor@bbva.com
*             Class creation
* -----------------------------------------------------------------------------------------------
*/
global class Arc_Gen_GetPermissions_LocatorMock implements Arc_Gen_GetPermissions_Interface {

    /**
    *-------------------------------------------------------------------------------
    * @description  Method "getPermissionToEdit" that retrieves permission to edit.
    --------------------------------------------------------------------------------
    * @author saimassimilianno.jordana.contractor@bbva.com
    * @date 2021-11-26
    * @param Id recordIds
    * @return Boolean
    * @example Boolean canEdit = Arc_Gen_GetPermissions_Locator.getPermissionToEdit(recordIds);
    **/
    @TestVisible
    global Boolean getPermissionToEdit(Id ahasId) {
        return ahasId != null;
    }
}