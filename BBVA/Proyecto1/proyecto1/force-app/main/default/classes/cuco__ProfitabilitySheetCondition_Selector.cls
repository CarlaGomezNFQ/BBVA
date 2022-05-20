/**
* ____________________________________________________________________________
* Profitability Sheet Condition Selector
* Selector for the object profitability_sheet_condition__c
* ____________________________________________________________________________
* @author      Torcuato Tejada <torcuato.tejada.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-02-18
* @modified
* @systemLayer Selector
* ____________________________________________________________________________
* @changes
*
* ____________________________________________________________________________
*/
@SuppressWarnings('sf:DMLWithoutSharingEnabled')
global class ProfitabilitySheetCondition_Selector extends bbvacep.fflib_SObjectSelector {

    /**
    * @description newInstance
    */
    global static ProfitabilitySheetCondition_Selector newInstance() {
        return (ProfitabilitySheetCondition_Selector) CUCO_Application.SELECTOR.newInstance(profitability_sheet_condition__c.SObjectType);
    }

    /**
    * @description Default constructor. Reads the fields from the getSObjectFieldList() method
    */
    global ProfitabilitySheetCondition_Selector() {
        super(false);
    }

    /**
    * @description Constructor that allows a parameter to use FieldSets if True
    */
    global ProfitabilitySheetCondition_Selector(Boolean includeFieldSet) {
        super(includeFieldSet);
        this.setDefaultFieldSet(CUCO_Application.DEFAULTFIELDSET);
    }

    /**
    * @description Constructor that allows a parameter to use the selected fieldsets
    */
    global ProfitabilitySheetCondition_Selector(List <String> fieldSetList) {
        super(true);
        this.setFieldSetList(fieldSetList);
    }

    /**
    * @description Override Schema.SObjectType
    */
    public override Schema.SObjectType getSObjectType() {
        return profitability_sheet_condition__c.sObjectType;
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
            profitability_sheet_condition__c.Id,
            profitability_sheet_condition__c.gf_psc_condition_id__c,
            profitability_sheet_condition__c.gf_profitability_sheet_id__c,
            profitability_sheet_condition__c.gf_ps_cond_atrb_srce_type_name__c
        };
    }

    /**
    * @description Select by Profitability Sheet Condition Id
    * @param idSet : Ids to filter search
    */
    global List<profitability_sheet_condition__c> selectById(Set<Id> idSet) {
        return (List<profitability_sheet_condition__c>) selectSObjectsById(idSet);
    }

    /**
    * @description Select by Profitability Sheet Id with empty source
    * @param profSheetIds : Set of Ids to filter search
    */
    global List<profitability_sheet_condition__c> selectByProfitabilitySheetId(Set<Id> profSheetIds) {
        return (List<profitability_sheet_condition__c>) Database.query(String.escapeSingleQuotes(
            newQueryFactory().
            selectField('cuco__gf_psc_condition_id__r.Name').
            selectField('cuco__gf_psc_condition_id__r.cuco__gf_psc_family_id__r.Name').
            selectField('cuco__gf_psc_condition_id__r.cuco__gf_psc_family_id__r.cuco__gf_psc_family_id__c').
            selectField('cuco__gf_psc_condition_id__r.cuco__gf_psc_family_id__r.cuco__gf_psc_family_product_name__c').
            selectField('cuco__gf_psc_condition_id__r.cuco__gf_psc_family_id__r.cuco__gf_psc_fmly_visual_ord_number__c').
            setCondition('gf_profitability_sheet_id__c IN :profSheetIds AND gf_ps_cond_atrb_srce_type_name__c = null').
            setOrdering('cuco__gf_psc_condition_id__r.cuco__gf_psc_family_id__r.cuco__gf_psc_fmly_visual_ord_number__c', bbvacep.fflib_QueryFactory.SortOrder.ASCENDING, true).
            toSOQL())
        );
    }

    /**
    * @description Select All by Profitability Sheet Id
    * @param profSheetIds : Set of Ids to filter search
    */
    global List<profitability_sheet_condition__c> selectAllByProfitabilitySheetId(Set<Id> profSheetIds) {
        return (List<profitability_sheet_condition__c>) Database.query(String.escapeSingleQuotes(
            newQueryFactory().
            selectField('cuco__gf_psc_condition_id__r.Name').
            selectField('cuco__gf_psc_condition_id__r.cuco__gf_psc_family_id__c').
            selectField('cuco__gf_psc_condition_id__r.cuco__gf_psc_family_id__r.Name').
            selectField('cuco__gf_psc_condition_id__r.cuco__gf_psc_family_id__r.cuco__gf_psc_family_id__c').
            selectField('cuco__gf_psc_condition_id__r.cuco__gf_psc_family_id__r.cuco__gf_psc_family_product_name__c').
            selectField('cuco__gf_psc_condition_id__r.cuco__gf_psc_family_id__r.cuco__gf_psc_fmly_visual_ord_number__c').
            setCondition('gf_profitability_sheet_id__c IN :profSheetIds').
            setOrdering('cuco__gf_psc_condition_id__r.cuco__gf_psc_family_id__r.cuco__gf_psc_fmly_visual_ord_number__c', bbvacep.fflib_QueryFactory.SortOrder.ASCENDING, true).
            toSOQL())
        );
    }
}