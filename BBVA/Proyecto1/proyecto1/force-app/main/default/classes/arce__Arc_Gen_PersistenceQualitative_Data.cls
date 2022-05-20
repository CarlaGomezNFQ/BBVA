/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_PersistenceQualitative_Data
* @Author   José Luis García Díaz   joseluis.garcia4.contractor@bbva.com
* @Date     Created: 08/05/2020
* @Group    ARCE
* ------------------------------------------------------------------------------------------------
* @Description Class that retrieves qualitative variable configuration from database.
* ------------------------------------------------------------------------------------------------
* @Changes
*
* |2020-05-08 joseluis.garcia4.contractor@bbva.com
*             Class creation.
* -----------------------------------------------------------------------------------------------
*/
@SuppressWarnings('sf:UseSingleton, PMD.ShortVariable')
global without sharing class Arc_Gen_PersistenceQualitative_Data {
    /**
    * @Description: DeveloperName of the arce__Service_persistence__mdt record that contains qualitative
    * variable mappings.
    */
    global static final String QCONF_NAME = Test.isRunningTest() ? 'qualitativeBlocksTest' : 'qualitativeBlocks';

    /**
    *-------------------------------------------------------------------------------
    * @description Wrapper used to describe a qualitative variable in the same format
    * as required by the service.
    *-------------------------------------------------------------------------------
    **/
    global class QualitativeVariableDefinition {
        /**
        * @Description: Unique identification of the qualitative variable in the rating model.
        */
        global String id { get; set; }
        /**
        * @Description: Specifies if the data is a block or a factor within a rating model.
        */
        global String type { get; set; }
    }

    /**
    *-------------------------------------------------------------------------------
    * @description Empty constructor to avoid SonarQube warning.
    *-------------------------------------------------------------------------------
    **/
    global Arc_Gen_PersistenceQualitative_Data() { }  // NOSONAR

    /**
    *-------------------------------------------------------------------------------
    * @description Fetches the qualitative variable configuration (mapping between AHA fields and
    * qualitative block variables) from the arce__Service_persistence__mdt custom metadata type.
    *-------------------------------------------------------------------------------
    * @author joseluis.garcia4.contractor@bbva.com
    * @date 08/05/2020
    * @return Map<String, QualitativeVariableDefinition> - A Map that maps AHA field API names to
    * an object with the configuration of matching qualitative block variables.
    **/
    global static Map<String, QualitativeVariableDefinition> getQualitativeVariablesDefinition() {
        final Map<String, QualitativeVariableDefinition> varByApi = new Map<String, QualitativeVariableDefinition>();
        final List<arce__Service_persistence__mdt> varDefConfLst = [SELECT arce__JSON_input__c FROM arce__Service_persistence__mdt WHERE DeveloperName = :QCONF_NAME];

        if (!varDefConfLst.isEmpty()) {
            final arce__Service_persistence__mdt variableDefConfig = varDefConfLst[0];
            varByApi.putAll(
                (Map<String, QualitativeVariableDefinition>) JSON.deserializeStrict(variableDefConfig.arce__JSON_input__c, Map<String, QualitativeVariableDefinition>.class));
        }

        return varByApi;
    }
}