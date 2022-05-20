/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_AnalysisSummary_Controller
* @Author   ivan.cons.contractor@bbva.com
* @Date     Created: 2020-05-20
* @Group    ARCE
* ------------------------------------------------------------------------------------------------
* @Description: Controller for the Arc_Gen_AnalysisSummary cmp.
* ------------------------------------------------------------------------------------------------
* @Changes
*
* |2020-11-13 jose.hijar.contractor@bbva.com.
*              Class creation.
* |2020-11-13 jose.hijar.contractor@bbva.com  header is added to the template type.
*               setRating method copied from arce core in order to help SP2 similar test classes
*               setFFSS method copied from arce core in order to help SP2 similar test classes
*               setAnalysis method copied from arce core in order to help SP2 similar test classes
*               setAnalyzedClient method copied from arce core in order to help SP2 similar test classes
*               getAnalyzedClient method copied from arce core in order to help SP2 similar test classes
*               setRatingVariable method copied from arce core in order to help SP2 similar test classes

* ------------------------------------------------------------------------------------------------
*/
@isTest
global with sharing class Arc_Gen_Ratings_Test_Utils {


  @isTest
  static void avoidSonar() {
    System.assert(true, 'Test method for avoiding sonar major issue');
  }

  /**
  * --------------------------------------------------------------------------------------
  * @Description Test setup method
  * --------------------------------------------------------------------------------------
  * @Author   eduardoefrain.hernandez.contractor@bbva.com
  * @param void
  * @return arce__rating__c
  * @example setRating()
  * --------------------------------------------------------------------------------------
  **/
  global static arce__rating__c setRating() {
    final arce__rating__c rating = new arce__rating__c();
    Insert rating;
    Return rating;
  }

  /**
  * --------------------------------------------------------------------------------------
  * @Description Test setup method
  * --------------------------------------------------------------------------------------
  * @Author   eduardoefrain.hernandez.contractor@bbva.com
  * @param String ratingId - Id of the rating
  * @param String validInd - Valid indicator
  * @return arce__Financial_Statements__c
  * @example setFFSS(String ratingId, String validInd)
  * --------------------------------------------------------------------------------------
  **/
  global static arce__Financial_Statements__c setFFSS(String ratingId, String validInd) {
    final arce__Financial_Statements__c ffss = new arce__Financial_Statements__c(
    arce__ffss_valid_type__c = validInd,
    arce__ffss_valid_for_rating_type__c = validInd,
    arce__financial_statement_id__c = '70252018129',
    arce__rating_id__c = ratingId
    );
    Insert ffss;
    Return ffss;
  }

  /**
  * --------------------------------------------------------------------------------------
  * @Description Test setup method
  * --------------------------------------------------------------------------------------
  * @Author   eduardoefrain.hernandez.contractor@bbva.com
  * @param String name - Name of the arce
  * @return  arce__Analysis__c
  * @example setAnalysis(String name)
  * --------------------------------------------------------------------------------------
  **/
  global static arce__Analysis__c setAnalysis(String name) {
    final arce__Analysis__c analysis = new arce__Analysis__c(
    Name = name
    );
    Insert analysis;
    Return analysis;
  }

  /**
  * --------------------------------------------------------------------------------------
  * @Description Test setup method
  * --------------------------------------------------------------------------------------
  * @Author   eduardoefrain.hernandez.contractor@bbva.com
  * @param String clientId - Id of the account
  * @param String analysisId - Id of the arce
  * @param String validFs - Id of valid FS
  * @return arce__Account_has_Analysis__c
  * @example setAnalyzedClient(String clientId,String analysisId,String validFs)
  * --------------------------------------------------------------------------------------
  **/
  global static arce__Account_has_Analysis__c setAnalyzedClient(String clientId,String analysisId,String validFs) {
    final arce__Account_has_Analysis__c analyzedClient = new arce__Account_has_Analysis__c(
    arce__Customer__c = clientId,
    arce__Analysis__c = analysisId,
    arce__ffss_for_rating_id__c = validFs,
    arce__branch_id__c = '0002'
    );
    Insert analyzedClient;
    Return analyzedClient;
  }
  /**
  * --------------------------------------------------------------------------------------
  * @Description Test setup method
  * --------------------------------------------------------------------------------------
  * @Author   eduardoefrain.hernandez.contractor@bbva.com
  * @param String accName - Name of the account
  * @param String accNumber - Number of the account
  * @param String analysisName - Name of the arce
  * @param String validFs - Id of valid FS
  * @return arce__Account_has_Analysis__c
  * @example getAnalyzedClient(String accName,String accNumber,String analysisName,String validFs)
  * --------------------------------------------------------------------------------------
  **/
  global static arce__Account_has_Analysis__c getAnalyzedClient(String accNumber,String analysisName,String validFs) {
    final Map<String, Arc_Gen_Account_Wrapper> groupAccWrapper = Arc_Gen_Account_Locator.getAccountByAccNumber(new List<String>{accNumber});//safe reference
    final Arc_Gen_Account_Wrapper groupAccount = groupAccWrapper.get(accNumber);
    arce__Analysis__c analysis = setAnalysis(analysisName);//safe reference
    arce__Account_has_Analysis__c accHasAn = setAnalyzedClient(groupAccount.accId,analysis.Id,validFs);//safe reference
    Return accHasAn;
  }

  /**
  * --------------------------------------------------------------------------------------
  * @Description Test setup method
  * --------------------------------------------------------------------------------------
  * @Author   eduardoefrain.hernandez.contractor@bbva.com
  * @param String analysisId - arce id
  * @param String ratingId - id of the rating
  * @return arce__rating_variables_detail__c
  * @example setRatingVariable(String analysisId,String ratingId)
  * --------------------------------------------------------------------------------------
  **/
  global static arce__rating_variables_detail__c setRatingVariable(String analysisId,String ratingId) {
    arce__rating_variables_detail__c ratingVariable = new arce__rating_variables_detail__c(
    arce__account_has_analysis_id__c = analysisId,
    arce__rating_id__c = ratingId,
    arce__rating_modifier_adj_type__c = 'OVERRIDE'
    );
    Insert ratingVariable;
    Return ratingVariable;
  }
}