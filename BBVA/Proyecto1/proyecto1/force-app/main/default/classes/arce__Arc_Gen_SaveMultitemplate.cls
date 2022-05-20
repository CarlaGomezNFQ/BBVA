/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_SaveMultitemplate
* @Author   amunguia.contractor@bbva.com
* @Date     Created: 10/09/2021
* @Group    ARCE
* -----------------------------------------------------------------------------------------------
* @Description Class that manages dyanmic form save for Industry Risk.
* -----------------------------------------------------------------------------------------------
* @Changes
*
* |10-09-2021 amunguia.contractor@bbva.com
*             Class creation.
* -----------------------------------------------------------------------------------------------
*/
global with sharing class Arc_Gen_SaveMultitemplate implements dyfr.Save_Interface {
    /**
        * @Description: string with the class name of object Acc has analysis ARCE
    */
    Static Final String ARCAHA = 'arce__Activity_Split_2012__c';
    /**
    * @description serviceMessage
    **/
    private static arce.Arc_Gen_CustomServiceMessages serviceMessages = new arce.Arc_Gen_CustomServiceMessages();
    /**
    * @description update GCP values method
    * @author amunguia.contractor@bbva.com | 09-10-2021
    * @param List<sObject> listObject
    * @return String JSON save
    **/
    public String save(List<sObject> listObject) {
        arce__Activity_Split_2012__c act2012;
        Arc_Gen_getIASOResponse.ServiceResponse multiResp = new Arc_Gen_getIASOResponse.ServiceResponse();
        String retValue;
        for(Integer i = 0;  listObject.size() > i ; i++) {
            if(ARCAHA.equals(String.valueOf(listObject[i].getSObjectType().getDescribe().getName()))) {
                act2012 = (arce__Activity_Split_2012__c) listObject.remove(i);
            }
        }

        final arce__Activity_Split_2012__c act =  Arc_Gen_Activities_Util.getAllActByParent2012ById(new Set<String>{act2012.Id})[0];
        try {
            multiResp = Arc_Gen_SP2_MultiPersistence_Service.callSpecificMultitemplate((arce__Activity_Split_2012__c) Arc_Gen_Corporate_Utils.mergeRecords(act,act2012,'arce__Activity_Split_2012__c'), '2012');
            retValue = JSON.serialize(new arce.Arc_Gen_wrpSave(true,'',listObject));
            if(multiResp.serviceCode == '200' || multiResp.serviceCode == '201') {
                final arce__Account_has_Analysis__c accHasAnalysis = arce.Arc_Gen_AccHasAnalysis_Data.getAccHasAnalysis(new List<String>{act.arce__Account_has_Analysis__c})[0];
                Arc_Gen_initAdjustment_Controller.getRtngIdRiskAss(accHasAnalysis.Id);
                final Arc_Gen_IndustryRiskRating_RP response = Arc_Gen_IndustryRiskRating_Service.callIndustryRiskRating(accHasAnalysis);
                retValue = JSON.serialize(new arce.Arc_Gen_wrpSave(true,'',listObject));
                if(response.isSuccessfull(serviceMessages.SUCCESSFUL_200)) {
                    final Map<String, Decimal> scoreMap = response.calculateRatingScore();
                    act2012.arce__Industry_Risk__c = scoreMap.get(Arc_Gen_RatingGlobal_Constants.INDUSTRY_RISK_RATING);
                    listObject.add(act2012);
                    retValue = JSON.serialize(new arce.Arc_Gen_wrpSave(true,'',listObject));
                } else {
                    retValue = JSON.serialize(new arce.Arc_Gen_wrpSave(false,response.messageError(),listObject));
                }
            }
        } catch(Exception e) {
            retValue = JSON.serialize(new arce.Arc_Gen_wrpSave(false,e.getMessage(),listObject));
            System.debug(e.getMessage()+e.getStackTraceString());
        }
        return retValue;
    }
}