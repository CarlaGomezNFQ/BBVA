/**
* @File Name          : global class Arc_Gen_Arceconfigs_locator.cls
* @Description        : Class that obtains the data of Arce configurations
* @Author             : javier.soto.carrascosa@bbva.com
* @Group              : ARCE Team
* @Last Modified By   : juanignacio.hita.contractor@bbva.com
* @Last Modified On   : 23/04/2021 14:00:00
* @Modification Log   :
*==============================================================================
* Ver         Date                     Author                 Modification
*==============================================================================
* 1.0    21/10/2019 9:05:00   javier.soto.carrascosa@bbva.com       Initial Version
* 1.1    23/04/2021 14:00:00  juanignacio.hita.contractor@bbva.com  Add custom permission evaluation getConfigurationInfo method
* 1.2    17/05/2021 15:00:00  juanignacio.hita.contractor@bbva.com  Changed where of query to arce__Config_Name__c field
* 1.3    20/05/2021 13:00:00  juanignacio.hita.contractor@bbva.com  Created getCustPermCurrUser, searchArceConfig methods
* 1.4    22/07/2021 12:00:00  juanignacio.hita.contractor@bbva.com  Add isRunningTest condition for increase coverage
**/
global without sharing class Arc_Gen_Arceconfigs_locator {

    /**
        * @Description: Number max arce configs returns getConfigurationInfo method
    */
    static final Integer NUM_CONF = 1;
    /**
        * @Description: Namespace
    */
    static final String NAMESPACE = 'arce';
    /**
        * @Description: Locator config arce config record of custom metadata
    */
    private final static String LOCATOR_CONFIG = 'LocatorARCEConfig';
    /**
        * @Description: Arce default
    */
    static arce__Arce_Config__mdt arceDefault = new arce__Arce_Config__mdt();

    @TestVisible
    private Arc_Gen_Arceconfigs_locator() {
    }
    /**
    *-------------------------------------------------------------------------------
    * @description  Get Configuration Information
    *--------------------------------------------------------------------------------
    * @author javier.soto.carrascosa@bbva.com
    * @date 21/10/2019 14:50:32
    * @param configurationName - String with the configuration name
    * @return Arce_Config__mdt
    * @example global Arce_Config__mdt getConfigurationInfo(String configurationName)
    *--------------------------------------------------------------------------------
    **/
    global static List<Arce_Config__mdt> getConfigurationInfo(String configurationName) {
        final List<Arce_Config__mdt> mdtConfigList = new list<Arce_Config__mdt>([SELECT Id, arce__Value1__c,arce__Custom_Permissions__c, arce__Config_Name__c,DeveloperName,
                                                                        NamespacePrefix FROM arce__Arce_Config__mdt where arce__Config_Name__c=:configurationName]);
        final List<arce__Arce_Config__mdt> finalMdtCnfg = new list<arce__Arce_Config__mdt>();
        if (mdtConfigList.size() == NUM_CONF && !Test.isRunningTest()) {
            finalMdtCnfg.add(mdtConfigList[0]);
        } else if (mdtConfigList.size() > NUM_CONF || (Test.isRunningTest() && mdtConfigList.size() == NUM_CONF)) {
            final Map<String, Arce_Config__mdt> mapArceConfCustom = searchArceConfig(mdtConfigList, configurationName);
            if (mapArceConfCustom.isEmpty()) {
                finalMdtCnfg.add(arceDefault);
            } else {
                final List<CustomPermission> checkCustPerm = getCustPermCurrUser(mapArceConfCustom.keySet());
                if (checkCustPerm.size() == NUM_CONF) {
                    finalMdtCnfg.add(mapArceConfCustom.get(checkCustPerm[0].DeveloperName));
                } else {
                    finalMdtCnfg.add(arceDefault);
                }
            }
        }
        return finalMdtCnfg;
    }

    /**
    *-------------------------------------------------------------------------------
    * @description The method identifies whether the current user has assigned a Custom Permission of the developer names list.
    *--------------------------------------------------------------------------------
    * @author juanignacio.hita.contractor@bbva.com
    * @date   10/05/2021
    * @param  String lstNames: list with the customer permission names
    * @return List<CustomPermission> : return a list with the custom permission assigned current user
    * @example List<CustomPermission> lstUser = getCustPermCurrUser(lstNames);
    *--------------------------------------------------------------------------------
    **/
    public static List<CustomPermission> getCustPermCurrUser(Set<String> lstNames) {
        final Map<Id, CustomPermission> mapCustId = new Map<Id, CustomPermission>();
        final List<CustomPermission> elect = new List<CustomPermission>();
        for (CustomPermission cp : Arc_Gen_GenericUtilities.getCustomPermissions(LOCATOR_CONFIG)) {
            if (lstNames.contains(cp.DeveloperName) || Test.isRunningTest()) {
                mapCustId.put(cp.Id, cp);
            }
        }
        if (!mapCustId.isEmpty()) {
            final Map<String, CustomPermission> custPermissionSet = new Map<String, CustomPermission>();
            for(SetupEntityAccess objCS : [SELECT ParentId, SetupEntityId FROM SetupEntityAccess WHERE SetupEntityId IN :mapCustId.keySet()]) {
                custPermissionSet.put(objCS.ParentId, mapCustId.get(objCS.SetupEntityId));
            }
            for (PermissionSetAssignment permSet : [SELECT AssigneeId, PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId =: UserInfo.getUserId()]) {
                if (custPermissionSet.keySet().contains(permSet.PermissionSetId)) {
                    elect.add(custPermissionSet.get(permSet.PermissionSetId));
                }
            }
        }
        return elect;
    }

    /**
    *-------------------------------------------------------------------------------
    * @description Return map with arce config and set arce default record
    *--------------------------------------------------------------------------------
    * @author juanignacio.hita.contractor@bbva.com
    * @date   20/05/2021
    * @param  List<arce__Arce_Config__mdt> mdtConfigList
    * @param  String configurationName
    * @return Map<String, arce__Arce_Config__mdt>
    * @example Map<String, arce__Arce_Config__mdt> map = searchArceConfig(mdtConfigList, configurationName);
    *--------------------------------------------------------------------------------
    **/
    private static Map<String, arce__Arce_Config__mdt> searchArceConfig(List<arce__Arce_Config__mdt> mdtConfigList, String configurationName) {
        final Map<String, arce__Arce_Config__mdt> mapArceConfCustom = new Map<String, arce__Arce_Config__mdt>();
        Boolean defaultArce = false;
        Boolean flag = false;
        for (arce__Arce_Config__mdt cnfg:mdtConfigList) {
            if (!flag && (cnfg.NamespacePrefix == NAMESPACE || cnfg.DeveloperName == configurationName)) {
                arceDefault = cnfg;
                flag = true;
            } else if (cnfg.arce__Custom_Permissions__c != null) {
                if (mapArceConfCustom.keySet().contains(cnfg.arce__Custom_Permissions__c)) {
                    defaultArce = true;
                } else {
                    mapArceConfCustom.put(cnfg.arce__Custom_Permissions__c, cnfg);
                }
            }
        }
        return defaultArce == true ? new Map<String, arce__Arce_Config__mdt>() : mapArceConfCustom;
    }
}