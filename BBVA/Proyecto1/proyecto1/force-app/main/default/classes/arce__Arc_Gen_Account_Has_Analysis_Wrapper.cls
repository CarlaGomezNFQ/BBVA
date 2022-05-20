/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_Account_Has_Analysis_Wrapper
* @Author   manuelhug.castillota.contractor@bbva.com
* @Date     Created: 150/12/2019
* @Group    ARCE
* -----------------------------------------------------------------------------------------------
* @Description Arc_Gen_Account_Has_Analysis_Wrapper that retrieves full account has analysis information
* -----------------------------------------------------------------------------------------------
* @Example Arc_Gen_Account_Has_Analysis_Wrapper wrapper = new Arc_Gen_Account_Has_Analysis_Wrapper();
* -----------------------------------------------------------------------------------------------
@Changes
*
* |2020-09-23 ivan.cons@bbva.com
*             Added method getX and modifier as parameter
* |2021-02-23 ivan.cons@bbva.com
*             Remove SP2 dependencies
* -----------------------------------------------------------------------------------------------
*/
@JsonAccess(serializable='always' deserializable='always')
global class Arc_Gen_Account_Has_Analysis_Wrapper {
    /**
    *
    * @Description : Account Has Analyisis Object
    */
    @AuraEnabled global arce__Account_has_Analysis__c ahaObj { get;set; }
    /**
    *
    * @Description : Account Wrapper Object
    */
    @AuraEnabled global Arc_Gen_Account_Wrapper accWrapperObj { get;set; }
    /**
    *
    * @Description : Modifier Object
    */
    @AuraEnabled global sObject modifierObj { get;set; }
    /**
    *
    * @Description : Overlay Object
    */
    @AuraEnabled global sObject overlayObj { get;set; }
    /**
    *-------------------------------------------------------------------------------
    * @description Gets the field specified as string to emulate the get method of map class
    *-------------------------------------------------------------------------------
    * @author ivan.cons@bbva.com
    * @date 23/09/2020
    * @param String paramName - Name of the parameter to be retrieved
    * @return Map<String, Object> - The parameter returned.
    **/
    global Map<String, Object> getX(String paramName) {
            String jsonInstance = Json.serialize(this);
            Map<String, Object> untypedInstance;
            untypedInstance= (Map<String, Object>)JSON.deserializeUntyped(jsonInstance);
            Map<String, Object> returnmap;
            try {
                returnmap = (Map<String, Object>) untypedInstance.get(paramName);
            } catch(TypeException ex) {
                System.debug('Arc_Gen_Account_Has_Analysis_Wrapper.getX: ' + ex.getMessage());
            }
            return returnmap;
    }
}