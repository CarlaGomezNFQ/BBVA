/**
* ────────────────────────────────────────────────────────────────────
* External_Documents_Helper
* Helper class for External_Documents_Service apex class
* ────────────────────────────────────────────────────────────────────
* @author      Fernando Elizalde <fernando.elizalde.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-05-28
* @modified
* @systemLayer
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
public class External_Documents_Helper {

    /**
    * @description Private constructor to avoid sonar err
    */
    @TestVisible
    private External_Documents_Helper() {}

    /**
    * @description Returns all needed info to external documents form of prof analysis
    * @param profAnalysisId : Id of the context profitability analysis id record
    * @return Map<String, Object>, with needed info
    */
    public static List<ExternalDocument_Wrapper> getPAExtDocsData(Id profAnalysisId) {
        final List<ExternalDocument_Wrapper> lstExtDocWrapp = new List<ExternalDocument_Wrapper>();
        final ExternalDocumentExtensionIcon_Selector extDocIconSelector = new ExternalDocumentExtensionIcon_Selector();
        final List<external_document_extension_icon__mdt> lstExtDocIcon = extDocIconSelector.selectAll();
        final Map<String, String> mapExtension2Icon = new Map<String, String>();
        for (external_document_extension_icon__mdt extDocMtd : lstExtDocIcon) {
            mapExtension2Icon.put(extDocMtd.doc_extension_desc__c, extDocMtd.icon_id__c);
        }
        final PAExternalDocument_Selector selectorExtDocs = new PAExternalDocument_Selector(true);
        final List<profitability_analysis_external_document__c> paExtDocsList = selectorExtDocs.selectByProfAnalysis(new Set<Id>{profAnalysisId});
        for (profitability_analysis_external_document__c extDoc : paExtDocsList) {
            lstExtDocWrapp.add(fillExtDocWrapper(extDoc, mapExtension2Icon));
        }
        return lstExtDocWrapp;
    }

    /**
    * @description Fill ExternalDocument_Wrapper with record param info
    * @param extDoc: profitability_analysis_external_document__c to get info
    * @param mapExtension2Icon: Map which contains each icon related with each extension
    * @return ExternalDocument_Wrapper: ExternalDocument_Wrapper filled with param data
    */
    public static ExternalDocument_Wrapper fillExtDocWrapper(profitability_analysis_external_document__c extDoc, Map<String, String> mapExtension2Icon) {
        ExternalDocument_Wrapper wrapperExtDoc = new ExternalDocument_Wrapper();
        wrapperExtDoc.externalDocumentDate = extDoc.gf_document_update_date__c;
        wrapperExtDoc.externalDocumentExtension = extDoc.gf_document_format_type__c;
        wrapperExtDoc.externalDocumentId = extDoc.gf_document_id__c;
        wrapperExtDoc.externalDocumentName = extDoc.gf_document_name__c;
        wrapperExtDoc.externalOperationId = extDoc.gf_external_operation_id__c;
        wrapperExtDoc.externalDocumentIcon = mapExtension2Icon.get(extDoc.gf_document_format_type__c) == null ? 'doctype:attachment' : mapExtension2Icon.get(extDoc.gf_document_format_type__c);
        wrapperExtDoc.externalDocumentNameWithExtension = extDoc.gf_document_name__c + '.' + extDoc.gf_document_format_type__c;
        return wrapperExtDoc;
    }
}