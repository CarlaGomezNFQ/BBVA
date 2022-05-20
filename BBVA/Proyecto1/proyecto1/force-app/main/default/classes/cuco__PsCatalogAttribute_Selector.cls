/**
* ____________________________________________________________________________
* PS Catalog Attribute Selector
* Selector for the object ps_catalog_attribute__c
* ____________________________________________________________________________
* @author      Diego Arias <diego.arias.fernandez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-04-16
* @modified
* @systemLayer Selector
* ____________________________________________________________________________
* @changes
*
* ____________________________________________________________________________
*/
@SuppressWarnings('sf:DMLWithoutSharingEnabled')
global class PsCatalogAttribute_Selector extends bbvacep.fflib_SObjectSelector {

    /**
    * @description newInstance
    */
    global static PsCatalogAttribute_Selector newInstance() {
        return (PsCatalogAttribute_Selector) CUCO_Application.SELECTOR.newInstance(ps_catalog_attribute__c.SObjectType);
    }

    /**
    * @description Default constructor. Reads the fields from the getSObjectFieldList() method
    */
    global PsCatalogAttribute_Selector() {
        super(false);
    }

    /**
    * @description Constructor that allows a parameter to use FieldSets if True
    */
    global PsCatalogAttribute_Selector(Boolean includeFieldSet) {
        super(includeFieldSet);
        this.setDefaultFieldSet(CUCO_Application.DEFAULTFIELDSET);
    }

    /**
    * @description Constructor that allows a parameter to use the selected fieldsets
    */
    global PsCatalogAttribute_Selector(List <String> fieldSetList) {
        super(true);
        this.setFieldSetList(fieldSetList);
    }

    /**
    * @description Override Schema.SObjectType
    */
    public override Schema.SObjectType getSObjectType() {
        return ps_catalog_attribute__c.sObjectType;
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
            ps_catalog_attribute__c.Id,
            ps_catalog_attribute__c.gf_psc_attribute_id__c
        };
    }

    /**
    * @description Select by Condition Attribute Id
    * @param idSet : Ids to filter search
    */
    global List<ps_catalog_attribute__c> selectById(Set<Id> idSet) {
        return (List<ps_catalog_attribute__c>) selectSObjectsById(idSet);
    }

    /**
    * @description Select by Attribute unique condition
    * @param names : Set of Ids to filter search
    */
    global List<ps_catalog_attribute__c> selectCatalogAttributeFromAttbCode(Set<String> attributesCodeSet) {
        return (List<ps_catalog_attribute__c>) Database.query(String.escapeSingleQuotes(
            newQueryFactory().
            setCondition('gf_psc_attribute_id__c IN :attributesCodeSet').
            toSOQL())
        );
    }

    /**
    * @description Select Attributes by id
    * @param idSet : Ids to filter search
    */
    global List<ps_catalog_attribute__c> selectByAttId(Set<Id> idSet) {
        return (List<ps_catalog_attribute__c>) Database.query(String.escapeSingleQuotes(
            newQueryFactory().
            setCondition('Id IN :idSet').
            toSOQL())
        );
    }

    /**
    * @description Select all Attributes
    * @param limitQuery : limit of query
    */
    global List<ps_catalog_attribute__c> selectAllAttributes(Integer limitQuery) {
        return (List<ps_catalog_attribute__c>) Database.query(String.escapeSingleQuotes(
            newQueryFactory().
            setLimit(limitQuery).
            toSOQL())
        );
    }
}