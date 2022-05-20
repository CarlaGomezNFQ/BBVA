/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_Validate_GeoSplits_Corp
* @Author   José Híjar García
* @Date     Created: 2020-10-15
* @Group    ARCE
* ------------------------------------------------------------------------------------------------
* @Description Class for related records table manager validations in corp
* ------------------------------------------------------------------------------------------------
* @Changes
* |2020-10-15 jose.hijar.contractor@bbva.com
*             Class creation.
* -----------------------------------------------------------------------------------------------
*/
global class Arc_Gen_Validate_GeoSplits_Corp implements rrtm.RelatedManager_Interface {

    /**
    * --------------------------------------------------------------------------------------
    * @Description Wrapper class
    * --------------------------------------------------------------------------------------
    * @Author   jose.hijar.contractor@bbva.com
    * @Date     Created: 2020-10-15
    * --------------------------------------------------------------------------------------
    **/
    @testVisible
    class Wrapper extends rrtm.RelatedRecord_WrapperValidation {}
    /**
    * --------------------------------------------------------------------------------------
    * @Description Method that validates the info coming from some tables
    * --------------------------------------------------------------------------------------
    * @Author   jose.hijar.contractor@bbva.com
    * @Date     Created: 2020-10-15
    * @param    List<Object> lstRecords for wrapper detail
    * @return   JSON String with validation result and messages updated
    * @example String beforeSaveData(List<Object> lstRecords)
    * --------------------------------------------------------------------------------------
    **/
    public String beforeSaveData(List<Object> lstRecords) {
        Wrapper wrapper = generateResponse(true,'');
        try{
            if(!Arc_Gen_SplitsValidation_Util_Corp.geoGeographicWeightValidation(lstRecords)) {
                wrapper=generateResponse(false,Label.Arc_Gen_geoGeographicWeight_error);
            }
        }catch(Exception e) {
            System.debug('Got an exception Arc_Gen_Validate_GeoSplits_Corp::beforeSaveData -> '+ e.getStackTraceString());
            wrapper=generateResponse(false,Label.Arc_Gen_SplitValidation_GenErr);
        }
        return JSON.serialize(wrapper);
    }

    /**
    * --------------------------------------------------------------------------------------
    * @Description generate de response object
    * --------------------------------------------------------------------------------------
    * @Author   jose.hijar.contractor@bbva.com
    * @Date     Created: 2020-10-15
    * @param    Boolean validation status
    * @param    String status message to be displayed to the user
    * @return   response object
    * @example generateResponse(true,'validation message')
    * --------------------------------------------------------------------------------------
    **/
    private Wrapper generateResponse(Boolean validation,String msg) {
        Wrapper ret = new Wrapper();
        ret.validation = validation;
        ret.msgInfo = msg;
        return ret;
    }
}