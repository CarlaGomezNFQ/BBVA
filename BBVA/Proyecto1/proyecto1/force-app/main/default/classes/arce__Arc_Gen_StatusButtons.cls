/**
* @File Name          : Arc_Gen_StatusButtons.cls
* @Description        : Used to retrieve buttons status
* @Author             : ARCE Team
* @Group              : ARCE
* @Last Modified By   : luisruben.quinto.munoz@bbva.com
* @Last Modified On   : 12/7/2019 19:04:18
* @Modification Log   :
*==============================================================================
* Ver         Date                     Author      		      Modification
*==============================================================================
* 1.0    7/5/2019 23:57:32   diego.miguel.contractor@bbva.com     Added comments
* 1.1    27/01/2020 16:42:00   javier.soto.carrascosa@bbva.com     Add support for arce allocation
* 1.2    29/04/2020 08:42:00   javier.soto.carrascosa@bbva.com     Fix arce allocation parameter
* 1.3    14/07/2020 10:00:00   joseluis.garcia4.contractor@bbva.com     Add method isButtonAvailable()
* 1.4    18/08/2020 10:00:00   joseluis.garcia4.contractor@bbva.com     Move isButtonAvailable() method to Arc_Gen_GenericUtilities
* 1.5    21/10/2020 10:00:00   juanignacio.hita.contractor@bbva.com     Fix error when recordId is null or empty.
**/
global class Arc_Gen_StatusButtons implements dwp_dbpn.DynamicButtonsStatusInterface {
    /**
    *-------------------------------------------------------------------------------
    * @description Controls the availability of the given button
    * with the selectedSector
    *--------------------------------------------------------------------------------
    * @date 7/5/2019
    * @author ARCE Team
    * @param String recordId
    * @param String sObjectName
    * @return Set<String>
    */
    global Set<String> getDynamicButtonStatus(String recordId, String sObjectName) {
        Set<String> buttonsStatusSet = new Set<String>();
        if (recordId != null && recordId != '') {
            final List<Id> lstIds = new List<Id>();
            lstIds.add(recordId);
            final Type inter = Type.forName('arcealloc.Allocation_Service');
            final boolean custAlloc = String.isNotBlank(String.valueOf(inter)) && !Test.isRunningTest() ? ((Map<Id,boolean>) ((Callable) inter.newInstance()).call('checkBulkPrivileges', new Map<String, Object> {'accHasAnlysIdsLst' => lstIds})).get(recordId) : true ;
            Map<String,Set<String>> actPerOppMap = new Map<String, Set<String>>();
            if (custAlloc) {
                actPerOppMap = dwp_dace.DynamicActionsEngine_helper.getAvailableActions(lstIds,sObjectName,'Arc_Gen_Buttons');
            }
            if (actPerOppMap.get(recordId) != null) {
                buttonsStatusSet.addAll(actPerOppMap.get(recordId));
            }
        }
        return buttonsStatusSet;
    }
}