/**
* ────────────────────────────────────────────────────────────────────
* RequestPicassoDocument_Helper
* Helper class for RequestPicassoDocument_Helper
* ────────────────────────────────────────────────────────────────────
* @author      Fernando Elizalde <fernando.elizalde.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-05-25
* @modified
* @systemLayer Business Logic
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
public class RequestPicassoDocument_Helper {

    /**
    * @description : Picasso WS configuration
    */
    private final static String PICASSO_WS = 'requestPicassoDocument';
    /**
    * @description : ticket Id
    */
    final String operationId;
    /**
    * @description : String with documentsList value
    */
    final String documentsList;
    /**
    * @Description : context user code
    */
    final String userCode;

    /**
    * @description : Default public constructor to RequestPicassoDocument_Helper
    * @param operationId : current record Id
    * @param documentsList :  List of documents Ids
    */
    public RequestPicassoDocument_Helper(String operationId, List<String> inputDocList) {
        final pa_general_configuration__mdt genConfig = Utils.getGeneralConfiguration();
        this.userCode = ProfitabilityAnalysis_Helper.getUserCode(genConfig,(Id) UserInfo.getUserId());
        this.operationId = operationId;
        final List<Document> outputDocList = new List<Document>();
        for (String docIterator : inputDocList) {
            final Document outputDoc = new Document();
            outputDoc.documentId = docIterator;
            outputDocList.add(outputDoc);
        }
        this.documentsList = JSON.serialize(outputDocList);
    }

    /**
    * @description : Method to serialize values to call webservice
    */
    public String generateRequest() {
        return JSON.serialize(this, true);
    }

    /**
    * @description : Method to invocate webdservice
    */
    public HttpResponse callWs() {
        HttpResponse response;
        final iaso__GBL_integration_service__mdt servicePicasso = iaso__GBL_integration_service__mdt.getInstance(PICASSO_WS);
        if (servicePicasso.iaso__Retrieve_Mock_LTA__c) {
            response = Utils.getResponseMock(PICASSO_WS, 200);
        } else {
            response = Utils.callWServices(PICASSO_WS, generateRequest());
        }
        return response;
    }

    /**
    * @description : Auxiliar class
    */
    private class Document {

        /**
        * @description : document Id
        */
        final String documentId;
    }
}