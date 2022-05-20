/**
* ────────────────────────────────────────────────────────────────────
* Profitability Analysis Interface
* Interface that will contain methods for determining profitability
* analysis information
* ────────────────────────────────────────────────────────────────────
* @author      Sara Torres <sara.torres.bermudez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-02-24
* @modified
* @systemLayer Domain
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@SuppressWarnings('PMD.AvoidGlobalModifier')
global interface ProfitabilityAnalysis_Itf {
    /**
    * @description returns the user code
    * @param userId Id of the user
    * @return String user code
    */
    String getUserCode(Id userId);
    /**
    * @description Returns a List of wrapper with the related info of each account id passed as a parameter in a Set
    * @param accountsIdsSet : Set of the related accounts Ids
    * @return List<Participants_Wrapper> fill with each participant info
    */
    profitability_analysis__c setPADefaultCreationData (profitability_analysis__c profAnalysis);

    /**
    * @description returns the user Id
    * @param userCode federation id of the user
    * @return String user Id
    */
    Id getUserId(String userCode);

    /**
    * @description returns the branch code of a Profitability Analysis or Profitability Sheet
    * @param contextRecordId context Id
    * @param contextObject context Object
    * @return String branch code
    */
    String getBranchCode(Id contextRecordId, String contextObject);

    /**
    * @description returns the branch code of a Profitability Analysis or Profitability Sheet
    * @param profAnalysis : Register of profitability_analysis__c object
    * @param branchCode : String with branch code
    * @param userCode : String with user code
    * @return profitability_analysis__c updated record
    */
    profitability_analysis__c setPADefaultRequestData(profitability_analysis__c profAnalysis, String branchCode, String userCode);

    /**
    * @description returns the ARCE date
    * @param Id : Profitability analysis id
    * @return date : return arce date
    */
    date getARCEDate (Id profAnalysisId);

    /**
    * @description returns the branch code of a Profitability Analysis or Profitability Sheet
    * @param ProfitabilityAnalysis_Wrapper : Profitability Analisys wrapper object
    * @param decisionId : String with decision id
    * @param decisionComments : String with decission code
    * @param screenShot : String with screenshot
    * @return Map<String, Object> : updated record
    */
    Map<String, Object> setPriceDecision (ProfitabilityAnalysis_Wrapper profAnalysis, String decisionId, String decisionComments, String screenShot);

    /**
    * @description returns the branch code of a Profitability Analysis or Profitability Sheet
    * @param decisionsIdsList : A list with the decision id's
    * @param currentStatus : A string with the profitability analysis current status
    * @return List<PriceDecision_Wrapper> : A list of Price decision wrapper objects
    */
    List<PriceDecision_Wrapper> getPriceDecisions (List<String> decisionsIdsList, String currentStatus);

    /**
    * @description returns wrapper info updated for profAnalysis
    * @param profAnalysis : ProfitabilityAnalysis_Wrapper wrapper with profitability_analysis__c info
    * @param approvalComments : String with comments
    * @return Map<String, Object> map with the response
    */
    Map<String, Object> setPAApprovePrice(ProfitabilityAnalysis_Wrapper profAnalysis, String approvalComments);

    /**
    * @description Do the actions of dismissal of profitability analysis
    * @param profAnalysis : Wrapper with related info of profAnalysis
    * @param dismissalComments : String with dismissal comments value
    * @param screenShot : String with value to audit record
    * @return Map<String, Object>, with action results
    */
    Map<String, Object> setPADismissal(ProfitabilityAnalysis_Wrapper profAnalysis, String dismissalComments, String screenShot);

    /**
    * @description returns wrapper info updated for profAnalysis in formalization
    * @param profAnalysis : ProfitabilityAnalysis_Wrapper wrapper with profitability_analysis__c info
    * @param formMethod : String with method to formalize
    * @param formComments : String with comments
    * @param screenShot : String with screen shot id
    * @return Map<String, Object> map with the response
    */
    Map<String, Object> setPAFormalization(ProfitabilityAnalysis_Wrapper profAnalysis, String formMethod, String formComments, String screenShot);

    /**
    * @description Do the actions of restudy of profitability analysis
    * @param profAnalysis : Wrapper with related info of profAnalysis
    * @param dismissalComments : String with dismissal comments value
    * @param screenShot : String with value to audit record
    * @return Map<String, Object>, with action results
    */
    Map<String, Object> setPARestudy(ProfitabilityAnalysis_Wrapper profAnalysis, String restudyComments, String screenShot);

    /**
    * @description Auxiliar method to obtain FirstName and LastName from a Owner Id. If its a Group id, returns empty string.
    * @param ownerId : Id of the User/Group
    * @return String, with FirstName and LastName concatenated
    */
    String getFirstAndLastName(Id ownerId);

    /**
    * @description Do the actions of notification of profitability analysis
    * @param profAnalysis : Wrapper with related info of profAnalysis
    * @param notificationComents : String with notification comments value
    * @param screenShot : String with value to audit record
    * @return Map<String, Object>, with action results
    */
    Map<String, Object> setPANotification(ProfitabilityAnalysis_Wrapper profAnalysis, String notificationComents, String screenShot);
}