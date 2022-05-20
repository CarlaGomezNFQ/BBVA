/**
* ------------------------------------------------------------------------------------------------
* @Name    Arc_Gen_RiskAssSP2_Service
* @Author  Sai Jordana  saimassimilianno.jordana.contractor@bbva.com
* @Date    Created: 10/03/2021
* @Group   ARCE
* ------------------------------------------------------------------------------------------------
* @Description Uses IASO to connect to Risk Assesment and Rating Engine services.
* ------------------------------------------------------------------------------------------------
* @Changes
* |10/03/2021 saimassimilianno.jordana.contractor@bbva.com
*             Class creation.
* |11/05/2021 saimassimilianno.jordana.contractor@bbva.com
*             Add getRatnVarCRP and getTraceEvntCRP meth0ds.
* |21/05/2021 saimassimilianno.jordana.contractor@bbva.com
*             initOverrideSer, isNotESPSer, isESPService, getRtngIdSer meth0ds added.
* -----------------------------------------------------------------------------------------------
*/
public with sharing class Arc_Gen_initAdjustment_Service {

    /**
    * --------------------------------------------------------------------------------------
    * Constructor
    **/
    @TestVisible
    private Arc_Gen_initAdjustment_Service() {}

    /**
    * @Description: arce.Arc_Gen_RatingGlobal_data()
    */
    private static arce.Arc_Gen_RatingGlobal_data ratingSp2Data = new arce.Arc_Gen_RatingGlobal_data();
    /**
    * @Description: string with the service name
    */
    Static Final String SERVICE_NAME = 'riskassRatingId';
    /**
    * @Description: string with a type of assessment
    */
    Static Final String RED_RAT = 'REDUCED_RATING_ASSESSMENT';
    /**
    * @Description: string with a type of event
    */
    Static Final String RATING = 'RATING';
    /*
    * @Description: Value for "Yes" in the arce__controlled_by_sponsor_type__c picklist field.
    */
    Static Final String FINANC_SPNSR_YES = '1';

    /**
    * @Description: response format for front usage.
    */
    public class AdjustResponse {
        /**
        * @Description: Status of the DML operation
        */
        @AuraEnabled
        public Boolean saveStatus {get;set;}
        /**
        * @Description: Message if the DML operation fails
        */
        @AuraEnabled
        public String saveMessage {get;set;}
        /**
        * @Description: Boolean to indicate if the tab have to refresh.
        */
        @AuraEnabled
        public Boolean refreshTab {get;set;}
        /**
        * @Description: Result code of service call.
        */
        @AuraEnabled
        public String serviceCode {get;set;}
        /**
        * @Description: Message if the service call operation fails
        */
        @AuraEnabled
        public String serviceMessage {get;set;}

        /**
        * @Description: Constructor.
        */
        public AdjustResponse() {
            this.serviceCode = '200';
            this.refreshTab = false;
            this.saveStatus = true;
        }
    }


    /**
    *-------------------------------------------------------------------------------
    * @description Meth0d to call risk Assessment to get ratingId.
    --------------------------------------------------------------------------------
    * @author saimassimilianno.jordana.contractor@bbva.com
    * @date 18/03/2021
    * @param arce__Account_has_Analysis__c header
    * @return Arc_Gen_ServiceAndSaveResponse
    **/
    public static arce.Arc_Gen_ServiceAndSaveResponse riskAssRatingId(arce__Account_has_Analysis__c header) {
        final Map<String, String> serHeadTest = new Map<String, String>();
        serHeadTest.put('Location','https://ei-asoexternos.grupobbva.com/ESCD/risk-analyst/v0/risk-assessments/804');
        final Boolean retriveMock = arce.Arc_Gen_RatingGlobal_data.getIasoIntegrationMtd(SERVICE_NAME).iaso__Retrieve_Mock_LTA__c;

        final arce.Arc_Gen_ServiceAndSaveResponse servAndSvRes = new arce.Arc_Gen_ServiceAndSaveResponse();
        arce.Arc_Gen_getIASOResponse.serviceResponse iasoResponse = new arce.Arc_Gen_getIASOResponse.serviceResponse();
        final String analysisId = header.arce__Analysis__c;
        final arce__Analysis__c analysis = arce.Arc_Gen_ArceAnalysis_Data.getArceAnalysisData(new List<Id>{analysisId})[0];
        final String customerId = arce.Arc_Gen_AccHasAnalysis_Data.getCorrectIdWAhas(header);
        final Map<Id, arce.Arc_Gen_Account_Wrapper> mapWrap = arce.Arc_Gen_Account_Locator.getAccountInfoById(new List<Id>{customerId});
        final String eventType = RATING;
        final String encryptedClient = arce.Arc_Gen_CallEncryptService.getEncryptedClient(mapWrap.get(customerId).accNumber);
        final String ChildARCE = header.Name;
        final String ParentARCE = header.Name;
        final String NumClient = encryptedClient;
        final String TypeArc = mapWrap.get(customerId).participantType;
        final String NameClient = mapWrap.get(customerId).name;
        final String docNumber = mapWrap.get(customerId).docNumber;
        final String docType = mapWrap.get(customerId).docType;
        final String branchId = mapWrap.get(customerId).branchId;
        final String bankId = mapWrap.get(customerId).bankId;
        final String assType = RED_RAT;
        final String finSponsor = analysis.arce__controlled_by_sponsor_type__c == FINANC_SPNSR_YES ? 'true' : 'false';
        iasoResponse = arce.Arc_Gen_getIASOResponse.calloutIASO(SERVICE_NAME,'{"ChildARCE" : "' + ChildARCE +'","assType" : "' + assType +'","ParentARCE" : "' + ParentARCE +'","branchId" : "' + branchId +'","bankId" : "' + bankId +'","docNumber" : "' + docNumber +'","docType" : "' + docType +'","NumClient" : "' + NumClient +'","TypeArc" : "' + TypeArc +'","NameClient" : "' +  NameClient +'","FS" : "' + finSponsor +'","eventType" : "' + eventType +'"}');
        servAndSvRes.serviceCode = iasoResponse.serviceCode;
        servAndSvRes.serviceMessage = iasoResponse.serviceMessage;
        servAndSvRes.serviceHeaders = Test.isRunningTest() || retriveMock ? serHeadTest : iasoResponse.serviceHeaders;
        return servAndSvRes;
    }

    /**
    *-------------------------------------------------------------------------------
    * @description Method that retrieves local Id from risk assessment header
    --------------------------------------------------------------------------------
    * @author javier.soto.carrascosa@bbva.com
    * @date 01/04/2020
    * @param arce.Arc_Gen_ServiceAndSaveResponse riskAss
    * @return String
    * @example private String getIdFromHeader (arce.Arc_Gen_ServiceAndSaveResponse riskAss)
    **/
    public static String getIdFromHeader (arce.Arc_Gen_ServiceAndSaveResponse riskAss) {
        final Map<String, String> header = riskAss.serviceHeaders;
        String localId = '';
        if(arce.Arc_Gen_ValidateInfo_utils.hasInfoMap(header)) {
            final String riskAssLocation = header.get('Location');
            if (arce.Arc_Gen_ValidateInfo_utils.isFilled(riskAssLocation)) {
                localId = riskAssLocation.substringAfterLast('/');
            }
        }
        return localId;
    }

    /**
    *-------------------------------------------------------------------------------
    * @description Method that retrieves wrapper response for Lightning Component.
    --------------------------------------------------------------------------------
    * @author saimassimilianno.jordana.contractor@bbva.com
    * @date 23/03/2021
    * @param arce.Arc_Gen_ServiceAndSaveResponse serAndSave
    * @param Boolean saveStatus
    * @return AdjustResponse
    **/
    public static AdjustResponse getRespAndRefresh(AdjustResponse response, arce.Arc_Gen_ServiceAndSaveResponse serAndSave, Boolean saveStatus) {
        response.refreshTab = true;
        response.saveMessage = serAndSave.saveMessage;
        response.saveStatus = saveStatus;
        response.serviceCode = serAndSave.serviceCode;
        response.serviceMessage = serAndSave.serviceMessage;
        return response;
    }

    /**
    *-------------------------------------------------------------------------------
    * @description Returns arce__Traceability_Event__c object related to CRP analysis.
    --------------------------------------------------------------------------------
    * @author saimassimilianno.jordana.contractor@bbva.com
    * @date   11/05/2021
    * @param  arce__Account_has_Analysis__c accHas
    * @return arce__Traceability_Event__c
    * @example arce__Traceability_Event__c trcEvent = getTraceEvntCRP(accHas);
    **/
    public static arce__Traceability_Event__c getTraceEvntCRP(arce__Account_has_Analysis__c accHas) {
        final arce__Traceability_Event__c currentTrcEvnt = new arce__Traceability_Event__c();
        currentTrcEvnt.arce__current_event__c = true;
        currentTrcEvnt.arce__account_has_analysis_id__c = accHas.Id;
        currentTrcEvnt.arce__gc_trcblty_internal_code_id__c = 'T-' + accHas.arce__Analysis__r.arce__parent_analysis_id__c + '-0';
        currentTrcEvnt.arce__analysis_id__c = accHas.arce__Analysis__c;
        currentTrcEvnt.arce__wkfl_stage_type__c = accHas.arce__Analysis__r.arce__Stage__c;
        currentTrcEvnt.arce__wkfl_status_stage_type__c = accHas.arce__Analysis__r.arce__wf_status_id__c;
        currentTrcEvnt.arce__anlys_wkfl_sub_process_type__c = accHas.arce__Analysis__r.arce__anlys_wkfl_sub_process_type__c;
        currentTrcEvnt.arce__audit_date__c = System.today();
        currentTrcEvnt.arce__user_audit_id__c = System.UserInfo.getUserId();
        currentTrcEvnt.arce__gf_applied_action_type__c = '1'; // Propose for IRP
        currentTrcEvnt.arce__riskAssessmentId__c = accHas.Name;

        return currentTrcEvnt;
    }

    /**
    *-------------------------------------------------------------------------------
    * @description Returns arce__rating_variables_detail__c object related to CRP analysis.
    --------------------------------------------------------------------------------
    * @author saimassimilianno.jordana.contractor@bbva.com
    * @date   11/05/2021
    * @param  accHasId Acc Has Analysis Id
    * @param  ratingId Current Rating Id
    * @return arce__rating_variables_detail__c
    * @example arce__rating_variables_detail__c ratVar = getRatnVarCRP(accHas);
    **/
    public static arce__rating_variables_detail__c getRatnVarCRP(Id accHasId, Id ratingId) {
        final arce__rating_variables_detail__c overrideVar = new arce__rating_variables_detail__c();
        overrideVar.arce__rating_id__c = ratingId;
        overrideVar.arce__account_has_analysis_id__c = accHasId;
        overrideVar.arce__rating_modifier_id__c = '02';
        overrideVar.arce__rating_modifier_adj_type__c = arce.Arc_Gen_RatingGlobal_Constants.METHOD_OVERRIDE;

        return overrideVar;
    }

    /**
    *-------------------------------------------------------------------------------
    * @description Meth0d to get ServiceAndSaveResponse for Crp flow.
    --------------------------------------------------------------------------------
    * @author saimassimilianno.jordana.contractor@bbva.com
    * @date 21/05/2021
    * @param arce__Account_has_Analysis__c header
    * @return Arc_Gen_ServiceAndSaveResponse
    **/
    public static arce.Arc_Gen_ServiceAndSaveResponse initOverrideSer (arce__Account_has_Analysis__c accHas) {
        final arce.Arc_Gen_ServiceAndSaveResponse serviceRes = new arce.Arc_Gen_ServiceAndSaveResponse();
        serviceRes.serviceCode = '200';

        final arce__Account_has_Analysis__c ahasToUpt = new arce__Account_has_Analysis__c();
        ahasToUpt.Id = accHas.Id;
        ahasToUpt.arce__rating_scale_type__c = '1';

        final arce__rating__c currentRating = ratingSp2Data.getCurrentRating(accHas.Id);

        final arce__rating_variables_detail__c overrideVar =  Arc_Gen_initAdjustment_Service.getRatnVarCRP(accHas.Id,currentRating.Id);

        final arce__Traceability_Event__c currentTrcEvnt = Arc_Gen_initAdjustment_Service.getTraceEvntCRP(accHas);

        final arce.Arc_Gen_RatingGlobal_data.SaveResult insrtResp = ratingSp2Data.insertRecords(new List<sObject> {overrideVar, ahasToUpt, currentTrcEvnt});
        serviceRes.saveStatus = insrtResp.status;
        serviceRes.saveMessage = insrtResp.message;

        return serviceRes;
    }

    /**
    *-------------------------------------------------------------------------------
    * @description Meth0d to get ServiceAndSaveResponse for Arp with no Spanish Client flow.
    --------------------------------------------------------------------------------
    * @author saimassimilianno.jordana.contractor@bbva.com
    * @date 21/05/2021
    * @param arce__Account_has_Analysis__c header
    * @return Arc_Gen_ServiceAndSaveResponse
    **/
    public static arce.Arc_Gen_ServiceAndSaveResponse isNotESPSer (arce__Account_has_Analysis__c accHas) {
        final arce.Arc_Gen_ServiceAndSaveResponse serviceRes = new arce.Arc_Gen_ServiceAndSaveResponse();
        serviceRes.serviceCode = '200';

        final arce__Account_has_Analysis__c ahas = new arce__Account_has_Analysis__c(Id = accHas.Id);
        ahas.arce__Spanish_Client__c = '0';
        ahas.arce__rating_scale_type__c = '2';

        final arce.Arc_Gen_RatingGlobal_data.SaveResult insrtResp = ratingSp2Data.insertRecords(new List<sObject> {ahas});
        serviceRes.saveStatus = insrtResp.status;
        serviceRes.saveMessage = insrtResp.message;

        return serviceRes;
    }

    /**
    *-------------------------------------------------------------------------------
    * @description Meth0d to get ServiceAndSaveResponse for Arp with no Spanish Client flow.
    --------------------------------------------------------------------------------
    * @author saimassimilianno.jordana.contractor@bbva.com
    * @date 21/05/2021
    * @param arce__Account_has_Analysis__c header
    * @return Arc_Gen_ServiceAndSaveResponse
    **/
    public static arce.Arc_Gen_ServiceAndSaveResponse isESPService (arce__Account_has_Analysis__c accHas) {
        arce.Arc_Gen_ServiceAndSaveResponse serviceRes = new arce.Arc_Gen_ServiceAndSaveResponse();
        //Call ratingEngine:ARP:CALCULATION
        serviceRes = arce.Arc_Gen_RatingGlobal_service.setupRating(accHas, null, arce.Arc_Gen_RatingGlobal_Constants.RATINGCAL);

        if(checkForValidState(serviceRes.serviceCode)) {
            final arce__Account_has_Analysis__c ahasToUpd = accHas;
            ahasToUpd.arce__Spanish_Client__c = '1';
            ahasToUpd.arce__rating_scale_type__c = '2';

            final arce.Arc_Gen_RatingGlobal_data.SaveResult insrtResp = ratingSp2Data.insertRecords(new List<sObject> {ahasToUpd});
            serviceRes.saveStatus = insrtResp.status;
            serviceRes.saveMessage = insrtResp.message;
        } else {
            serviceRes = isNotESPSer(accHas);
            serviceRes.serviceCode = '300';
            serviceRes.serviceMessage = System.Label.Arc_Gen_Switched_Standalone;
        }

        return serviceRes;
    }

    /**
    *-------------------------------------------------------------------------------
    * @description Meth0d to get ServiceAndSaveResponse for Arp with no Spanish Client flow.
    --------------------------------------------------------------------------------
    * @author saimassimilianno.jordana.contractor@bbva.com
    * @date 21/05/2021
    * @param arce__Account_has_Analysis__c header
    * @return Arc_Gen_ServiceAndSaveResponse
    **/
    public static Arc_Gen_initAdjustment_Service.AdjustResponse getRtngIdSer (String accHasId) {
        final Arc_Gen_initAdjustment_Service.AdjustResponse response = new Arc_Gen_initAdjustment_Service.AdjustResponse();
        final arce__Account_has_Analysis__c ahasTo = arce.Arc_Gen_RatingGlobal_data.getAcchasForWF(accHasId);
        final arce__rating__c currentRating = ratingSp2Data.getCurrentRating(ahasTo.Id);

        if(String.isBlank(currentRating.arce__rating_id__c)) {
            final arce.Arc_Gen_ServiceAndSaveResponse serviceRes = riskAssRatingId(ahasTo);
            final String ratingId = getIdFromHeader(serviceRes);
            currentRating.arce__rating_id__c = ratingId;

            final arce.Arc_Gen_RatingGlobal_data.SaveResult insrtResp = ratingSp2Data.insertRecords(new List<sObject> {currentRating});
            response.serviceCode = serviceRes.serviceCode;
            response.saveStatus = Boolean.valueOf(insrtResp.status);
        }
        return response;
    }
    /**
    * @description checkForValidState
    * @author amunguia.contractor@bbva.com | 05-17-2021
    * @param String statusCode
    * @return Boolean
    **/
    private static Boolean checkForValidState(String statusCode) {
        return statusCode == arce.Arc_Gen_RatingGlobal_Constants.SUCC1 || statusCode == arce.Arc_Gen_RatingGlobal_Constants.SUCC2 || statusCode == arce.Arc_Gen_RatingGlobal_Constants.SUCC3;
    }

}