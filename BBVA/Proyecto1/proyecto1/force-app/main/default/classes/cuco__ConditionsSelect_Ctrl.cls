/**
* ────────────────────────────────────────────────────────────────────
* ConditionsSelect_Ctrl
* Controller class for conditions_select_cmp Aura Component
* ────────────────────────────────────────────────────────────────────
* @author      Torcuato Tejada <torcuato.tejada.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-03-08
* @modified
* @systemLayer Presentation
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
public with sharing class ConditionsSelect_Ctrl {

    /*
    * @description constructor
    */
    @TestVisible
    private ConditionsSelect_Ctrl() {}

    /**
    * @description get All Active Catalñog Conditions
    * @return List of PsCatalogCondition_Wrapper
    */
    @AuraEnabled
    public static List<PsCatalogCondition_Wrapper> getActiveCatalogConditions() {
        List<PsCatalogCondition_Wrapper> res = new List<PsCatalogCondition_Wrapper>();
        try {
            res = PsCatalogCondition_Service.getActiveCatalogConditionsWrapper();
        } catch (Exception e) { //NOSONAR
            throw new AuraHandledException(e.getMessage()); //NOSONAR
        }
        return res;
    }

    /**
    * @description get All Active Catalñog Conditions
    * @return List of PsCatalogCondition_Wrapper
    */
    @AuraEnabled
    public static List<PsCatalogCondition_Wrapper> getActiveFlatCatalogConditions() {
        List<PsCatalogCondition_Wrapper> res = new List<PsCatalogCondition_Wrapper>();
        try {
            res = PsCatalogCondition_Service.getActiveFlatCatalogConditionsWrapper();
        } catch (Exception e) { //NOSONAR
            throw new AuraHandledException(e.getMessage()); //NOSONAR
        }
        return res;
    }

}