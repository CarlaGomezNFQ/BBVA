/**
* ────────────────────────────────────────────────────────────────────
* Profitability Sheet Flat Rates DP Selector
* Selector for the object ps_catalog_flat_rates_dp_attribute__c
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
global class PSCatalogAttributesFlatRatesDpSelector extends bbvacep.fflib_SObjectSelector {
    global static PSCatalogAttributesFlatRatesDpSelector newInstance() {
        return (PSCatalogAttributesFlatRatesDpSelector) CUCO_Application.SELECTOR.newInstance(ps_catalog_flat_rates_dp_attribute__c.SObjectType);
    }

    /**
    * Default constructor. Reads the fields from the getSObjectFieldList() method
    */
    global PSCatalogAttributesFlatRatesDpSelector() {
        super(false);
    }

    /**
    * Constructor that allows a parameter to use FieldSets if True
    */
    global PSCatalogAttributesFlatRatesDpSelector(Boolean includeFieldSetFields) {
        super(includeFieldSetFields);
        this.setDefaultFieldSet(CUCO_Application.DEFAULTFIELDSET);
    }

    /**
    * Constructor that allows a parameter to use the selected fieldsets
    */
    global PSCatalogAttributesFlatRatesDpSelector(List <String> fieldSetList) {
        super(true);
        this.setFieldSetList(fieldSetList);
    }

    public override Schema.SObjectType getSObjectType() {
        return ps_catalog_flat_rates_dp_attribute__c.sObjectType;
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
            ps_catalog_flat_rates_dp_attribute__c.Id
        };
    }

    /**
    * @description Select by Profitability Sheet Id
    * @param idSet : Ids to filter search
    */
    global List<ps_catalog_flat_rates_dp_attribute__c> selectById(Set<ID> idSet) {
        return (List<ps_catalog_flat_rates_dp_attribute__c>) selectSObjectsById(idSet);
    }

    /**
    * @description Select by Profitability Sheet Id
    * @param idSet : Ids to filter search
    */
    global List<ps_catalog_flat_rates_dp_attribute__c> selectAll() {
        bbvacep.fflib_QueryFactory query = newQueryFactory();
        return (List<ps_catalog_flat_rates_dp_attribute__c>) Database.query( String.escapeSingleQuotes(query.toSOQL()) );
    }

    /**
    * @description Select by Profitability Sheet Id
    * @param idSet : Ids to filter search
    */
    global List<ps_catalog_flat_rates_dp_attribute__c> selectDP() {
        bbvacep.fflib_QueryFactory query = newQueryFactory().setCondition('cuco__gf_psc_atribute_id__r.cuco__gf_pscd_atrb_dp_apply_ind_type__c = true AND cuco__gf_psc_atrb_active_dp_ind_type__c=true').setOrdering('cuco__gf_psc_atribute_id__r.cuco__gf_psc_atrb_vslztn_ord_number__c', bbvacep.fflib_QueryFactory.SortOrder.ASCENDING, true);
        return (List<ps_catalog_flat_rates_dp_attribute__c>) Database.query( String.escapeSingleQuotes(query.toSOQL()) );
    }

    /**
    * @description Select by Profitability Analysis Id with source= null
    * @param names : Set of Ids to filter search
    */
    global List<ps_catalog_flat_rates_dp_attribute__c> selectAllfields() {
        return (List<ps_catalog_flat_rates_dp_attribute__c>) Database.query(String.escapeSingleQuotes(
            newQueryFactory().
            selectField('Name').
            selectField('cuco__gf_psc_fr_dynamic_pricing_id__c').
            selectField('cuco__gf_psc_atribute_id__c').
            selectField('cuco__gf_dp_atrb_vslztn_ord_number__c').
            selectField('cuco__gf_psc_atrb_active_dp_ind_type__c').
            selectField('cuco__gf_psc_dynamic_pricing_atrb_id__c').
            selectField('cuco__gf_psc_fr_dynamic_pricing_id__r.cuco__gf_psc_fr_dp_visual_ord_number__c').
            toSOQL())
        );
    }

    /**
    * @description Select by PS Catalog Flat Rate DP
    * @param psCatalogId : Ids to filter search
    */
    global List<ps_catalog_flat_rates_dp_attribute__c> selectDPById(Set<Id> psCatalogId) {
        bbvacep.fflib_QueryFactory query = newQueryFactory().setCondition('cuco__gf_psc_fr_dynamic_pricing_id__c IN :psCatalogId AND cuco__gf_psc_atribute_id__r.cuco__gf_pscd_atrb_dp_apply_ind_type__c = true AND cuco__gf_psc_atrb_active_dp_ind_type__c=true').setOrdering('cuco__gf_psc_atribute_id__r.cuco__gf_psc_atrb_vslztn_ord_number__c', bbvacep.fflib_QueryFactory.SortOrder.ASCENDING, true);
        return (List<ps_catalog_flat_rates_dp_attribute__c>) Database.query( String.escapeSingleQuotes(query.toSOQL()) );
    }
}