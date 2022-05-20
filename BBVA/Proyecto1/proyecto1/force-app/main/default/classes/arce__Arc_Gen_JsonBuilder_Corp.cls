/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_JsonBuilder
* @Author   ivan.cons.contractor@bbva.com
* @Date     Created: 2020/05/27
* @Group    ARCE
* ------------------------------------------------------------------------------------------------
* @Description retrieve a JSON to build dynamics tables.
* ------------------------------------------------------------------------------------------------
* @Changes
*
* |2019-07-12 luisruben.quinto.munoz@bbva.com
*             Class creation.
* |2019-08-29 mariohumberto.ramirez.contractor@bbva.com
*             Added new param "apiNameObject".
* -----------------------------------------------------------------------------------------------
*/
global with sharing class Arc_Gen_JsonBuilder_Corp implements cmpw.GBL_ComponentWrapper_Interface {
    /**
    *-------------------------------------------------------------------------------
    * @Description retrieve financial statemnts formated to table
    *--------------------------------------------------------------------------------
    * @ Author ivan.cons.contractor@bbva.com
    * @ Date 2020/05/27
    * @ param recordId recordId of the account_has_analysis.
    * @ param jsonInput Json obtained from the component.
    * @ return JsonFinal returns the Json generated from the method.
    * @ example Arc_Gen_JsonBuilder.getComponents(recordId,jsonInput)
    *--------------------------------------------------------------------------------
    **/
    global static String getComponents(Id recordId, String jsonInput){
      Map<String, Object> jsonMap = (Map<String, Object>)JSON.deserializeUntyped(jsonInput);
      String collectionType = String.valueOf(jsonMap.get('collectionType'));
      String apiNameObject = String.valueOF(jsonMap.get('apiNameObject'));
      String buttons = Arc_Gen_Buttons_controller_Corp.getButtonsJsonComponent(collectionType,recordId,apiNameObject);
      String jsonFinal;
      jsonFinal = '{"orientation":"horizontal",'+
                          '"components":['+
                          //table+
                          //charts+
                          buttons+
                          ']'+
                          '}';
      return jsonFinal;
    }
  }