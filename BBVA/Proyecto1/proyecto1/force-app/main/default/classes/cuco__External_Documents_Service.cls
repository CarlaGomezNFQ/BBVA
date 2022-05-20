/**
* ────────────────────────────────────────────────────────────────────
* External_Documents_Service
* Service class for External_Documents_Ctrl apex class
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
public class External_Documents_Service {

    /**
    * @description Private constructor to avoid sonar err
    */
    @TestVisible
    private External_Documents_Service() {}

    /**
    * @description Returns the external documents info to show
    * @param profAnalysisId : Id of the prof analysis context record
    * @return List<ExternalDocument_Wrapper>, wrapper with external documents info, if have
    */
    public static List<ExternalDocument_Wrapper> getExtDocsInfo(Id profAnalysisId) {
        return External_Documents_Helper.getPAExtDocsData(profAnalysisId);
    }

    /**
    * @description: Method to do picasso ws call
    * @param operationId : External operation id
    * @param docId : External document id
    * @return Map<String, Object>: with the operation response
    */
    public static Map<String, Object> getPicassoWSResponse(String operationId, String docId) {
        Map<String, Object> retMap = new Map<String, Object>();
        final RequestPicassoDocument_Helper rpdh = new RequestPicassoDocument_Helper(operationId, new List<String>{docId});
        final HttpResponse responsePicassoDoc = rpdh.callWs();
        switch on responsePicassoDoc.getStatusCode() {
            when 200 {
                retMap.put('isSuccess', true);
                final Map<String, Object> mapDocValues = (Map<String, Object>) JSON.deserializeUntyped(responsePicassoDoc.getBody());
                final List<Object> lstDocs = (List<Object>) mapDocValues.get('documentsInfo');
                final Map<String, Object> docMap = (Map<String, Object>) lstDocs.get(0);
                retMap.put('url', docMap.get('href'));
            }
            when else {
                String errorPicasso = null;
                Map<String,Object> errorMapPicassoDoc = (Map<String,Object>) JSON.deserializeUntyped(responsePicassoDoc.getBody());
                if (errorMapPicassoDoc.containsKey('error-message')) {
                    errorPicasso = (String) errorMapPicassoDoc.get('error-message');
                }
                if (errorPicasso == null) {
                    retMap.put('isSuccess', false);
                    retMap.put('errMessage', Label.ext_docs_error_generic);
                } else {
                    retMap.put('isSuccess', false);
                    retMap.put('errMessage', Label.ext_docs_error_detail + ' ' + errorPicasso);
                }
            }
        }
        return retMap;
    }
}