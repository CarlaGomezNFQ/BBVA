/**
* ____________________________________________________________________________
* Profitability Analysis Selector
* Selector for the object profitability_analysis__c
* ____________________________________________________________________________
* @author      Torcuato Tejada <torcuato.tejada.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-02-04
* @modified
* @systemLayer Selector
* ____________________________________________________________________________
* @changes
*
* ____________________________________________________________________________
*/
@SuppressWarnings('sf:DMLWithoutSharingEnabled')
global class ProfitabilityAnalysis_Selector extends bbvacep.fflib_SObjectSelector {

    /**
    * @description newInstance
    */
    global static ProfitabilityAnalysis_Selector newInstance() {
        return (ProfitabilityAnalysis_Selector) CUCO_Application.SELECTOR.newInstance(profitability_analysis__c.SObjectType);
    }

    /**
    * @description Default constructor. Reads the fields from the getSObjectFieldList() method
    */
    global ProfitabilityAnalysis_Selector() {
        super(false);
    }

    /**
    * @description Constructor that allows a parameter to use FieldSets if True
    */
    global ProfitabilityAnalysis_Selector(Boolean includeFieldSet) {
        super(includeFieldSet);
        this.setDefaultFieldSet(CUCO_Application.DEFAULTFIELDSET);
    }

    /**
    * @description Constructor that allows a parameter to use the selected fieldsets
    */
    global ProfitabilityAnalysis_Selector(List <String> fieldSetList) {
        super(true);
        this.setFieldSetList(fieldSetList);
    }

    /**
    * @description Override Schema.SObjectType
    */
    public override Schema.SObjectType getSObjectType() {
        return profitability_analysis__c.sObjectType;
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
            profitability_analysis__c.Id,
            profitability_analysis__c.Name,
            profitability_analysis__c.gf_pa_management_type_name__c,
            profitability_analysis__c.gf_profitability_sheet_id__c,
            profitability_analysis__c.participant_id__c
        };
    }

    /**
    * @description Select by Profitability Analysis Id
    * @param idSet : Ids to filter search
    */
    global List<profitability_analysis__c> selectById(Set<ID> idSet) {
        return (List<profitability_analysis__c>) selectSObjectsById(idSet);
    }

    /**
    * @description Select by Profitability Analysis Name
    * @param names : Set of names to filter search
    */
    global List<profitability_analysis__c> selectByName(Set<String> names) {
        bbvacep.fflib_QueryFactory query = newQueryFactory();
        query.setCondition('Name IN :names');
        return (List<profitability_analysis__c>) Database.query( String.escapeSingleQuotes(query.toSOQL()) );
    }

    /**
    * @description Select Profitability Analysis related to a profitability sheet id or code when is on closed stage
    * @param idProfSheetSet : Ids of Profitability Sheet to filter search
    * @param setProfSheetCode : Strings of Profitability Sheet codes
    */
    global List<profitability_analysis__c> selectByProfSheetNoClosedPA(Set<Id> idProfSheetSet, Set<String> setProfSheetCode) {
        return (List<profitability_analysis__c>) Database.query(String.escapeSingleQuotes(
            newQueryFactory().
            setCondition('gf_pa_mgmt_clos_st_type_name__c = false AND (gf_profitability_sheet_id__c IN :idProfSheetSet OR gf_auto_formalization_req_id__c IN: setProfSheetCode)').
            setOrdering('CreatedDate', bbvacep.fflib_QueryFactory.SortOrder.DESCENDING, true).
            toSOQL())
        );
    }

    /**
    * @description Select by Profitability Analysis
    * @param names : Set of id to filter search
    */
    global List<profitability_analysis__c> selectGestion(Set<ID> paIdSet) {
        bbvacep.fflib_QueryFactory query = newQueryFactory();
        query.setCondition('(Id IN :paIdSet AND gf_pa_mgmt_clos_st_type_name__c = false)');
        return (List<profitability_analysis__c>) Database.query( String.escapeSingleQuotes(query.toSOQL()));
    }

    /**
    * @description Select by Profitability Analysis by Parent
    * @param names : Set of id to filter search
    */
    global List<profitability_analysis__c> selectOpenByParent(Set<String> psCodeSet) {
        bbvacep.fflib_QueryFactory query = newQueryFactory();
        query.setCondition('(gf_profitability_sheet_id__r.cuco__gf_profitability_sheet_id__c IN:psCodeSet OR gf_auto_formalization_req_id__c IN:psCodeSet) AND cuco__gf_pa_mgmt_clos_st_type_name__c = false');
        return (List<profitability_analysis__c>) Database.query( String.escapeSingleQuotes(query.toSOQL()) );
    }

    /**
    * @description Select Profitability Analysis filter by prof analysis id and manual request id
    * @param idProfSheetSet : Ids of Profitability Sheet to filter search
    * @param setProfSheetCode : Strings of Profitability Sheet codes
    */
    global List<profitability_analysis__c> selectByIdAndManualReqId(Set<Id> setProfAnalysisId, Set<String> setManualReqId) {
        return (List<profitability_analysis__c>) Database.query(String.escapeSingleQuotes(
            newQueryFactory().
            setCondition('Id IN :setProfAnalysisId AND gf_manl_formalization_req_id__c IN :setManualReqId').
            toSOQL())
        );
    }
}