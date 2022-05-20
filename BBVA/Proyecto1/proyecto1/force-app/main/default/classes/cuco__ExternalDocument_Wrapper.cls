/**
* ────────────────────────────────────────────────────────────────────
* ExternalDocument Wrapper
* Contains the ExternalDocument wrapper
* ────────────────────────────────────────────────────────────────────
* @author     Fernando Elizalde <fernando.elizalde.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-05-28
* @modified
* @systemLayer Domain
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@SuppressWarnings('PMD.AvoidGlobalModifier')
global class ExternalDocument_Wrapper {
    /**
    * @Description: Date with reception date
    */
    @AuraEnabled
    global Date externalDocumentDate { get; set; }

    /**
    * @Description: String with document extension
    */
    @AuraEnabled
    global String externalDocumentExtension { get; set; }

    /**
    * @Description: String with document id
    */
    @AuraEnabled
    global String externalDocumentId { get; set; }

    /**
    * @Description: String with document name
    */
    @AuraEnabled
    global String externalDocumentName { get; set; }

    /**
    * @Description: String with operation id
    */
    @AuraEnabled
    global String externalOperationId { get; set; }

    /**
    * @Description: String with icon doctype
    */
    @AuraEnabled
    global String externalDocumentIcon { get; set; }

    /**
    * @Description: String with document name and extension
    */
    @AuraEnabled
    global String externalDocumentNameWithExtension { get; set; }
}