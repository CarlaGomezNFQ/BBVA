/**
* ____________________________________________________________________________
* PS Catalog Condition Standard Selector
* Selector for the object ps_catalog_condition_standard__c
* ____________________________________________________________________________
* @author      Diego Martinez <diego.martinez.chollet.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-03-24
* @modified
* @systemLayer Selector
* ____________________________________________________________________________
* @changes
*
* ____________________________________________________________________________
*/
@SuppressWarnings('sf:DMLWithoutSharingEnabled')
global class PsCatalogConditionStandard_Selector extends bbvacep.fflib_SObjectSelector {

  /**
  * @description newInstance
  */
  global static PsCatalogConditionStandard_Selector newInstance() {
    return (PsCatalogConditionStandard_Selector) CUCO_Application.SELECTOR.newInstance(ps_catalog_condition_standard__c.SObjectType);
  }

  /**
  * Default constructor. Reads the fields from the getSObjectFieldList() method
  **/
  global PsCatalogConditionStandard_Selector() {
    super(false);
  }

  /**
  * Constructor that allows a parameter to use FieldSets if True
  **/
  global PsCatalogConditionStandard_Selector(Boolean includeFieldSetFields) {
    super(includeFieldSetFields);
    this.setDefaultFieldSet(CUCO_Application.DEFAULTFIELDSET);
  }

  /**
  * Constructor that allows a parameter to use the selected fieldsets
  **/
  global PsCatalogConditionStandard_Selector(List <String> fieldSetList) {
    super(true);
    this.setFieldSetList(fieldSetList);
  }

  public override Schema.SObjectType getSObjectType() {
    return ps_catalog_condition_standard__c.sObjectType;
  }

  /**
  * Override default order by in all queries to the object.

  public override String getOrderBy() {
    return 'cuco__gf_psc_cond_visual_ord_number__c ASC, Name';
  }
  **/
  /**
  * Returns a default list of fields if FieldSets functionality is not used (No Dependency Injection Pattern here!)
  * Use this method to add base fields to all queries to the object.
  **/
  public override List<Schema.SObjectField> getSObjectFieldList() {
    return new List<Schema.SObjectField> {
    ps_catalog_condition_standard__c.Id,
    ps_catalog_condition_standard__c.gf_psc_condition_attribute_id__r.gf_psc_condition_attribute_id__c,
    ps_catalog_condition_standard__c.gf_cond_atrb_max_val_name__c,
    ps_catalog_condition_standard__c.gf_cond_atrb_min_val_name__c,
    ps_catalog_condition_standard__c.gf_cond_atrb_standard_val_name__c
    };
  }

  /******** ADD OR MODIFY SELECTS FROM THIS POINT */

  global List<cuco__ps_catalog_condition_standard__c> selectActive() {
    bbvacep.fflib_QueryFactory query = newQueryFactory();
    query.setCondition('gf_psc_condition_attribute_id__r.gf_psc_cond_atrb_act_ind_type__c = true');
    return (List<cuco__ps_catalog_condition_standard__c>) Database.query(String.escapeSingleQuotes(query.toSOQL()));
  }

}