/**
*
* ────────────────────────────────────────────────────────────────────
* Picasso Response
* Rest class to receive a Picasso response
* information
* ────────────────────────────────────────────────────────────────────
* @author
* @modifiedBy
* @version     1.0
* @created
* @modified
* @systemLayer Domain
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@RestResource(urlMapping='/PicassoResponse/*')
global class PicassoResponse {
    /**
    * @description Process the Picasso response
    */
    @HttpPost
    global static void setPicassoResponse() {
        PicassoResponse_Wrapper inputResponse = (PicassoResponse_Wrapper)JSON.deserialize(RestContext.request.requestBody.toString(), PicassoResponse_Wrapper.class);
        //Obtain the local implementation of the interface
        pa_general_configuration__mdt configMtd = Utils.getGeneralConfiguration();
        Type picassoDispatcherClass = Type.forName(configMtd.picasso_dispatcher_itf_name__c);
        PicasoResponseDispatcher_itf picassoDispatcherItf = (PicasoResponseDispatcher_itf) picassoDispatcherClass.newInstance();
        //Process the response
        PicassoResponseError_Wrapper result = picassoDispatcherItf.setPicassoResponse(inputResponse);
        //Return the process result
        RestContext.response.statusCode = result.statusCode;
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(result.errorDetail));
    }
}