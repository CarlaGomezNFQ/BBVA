/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_IndustryRiskRating_RP
* @Author   amunguia.contractor@bbva.com
* @Date     Created: 16/09/2021
* @Group    ARCE
* -----------------------------------------------------------------------------------------------
* @Description Arc_Gen_IndustryRiskRating_RP
* -----------------------------------------------------------------------------------------------
* @Changes
*
* |18-03-2021 amunguia.contractor@bbva.com
*             Class creation.
* -----------------------------------------------------------------------------------------------
*/
public with sharing class Arc_Gen_IndustryRiskRating_RP {
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
        * @Description: id
        */
        public String id {get; set;}//NOSONAR
        /**
        * @Description: RatingWrapper list
        */
        public List<RatingWrapper> ratings {get; set;}
    }


    /**
    *-------------------------------------------------------------------------------
    * @description Wrapper used to describe the RatingType that the service will provide.
    *-------------------------------------------------------------------------------
    **/
    public class RatingType {
        /**
        * @Description: String with id
        */
        public String id {get; set;}//NOSONAR
    }
    /**
    *-------------------------------------------------------------------------------
    * @description Wrapper used to describe the Ratings that the service will provide.
    *-------------------------------------------------------------------------------
    **/
    public class RatingWrapper {
        /**
        * @Description: Wrapper with RatingType
        */
        public RatingType ratingType {get; set;}
        /**
        * @Description: Decimal with score
        */
        public Decimal score {get; set;}
        /**
        * @Description: shortScaleValue
        */
        public String shortScaleValue {get; set;}
        /**
        * @Description: longtScaleValue
        */
        public String longScaleValue {get; set;}
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
    /**
    * @description calculateRatingScore
    * @author amunguia.contractor@bbva.com | 16-09-2021
    * @return Decimal
    **/
    public Map<String, Decimal> calculateRatingScore () {
        final Map<String, Decimal> scoreMap = new Map<String, Decimal>();
        for(RatingWrapper aux :response.data.ratings) {
            scoreMap.put(aux.ratingType.id, aux.score);
        }
        return scoreMap;
    }

}