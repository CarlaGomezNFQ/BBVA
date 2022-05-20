/**
* ────────────────────────────────────────────────────────────────────
* Picasso Response Dispatcher Sample
* Sample implementation of the multiple methods from PicasoResponseDispatcher_itf
* ────────────────────────────────────────────────────────────────────
* @author
* @modifiedBy
* @version     1.0
* @created     2021-02-09
* @modified
* @systemLayer Sample
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
global with sharing class PicassoResponseDispatcherSample implements PicasoResponseDispatcher_itf {

    /**
    * @description Process the Picasso response
    * @param response : Picasso response details
    * @return PicassoResponseError_Wrapper result of the Picasso response processing
    */
    global PicassoResponseError_Wrapper setPicassoResponse(PicassoResponse_Wrapper response) {

        PicassoResponseError_Wrapper result;

        Id recordsId = (Id)response.externalId;
        String recordObject = recordsId.getSObjectType().getDescribe().getName();

        switch on recordObject {
            when 'cuco__profitability_analysis__c' {
                result = ProfitabilityAnalysisRespSample.setPicassoProfAnalysisResponse(response);
            }
            when else {
                result = new PicassoResponseError_Wrapper();
                result.statusCode = 409;
                PicassoResponseError_Wrapper.ErrorDetail errorDetail = new PicassoResponseError_Wrapper.ErrorDetail();
                errorDetail.errorCode = Label.picasso_response_not_found_code;
                errorDetail.message = Label.picasso_response_not_found_sample;
                result.errorDetail = errorDetail;
            }
        }

        return result;
    }
}