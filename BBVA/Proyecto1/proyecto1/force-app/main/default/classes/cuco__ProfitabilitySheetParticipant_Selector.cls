/**
* ────────────────────────────────────────────────────────────────────
* Profitability Sheet Participant Selector
* Selector for the object profitability_sheet_participant__c
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
global class ProfitabilitySheetParticipant_Selector extends bbvacep.fflib_SObjectSelector {

    global static ProfitabilitySheetParticipant_Selector newInstance() {
        return (ProfitabilitySheetParticipant_Selector) CUCO_Application.SELECTOR.newInstance(profitability_sheet_participant__c.SObjectType);
    }

    /**
    * Default constructor. Reads the fields from the getSObjectFieldList() method
    */
    global ProfitabilitySheetParticipant_Selector() {
        super(false);
    }

    /**
    * Constructor that allows a parameter to use FieldSets if True
    */
    global ProfitabilitySheetParticipant_Selector(Boolean includeFieldSetFields) {
        super(includeFieldSetFields);
        this.setDefaultFieldSet(CUCO_Application.DEFAULTFIELDSET);
    }

    /**
    * Constructor that allows a parameter to use the selected fieldsets
    */
    global ProfitabilitySheetParticipant_Selector(List <String> fieldSetList) {
        super(true);
        this.setFieldSetList(fieldSetList);
    }

    public override Schema.SObjectType getSObjectType() {
        return profitability_sheet_participant__c.sObjectType;
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
            profitability_sheet_participant__c.Id,
            profitability_sheet_participant__c.Name
        };
    }

    /**
    * @description Select by Profitability Sheet Participant Id
    * @param idSet : Ids to filter search
    */
    global List<profitability_sheet_participant__c> selectById(Set<ID> idSet) {
        return (List<profitability_sheet_participant__c>) selectSObjectsById(idSet);
    }

    /**
    * @description Select by Profitability Sheet Id
    * @param idSet : Ids to filter search
    */
    global List<profitability_sheet_participant__c> selectByProfSheet(Set<Id> profSheetSet) {
        bbvacep.fflib_QueryFactory query = newQueryFactory();
        query.setCondition('gf_profitability_sheet_id__c IN :profSheetSet');
        return (List<profitability_sheet_participant__c>) Database.query( String.escapeSingleQuotes(query.toSOQL()) );
    }

    /**
    * @description Select by Profitability Sheet Id
    * @param idSet : Ids to filter search
    */
    global List<profitability_sheet_participant__c> selectByParticipantid(Set<Id> praticipantids) {
        bbvacep.fflib_QueryFactory query = newQueryFactory();
        query.setCondition('participant_id__c IN: praticipantids');
        return (List<profitability_sheet_participant__c>) Database.query( String.escapeSingleQuotes(query.toSOQL()) );
    }

    /**
    * @description Select active profitability sheet with participant id on the param acc Id set, filter by status
    * @param accIds : Set of account id to filter search
    * @param lstStatus : List of status to filter search
    */
    global List<profitability_sheet_participant__c> selectAccsByStatusPS(Set<Id> accIds, List<String> lstStatus) {
        bbvacep.fflib_QueryFactory query = newQueryFactory();
        query.setCondition('participant_id__c IN :accIds AND cuco__gf_profitability_sheet_id__r.cuco__gf_prftbly_sheet_stt_desc__c IN :lstStatus');
        return (List<profitability_sheet_participant__c>) Database.query( String.escapeSingleQuotes(query.toSOQL()) );
    }

    /**
    * @description Select active profitability sheet with participant id on the param acc Id set, filter by status and profsheetcode
    * @param accIds : Set of account id to filter search
    * @param lstStatus : List of status to filter search
    * @param profSheetCode : String with the gf_profitability_sheet_id__c of the related prof sheet
    */
    global List<profitability_sheet_participant__c> selectAccsByStatusAndPSCode(Set<Id> accIds, List<String> lstStatus, List<String> lstPSCode) {
        bbvacep.fflib_QueryFactory query = newQueryFactory();
        query.setCondition('participant_id__c IN :accIds AND cuco__gf_profitability_sheet_id__r.cuco__gf_prftbly_sheet_stt_desc__c IN :lstStatus AND cuco__gf_profitability_sheet_id__r.cuco__gf_profitability_sheet_id__c NOT IN :lstPSCode');
        return (List<profitability_sheet_participant__c>) Database.query( String.escapeSingleQuotes(query.toSOQL()) );
    }
}