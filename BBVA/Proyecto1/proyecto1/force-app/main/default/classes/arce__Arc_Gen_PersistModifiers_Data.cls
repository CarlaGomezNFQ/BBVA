/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_PersistModifiers_Data
* @Author   jorge.diaz-blanco.contractor@bbva.com
* @Date     Created: 23/09/2020
* @Group    ARCE
* ------------------------------------------------------------------------------------------------
* @Description Class that retrieves modifier variable configuration from database.
* ------------------------------------------------------------------------------------------------
* @Changes
*
* |2020-05-08 joseluis.garcia4.contractor@bbva.com
*             Class creation.
* |2020-05-08 ivan.cons@bbva.com
*             Class refactor to be reusable.
* |2021-04-14 joseluis.garcia4.contractor@bbva.com
*             Class renaming for dependencies package.
* -----------------------------------------------------------------------------------------------
*/
global without sharing class Arc_Gen_PersistModifiers_Data {
    /**
    *-------------------------------------------------------------------------------
    * @description Wrapper used to describe a modifier variable in the same format
    * as required by the service.
    *-------------------------------------------------------------------------------
    **/
    global class ModifierVariableDefinition {
        /**
        * @Description: Unique identification of the modifier variable in the rating model.
        */
        global String id { get; set; }
        /**
        * @Description: Specifies if the data is a block or a factor within a rating model.
        */
        global String type { get; set; }
        /**
        * @Description: Specifies if the data is a block or a factor within a rating model.
        */
        global String parentCode { get; set; }
    }

    /**
    *-------------------------------------------------------------------------------
    * @description Empty constructor to avoid SonarQube warning.
    *-------------------------------------------------------------------------------
    **/
    private Arc_Gen_PersistModifiers_Data() { }  // NOPMD

    /**
    *-------------------------------------------------------------------------------
    * @description Fetches the modifier variable configuration (mapping between AHA fields and
    * modifier block variables) from the arce__Service_persistence__mdt custom metadata type.
    *-------------------------------------------------------------------------------
    * @author jorge.diaz-blanco.contractor@bbva.com
    * @date 23/09/2020
    * @return Map<String, ModifierVariableDefinition> - A Map that maps AHA field API names to
    * an object with the configuration of matching modifier block variables.
    **/
    global static Map<String, ModifierVariableDefinition> getModifierVariablesDefinition(String configName) {
        final Map<String, ModifierVariableDefinition> variablesByFieldApiName = new Map<String, ModifierVariableDefinition>();
        final List<arce__Service_persistence__mdt> variableDefConfigList = [SELECT arce__JSON_input__c FROM arce__Service_persistence__mdt WHERE DeveloperName = :configName];
        if (!variableDefConfigList.isEmpty()) {
            final arce__Service_persistence__mdt variableDefConfig = variableDefConfigList[0];
            variablesByFieldApiName.putAll(
                (Map<String, ModifierVariableDefinition>) JSON.deserializeStrict(variableDefConfig.arce__JSON_input__c, Map<String, ModifierVariableDefinition>.class));
        }
        return variablesByFieldApiName;
    }
}