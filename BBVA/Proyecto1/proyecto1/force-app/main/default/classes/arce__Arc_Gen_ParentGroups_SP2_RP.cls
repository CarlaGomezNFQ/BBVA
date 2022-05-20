/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_ParentGroups_SP2_RP
* @Author   amunguia.contractor@bbva.com
* @Date     Created: 18/03/2021
* @Group    ARCE
* -----------------------------------------------------------------------------------------------
* @Description Arc_Gen_ParentGroups_SP2_RP
* -----------------------------------------------------------------------------------------------
* @Changes
*
* |18-03-2021 amunguia.contractor@bbva.com
*             Class creation.
* |10-06-2021 ivan.cons@bbva.com
*             Removed static variable and modified isParent Method
* -----------------------------------------------------------------------------------------------
*/
public with sharing class Arc_Gen_ParentGroups_SP2_RP {
    /**
    * @Description: response block
    */
    public Response response {get; set;}
    /**
    * @Description: message block
    */
    private arce.Arc_Gen_GlobalMessage.Message message;
    /**
    *-------------------------------------------------------------------------------
    * @description Wrapper used to describe the parameters to be provided to the service.
    *-------------------------------------------------------------------------------
    **/
    public class RequestParentGroup {
        /**
        * @Description: Unique participant identifier.
        */
        String participantId { get; set; }
        /**
        * @Description: Unique identification of the economic block
        */
        String economicGroupId { get; set; }
        /**
        * @description constructor
        * @author amunguia.contractor@bbva.com | 03-18-2021
        * @param String participant
        * @param String economicGroup
        **/
        public RequestParentGroup (String participant, String economicGroup) {
            this.participantId = participant;
            this.economicGroupId = economicGroup;
        }
    }
    /**
    *-------------------------------------------------------------------------------
    * @description Wrapper used to describe the response that the service will provide.
    *-------------------------------------------------------------------------------
    **/
    public class Response {
        /**
        * @Description: data list
        */
        public List<DataWrapper> data {get; set;}
    }
    /**
    *-------------------------------------------------------------------------------
    * @description Wrapper used to describe the Data that the service will provide.
    *-------------------------------------------------------------------------------
    **/
    public class DataWrapper {
        /**
        * @Description: Unique identification of GlobalId
        */
        public String id {get; set;}
        /**
        * @Description: Unique identification of LocalId
        */
        public String localId {get; set;}
        /**
        * @Description:participant block
        */
        public ParticipantType participantType {get; set;}
        /**
        * @Description: relation block
        */
        public Relation relation {get; set;}
    }
    /**
    *-------------------------------------------------------------------------------
    * @description Wrapper used to describe the ParticipantType that the service will provide.
    *-------------------------------------------------------------------------------
    **/
    public class ParticipantType {
        /**
        * @Description: Unique identification of participant
        */
        public String id {get; set;}
    }
    /**
    *-------------------------------------------------------------------------------
    * @description Wrapper used to describe the Relation that the service will provide.
    *-------------------------------------------------------------------------------
    **/
    public class Relation {
        /**
        * @Description: Integer with level
        */
        public Integer level {get; set;}
    }
    /**
    * @description getGroups
    * @author amunguia.contractor@bbva.com | 03-18-2021
    * @return Map<String, List<String>>
    **/
    public Map<String,List<String>> calculateChildrens() {
        Map<String,List<String>> groups = new Map<String,List<String>>();
        for(DataWrapper aux :response.data) {
            if(groups.containsKey(aux.id)) {
                groups.get(aux.id).add(aux.localId);
            } else {
                groups.put(aux.id, new List<String>{aux.localId});
            }
        }
        return groups;
    }
    /**
    * @description parent is calculated.
    * @author amunguia.contractor@bbva.com | 03-18-2021
    * @param String parentId
    * @return Boolean isParent
    **/
    public Boolean isParent(String parentId) {
        Set<String> localIds = new Set<String>();
        for(DataWrapper aux :response.data) {
            localIds.add(aux.localId);
        }
        return localIds.contains(parentId);
    }
    /**
    * @description add message
    * @author amunguia.contractor@bbva.com | 03-19-2021
    * @param String error
    * @param String description
    * @param String detailedMessage
    **/
    public void addMessage(String error, String description, String detailedMessage) {
        message = new arce.Arc_Gen_GlobalMessage.Message();
        message.errorCode = error;
        message.description = description;
        message.detailedMessage = detailedMessage;
    }
    /**
    * @description text compare
    * @author amunguia.contractor@bbva.com | 03-19-2021
    * @param String detail
    * @return Boolean
    **/
    public Boolean isSuccessfull (String detail) {
        return message != null && message.description == detail;
    }
    /**
    * @description message Error
    * @author amunguia.contractor@bbva.com | 03-19-2021
    * @return String
    **/
    public String messageError () {
        String msg = '';
        if(message != null) {
            msg = message.errorCode + ' - ' + message.description;
        }
        return msg;
    }
}