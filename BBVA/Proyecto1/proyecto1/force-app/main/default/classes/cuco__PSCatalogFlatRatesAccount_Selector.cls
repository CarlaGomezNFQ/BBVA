/**
* ────────────────────────────────────────────────────────────────────
* PS Catalog Flat Rates Account
* Selector for the object ps_catalog_flat_rates_account__c
* ────────────────────────────────────────────────────────────────────
* @author      Giancarlo Mastrogiorgio <giancarlo.mastrogiorgio.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-05-10
* @modified
* @systemLayer Selector
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@SuppressWarnings('sf:DMLWithoutSharingEnabled')
global class PSCatalogFlatRatesAccount_Selector extends bbvacep.fflib_SObjectSelector {
    /**
    * @description newInstance
    */
    global static PSCatalogFlatRatesAccount_Selector newInstance() {
        return (PSCatalogFlatRatesAccount_Selector) CUCO_Application.SELECTOR.newInstance(ps_catalog_flat_rates_account__c.SObjectType);
    }

    /**
    * @description Default constructor. Reads the fields from the getSObjectFieldList() method
    */
    global PSCatalogFlatRatesAccount_Selector() {
        super(false);
    }

    /**
    * @description Constructor that allows a parameter to use FieldSets if True
    */
    global PSCatalogFlatRatesAccount_Selector(Boolean includeFieldSet) {
        super(includeFieldSet);
        this.setDefaultFieldSet(CUCO_Application.DEFAULTFIELDSET);
    }

    /**
    * @description Constructor that allows a parameter to use the selected fieldsets
    */
    global PSCatalogFlatRatesAccount_Selector(List <String> fieldSetList) {
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
            ps_catalog_flat_rates_account__c.Id,
            ps_catalog_flat_rates_account__c.Name
        };
    }

    /**
    * @description Override Schema.SObjectType
    */
    public override Schema.SObjectType getSObjectType() {
        return ps_catalog_flat_rates_account__c.sObjectType;
    }

    /**
    * @description Select by PS Catalog Flat Rates Account Id
    * @param idSet : Ids to filter search
    */
    global List<ps_catalog_flat_rates_account__c> selectById(Set<ID> idSet) {
        return (List<ps_catalog_flat_rates_account__c>) selectSObjectsById(idSet);
    }

    /**
    * @description Select by PS Catalog Flat Rates Account
    * @param names : Set of Ids to filter search
    */
    global List<ps_catalog_flat_rates_account__c> selectAll(Integer limitQuery) {
        return (List<ps_catalog_flat_rates_account__c>) Database.query(String.escapeSingleQuotes(
            newQueryFactory().
            selectField('cuco__gf_psc_flat_rate_ac_id__c').
            selectField('cuco__gf_psc_flat_rate_ac_svc_id__c').
            selectField('cuco__gf_psc_pkg_act_fr_ac_ind_type__c').
            selectField('cuco__gf_psc_flat_rate_ac_desc__c').
            setLimit(limitQuery).
            toSOQL())
        );
    }

    /**
    * @description Select by Canonical Id
    * @param names : Set of Ids to filter search
    */
    global List<ps_catalog_flat_rates_account__c> selectByCanonicalId(Set<String> setCanonicalId) {
        return (List<ps_catalog_flat_rates_account__c>) Database.query(String.escapeSingleQuotes(
            newQueryFactory().
            setCondition('gf_psc_flat_rate_ac_svc_id__c IN :setCanonicalId').
            toSOQL())
        );
    }
}