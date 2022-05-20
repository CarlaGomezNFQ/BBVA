/**
* ____________________________________________________________________________
* Profitability Analysis Flat Rates Selector
* Selector for the object profitability_analysis_flat_rates__c
* ____________________________________________________________________________
* @author      Miguel Cabrera <miguel.cabrera@bbvaitspain.com>
* @modifiedBy
* @version     1.0
* @created     2021-04-22
* @modified
* @systemLayer Selector
* ____________________________________________________________________________
* @changes
*
* ____________________________________________________________________________
*/
@SuppressWarnings('sf:DMLWithoutSharingEnabled')
global class ProfitabilityAnalysisFlatRates_Selector extends bbvacep.fflib_SObjectSelector {

    /**
    * @description newInstance
    */
    global static ProfitabilityAnalysisFlatRates_Selector newInstance() {
        return (ProfitabilityAnalysisFlatRates_Selector) CUCO_Application.SELECTOR.newInstance(profitability_analysis_flat_rates__c.SObjectType);
    }

    /**
    * @description Default constructor. Reads the fields from the getSObjectFieldList() method
    */
    global ProfitabilityAnalysisFlatRates_Selector() {
        super(false);
    }

    /**
    * @description Constructor that allows a parameter to use FieldSets if True
    */
    global ProfitabilityAnalysisFlatRates_Selector(Boolean includeFieldSet) {
        super(includeFieldSet);
        this.setDefaultFieldSet(CUCO_Application.DEFAULTFIELDSET);
    }

    /**
    * @description Constructor that allows a parameter to use the selected fieldsets
    */
    global ProfitabilityAnalysisFlatRates_Selector(List <String> fieldSetList) {
        super(true);
        this.setFieldSetList(fieldSetList);
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
            profitability_analysis_flat_rates__c.Id,
            profitability_analysis_flat_rates__c.Name
        };
    }

    /**
    * @description Override Schema.SObjectType
    */
    public override Schema.SObjectType getSObjectType() {
        return profitability_analysis_flat_rates__c.sObjectType;
    }

    /**
    * @description Select by Profitability Analysis Id
    * @param idSet : Ids to filter search
    */
    global List<profitability_analysis_flat_rates__c> selectById(Set<ID> idSet) {
        return (List<profitability_analysis_flat_rates__c>) selectSObjectsById(idSet);
    }

    /**
    * @description Select by Profitability Analysis Id
    * @param idSet : Ids to filter search
    */
    global List<profitability_analysis_flat_rates__c> selectByProfAnalysis(Set<Id> profAnalysisSet) {
        return (List<profitability_analysis_flat_rates__c>) Database.query( String.escapeSingleQuotes(
            newQueryFactory().
            setCondition('cuco__gf_profitablity_analysis_id__c IN :profAnalysisSet').
            toSOQL())
        );
    }

    /**
    * @description Select by Id
    * @param names : Set of Ids to filter search
    */
    global List<profitability_analysis_flat_rates__c> byIdWithFields(Set<Id> idSet) {
        return (List<profitability_analysis_flat_rates__c>) Database.query(String.escapeSingleQuotes(
            newQueryFactory().
            selectField('cuco__gf_profitablity_analysis_id__r.cuco__gf_profitability_sheet_id__c').
            setCondition('Id IN :idSet').
            toSOQL())
        );
    }

    /**
    * @description Select by profitability analysis Id
    * @param names : Set of Ids to filter search
    */
    global List<profitability_analysis_flat_rates__c> byPaIdWithFields(Set<Id> idSet) {
        return (List<profitability_analysis_flat_rates__c>) Database.query(String.escapeSingleQuotes(
            newQueryFactory().
            selectField('cuco__gf_profitablity_analysis_id__r.cuco__gf_profitability_sheet_id__c').
            setCondition('cuco__gf_profitablity_analysis_id__c IN :idSet').
            toSOQL())
        );
    }
}