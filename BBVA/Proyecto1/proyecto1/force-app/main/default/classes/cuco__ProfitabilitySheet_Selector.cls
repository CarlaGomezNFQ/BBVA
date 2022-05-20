/**
* ────────────────────────────────────────────────────────────────────
* Profitability Sheet Selector
* Selector for the object profitability_sheet__c
* ────────────────────────────────────────────────────────────────────
* @author      Diego Arias <diego.arias.fernandez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-02-05
* @modified
* @systemLayer Selector
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@SuppressWarnings('sf:DMLWithoutSharingEnabled, sf:UnusedLocalVariable')
global class ProfitabilitySheet_Selector extends bbvacep.fflib_SObjectSelector {

    global static ProfitabilitySheet_Selector newInstance() {
        return (ProfitabilitySheet_Selector) CUCO_Application.SELECTOR.newInstance(profitability_sheet__c.SObjectType);
    }

    /**
    * Default constructor. Reads the fields from the getSObjectFieldList() method
    */
    global ProfitabilitySheet_Selector() {
        super(false);
    }

    /**
    * Constructor that allows a parameter to use FieldSets if True
    */
    global ProfitabilitySheet_Selector(Boolean includeFieldSetFields) {
        super(includeFieldSetFields);
        this.setDefaultFieldSet(CUCO_Application.DEFAULTFIELDSET);
    }

    /**
    * Constructor that allows a parameter to use the selected fieldsets
    */
    global ProfitabilitySheet_Selector(List <String> fieldSetList) {
        super(true);
        this.setFieldSetList(fieldSetList);
    }

    public override Schema.SObjectType getSObjectType() {
        return profitability_sheet__c.sObjectType;
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
            profitability_sheet__c.Id,
            profitability_sheet__c.gf_profitability_sheet_id__c,
            profitability_sheet__c.participant_id__c
        };
    }

    /**
    * @description Select by Profitability Sheet Id
    * @param idSet : Ids to filter search
    */
    global List<profitability_sheet__c> selectById(Set<ID> idSet) {
        return (List<profitability_sheet__c>) selectSObjectsById(idSet);
    }

    /**
    * @description Select by Profitability Sheet Name
    * @param names : Set of names to filter search
    */
    global List<profitability_sheet__c> selectByName(Set<String> names) {
        bbvacep.fflib_QueryFactory query = newQueryFactory();
        query.setCondition('Name IN :names');
        return (List<profitability_sheet__c>) Database.query( String.escapeSingleQuotes(query.toSOQL()) );
    }

    /**
    * @description Select by Profitability Sheet Participan
    * @param names : Set of id to filter search
    */
    global List<profitability_sheet__c> selectParticipantId(Set<ID> idSet) {
        bbvacep.fflib_QueryFactory query = newQueryFactory();
        query.setCondition('participant_id__c IN :idSet');
        return (List<profitability_sheet__c>) Database.query( String.escapeSingleQuotes(query.toSOQL()) );
    }

    /**
    * @description Select by Profitability Sheet Participant
    * @param names : Set of id to filter search
    */
    global List<profitability_sheet__c> selectValid(Set<ID> idSet) {
        final List<String> validStatus = new List<String>{'Valid'};
        bbvacep.fflib_QueryFactory query = newQueryFactory();
        query.setCondition('gf_prftbly_sheet_stt_desc__c IN: validStatus AND Id IN :idSet');
        return (List<profitability_sheet__c>) Database.query( String.escapeSingleQuotes(query.toSOQL()));
    }

    /**
    * @description Select by Profitability Sheet Participan
    * @param names : Set of id to filter search
    */
    global List<profitability_sheet__c> selectPSToProfList(Set<ID> idSet, Integer maxdays, Set<String> codeSet) {
        final List<String> validStatus = new List<String>{'Valid'};
        final List<String> expiredStatus = new List<String>{'Expired'};
        bbvacep.fflib_QueryFactory query = newQueryFactory();
        query.setCondition('((((gf_prftbly_sheet_stt_desc__c IN: validStatus) OR (gf_prftbly_sheet_stt_desc__c IN: expiredStatus AND gf_prftbly_sheet_end_date__c = LAST_N_DAYS:'+ maxdays +')) AND Id IN: idSet) OR (gf_profitability_sheet_id__c IN :codeSet))');
        query.setOrdering('cuco__gf_prftbly_sheet_end_date__c', bbvacep.fflib_QueryFactory.SortOrder.ASCENDING, true);
        return (List<profitability_sheet__c>) Database.query( String.escapeSingleQuotes(query.toSOQL()));
    }

}