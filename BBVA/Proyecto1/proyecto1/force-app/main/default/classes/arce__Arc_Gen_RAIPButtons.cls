/**
* @File Name          : Arc_Gen_RAIPButtons.cls
* @Description        : Used to retrieve RAIP Buttons status
* @Author             : ARCE Team
* @Group              : ARCE
* @Last Modified By   : juanignacio.hita.contractor@bbva.com
* @Last Modified On   : 30/03/2020 - 17:00:00
* @Modification Log   :
*==============================================================================
* Ver         Date                     Author      		      Modification
*==============================================================================
* 1.0    30/03/2020 - 17:00:00   juanignacio.hita.contractor@bbva.com     Created class for RAIP allocation
* 1.1    21/10/2020 - 10:00:00   juanignacio.hita.contractor@bbva.com     Fix error when recordId is null or empty.
**/
global class Arc_Gen_RAIPButtons implements dwp_dbpn.DynamicButtonsStatusInterface {
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
            final boolean custAlloc = String.isNotBlank(String.valueOf(inter)) && !Test.isRunningTest() ? ((Map<Id,boolean>) ((Callable) inter.newInstance()).call('checkBulkPrivileges', new Map<String, Object> {'anlysIdsLst' => lstIds})).get(recordId) : true ;
            Map<String,Set<String>> actOppIdMap = new Map<String, Set<String>>();
            if (custAlloc) {
                actOppIdMap = dwp_dace.DynamicActionsEngine_helper.getAvailableActions(lstIds,sObjectName,'Arc_Gen_RAIP');
            }
            if (actOppIdMap.get(recordId) != null) {
                buttonsStatusSet.addAll(actOppIdMap.get(recordId));
            }
        }
        return buttonsStatusSet;
    }
}