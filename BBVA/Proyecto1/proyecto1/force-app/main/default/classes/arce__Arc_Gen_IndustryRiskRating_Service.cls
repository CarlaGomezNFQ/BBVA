/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_IndustryRiskRating_Service
* @Author   amunguia.contractor@bbva.com
* @Date     Created: 16/09/2021
* @Group    ARCE
* -----------------------------------------------------------------------------------------------
* @Description Class that manages dynamic form save for Industry Risk.
* -----------------------------------------------------------------------------------------------
* @Changes
*
* |16-09-2021 amunguia.contractor@bbva.com
*             Class creation.
* -----------------------------------------------------------------------------------------------
*/
public with sharing class Arc_Gen_IndustryRiskRating_Service {
    /**
    *-------------------------------------------------------------------------------
    * @description Empty constructor to avoid SonarQube warning.
    *-------------------------------------------------------------------------------
    **/
    @TestVisible
    private Arc_Gen_IndustryRiskRating_Service() {

    }
    /**
    * @Description: serviceMessage Structure
    */
    private static arce.Arc_Gen_CustomServiceMessages serviceMessages = new arce.Arc_Gen_CustomServiceMessages();

    /**
    * @description call IndustryRiskRating service
    * @author amunguia.contractor@bbva.com | 16-09-2021
    * @param arce__Account_has_Analysis__c accHasAnalysis
    * @return Arc_Gen_IndustryRiskRating_RP return service
    **/
    public static Arc_Gen_IndustryRiskRating_RP callIndustryRiskRating(arce__Account_has_Analysis__c accHasAnalysis) {
        arce.Arc_Gen_getIASOResponse.serviceResponse sResponse = new arce.Arc_Gen_getIASOResponse.serviceResponse();
        final Arc_Gen_IndustryRiskRating_RP returnData = new Arc_Gen_IndustryRiskRating_RP();
        final arce.Arc_Gen_RatingGlobal_helper.HelperParameters helperWrapper = new arce.Arc_Gen_RatingGlobal_helper.HelperParameters(accHasAnalysis,null,Arc_Gen_RatingGlobal_Constants.INDUSTRY_RISK_RATING);
        final Arc_Gen_Account_Has_Analysis_Wrapper analyzedClient = Arc_Gen_AccHasAnalysis_Data.getAccountHasAnalysisAndCustomer(new List<String>{accHasAnalysis.Id})[0];
        helperWrapper.setBankId(analyzedClient.accWrapperObj.bankId);

        try {
            sResponse = callEngine('ratingEngine', arce.Arc_Gen_RatingGlobal_helper.setServiceParameters(helperWrapper));
            returndata.addMessage(sResponse.serviceCode, sResponse.serviceMessage, null);
        } catch (Exception e) {
            returndata.addMessage(String.valueOf(serviceMessages.CODE_500), e.getMessage(), e.getStackTraceString());
            System.debug('ERROR: ' + e.getMessage() + e.getStackTraceString());
        }
        if(sResponse.serviceMessage == serviceMessages.SUCCESSFUL_200) {
            returndata.response = (Arc_Gen_IndustryRiskRating_RP.Response) JSON.deserialize(JSON.serialize(sResponse.serviceResponse), Arc_Gen_IndustryRiskRating_RP.Response.class);
        }
        return returnData;
    }

    /**
    * @description call IASO
    * @author amunguia.contractor@bbva.com | 03-18-2021
    * @param String serviceName
    * @param String params
    * @return arce.Arc_Gen_getIASOResponse.serviceResponse
    **/
    private static arce.Arc_Gen_getIASOResponse.serviceResponse callEngine(String serviceName, String params) {
        return arce.Arc_Gen_getIASOResponse.calloutIASO(serviceName,params);
    }
}