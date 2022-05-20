/**
* ____________________________________________________________________________
* PS Catalog Condition Attribute Selector
* Selector for the object ps_catalog_condition_attribute__c
* ____________________________________________________________________________
* @author      Torcuato Tejada <torcuato.tejada.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-02-17
* @modified
* @systemLayer Selector
* ____________________________________________________________________________
* @changes
*
* ____________________________________________________________________________
*/
@SuppressWarnings('sf:DMLWithoutSharingEnabled')
global class PsCatalogConditionAttribute_Selector extends bbvacep.fflib_SObjectSelector {

    /**
    * @description newInstance
    */
    global static PsCatalogConditionAttribute_Selector newInstance() {
        return (PsCatalogConditionAttribute_Selector) CUCO_Application.SELECTOR.newInstance(ps_catalog_condition_attribute__c.SObjectType);
    }

    /**
    * @description Default constructor. Reads the fields from the getSObjectFieldList() method
    */
    global PsCatalogConditionAttribute_Selector() {
        super(false);
    }

    /**
    * @description Constructor that allows a parameter to use FieldSets if True
    */
    global PsCatalogConditionAttribute_Selector(Boolean includeFieldSet) {
        super(includeFieldSet);
        this.setDefaultFieldSet(CUCO_Application.DEFAULTFIELDSET);
    }

    /**
    * @description Constructor that allows a parameter to use the selected fieldsets
    */
    global PsCatalogConditionAttribute_Selector(List <String> fieldSetList) {
        super(true);
        this.setFieldSetList(fieldSetList);
    }

    /**
    * @description Override Schema.SObjectType
    */
    public override Schema.SObjectType getSObjectType() {
        return ps_catalog_condition_attribute__c.sObjectType;
    }

    /**
    * @description Override default order by in all queries to the object.
    */
    public override String getOrderBy() {
        return 'Name ASC';
    }

    /**
    * @description Returns a default list of fields if FieldSets functionality
    *              is not used (No Dependency Injection Pattern here!) Use this
    *              method to add base fields to all queries to the object.
    */
    public override List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            ps_catalog_condition_attribute__c.Id,
            ps_catalog_condition_attribute__c.gf_psc_condition_id__c,
            ps_catalog_condition_attribute__c.gf_psc_atribute_id__c
        };
    }

    /**
    * @description Select by Condition Attribute Id
    * @param idSet : Ids to filter search
    */
    global List<ps_catalog_condition_attribute__c> selectById(Set<Id> idSet) {
        return (List<ps_catalog_condition_attribute__c>) selectSObjectsById(idSet);
    }

    /**
    * @description Select by Condition Id
    * @param names : Set of Ids to filter search
    */
    global List<ps_catalog_condition_attribute__c> selectConditionAttributesFromConditionIds(Set<Id> conditionIds) {
        return (List<ps_catalog_condition_attribute__c>) Database.query(String.escapeSingleQuotes(
            newQueryFactory().
            selectField('cuco__gf_psc_fa_frmlz_proc_type_name__c').
            selectField('cuco__gf_psc_cond_atrb_act_ind_type__c').
            selectField('cuco__gf_psc_fa_prc_aprvl_ind_type__c').
            selectField('cuco__gf_psc_atribute_id__r.cuco__gf_psc_bknd_svc_fmt_unit_type__c').
            selectField('cuco__gf_psc_atribute_id__r.cuco__gf_psc_bknd_svc_fmt_unit_type__c').
            setCondition('gf_psc_condition_id__c IN :conditionIds').
            setOrdering('cuco__gf_psc_ca_vslztn_ord_number__c', bbvacep.fflib_QueryFactory.SortOrder.ASCENDING, true).
            toSOQL())
        );
    }

    /**
    * @description Select by Canonical Name
    * @param names : Set of Ids to filter search
    */
    global List<ps_catalog_condition_attribute__c> selectConditionAttributesByCanonicalName(Set<Id> conditionIds, Set<String> attributeNames) {
        bbvacep.fflib_QueryFactory query = newQueryFactory();
        query.selectField('cuco__gf_psc_fa_frmlz_proc_type_name__c');
        query.selectField('cuco__gf_psc_cond_atrb_act_ind_type__c');
        query.selectField('cuco__gf_psc_fa_prc_aprvl_ind_type__c');
        query.selectField('cuco__gf_psc_atribute_id__r.cuco__gf_psc_bknd_svc_fmt_unit_type__c');
        query.selectField('cuco__gf_psc_atribute_id__r.cuco__gf_stored_prps_atrb_field_name__c');
        query.setCondition('cuco__gf_psc_condition_id__c IN :conditionIds AND cuco__gf_psc_condition_attribute_id__c IN :attributeNames');
        query.setOrdering('cuco__gf_psc_ca_vslztn_ord_number__c', bbvacep.fflib_QueryFactory.SortOrder.ASCENDING, true);
        return (List<ps_catalog_condition_attribute__c>) Database.query(String.escapeSingleQuotes(query.toSOQL()));
      }

    /**
    * @description get all condition attributes
    * @param limitQuery Integer max results number
    */
    global List<ps_catalog_condition_attribute__c> getCatalogConditionsAttribute(Integer limitQuery) {
        return (List<ps_catalog_condition_attribute__c>) Database.query(String.escapeSingleQuotes(
            newQueryFactory().
            selectField('cuco__gf_psc_condition_id__r.cuco__gf_psc_family_id__r.cuco__gf_psc_fmly_visual_ord_number__c').
            setLimit(limitQuery).
            toSOQL())
        );
    }
}