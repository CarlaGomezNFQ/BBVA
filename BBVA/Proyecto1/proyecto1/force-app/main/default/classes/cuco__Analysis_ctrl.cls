/**
* ────────────────────────────────────────────────────────────────────
* Analysis_ctrl
* Controller class for analysis_cmp Lightning Component
* ────────────────────────────────────────────────────────────────────
* @author     Diego Martinez <diego.martinez.chollet.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-03-30
* @modified
* @systemLayer Presentation
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
public with sharing class Analysis_ctrl {

    // Private constructor to avoid sonar err
    @TestVisible
    private Analysis_ctrl() {}

    /**
    * @description Get data of current profitability analysis and check manage permissions of current user
    * @param profAnalysisId : Id of the Profitability Analysis
    * @return Map<String, Object> map with the manage permissions and prof analysis info
    */
    @AuraEnabled
    public static Map<String, Object> getAnalysisPermissions(Id profAnalysisId) {
        Map<String, Object> retMap = new Map<String, Object>();
        try {
            retMap = checkManagePAPermissions(profAnalysisId);
            final ProfitabilityAnalysis_Selector paSelector = new ProfitabilityAnalysis_Selector(true);
            final List<profitability_analysis__c> lstPA = paSelector.selectById(new Set<Id>{profAnalysisId});
            if (!lstPA.isEmpty()) {
                retMap.put('profAnalysis', lstPA.get(0));
            }
        } catch (Exception e) {//NOSONAR
            throw new AuraHandledException(e.getMessage()); //NOSONAR
        }
        return retMap;
    }

    /**
    * @description Check if current user can manage current Profitability Analysis
    * @param profAnalysisId : Id of the Profitability Analysis
    * @return Map<String, Object> map with the manage permissions
    */
    @AuraEnabled
    public static Map<String, Object> checkManagePAPermissions(Id profAnalysisId) {
        Map<String, Object> retMap = new Map<String, Object>();
        try {
            retMap = Permissions_Service.checkManagePAPermissions(profAnalysisId, UserInfo.getUserId());
        } catch (Exception e) {//NOSONAR
            throw new AuraHandledException(e.getMessage()); //NOSONAR
        }
        return retMap;
    }

    /**
    * @description Update the current prof analysis
    * @param lstProfAnalysis: Profitability Analysis to update
    */
    @AuraEnabled
    public static Utils.DML_Wrapper updatePAAnalysis(List<profitability_analysis__c> lstProfAnalysis) {
        final List<String> errLstInsertPAP = new List<String>();
        try{
            final List<Database.SaveResult> srLstPAP = Database.update(lstProfAnalysis, true);
            // Iterate through each returned
            for (Database.SaveResult srPAP : srLstPAP) {
                if (!srPAP.isSuccess()){
                    // Operation failed, so get all errors
                    for (Database.Error errInsPAP : srPAP.getErrors()) {
                        errLstInsertPAP.add(errInsPAP.getMessage());
                        System.debug('Insert profitability_analysis_participant__c ERROR: ' + userInfo.getUserName()+', ' + errInsPAP.getStatusCode()+': ' + errInsPAP.getMessage());
                    }
                }
            }
        } catch (Exception e){//NOSONAR
            throw new AuraHandledException(e.getMessage()); //NOSONAR
        }
        return new Utils.DML_Wrapper(errLstInsertPAP.isEmpty(), errLstInsertPAP);
    }
}