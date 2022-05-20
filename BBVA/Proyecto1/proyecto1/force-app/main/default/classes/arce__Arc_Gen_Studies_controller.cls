/**
* @File Name          : Arc_Gen_Studies_controller.cls
* @Description        : Controller class for Arc_Gen_StudiesSP2.cmp
* @Author             : juanpedro.benito.contractor@bbva.com
* @Group              : ARCE Team
* @Last Modified By   : juanpedro.benito.contractor@bbva.com
* @Last Modified On   : 29-04-2021
* @Changes
*==============================================================================
* Ver         Date                     Author                 Modification
*==============================================================================
* 1.0    29-04-2021  juanpedro.benito.contractor@bbva.com     Initial Version
**/
public class Arc_Gen_Studies_controller {
  /**
  * @Description: name of ratings service
  */
  final static String SERVICENAME = 'ratingsSP2';
  /**
  *-------------------------------------------------------------------------------
  * @Description constructor
  *--------------------------------------------------------------------------------
  * @ Author juanpedro.benito.contractor@bbva.com
  * @ Date   Created: 29-04-2021
  *--------------------------------------------------------------------------------
  **/
  @TestVisible
  private Arc_Gen_Studies_controller() {

  }
  /**
  *-------------------------------------------------------------------------------
  * @Description method getJsonTable
  *--------------------------------------------------------------------------------
  * @ Author juanpedro.benito.contractor@bbva.com
  * @ Date   Created: 29-04-2021
  *--------------------------------------------------------------------------------
  **/
  @AuraEnabled
  // public static List<Arc_Gen_Wrapper_RatingSP2.StudiesAuraWrapper> getJsonTable(Id analysisId) {
  public static Map<String, Object> getJsonTable(Id analysisId) {
    Map<String, Object> ret = new Map<String, Object>();
    try {
      String clientId;
      if(analysisId.getSobjectType().getDescribe().getName().equals(arce__Account_has_Analysis__c.sObjectType.getDescribe().getName())) {
        final arce__Account_has_Analysis__c accHasAnalysis = arce.Arc_Gen_AccHasAnalysis_Data.getAccHasAnalysis(new List<String>{analysisId})[0];
        clientId = arce.Arc_Gen_AccHasAnalysis_Data.getCorrectIdWAhas(accHasAnalysis);
      } else {
        clientId = analysisId;
      }
      final arce.Arc_Gen_Account_Wrapper accWrapper = arce.Arc_Gen_Account_Locator.getAccountInfoById(new List<Id> { clientId }).get(clientId);
      final String customerNumber = arce.Arc_Gen_CallEncryptService.getEncryptedClient(accWrapper.accNumber);
      Arc_Gen_Wrapper_RatingSP2.WrapperRatingSP2 tempObj = callRatingEngine(customerNumber);
      ret.put('oldObj', JSON.serialize(tempObj));
      ret.put('newObj', tempObj.data != null ? createDataWrapper(tempObj) : new List<Arc_Gen_Wrapper_RatingSP2.StudiesAuraWrapper>());
    } catch (Exception e) {
      throw new AuraHandledException(System.label.Arc_Gen_HandleErrors_Ratings + e + analysisId);
    }
    return ret;
  }
  /**
  *-------------------------------------------------------------------------------
  * @Description method getJsonTable
  *--------------------------------------------------------------------------------
  * @ Author juanpedro.benito.contractor@bbva.com
  * @ Date   Created: 29-04-2021
  *--------------------------------------------------------------------------------
  **/
  private static Arc_Gen_Wrapper_RatingSP2.WrapperRatingSP2 callRatingEngine(String analysisId) {
    arce.Arc_Gen_getIASOResponse.ServiceResponse servAndResp = new arce.Arc_Gen_getIASOResponse.ServiceResponse();
    final String jsonInput = '{"isCurrent":"false","businessId":"'+analysisId+'"}';
    servAndResp = arce.Arc_Gen_getIASOResponse.calloutIASO(SERVICENAME, jsonInput);
    String jsonOutput = JSON.serialize(servAndResp.serviceResponse);
    jsonOutput = jsonOutput.replace('"number":', '"number_x":');
    System.debug('ratingsSP2 jsonInput ' + jsonInput);
    System.debug('ratingsSP2 jsonOutput ' + jsonOutput);
    final Arc_Gen_Wrapper_RatingSP2.WrapperRatingSP2 wrapperOutput = (Arc_Gen_Wrapper_RatingSP2.WrapperRatingSP2) JSON.deserialize(jsonOutput,Arc_Gen_Wrapper_RatingSP2.WrapperRatingSP2.class);
    System.debug('ratingsSP2 wrapperOutput ' + wrapperOutput);
    return wrapperOutput;
  }

  private static List<Arc_Gen_Wrapper_RatingSP2.StudiesAuraWrapper> createDataWrapper(Arc_Gen_Wrapper_RatingSP2.WrapperRatingSP2 rawData) {
    List<Arc_Gen_Wrapper_RatingSP2.StudiesAuraWrapper> ret = new List<Arc_Gen_Wrapper_RatingSP2.StudiesAuraWrapper>();
    Arc_Gen_Wrapper_RatingSP2.StudiesAuraWrapper retElement;

    for(Arc_Gen_Wrapper_RatingSP2.FF_SS ffss : rawData.data){
      if('RA'.equals(ffss.originApplication?.id)){
        retElement = createRADataWrapper(ffss);
      }else{
        retElement = createARCEDataWrapper(ffss);
      }
      ret.add(retElement);
    }
    return ret;
  }


  private static Arc_Gen_Wrapper_RatingSP2.StudiesAuraWrapper createRADataWrapper(Arc_Gen_Wrapper_RatingSP2.FF_SS ffss) {
    return new Arc_Gen_Wrapper_RatingSP2.StudiesAuraWrapper();
  }

  private static Arc_Gen_Wrapper_RatingSP2.StudiesAuraWrapper createARCEDataWrapper(Arc_Gen_Wrapper_RatingSP2.FF_SS ffss) {
    List<Arc_Gen_Wrapper_RatingSP2.StudiesAuraWrapper> ret = new List<Arc_Gen_Wrapper_RatingSP2.StudiesAuraWrapper>();
    Arc_Gen_Wrapper_RatingSP2.StudiesAuraWrapper retElement;

    retElement = new Arc_Gen_Wrapper_RatingSP2.StudiesAuraWrapper();
    retElement.id = ffss.id;
    retElement.evalDate = ffss.evaluationDate.substring(0,10);
    if(ffss.templates != null){
      populateWithTemplates(retElement, ffss.templates.clone());
    }
    if(ffss.financialStatement != null){
      populateWithFFSSInfo(retElement, ffss.financialStatement);
    }
    if(ffss.subRatings != null){
      populateWithSubRatingInfo(retElement, ffss.subRatings);
    }
    if(ffss.adjustments != null){
      populateWithAdjustmentsInfo(retElement, ffss.adjustments);
    }
    if(ffss.variables != null){
      populateWithVariables(retElement, ffss.variables);
    }
    return retElement;
  }

  private static void populateWithTemplates(Arc_Gen_Wrapper_RatingSP2.StudiesAuraWrapper target, List<Arc_Gen_Wrapper_RatingSP2.Templates> source) {

    for(Arc_Gen_Wrapper_RatingSP2.Templates template : source) {
      final String objecToUse = Integer.valueOf(template.id) >= 101 ? 'arce__Activity_Split_2012__c' : 'arce__Activity_Split__c';
      template.id = Arc_Gen_GenericUtilities.getPicklistLabels(objecToUse,'arce__Template_type__c').get(template.id);
      if(template.country != null) {
        template.country.id = objecToUse == 'arce__Activity_Split_2012__c' ? Arc_Gen_GenericUtilities.getPicklistLabels('arce__Activity_Split_2012__c','arce__Country__c').get(template.country.id) : template.country.id;
      }
      if(template.subindustry != null) {
        template.subindustry.id = objecToUse == 'arce__Activity_Split_2012__c' ? Arc_Gen_GenericUtilities.getPicklistLabels('arce__Activity_Split_2012__c','arce__gf_subactivity_id__c').get(template.subindustry.id) : template.subindustry.id;
      }
    }
    target.templates = source;
  }

  private static void populateWithVariables(Arc_Gen_Wrapper_RatingSP2.StudiesAuraWrapper target, List<Arc_Gen_Wrapper_RatingSP2.variables> source) {
    for(Arc_Gen_Wrapper_RatingSP2.variables variable : source) {
      switch on variable.id {
        when 'FF00001002' {
          target.finanFlexRiskScore = variable.score.value;
        }
        when 'DA00002001' {
          target.diverAdjustm = variable.score.value;
        }
      }
    }
  }

  private static void populateWithFFSSInfo(Arc_Gen_Wrapper_RatingSP2.StudiesAuraWrapper target, Arc_Gen_Wrapper_RatingSP2.FinancialStatement source){
    target.shortId = source.id.replaceAll('^0+', '');
    if (source.period != null) {
      target.months = source.period.number_x;
      target.validity = source.period.startDate;
      target.endDate = source.period.endDate;
      target.evaluationDate = source.period.startDate;
    }
    if (source.certification != null) {
      target.certification = source.certification.certificationType;
    }
    if (source.audit != null && source.audit.auditor != null) {
      target.audit = source.audit.auditor.opinion;
    }
    if (source.financialStatementType != null) {
      target.ffssType = source.financialStatementType.id;
    }
    target.adjustment = source.adjustedIndicator;
  }

  private static void populateWithSubRatingInfo(Arc_Gen_Wrapper_RatingSP2.StudiesAuraWrapper target, List<Arc_Gen_Wrapper_RatingSP2.SubRatings> source){
    for(Arc_Gen_Wrapper_RatingSP2.SubRatings subRating : source){
      if (subRating.ratingType != null) {
        switch on subRating.ratingType.id {
          when 'FINAL' {
            target.model = subRating.tool != null ? subRating.tool.id : null;
            target.finalScore = subRating.score;
            target.finalLong = subRating.longScaleValue;
            target.scale = subRating.longScaleValue;
            findValidator(target, subRating.businessAgents.clone());
          }
          when 'ANCHOR' {
            target.anchorScore = subRating.score;
            target.anchorLong = subRating.longScaleValue;
          }
          when 'STANDALONE' {
            target.standaloneScore = subRating.score;
            target.standaloneLong = subRating.longScaleValue;
          }
          when 'OVERLAY' {
            target.overlaysScore = subRating.score;
            target.overlaysLong = subRating.longScaleValue;
            findFinalizer(target, subRating.businessAgents, false);
          }
          when 'OVERRIDE' {
            target.overrideRating = subRating.score;
            findFinalizer(target, subRating.businessAgents, true);
          }
        }
      }
    }
  }

  private static void findValidator(Arc_Gen_Wrapper_RatingSP2.StudiesAuraWrapper target, List<Arc_Gen_Wrapper_RatingSP2.BusinessAgents> source) {
    Arc_Gen_Wrapper_RatingSP2.BusinessAgents bussAgent;
    Boolean found = false;
    while(source != null && !source.isEmpty() && !found){
      bussAgent = source.remove(0);
      found = bussAgent.businessAgentType != null && 'RATING_VALIDATOR'.equals(bussAgent.businessAgentType.id);
    }
    target.validated = found ? bussAgent.id : null;
  }

  private static void findFinalizer(Arc_Gen_Wrapper_RatingSP2.StudiesAuraWrapper target, List<Arc_Gen_Wrapper_RatingSP2.BusinessAgents> bsnssAgentList, Boolean priority){
    if(priority){
      target.finalizedBy = bsnssAgentList != null && !bsnssAgentList.isEmpty() ? String.isNotBlank(bsnssAgentList.get(0).id) ? bsnssAgentList.get(0).id : target.finalizedBy : target.finalizedBy;
    }else{
      target.finalizedBy = bsnssAgentList != null && !bsnssAgentList.isEmpty() ? String.isBlank(target.finalizedBy) ? bsnssAgentList.get(0).id : target.finalizedBy : target.finalizedBy;
    }
  }

  private static void populateWithAdjustmentsInfo(Arc_Gen_Wrapper_RatingSP2.StudiesAuraWrapper target, List<Arc_Gen_Wrapper_RatingSP2.Adjustments> source){
    target.adjustments = new List<Arc_Gen_Wrapper_RatingSP2.Adjustments>();
    for(Arc_Gen_Wrapper_RatingSP2.Adjustments adj : source){
      switch on adj.adjustmentType.id {
        when 'MODIFIER' {
          target.adjustments.add(adj);
        }
        when 'OVERLAY' {
          if(adj.modifier != null){
            populateWithModifierInfo(target, adj);
          }
        }
        when 'OVERRIDE' {
          if(adj.modifier != null){
            target.reason = adj.reason;
          }
        }
      }
    }
  }

  private static void populateWithModifierInfo(Arc_Gen_Wrapper_RatingSP2.StudiesAuraWrapper target, Arc_Gen_Wrapper_RatingSP2.Adjustments source) {
    switch on source.modifier.id {
      when '01' {
        target.gre = source.longScaleValue;
      }
      when '02' {
        target.parentAd = source.longScaleValue;
      }
      when '03' {
        target.soveCap = source.longScaleValue;
      }
      when '04' {
        target.wl = source.longScaleValue;
      }

    }
  }
}