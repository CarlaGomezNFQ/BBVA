/**
* ────────────────────────────────────────────────────────────────────
* Dynamic_Pricing_Setup_Ctrl
* Controller class for dynamic_pricing_setup_cmp Lightning Component
* ────────────────────────────────────────────────────────────────────
* @author     Oscar Gomez <oscar.gomez.arqueros.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-05-15
* @modified
* @systemLayer Presentation
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
public with sharing class Dynamic_Pricing_Setup_Ctrl {

    // Private constructor to avoid sonar err
    @TestVisible
    private Dynamic_Pricing_Setup_Ctrl() {}

    /**
    * @description Gets dynamic pricing data to form
    * @param flatRateId : Context record id of flat rates received in the component
    * @return Map<String, Object>, with needed info
    */
    @AuraEnabled
    public static Map<String, Object> getDPData(String flatRateId) {
        try {
            return Dynamic_Pricing_Setup_Service.getDPData(flatRateId);
        } catch (Exception e) {//NOSONAR
            throw new AuraHandledException(e.getMessage()); //NOSONAR
        }
    }

    /**
    * @description Do save actions with the dynamic setup form values
    * @param strValues : String with info for operate
    * @param profAnFlatRateId : String with id of the record
    * @return Map<String,Object>, with DML Responses
    */
    @AuraEnabled
    public static Map<String,Object> doSaveActions(String strValues, String profAnFlatRateId) {
        try {
            return Dynamic_Pricing_Setup_Service.doSaveActions(strValues, profAnFlatRateId);
        }  catch (Exception e) {//NOSONAR
            throw new AuraHandledException(e.getMessage()); //NOSONAR
        }
    }
}