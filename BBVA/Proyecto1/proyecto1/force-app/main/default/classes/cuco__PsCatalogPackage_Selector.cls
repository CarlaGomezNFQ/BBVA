/**
* ────────────────────────────────────────────────────────────────────
* Ps Catalog Package Selector
* Selector for the object ps_catalog_package__c
* ────────────────────────────────────────────────────────────────────
* @author      Diego Arias <diego.arias.fernandez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-03-03
* @modified
* @systemLayer Selector
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@SuppressWarnings('sf:DMLWithoutSharingEnabled')
global class PsCatalogPackage_Selector extends bbvacep.fflib_SObjectSelector {

    global static PsCatalogPackage_Selector newInstance() {
        return (PsCatalogPackage_Selector) CUCO_Application.SELECTOR.newInstance(ps_catalog_package__c.SObjectType);
    }

    /**
    * Default constructor. Reads the fields from the getSObjectFieldList() method
    */
    global PsCatalogPackage_Selector() {
        super(false);
    }

    /**
    * Constructor that allows a parameter to use FieldSets if True
    */
    global PsCatalogPackage_Selector(Boolean includeFieldSetFields) {
        super(includeFieldSetFields);
        this.setDefaultFieldSet(CUCO_Application.DEFAULTFIELDSET);
    }

    /**
    * Constructor that allows a parameter to use the selected fieldsets
    */
    global PsCatalogPackage_Selector(List <String> fieldSetList) {
        super(true);
        this.setFieldSetList(fieldSetList);
    }

    public override Schema.SObjectType getSObjectType() {
        return ps_catalog_package__c.sObjectType;
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
            ps_catalog_package__c.Id,
            ps_catalog_package__c.gf_psc_package_id__c,
            ps_catalog_package__c.gf_psc_package_code_id__c,
            ps_catalog_package__c.cuco__gf_psc_package_name__c,
            ps_catalog_package__c.gf_psc_pkg_geo_scope_type_name__c,
            ps_catalog_package__c.gf_psc_package_type_name__c,
            ps_catalog_package__c.gf_psc_extended_pkg_ind_type__c
        };
    }

    /**
    * @description Select by Ps Catalog Package Id
    * @param idSet : Ids to filter search
    */
    global List<ps_catalog_package__c> selectById(Set<ID> idSet) {
        return (List<ps_catalog_package__c>) selectSObjectsById(idSet);
    }

    /**
    * @description Select by Ps Catalog Package Name
    * @param names : Set of names to filter search
    */
    global List<ps_catalog_package__c> selectByName(Set<String> names) {
        bbvacep.fflib_QueryFactory query = newQueryFactory();
        query.setCondition('Name IN :names');
        return (List<ps_catalog_package__c>) Database.query( String.escapeSingleQuotes(query.toSOQL()) );
    }

    /**
    * @description Select by Ps Catalog Package Name
    * @param names : Set of names to filter search
    */
    global List<ps_catalog_package__c> selectByPkgCode(Set<String> lstPkgCodes) {
        bbvacep.fflib_QueryFactory query = newQueryFactory();
        query.setCondition('gf_psc_package_id__c IN :lstPkgCodes');
        return (List<ps_catalog_package__c>) Database.query( String.escapeSingleQuotes(query.toSOQL()) );
    }

    /**
    * @description Select by Package Type and active type true
    * @param lstPkgType : Set of pkg type to filter search
    */
    global List<ps_catalog_package__c> selectByPkgTypeAndActiveRecord(Set<String> lstPkgType) {
        return (List<ps_catalog_package__c>) Database.query( String.escapeSingleQuotes(
            newQueryFactory().
            setCondition('gf_psc_package_type_name__c IN :lstPkgType AND gf_psc_package_active_ind_type__c = true').
            setOrdering('cuco__gf_psc_package_code_id__c', bbvacep.fflib_QueryFactory.SortOrder.ASCENDING, true).
            toSOQL())
        );
    }

    /**
    * @description Select by Ps Catalog Package Type Name
    * @param lstPkgTypeName : Set of pkg type names to filter search
    */
    global List<ps_catalog_package__c> selectByPkgTypeName(Set<String> lstPkgTypeName) {
        return (List<ps_catalog_package__c>) Database.query( String.escapeSingleQuotes(
            newQueryFactory().
            setCondition('gf_psc_package_type_name__c IN :lstPkgTypeName').
            toSOQL())
        );
    }

}