/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_Validate_ActivitySplits_Corp
* @Author   José Híjar García
* @Date     Created: 2020-10-15
* @Group    ARCE
* ------------------------------------------------------------------------------------------------
* @Description Class for related records table manager validations in corp
* ------------------------------------------------------------------------------------------------
* @Changes
* |2020-10-15 jose.hijar.contractor@bbva.com
*             Class creation.
* |2021-11-01 saimassimilianno.jordana.contractor@bbva.com
*             Duplicated validation added.
* -----------------------------------------------------------------------------------------------
*/
global class Arc_Gen_Validate_ActivitySplits_Corp implements rrtm.RelatedManager_Interface {

    /**
    * --------------------------------------------------------------------------------------
    * @Description Wrapper class
    * --------------------------------------------------------------------------------------
    * @Author   jose.hijar.contractor@bbva.com
    * @Date     Created: 2020-10-15
    * --------------------------------------------------------------------------------------
    **/
    @TestVisible
    class Wrapper extends rrtm.RelatedRecord_WrapperValidation {}
    /**
    * --------------------------------------------------------------------------------------
    * @Description Method that validates the info coming from some tables
    * --------------------------------------------------------------------------------------
    * @Author   jose.hijar.contractor@bbva.com
    * @Date     Created: 2020-10-15
    * @param    List<Object> lstRecords for wrapper detail
    * @return   JSON String with validation result and messages updated
    * @example static String beforeSaveData(List<Object> lstRecords)
    * --------------------------------------------------------------------------------------
    **/
    public String beforeSaveData(List<Object> lstRecords) {
        Wrapper wrapper = generateResponse(true,'');

        try {
            final Arc_Gen_SplitsValidation_Util_Corp.ValidationWrapper validation = Arc_Gen_SplitsValidation_Util_Corp.activitySubIndWValidation(lstRecords);
            if(!validation.validated) {
                wrapper=generateResponse(false,validation.errorMessg);
            }
        } catch(Exception e) {
            System.debug('Got an exception Arc_Gen_Validate_ActivitySplits_Corp::beforeSaveData -> '+ e.getStackTraceString());
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