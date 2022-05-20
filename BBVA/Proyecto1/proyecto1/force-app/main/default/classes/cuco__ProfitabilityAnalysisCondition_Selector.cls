/**
* ____________________________________________________________________________
* Profitability Analysis Condition Selector
* Selector for the object profitability_analysis_condition__c
* ____________________________________________________________________________
* @author      Torcuato Tejada <torcuato.tejada.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-02-10
* @modified
* @systemLayer Selector
* ____________________________________________________________________________
* @changes
*
* ____________________________________________________________________________
*/
@SuppressWarnings('sf:DMLWithoutSharingEnabled')
global class ProfitabilityAnalysisCondition_Selector extends bbvacep.fflib_SObjectSelector {

    /**
    * @description newInstance
    */
    global static ProfitabilityAnalysisCondition_Selector newInstance() {
        return (ProfitabilityAnalysisCondition_Selector) CUCO_Application.SELECTOR.newInstance(profitability_analysis_condition__c.SObjectType);
    }

    /**
    * @description Default constructor. Reads the fields from the getSObjectFieldList() method
    */
    global ProfitabilityAnalysisCondition_Selector() {
        super(false);
    }

    /**
    * @description Constructor that allows a parameter to use FieldSets if True
    */
    global ProfitabilityAnalysisCondition_Selector(Boolean includeFieldSet) {
        super(includeFieldSet);
        this.setDefaultFieldSet(CUCO_Application.DEFAULTFIELDSET);
    }

    /**
    * @description Constructor that allows a parameter to use the selected fieldsets
    */
    global ProfitabilityAnalysisCondition_Selector(List <String> fieldSetList) {
        super(true);
        this.setFieldSetList(fieldSetList);
    }

    /**
    * @description Override Schema.SObjectType
    */
    public override Schema.SObjectType getSObjectType() {
        return profitability_analysis_condition__c.sObjectType;
    }

    /**
    * @description Override default order by in all queries to the object.
    */
    public override String getOrderBy() {
        return 'cuco__gf_psc_condition_id__r.cuco__gf_psc_family_id__r.cuco__gf_psc_fmly_visual_ord_number__c ASC, cuco__gf_psc_condition_id__r.cuco__gf_psc_cond_visual_ord_number__c ASC';
    }

    /**
    * @description Returns a default list of fields if FieldSets functionality
    *              is not used (No Dependency Injection Pattern here!) Use this
    *              method to add base fields to all queries to the object.
    */
    public override List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            profitability_analysis_condition__c.Id,
            profitability_analysis_condition__c.gf_psc_condition_id__c,
            profitability_analysis_condition__c.gf_profitablity_analysis_id__c,
            profitability_analysis_condition__c.gf_pa_cond_atrb_source_type__c,
            profitability_analysis_condition__c.gf_pa_source_cust_package_id__c
        };
    }

    /**
    * @description Select by Profitability Analysis Condition Id
    * @param idSet : Ids to filter search
    */
    global List<profitability_analysis_condition__c> selectById(Set<Id> idSet) {
        return (List<profitability_analysis_condition__c>) selectSObjectsById(idSet);
    }

    /**
    * @description Select by Profitability Analysis Id with source= null
    * @param names : Set of Ids to filter search
    */
    global List<profitability_analysis_condition__c> selectSpecialConditionsByProfitabiliyAnalysisId(Set<Id> contextIds) {
        return (List<profitability_analysis_condition__c>) Database.query(String.escapeSingleQuotes(
            newQueryFactory().
            selectField('cuco__gf_psc_condition_id__r.Name').
            selectField('cuco__gf_psc_condition_id__r.cuco__gf_psc_family_id__r.Name').
            selectField('cuco__gf_psc_condition_id__r.cuco__gf_psc_family_id__r.cuco__gf_psc_family_id__c').
            selectField('cuco__gf_psc_condition_id__r.cuco__gf_psc_family_id__r.cuco__gf_psc_family_product_name__c').
            selectField('cuco__gf_psc_condition_id__r.cuco__gf_psc_family_id__r.cuco__gf_psc_fmly_visual_ord_number__c').
            setCondition('gf_profitablity_analysis_id__c IN :contextIds AND gf_pa_cond_atrb_source_type__c = null').
            setOrdering('cuco__gf_psc_condition_id__r.cuco__gf_psc_family_id__r.cuco__gf_psc_fmly_visual_ord_number__c', bbvacep.fflib_QueryFactory.SortOrder.ASCENDING, true).
            toSOQL())
        );
    }

    /**
    * @description Select by Profitability Analysis Id
    * @param names : Set of Ids to filter search
    */
    global List<profitability_analysis_condition__c> selectByProfitabiliyAnalysisId(Set<Id> contextIds) {
        return (List<profitability_analysis_condition__c>) Database.query(String.escapeSingleQuotes(
            newQueryFactory().
            selectField('cuco__gf_psc_condition_id__r.Name').
            selectField('cuco__gf_psc_condition_id__r.cuco__gf_psc_family_id__r.Name').
            selectField('cuco__gf_psc_condition_id__r.cuco__gf_psc_family_id__r.cuco__gf_psc_family_id__c').
            selectField('cuco__gf_psc_condition_id__r.cuco__gf_psc_family_id__r.cuco__gf_psc_family_product_name__c').
            selectField('cuco__gf_psc_condition_id__r.cuco__gf_psc_family_id__r.cuco__gf_psc_fmly_visual_ord_number__c').
            setCondition('gf_profitablity_analysis_id__c IN :contextIds').
            setOrdering('cuco__gf_psc_condition_id__r.cuco__gf_psc_family_id__r.cuco__gf_psc_fmly_visual_ord_number__c', bbvacep.fflib_QueryFactory.SortOrder.ASCENDING, true).
            toSOQL())
        );
    }

    /**
    * @description Select by Profitability Analysis Id
    * @param names : Set of Ids to filter search
    */
    global List<profitability_analysis_condition__c> selectFlatByProfitabiliyAnalysisId(Set<Id> contextIds) {
        return (List<profitability_analysis_condition__c>) Database.query(String.escapeSingleQuotes(
            newQueryFactory().
            selectField('cuco__gf_psc_condition_id__r.Name').
            selectField('cuco__gf_psc_condition_id__r.cuco__gf_psc_family_id__r.Name').
            selectField('cuco__gf_psc_condition_id__r.cuco__gf_psc_family_id__r.cuco__gf_psc_family_product_name__c').
            selectField('cuco__gf_psc_condition_id__r.cuco__gf_psc_family_id__r.cuco__gf_psc_fmly_visual_ord_number__c').
            setCondition('cuco__gf_psc_condition_id__r.cuco__gf_psc_cond_flat_rate_ind_type__c = true AND gf_profitablity_analysis_id__c IN :contextIds AND gf_pa_cond_atrb_source_type__c = null').
            setOrdering('cuco__gf_psc_condition_id__r.cuco__gf_psc_family_id__r.cuco__gf_psc_fmly_visual_ord_number__c', bbvacep.fflib_QueryFactory.SortOrder.ASCENDING, true).
            toSOQL())
        );
    }

    /**
    * @description Select by Profitability Analysis Conditon Ids, same as getbyId but sorted and with relationships
    * @param names : Set of Ids to filter search
    */
    global List<profitability_analysis_condition__c> selectByPAConditionIds(Set<Id> paConditionIds) {
        return (List<profitability_analysis_condition__c>) Database.query(String.escapeSingleQuotes(
            newQueryFactory().
            selectField('cuco__gf_psc_condition_id__r.Name').
            selectField('cuco__gf_psc_condition_id__r.cuco__gf_psc_family_id__r.Name').
            selectField('cuco__gf_psc_condition_id__r.cuco__gf_psc_family_id__r.cuco__gf_psc_family_id__c').
            selectField('cuco__gf_psc_condition_id__r.cuco__gf_psc_family_id__r.cuco__gf_psc_family_product_name__c').
            selectField('cuco__gf_psc_condition_id__r.cuco__gf_psc_family_id__r.cuco__gf_psc_fmly_visual_ord_number__c').
            setCondition('Id IN :paConditionIds').
            setOrdering('cuco__gf_psc_condition_id__r.cuco__gf_psc_family_id__r.cuco__gf_psc_fmly_visual_ord_number__c', bbvacep.fflib_QueryFactory.SortOrder.ASCENDING, true).
            toSOQL())
        );
    }

    /**
    * @description Select by Profitability Analysis Conditon Ids, same as getbyId but sorted and with relationships
    * @param names : Set of Ids to filter search
    */
    global List<profitability_analysis_condition__c> selectByFamilyId(Id profAnalysisId, Id familyId) {
        return (List<profitability_analysis_condition__c>) Database.query(String.escapeSingleQuotes(
            newQueryFactory().
            selectField('cuco__gf_psc_condition_id__r.Name').
            selectField('cuco__gf_psc_condition_id__r.cuco__gf_psc_family_id__r.Name').
            selectField('cuco__gf_psc_condition_id__r.cuco__gf_psc_family_id__r.cuco__gf_psc_family_id__c').
            selectField('cuco__gf_psc_condition_id__r.cuco__gf_psc_family_id__r.cuco__gf_psc_family_product_name__c').
            selectField('cuco__gf_psc_condition_id__r.cuco__gf_psc_family_id__r.cuco__gf_psc_fmly_visual_ord_number__c').
            setCondition('cuco__gf_profitablity_analysis_id__c = :profAnalysisId AND cuco__gf_psc_condition_id__r.cuco__gf_psc_family_id__c = :familyId').
            setOrdering('cuco__gf_psc_condition_id__r.cuco__gf_psc_family_id__r.cuco__gf_psc_fmly_visual_ord_number__c', bbvacep.fflib_QueryFactory.SortOrder.ASCENDING, true).
            toSOQL())
        );
    }

    /**
    * @description Select by catalog Conditon Ids
    * @param pscConditionIds : Set of ps catalog condition Ids to filter search
    */
    global List<profitability_analysis_condition__c> selectByPsCatalogConditionId(Id profAnalysisId, Set<Id> pscConditionIds) {
        return (List<profitability_analysis_condition__c>) Database.query(String.escapeSingleQuotes(
            newQueryFactory().
            selectField('cuco__gf_psc_condition_id__r.Name').
            selectField('cuco__gf_psc_condition_id__r.cuco__gf_psc_family_id__r.Name').
            selectField('cuco__gf_psc_condition_id__r.cuco__gf_psc_family_id__r.cuco__gf_psc_family_id__c').
            selectField('cuco__gf_psc_condition_id__r.cuco__gf_psc_family_id__r.cuco__gf_psc_family_product_name__c').
            selectField('cuco__gf_psc_condition_id__r.cuco__gf_psc_family_id__r.cuco__gf_psc_fmly_visual_ord_number__c').
            setCondition('cuco__gf_profitablity_analysis_id__c = :profAnalysisId  AND cuco__gf_psc_condition_id__c IN :pscConditionIds').
            setOrdering('cuco__gf_psc_condition_id__r.cuco__gf_psc_cond_visual_ord_number__c', bbvacep.fflib_QueryFactory.SortOrder.ASCENDING, true).
            toSOQL())
        );
    }

    /**
    * @description Select by catalog Conditon Ids and source
    * @param pscConditionIds : Set of ps catalog condition Ids to filter search
    */
    global List<profitability_analysis_condition__c> selectByPsCatalogConditionIdAndSource(Id profAnalysisId, Set<Id> pscConditionIds, Set<String> sourceSet) {
        return (List<profitability_analysis_condition__c>) Database.query(String.escapeSingleQuotes(
            newQueryFactory().
            selectField('cuco__gf_psc_condition_id__r.Name').
            selectField('cuco__gf_psc_condition_id__r.cuco__gf_psc_family_id__r.Name').
            selectField('cuco__gf_psc_condition_id__r.cuco__gf_psc_family_id__r.cuco__gf_psc_family_id__c').
            selectField('cuco__gf_psc_condition_id__r.cuco__gf_psc_family_id__r.cuco__gf_psc_family_product_name__c').
            selectField('cuco__gf_psc_condition_id__r.cuco__gf_psc_family_id__r.cuco__gf_psc_fmly_visual_ord_number__c').
            setCondition('cuco__gf_profitablity_analysis_id__c = :profAnalysisId  AND cuco__gf_psc_condition_id__c IN :pscConditionIds AND cuco__gf_pa_cond_atrb_source_type__c IN :sourceSet').
            setOrdering('cuco__gf_psc_condition_id__r.cuco__gf_psc_cond_visual_ord_number__c', bbvacep.fflib_QueryFactory.SortOrder.ASCENDING, true).
            toSOQL())
        );
    }

    /**
    * @description Select by source type included empty source records
    * @param pscConditionIds : Set of ps catalog condition Ids to filter search
    */
    global List<profitability_analysis_condition__c> selectBySourceWithEmptyValues(Id profAnalysisId, Set<String> sourceSet) {
        return (List<profitability_analysis_condition__c>) Database.query(String.escapeSingleQuotes(
            newQueryFactory().
            selectField('cuco__gf_psc_condition_id__r.Name').
            selectField('cuco__gf_psc_condition_id__r.cuco__gf_psc_family_id__r.Name').
            selectField('cuco__gf_psc_condition_id__r.cuco__gf_psc_family_id__r.cuco__gf_psc_family_id__c').
            selectField('cuco__gf_psc_condition_id__r.cuco__gf_psc_family_id__r.cuco__gf_psc_family_product_name__c').
            selectField('cuco__gf_psc_condition_id__r.cuco__gf_psc_family_id__r.cuco__gf_psc_fmly_visual_ord_number__c').
            setCondition('cuco__gf_profitablity_analysis_id__c = :profAnalysisId  AND (cuco__gf_pa_cond_atrb_source_type__c IN :sourceSet OR cuco__gf_pa_cond_atrb_source_type__c = null)').
            setOrdering('cuco__gf_psc_condition_id__r.cuco__gf_psc_cond_visual_ord_number__c', bbvacep.fflib_QueryFactory.SortOrder.ASCENDING, true).
            toSOQL())
        );
    }

    /**
    * @description Select by catalog Conditon Ids
    * @param pscConditionIds : Set of ps catalog condition Ids to filter search
    */
    global List<profitability_analysis_condition__c> selectByCanonicalNames(Id profAnalysisId, Set<String> attributeNames) {
        return (List<profitability_analysis_condition__c>) Database.query(String.escapeSingleQuotes(
            newQueryFactory().
            selectField('cuco__gf_psc_condition_id__r.Name').
            selectField('cuco__gf_psc_condition_id__r.cuco__gf_psc_family_id__r.Name').
            selectField('cuco__gf_psc_condition_id__r.cuco__gf_psc_family_id__r.cuco__gf_psc_family_id__c').
            selectField('cuco__gf_psc_condition_id__r.cuco__gf_psc_family_id__r.cuco__gf_psc_family_product_name__c').
            selectField('cuco__gf_psc_condition_id__r.cuco__gf_psc_family_id__r.cuco__gf_psc_fmly_visual_ord_number__c').
            setCondition('cuco__gf_profitablity_analysis_id__c = :profAnalysisId  AND cuco__gf_psc_condition_id__r.cuco__gf_psc_condition_id__c IN :attributeNames').
            setOrdering('cuco__gf_psc_condition_id__r.cuco__gf_psc_cond_visual_ord_number__c', bbvacep.fflib_QueryFactory.SortOrder.ASCENDING, true).
            toSOQL())
        );
    }

    /**
    * @description Select by Profitability Analysis Id and Source type
    * @param setProfAnalysisId : Set of Ids of profitability analysis to filter search
    * @param lstSourceTypes : List<String> with Source types to filter search
    */
    global List<profitability_analysis_condition__c> selectByProfitabilityAnalysisIdAndSourceType(Set<Id> setProfAnalysisId, List<String> lstSourceTypes) {
        return (List<profitability_analysis_condition__c>) Database.query(String.escapeSingleQuotes(
            newQueryFactory().
            setCondition('gf_profitablity_analysis_id__c IN :setProfAnalysisId AND gf_pa_cond_atrb_source_type__c IN :lstSourceTypes').
            toSOQL())
        );
    }

    /**
    * @description Select by Source Client package
    * @param lstSourceClientPkg : Set of String with source client packages to filter search
    */
    global List<profitability_analysis_condition__c> selectByProfitabilityAnalysisIdAndSourceClientPkg(Set<String> lstSourceClientPkg) {
        return (List<profitability_analysis_condition__c>) Database.query(String.escapeSingleQuotes(
            newQueryFactory().
            setCondition('gf_pa_source_cust_package_id__c IN :lstSourceClientPkg').
            toSOQL())
        );
    }

    /**
    * @description Method to get if conditions in param are created on prof analysis conditions related to prof analysis param
    * @param setProfAnalysisId : Set of Ids of profitability analysis to filter search
    * @param setConditions : Set of Strings with conditions to filter search
    */
    global List<profitability_analysis_condition__c> selectConditionsInProfAnalysis(Set<Id> setProfAnalysisId, Set<String> setConditions) {
        return (List<profitability_analysis_condition__c>) Database.query(String.escapeSingleQuotes(
            newQueryFactory().
            selectField('cuco__gf_psc_condition_id__r.Name').
            setCondition('cuco__gf_profitablity_analysis_id__c IN :setProfAnalysisId AND cuco__gf_psc_condition_id__r.cuco__gf_psc_condition_id__c IN :setConditions').
            setOrdering('cuco__gf_psc_condition_id__r.cuco__gf_psc_family_id__r.cuco__gf_psc_fmly_visual_ord_number__c', bbvacep.fflib_QueryFactory.SortOrder.ASCENDING, true).
            setOrdering('cuco__gf_psc_condition_id__r.cuco__gf_psc_cond_visual_ord_number__c', bbvacep.fflib_QueryFactory.SortOrder.ASCENDING, true).
            toSOQL())
        );
    }

    /**
    * @description Select by Profitability Analysis Id
    * @param names : Set of Ids to filter search
    */
    global List<profitability_analysis_condition__c> byProfitabiliyAnalysisId(Set<Id> profAnalysisId) {
        return (List<profitability_analysis_condition__c>) Database.query(String.escapeSingleQuotes(
            newQueryFactory().
            selectField('cuco__gf_psc_condition_id__r.Name').
            selectField('cuco__gf_psc_condition_id__r.cuco__gf_psc_family_id__r.Name').
            selectField('cuco__gf_psc_condition_id__r.cuco__gf_psc_family_id__r.cuco__gf_psc_family_id__c').
            selectField('cuco__gf_psc_condition_id__r.cuco__gf_psc_family_id__r.cuco__gf_psc_family_product_name__c').
            selectField('cuco__gf_psc_condition_id__r.cuco__gf_psc_family_id__r.cuco__gf_psc_fmly_visual_ord_number__c').
            setCondition('gf_profitablity_analysis_id__c IN :profAnalysisId').
            toSOQL())
        );
    }

    /**
    * @description Select by Profitability Analysis Id
    * @param names : Set of Ids to filter search
    */
    global List<profitability_analysis_condition__c> byProfAnalysisIdFlatComm(Set<Id> profAnalysisId, String source) {
        return (List<profitability_analysis_condition__c>) Database.query(String.escapeSingleQuotes(
            newQueryFactory().
            setCondition('cuco__gf_profitablity_analysis_id__c IN :profAnalysisId AND cuco__gf_pa_cond_atrb_source_type__c = :source').
            toSOQL())
        );
    }
}