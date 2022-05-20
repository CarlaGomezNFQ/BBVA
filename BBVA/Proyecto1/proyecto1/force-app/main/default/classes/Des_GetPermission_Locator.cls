/**
 * @description       :
 * @author            : Global Desktop
 * @group             :
 * @last modified on  : 16-12-2021
 * @last modified by  : Global Desktop
**/
global with sharing class Des_GetPermission_Locator implements arce.Arc_Gen_GetPermissions_Interface {//NOSONAR
    /**
    * @description
    * @author Global Desktop | 09-12-2021
    * @param ahasId
    * @return Boolean
    **/
    public Boolean getPermissionToEdit(Id ahasId) {
        System.debug('>>>>>>> getPermissionToEdit entra');
        final Boolean resultado = Boolean.valueOf(Arc_Gen_TabSet_service.getPermissionToEdit(ahasId));
        System.debug('>>>>>>> getPermissionToEdit' + resultado);
        return resultado;
    }
}