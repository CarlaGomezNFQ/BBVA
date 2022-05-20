/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_CallMessagesArc_Gen_CallMessages
* @Author   amunguia.contractor@bbva.com
* @Date     Created: 18/03/2021
* @Group    ARCE
* -----------------------------------------------------------------------------------------------
* @Description Arc_Gen_CallMessages
* -----------------------------------------------------------------------------------------------
* @Changes
*
* |18-03-2021 amunguia.contractor@bbva.com
*             Class creation.
* -----------------------------------------------------------------------------------------------
*/
global inherited sharing class Arc_Gen_GlobalMessage {
    /**
    *-------------------------------------------------------------------------------
    * @description Wrapper used to describe the Message that the service will provide.
    *-------------------------------------------------------------------------------
    **/
    global class Message {
        /** @Description: String with errorCode */
        global String errorCode {get; set;}
        /** @Description: String with description */
        global String description {get; set;}
        /** @Description: String with detailedMessage */
        global String detailedMessage {get; set;}
        /**
        * ---------------------------------------------------------------------------------------------------
        * @Description - Method to add an error.
        * ---------------------------------------------------------------------------------------------------
        * @author amunguia.contractor@bbva.com | 19-05-2021
        * @param String error
        * @param String description
        * @param String detailedMessage
        **/
        global void addMessage(String error, String description, String detailedMessage) {
            this.errorCode = error;
            this.description = description;
            this.detailedMessage = detailedMessage;
        }
    }
}