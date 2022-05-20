/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_initAdjustment_Controller
* @Author   saimassimilianno.jordana.contractor@bbva.com
* @Date     Created: 2021-03-02
* @Group    ARCE
* ------------------------------------------------------------------------------------------------
* @Description: Controller for the Arc_Gen_AnalysisSummary cmp.
* ------------------------------------------------------------------------------------------------
* @Changes
* |2021-03-02 saimassimilianno.jordana.contractor@bbva.com
*             Class creation
* |2021-05-11 saimassimilianno.jordana.contractor@bbva.com
*             Build arce__Traceability_Event__c in initFromOverride meth0d for CRP.
* |2021-05-21 saimassimilianno.jordana.contractor@bbva.com
*             Refactor class to get ratingId to all flows.
* |2021-05-27 amunguia.contractor@bbva.com
*             the GCP rating for overlay is calculated
* ------------------------------------------------------------------------------------------------
*/
@SuppressWarnings('sf:TooManyMethods')
public with sharing class Arc_Gen_initAdjustment_Controller {

    /**
    * --------------------------------------------------------------------------------------
    * Constructor
    **/
    @TestVisible
    private Arc_Gen_initAdjustment_Controller() {}

    /**
    * --------------------------------------------------------------------------------------
    * @description Init meth0d to get data from client and recognize if it is spanish or not.
    * @param aHasAnalysId Id of the account has analysis.
    * @return Returns the wrapper with services and save response results.
    **/
    @AuraEnabled
    public static Arc_Gen_initAdjustment_Service.AdjustResponse clientInfo(String aHasAnalysId) {
        arce.Arc_Gen_ServiceAndSaveResponse serviceResponse = new arce.Arc_Gen_ServiceAndSaveResponse();
        Arc_Gen_initAdjustment_Service.AdjustResponse response = new Arc_Gen_initAdjustment_Service.AdjustResponse();

        final arce__Account_has_Analysis__c ahasTo = arce.Arc_Gen_RatingGlobal_data.getAcchasForWF(aHasAnalysId);

        if (String.isBlank(ahasTo.arce__Spanish_Client__c) && ahasTo.arce__IRP_Workflow__c == System.Label.Arc_Gen_NewRaipAdjustmentApi) {
            //ARP Flow
            final String clientId = arce.Arc_Gen_AccHasAnalysis_Data.getCorrectIdWAhas(ahasTo);
            final arce.Arc_Gen_Account_Wrapper mapWrap = arce.Arc_Gen_Account_Locator.getAccountInfoById(new List<Id>{clientId}).get(clientId);

            if (mapWrap.country.containsIgnoreCase('ES') || (Test.isRunningTest() && mapWrap.name.containsIgnoreCase('ES'))) {
                //Is Spanish Client
                //Call rissAssessment to get RatingId and ratingEngine (ARP:Calculation) to get standalone data.
                serviceResponse = isESPClient(ahasTo);
                response = Arc_Gen_initAdjustment_Service.getRespAndRefresh(response,serviceResponse,Boolean.valueOf(serviceResponse.saveStatus));
            } else {
                //Is Not Spanish Client
                //Call rissAssessment to get RatingId.
                serviceResponse = isNotESPClient(ahasTo);
                response = Arc_Gen_initAdjustment_Service.getRespAndRefresh(response,serviceResponse,Boolean.valueOf(serviceResponse.saveStatus));
            }
            if(checkForValidState(response.serviceCode)) {
                updateOverlayObject(ahasTo);
            }
        } else if (String.isBlank(ahasTo.arce__rating_scale_type__c) && ahasTo.arce__IRP_Workflow__c == System.Label.Arc_Gen_NewRaipOverrideApi) {
            //CRP Flow
            serviceResponse = initFromOverride(ahasTo);
            response = Arc_Gen_initAdjustment_Service.getRespAndRefresh(response,serviceResponse,Boolean.valueOf(serviceResponse.saveStatus));
        }

        return response;
    }

    /**
    * --------------------------------------------------------------------------------------
    * @description Init meth0d to get ratingId with riskAssessment service.
    * @param aHasAnalysId Id of the account has analysis.
    * @return AdjustResponse - Returns the wrapper with services and save response results.
    **/
    @AuraEnabled
    public static Arc_Gen_initAdjustment_Service.AdjustResponse getRtngIdRiskAss(String aHasAnalysId) {
        Arc_Gen_initAdjustment_Service.AdjustResponse response = new Arc_Gen_initAdjustment_Service.AdjustResponse();
        try {
            response = Arc_Gen_initAdjustment_Service.getRtngIdSer(aHasAnalysId);
        } catch(Exception ex) {
            response.saveStatus = Boolean.valueOf(arce.Arc_Gen_RatingGlobal_Constants.FALSE_TEXT);
            response.saveMessage = ex.getMessage();
            System.debug('ERROR :: arce.Arc_Gen_initAdjustment_Controller.getRtngIdRiskAss :: '+ex.getMessage());
            System.debug('ERROR :: arce.Arc_Gen_initAdjustment_Controller.getRtngIdRiskAss :: '+ex.getStackTraceString());
        }

        return response;
    }


    /**
    * --------------------------------------------------------------------------------------
    * @description Call ratingEngine:ARP:CALCULATION to get client standalone data.
    * @param aHas Account has analysis object.
    * @return Returns ServiceAndSaveResponse wrapper.
    **/
    public static arce.Arc_Gen_ServiceAndSaveResponse isESPClient(arce__Account_has_Analysis__c aHas) {
        arce.Arc_Gen_ServiceAndSaveResponse serviceRes = new arce.Arc_Gen_ServiceAndSaveResponse();

        try {
            serviceRes = Arc_Gen_initAdjustment_Service.isESPService(aHas);
        } catch(Exception ex) {
            serviceRes.saveStatus = arce.Arc_Gen_RatingGlobal_Constants.FALSE_TEXT;
            serviceRes.saveMessage = ex.getMessage();
            System.debug('ERROR :: arce.Arc_Gen_initAdjustment_Controller.isESPClient :: '+ex.getMessage());
            System.debug('ERROR :: arce.Arc_Gen_initAdjustment_Controller.isESPClient :: '+ex.getStackTraceString());
        }

        return serviceRes;
    }

    /**
    * --------------------------------------------------------------------------------------
    * @description Call riskAssessment:RATING service to get RatingId.
    * @param accHas Account has analysis object.
    * @return Returns ServiceAndSaveResponse wrapper.
    **/
    public static arce.Arc_Gen_ServiceAndSaveResponse isNotESPClient(arce__Account_has_Analysis__c accHas) {
        arce.Arc_Gen_ServiceAndSaveResponse serviceRes = new arce.Arc_Gen_ServiceAndSaveResponse();
        try {
            serviceRes = Arc_Gen_initAdjustment_Service.isNotESPSer(accHas);
        } catch (Exception ex) {
            serviceRes.saveStatus = arce.Arc_Gen_RatingGlobal_Constants.FALSE_TEXT;
            serviceRes.saveMessage = ex.getMessage();
            System.debug('ERROR :: arce.Arc_Gen_initAdjustment_Controller.isNotESPClient :: '+ex.getMessage());
            System.debug('ERROR :: arce.Arc_Gen_initAdjustment_Controller.isNotESPClient :: '+ex.getStackTraceString());
        }


        return serviceRes;
    }

    /**
    * --------------------------------------------------------------------------------------
    * @description Call riskAssessment:RATING service to get RatingId.
    * @param accHas Account has analysis object.
    * @return Returns ServiceAndSaveResponse wrapper.
    **/
    public static arce.Arc_Gen_ServiceAndSaveResponse initFromOverride (arce__Account_has_Analysis__c accHas) {
        arce.Arc_Gen_ServiceAndSaveResponse serviceRes = new arce.Arc_Gen_ServiceAndSaveResponse();

        try {
            serviceRes = Arc_Gen_initAdjustment_Service.initOverrideSer(accHas);
        } catch (Exception ex) {
            serviceRes.saveStatus = arce.Arc_Gen_RatingGlobal_Constants.FALSE_TEXT;
            serviceRes.saveMessage = ex.getMessage();
            System.debug('ERROR :: arce.Arc_Gen_initAdjustment_Controller.initFromOverride :: '+ex.getMessage());
            System.debug('ERROR :: arce.Arc_Gen_initAdjustment_Controller.initFromOverride :: '+ex.getStackTraceString());
        }

        return serviceRes;
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
    /**
    * @description update overlay object
    * @author amunguia.contractor@bbva.com | 05-27-2021
    * @param arce__Account_has_Analysis__c aHa
    **/
    private static void updateOverlayObject(arce__Account_has_Analysis__c aHa) {
        final arce__Overlay__c overlayObj = arce.Arc_Gen_Overlays_Utils.getOverlaysByAha(new Set<String>{aHa.Id})[0];
        if(!String.isBlank(overlayObj.arce__Arc_Gen_LocalId_VC__c)) {
          final Set<String> cclients = new Set<String>();
          final List<dyfr__Dependent_value__c> localIdList = (List<dyfr__Dependent_value__c>) JSON.deserialize(overlayObj.arce__Arc_Gen_LocalId_VC__c, List<dyfr__Dependent_value__c>.class);
          for(dyfr__Dependent_value__c dependent : localIdList) {
              cclients.addAll(dependent.dyfr__LoV_values__c.split(','));
          }
          arce.Arc_Gen_Overlays_Utils.updateOverlayObject(aHa.Id, JSON.serialize(cclients), overlayObj);
        }
      }
}