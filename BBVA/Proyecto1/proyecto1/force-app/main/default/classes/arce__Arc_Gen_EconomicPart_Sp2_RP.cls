/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_EconomicPart_Sp2_RP
* @Author   amunguia.contractor@bbva.com
* @Date     Created: 18/03/2021
* @Group    ARCE
* -----------------------------------------------------------------------------------------------
* @Description Arc_Gen_EconomicPart_Sp2_RP
* -----------------------------------------------------------------------------------------------
* @Changes
*
* |18-03-2021 amunguia.contractor@bbva.com
*             Class creation.
* -----------------------------------------------------------------------------------------------
*/
@SuppressWarnings('PMD.ExcessivePublicCount, sf:TooManyMethods, sf:TooManyFields')
public with sharing class Arc_Gen_EconomicPart_Sp2_RP {
    /**
    * @Description: response block
    */
    public Response response {get; set;}
    /**
    * @Description: message block
    */
    private arce.Arc_Gen_GlobalMessage.Message message;
    /**
    * @Description: private matrix list
    */
    private static List<String> matrix = new List<String>();
    /**
    *-------------------------------------------------------------------------------
    * @description Wrapper used to describe the response that the service will provide.
    *-------------------------------------------------------------------------------
    **/
    public class Response {
        /**
        * @Description: data block
        */
        public DataWrapper data {get; set;}
    }
    /**
    *-------------------------------------------------------------------------------
    * @description Wrapper used to describe the Data that the service will provide.
    *-------------------------------------------------------------------------------
    **/
    public class DataWrapper {
        /**
        * @Description: business block
        */
        public Business business {get; set;}
        /**
        * @Description: group list
        */
        public List<GroupWrapper> groups {get; set;}
    }
    /**
    *-------------------------------------------------------------------------------
    * @description Wrapper used to describe the Business that the service will provide.
    *-------------------------------------------------------------------------------
    **/
    public class Business {
        /**
        * @Description: String with Id
        */
        public String id {get; set;}
        /**
        * @Description: String with legalName
        */
        public String legalName {get; set;}
        /**
        * @Description: BusinessDocuments List
        */
        public List<BusinessDocument> businessDocuments {get; set;}
    }
    /**
    *-------------------------------------------------------------------------------
    * @description Wrapper used to describe the BusinessDocument that the service will provide.
    *-------------------------------------------------------------------------------
    **/
    public class BusinessDocument {
        /**
        * @Description: String with documentNumber
        */
        public string documentNumber {get; set;}
        /**
        * @Description: businessDoc block
        */
        public BusinessDocumentType businessDocumentType {get; set;}

    }
    /**
    *-------------------------------------------------------------------------------
    * @description Wrapper used to describe the BusinessDocumentType that the service will provide.
    *-------------------------------------------------------------------------------
    **/
    public class BusinessDocumentType {
        /**
        * @Description: String with id
        */
        public String id {get; set;}
        /**
        * @Description: String with name
        */
        public String name {get; set;}
    }
    /**
    *-------------------------------------------------------------------------------
    * @description Wrapper used to describe the Group that the service will provide.
    *-------------------------------------------------------------------------------
    **/
    public class GroupWrapper {
        /**
        * @Description: String with id
        */
        public String id {get; set;}
        /**
        * @Description: String with name
        */
        public String name {get; set;}
        /**
        * @Description: economicGroup block
        */
        public EconomicGroupType economicGroupType {get; set;}
        /**
        * @Description: relation block
        */
        public Relation relation {get; set;}
        /**
        * @Description: Boolean with isHolding
        */
        public Boolean isHolding {get; set;}
    }
    /**
    *-------------------------------------------------------------------------------
    * @description Wrapper used to describe the EconomicGroupType that the service will provide.
    *-------------------------------------------------------------------------------
    **/
    public class EconomicGroupType {
        /**
        * @Description: String with id
        */
        public String id {get; set;}
        /**
        * @Description: String with name
        */
        public String name {get; set;}
    }
    /**
    *-------------------------------------------------------------------------------
    * @description Wrapper used to describe the Relation that the service will provide.
    *-------------------------------------------------------------------------------
    **/
    public class Relation {
        /**
        * @Description: relationType block
        */
        public RelationType relationType {get; set;}
    }
    /**
    *-------------------------------------------------------------------------------
    * @description Wrapper used to describe the RelationType that the service will provide.
    *-------------------------------------------------------------------------------
    **/
    public class RelationType {
        /**
        * @Description: String with id
        */
        public String id {get; set;}
        /**
        * @Description: String with name
        */
        public String name {get; set;}
    }
    /**
    * @description we have more than one group
    * @author amunguia.contractor@bbva.com | 03-18-2021
    * @return Boolean have errors
    **/
    public Boolean drawError () {
        if(matrix.isEmpty()) {
            getRecursiveMatrix (response.data.groups);
        }
        return matrix.isEmpty();
    }
    /**
    * @description returns the matrix
    * @author amunguia.contractor@bbva.com | 03-18-2021
    * @return String matrix
    **/
    public String calculateParent () {
        if(matrix.isEmpty()) {
            getRecursiveMatrix (response.data.groups);
        }
        return matrix.isEmpty() ? '' : matrix[0];
    }
    /**
    * @description getMatrix
    * @author amunguia.contractor@bbva.com | 03-18-2021
    * @param List<GroupWrapper> groups
    **/
    private static void getRecursiveMatrix (List<GroupWrapper> groups) {
        for (GroupWrapper currentGroup : groups) {
            if (currentGroup.isHolding && currentGroup.relation.relationType.id == 'GROUP') {
                matrix.add(currentGroup.id);
            }
        }
    }
    /**
    * @description addMessage
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