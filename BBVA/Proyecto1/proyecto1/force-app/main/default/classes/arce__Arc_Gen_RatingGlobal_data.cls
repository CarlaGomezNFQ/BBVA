/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_RatingGlobal_data
* @Author   jose.hijar.contractor@bbva.es
* @Date     Created: 04/11/2020
* @Group    ARCE
* -----------------------------------------------------------------------------------------------
* @Description Contains the logic to assign the different rating variables to salesforce fields
* -----------------------------------------------------------------------------------------------
* @Changes
*
* |2020-11-04 jose.hijar.contractor@bbva.es
*               Class creation
* |2020-11-10 jose.hijar.contractor@bbva.es
*               Entire class copied from arce core and adapted to SP2 business logic, rfactorization, code review, etc...
* |2020-04-22 saimassimilianno.jordana.contractor@bbva.es   Add new meth0d getAcchasForWF to get ahas without use dependencies classes.
* |2020-04-22 saimassimilianno.jordana.contractor@bbva.es   Add new fields to getAcchasForWF meth0d.
* |2020-05-20 saimassimilianno.jordana.contractor@bbva.es   Add new fields to getAcchasForWF meth0d.
* -----------------------------------------------------------------------------------------------
*/
@SuppressWarnings('sf:TooManyMethods')
global without sharing class Arc_Gen_RatingGlobal_data {
  /**
  * @Class: SaveResult
  * @Description: Wrapper that contain the information of a DML Result
  * @author BBVA
  */
  @JsonAccess(serializable='always' deserializable='always')
  global class SaveResult {
    /**
    * @Description: Status of the DML operation
    */
    global String status {get;set;}
    /**
    * @Description: Message if the DML operation fails
    */
    global String message {get;set;}
  }
  /**
  *-------------------------------------------------------------------------------
  * @description Method that calls a service using the iaso component
  --------------------------------------------------------------------------------
  * @author eduardoefrain.hernandez.contractor@bbva.com
  * @date 30/4/2019
  * @param String analysisId
  * @param String customerId
  * @return Arc_Gen_getIASOResponse.serviceResponse - Wrapper that contains the response of the called service
  * @example global Arc_Gen_getIASOResponse.serviceResponse callRatingService(String analysisId,String customerId)
  **/
  global Arc_Gen_getIASOResponse.serviceResponse callRatingService(String parameters, String serviceName) {
    Arc_Gen_getIASOResponse.serviceResponse response = new Arc_Gen_getIASOResponse.serviceResponse();
    response = Arc_Gen_getIASOResponse.calloutIASO(serviceName, parameters);
    return response;
  }
  /**
  *-------------------------------------------------------------------------------
  * @description Method that gets the valid FFSS from an analyzed client
  --------------------------------------------------------------------------------
  * @author eduardoefrain.hernandez.contractor@bbva.com
  * @date 30/4/2019
  * @param String analysisId
  * @return List<arce__Financial_Statements__c>
  * @example global List<arce__Financial_Statements__c> getValidFFSS(String analysisId)
  **/
  global List<arce__Financial_Statements__c> getValidFFSS(String analysisId) {
    List<arce__Account_has_Analysis__c> analysis = [SELECT Id, arce__ffss_for_rating_id__c FROM arce__Account_has_Analysis__c WHERE Id =: analysisId LIMIT 1];
    String validId = analysis[0].arce__ffss_for_rating_id__c;
    List<arce__Financial_Statements__c> validFinancialState = [SELECT id,arce__ffss_valid_for_rating_type__c,arce__ffss_valid_type__c,arce__rating_id__c,arce__ffss_withRating_type__c FROM arce__Financial_Statements__c WHERE Id =:validId LIMIT 1];
    return validFinancialState;
  }
  /**
  *-------------------------------------------------------------------------------
  * @description Method that gets the name and the accountNumber of a client
  --------------------------------------------------------------------------------
  * @author eduardoefrain.hernandez.contractor@bbva.com
  * @date 30/4/2019
  * @param String analysisId
  * @return List<String> - Position[0] = Name, Position[1] = AccountNumber
  * @example global static List<String> getCustomerData(String analysisId)
  **/
  global static List<String> getCustomerData(String analysisId) {
    List<String> customerData = new List<String>();
    arce__Account_has_Analysis__c analysis = [SELECT arce__Customer__c,arce__CustomAccountID__c FROM arce__Account_has_Analysis__c WHERE id =: analysisId LIMIT 1];
    final String clientId = arce.Arc_Gen_AccHasAnalysis_Data.getCorrectIdWAhas(analysis);
    final Map<Id, Arc_Gen_Account_Wrapper> mapWrap = Arc_Gen_Account_Locator.getAccountInfoById(new List<Id>{clientId});
    customerData.add(mapWrap.get(clientId).name);
    customerData.add(mapWrap.get(clientId).accNumber);
    return customerData;
  }
  /**
  *-------------------------------------------------------------------------------
  * @description Method that gets the AccountHasAnalysis from its Id
  --------------------------------------------------------------------------------
  * @author eduardoefrain.hernandez.contractor@bbva.com
  * @date 30/4/2019
  * @param String analysisId
  * @return List<arce__Account_has_Analysis__c>
  * @example global List<arce__Account_has_Analysis__c> getAccountHasAnalysis(String analysisId)
  **/
  global List<arce__Account_has_Analysis__c> getAccountHasAnalysis(String analysisId) {
    return arce.Arc_Gen_AccHasAnalysis_Data.getAccHasAnalysis(new List<String>{analysisId});
  }
  /**
  *-------------------------------------------------------------------------------
  * @description Method that gets the existen rating variables of an analyzed client
  --------------------------------------------------------------------------------
  * @author eduardoefrain.hernandez.contractor@bbva.com
  * @date 30/4/2019
  * @param String analysisId
  * @param String ratingId
  * @return List<arce__rating_variables_detail__c>
  * @example global List<arce__rating_variables_detail__c> getExistentVariables(String analysisId,String ratingId)
  **/
  global List<arce__rating_variables_detail__c> getExistentVariables(String analysisId,String ratingId) {
    return [SELECT id,arce__parent_code_number__c,arce__modifier_mix_type__c FROM arce__rating_variables_detail__c WHERE arce__account_has_analysis_id__c =: analysisId AND arce__rating_id__c =: ratingId];
  }
  /**
  *-------------------------------------------------------------------------------
  * @description Method that gets the current rating of an analyzed client
  --------------------------------------------------------------------------------
  * @author eduardoefrain.hernandez.contractor@bbva.com
  * @date 30/4/2019
  * @param String analysisId
  * @return arce__rating__c
  * @example global arce__rating__c getCurrentRating(String analysisId)
  **/
  global arce__rating__c getCurrentRating(String analysisId) {
    arce__Account_has_Analysis__c analysis = [SELECT arce__ffss_for_rating_id__r.arce__rating_id__c FROM arce__Account_has_Analysis__c WHERE Id =: analysisId];
    String ratingId = analysis.arce__ffss_for_rating_id__r.arce__rating_id__c;
    arce__rating__c currentRating = Arc_Gen_Rating_data.generalRatingData(new List<String>{ratingId})[0];
    return currentRating;
  }
  /**
  *-------------------------------------------------------------------------------
  * @description Method that gets the leverage results
  --------------------------------------------------------------------------------
  * @author eduardoefrain.hernandez.contractor@bbva.com
  * @date 30/4/2019
  * @param String analysisId
  * @return arce__Account_has_Analysis__c
  * @example global arce__Account_has_Analysis__c getLeveragedResults(String analysisId)
  **/
  global arce__Account_has_Analysis__c getLeveragedResults(String analysisId) {
    return [SELECT id,arce__anlys_wkfl_sbanlys_status_type__c,arce__ll_before_adj_ind_type__c,arce__ll_before_adj_clsfn_type__c,arce__ll_after_adj_ind_type__c,arce__ll_after_adj_clsfn_type__c FROM arce__Account_has_Analysis__c WHERE Id =: analysisId][0];
  }
  /**
  *-------------------------------------------------------------------------------
  * @description Method that gets all Ahas variables needed for new IRP workflow.
  --------------------------------------------------------------------------------
  * @author saimassimilianno.jordana.contractor@bbva.es
  * @date 14/04/2021
  * @param String analysisId
  * @return arce__Account_has_Analysis__c
  * @example getAcchasForWF(analysisId)
  **/
  global static arce__Account_has_Analysis__c getAcchasForWF(String analysisId) {
      return [SELECT Id, Name, arce__rating_scale_type__c, arce__Spanish_Client__c, arce__IRP_Workflow__c, arce__ffss_for_rating_id__r.arce__ffss_valid_type__c, arce__Analysis__r.arce__anlys_wkfl_sub_process_type__c,
          arce__customer__c, arce__RAR_rating_tool_id__c, arce__CustomAccountID__c, arce__group_asset_header_type__c, arce__Analysis__c, arce__ffss_for_rating_id__r.arce__rating_id__c, arce__ffss_for_rating_id__r.arce__financial_statement_id__c,
          arce__Analysis__r.OwnerId, arce__anlys_wkfl_cnsld_ffss_type__c, arce__Analysis__r.arce__analysis_customer_relation_type__c, arce__smes_eur_comuty_defn_type__c, arce__Analysis__r.arce__Stage__c,
          arce__Analysis__r.arce__wf_status_id__c, arce__Analysis__r.arce__parent_analysis_id__c
          FROM arce__Account_has_Analysis__c WHERE Id =: analysisId LIMIT 1];
  }
  /**
  *-------------------------------------------------------------------------------
  * @description Method that sets an empty rating record
  --------------------------------------------------------------------------------
  * @author eduardoefrain.hernandez.contractor@bbva.com
  * @date 30/4/2019
  * @return arce__rating_variables_detail__c
  * @example global arce__rating_variables_detail__c setRatingVariableObj()
  **/
  global arce__rating_variables_detail__c setRatingVariableObj() {
    return new arce__rating_variables_detail__c();
  }
  /**
  *-------------------------------------------------------------------------------
  * @description Method that update a list of sObjects
  --------------------------------------------------------------------------------
  * @author eduardoefrain.hernandez.contractor@bbva.com
  * @date 30/4/2019
  * @param List<sObject> recordsToUpdate
  * @return SaveResult - A wrapper with the results of a DML operation
  * @example global SaveResult updateRecords(List<sObject> recordsToUpdate) {
    **/
    global SaveResult updateRecords(List<sObject> recordsToUpdate) {
      final SaveResult updateResults = new SaveResult();
      try {
        updateResults.status = 'true';
        update(recordsToUpdate);
      } catch(DmlException ex) {
        updateResults.status = 'false';
        updateResults.message = ex.getMessage();
      }
      return updateResults;
    }
    /**
    *-------------------------------------------------------------------------------
    * @description Method that update a single record
    --------------------------------------------------------------------------------
    * @author cesaroctavio.villanueva.cebal@bbva.com
    * @date 30/4/2019
    * @param sObject recordToUpdate
    * @return saveResult - A wrapper with the results of a DML operation
    * @example global saveResult updateRecord(sObject recordToUpdate)
    **/
    global saveResult updateRecord(sObject recordToUpdate) {
      final saveResult updateResults = new saveResult();
      try {
        updateResults.status = 'true';
        update(recordToUpdate);
      } catch(DmlException ex) {
        updateResults.status = 'false';
        updateResults.message = ex.getMessage();
      }
      return updateResults;
    }
    /**
    *-------------------------------------------------------------------------------
    * @description Method that inserts a list of sObjects
    --------------------------------------------------------------------------------
    * @author eduardoefrain.hernandez.contractor@bbva.com
    * @date 30/4/2019
    * @param List<sObject> recordsToInsert
    * @return SaveResult - A wrapper with the results of a DML operation
    * @example global SaveResult insertRecords(List<sObject> recordsToInsert)
    **/
    global SaveResult insertRecords(List<sObject> recordsToInsert) {
      final SaveResult insertResults = new SaveResult();
      try {
        insertResults.status = 'true';
        upsert(recordsToInsert);
      } catch(DmlException ex) {
        insertResults.status = 'false';
        insertResults.message = ex.getMessage();
      }

      return insertResults;
    }
    /**
    *-------------------------------------------------------------------------------
    * @description Method that deletes a list of sObjects
    --------------------------------------------------------------------------------
    * @author eduardoefrain.hernandez.contractor@bbva.com
    * @date 30/4/2019
    * @param List<sObject> recordsToDelete
    * @return SaveResult - A wrapper with the results of a DML operation
    * @example global SaveResult deleteRecords(List<sObject> recordsToDelete)
    **/
    global void deleteRecords(List<sObject> recordsToDelete) {
      delete(recordsToDelete);
    }

    global static List<arce__ratingOverlayMap__mdt> getOverwriteMapConfig(String blockType) {
      List<arce__ratingOverlayMap__mdt> ret;
      List<arce__ratingOverlayMap__mdt> customMap=[SELECT arce__adjustment_type__c, arce__blockIds__c, arce__block_type__c, arce__entire_block__c FROM arce__ratingOverlayMap__mdt WHERE arce__block_type__c = :blockType];
      if (!customMap.isEmpty()) {
        ret = customMap;
      }
      return ret;
    }

    global static arce__Overlay__c getOverlayFromAhA(Id accHasAnalysisId) {
      String queryString = 'SELECT ' + Arc_Gen_GenericUtilities.getAllFields('arce__Overlay__c');
      queryString += ' FROM arce__Overlay__c WHERE arce__Account_has_AnalysisId__c = :accHasAnalysisId';
      final List<arce__Overlay__c> lstMod = Database.query(String.escapeSingleQuotes(queryString));
      return lstMod.isEmpty() ? new arce__Overlay__c(): lstMod[0];
    }

    global static Map<String,arce__overlay_custom_mapping__mdt> getModifierOverlayMapping() {
      Map<String,arce__overlay_custom_mapping__mdt> ret;

      final List<arce__overlay_custom_mapping__mdt> overlyaMappingList = [SELECT arce__modifierId__c, arce__defProb_fieldMap__c, arce__longScale_fieldMap__c,
      arce__score_fieldMap__c, arce__shortScale_fieldMap__c, arce__modifierValue_fieldMap__c
      FROM arce__overlay_custom_mapping__mdt]; //limit wiggum major issue

      if(!overlyaMappingList.isEmpty()) {
        ret = new Map<String,arce__overlay_custom_mapping__mdt>();
        for(arce__overlay_custom_mapping__mdt oMapping : overlyaMappingList) {
          ret.put(oMapping.arce__modifierId__c,oMapping);
        }
      }
      return ret;
    }

    global static arce__Arce_Config__mdt getArceConfig(String developerName) {
      arce__Arce_Config__mdt ret;
      final List<arce__Arce_Config__mdt> configs = [SELECT arce__Value1__c FROM arce__Arce_Config__mdt WHERE DeveloperName = :developerName];
      ret = configs.isEmpty() ? ret : configs[0];
      return ret;
    }
    /**
    *-------------------------------------------------------------------------------
    * @description Method that get override variable
    --------------------------------------------------------------------------------
    * @author juanmanuel.perez.ortiz.contractor@bbva.com
    * @date 25/06/2020
    * @param String accAhaId
    * @return arce__rating_variables_detail__c
    * @example global static arce__rating_variables_detail__c getOverrideVariable(String accAhaId)
    **/
    global static arce__rating_variables_detail__c getOverrideVariable(String accAhaId) {
        return [SELECT id,name,arce__account_has_analysis_id__r.Name,arce__rating_var_score_number__c,arce__rating_id__r.arce__rating_long_value_type__c,
                                                        arce__rating_override_reason_desc__c,arce__rating_id__c,arce__rating_variable_type_name__c
                                                        FROM arce__rating_variables_detail__c WHERE arce__account_has_analysis_id__c =:accAhaId LIMIT 1];
    }

    /**
    *-------------------------------------------------------------------------------
    * @description Method that gets info about Iaso Integration mtd.
    --------------------------------------------------------------------------------
    * @author saimassimilianno.jordana.contractor@bbva.com
    * @date 15/4/2021
    * @param String name
    * @return iaso__GBL_integration_service__mdt
    * @example getIasoIntegrationMtd('ratingEngine')
    **/
    global static iaso__GBL_integration_service__mdt getIasoIntegrationMtd(String name) {
        return [SELECT DeveloperName,iaso__Authentication_Service__c,iaso__Blocked_Service__c,iaso__Custom_Setting__c,iaso__Headers_Class__c,iaso__Http_Headers_LTA_TEMP__c,iaso__Http_Headers_LTA__c,iaso__Http_Method__c,iaso__Json_Input_Template_LTA_TEMP__c,iaso__Json_Input_Template_LTA__c,iaso__Mock_LTA_TEMP__c,iaso__Mock_LTA__c,iaso__Querystring_Input_Template_LTA_TEMP__c,iaso__Querystring_Input_Template_LTA__c,iaso__Retrieve_Mock_LTA_TEMP__c,iaso__Retrieve_Mock_LTA__c FROM iaso__GBL_integration_service__mdt WHERE DeveloperName =: name];
    }
}