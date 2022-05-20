/**
  * ------------------------------------------------------------------------------------------------
  * @Name     Arc_Gen_ModificationArce_Service
  * @Author   juanmanuel.perez.ortiz.contractor@bbva.com
  * @Date     Created: 2020-05-04
  * @Group    ARCE
  * ------------------------------------------------------------------------------------------------
  * @Description Service class to control all the modification logic of a ARCE
  * ------------------------------------------------------------------------------------------------
  * @Changes
  * |2020-04-05 juanmanuel.perez.ortiz.contractor@bbva.com
  *             Class Creation
  * |2020-05-12 juanmanuel.perez.ortiz.contractor@bbva.com
  *             Change reference in field name in method persistenceDmlModificationARCE
  * |2020-05-13 juanmanuel.perez.ortiz.contractor@bbva.com
  *             Add logic to assign group template
  * |2020-05-20 juanmanuel.perez.ortiz.contractor@bbva.com
  *             Change insert and update method references
  * |2020-06-12 mariohumberto.ramirez.contractor@bbva.com
  *             Added logic to copy policie table records from a previous analysis
  * |2020-06-29 juanmanuel.perez.ortiz.contractor@bbva.com
  *             Modified method called associateRecords for add an extra conditional
  * |2020-07-02 javier.soto.carrascosa@bbva.com
  *             Remove g-01 as sector
  * |2020-07-27 juanmanuel.perez.ortiz.contractor@bbva.com
  *             Break method persistenceDmlModificationARCE in smaller methods to avoid sonar majors
  * |2020-08-05 juanmanuel.perez.ortiz.contractor@bbva.com
  *             Add arce__group_risk_detail_part_name__c value in account has analysis creation
  * |2020-08-12 mariohumberto.ramirez.contractor@bbva.com
  *             Refactor class and added support for hu Renovation
  * |2020-09-23 saimassimilianno.jordana.contractor@bbva.com
  *             Added arce. namespace to all classes that are now in the arce-dependencies package
  * |2020-09-24 eduardoefrain.hernandez.contractor@bbva.com
  *             Update persistenceDmlModificationARCE method parameters & Add AnalysisResponse wrapper
  * |2020-10-14 eduardoefrain.hernandez.contractor@bbva.com
  *             Remove emptyFFSS setting in persistenceDmlModificationARCE method
  * |2020-10-14 juanmanuel.perez.ortiz.contractor@bbva.com
  *             Add parameter 'data' in associateAccHasAn2Arce, compareStructures methods
  * |2021-05-21 joseluis.garcia4.contractor@bbva.com
  *             Enable overlay creation in modification/renovation ARCEs.
  **/
@SuppressWarnings('sf:TooManyMethods, PMD.ExcessivePublicCount')
public without sharing class Arc_Gen_ModificationArce_Service {
    /*
    @Description: String with the word 1
    */
    static final String HEADER = '1';
    /**
    * @Class: AnalysisResponse
    * @Description: Wrapper that contain the needed params to send the helper
    * @author ARCE
    */
    public class AnalysisResponse {
        /**
            * @Description: String analysisId
        */
        public String analysisId {get;set;}
        /**
            * @Description: String Account has analysis Id group
        */
        public String groupAhaId {get;set;}
        /**
            * @Description: Persistance status indicator
        */
        public Boolean persistanceStatus {get;set;}
    }
    /**
    * ----------------------------------------------------------------------------------------------------
    * @Description Void Constructor to avoid warning in sonar qube
    * ----------------------------------------------------------------------------------------------------
    * @param void
    * @return void
    * @example Arc_Gen_ModificationArce_Service service = new Arc_Gen_ModificationArce_Service()
    * ----------------------------------------------------------------------------------------------------
    **/
    @TestVisible
    private Arc_Gen_ModificationArce_Service() {

    }

    /**
    *-------------------------------------------------------------------------------
    * @description Insert account has analysis to new modified arce
    *-------------------------------------------------------------------------------
    * @date 04/05/2020
    * @author juanmanuel.perez.ortiz.contractor@bbva.com
    * @param  analysisId
    * @return String id  to redirect
    * @example public static String persistenceDmlModificationARCE(String analysisId,String modRenVar,String selectedSector,String accountswraper) {
    */
    public static String persistenceDmlModificationARCE(Map<String, String> data) {
        final AnalysisResponse resultWrapper = new AnalysisResponse();
        final String analysisId = data.get('analysisId');
        final String modRenVar = data.get('modRenVar');
        final String accountswraper = data.get('accountswraper');
        final String subProcess = data.get('subProcess');
        final Boolean persistanceStatus = Arc_Gen_SyncPersistance_Helper.getPersistanceStatus(Boolean.valueOf(data.get('persistanceInd')), subProcess);

        final Map<String,arce__Account_has_Analysis__c> mapaha = new Map<String,arce__Account_has_Analysis__c>();
        final List < arce__rating_variables_detail__c > ratingVariables = new List <arce__rating_variables_detail__c> ();
        final String customerRelation = arce.Arc_Gen_ArceAnalysis_Data.getArceAnalysisData(new List<Id>{analysisId})[0].arce__analysis_customer_relation_type__c;
        final Arc_Gen_CloneWrapper response = Arc_Gen_ModRenArce_Helper.cloneRecords(Arc_Gen_ModRenArce_Helper.getRelatedRecordsArce(analysisId, modRenVar), modRenVar);
        for(arce__Account_has_Analysis__c aha: response.lsaha) {
            mapaha.put(aha.getCloneSourceId(), aha);
        }
        final List<arce__Account_has_Analysis__c> ahaToUpsertList = Arc_Gen_ModRenArce_Helper.associateAccHasAn2Arce(response, customerRelation, persistanceStatus, data);
        arce.Arc_Gen_AccHasAnalysis_Data.upsertObjects(ahaToUpsertList);

        final List<arce.Arc_Gen_Account_Wrapper> accountsWrapLts = (List<arce.Arc_Gen_Account_Wrapper>) JSON.deserialize(accountswraper, List<arce.Arc_Gen_Account_Wrapper>.Class);
        final Map<Id,List<String>> accIdsFromGE = Arc_Gen_ModRenArce_Helper.getAccountIdsFromGE(accountsWrapLts);
        final Map<Id,String> accIdsFromPreviousArce = new Map<Id,String>();
        final List<arce__Account_has_Analysis__c> previousArceAHAS = arce.Arc_Gen_AccHasAnalysis_Data.accHasAnByArce(new List<String>{response.lsarc[0].id});
        for (arce__Account_has_Analysis__c aha:  previousArceAHAS) {
            accIdsFromPreviousArce.put(aha.arce__Customer__c, aha.arce__Customer__r.Name);
            ratingVariables.add(arce.Arc_Gen_Rating_Var_detail_Data.setEmptyRatingVariable(aha.Id));
        }
        insert createOverlays(ahaToUpsertList);
        arce.Arc_Gen_Rating_Var_detail_Data.insertRatingVariables(ratingVariables);
        Arc_Gen_ModRenArce_Helper.compareStructures(accIdsFromGE, accIdsFromPreviousArce, response.lsarc[0].id, data);
        final String arceId = Arc_Gen_ModRenArce_Helper.associateRecords2AccHasAn(response, mapaha, modRenVar);
        Arc_Gen_ModRenArce_Helper.manageTraceability(arceId, modRenVar);
        resultWrapper.analysisId = arceId;
        resultWrapper.persistanceStatus = persistanceStatus;
        final String groupAhaId = ahaToUpsertList.size() == 1 ? ahaToUpsertList[0].Id : arce.Arc_Gen_AccHasAnalysis_Data.getAhaGroupOfArce(arceId).Id;
        resultWrapper.groupAhaId = groupAhaId;
        sendNotification(arceId);

        return JSON.serialize(resultWrapper);
    }
    /**
    *--------------------------------------------------------------------------------
    * @Description creates overlay records for rating if overlays are enabled.
    *--------------------------------------------------------------------------------
    * @Author   José Luis García Díaz - joseluis.garcia4.contractor@bbva.com
    * @Date     Created: 2021-04-22
    * @param    accHas2CreateLts - List of account has analysis records.
    * @return   list of overlays.
    * -------------------------------------------------------------------------------
    */
    private static List<arce__Overlay__c> createOverlays(List<arce__Account_has_Analysis__c> accHas2CreateLts) {
        // Check if overlays enabled.
        final List<arce__Arce_Config__mdt> configs = arce.Arc_Gen_Arceconfigs_locator.getConfigurationInfo('EnableOverlays');
        final Boolean overlaysEnabled = configs.isEmpty() ? false : Boolean.valueOf(configs[0].arce__Value1__c);

        final List<arce__Overlay__c> overlayObjs = new List<arce__Overlay__c>();
        if (overlaysEnabled) {
            for (arce__Account_has_Analysis__c aha : accHas2CreateLts) {
                overlayObjs.add(arce.Arc_Gen_Overlays_Utils.createOverlay(aha.Id));
            }
        }
        return overlayObjs;
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Method to send notifications when arce is created
    *-------------------------------------------------------------------------------
    * @Date 16-07-2020
    * @author juanmanuel.perez.ortiz.contractor@bbva.com
    * @param arceId - Id of the arce
    * @return void
    * @example sendNotification(arceId)
    *-------------------------------------------------------------------------------
    */
    public static void sendNotification(String arceId) {
        final List<arce__Account_has_Analysis__c> lstAccHas = arce.Arc_Gen_AccHasAnalysis_Data.accHasAnByArce(new List<String>{arceId});
        List<User> ltsUsers = new list<User>();
        Set<Id> setIds = new Set<Id>();
            for (arce__Account_has_Analysis__c accHas : lstAccHas) {
                setIds.add(accHas.arce__Customer__r.OwnerId);
            }
            for (Id usId : setIds) {
                user newUser = new user();
                newUser.id = usId;
                ltsUsers.add(newUser);
            }
            arce.Arc_Gen_GenericUtilities.createNotifications(ltsUsers,arceId, System.Label.Arc_Gen_ArceCreated + ': ' + arce.Arc_Gen_ArceAnalysis_Data.getArceAnalysisData(new List<Id>{arceId})[0].Name);
        }
}