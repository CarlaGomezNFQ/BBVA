/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_RatingErrorManagement
* @Author   Eduardo Efraín Hernández Rendón  eduardoefrain.hernandez.contractor@bbva.com
* @Date     Created: 06/05/2020
* @Group    ARCE
* -----------------------------------------------------------------------------------------------
* @Description Contains the the logic to show an appropiate error message to the user when the rating engine fails
* -----------------------------------------------------------------------------------------------
* @Changes
*
* |28/10/2019 eduardoefrain.hernandez.contractor@bbva.com
*             Class creation.
* |2021-06-23 amunguia.contractor@bbva.com it works with the parameter structure for error handling of webServices
* -----------------------------------------------------------------------------------------------
*/
global with sharing class Arc_Gen_RatingErrorManagement {
    /**
    * @Description: Service response identificator
    */
    global final static String CODE_TEXT='code';
    /**
    * @Description: Error code of Missing parameters in request
    */
    global final static String MISSING_PARAMS_EXPLICIT='mandatoryParametersMissingExplicit';
    /**
    * @Description: Error code of Missing parameters in request
    */
    global final static String MISSING_PARAMS='mandatoryParametersMissing';
    /**
    * @Description: Error code of Missing parameters in request
    */
    global final static String INVALID_PARAMS='invalidParameters';
    /**
    * @Description: Error code of Missing parameters in request
    */
    global final static String FUNCTIONAL_ERROR='functionalError';
    /**
    * @Description: Error code of Missing parameters in request
    */
    global final static String MISSING_DATA='missingData';
    /**
    * @Description: Error code of Missing parameters in request
    */
    global final static String REST_TIME_OUT='errorRestConnector';
    /**
    * @Description: Name of the iaso metadata that contains the service configuration
    */
    global final static String MESSAGE_S='message';
    /**
    * @Description: Error code of Missing parameters in request
    */
    global final static String INVALID_CALC = 'invalidLocalCalculation';
    /**
    * @Description: Error code of Missing parameters in request
    */
    global final static String TRIAGE_S = 'TRIAGE';
    /**
* @Class: RatingParameters
* @Description: Wrapper that contain the needed params to send the helper
* @author BBVA
*/
@JsonAccess(serializable='always' deserializable='always')
global class ErrorData {
    /**
    * @Description: Id of the analyzed cient
    */
    global String errorCode {get;set;}
    /**
    * @Description: Number of the client
    */
    global String errorTitle {get;set;}
    /**
    * @Description: Bank identificator
    */
    global String errorMessage {get;set;}
}
    /**
    * @description: Empty constructor
    **/
    @TestVisible
    global Arc_Gen_RatingErrorManagement() {

    }
    /**
    *-------------------------------------------------------------------------------
    * @description Method that process the service error responses
    --------------------------------------------------------------------------------
    * @author eduardoefrain.hernandez.contractor@bbva.com
    * @date 30/4/2019
    * @param Map<String, Object> responseMap
    * @return String - The error string
    * @example global static String processErrorData(Map<String, Object> responseMap)
    **/
    global static ErrorData processErrorData(Arc_Gen_getIASOResponse.serviceResponse serviceResp, String subEventType) {
        final Map<String, Object> mapName = serviceResp.serviceResponse;
        final ErrorData response = new ErrorData();
        response.errorTitle = getErrorTitle(subEventType);
        final List <Object> listServiceResp = (List <Object>) mapName.get('messages');
        List <Object> listParams = new List <Object>();
        for (Integer i = 0; i < listServiceResp.size(); i++) {
            final Map <String, Object> respMap = (Map <String, Object>) listServiceResp[i];
            final String errorCode = (String) respMap.get('code');
            response.errorCode = '('+serviceResp.serviceCode+') ' + errorCode;
            if(subEventType != TRIAGE_S) {
                listParams = (List <Object>) respMap.get('parameters');
            }
            response.errorMessage = getErrorMessage(respMap, listParams);
        }
        Return response;
    }
    /**
    *-------------------------------------------------------------------------------
    * @description Method that process the service error responses
    --------------------------------------------------------------------------------
    * @author eduardoefrain.hernandez.contractor@bbva.com
    * @date 30/4/2019
    * @param Map<String, Object> responseMap
    * @return String - The error string
    * @example global static String processErrorData(Map<String, Object> responseMap)
    **/
    global static String getErrorTitle(String subEventType) {
        String errorTitle;
        switch on subEventType {
            when 'CALCULATION' {
                errorTitle = System.Label.Arc_Gen_RatingError_CalculateError;
            }
            when 'VALIDATION' {
                errorTitle = System.Label.Arc_Gen_RatingError_ValidateError;
            }
            when 'OVERRIDE' {
                errorTitle = System.Label.Arc_Gen_RatingError_OverrideError;
            }
            when 'TRIAGE' {
                errorTitle = System.Label.Arc_Gen_TriageError_Error;
            }
        }
        Return errorTitle;
    }
    /**
    *-------------------------------------------------------------------------------
    * @description Method that process the service error responses
    --------------------------------------------------------------------------------
    * @author eduardoefrain.hernandez.contractor@bbva.com
    * @date 30/4/2019
    * @param Map<String, Object> responseMap
    * @return String - The error string
    * @example global static String processErrorData(Map<String, Object> responseMap)
    **/
    global static String getErrorMessage(Map < String, Object > respMap, List < Object > listParams) {
        String message;
        if ((String) respMap.get(CODE_TEXT) == MISSING_PARAMS_EXPLICIT || (String) respMap.get(CODE_TEXT) == MISSING_PARAMS || (String) respMap.get(CODE_TEXT) == INVALID_PARAMS || (String) respMap.get(CODE_TEXT) == FUNCTIONAL_ERROR) {
            final List <String> params = new List <String> ();
            for (Object obj: listParams) {
                final Map <String, Object> paramsMap = (Map <String, Object>) obj;
                params.add((String) paramsMap.get('name'));
            }
            message = getMissingParamsError(params);
        } else if ((String) respMap.get(CODE_TEXT) == MISSING_DATA) {
            message = getMissingDataError((String) respMap.get(MESSAGE_S), respMap);
        } else if ((String) respMap.get(CODE_TEXT) == REST_TIME_OUT) {
            message = System.Label.Arc_Gen_RatingError_ServerTimeOut;
        } else if((String) respMap.get(CODE_TEXT) == INVALID_CALC) {
            message = System.Label.Arc_Gen_RatingError_OverrideCalcError;
        } else {
            message = System.Label.Arc_Gen_RatingError_GenericError;
        }
        Return message;
    }
    /**
    *-------------------------------------------------------------------------------
    * @description Method that process the service error responses
    --------------------------------------------------------------------------------
    * @author eduardoefrain.hernandez.contractor@bbva.com
    * @date 30/4/2019
    * @param Map<String, Object> responseMap
    * @return String - The error string
    * @example global static String processErrorData(Map<String, Object> responseMap)
    **/
    global static String getMissingParamsError(List <String> params) {
        String message;
        String errorCode = '';
        if(!params.isEmpty()) {
            errorCode = params.get(0);
        }
        switch on errorCode {
            when 'businessAgent.id' {
                message = System.Label.Arc_Gen_RatingError_MissingFedId;
            }
            when 'bank.branch.id' {
                message = System.Label.Arc_Gen_RatingError_MissingBranchId;
            }
            when 'bank.branch.level.id' {
                message = System.Label.Arc_Gen_RatingError_MissingBranchLevel;
            }
            when 'bank.id' {
                message = System.Label.Arc_Gen_RatingError_MissingBankId;
            }
            when else {
                message = params.isEmpty() ? System.Label.Arc_Gen_RatingError_GenericError : String.format(System.Label.Arc_Gen_RatingError_CallService, params);
            }
        }
        return message;
    }
    /**
    *-------------------------------------------------------------------------------
    * @description Method that process the service error responses
    --------------------------------------------------------------------------------
    * @author eduardoefrain.hernandez.contractor@bbva.com
    * @date 30/4/2019
    * @param Map<String, Object> responseMap
    * @return String - The error string
    * @example global static String processErrorData(Map<String, Object> responseMap)
    **/
    global static String getMissingDataError(String errorCode, Map < String, Object > respMap) {
        String message;
        Switch on errorCode {
            When 'Unable to persist rating' {
                message = System.Label.Arc_Gen_RatingError_RiskAssessmnent;
            }
            When 'Unable to call detail of financial statement service' {
                message = System.Label.Arc_Gen_RatingError_InvalidEEFF;
            }
            When 'Unable to call customer service' {
                message = System.Label.Arc_Gen_RatingError_CustomerServError;
            }
            When
            else {
                message = System.Label.Arc_Gen_RatingError_GenericError + ' - ' + (String) respMap.get(MESSAGE_S);
            }
        }
        Return message;
    }
}