/**
* ____________________________________________________________________________
* Profitability Sheet Catalog Condition Service
* Service class for the object ps_catalog_condition__c
* ____________________________________________________________________________
* @author      Torcuato Tejada <torcuato.tejada.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-03-08
* @modified
* @systemLayer Service
* ____________________________________________________________________________
* @changes
*
* ____________________________________________________________________________
*/
@SuppressWarnings('sf:DMLWithoutSharingEnabled')
public class PsCatalogCondition_Service {

    /**
    * @description private constructor.
    */
    @TestVisible
    private PsCatalogCondition_Service() {}

    /**
    * @description returns active Catalog Conditions
    * @return List<ps_catalog_condition__c> : List of Conditions
    */
    public static List<ps_catalog_condition__c> getActiveCatalogConditions() {
        return PsCatalogCondition_Helper.getActiveCatalogConditions();
    }

    /**
    * @description returns Catalog Conditions from Ids
    * @param pscConditionIds Set<Id> Set of Condition Ids
    * @return List<ps_catalog_condition__c> : List of Conditions
    */
    public static List<ps_catalog_condition__c> getCatalogConditionsFromIds(Set<Id> pscConditionIds) {
        return PsCatalogCondition_Helper.getCatalogConditionsFromIds(pscConditionIds);
    }

    /**
    * @description returns Catalog Conditions from a Family Id
    * @param familyId familyId
    * @return List<ps_catalog_condition__c> : List of Conditions
    */
    public static List<ps_catalog_condition__c> getCatalogConditionsFromFamilyId(Id familyId) {
        return PsCatalogCondition_Helper.getCatalogConditionsFromFamilyId(familyId);
    }

    /**
    * @descriptionreturns active Catalog Conditions with Flat Conditions Allowed from Catalog Conditions
    * @return List<ps_catalog_condition__c> : List of Conditions
    */
    public static List<ps_catalog_condition__c> getActiveFlatCatalogConditions() {
        return PsCatalogCondition_Helper.getActiveFlatCatalogConditions();
    }

    /**
    * @description returns active Conditions Catalog Conditions
    * @return List<PsCatalogCondition_Wrapper> : List of Conditions wrapper
    */
    public static List<PsCatalogCondition_Wrapper> getActiveCatalogConditionsWrapper() {
        final List<ps_catalog_condition__c> conditions = getActiveCatalogConditions();
        return PsCatalogCondition_Helper.getCatalogConditionsWrapper(conditions);
    }

    /**
    * @description returns active Conditions with Flat Conditions Allowed from Catalog Conditions
    * @return List<PsCatalogCondition_Wrapper> : List of Conditions wrapper
    */
    public static List<PsCatalogCondition_Wrapper> getActiveFlatCatalogConditionsWrapper() {
        final List<ps_catalog_condition__c> conditions = getActiveFlatCatalogConditions();
        return PsCatalogCondition_Helper.getCatalogConditionsWrapper(conditions);
    }

}