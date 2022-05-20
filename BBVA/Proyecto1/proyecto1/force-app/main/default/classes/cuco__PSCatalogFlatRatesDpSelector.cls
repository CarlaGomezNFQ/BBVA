/**
* ────────────────────────────────────────────────────────────────────
* Profitability Sheet Flat Rates DP Selector
* Selector for the object ps_catalog_flat_rates_dp__c
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
global class PSCatalogFlatRatesDpSelector extends bbvacep.fflib_SObjectSelector {
    global static PSCatalogFlatRatesDpSelector newInstance() {
        return (PSCatalogFlatRatesDpSelector) CUCO_Application.SELECTOR.newInstance(ps_catalog_flat_rates_dp__c.SObjectType);
    }

    /**
    * Default constructor. Reads the fields from the getSObjectFieldList() method
    */
    global PSCatalogFlatRatesDpSelector() {
        super(false);
    }

    /**
    * Constructor that allows a parameter to use FieldSets if True
    */
    global PSCatalogFlatRatesDpSelector(Boolean includeFieldSetFields) {
        super(includeFieldSetFields);
        this.setDefaultFieldSet(CUCO_Application.DEFAULTFIELDSET);
    }

    /**
    * Constructor that allows a parameter to use the selected fieldsets
    */
    global PSCatalogFlatRatesDpSelector(List <String> fieldSetList) {
        super(true);
        this.setFieldSetList(fieldSetList);
    }

    public override Schema.SObjectType getSObjectType() {
        return ps_catalog_flat_rates_dp__c.sObjectType;
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
            ps_catalog_flat_rates_dp__c.Id
        };
    }

    /**
    * @description Select by Profitability Sheet Id
    * @param idSet : Ids to filter search
    */
    global List<ps_catalog_flat_rates_dp__c> selectById(Set<ID> idSet) {
        return (List<ps_catalog_flat_rates_dp__c>) selectSObjectsById(idSet);
    }
    /**
    * @description Select by Profitability Sheet Id
    * @param idSet : Ids to filter search
    */
    global List<ps_catalog_flat_rates_dp__c> selectAll() {
        bbvacep.fflib_QueryFactory query = newQueryFactory();
        return (List<ps_catalog_flat_rates_dp__c>) Database.query( String.escapeSingleQuotes(query.toSOQL()) );
    }

    /**
    * @description Select all ps_catalog_flat_rates_dp__c order by visualization order
    */
    global List<ps_catalog_flat_rates_dp__c> selectAllOrder() {
        return (List<ps_catalog_flat_rates_dp__c>) Database.query(String.escapeSingleQuotes(
            newQueryFactory().
            setOrdering('cuco__gf_psc_fr_dp_visual_ord_number__c', bbvacep.fflib_QueryFactory.SortOrder.ASCENDING, true).
            toSOQL())
        );
    }

    /**
    * @description Select by Names
    * @param names : names to filter search
    */
    global List<ps_catalog_flat_rates_dp__c> selectByName(Set<String> names) {
        return (List<ps_catalog_flat_rates_dp__c>) Database.query(String.escapeSingleQuotes(
            newQueryFactory().
            setCondition('Name IN :names').
            toSOQL())
        );
    }
}