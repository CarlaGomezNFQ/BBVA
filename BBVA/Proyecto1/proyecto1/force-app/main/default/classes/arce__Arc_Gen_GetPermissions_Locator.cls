/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_GetPermissions_Locator
* @Author   saimassimilianno.jordana.contractor@bbva.com
* @Date     Created: 26/11/2021
* @Group    ARCE
* -----------------------------------------------------------------------------------------------
* @Description Class "Arc_Gen_GetPermissions_Locator"
* -----------------------------------------------------------------------------------------------
* @Changes
*
* |2021-11-26 saimassimilianno.jordana.contractor@bbva.com
*             Class creation
* -----------------------------------------------------------------------------------------------
*/
global class Arc_Gen_GetPermissions_Locator implements Arc_Gen_GetPermissions_Interface {
    /**
    *-------------------------------------------------------------------------------
    * @description  Contrcutor to avoid major
    --------------------------------------------------------------------------------
    * @author saimassimilianno.jordana.contractor@bbva.com
    * @date 2021-11-26
    * @example Arc_Gen_GetPermissions_Locator()
    **/
    @TestVisible
    private Arc_Gen_GetPermissions_Locator() {
    }

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
    global static Boolean getPermissionToEdit(Id recordIds) {
        Boolean booToReturn;
        final String interfaceName = Test.isRunningTest() ? 'GetPermssInterfaceMock' : 'GetPermssInterface';
        final List<Arce_Config__mdt> lstArceConfig = Arc_Gen_Arceconfigs_locator.getConfigurationInfo(interfaceName);
        if (lstArceConfig.isEmpty()) {
            booToReturn = Arc_Gen_RatingGlobal_service.getPermissionIrp(recordIds, System.Label.Get_Permission_RS, System.Label.Get_Permission_Action);
        } else {
            try {
                final Arc_Gen_GetPermissions_Interface classToGetPerm = getGetPerLocatorClass(lstArceConfig);
                booToReturn = classToGetPerm.getPermissionToEdit(recordIds);
            } catch(Exception ex) {
                System.debug(ex.getMessage());
            }
        }
        return booToReturn;
    }

    /**
    * ---------------------------------------------------------------------------------------------------
    * @Description - Method "getGetPerLocatorClass" to find the class with the interface Arc_Gen_GetPermissions_Interface
    * ---------------------------------------------------------------------------------------------------
    * @Author   saimassimilianno.jordana.contractor@bbva.com
    * @Date     Created: 2021-11-26
    * @return   Arc_Gen_GetPermissions_Interface
    * @example Arc_Gen_GetPermissions_Interface classToGetPerm = getGetPerLocatorClass(nameConfig)
    * ---------------------------------------------------------------------------------------------------
    **/
    global static Arc_Gen_GetPermissions_Interface getGetPerLocatorClass(List<Arce_Config__mdt> lstArceConfig) {
        final System.Type objType = Type.forName(lstArceConfig.get(0).Value1__c);
        return (Arc_Gen_GetPermissions_Interface)objType.newInstance();
    }

}