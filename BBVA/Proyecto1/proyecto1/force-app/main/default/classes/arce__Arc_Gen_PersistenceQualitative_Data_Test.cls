/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_RAIPButtons_Test
* @Author   Sai Jordana - saimassimilianno.jordana.contractor@bbva.com / BBVA ARCE
* @Date     Created: 29/10/2020
* @Group    ARCE
* -----------------------------------------------------------------------------------------------
* @Description test for method class Arc_Gen_PersistenceQualitative_Data.
* -----------------------------------------------------------------------------------------------
* @Changes
*
* |29-10-2020 Sai Jordana
*             Class creation.
*/
@isTest
public class Arc_Gen_PersistenceQualitative_Data_Test {
    /**
    * --------------------------------------------------------------------------------------
    * @Description Test method to Arc_Gen_PersistenceQualitative_Data
    * --------------------------------------------------------------------------------------
    * @Author   Sai Jordana - saimassimilianno.jordana.contractor@bbva.com / BBVA ARCE
    * @Date     Created: 29/10/2020
    * @param void
    * @return void
    * @example Arc_Gen_PersistenceQualitative_Data_Test.getQualitativeVariablesDefinitionTest()
    * --------------------------------------------------------------------------------------
    **/
    @isTest
    public static void getQualitativeVariablesDefinitionTest() {
        Test.startTest();
        final Map<String, Arc_Gen_PersistenceQualitative_Data.QualitativeVariableDefinition> qualitativeData = Arc_Gen_PersistenceQualitative_Data.getQualitativeVariablesDefinition();
        System.assert(!qualitativeData.isEmpty(), 'The qualityData result is empty');
        Test.stopTest();
    }

    /**
    * --------------------------------------------------------------------------------------
    * @Description Test method to Arc_Gen_PersistenceQualitative_Data
    * --------------------------------------------------------------------------------------
    * @Author   Sai Jordana - saimassimilianno.jordana.contractor@bbva.com / BBVA ARCE
    * @Date     Created: 29/10/2020
    * @param void
    * @return void
    * @example Arc_Gen_PersistenceQualitative_Data_Test.QualitativeVariableDefinitionTest()
    * --------------------------------------------------------------------------------------
    **/
    @isTest
    public static void qualitativeVariableDefinitionTest() {
        new Arc_Gen_PersistenceQualitative_Data();
        Test.startTest();
        final Arc_Gen_PersistenceQualitative_Data.QualitativeVariableDefinition definition = new Arc_Gen_PersistenceQualitative_Data.QualitativeVariableDefinition();
        definition.id = 'testId';
        definition.type = 'testType';
        System.assertEquals(definition.id, 'testId', 'The definition is not working');
        Test.stopTest();
    }
}