/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_SaveRatingSP2
* @Author   jose.hijar.contractor@bbva.com
* @Date     Created: 2020-11-27
* @Group    ARCE
* ------------------------------------------------------------------------------------------------
* @Description: Class that manages dyanmic form save for Rating for SP2
* ------------------------------------------------------------------------------------------------
* @Changes
*
* |2020-11-27 jose.hijar.contractor@bbva.com
*              Class creation.
* |2020-04-22 saimassimilianno.jordana.contractor@bbva.com
*             Add new condition to if() into getOverrideResponse meth0d to get correct response.
* |2021-05-13 saimassimilianno.jordana.contractor@bbva.com
*             get ffssId from fieldConfig to use in override flow.
* |2021-07-08 ivan.consr@bbva.com
*             fixed bug scale is not got in processVariables method
* ------------------------------------------------------------------------------------------------
*/
global class Arc_Gen_SaveRatingSP2 implements dyfr.Save_Interface {


  //private Arc_Gen_SaveRatingSP2(){}

  global String save(List<sObject> listObject) {
    Arc_Gen_wrpSave succesOR;
    if(!listObject.isEmpty()) {
      succesOR = processVariables(listObject);
    }
    return JSON.serialize(new Arc_Gen_wrpSave(succesOR.validated,succesOR.message,listObject));
  }


  /**
  *-------------------------------------------------------------------------------
  * @description Processing Variables gotten from Dynamic Form.
  *--------------------------------------------------------------------------------
  * @date   14/05/2021
  * @author saimassimilianno.jordana.contractor@bbva.com
  * @param  List<sObject> : listObjct
  * @return Arc_Gen_wrpSave : Wrapper of response
  * @example  Arc_Gen_wrpSave res = processVariables(listObjct);
  */
  private Arc_Gen_wrpSave processVariables(List<sObject> listObjct) {
    Id ahaId;
    String ffssId;
    String scale;
    String sObjectName;
    arce__Analysis__c analysis;
    final List<String> ahaIdList = new List<String>();
    //String errorConstant = arce.Arc_Gen_RatingGlobal_Constants.PERM_ERROR; //wiggum-bot  major fix
    List<arce__Account_has_Analysis__c> ahaList = new List<arce__Account_has_Analysis__c> ();
    final List<arce__rating_variables_detail__c> rvdList = new List<arce__rating_variables_detail__c>();
    for(sObject obj : listObjct) {
      sObjectName = obj.getSObjectType().getDescribe().getName();
      if(sObjectName.equals(arce__Account_has_Analysis__c.sObjectType.getDescribe().getName())) {
        ahaId = (Id)obj.get('Id');

        // Validate if Overlay was calculated.
        checkPermssn(ahaId);
        scale = (String)obj.get('arce__rating_scale_type__c');
        analysis = Arc_Gen_ArceAnalysis_Data.gerArce((String)ahaId);//Safe reference(dependencies)
        ahaIdList.add((String)ahaId);
      } else if(sObjectName.equals(arce__rating_variables_detail__c.sObjectType.getDescribe().getName())) {
        rvdList.add((arce__rating_variables_detail__c)obj);
      } else if(sObjectName.equals(arce__Financial_Statements__c.sObjectType.getDescribe().getName())) {
        ffssId = (String)obj.get('arce__financial_statement_id__c');
        ffssId = String.isBlank(ffssId) ? '' : ffssId.leftPad(22,'0');
        obj.put('arce__financial_statement_id__c',ffssId);
      }
    }
    ahaList = arce.Arc_Gen_AccHasAnalysis_Data.getAccHasAnalysis(ahaIdList);
    ahaList[0].arce__rating_scale_type__c = scale;
    if(ahaList[0].arce__IRP_Workflow__c == System.Label.Arc_Gen_NewRaipOverrideApi && String.isNotBlank(ffssId)) {
      ahaList[0].arce__ffss_for_rating_id__r.arce__financial_statement_id__c = ffssId;
    }
    return getOverrideResponse(ahaList[0], rvdList, analysis);
  }

  /**
  *-------------------------------------------------------------------------------
  * @description evaluateIdentification
  *--------------------------------------------------------------------------------
  * @date   15/01/2020
  * @author juanignacio.hita.contractor@bbva.com
  * @param  Id : accHasAnalysisId
  * @param  Object : wrapper
  * @param  String : userId
  * @return String : JSON serialize of the delegation wrapper
  * @example  String res = evaluateIdentification(accHasId, wrapper, userId);
  */
  private Arc_Gen_wrpSave getOverrideResponse(arce__Account_has_Analysis__c aha, List<arce__rating_variables_detail__c> rvdList, arce__Analysis__c analysis) {
    /*
    ahaIdList        ->      set de id's de accountHasAnalysis a procesar
    ahaList      ->      lista de objetos accountHasAnalysis a procesar
    rvdList      ->      lista de ratingVariablesDetail a procesar
    analysis        ->        Analysis asociado al accountHasAnalysis en contexto

    */
    Arc_Gen_wrpSave response;
    if(analysis.isSet('Id')) {
      switch on analysis.arce__Stage__c {
        when '1' {
          response = new Arc_Gen_wrpSave(true,'',null);
        }
        when '2' {
          if (aha.arce__IRP_Workflow__c == System.Label.Arc_Gen_NewRaipRatingApi && rvdList[0].arce__adj_long_rating_value_type__c == null && rvdList[0].arce__adj_short_rating_value_type__c == null) {
            response = new Arc_Gen_wrpSave(true,'',null);
          } else {
            response = Arc_Gen_OverRideSP2_Service.persistOR(aha, rvdList, true);
          }
        }
      }
    }
    return response;
  }

  /**
  *-------------------------------------------------------------------------------
  * @description Clears leveraged test results if rating override changes.
  *--------------------------------------------------------------------------------
  * @date   31/07/2020
  * @author joseluis.garcia4.contractor@bbva.com
  * @param  ahaId Id of the account has analysis
  * @param  rvdList List of rating variables included in the dynamic form
  * @return String : JSON serialize of the delegation wrapper
  */
  /*
  private static void clearLeveragedIfOverrideChanged(Id ahaId, List<arce__rating_variables_detail__c> rvdList) {
    final List<arce__rating_variables_detail__c> varList = arce.Arc_Gen_Rating_Var_detail_Data.getOverrideVariable(ahaId);
    if (!varList.isEmpty()) {
      final arce__rating_variables_detail__c oldOverrideVar = varList[0];
      for (arce__rating_variables_detail__c newVar : rvdList) {
        if (newVar.Id == oldOverrideVar.Id && newVar.arce__adj_long_rating_value_type__c != oldOverrideVar.arce__adj_long_rating_value_type__c) {
          //Arc_Gen_TestLeverage_service.clearTestLeveragedResults((String)ahaId);
        }
      }
    }*/
  /**
  *-------------------------------------------------------------------------------
  * @description Verify permission from Action Engine.
  *--------------------------------------------------------------------------------
  * @date   18/05/2020
  * @author saimassimilianno.jordana.contractor@bbva.com
  * @param  ahaId Id of the account has analysis
  */
  private static void checkPermssn(Id ahaId) {
    final arce.Arc_Gen_RatingGlobal_data dataClass = new arce.Arc_Gen_RatingGlobal_data();
    final arce__rating__c currentRating = dataClass.getCurrentRating((String)ahaId);
    final String currentFlow = Arc_Gen_AccHasAnalysis_Data.getAccHasAnalysis(new List<String>{(String)ahaId})[0].arce__IRP_Workflow__c;
    if (!arce.Arc_Gen_RatingGlobal_service.getPermissionIrp(currentRating.Id, System.Label.Arc_Gen_RuleSetIRP, 'Arc_Gen_Overlay_True') && currentFlow != System.Label.Arc_Gen_NewRaipOverrideApi) {
      throw new AuraHandledException(System.Label.Arc_Gen_OverlayMissing);
    }
  }

}