/**
* ────────────────────────────────────────────────────────────────────
* Profitability Analysis Participant Selector
* Selector for the object profitability_analysis_participant__c
* ────────────────────────────────────────────────────────────────────
* @author      Diego Arias <diego.arias.fernandez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-02-11
* @modified
* @systemLayer Selector
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@SuppressWarnings('sf:DMLWithoutSharingEnabled')
global class PAParticipant_Selector extends bbvacep.fflib_SObjectSelector {

    global static PAParticipant_Selector newInstance() {
        return (PAParticipant_Selector) CUCO_Application.SELECTOR.newInstance(profitability_analysis_participant__c.SObjectType);
    }

    /**
    * Default constructor. Reads the fields from the getSObjectFieldList() method
    */
    global PAParticipant_Selector() {
        super(false);
    }

    /**
    * Constructor that allows a parameter to use FieldSets if True
    */
    global PAParticipant_Selector(Boolean includeFieldSetFields) {
        super(includeFieldSetFields);
        this.setDefaultFieldSet(CUCO_Application.DEFAULTFIELDSET);
    }

    /**
    * Constructor that allows a parameter to use the selected fieldsets
    */
    global PAParticipant_Selector(List <String> fieldSetList) {
        super(true);
        this.setFieldSetList(fieldSetList);
    }

    public override Schema.SObjectType getSObjectType() {
        return profitability_analysis_participant__c.sObjectType;
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
            profitability_analysis_participant__c.Id,
            profitability_analysis_participant__c.Name
        };
    }

    /**
    * @description Select by Profitability Analysis Participant Id
    * @param idSet : Ids to filter search
    */
    global List<profitability_analysis_participant__c> selectById(Set<ID> idSet) {
        return (List<profitability_analysis_participant__c>) selectSObjectsById(idSet);
    }

    /**
    * @description Select by Profitability Analysis Id
    * @param idSet : Ids to filter search
    */
    global List<profitability_analysis_participant__c> selectByProfAnalysis(Set<Id> profAnalysisSet) {
        return (List<profitability_analysis_participant__c>) Database.query( String.escapeSingleQuotes(
            newQueryFactory().
            setCondition('gf_profitablity_analysis_id__c IN :profAnalysisSet').
            toSOQL())
        );
  }

    /**
    * @description Select active profitability sheet with participant id on the param acc Id set
    * @param accIds : Set of account id to filter search
    */
    global List<profitability_analysis_participant__c> selectAccsWithActivePA(Set<Id> accIds) {
        return (List<profitability_analysis_participant__c>) Database.query(String.escapeSingleQuotes(
            newQueryFactory().
            setCondition('gf_profitablity_analysis_id__r.gf_pa_mgmt_clos_st_type_name__c = false AND participant_id__c IN :accIds').
            toSOQL())
        );
    }

    /**
    * @description Select active profitability sheet with participant id on the param acc Id set
    * @param accIds : Set of account id to filter search
    */
    global List<profitability_analysis_participant__c> selectByProfAnalysisAndAcc(Set<Id> profAnalysisSet, Set<Id> accSet) {
        return (List<profitability_analysis_participant__c>) Database.query(String.escapeSingleQuotes(
            newQueryFactory().
            setCondition('gf_profitablity_analysis_id__c IN :profAnalysisSet AND participant_id__c IN :accSet').
            toSOQL())
        );
    }

    /**
    * @description Select by Participant Id
    * @param idSet : Ids to filter search
    */
    global List<profitability_analysis_participant__c> selectByPrticipant(Set<Id> participantSet) {
        return (List<profitability_analysis_participant__c>) Database.query( String.escapeSingleQuotes(
            newQueryFactory().
            setCondition('participant_id__c IN :participantSet').
            toSOQL())
        );
  }

}