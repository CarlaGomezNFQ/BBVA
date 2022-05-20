/**
* ____________________________________________________________________________
* PS Catalog Condition Attribute Selector
* Selector for the object ps_catalog_condition__c
* ____________________________________________________________________________
* @author      Jorge Queipo <jotge.queipo.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-02-01
* @modified
* @systemLayer Selector
* ____________________________________________________________________________
* @changes
*
* ____________________________________________________________________________
*/
@SuppressWarnings('sf:DMLWithoutSharingEnabled')
global without sharing class PsCatalogCondition_Selector extends bbvacep.fflib_SObjectSelector {

  /**
  * @description newInstance
  */
  global static PsCatalogCondition_Selector newInstance() {
    return (PsCatalogCondition_Selector) CUCO_Application.SELECTOR.newInstance(ps_catalog_condition__c.SObjectType);
  }

  /**
  * Default constructor. Reads the fields from the getSObjectFieldList() method
  **/
  global PsCatalogCondition_Selector() {
    super(false);
  }

  /**
  * Constructor that allows a parameter to use FieldSets if True
  **/
  global PsCatalogCondition_Selector(Boolean includeFieldSetFields) {
    super(includeFieldSetFields);
    this.setDefaultFieldSet(CUCO_Application.DEFAULTFIELDSET);
  }

  /**
  * Constructor that allows a parameter to use the selected fieldsets
  **/
  global PsCatalogCondition_Selector(List <String> fieldSetList) {
    super(true);
    this.setFieldSetList(fieldSetList);
  }

  public override Schema.SObjectType getSObjectType() {
    return ps_catalog_condition__c.sObjectType;
  }

  /**
  * Override default order by in all queries to the object.
  **/
  public override String getOrderBy() {
    return 'cuco__gf_psc_family_id__r.cuco__gf_psc_fmly_visual_ord_number__c ASC, cuco__gf_psc_cond_visual_ord_number__c ASC';
  }

  /**
  * Returns a default list of fields if FieldSets functionality is not used (No Dependency Injection Pattern here!)
  * Use this method to add base fields to all queries to the object.
  **/
  public override List<Schema.SObjectField> getSObjectFieldList() {
    return new List<Schema.SObjectField> {
      ps_catalog_condition__c.Id,
      ps_catalog_condition__c.Name,
      ps_catalog_condition__c.gf_psc_cond_fmly_lvl_ind_type__c
    };
  }

  /******** ADD OR MODIFY SELECTS FROM THIS POINT */

  global List<ps_catalog_condition__c> selectById(Set<ID> idSet) {
    return (List<ps_catalog_condition__c>) selectSObjectsById(idSet);
  }

  global List<ps_catalog_condition__c> selectByName(Set<String> names) {
    bbvacep.fflib_QueryFactory query = newQueryFactory();
    query.setCondition('Name IN :names');
    return (List<ps_catalog_condition__c>) Database.query(String.escapeSingleQuotes(query.toSOQL()));
  }

  global List<ps_catalog_condition__c> selectByFamily(Id familyId) {
    bbvacep.fflib_QueryFactory query = newQueryFactory();
    query.setCondition('cuco__gf_psc_family_id__c = :familyId AND cuco__gf_psc_cond_avail_ind_type__c = true');
    query.setOrdering('cuco__gf_psc_cond_visual_ord_number__c', bbvacep.fflib_QueryFactory.SortOrder.ASCENDING, true);
    return (List<ps_catalog_condition__c>) Database.query(String.escapeSingleQuotes(query.toSOQL()));
  }

  /**
  * @description Select conditions by ids
  * @param names : Set of Ids to filter search
  */
  global List<ps_catalog_condition__c> selectCatalogConditionsFromIds(Set<ID> idSet) {
    return (List<ps_catalog_condition__c>) Database.query(String.escapeSingleQuotes(
        newQueryFactory().
        setCondition('Id IN :idSet').
        toSOQL())
    );
  }

  /**
  * @description Select all active conditions
  * @param names : Set of Ids to filter search
  */
  global List<ps_catalog_condition__c> selectActiveCatalogConditions() {
    return (List<ps_catalog_condition__c>) Database.query(String.escapeSingleQuotes(
        newQueryFactory().
        setCondition('cuco__gf_psc_cond_avail_ind_type__c = true').
        setOrdering('cuco__gf_psc_family_id__r.cuco__gf_psc_fmly_visual_ord_number__c', bbvacep.fflib_QueryFactory.SortOrder.ASCENDING, true).
        toSOQL())
    );
  }

  /**
  * @description Select all active conditions that allow Flat Selection
  * @param names : Set of Ids to filter search
  */
  global List<ps_catalog_condition__c> selectActiveFlatCatalogConditions() {
    return (List<ps_catalog_condition__c>) Database.query(String.escapeSingleQuotes(
      newQueryFactory().
      setCondition('cuco__gf_psc_cond_flat_rate_ind_type__c = true AND cuco__gf_psc_cond_avail_ind_type__c = true').
      setOrdering('cuco__gf_psc_family_id__r.cuco__gf_psc_fmly_visual_ord_number__c', bbvacep.fflib_QueryFactory.SortOrder.ASCENDING, true).
      toSOQL())
    );
  }

  /**
  * @description Select all active conditions with prices
  * @param names : Set of Ids to filter search
  */
  global List<ps_catalog_condition__c> selectConditionsPrice(Set<ID> idSet) {
    return (List<ps_catalog_condition__c>) Database.query(String.escapeSingleQuotes(
      newQueryFactory().
      setCondition('Id IN :idSet AND cuco__gf_psc_cond_prc_class_ind_type__c = true').
      setOrdering('cuco__gf_psc_family_id__r.cuco__gf_psc_fmly_visual_ord_number__c', bbvacep.fflib_QueryFactory.SortOrder.ASCENDING, true).
      toSOQL())
    );
  }

  /**
  * @description Select by cuco__gf_psc_condition_id__c
  * @param names : Set of Strings to filter search
  */
  global List<ps_catalog_condition__c> selectPriceClassConditions() {
    return (List<ps_catalog_condition__c>) Database.query(String.escapeSingleQuotes(
      newQueryFactory().
      setCondition('cuco__gf_psc_cond_prc_class_ind_type__c = true').
      toSOQL())
    );
  }
}