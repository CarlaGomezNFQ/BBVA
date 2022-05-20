/**
 * @description       : 
 * @author            : Global Desktop
 * @group             : 
 * @last modified on  : 30-11-2021
 * @last modified by  : Global Desktop
**/
public without sharing  class Arc_Gen_ValidateRatingBy_Controller {


  @TestVisible
  private Arc_Gen_ValidateRatingBy_Controller(){}

  public class ValidatedByResponse{
    @AuraEnabled
    public Map<String,Object> data {get;private set;}
    @AuraEnabled
    public Boolean success {get;private set;}
    @AuraEnabled
    public String message {get;private set;}

    public ValidatedByResponse(Map<String,Object> data, Boolean success, String msg){
      this.data=data;
      this.success=success;
      this.message=msg;
    }
  }


  @AuraEnabled
  public static ValidatedByResponse getRatingData(String aHaId) {
    ValidatedByResponse ret;
    Map<String,Object> data;
    Arc_Gen_Delegation_Wrapper wrapper;
    arce.Arc_Gen_RatingGlobal_data locator = new arce.Arc_Gen_RatingGlobal_data();

    if(String.isNotBlank(aHaId)){
      if(Arc_Gen_TabSet_service.hasPermissionAmbit(aHaId)) {
      try {
        data = new Map<String,Object>();
        arce__Account_has_Analysis__c aHa = locator.getAccountHasAnalysis(aHaId)[0];
        data.put('wfType', aHa.arce__IRP_Workflow__c);
        data.put('subProcessType', aHa.arce__Analysis__r.arce__anlys_wkfl_sub_process_type__c);
        data.put('ratingId', aHa.arce__ffss_for_rating_id__r.arce__rating_id__c);
		data.put('ffssCertification', aHa.arce__ffss_for_rating_id__r.arce__ffss_certification_type__c);
        final arce.Arc_Gen_User_Wrapper wrpUser = arce.Arc_Gen_User_Locator.getUserInfo(System.UserInfo.getUserId());
        wrapper = Arc_Gen_Propose_Helper.initDelegation(wrpUser.ambitUser, null, 'RAIP-PROPOSE');
        data.put('ambitList', wrapper.lstAmbits);
        ret = createResponseObj(data, true, null);
      } catch (Exception e) {
        throw new AuraHandledException(e.getMessage()); //NOSONAR
      }
      } else {
        ret = createResponseObj(null, false, 'The action cannot be executed. Invalid profile.');
      }

    } else {
      ret = createResponseObj(null, false, 'AccountHasAnalysisId must be provided to the APEX controller');
    }
    return ret;
  }

  /**
  * @description
  * @author Global Desktop | 24-11-2021
  * @param selectedAmbit
  * @return ValidatedByResponse
  **/
  @AuraEnabled
  public static ValidatedByResponse fetchUsers(String selectedAmbit) {
    ValidatedByResponse ret;
    Map<String,Object> data;
    Arc_Gen_Delegation_Wrapper wrapper;

    if(String.isNotBlank(selectedAmbit)) {
      try {
        data = new Map<String,Object>();
        wrapper = Arc_GBL_Workflow_Helper.fetchUsersByAmbit(selectedAmbit);
        data.put('userList', wrapper.lstUsers);
        ret = createResponseObj(data, true, null); //NOSONAR
      } catch (Exception e) {
        throw new AuraHandledException(System.Label.Arc_Gen_ApexCallError + ': ' + e.getMessage()); //NOSONAR
      }
    } else {
      ret = createResponseObj(null, false, 'Ambit must be provided to the APEX controller');
    }
    return ret;
  }

  /**
  * @description
  * @author Global Desktop | 24-11-2021
  * @param selectedAmbit
  * @param aHaId
  * @return ValidatedByResponse
  **/
  @AuraEnabled
  public static ValidatedByResponse fetchUsersAha(String selectedAmbit,String aHaId) {
    ValidatedByResponse ret;
    Map<String,Object> data;
    Arc_Gen_Delegation_Wrapper wrapper;

    if(String.isNotBlank(selectedAmbit) && String.isNotBlank(aHaId)) {
      try {
        data = new Map<String,Object>();
        final List<arce__Account_has_Analysis__c> aHa = [select id, arce__Analysis__r.arce__proposeUser__c  from arce__Account_has_Analysis__c where Id = :aHaId Limit 1];
        wrapper = Arc_GBL_Workflow_Helper.fetchUsersByAmbit(selectedAmbit);
        for(Integer i = 0; i <  wrapper.lstUsers.size(); i++) {
          if(aHa.get(0).arce__Analysis__r.arce__proposeUser__c == wrapper.lstUsers.get(i).get('value')) {
            wrapper.lstUsers.remove(i);
          }
        }
        data.put('userList', wrapper.lstUsers);
        ret = createResponseObj(data, true, null); //NOSONAR
      } catch (Exception e) {
        throw new AuraHandledException(System.Label.Arc_Gen_ApexCallError + ': ' + e.getMessage()); //NOSONAR
      }
    } else {
      ret = createResponseObj(null, false, 'Ambit must be provided to the APEX controller');
    }
    return ret;
  }


  /**
  *-------------------------------------------------------------------------------
  * @description Method that obtains the response of the changing status from the service class
  --------------------------------------------------------------------------------
  * @author eduardoefrain.hernandez.contractor@bbva.com
  * @date 2019-05-13
  * @param String arce analysis Id
  * @param String rating  Id
  * @return arce.Arc_Gen_ServiceAndSaveResponse - A wrapper with information of saving records
  * @example public static arce.Arc_Gen_ServiceAndSaveResponse changeStatus(String analysisId)
  **/
  //    @SupressWarning(PMD.)

  @AuraEnabled
  public static ValidatedByResponse validateRating(String analysisId, String ratingId, String validatedById, String description) {
    ValidatedByResponse ret;
    arce.Arc_Gen_ServiceAndSaveResponse response;
    arce.Arc_Gen_RatingGlobal_data ratingLocator = new arce.Arc_Gen_RatingGlobal_data();
    arce.Arc_Gen_RatingGlobal_data.SaveResult saveResult;
    if (Arc_Gen_TabSet_service.getPermissionToEdit(analysisId) == 'true') {
      try {
        response = Arc_Gen_ValidateRating_service.setupValidateRatingByUser(analysisId, validatedById, ratingId, null, true);
        arce__rating__c rating = new arce__rating__c(Id = ratingId);
        rating.arce__Arc_Gen_ValidationCommentary__c = description;
        saveResult = ratingLocator.updateRecord(rating);//update result not verified since is not critical for the validation service

        if(response.serviceCode == arce.Arc_Gen_RatingGlobal_Constants.SUCC1){
          ret = createResponseObj(null, Boolean.valueOf(response.saveStatus), response.saveMessage); //Save status is returned to lightning controller because its the last operation after all previous succeeded
        }else{
          ret = createResponseObj(null, false, response.serviceMessage);
        }
      } catch (Exception e) {
        arce.Arc_Gen_GenericUtilities.throwAuraExcept(System.Label.Arc_Gen_ApexCallError + ': ' + e.getMessage() + e.getStackTraceString());
      }
    } else {
        ret = createResponseObj(null, false, System.Label.Arc_Gen_Generic_NotAllowed);
    }
    return ret;
  }


  private static ValidatedByResponse createResponseObj(Map<String,Object> d, Boolean s, String m){
    return new ValidatedByResponse(d,s,m);
  }
}