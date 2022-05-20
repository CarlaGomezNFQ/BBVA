/**
* ────────────────────────────────────────────────────────────────────
* PicassoResponse_Wrapper
* Wrapper class for with the Picasso response structure
* ────────────────────────────────────────────────────────────────────
* @author
* @modifiedBy
* @version     1.0
* @created     2021-04-22
* @modified
* @systemLayer Domain
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@SuppressWarnings('PMD.AvoidGlobalModifier')
global class PicassoResponse_Wrapper {
    /**
    * @description Picasso operation id
    */
    global String operationId  {get; set;}
    /**
    * @description SF record id
    */
    global String externalId  {get; set;}
    /**
    * @description List of documents
    */
    global Action action {get; set;}
    /**
    * @description List of documents
    */
    global List<Document> documents {get; set;}
    /**
    * @description Document inner class
    */
    global class Document {
        /**
        * @description document id
        */
        global String id  {get; set;}
        /**
        * @description document name
        */
        global String name  {get; set;}
        /**
        * @description document extension
        */
        global String format  {get; set;}
    }
    /**
    * @description: Response action information
    */
    global class Action {
        /**
        * @description action id
        */
        global String id {get; set;}
        /**
        * @description action description
        */
        global String description {get; set;}
        /**
        * @description action source
        */
        global String source {get; set;}
    }
    /**
    * @description Response channel id
    */
    global String channelId  {get; set;}
}