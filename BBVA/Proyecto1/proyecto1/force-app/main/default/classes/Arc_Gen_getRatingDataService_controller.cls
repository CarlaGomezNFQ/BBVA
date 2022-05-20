/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_getRatingDataService_controller
* @Author   Eduardo Efraín Hernández Rendón  eduardoefrain.hernandez.contractor@bbva.com
* @Date     Created: 22/10/2019
* @Group    ARCE
* -----------------------------------------------------------------------------------------------
* @Description Obtains the response of the rating calculation service
* -----------------------------------------------------------------------------------------------
* @Changes
*
* |28/10/2019 eduardoefrain.hernandez.contractor@bbva.com
*             Class creation.
* |23/7/2019  eduardoefrain.hernandez.contractor@bbva.com
*             Added comments.
* |2020-04-14 mariohumberto.ramirez.contractor@bbva.com
*             Added setupRatingPrev method
* |25/5/2020  juanignacio.hita.contractor@bbva.com
*             Added "getCustomerData" and "validationQualitativeQuestion" methods
* |16/6/2020  joseluis.garcia4.contractor@bbva.com
*             Raise an error if calculating a rating on an analysis with no permission to edit.
* |2020-06-29 mariohumberto.ramirez.contractor@bbva.com
*             Update class for HU GADRDCDE-1577 Mejora Tabla Información Financiera
*             The call to the rating service for the previous financial statement was eliminated
* |16/7/2020  joseluis.garcia4.contractor@bbva.com
*             Clear Leveraged Test results after calculating rating.
* |17/09/2020 eduardoefrain.hernandez.contractor@bbva.com
*             Add throwAuraExcept method instead of "throw new AuraHandledException"
* |2020-09-23 saimassimilianno.jordana.contractor@bbva.com
*             Added arce. namespace to all classes that are now in the arce-dependencies package
* |2021-04-30 otiliaramona.veres.contractor@bbva.com
* 			  Added an empty constructor method.
* |2021-05-04 otiliaramona.veres.contractor@bbva.com
* 			  Added annotation '@testVisible' to the empty constructor method.
* -----------------------------------------------------------------------------------------------
*/
public without sharing class Arc_Gen_getRatingDataService_controller {
    /**
    * @Description: Error Literal
    */
    private final static String ERROR_TEXT = 'Error';
    /**
    * @Description: False Literal
    */
    private final static String FALSE_TEXT = 'false';
    /**
    *-------------------------------------------------------------------------------
    * @description Empty constructor method
    *-------------------------------------------------------------------------------
    *@author otiliaramona.veres.contractor@bbva.com
    *@Date   Created:2021-04-30
    */
    @TestVisible
    private Arc_Gen_getRatingDataService_controller() { }
    /**
    * @Class: ClientData
    * @Description: Wrapper that contain all the rating service parameters
    * @author BBVA
    */
    public class ClientData {
        /**
        * @Description: Indicates name of the customer
        */
        @AuraEnabled public String customerName {get;set;}
        /**
        * @Description: Indicates if the numeber of the customer
        */
        @AuraEnabled public String customerId {get;set;}
    }
    /**
    *-------------------------------------------------------------------------------
    * @description Method to get the selected analysis from the id (account has analysis object)
    --------------------------------------------------------------------------------
    * @author juanignacio.hita.contractor@bbva.com
    * @date 21/05/2020
    * @param String accHasId
    * @return arce__Analysis__c
    * @example arce__Analysis__c arce = Arc_Gen_getRatingDataService_controller.getAnalysis(accHasId)
    **/
    @AuraEnabled
    public static arce__Analysis__c getAnalysis(String accHasId) {
        try {
            return arce.Arc_Gen_ArceAnalysis_Data.gerArce(accHasId);
        } catch (Exception e) {
            throw new AuraHandledException(System.Label.Arc_Gen_ApexCallError + e);
        }
    }
    /**
    *-------------------------------------------------------------------------------
    * @description Method that gets the client data
    --------------------------------------------------------------------------------
    * @author eduardoefrain.hernandez.contractor@bbva.com
    * @date 30/4/2019
    * @param String analysisId
    * @return ClientData - A wrapper with the data of the client
    * @example public static ClientData getCustomerData(String analysisId
    **/
    @AuraEnabled
    public static ClientData getCustomerData(String analysisId) {
        ClientData data = new ClientData();
        List<String> customerData = new List<String>();
        customerData = Arc_Gen_getRatingDataService_service.getCustomerData(analysisId);
        data.customerName = customerData[0];
        data.customerId = customerData[1];
        Return data;
    }
    /**
    *-------------------------------------------------------------------------------
    * @description Method that gets the response FROM the service class
    --------------------------------------------------------------------------------
    * @author eduardoefrain.hernandez.contractor@bbva.com
    * @date 30/4/2019
    * @param String analysisId
    * @param String customerId
    * @return arce.Arc_Gen_ServiceAndSaveResponse - A wrapper with the result of a DML operation and service call
    * @example public static arce.Arc_Gen_ServiceAndSaveResponse setupRating(String analysisId,String customerId)
    **/
    @AuraEnabled
    public static arce.Arc_Gen_ServiceAndSaveResponse setupRating(String analysisId, String customerId, String serviceMock) {
        arce.Arc_Gen_ServiceAndSaveResponse response = new arce.Arc_Gen_ServiceAndSaveResponse();
        final Boolean hasPermissions = Arc_Gen_TabSet_service.getPermissionToEdit(analysisId) == 'true';
        if (hasPermissions) {
            try {
                if(serviceMock == ERROR_TEXT) {
                    throw new CalloutException();
                }
                response = Arc_Gen_getRatingDataService_service.setupRating(analysisId, customerId, null, serviceMock);

                // Clear Leveraged Test results.
                Arc_Gen_TestLeverage_service.clearTestLeveragedResults(analysisId);
            } catch(CalloutException ex) {
                response.saveStatus = FALSE_TEXT;
                response.serviceMessage = ex.getMessage();
            }
        } else {
            final Map<String, Object> errorWrapper = new Map<String, Object>();
            errorWrapper.put('errorCode', '403');
            errorWrapper.put('errorTitle', System.Label.Arc_Gen_Error);
            errorWrapper.put('errorMessage', System.Label.Arc_Gen_Generic_NotAllowed);
            response.serviceCode = '403';
            response.serviceMessage = JSON.serialize(errorWrapper);
        }
        return response;
    }
    /**
    *-------------------------------------------------------------------------------
    * @description Method that validate qualitative questions
    --------------------------------------------------------------------------------
    * @author juanignacio.hita.contractor@bbva.com
    * @date 24/04/2020
    * @param String accHasId
    * @return Map<String, List<dyfr__Field_Config__c>>
    * @example Map<String, List<dyfr__Field_Config__c>> lstFc = Arc_Gen_getRatingDataService_controller.validationQualitativeQuestion(accHasId)
    **/
    @AuraEnabled
    public static Map<String, List<dyfr__Field_Config__c>> validationQualitativeQuestion(String accHasId, arce__Analysis__c analysis) {
        Map<String, List<dyfr__Field_Config__c>> mapTabEmptyFc = new Map<String, List<dyfr__Field_Config__c>>();
        try {
            // Get sector and tabset information, the map contains the name of the template and code of the sector
            final List<arce__Account_has_Analysis__c> lstAccHasAnalysis = arce.Arc_Gen_AccHasAnalysis_Data.getAccHasAnalysis(new List<String>{accHasId});
            final Map<String, String> mapTabset = Arc_Gen_Sector_Data.getMapTabSet(lstAccHasAnalysis[0], analysis.arce__anlys_wkfl_sub_process_type__c);
            mapTabEmptyFc = Arc_Gen_getRatingDataService_service.validationQualitativeQuestion(accHasId, mapTabset);
        } catch (Exception e) {
            arce.Arc_Gen_GenericUtilities.throwAuraExcept(System.Label.Arc_Gen_ApexCallError + e.getMessage() + ' - ' + e.getStackTraceString());
        }
        return mapTabEmptyFc;
    }
}