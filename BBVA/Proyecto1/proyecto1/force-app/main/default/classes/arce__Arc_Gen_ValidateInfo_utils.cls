/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_ValidateInfo_utils
* @Author   Javier Soto Carrascosa
* @Date     Created: 2019-11-03
* @Group    ARCE
* ------------------------------------------------------------------------------------------------
* @Description Utility class for all Info validations
* ------------------------------------------------------------------------------------------------
* |2019-11-03 javier.soto.carrascosa@bbva.com
*             Class creation.
* |2020-04-02 javier.soto.carrascosa@bbva.com
*             add new method
* -----------------------------------------------------------------------------------------------
*/
global class Arc_Gen_ValidateInfo_utils {
    /**
    * ----------------------------------------------------------------------------------------------------
    * @Description Void Constructor to avoid warning in sonar qube
    * ----------------------------------------------------------------------------------------------------
    * @param void
    * @return void
    * @example Arc_Gen_ValidateInfo_utils validateInfo = new Arc_Gen_ValidateInfo_utils()
    * ----------------------------------------------------------------------------------------------------
    **/
    @TestVisible
    private Arc_Gen_ValidateInfo_utils() {

    }
    /**
    *-------------------------------------------------------------------------------
    * @description Method that generates map of key value adding value if key exists
    --------------------------------------------------------------------------------
    * @author javier.soto.carrascosa@bbva.com
    * @date 2019-11-03
    * @param Map<String, Decimal> mapKeyValue, String key with key for the map, String value with value to be added
    * @return Map<String, Decimal> resulting of sum (value) according to the key
    * @example global static Map<String, Decimal> sumMapMethod(Map<String, Decimal> mapKeyValue, String key, String value)
    **/
    global static Map<String, Decimal> sumMapMethod(Map<String, Decimal> mapKeyValue, String key, String value) {
        Decimal sum;
        if(mapKeyValue.containsKey(key) == false) {
            sum = (value == null) ? 0 : Decimal.valueOf(value);
        } else {
            sum = (value == null) ? 0 : Decimal.valueOf(value) + mapKeyValue.get(key);
        }
        mapKeyValue.put(key, sum);
        return mapKeyValue;
    }
    /**
    *-------------------------------------------------------------------------------
    * @description Method that validates if a field contains information
    --------------------------------------------------------------------------------
    * @author javier.soto.carrascosa@bbva.com
    * @date 2019-11-03
    * @param String inputField with the field information
    * @return boolean true if field has information false if not
    * @example global static boolean isFilled(string inputField)
    **/
    global static boolean isFilled(string inputField) {
        boolean hasValue = true;
        if(inputField == null || inputField == '') {
            hasValue = false;
        }
        return hasValue;
    }
    /**
    *-------------------------------------------------------------------------------
    * @description Method that validates if a Map has info
    --------------------------------------------------------------------------------
    * @author javier.soto.carrascosa@bbva.com
    * @date 2020-04-02
    * @param Map<String,String> inputField with the field information
    * @return boolean true if Map has information false if not
    * @example global static boolean hasInfoMap(Map<String,String> inputField)
    **/
    global static boolean hasInfoMap(Map<String,String> inputField) {
        boolean hasValue = true;
        if(inputField == null || inputField.isEmpty()) {
            hasValue = false;
        }
        return hasValue;
    }
    /**
    *-------------------------------------------------------------------------------
    * @description Method that validates if Map<String,Object> is filled
    --------------------------------------------------------------------------------
    * @author javier.soto.carrascosa@bbva.com
    * @date 2020-04-04
    * @param Map<String,Object> inputField with the Map information
    * @return boolean true if Map has information false if not
    * @example global static boolean isFilled(string inputField)
    **/
    global static boolean hasInfoMapObj(Map<String,Object> inputField) {
        boolean hasValue = true;
        if(inputField == null || inputField.isEmpty()) {
            hasValue = false;
        }
        return hasValue;
    }
    /**
    *-------------------------------------------------------------------------------
    * @description Method that validates if List<Map<String,Object>> is filled
    --------------------------------------------------------------------------------
    * @author javier.soto.carrascosa@bbva.com
    * @date 2020-04-04
    * @param List<Map<String,Object>> inputField with the Map information
    * @return boolean true if Map has information false if not
    * @example global static boolean isFilled(string inputField)
    **/
    global static boolean hasInfoListMapObj(List<Map<String,Object>> inputField) {
        boolean hasValue = true;
        if(inputField == null || inputField.isEmpty()) {
            hasValue = false;
        }
        return hasValue;
    }
}