/**
* ────────────────────────────────────────────────────────────────────
* PsCatalogCondition_Wrapper
* Wrapper class for for Profitability Sheet Catalog Conditions
* ────────────────────────────────────────────────────────────────────
* @author      Torcuato Tejada <torcuato.tejada.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-03-08
* @modified
* @systemLayer Domain
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@SuppressWarnings('PMD.AvoidGlobalModifier, PMD.ExcessivePublicCount')
global class PsCatalogCondition_Wrapper {

    /* @description Product Name */
    @AuraEnabled
    public String name {get; set;}

    /* @description Id  */
    @AuraEnabled
    public String id {get; set;}

    /* @description Id  */
    @AuraEnabled
    public String pscConditionId {get; set;}

    /* @description Family Name  */
    @AuraEnabled
    public String familyName {get; set;}

    /* @description Family Identifier  */
    @AuraEnabled
    public String familyId {get; set;}

    /* @description Family Name  */
    @AuraEnabled
    public Integer familyOrder {get; set;}

    /* @description Product Name  */
    @AuraEnabled
    public String productName {get; set;}

    /* @description Allow Flat Selection?  */
    @AuraEnabled
    public Boolean allowFlatSel {get; set;}

    /* @description has Price Class?  */
    @AuraEnabled
    public Boolean priceClass {get; set;}

    /* @description Is Family Level?  */
    @AuraEnabled
    public Boolean familyLevel {get; set;}

    /* @description Manual form. if international package?  */
    @AuraEnabled
    public Boolean manualIntl {get; set;}

    /* @description Visualization Order  */
    @AuraEnabled
    public Integer order {get; set;}
}