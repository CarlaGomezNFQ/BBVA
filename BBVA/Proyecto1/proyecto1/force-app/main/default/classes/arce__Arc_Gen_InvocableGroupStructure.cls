/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_InvocableGroupStructure
* @Author   amunguia.contractor@bbva.com
* @Date     Created: 18/03/2021
* @Group    ARCE
* -----------------------------------------------------------------------------------------------
* @Description Arc_Gen_InvocableGroupStructure
* -----------------------------------------------------------------------------------------------
* @Changes
*
* |18-03-2021 amunguia.contractor@bbva.com
*             Class creation.
* |17-05-2021 amunguia.contractor@bbva.com the GCP Rating logic is eliminated
* |27-05-2021 amunguia.contractor@bbva.com the sovereign's country is mapped
* |08-07-2021 amunguia.contractor@bbva.com logic is added to find the names of the cclient
* -----------------------------------------------------------------------------------------------
*/
public with sharing class Arc_Gen_InvocableGroupStructure {
    /**
    *-------------------------------------------------------------------------------
    * @description Empty constructor to avoid SonarQube warning.
    *-------------------------------------------------------------------------------
    **/
    @TestVisible
    private Arc_Gen_InvocableGroupStructure() {

    }
    /**
    * @Description: serviceMessage Structure
    */
    private static arce.Arc_Gen_CustomServiceMessages serviceMessages = new arce.Arc_Gen_CustomServiceMessages();
    /**
    * @Description: Object to insert
    */
    private static Map<String,arce__Overlay__c> toInsert;
    /**
    * @Description: event List
    */
    private static List<arce__persistanceCallbackEvent__e> errorEvents;
    /**
    * @Description: cclients Set
    */
    private static Set<String> cclients;
    /**
    * @Description: subsidiary type
    */
    private static final String SUBSIDIARY = '2';
    /**
    * @description call group services
    * @author amunguia.contractor@bbva.com | 03-18-2021
    * @param List<arce__Account_has_Analysis__c> ahaObjectList
    **/
    @InvocableMethod(label='call group services' description='update overlay from group services' category='Overlay')
    public static void callGroupServices(List<arce__Account_has_Analysis__c> ahaObjectList) {
        final List<Id> accountIds = new List<Id>();
        for(arce__Account_has_Analysis__c current :ahaObjectList) {
            accountIds.add(current.Id);
        }
        makeTheCallout(accountIds);
    }
    /**
    * @description future callout
    * @author amunguia.contractor@bbva.com | 04-22-2021
    * @param List<Id> objectIds
    **/
    @future(callout=true)
    public static void makeTheCallout(List<Id> objectIds) {
        final List<arce__Account_has_Analysis__c> updateAhas = [SELECT Id,arce__Analysis__c, arce__Customer__c,arce__CustomAccountID__c FROM arce__Account_has_Analysis__c WHERE Id IN :objectIds];
        servicesGroup(updateAhas);
    }
    /**
    * @description service group callouts
    * @author amunguia.contractor@bbva.com | 04-22-2021
    * @param List<arce__Account_has_Analysis__c> ahaObjectList
    **/
    public static void servicesGroup(List<arce__Account_has_Analysis__c> ahaObjectList) {
        final Set<Id> newAhas = new Set<Id>();
        final List<Id> clientList = new List<Id>();
        toInsert = new Map<String,arce__Overlay__c>();
        cclients = new Set<String>();
        for(arce__Account_has_Analysis__c currentObj : ahaObjectList) {
            clientList.add(arce.Arc_Gen_AccHasAnalysis_Data.getCorrectIdWAhas(currentObj));
            newAhas.add(currentObj.Id);
        }
        final Map<Id, List<arce__Overlay__c>> overlayMap = arce.Arc_Gen_Overlays_Utils.getOverlayMapByAha(newAhas);
        final Map<Id, arce.Arc_Gen_Account_Wrapper> accountWrpMap = arce.Arc_Gen_Account_Locator.getAccountInfoById(clientList);
        for(arce__Account_has_Analysis__c currentObj : ahaObjectList) {
            final String clientId = arce.Arc_Gen_AccHasAnalysis_Data.getCorrectIdWAhas(currentObj);
            if(!overlayMap.containsKey(currentObj.Id) && accountWrpMap.containsKey(clientId)) {
                invoked(currentObj, accountWrpMap.get(clientId));
            }
        }
        groupStructureBuilder();
        if(arce__Overlay__c.sObjectType.getDescribe().isCreateable() && !toInsert.isEmpty()) {
            insert toInsert.values();
        }
    }
    /**
    * @description call structure service
    * @author amunguia.contractor@bbva.com | 03-18-2021
    * @param arce__Account_has_Analysis__c ahaObject
    * @param arce.Arc_Gen_Account_Wrapper accWrapper
    **/
    private static void invoked(arce__Account_has_Analysis__c ahaObject, arce.Arc_Gen_Account_Wrapper accWrapper) {
        errorEvents = new List<arce__persistanceCallbackEvent__e>();
        Map<String,String> countryValuesMap = arce.Arc_Gen_Corporate_Utils.getPicklistLabels('arce__Geographic_Split__c' , 'arce__Country__c');
        final arce__Overlay__c newOverlay = arce.Arc_Gen_Overlays_Utils.createOverlay(ahaObject.Id);
        newOverlay.arce__Arc_Gen_Validate_GCP__c = '1';
        newOverlay.arce__Arc_Gen_SO_Country__c = countryValuesMap.containsKey(accWrapper.country) ? countryValuesMap.get(accWrapper.country) : accWrapper.country;
        final String customerNumber = arce.Arc_Gen_CallEncryptService.getEncryptedClient(accWrapper.accNumber);
        final Arc_Gen_EconomicPart_Sp2_RP econPartResult = Arc_Gen_StructureGroups_SP2_Service.callEconomicParticipations(customerNumber);
        if(validateEconomicParticipation(econPartResult, ahaObject.Id)) {
            final String economicGroup = econPartResult.calculateParent();
            final Arc_Gen_ParentGroups_SP2_RP parentGroupRP = Arc_Gen_StructureGroups_SP2_Service.callParentGroups(customerNumber, economicGroup);
            if(validateParentGroup(parentGroupRP, customerNumber)) {
                final Map<String, List<String>> structure = parentGroupRP.calculateChildrens();
                newOverlay.arce__Arc_Gen_ParentGroups__c = JSON.serialize(structure);
                cclients.addAll(structure.keySet());
                for(String key : structure.keySet()) {
                    cclients.addAll(structure.get(key));
                }
                newOverlay.arce__Arc_Gen_Validate_GCP__c = '2';
            } else {
                if(!parentGroupRP.isSuccessfull(serviceMessages.SUCCESSFUL_200)) {
                    errorEvents.add(createEvent(ahaObject.Id, parentGroupRP.messageError()));
                }
            }
        } else {
            if(!econPartResult.isSuccessfull(serviceMessages.SUCCESSFUL_200)) {
                errorEvents.add(createEvent(ahaObject.Id, econPartResult.messageError()));
            }
        }
        if(!errorEvents.isEmpty()) {
            EventBus.publish(errorEvents);
        }
        toInsert.put(ahaObject.Id, newOverlay);
    }
    /**
    * @description validate parent group service response
    * @author amunguia.contractor@bbva.com | 03-23-2021
    * @param Arc_Gen_ParentGroups_SP2_RP parentGroupRP
    * @param String customerNumber
    * @return Boolean
    **/
    private static Boolean validateParentGroup(Arc_Gen_ParentGroups_SP2_RP parentGroupRP, String customerNumber) {
        return parentGroupRP != null && parentGroupRP.isSuccessfull(serviceMessages.SUCCESSFUL_200) && !parentGroupRP.isParent(customerNumber);
    }
    /**
    * @description validate parent group service response
    * @author amunguia.contractor@bbva.com | 03-23-2021
    * @param Arc_Gen_ParentGroups_SP2_RP parentGroupRP
    * @param String customerNumber
    * @return Boolean
    **/
    private static arce__persistanceCallbackEvent__e createEvent(String ahaObjectId, String msg) {
        return new arce__persistanceCallbackEvent__e(
                    arce__AccountHasAnalysisId__c = ahaObjectId,
                    arce__Message__c = msg
                );
    }
    /**
    * @description validate economicParticipation response
    * @author amunguia.contractor@bbva.com | 03-23-2021
    * @param Arc_Gen_EconomicPart_Sp2_RP econPartResult
    * @return Boolean
    **/
    private static Boolean validateEconomicParticipation(Arc_Gen_EconomicPart_Sp2_RP econPartResult, String ahaObjectId) {
        Boolean result = econPartResult != null && econPartResult.isSuccessfull(serviceMessages.SUCCESSFUL_200);
        if(result && econPartResult.drawError()) {
            errorEvents.add(createEvent(ahaObjectId, System.Label.Arc_Gen_MatrixNoConfigured));
            result = false;
        }
        return result;
    }

    private static void groupStructureBuilder() {
        final Map<String, String> accountsMap = new Map<String, String>();
        final Map<String, arce.Arc_Gen_Account_Wrapper> accountWrpMap = arce.Arc_Gen_Account_Locator.getAccountByAccNumber(new List<String>(cclients));
        for(Arc_Gen_Account_Wrapper aux : accountWrpMap.values()) {
            accountsMap.put(aux.accNumber, aux.name);
        }
        for(arce__Overlay__c current : toInsert.values()) {
            if(current.arce__Arc_Gen_Validate_GCP__c == SUBSIDIARY) {
                final Map<String, List<String>> structure = (Map<String, List<String>>) JSON.deserialize(current.arce__Arc_Gen_ParentGroups__c, Map<String, List<String>>.class);
                current.arce__Arc_Gen_GlobalId_VC__c = JSON.serialize(Arc_Gen_DependentValue_Utils.parentBuilder(new Map<String,List<String>>{'' => new List<String>(structure.keySet())}, accountsMap));
                current.arce__Arc_Gen_LocalId_VC__c = JSON.serialize(Arc_Gen_DependentValue_Utils.parentBuilder(structure, accountsMap));
            }
        }
    }
    /**
    * @Description: Overlay Exception
    */
    public class OverlayException extends Exception {}
}