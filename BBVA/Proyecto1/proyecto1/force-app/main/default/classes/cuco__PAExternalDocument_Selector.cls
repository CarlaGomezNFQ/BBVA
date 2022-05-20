/**
* ____________________________________________________________________________
* Profitability Analysis External Document Selector
* Selector for the object profitability_analysis_external_document__c
* ____________________________________________________________________________
* @author      Fernando Elizalde <fernando.elizalde.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-05-28
* @modified
* @systemLayer Selector
* ____________________________________________________________________________
* @changes
*
* ____________________________________________________________________________
*/
@SuppressWarnings('sf:DMLWithoutSharingEnabled,PMD.AvoidGlobalModifier')
global class PAExternalDocument_Selector extends bbvacep.fflib_SObjectSelector {

    /**
    * @description newInstance
    */
    global static PAExternalDocument_Selector newInstance() {
        return (PAExternalDocument_Selector) CUCO_Application.SELECTOR.newInstance(profitability_analysis_external_document__c.SObjectType);
    }

    /**
    * @description Default constructor. Reads the fields from the getSObjectFieldList() method
    */
    global PAExternalDocument_Selector() {
        super(false);
    }

    /**
    * @description Constructor that allows a parameter to use FieldSets if True
    */
    global PAExternalDocument_Selector(Boolean includeFieldSet) {
        super(includeFieldSet);
        this.setDefaultFieldSet(CUCO_Application.DEFAULTFIELDSET);
    }

    /**
    * @description Constructor that allows a parameter to use the selected fieldsets
    */
    global PAExternalDocument_Selector(List <String> fieldSetList) {
        super(true);
        this.setFieldSetList(fieldSetList);
    }

    /**
    * Override default order by in all queries to the object.
    */
    global override String getOrderBy() {
        return 'CreatedDate DESC';
    }

    /**
    * Returns a default list of fields if FieldSets functionality is not used (No Dependency Injection Pattern here!)
    * Use this method to add base fields to all queries to the object.
    */
    global override List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            profitability_analysis_external_document__c.Id,
            profitability_analysis_external_document__c.Name
        };
    }

    /**
    * @description Override Schema.SObjectType
    */
    global override Schema.SObjectType getSObjectType() {
        return profitability_analysis_external_document__c.sObjectType;
    }

    /**
    * @description Select by Profitability Analysis Id
    * @param idSet : Ids to filter search
    */
    global List<profitability_analysis_external_document__c> selectById(Set<ID> idSet) {
        return (List<profitability_analysis_external_document__c>) selectSObjectsById(idSet);
    }

    /**
    * @description Select by Profitability Analysis Id
    * @param idSet : Ids to filter search
    */
    global List<profitability_analysis_external_document__c> selectByProfAnalysis(Set<Id> profAnalysisSet) {
        return (List<profitability_analysis_external_document__c>) Database.query( String.escapeSingleQuotes(
            newQueryFactory().
            setCondition('cuco__gf_profitablity_analysis_id__c IN :profAnalysisSet').
            setOrdering('cuco__gf_document_update_date__c', bbvacep.fflib_QueryFactory.SortOrder.DESCENDING, true).
            toSOQL())
        );
    }

    /**
    * @description Upsert the Profitability Analysis External Documents records passed as parameters
    * @param lstCatPkg: List of Profitability Analysis Package Request records ready to upsert
    * @return Utils.DML_Wrapper, with the response of the DML operation
    */
    global static Utils.DML_Wrapper upsertPAED(List<cuco__profitability_analysis_external_document__c> lstPAED) {
        final List<String> errLstUpsertPAED = new List<String>();
        final List<Database.UpsertResult> urLstPAED = Database.upsert(lstPAED, false);
        // Iterate through each returned result
        for (Database.UpsertResult urPAED : urLstPAED) {
            if (!urPAED.isSuccess()) {
                // Operation failed, so get all errors
                for (Database.Error errUpsPAED : urPAED.getErrors()) {
                    errLstUpsertPAED.add(errUpsPAED.getMessage());
                    System.debug('Upsert cuco__profitability_analysis_external_document__c ERROR: ' + userInfo.getUserName() + ', ' + errUpsPAED.getStatusCode() + ': ' + errUpsPAED.getMessage());
                }
            }
        }
        return new Utils.DML_Wrapper(errLstUpsertPAED.isEmpty(), errLstUpsertPAED);
    }
}