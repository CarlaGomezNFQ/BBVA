/**
* ────────────────────────────────────────────────────────────────────
* Client Package Selector
* Selector for the object client_package__c
* ────────────────────────────────────────────────────────────────────
* @author      Diego Arias <diego.arias.fernandez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-02-24
* @modified
* @systemLayer Selector
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@SuppressWarnings('sf:DMLWithoutSharingEnabled')
global class ClientPackage_Selector extends bbvacep.fflib_SObjectSelector {

    global static ClientPackage_Selector newInstance() {
        return (ClientPackage_Selector) CUCO_Application.SELECTOR.newInstance(client_package__c.SObjectType);
    }

    /**
    * Default constructor. Reads the fields from the getSObjectFieldList() method
    */
    global ClientPackage_Selector() {
        super(false);
    }

    /**
    * Constructor that allows a parameter to use FieldSets if True
    */
    global ClientPackage_Selector(Boolean includeFieldSetFields) {
        super(includeFieldSetFields);
        this.setDefaultFieldSet(CUCO_Application.DEFAULTFIELDSET);
    }

    /**
    * Constructor that allows a parameter to use the selected fieldsets
    */
    global ClientPackage_Selector(List <String> fieldSetList) {
        super(true);
        this.setFieldSetList(fieldSetList);
    }

    public override Schema.SObjectType getSObjectType() {
        return client_package__c.sObjectType;
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
            client_package__c.Id,
            client_package__c.gf_entity_id__c
        };
    }

    /**
    * @description Select by Profitability Sheet Id
    * @param idSet : Ids to filter search
    */
    global List<client_package__c> selectById(Set<ID> idSet) {
        return (List<client_package__c>) selectSObjectsById(idSet);
    }

    /**
    * @description Select client packages related to Acc set id when status is on param list
    * @param setAccId : Ids of related account to filter search
    * @param lstStatus : List of status to filter search
    */
    global List<client_package__c> selectPkgByAccIdAndStatus(Set<Id> setAccId, List<String> lstStatus) {
        return (List<client_package__c>) Database.query(String.escapeSingleQuotes(
            newQueryFactory().
            setCondition('gf_cst_pkg_ct_status_type__c IN :lstStatus AND participant_id__c IN :setAccId').
            toSOQL())
        );
    }

    /**
    * @description Select client packages related to Acc set id when status is on param list and have a PS Catalog Package with type in param lstType
    * @param setAccId : Ids of related account to filter search
    * @param lstStatus : List of status to filter search
    * @param lstType : List of PS Catalog Package type to filter search
    */
    global List<client_package__c> selectPkgByAccIdAndStatusAndPkgType(Set<Id> setAccId, List<String> lstStatus, List<String> lstType) {
        return (List<client_package__c>) Database.query(String.escapeSingleQuotes(
            newQueryFactory().
            setCondition('gf_cst_pkg_ct_status_type__c IN :lstStatus AND participant_id__c IN :setAccId AND gf_psc_package_code_id__r.gf_psc_package_type_name__c IN :lstType').
            toSOQL())
        );
    }

    /**
    * @description Select client packages when status is on param list and have a PS Catalog Package with type in param lstType and account id in setAccId
    * @param lstStatus : List of status to filter search
    * @param setAccId : Set of account id to filter search
    * @param lstType : List of PS Catalog Package type to filter search
    */
    global List<client_package__c> selectPkgByStatusAndAccIdAndPkgType(List<String> lstStatus, Set<Id> setAccId, List<String> lstType) {
        return (List<client_package__c>) Database.query(String.escapeSingleQuotes(
            newQueryFactory().
            setCondition('gf_cst_pkg_ct_status_type__c IN :lstStatus AND participant_id__c IN :setAccId AND gf_psc_package_code_id__r.gf_psc_package_type_name__c IN :lstType').
            toSOQL())
        );
    }

    /**
    * @description Select client packages when status is on param list and have a PS Catalog Package with type in param lstType and id in lstPkgId
    * @param lstStatus : List of status to filter search
    * @param setPkgId : List of PS Catalog Package Id to filter search
    * @param setAccId : Set of account id to filter search
    */
    global List<client_package__c> selectPkgByStatusAndPkgIdAndPkgType(List<String> lstStatus, Set<String> setPkgId, Set<Id> setAccId) {
        final bbvacep.fflib_QueryFactory query =  newQueryFactory().
                                            setCondition('gf_cst_pkg_ct_status_type__c IN :lstStatus AND gf_psc_package_code_id__r.gf_psc_package_id__c IN :setPkgId AND participant_id__c IN :setAccId').
                                            setOrdering('cuco__gf_cust_pkg_ct_effective_date__c', bbvacep.fflib_QueryFactory.SortOrder.DESCENDING, true);
        if (lstStatus.contains('Cancelled')) {
            query.setLimit(1);
        }
        return (List<client_package__c>) Database.query( String.escapeSingleQuotes(query.toSOQL()) );
    }
}