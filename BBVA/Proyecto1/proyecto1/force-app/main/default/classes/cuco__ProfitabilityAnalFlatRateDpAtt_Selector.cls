/**
* ____________________________________________________________________________
* Profitability Analysis Flat Rates DP Attribute Selector
* Selector for the object ps_catalog_flat_rates_dp_attribute__c
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
global class ProfitabilityAnalFlatRateDpAtt_Selector extends bbvacep.fflib_SObjectSelector {

    /**
    * @description newInstance
    */
    global static ProfitabilityAnalFlatRateDpAtt_Selector newInstance() {
        return (ProfitabilityAnalFlatRateDpAtt_Selector) CUCO_Application.SELECTOR.newInstance(ps_catalog_flat_rates_dp_attribute__c.SObjectType);
    }

    /**
    * @description Default constructor. Reads the fields from the getSObjectFieldList() method
    */
    global ProfitabilityAnalFlatRateDpAtt_Selector() {
        super(false);
    }

    /**
    * @description Constructor that allows a parameter to use FieldSets if True
    */
    global ProfitabilityAnalFlatRateDpAtt_Selector(Boolean includeFieldSet) {
        super(includeFieldSet);
        this.setDefaultFieldSet(CUCO_Application.DEFAULTFIELDSET);
    }

    /**
    * @description Constructor that allows a parameter to use the selected fieldsets
    */
    global ProfitabilityAnalFlatRateDpAtt_Selector(List <String> fieldSetList) {
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
            ps_catalog_flat_rates_dp_attribute__c.Id,
            ps_catalog_flat_rates_dp_attribute__c.Name
        };
    }

    /**
    * @description Override Schema.SObjectType
    */
    public override Schema.SObjectType getSObjectType() {
        return ps_catalog_flat_rates_dp_attribute__c.sObjectType;
    }

    /**
    * @description Select by Profitability Analysis Id
    * @param idSet : Ids to filter search
    */
    global List<ps_catalog_flat_rates_dp_attribute__c> selectById(Set<ID> idSet) {
        return (List<ps_catalog_flat_rates_dp_attribute__c>) selectSObjectsById(idSet);
    }

    /**
    * @description Select by Profitability Analysis Id
    * @param idSet : Ids to filter search
    */
    global List<ps_catalog_flat_rates_dp_attribute__c> selectByProfAnalFlatRateDp(Set<Id> setPafrDp) {
        return (List<ps_catalog_flat_rates_dp_attribute__c>) Database.query( String.escapeSingleQuotes(
            newQueryFactory().
            selectField('cuco__gf_psc_fr_dynamic_pricing_id__r.cuco__gf_dp_item_classification_desc__c').
            selectField('cuco__gf_psc_fr_dynamic_pricing_id__r.cuco__gf_dynamic_pricing_item_id__c').
            selectField('cuco__gf_psc_fr_dynamic_pricing_id__r.cuco__gf_pkg_fr_defn_avail_ind_type__c').
            selectField('cuco__gf_psc_fr_dynamic_pricing_id__r.cuco__gf_dp_item_crscls_ind_type__c').
            selectField('cuco__gf_psc_fr_dynamic_pricing_id__r.Name').
            selectField('cuco__gf_psc_fr_dynamic_pricing_id__r.cuco__gf_psc_fr_dp_visual_ord_number__c').
            selectField('cuco__gf_psc_atribute_id__r.cuco__gf_stored_prps_atrb_field_name__c').
            selectField('cuco__gf_psc_atribute_id__r.cuco__gf_attribute_value_type_name__c').
            selectField('cuco__gf_psc_atribute_id__r.Name').
            selectField('cuco__gf_psc_atribute_id__r.cuco__gf_psc_bknd_svc_format_type__c').
            selectField('cuco__gf_psc_atribute_id__r.cuco__gf_psc_bknd_svc_fmt_unit_type__c').
            setCondition('cuco__gf_psc_fr_dynamic_pricing_id__c IN :setPafrDp').
            toSOQL())
        );
    }
}