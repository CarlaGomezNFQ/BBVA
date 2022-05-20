/**
* ────────────────────────────────────────────────────────────────────
* ProfitabilityAnalysis_Service
* Test Service for ProfitabilityAnalysis apex class
* ────────────────────────────────────────────────────────────────────
* @author      Sara Torres <sara.torres.bermudez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-03-01
* @modified
* @systemLayer Domain
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
global class ProfitabilityAnalysis_Service {
    /*
    * @description Private constructor to avoid sonar err
    */
    @TestVisible
    private ProfitabilityAnalysis_Service() {}

    /**
    * @description Returns the info to show on the table
    * @param userId Current record Id
    * @return String, with the code user
    */
    public static String obtainUserInfo(Id userId) {
        // Obtain the current active version of general config mtd
        final pa_general_configuration__mdt genConfig = Utils.getGeneralConfiguration();
        // Obtain the current userId of the context sObject
        return ProfitabilityAnalysis_Helper.getUserCode(genConfig, userId);
    }

    /**
    * @description Insert the profitability analysis participants passed as parameters
    * @param lstPAP: List of profitability analysis participants ready to insert
    * @return Utils.DML_Wrapper, with the response of the DML operation
    */
    public static Utils.DML_Wrapper insertPA(List<profitability_analysis__c> lstPA) {
        return ProfitabilityAnalysis_Helper.insertPA(lstPA);
    }

    /**
    * @description Returns the info to show on the table
    * @param userCode User federation identifier
    * @return User Id
    */
    public static Id obtainUserInfo(String userCode) {
        final pa_general_configuration__mdt genConfig = Utils.getGeneralConfiguration();
        return ProfitabilityAnalysis_Helper.getUserId(genConfig, userCode);
    }

    /**
    * @description Returns profitability analysis or profitability sheet related branch code
    * @param contextRecordId Id of the profitability analysis or profitability sheet
    * @return  string profitability analysis / profitability sheet account.Sic
    */
    public static String getBranchCode(Id contextRecordId) {
        final pa_general_configuration__mdt genConfig = Utils.getGeneralConfiguration();
        return ProfitabilityAnalysis_Helper.getBranchCode(genConfig, contextRecordId);
    }

    /**
    * @description Returns profitability analysis or profitability sheet related price decisions
    * @param contextRecordId Id of the profitability analysis or profitability sheet
    * @return  string profitability analysis / profitability sheet account.Sic
    */
    public static List<PriceDecision_Wrapper> getPriceDecision(List<String> decisionsIdsList, String currentStatus) {
        final pa_general_configuration__mdt genConfig = Utils.getGeneralConfiguration();
        return ProfitabilityAnalysis_Helper.getPriceDecision(genConfig, decisionsIdsList, currentStatus);
    }

    /**
    * @description Returns the Arce date from interface
    * @param contextRecordId Id of the profitability analysis
    * @return  date / arce date
    */
    public static Date getARCEDate(Id recordId) {
        final pa_general_configuration__mdt genConfig = Utils.getGeneralConfiguration();
        return ProfitabilityAnalysis_Helper.getARCEDate(genConfig, recordId);
    }

    /**
    * @description Returns profitability analysis price decisions and set in bbdd
    * @param profAnalysis object
    * @param decisionId of the price decision
    * @param decisionComments of the price decision
    * @param contextRecordId Id of the price decision
    * @return  string profitability analysis / profitability sheet account.Sic
    */
    public static Map<String,Object> setPriceDecision(ProfitabilityAnalysis_Wrapper profAnalysis, String decisionId, String decisionComments, String screenShot) {
        final pa_general_configuration__mdt genConfig = Utils.getGeneralConfiguration();
        Map<String,Object> mapParameters = new Map<String, Object>();
        mapParameters.put('profAnalysis', profAnalysis);
        mapParameters.put('decisionId', decisionId);
        mapParameters.put('decisionComments', decisionComments);
        mapParameters.put('screenShot', screenShot);
        mapParameters.put('genConfig', genConfig);
        return ProfitabilityAnalysis_Helper.setPriceDecision(mapParameters);
    }

    /**
    * @description Returns profitability analysis or profitability sheet related branch code
    * @param profAnalysisId Id of the profitability analysis or profitability sheet
    * @return  string profitability analysis / profitability sheet account.Sic
    */
    global static profitability_analysis__c getProfitabilityAnalysisInfo(Id profAnalysisId) {
        Set<Id> profAnalysisIds = new Set<Id>{profAnalysisId};
        final List<profitability_analysis__c> res = ProfitabilityAnalysis_Helper.getProfitabilityAnalysisInfo(profAnalysisIds);
        return res[0];
    }

    /**
    * @description Returns response from setPADismissal method at ProfitabilityAnalysis_Itf
    * @param paWrapper : ProfitabilityAnalysis_Wrapper with the prof analysis info
    * @param dismissalComments : Dismissal comments value from the form
    * @param screenShot : String with the html screenshot to audit detail records
    * @return Map<String, Object>, with response
    */
    public static Map<String, Object> setPADismissalProfAnalysis(ProfitabilityAnalysis_Wrapper paWrapper, String dismissalComments, String screenShot) {
        final pa_general_configuration__mdt genConfig = Utils.getGeneralConfiguration();
        return ProfitabilityAnalysis_Helper.setPADismissalProfAnalysis(genConfig, paWrapper, dismissalComments, screenShot);
    }

    /**
    * @description Returns response from setPARestudy method at ProfitabilityAnalysis_Itf
    * @param paWrapper : ProfitabilityAnalysis_Wrapper with the prof analysis info
    * @param restudyComments : Restudy comments value from the form
    * @param screenShot : String with the html screenshot to audit detail records
    * @return Map<String, Object>, with response
    */
    public static Map<String, Object> setPARestudyProfAnalysis(ProfitabilityAnalysis_Wrapper paWrapper, String restudyComments, String screenShot) {
        final pa_general_configuration__mdt genConfig = Utils.getGeneralConfiguration();
        return ProfitabilityAnalysis_Helper.setPARestudyProfAnalysis(genConfig, paWrapper, restudyComments, screenShot);
    }

    /**
    * @description Returns response from setPADefaultRequestData method at ProfitabilityAnalysis_Itf
    * @param profAnalysis : Register of profitability_analysis__c object
    * @param psBranchCode : String with pa sheet branch code
    * @param psOwnerCode : String with pa sheet owner's code
    * @return profitability_analysis__c, with response
    */
    public static profitability_analysis__c setPADefaultRequestData(profitability_analysis__c profAnalysis, String branchCode, String userCode) {
        final pa_general_configuration__mdt genConfig = Utils.getGeneralConfiguration();
        return ProfitabilityAnalysis_Helper.setPADefaultRequestData(genConfig, profAnalysis, branchCode, userCode);
    }

    /**
    * @description Returns response from setPAApprovePrice method at ProfitabilityAnalysis_Itf
    * @param profAnalysis : ProfitabilityAnalysis_Wrapper with the prof analysis info
    * @param dismissalComments : String with comments
    * @return Map<String, Object> map with the response
    */
    public static Map<String, Object> setPAApprovePrice(ProfitabilityAnalysis_Wrapper profAnalysis, String dismissalComments) {
        final pa_general_configuration__mdt genConfig = Utils.getGeneralConfiguration();
        return ProfitabilityAnalysis_Helper.setPAApprovePrice(genConfig, profAnalysis, dismissalComments);
    }

    /**
    * @description Returns response from getFirstAndLastName method at ProfitabilityAnalysis_Itf
    * @param genConfig : Metadata record with the general configuration of classes
    * @param ownerId : Id of the User/Group
    * @return String, with FirstName and LastName concatenated
    */
    public static String getFirstAndLastName(Id ownerId) {
        final pa_general_configuration__mdt genConfig = Utils.getGeneralConfiguration();
        return ProfitabilityAnalysis_Helper.getFirstAndLastName(genConfig, ownerId);
    }
}