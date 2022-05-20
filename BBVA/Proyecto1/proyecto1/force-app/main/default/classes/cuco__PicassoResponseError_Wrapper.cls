/**
* ────────────────────────────────────────────────────────────────────
* PicassoResponseError_Wrapper
* Wrapper class for with the Picasso response error
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
@SuppressWarnings('PMD.AvoidGlobalModifier')
global class PicassoResponseError_Wrapper {

    /**
    * @description error code
    */
    global Integer statusCode  {get; set;}

    /**
    * @description error code
    */
    global ErrorDetail errorDetail  {get; set;}

    /**
    * @description error details inner class
    */
    global class ErrorDetail {
        /**
        * @description error code
        */
        global String errorCode  {get; set;}
        /**
        * @description error message
        */
        global String message  {get; set;}
    }

}