/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_IASO_Utils_Interface
* @Author   juanignacio.hita.contractor@bbva.com
* @Date     Created: 2020-12-17
* @Group    ARCE
* ------------------------------------------------------------------------------------------------
* @Description Interface to implement local services
* ------------------------------------------------------------------------------------------------
* @Changes
*
* |2020-12-17 juanignacio.hita.contractor@bbva.com
*             Class creation.
* -----------------------------------------------------------------------------------------------
*/
global interface Arc_Gen_IASO_Utils_Interface {
    /**
    * --------------------------------------------------------------------------------------
    * @Description Calls the IASO service and returns in JSON the Arc_Gen_getIASOResponse.ServiceResponse
    * --------------------------------------------------------------------------------------
    * @Author  juanignacio.hita.contractor@bbva.com
    * @Date    Created: 2020-12-17
    * @param   Map<String, Object> mapParams - Map with the request params
    * @return  Arc_Gen_getIASOResponse.ServiceResponse JSON serialize with the Arc_Gen_ServiceAndSaveResponse data wrapper
    * @example Arc_Gen_getIASOResponse.ServiceResponse serv = callService(mapParams);
    * --------------------------------------------------------------------------------------
    **/
    Arc_Gen_getIASOResponse.ServiceResponse callService(String request);
    /**
    * --------------------------------------------------------------------------------------
    * @Description Setups the response of the service and execute local actions (update, insert...)
    *              returns a ServiceAndSave response wrapper.
    * --------------------------------------------------------------------------------------
    * @Author  juanignacio.hita.contractor@bbva.com
    * @Date    Created: 2020-12-17
    * @param   Arc_Gen_ServiceAndSaveResponse - Service and save response wrapper
    * @param   Map<String, Object> mapParams - Map with the request params
    * @return  Arc_Gen_ServiceAndSaveResponse
    * @example Arc_Gen_ServiceAndSaveResponse serv = setupService(serviceResponse, mapParams)
    * --------------------------------------------------------------------------------------
    **/
    Arc_Gen_ServiceAndSaveResponse setupService(Arc_Gen_getIASOResponse.ServiceResponse serviceResponse, Map<String, Object> mapParams);
    /**
    * --------------------------------------------------------------------------------------
    * @Description Setup the request for call to service return a json request
    * --------------------------------------------------------------------------------------
    * @Author  juanignacio.hita.contractor@bbva.com
    * @Date    Created: 2020-12-17
    * @param   Map<String, Object> mapParams - Map with the request params
    * @return  String
    * @example String setServiceParams(mapParams);
    * --------------------------------------------------------------------------------------
    **/
    String setServiceParams(Map<String, Object> mapParams);

}