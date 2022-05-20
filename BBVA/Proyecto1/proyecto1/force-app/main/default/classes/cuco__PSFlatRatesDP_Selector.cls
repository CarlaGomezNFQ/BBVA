/**
* ────────────────────────────────────────────────────────────────────
* Profitability Sheet Flat Rates DP Selector
* Selector for the object profitability_sheet_flat_rates_dp__c
* ────────────────────────────────────────────────────────────────────
* @author      Diego Martinez <diego.martinez.chollet.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-04-14
* @modified
* @systemLayer Selector
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@SuppressWarnings('sf:DMLWithoutSharingEnabled')
global class PSFlatRatesDP_Selector extends bbvacep.fflib_SObjectSelector {
    global static PSFlatRatesDP_Selector newInstance() {
        return (PSFlatRatesDP_Selector) CUCO_Application.SELECTOR.newInstance(profitability_sheet_flat_rates_dp__c.SObjectType);
    }

    /**
    * Default constructor. Reads the fields from the getSObjectFieldList() method
    */
    global PSFlatRatesDP_Selector() {
        super(false);
    }

    /**
    * Constructor that allows a parameter to use FieldSets if True
    */
    global PSFlatRatesDP_Selector(Boolean includeFieldSetFields) {
        super(includeFieldSetFields);
        this.setDefaultFieldSet(CUCO_Application.DEFAULTFIELDSET);
    }

    /**
    * Constructor that allows a parameter to use the selected fieldsets
    */
    global PSFlatRatesDP_Selector(List <String> fieldSetList) {
        super(true);
        this.setFieldSetList(fieldSetList);
    }

    public override Schema.SObjectType getSObjectType() {
        return profitability_sheet_flat_rates_dp__c.sObjectType;
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
            profitability_sheet_flat_rates_dp__c.Id
        };
    }

    /**
    * @description Select by Profitability Sheet Id
    * @param idSet : Ids to filter search
    */
    global List<profitability_sheet_flat_rates_dp__c> selectById(Set<ID> idSet) {
        return (List<profitability_sheet_flat_rates_dp__c>) selectSObjectsById(idSet);
    }
    /**
    * @description Select by Profitability Sheet Id
    * @param idSet : Ids to filter search
    */
    global List<profitability_sheet_flat_rates_dp__c> selectByFlatId(Set<Id> flatRateSet) {
        bbvacep.fflib_QueryFactory query = newQueryFactory();
        query.setCondition('gf_ps_flat_rate_id__c IN :flatRateSet');
        return (List<profitability_sheet_flat_rates_dp__c>) Database.query( String.escapeSingleQuotes(query.toSOQL()) );
    }
}