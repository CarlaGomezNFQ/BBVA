/**
* ____________________________________________________________________________
* Profitability Analysis Flat Rates Selector
* Selector for the object profitability_analysis_flat_rates_dp__c
* ____________________________________________________________________________
* @author      Miguel Cabrera <miguel.cabrera@bbvaitspain.com>
* @modifiedBy
* @version     1.0
* @created     2021-04-22
* @modified
* @systemLayer Selector
* ____________________________________________________________________________
* @changes
*
* ____________________________________________________________________________
*/
@SuppressWarnings('sf:DMLWithoutSharingEnabled')
global class ProfitabilityAnalysiFlatRateDp_Selector extends bbvacep.fflib_SObjectSelector {

    /**
    * @description newInstance
    */
    global static ProfitabilityAnalysiFlatRateDp_Selector newInstance() {
        return (ProfitabilityAnalysiFlatRateDp_Selector) CUCO_Application.SELECTOR.newInstance(profitability_analysis_flat_rates_dp__c.SObjectType);
    }

    /**
    * @description Default constructor. Reads the fields from the getSObjectFieldList() method
    */
    global ProfitabilityAnalysiFlatRateDp_Selector() {
        super(false);
    }

    /**
    * @description Constructor that allows a parameter to use FieldSets if True
    */
    global ProfitabilityAnalysiFlatRateDp_Selector(Boolean includeFieldSet) {
        super(includeFieldSet);
        this.setDefaultFieldSet(CUCO_Application.DEFAULTFIELDSET);
    }

    /**
    * @description Constructor that allows a parameter to use the selected fieldsets
    */
    global ProfitabilityAnalysiFlatRateDp_Selector(List <String> fieldSetList) {
        super(true);
        this.setFieldSetList(fieldSetList);
    }

    /**
    * Override default order by in all queries to the object.
    */
    public override String getOrderBy() {
        return 'CreatedDate DESC';
    }

    /**
    * Returns a default list of fields if FieldSets functionality is not used (No Dependency Injection Pattern here!)
    * Use this method to add base fields to all queries to the object.
    */
    public override List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            profitability_analysis_flat_rates_dp__c.Id,
            profitability_analysis_flat_rates_dp__c.Name
        };
    }

    /**
    * @description Override Schema.SObjectType
    */
    public override Schema.SObjectType getSObjectType() {
        return profitability_analysis_flat_rates_dp__c.sObjectType;
    }

    /**
    * @description Select by Profitability Analysis Id
    * @param idSet : Ids to filter search
    */
    global List<profitability_analysis_flat_rates_dp__c> selectById(Set<ID> idSet) {
        return (List<profitability_analysis_flat_rates_dp__c>) selectSObjectsById(idSet);
    }

    /**
    * @description Select by Profitability Analysis Id
    * @param idSet : Ids to filter search
    */
    global List<profitability_analysis_flat_rates_dp__c> selectByProfAnalysisFlatRate(Set<Id> lstProfAnalFlatRates) {
        return (List<profitability_analysis_flat_rates_dp__c>) Database.query( String.escapeSingleQuotes(
            newQueryFactory().
            selectField('cuco__gf_fr_dynamic_pricing_item_id__r.cuco__gf_dp_item_classification_desc__c').
            selectField('cuco__gf_fr_dynamic_pricing_item_id__r.Name').
            selectField('cuco__gf_pa_flat_rate_id__r.cuco__gf_profitablity_analysis_id__c').
            setCondition('cuco__gf_pa_flat_rate_id__c IN :lstProfAnalFlatRates').
            toSOQL())
        );
    }

    /**
    * @description Select by Dynamic pricing Id
    * @param idSet : Ids to filter search
    */
    global List<profitability_analysis_flat_rates_dp__c> selectByPricing(Set<String> nameSet) {
        return (List<profitability_analysis_flat_rates_dp__c>) Database.query( String.escapeSingleQuotes(
            newQueryFactory().
            selectField('cuco__gf_fr_dynamic_pricing_item_id__r.Name').
            selectField('cuco__gf_pa_fr_dp_annual_prc_amount__c').
            selectField('cuco__gf_pa_fr_dp_neg_anl_ope_amount__c').
            setCondition('cuco__gf_fr_dynamic_pricing_item_id__r.Name IN :nameSet').
            toSOQL())
        );
    }
}