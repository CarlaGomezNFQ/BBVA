/**
* ____________________________________________________________________________
* External Document Extension Icon Selector class
* Selector for the object external_document_extension_icon__mdt
* ____________________________________________________________________________
* @author      Fernando Elizalde <fernando.elizalde.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-06-08
* @modified
* @systemLayer Selector
* ____________________________________________________________________________
* @changes
*
* ____________________________________________________________________________
*/
@SuppressWarnings('sf:DMLWithoutSharingEnabled,PMD.AvoidGlobalModifier')
global class ExternalDocumentExtensionIcon_Selector extends bbvacep.fflib_SObjectSelector {

    /**
    * @description newInstance
    */
    global static ExternalDocumentExtensionIcon_Selector newInstance() {
        return (ExternalDocumentExtensionIcon_Selector) CUCO_Application.SELECTOR.newInstance(external_document_extension_icon__mdt.SObjectType);
    }

    /**
    * @description Default constructor. Reads the fields from the getSObjectFieldList() method
    */
    global ExternalDocumentExtensionIcon_Selector() {
        super(false);
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
            external_document_extension_icon__mdt.Id,
            external_document_extension_icon__mdt.DeveloperName,
            external_document_extension_icon__mdt.doc_extension_desc__c,
            external_document_extension_icon__mdt.icon_id__c
        };
    }

    /**
    * @description Override Schema.SObjectType
    */
    public override Schema.SObjectType getSObjectType() {
        return external_document_extension_icon__mdt.sObjectType;
    }

    /**
    * @description Select records from mtd object, with 100 limit records
    */
    global List<external_document_extension_icon__mdt> selectAll() {
        return (List<external_document_extension_icon__mdt>) Database.query( String.escapeSingleQuotes(
            newQueryFactory().
            setLimit(100).
            toSOQL())
        );
    }
}