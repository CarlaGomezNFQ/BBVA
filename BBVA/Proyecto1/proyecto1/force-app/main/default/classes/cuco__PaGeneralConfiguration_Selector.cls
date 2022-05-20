/**
* ────────────────────────────────────────────────────────────────────
* PA General Configuration Metadata Selector
* Selector for the custom object metadata pa_general_configuration__mdt
* ────────────────────────────────────────────────────────────────────
* @author      Diego Arias <diego.arias.fernandez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-02-10
* @modified
* @systemLayer Selector
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@SuppressWarnings('sf:DMLWithoutSharingEnabled')
global class PaGeneralConfiguration_Selector extends bbvacep.fflib_SObjectSelector {

    global static PaGeneralConfiguration_Selector newInstance() {
        return (PaGeneralConfiguration_Selector) CUCO_Application.SELECTOR.newInstance(pa_general_configuration__mdt.SObjectType);
    }

    /**
    * Default constructor. Reads the fields from the getSObjectFieldList() method
    */
    global PaGeneralConfiguration_Selector() {
        super(false);
    }

    public override Schema.SObjectType getSObjectType() {
        return pa_general_configuration__mdt.sObjectType;
    }

    /**
    * Override default order by in all queries to the object.
    */
    public override String getOrderBy() {
        return 'DeveloperName DESC';
    }

    /**
    * Returns a default list of fields if FieldSets functionality is not used (No Dependency Injection Pattern here!)
    * Use this method to add base fields to all queries to the object.
    */
    public override List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            pa_general_configuration__mdt.Id,
            pa_general_configuration__mdt.Label,
            pa_general_configuration__mdt.DeveloperName,
            pa_general_configuration__mdt.condition_itf_name__c,
            pa_general_configuration__mdt.participants_itf_name__c,
            pa_general_configuration__mdt.permissions_itf_name__c,
            pa_general_configuration__mdt.price_approval_type__c,
            pa_general_configuration__mdt.price_auth_max_validity_term__c,
            pa_general_configuration__mdt.price_classification_name__c,
            pa_general_configuration__mdt.price_first_level_name__c,
            pa_general_configuration__mdt.price_second_level_name__c,
            pa_general_configuration__mdt.prof_analysis_itf_name__c,
            pa_general_configuration__mdt.renewals_form_max_due_term__c,
            pa_general_configuration__mdt.renewals_max_due_term__c,
            pa_general_configuration__mdt.retrieve_delegated_values_type__c,
            pa_general_configuration__mdt.retrieve_ps_from_backend_type__c,
            pa_general_configuration__mdt.retrieve_standard_values_type__c,
            pa_general_configuration__mdt.segment_type__c,
            pa_general_configuration__mdt.dynamic_pricing__c,
            pa_general_configuration__mdt.price_approval_decision_id__c,
            pa_general_configuration__mdt.price_dismissal_decision_id__c,
            pa_general_configuration__mdt.price_init_form_decision_id__c,
            pa_general_configuration__mdt.price_restudy_decision_id__c,
            pa_general_configuration__mdt.available_actions_itf_name__c,
            pa_general_configuration__mdt.picasso_channel_id__c,
            pa_general_configuration__mdt.picasso_request_type__c,
            pa_general_configuration__mdt.picasso_dispatcher_itf_name__c,
            pa_general_configuration__mdt.picasso_notification_id__c,
            pa_general_configuration__mdt.picasso_formalization_id__c
        };
    }

    /**
    * @description Select one active mtd record
    */
    global List<pa_general_configuration__mdt> selectActiveRecord(){
        return (List<pa_general_configuration__mdt>) Database.query(String.escapeSingleQuotes(
          newQueryFactory().
          setCondition('active_type__c = true').
          setLimit(1).
          toSOQL()));
    }

    /**
    * @description Select general configuration mtd by developer Name
    * @param developerName : String with developer name to filter search
    */
    global List<pa_general_configuration__mdt> selectByDeveloperName(String developerName) {
        return (List<pa_general_configuration__mdt>) Database.query(String.escapeSingleQuotes(
          newQueryFactory().
          setCondition('DeveloperName =: developerName').
          setLimit(1).
          toSOQL()));
    }
}