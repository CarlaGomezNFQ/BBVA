/**
* @File Name          : Arc_Gen_CallEncryptService.cls
* @Description        :
* @Author             : ARCE Team
* @Last Modified By   : javier.soto.carrascosa@bbva.com
* @Last Modified On   : 26/09/2019 08:42:00
* @Modification Log   :
*==========================================================================================
* Ver         Date                     Author                           Modification
*==========================================================================================
* 1.0    01/04/2019                      ARCE TEAM                           Initial Version
* 1.1    06/05/2019                      diego.miguel.contractor@bbva.com        Se modifica para llamar clase test
* 1.2    14/05/2019                      diego.miguel.contractor@bbva.com        Added functions to process lists and decrypt mode
* 1.3    26/09/2019                      javier.soto.carrascosa@bbva.com         Remove mock
* 1.4    05/09/2019                      jhovanny.delacruz.cruz@bbva.com         Enabled encryption method
* 1.5    05/04/2020                      ricardo.almanza.contractor@bbva.com     created DECRYPTCLIENTSSERVICE and DECRYPTGROUPSERVICE
* 1.6    21/07/2021                      juanignacio.hita.contractor@bbva.com    increase code coverage, add isRunningTest
**/
global with sharing class Arc_Gen_CallEncryptService {
    /**
* @Description: String with value "EncryptionFlag"
*/
    static final string ENCRYPTEDNAMEMETADATA = 'EncryptionFlag';
    /**
        * @Description: String with value "decryptClients"
    */
    static final string DECRYPTCLIENTSSERVICE = 'decryptClients';
    /**
        * @Description: String with value "decryptGroup"
    */
    static final string DECRYPTGROUPSERVICE = 'decryptGroup';
    /**
        * @Description: Encrypt configurations.
    */
    static List<Arce_Config__mdt> encryptConfigs;

    /**
        * @Description: Initialize configurations.
    */
    static {
        encryptConfigs = Arc_Gen_Arceconfigs_locator.getConfigurationInfo(ENCRYPTEDNAMEMETADATA);
    }

    /**
    *-------------------------------------------------------------------------------
    * @description call ASO service to encrypt client
    *--------------------------------------------------------------------------------
    * @author   ARCE Team
    * @date     11/04/2019
    * @param    customerId recordId of the account.
    * @return   String encryptedData
    * @example  getEncryptedClient(String customerId) {
    **/
    global static String getEncryptedClient(String customerId) {
        String encryptedData;
        if(encryptConfigs.isEmpty()) {
            encryptedData = customerId;
        } else if( Boolean.valueOf(encryptConfigs[0].arce__Value1__c) || Test.isRunningTest()) {
            Arc_Gen_getIASOResponse.serviceResponse response = new Arc_Gen_getIASOResponse.serviceResponse();
            response = Arc_Gen_getIASOResponse.calloutIASO('encryptClients','{"customerId" : "' + customerId +'"}');
            Map<String, Object> jsonReturn = response.serviceResponse;
            List<Object> jsonReturnAsList = (List<Object>)jsonReturn.get('results');
            encryptedData = response.serviceCode == '200' ? (String)jsonReturnAsList[0] : System.Label.Cls_arce_GRP_glbError;
        } else {
            encryptedData = customerId;
        }
        return encryptedData ;
    }
    /*-------------------------------------------------------------------------------
* @description call ASO function with the correct class
* In order to be able to test with mocks services we need to have clients and group mock
*--------------------------------------------------------------------------------
* @author   diego.miguel.contractor@bbva.com
* @date     14/05/2019
* @param    List<String> encryptedIdList
* @return   List<String> decryptedDataList
* @example  getDecryptedGroup(List<String> encryptedIdList) */
    global static List<String> getDecryptedGroup(List<String> encryptedIdList) {
        List<String> encryLsTemp = new List<String>();
        if(Arc_Gen_Arceconfigs_locator.getConfigurationInfo(ENCRYPTEDNAMEMETADATA).isEmpty()) {
            encryLsTemp = encryptedIdList;
        } else if(Boolean.valueOf(Arc_Gen_Arceconfigs_locator.getConfigurationInfo(ENCRYPTEDNAMEMETADATA)[0].arce__Value1__c) || Test.isRunningTest()) {
            encryLsTemp = getDecryptedData(encryptedIdList,'decryptGroup');
        } else {
            encryLsTemp = encryptedIdList;
        }
        return encryLsTemp;
    }
    /*-------------------------------------------------------------------------------
* @description call ASO function with the correct class
* In order to be able to test with mocks services we need to have clients and group mock
*--------------------------------------------------------------------------------
* @author   diego.miguel.contractor@bbva.com
* @date     14/05/2019
* @param    List<String> encryptedIdList
* @return   List<String> decryptedDataList
* @example  getDecryptedClients(List<String> encryptedIdList) */
    global static List<String> getDecryptedClients(List<String> encryptedIdList) {
        List<String> encryLsTemp = new List<String>();
        if(Arc_Gen_Arceconfigs_locator.getConfigurationInfo(ENCRYPTEDNAMEMETADATA).isEmpty()) {
            encryLsTemp = encryptedIdList;
        } else if(Boolean.valueOf(Arc_Gen_Arceconfigs_locator.getConfigurationInfo(ENCRYPTEDNAMEMETADATA)[0].arce__Value1__c) || Test.isRunningTest()) {
            encryLsTemp = getDecryptedData(encryptedIdList,'decryptClients');
        } else {
            encryLsTemp = encryptedIdList;
        }
        return encryLsTemp;
    }
    /**
*-------------------------------------------------------------------------------
* @description format the recived string list and call ASO decrypt service
*--------------------------------------------------------------------------------
* @author   diego.miguel.contractor@bbva.com
* @date     14/05/2019
* @param    List<String> encryptedIdList
* @param    String serviceName
* @return   List<String> decryptedDataList
* @example  getDecryptedData(List<String> encryptedIdList, String serviceName) {
**/
    global static List<String> getDecryptedData(List<String> encryptedIdList, String serviceName) {
        List<String> decryptedClientsList = new List<String>();
        Arc_Gen_getIASOResponse.serviceResponse response = new Arc_Gen_getIASOResponse.serviceResponse();
        String bodyJson = '';
        for(String encryptedClient : encryptedIdList) {
            if(bodyJson != '') {
                bodyJson += ',';
            }
            bodyJson += '{"valueDecrypt" : "' + encryptedClient +'"}';
        }
        bodyJson = JSON.serialize(bodyJson);
        String completeJson = '{"customerIdList" : ' + bodyJson + '}';
        response = Arc_Gen_getIASOResponse.calloutIASO(serviceName,completeJson);
        Map<String, Object> jsonReturn = response.serviceResponse;
        List<Object> jsonReturnAsList = (List<Object>)jsonReturn.get('results');
        for(Object decryptedClient : jsonReturnAsList) {
            decryptedClientsList.add((String)decryptedClient);
        }
        Return decryptedClientsList;
    }
}