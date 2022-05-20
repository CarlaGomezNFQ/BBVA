@SuppressWarnings('sf:DMLWithoutSharingEnabled')
global class PsCatalogFamily_Selector extends bbvacep.fflib_SObjectSelector {

  global static PsCatalogFamily_Selector newInstance() {
    return (PsCatalogFamily_Selector) CUCO_Application.SELECTOR.newInstance(ps_catalog_family__c.SObjectType);
  }

  /**
  * Default constructor. Reads the fields from the getSObjectFieldList() method
  **/
  global PsCatalogFamily_Selector() {
    super(false);
  }

  /**
  * Constructor that allows a parameter to use FieldSets if True
  **/
  global PsCatalogFamily_Selector(Boolean includeFieldSetFields) {
    super(includeFieldSetFields);
    this.setDefaultFieldSet(CUCO_Application.DEFAULTFIELDSET);
  }

  /**
  * Constructor that allows a parameter to use the selected fieldsets
  **/
  global PsCatalogFamily_Selector(List <String> fieldSetList) {
    super(true);
    this.setFieldSetList(fieldSetList);
  }

  public override Schema.SObjectType getSObjectType() {
    return ps_catalog_family__c.sObjectType;
  }

  /**
  * Override default order by in all queries to the object.
  **/
  public override String getOrderBy() {
    return 'cuco__gf_psc_family_product_name__c DESC, Name';
  }

  /**
  * Returns a default list of fields if FieldSets functionality is not used (No Dependency Injection Pattern here!)
  * Use this method to add base fields to all queries to the object.
  **/
  public override List<Schema.SObjectField> getSObjectFieldList() {
    return new List<Schema.SObjectField> {
      ps_catalog_family__c.Id,
      ps_catalog_family__c.Name,
      ps_catalog_family__c.cuco__gf_psc_family_product_name__c
    };
  }

  /******** ADD OR MODIFY SELECTS FROM THIS POINT */

  global List<ps_catalog_family__c> selectById(Set<ID> idSet) {
    return (List<ps_catalog_family__c>) selectSObjectsById(idSet);
  }

  global List<ps_catalog_family__c> selectByName(Set<String> names){
    bbvacep.fflib_QueryFactory query = newQueryFactory();
    query.setCondition('Name IN :names');
    return (List<ps_catalog_family__c>) Database.query( String.escapeSingleQuotes(query.toSOQL()) );
  }

  global List<ps_catalog_family__c> selectByNameWithConditions(Set<String> names){
    bbvacep.fflib_QueryFactory query = newQueryFactory();
    bbvacep.fflib_QueryFactory queryConditions = new PsCatalogCondition_Selector(true).addQueryFactorySubselect(query);
      query.setCondition('Name IN :names');
      return (List<ps_catalog_family__c>) Database.query(String.escapeSingleQuotes(query.toSOQL() ));
  }


  /**
  * Example of where clause with a filter and a record limit
  */
  public List<ps_catalog_family__c> selectRecentlyUpdated(Integer recordLimit) {
        return (List<ps_catalog_family__c>) Database.query(String.escapeSingleQuotes(
            /**
              Query factory has been pre-initialised by calling
              getSObjectFieldList(), getOrderBy() for you.
            */
            newQueryFactory().
            /**
              Now focus on building the remainder of the
              query needed for this method.
            */
            setCondition('LastModifiedDate = LAST_N_DAYS:30').
            setLimit(recordLimit).
            // Finally build the query to execute
            toSOQL()));
    }
}