/**
* ────────────────────────────────────────────────────────────────────
* Picasso Response Dispatcher Interface
* Interface that will contains methods to process the a Picasso Response
* information
* ────────────────────────────────────────────────────────────────────
* @author      D
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
global interface PicasoResponseDispatcher_itf {

    /**
    * @description Process the Picasso response
    * @param response : Picasso response details
    * @return PicassoResponseError_Wrapper result of the Picasso response processing
    */
    PicassoResponseError_Wrapper setPicassoResponse(PicassoResponse_Wrapper response);

}