/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_SP2_Multitemplate_Service
* @Author   BBVA Developers
* @Date     Created: 2020-07-13
* @Group    ARCE
* ------------------------------------------------------------------------------------------------
* @Description: Service class for communication with multitemplate service for SP2 model
* ------------------------------------------------------------------------------------------------
* @Changes
*
* |2020-07-13 BBVA Developers.
*              Class creation.
* 2021-03-24  juanpedro.benito.contractor@bbva.com
*              Add debug in callouts
* 2021-07-26  saimassimilianno.jordana.contractor@bbva.com
*              Model attribute added to callMultitmpltEngn, generateIasoParameters and processMultiTemplateResponse methods
*              to work with 2012 model.
* ------------------------------------------------------------------------------------------------
*/
public with sharing class Arc_Gen_SP2_Multitemplate_Service {
  /**
  * ----------------------------------------------------------------------------------------------------
  * @Description Custom Exception for Multitemplate SP2
  * ----------------------------------------------------------------------------------------------------
  * @Author   ivan.cons.contractor@bbva.com
  * @Date     Created: 2020-07-13
  * @example throw new MultitemplateSP2Exception('Unexpected Error');
  * ----------------------------------------------------------------------------------------------------
  **/
    public class SP2MultitemplateException extends Exception {}
  /**
  * --------------------------------------------------------------------------------------
  * @description Saves and retrieves Anchor information
  * @param aHasAnalysId Id of the account has analysis.
  * @return Returns the wrapper with the chart parameters.
  **/
  public static void callMultitmpltEngn(String aHasAnalysId, String model) {
    final String serviceName = 'multitemplateSP2';
    arce.Arc_Gen_getIASOResponse.ServiceResponse serviceAndSaveResp = new arce.Arc_Gen_getIASOResponse.ServiceResponse();
    String jsonInput = JSON.serialize(generateIasoParameters(aHasAnalysId, model));
    serviceAndSaveResp = arce.Arc_Gen_getIASOResponse.calloutIASO(serviceName,jsonInput);
    String jsonOutput = JSON.serialize(serviceAndSaveResp.serviceResponse);
    System.debug('multitemplateSP2 jsonInput ' + jsonInput);
    System.debug('multitemplateSP2 jsonOutput ' + jsonOutput);
    Arc_Gen_Wrapper_Multitemplate wrapperOutput = (Arc_Gen_Wrapper_Multitemplate) JSON.deserialize(jsonOutput,Arc_Gen_Wrapper_Multitemplate.class);
    processMultiTemplateResponse(wrapperOutput, model);
  }

  /**
  * --------------------------------------------------------------------------------------
  * @description Generates the parameters for the IASO call
  * @param aHasAnalysId Id of the account has analysis.
  * @return Returns the map with the chart parameters.
  **/
  public static Map<String,String> generateIasoParameters(String aHasAnalysId, String modelSlctd) {
    final arce__Account_has_Analysis__c aHa = arce.Arc_Gen_AccHasAnalysis_Data.getAccHasAnalysis(new List<Id> {aHasAnalysId})[0];
    final String clientId = arce.Arc_Gen_AccHasAnalysis_Data.getCorrectIdWAhas(aHa);
    final Map<Id, Arc_Gen_Account_Wrapper> mapWrap = Arc_Gen_Account_Locator.getAccountInfoById(new List<Id>{clientId});
    final String customerNumber = mapWrap.get(clientId).accNumber;
    final String customerId = Arc_Gen_CallEncryptService.getEncryptedClient(customerNumber);
    Arc_Gen_Wrapper_Multitemplate wrapper = new Arc_Gen_Wrapper_Multitemplate(aHasAnalysId,null,aHa.Name,customerId,modelSlctd);
    Map<String,String> mapa = new Map<String,String>();
    if(!wrapper.root.isEmpty()){
      String jsonInput = JSON.serialize(wrapper,true);
      mapa.put('JSONinput',jsonInput);
    }
    return mapa;
  }
  /**
  * --------------------------------------------------------------------------------------
  * @description Saves and retrieves Anchor information
  * @param aHasAnalysId Id of the account has analysis.
  * @return Returns the wrapper with the chart parameters.
  **/
  public static void processMultiTemplateResponse(Arc_Gen_Wrapper_Multitemplate response, String modelSelctd) {
    final String objectToUse = modelSelctd == '2019' ? 'arce__Activity_Split__c' : 'arce__Activity_Split_2012__c';
    Map<String, arce__Qualitative_question__mdt> questionsMap = Arc_Gen_Corporate_Utils.getAllQualitativeQuestions();
    List<sObject> acttiesToUpdate = new List<sObject>();
    if(response.data != null){
      for(Arc_Gen_Wrapper_Multitemplate.WrapperMultitemplate data : response.data) {
        String dataId = data.id?.split('/')[0];
        //arce__Activity_Split__c actty = new arce__Activity_Split__c(Id = dataId);
        Arc_Gen_Corporate_Utils.Dynamicsobject dynamic = new Arc_Gen_Corporate_Utils.Dynamicsobject();
        sObject actty = dynamic.getNewSObject(objectToUse);
        actty.put('Id', dataId);
        if(data.riskScore != null) {
          actty.put('arce__Industry_Risk__c', data.riskScore.standard);
          actty.put('arce__Final_Industry_Risk_DV__c', Arc_Gen_Corporate_Utils.getDependentValuesJSON(data.riskScore.engineScores));
        }
        for(Arc_Gen_Wrapper_Multitemplate.CompetitivePositionSection cp : data.competitivePositionSections) {
          for(Arc_Gen_Wrapper_Multitemplate.Question q: cp.questions){
            actty.put(questionsMap.get(q.Id).arce__Question_Values__c,Arc_Gen_Corporate_Utils.getDependentValuesJSON(questionsMap.get(q.Id), q.avalaibleAnswers, objectToUse));
          }
        }
        acttiesToUpdate.add(actty);
      }
    }
    if(!Test.isRunningTest()) {
      update acttiesToUpdate;
    }
  }
}