/**
* ────────────────────────────────────────────────────────────────────
* Profitability Analysis Pkg Request Selector
* Selector for the object profitability_analysis_pkg_request__c
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
@SuppressWarnings('sf:DMLWithoutSharingEnabled, PMD.ExcessiveParameterList')
global class PAPackageRequest_Selector extends bbvacep.fflib_SObjectSelector {

    global static PAPackageRequest_Selector newInstance() {
        return (PAPackageRequest_Selector) CUCO_Application.SELECTOR.newInstance(profitability_analysis_pkg_request__c.SObjectType);
    }

    /**
    * Default constructor. Reads the fields from the getSObjectFieldList() method
    */
    global PAPackageRequest_Selector() {
        super(false);
    }

    /**
    * Constructor that allows a parameter to use FieldSets if True
    */
    global PAPackageRequest_Selector(Boolean includeFieldSetFields) {
        super(includeFieldSetFields);
        this.setDefaultFieldSet(CUCO_Application.DEFAULTFIELDSET);
    }

    /**
    * Constructor that allows a parameter to use the selected fieldsets
    */
    global PAPackageRequest_Selector(List <String> fieldSetList) {
        super(true);
        this.setFieldSetList(fieldSetList);
    }

    public override Schema.SObjectType getSObjectType() {
        return profitability_analysis_pkg_request__c.sObjectType;
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
            profitability_analysis_pkg_request__c.Id,
            profitability_analysis_pkg_request__c.Name
        };
    }

    /**
    * @description Select by Profitability Sheet Id
    * @param idSet : Ids to filter search
    */
    global List<profitability_analysis_pkg_request__c> selectById(Set<ID> idSet) {
        return (List<profitability_analysis_pkg_request__c>) selectSObjectsById(idSet);
    }

    /**
    * @description Select profitability analysis package request with request type Cancellation filter by prof analysis and client package set
    * @param setClientPkg : Ids of related client packages to filter search
    * @param profAnalysisId: Id of related prof analysis Id to filter search
    * @param lstReqType : List of request type to filter search
    */
    global List<profitability_analysis_pkg_request__c> selectPkgReqByReqType(Set<Id> setClientPkg, Id profAnalysisId, List<String> lstReqType) {
        return (List<profitability_analysis_pkg_request__c>) Database.query(String.escapeSingleQuotes(
            newQueryFactory().
            setCondition('gf_profitablity_analysis_id__c =: profAnalysisId AND gf_cust_package_id__c IN :setClientPkg AND gf_pa_pkg_request_type_name__c IN :lstReqType').
            toSOQL())
        );
    }

    /**
    * @description Select profitability analysis package request filter by participantId (From Prof Analysis Participant) and request type
    * @param setPapId: Id of related prof analysis participant id to filter search
    * @param lstReqType : List of request type to filter search
    */
    global List<profitability_analysis_pkg_request__c> selectPkgReqByAccAndReqType(Set<Id> setPapId, List<String> lstReqType) {
        return (List<profitability_analysis_pkg_request__c>) Database.query(String.escapeSingleQuotes(
            newQueryFactory().
            setCondition('participant_id__c IN :setPapId AND gf_pa_pkg_request_type_name__c IN :lstReqType').
            toSOQL())
        );
    }

    /**
    * @description Select profitability analysis package request filter by participantId (From Prof Analysis Participant)
    * @param setPapId: Id of related prof analysis participant id to filter search
    */
    global List<profitability_analysis_pkg_request__c> selectPkgReqByAcc(Set<Id> setPapId) {
        return (List<profitability_analysis_pkg_request__c>) Database.query(String.escapeSingleQuotes(
            newQueryFactory().
            setCondition('participant_id__c IN :setPapId').
            toSOQL())
        );
    }

    /**
    * @description Select profitability analysis package request filter by profitability analysis Id with related client package null or filter by req type and ext req type, and PS Catalog Package with type in param lstType
    * @param setProfAnalysis: Id of related prof analysis id to filter search
    * @param lstType: List of PS Catalog Package type to filter search
    * @param lstReqType: List of request type to filter search
    * @param lstExtReqType: List of extension request type to filter search
    * @param lstStatus: List of status to fiter search
    */
    global List<profitability_analysis_pkg_request__c> selectPkgReqByReqExt(Set<Id> setProfAnalysis, List<String> lstType, List<String> lstReqType, List<String> lstExtReqType, List<String> lstStatus) {
        return (List<profitability_analysis_pkg_request__c>) Database.query(String.escapeSingleQuotes(
            newQueryFactory().
            setCondition('gf_profitablity_analysis_id__c IN :setProfAnalysis AND gf_psc_package_id__r.gf_psc_package_type_name__c IN :lstType AND gf_pa_pkg_request_type_name__c IN :lstReqType AND gf_pa_pkg_ext_req_st_type_name__c IN :lstExtReqType AND gf_cust_package_id__c != null AND gf_cust_package_id__r.gf_cst_pkg_ct_status_type__c IN :lstStatus').
            toSOQL())
        );
    }

    /**
    * @description Select profitability analysis package request filter by profitability analysis Id with related client package null and PS Catalog Package with type in param lstType
    * @param setProfAnalysis: Id of related prof analysis id to filter search
    * @param lstType: List of PS Catalog Package type to filter search
    */
    global List<profitability_analysis_pkg_request__c> selectPkgReqWithoutCP(Set<Id> setProfAnalysis, List<String> lstType) {
        return (List<profitability_analysis_pkg_request__c>) Database.query(String.escapeSingleQuotes(
            newQueryFactory().
            setCondition('gf_profitablity_analysis_id__c IN :setProfAnalysis AND gf_psc_package_id__r.gf_psc_package_type_name__c IN :lstType AND gf_cust_package_id__c = null').
            toSOQL())
        );
    }

    /**
    * @description Select profitability analysis package request filter by client package id and profitability analysis id
    * @param setClientPackage: Id of related client package id to filter search
    */
    global List<profitability_analysis_pkg_request__c> selectPkgReqByClientPackageId(Set<Id> setClientPackage, Set<Id> setProfAnalysisId) {
        return (List<profitability_analysis_pkg_request__c>) Database.query(String.escapeSingleQuotes(
            newQueryFactory().
            setCondition('gf_cust_package_id__c IN :setClientPackage AND gf_profitablity_analysis_id__c IN :setProfAnalysisId').
            toSOQL())
        );
    }

    /**
    * @description Select profitability analysis package request filter by profitability analysis participant, package id and request type
    * @param setPAP: Set of profitability analysis participant to filter search
    * @param setPkgId: Set of package ids to filter search
    * @param setType: Set of request type to filter search
    */
    global List<profitability_analysis_pkg_request__c> selectPkgReqByPAPAndPkgAndReqType(Set<Id> setPAP, Set<Id> setPkgId, Set<String> setType) {
        return (List<profitability_analysis_pkg_request__c>) Database.query(String.escapeSingleQuotes(
            newQueryFactory().
            setCondition('participant_id__c IN :setPAP AND gf_psc_package_id__c IN :setPkgId AND gf_pa_pkg_request_type_name__c IN :setType').
            toSOQL())
        );
    }

    /**
    * @description Select profitability analysis package request filter by profitability analysis participant, and request type
    * @param setPAP: Set of profitability analysis participant to filter search
    * @param setType: Set of request type to filter search
    */
    global List<profitability_analysis_pkg_request__c> selectPkgReqByPAPAndReqType(Set<Id> setPAP, Set<String> setType) {
        return (List<profitability_analysis_pkg_request__c>) Database.query(String.escapeSingleQuotes(
            newQueryFactory().
            setCondition('participant_id__c IN :setPAP AND gf_pa_pkg_request_type_name__c IN :setType').
            toSOQL())
        );
    }

    /**
    * @description Select profitability analysis package request filter by prof analysis and catalogId
    * @param setCatId : Ids of related catalog packages to filter search
    * @param profAnalysisId: Id of related prof analysis Id to filter search
    */
    global List<profitability_analysis_pkg_request__c> selectPkgReqByCat(Set<Id> setCatId, Id profAnalysisId) {
        return (List<profitability_analysis_pkg_request__c>) Database.query(String.escapeSingleQuotes(
            newQueryFactory().
            setCondition('gf_profitablity_analysis_id__c =: profAnalysisId AND gf_cust_package_id__r.gf_psc_package_code_id__c IN :setCatId').
            toSOQL())
        );
    }

    /**
    * @description Select profitability analysis package request filter by profitability analysis, participant_id with null value
    * @param setProfAnalysisId: Set of prof analysis id to filter search
    */
    global List<profitability_analysis_pkg_request__c> selectPkgReqByAnWithoutParticipant(Set<Id> setProfAnalysisId) {
        return (List<profitability_analysis_pkg_request__c>) Database.query(String.escapeSingleQuotes(
            newQueryFactory().
            setCondition('gf_profitablity_analysis_id__c IN :setProfAnalysisId AND participant_id__c = null').
            toSOQL())
        );
    }
}