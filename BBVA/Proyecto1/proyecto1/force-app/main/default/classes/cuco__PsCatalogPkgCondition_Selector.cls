/**
* ────────────────────────────────────────────────────────────────────
* Ps Catalog Package Condition
* Selector for the object ps_catalog_pkg_condition__c
* ────────────────────────────────────────────────────────────────────
* @author      Diego Arias <diego.arias.fernandez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-04-08
* @modified
* @systemLayer Selector
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@SuppressWarnings('sf:DMLWithoutSharingEnabled')
global class PsCatalogPkgCondition_Selector extends bbvacep.fflib_SObjectSelector {

    global static PsCatalogPkgCondition_Selector newInstance() {
        return (PsCatalogPkgCondition_Selector) CUCO_Application.SELECTOR.newInstance(ps_catalog_pkg_condition__c.SObjectType);
    }

    /**
    * Default constructor. Reads the fields from the getSObjectFieldList() method
    */
    global PsCatalogPkgCondition_Selector() {
        super(false);
    }

    /**
    * Constructor that allows a parameter to use FieldSets if True
    */
    global PsCatalogPkgCondition_Selector(Boolean includeFieldSetFields) {
        super(includeFieldSetFields);
        this.setDefaultFieldSet(CUCO_Application.DEFAULTFIELDSET);
    }

    /**
    * Constructor that allows a parameter to use the selected fieldsets
    */
    global PsCatalogPkgCondition_Selector(List <String> fieldSetList) {
        super(true);
        this.setFieldSetList(fieldSetList);
    }

    public override Schema.SObjectType getSObjectType() {
        return ps_catalog_pkg_condition__c.sObjectType;
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
            ps_catalog_pkg_condition__c.Id,
            ps_catalog_pkg_condition__c.gf_psc_cond_pkg_id__c
        };
    }

    /**
    * @description Select by Ps Catalog Package Id
    * @param idSet : Ids to filter search
    */
    global List<ps_catalog_pkg_condition__c> selectById(Set<ID> idSet) {
        return (List<ps_catalog_pkg_condition__c>) selectSObjectsById(idSet);
    }

    /**
    * @description Select active profitability sheet with participant id on the param acc Id set
    * @param setPkgCode : Set of pkg code to filter search
    */
    global List<ps_catalog_pkg_condition__c> retrieveConditionsOfPkg(Set<String> setPkgCode) {
        return (List<ps_catalog_pkg_condition__c>) Database.query(String.escapeSingleQuotes(
            newQueryFactory().
            setCondition('gf_psc_package_id__r.gf_psc_package_id__c IN :setPkgCode').
            toSOQL())
        );
    }
}