/**
* ____________________________________________________________________________
* Profitability Analysis Flat Rates Account Selector
* Selector for the object profitability_analysis_flatrates_account__c
* ____________________________________________________________________________
* @author      Miguel Cabrera <miguel.cabrera@bbvaitspain.com>
* @modifiedBy
* @version     1.0
* @created     2021-04-23
* @modified
* @systemLayer Selector
* ____________________________________________________________________________
* @changes
*
* ____________________________________________________________________________
*/
@SuppressWarnings('sf:DMLWithoutSharingEnabled')
global class ProfitabilityAnalysFlatRateAcc_Selector extends bbvacep.fflib_SObjectSelector {

    /**
    * @description newInstance
    */
    global static ProfitabilityAnalysFlatRateAcc_Selector newInstance() {
        return (ProfitabilityAnalysFlatRateAcc_Selector) CUCO_Application.SELECTOR.newInstance(profitability_analysis_flatrates_account__c.SObjectType);
    }

    /**
    * @description Default constructor. Reads the fields from the getSObjectFieldList() method
    */
    global ProfitabilityAnalysFlatRateAcc_Selector() {
        super(false);
    }

    /**
    * @description Constructor that allows a parameter to use FieldSets if True
    */
    global ProfitabilityAnalysFlatRateAcc_Selector(Boolean includeFieldSet) {
        super(includeFieldSet);
        this.setDefaultFieldSet(CUCO_Application.DEFAULTFIELDSET);
    }

    /**
    * @description Constructor that allows a parameter to use the selected fieldsets
    */
    global ProfitabilityAnalysFlatRateAcc_Selector(List <String> fieldSetList) {
        super(true);
        this.setFieldSetList(fieldSetList);
    }

    /**
    * @description Override Schema.SObjectType
    */
    public override Schema.SObjectType getSObjectType() {
        return profitability_analysis_flatrates_account__c.sObjectType;
    }

    /**
    * @description Override default order by in all queries to the object.
    */
    public override String getOrderBy() {
        return 'Name ASC';
    }

    /**
    * @description Select by Profitability Analysis Condition Id
    * @param idSet : Ids to filter search
    */
    global List<profitability_analysis_flatrates_account__c> selectById(Set<Id> idSet) {
        return (List<profitability_analysis_flatrates_account__c>) selectSObjectsById(idSet);
    }

    /**
    * Returns a default list of fields if FieldSets functionality is not used (No Dependency Injection Pattern here!)
    * Use this method to add base fields to all queries to the object.
    */
    public override List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            profitability_analysis_flatrates_account__c.Id,
            profitability_analysis_flatrates_account__c.Name
        };
    }

    /**
    * @description Select by Profitability Analysis Flat Rates Id and Source type
    * @param profAnalFlatRates : Set of Ids of pProfitability Analysis Flat Rate to filter search
    */
    global List<profitability_analysis_flatrates_account__c> selectByProfAnalFlatRates(Set<Id> profAnalFlatRates) {
        return (List<profitability_analysis_flatrates_account__c>) Database.query(String.escapeSingleQuotes(
            newQueryFactory().
            selectField('cuco__gf_pa_flat_rate_account_id__r.cuco__gf_psc_flat_rate_ac_svc_id__c').
            selectField('cuco__gf_pa_flat_rate_account_id__r.cuco__gf_psc_flat_rate_ac_id__c').
            selectField('cuco__gf_pa_flat_rate_account_id__r.cuco__gf_psc_flat_rate_ac_desc__c').
            selectField('cuco__gf_pa_flat_rate_account_id__r.Name').
            setCondition('gf_pa_flat_rate_id__c IN :profAnalFlatRates').
            toSOQL())
        );
    }
}