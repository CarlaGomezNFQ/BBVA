/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_StructureGroups_SP2_Service
* @Author   amunguia.contractor@bbva.com
* @Date     Created: 18/03/2021
* @Group    ARCE
* -----------------------------------------------------------------------------------------------
* @Description Arc_Gen_StructureGroups_SP2_Service
* -----------------------------------------------------------------------------------------------
* @Changes
*
* |18-03-2021 amunguia.contractor@bbva.com
*             Class creation.
* -----------------------------------------------------------------------------------------------
*/
public inherited sharing class Arc_Gen_StructureGroups_SP2_Service {
    /**
    *-------------------------------------------------------------------------------
    * @description Empty constructor to avoid SonarQube warning.
    *-------------------------------------------------------------------------------
    **/
    @TestVisible
    private Arc_Gen_StructureGroups_SP2_Service() {

    }
    /**
    * @Description: serviceMessage Structure
    */
    private static arce.Arc_Gen_CustomServiceMessages serviceMessages = new arce.Arc_Gen_CustomServiceMessages();

    /**
    * @description call ParentGroups service
    * @author amunguia.contractor@bbva.com | 03-18-2021
    * @param String customerNumber
    * @param String economicGroupId
    * @return Arc_Gen_ParentGroups_SP2_RP return service
    **/
    public static Arc_Gen_ParentGroups_SP2_RP callParentGroups(String customerNumber, String economicGroupId) {
        final Arc_Gen_ParentGroups_SP2_RP returndata = new Arc_Gen_ParentGroups_SP2_RP();
        arce.Arc_Gen_getIASOResponse.serviceResponse sResponse = new arce.Arc_Gen_getIASOResponse.serviceResponse();
        final Arc_Gen_ParentGroups_SP2_RP.RequestParentGroup request = new Arc_Gen_ParentGroups_SP2_RP.RequestParentGroup(customerNumber, economicGroupId);
        final String params = JSON.serialize(request);
        try {
            sResponse = callEngine('getParentGroupsSP2', params);
            returndata.addMessage(sResponse.serviceCode, sResponse.serviceMessage, null);
        } catch (Exception e) {
            returndata.addMessage(String.valueOf(serviceMessages.CODE_500), e.getMessage(), e.getStackTraceString());
            System.debug('ERROR: ' + e.getMessage() + e.getStackTraceString());
        }
        if(sResponse.serviceMessage == serviceMessages.SUCCESSFUL_200) {
            returndata.response = (Arc_Gen_ParentGroups_SP2_RP.Response) JSON.deserialize(JSON.serialize(sResponse.serviceResponse), Arc_Gen_ParentGroups_SP2_RP.Response.class);
        }
        return returndata;
    }

    /**
    * @description call EconomicParticipation service
    * @author amunguia.contractor@bbva.com | 03-18-2021
    * @param String encryptedClient
    * @return Arc_Gen_EconomicPart_Sp2_RP
    **/
    public static Arc_Gen_EconomicPart_Sp2_RP callEconomicParticipations(String encryptedClient) {
        final String customerId = arce.Arc_Gen_CallEncryptService.getEncryptedClient(encryptedClient);
        final Arc_Gen_EconomicPart_Sp2_RP returndata = new Arc_Gen_EconomicPart_Sp2_RP();
        final String params = JSON.serialize(new Map<String, String>{'customerId' => customerId});// params to economic participant service
        arce.Arc_Gen_getIASOResponse.serviceResponse sResponse = new arce.Arc_Gen_getIASOResponse.serviceResponse();
        try {
            sResponse = callEngine('economicParticipationsSP2', params);
            returndata.addMessage(sResponse.serviceCode, sResponse.serviceMessage, null);
        } catch (Exception e) {
            returndata.addMessage(String.valueOf(serviceMessages.CODE_500), e.getMessage(), e.getStackTraceString());
            System.debug('ERROR: ' + e.getMessage() + e.getStackTraceString());
        }
        if(sResponse.serviceMessage == serviceMessages.SUCCESSFUL_200) {
            returndata.response = (Arc_Gen_EconomicPart_Sp2_RP.Response) JSON.deserialize(JSON.serialize(sResponse.serviceResponse), Arc_Gen_EconomicPart_Sp2_RP.Response.class);
        }
        return returndata;
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