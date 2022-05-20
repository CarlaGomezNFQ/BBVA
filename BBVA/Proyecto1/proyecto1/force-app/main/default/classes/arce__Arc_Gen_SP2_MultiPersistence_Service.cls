/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_SP2_MultiPersistence_Service
* @Author   BBVA Developers
* @Date     Created: 2020-11-27
* @Group    ARCE
* ------------------------------------------------------------------------------------------------
* @Description Arc_Gen_SP2_MultiPersistence_Service
* ------------------------------------------------------------------------------------------------
* @Changes
*
* 2021-03-24    juanpedro.benito.contractor@bbva.com   add debug in callouts
* 2021-07-23    saimassimilianno.jordana.contractor@bbva.com   Model attribute added to callMultitemplateEngine,
*               processMultiTemplateResponse and generateIasoParameters methods to 2012 adaptations.
* 2021-08-10    saimassimilianno.jordana.contractor@bbva.com mainTemplte meth0d added to update the main template
*               field of the overlay related.
* 2021-09-13    amunguia.contractor@bbva.com new method to call multitemplate persistence with a single sub-industry
* -------------------------------------------------------------------------------------------------
*/
public with sharing class Arc_Gen_SP2_MultiPersistence_Service {

  /**
  * @Description: string with the model name
  */
  Static Final String MODEL_2012 = '2012';
  /**
  * @Description: string with the service name
  */
  Static Final String SERVICENAME = 'PersistenceMultitemplate';

  /**
    * ----------------------------------------------------------------------------------------------------
    * @Description Void Constructor to avoid warning in sonar qube
    * ----------------------------------------------------------------------------------------------------
    * @Author   ivan.cons.contractor@bbva.com
    * @Date     Created: 2020-09-15
    * @param void
    * @return void
    * @example Arc_Gen_SP2_MultiPersistence_Service data = new Arc_Gen_SP2_MultiPersistence_Service();
    * ----------------------------------------------------------------------------------------------------
    **/
    @TestVisible
    private Arc_Gen_SP2_MultiPersistence_Service() {

    }

    /**
    *-------------------------------------------------------------------------------
    * @description Wrapper used to describe the parameters to be provided to the service.
    *-------------------------------------------------------------------------------
    **/
    private class PMParamSet {
      /**
      * @Description: Unique risk assessment identifier.
      */
      private String riskAssessmentId { get; set; }
      /**
      * @Description: Unique participant identifier.
      */
      private String participantId { get; set; }
      /**
      * @Description: JSON object to be provided to the service in the request body.
      */
      private String jsonInput { get; set; }
  }

  /**
  * ----------------------------------------------------------------------------------------------------
  * @Description Custom Exception for Multitemplate SP2
  * ----------------------------------------------------------------------------------------------------
  * @Author   ivan.cons.contractor@bbva.com
  * @Date     Created: 2020-07-13
  * @example throw new MultitemplateSP2Exception('Unexpected Error');
  * ----------------------------------------------------------------------------------------------------
  **/
  public class SP2MultitemplateException extends Exception {}//NOSONAR
  /**
  * --------------------------------------------------------------------------------------
  * @description Saves and retrieves Anchor information
  * @param aHasAnalysId Id of the account has analysis.
  * @return Returns the wrapper with the multitemplate parameters.
  **/
  public static Arc_Gen_Wrapper_Multitemplate callMultitemplateEngine(String aHasAnalysId, String model) {
    final arce__Account_has_Analysis__c accHasAnalysis = arce.Arc_Gen_AccHasAnalysis_Data.getAccHasAnalysis(new List<String>{aHasAnalysId})[0];
    final String clientId = arce.Arc_Gen_AccHasAnalysis_Data.getCorrectIdWAhas(accHasAnalysis);
    final arce.Arc_Gen_Account_Wrapper accWrapper = arce.Arc_Gen_Account_Locator.getAccountInfoById(new List<Id> { clientId }).get(clientId);
    final String customerNumber = arce.Arc_Gen_CallEncryptService.getEncryptedClient(accWrapper.accNumber);
    Arc_Gen_getIASOResponse.ServiceResponse serviceAndSaveResp = new Arc_Gen_getIASOResponse.ServiceResponse();
    final PMParamSet serviceParams = new PMParamSet();
    serviceParams.participantId = customerNumber;
    serviceParams.riskAssessmentId = accHasAnalysis.Name;
    serviceParams.jsonInput = generateIasoParameters(aHasAnalysId, model);
    final String jsonInput = JSON.serialize(serviceParams);
    serviceAndSaveResp = arce.Arc_Gen_getIASOResponse.calloutIASO(SERVICENAME,jsonInput);
    final Arc_Gen_Wrapper_Multitemplate respMultitemp = processMultiTemplateResponse(serviceAndSaveResp, aHasAnalysId, model);
    System.debug('PersistenceMultitemplate jsonInput ' + jsonInput);
    System.debug('PersistenceMultitemplate serviceAndSaveResp ' + serviceAndSaveResp);
    Return respMultitemp;
  }
  /**
  * --------------------------------------------------------------------------------------
  * @description Generates the parameters for the IASO call
  * @param aHasAnalysId Id of the account has analysis.
  * @return Returns the map with the chart parameters.
  **/
  public static String generateIasoParameters(String aHasAnalysId, String model) {
    final Arc_Gen_Wrapper_Multitemplate wrapper = new Arc_Gen_Wrapper_Multitemplate(aHasAnalysId,  model);
    return JSON.serialize(wrapper,true);
  }
  /**
  * --------------------------------------------------------------------------------------
  * @description Saves and retrieves Anchor information
  * @param aHasAnalysId Id of the account has analysis.
  * @return Returns the wrapper with the chart parameters.
  **/
  public static Arc_Gen_Wrapper_Multitemplate processMultiTemplateResponse(Arc_Gen_getIASOResponse.ServiceResponse multiTempResp, String ahaId, String modelSlctd) {
    final String empty;
    final Arc_Gen_Wrapper_Multitemplate respData = new Arc_Gen_Wrapper_Multitemplate(ahaId, empty, modelSlctd);
    if (multiTempResp.serviceCode == '201' || multiTempResp.serviceCode == '200' ) {
      final Map<String,Object> responseMap = multiTempResp.serviceResponse;

      final Object listServiceResp = (Object)responseMap.get('data');
      //Once the service is active, this method should end
      final List<Arc_Gen_Wrapper_Multitemplate.WrapperMultitemplate> data = (List<Arc_Gen_Wrapper_Multitemplate.WrapperMultitemplate>)listServiceResp;//NOSONAR
      if (modelSlctd == MODEL_2012) {
        mainTemplte(ahaId);
      }
    } else {
      //this exception is sent to Arc_Gen_AnalysisSummary_Controller.callMultiPersistenceEngine and it's painted in the catch
      throw new SP2MultitemplateException(multiTempResp.serviceCode + ' - ' + multiTempResp.serviceMessage);
    }
    return respData;
  }

  /**
  * --------------------------------------------------------------------------------------
  * @description Update the main template field of the overlay related.
  * @param aHasAnalysId Id of the account has analysis.
  * @return n/a
  **/
  public static void mainTemplte(String aHasAnalysId) {
    Decimal maxPerctg = 0;
    final Set<String> parentIdSet = new Set<String>();
    parentIdSet.add(aHasAnalysId);
    final Id overlayId = Arc_Gen_Overlays_Utils.getOverlaysByAha(parentIdSet)[0].Id;
    final arce__Overlay__c overlay = new arce__Overlay__c(Id = overlayId);
    final List<arce__Activity_Split_2012__c> lstActSplit = Arc_Gen_Activities_Util.getAllActByParent2012(parentIdSet);

    for(arce__Activity_Split_2012__c aSplit : lstActSplit) {
      if (aSplit.arce__gf_subindustry_weight_per__c > maxPerctg) {
        overlay.arce__Arc_Gen_Main_Template__c = aSplit.arce__Template_type__c;
        maxPerctg = aSplit.arce__gf_subindustry_weight_per__c;
      }
    }

    try {
      update overlay;
    } catch (Exception e) {
      System.debug('::::::-ERROR-::::: OVERLAY RECORD HAS NOT BEEN UPDATED -> ' + e.getMessage());
    }

  }
  /**
  * --------------------------------------------------------------------------------------
  * @description Saves and retrieves Anchor information
  * @param aHasAnalysId Id of the account has analysis.
  * @return Returns the wrapper with the multitemplate parameters.
  **/
  public static  Arc_Gen_getIASOResponse.ServiceResponse callSpecificMultitemplate(SObject actty, String model) {
    final arce__Account_has_Analysis__c accHasAnalysis = arce.Arc_Gen_AccHasAnalysis_Data.getAccHasAnalysis(new List<String>{(String)actty.get('arce__Account_has_Analysis__c')})[0];
    final String clientId = arce.Arc_Gen_AccHasAnalysis_Data.getCorrectIdWAhas(accHasAnalysis);
    final arce.Arc_Gen_Account_Wrapper accWrapper = arce.Arc_Gen_Account_Locator.getAccountInfoById(new List<Id> { clientId }).get(clientId);
    final String customerNumber = arce.Arc_Gen_CallEncryptService.getEncryptedClient(accWrapper.accNumber);
    Arc_Gen_getIASOResponse.ServiceResponse response = new Arc_Gen_getIASOResponse.ServiceResponse();
    final PMParamSet serviceParams = new PMParamSet();
    serviceParams.participantId = customerNumber;
    serviceParams.riskAssessmentId = accHasAnalysis.Name;
    serviceParams.jsonInput = JSON.serialize(new Arc_Gen_Wrapper_Multitemplate(actty), true);
    final String jsonInput = JSON.serialize(serviceParams);
    response = arce.Arc_Gen_getIASOResponse.calloutIASO(SERVICENAME,jsonInput);
    System.debug('PersistenceMultitemplate jsonInput ' + jsonInput);
    System.debug('PersistenceMultitemplate response ' + response);
    return response;
  }
}