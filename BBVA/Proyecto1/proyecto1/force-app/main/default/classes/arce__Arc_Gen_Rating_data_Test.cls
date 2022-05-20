/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_RAIPButtons_Test
* @Author   Sai Jordana - saimassimilianno.jordana.contractor@bbva.com / BBVA ARCE
* @Date     Created: 29/10/2020
* @Group    ARCE
* -----------------------------------------------------------------------------------------------
* @Description test for method class Arc_Gen_Rating_data.
* -----------------------------------------------------------------------------------------------
* @Changes
*
* |29-10-2020 Sai Jordana
*             Class creation.
*/
@isTest
public with sharing class Arc_Gen_Rating_data_Test {
    /**
    * --------------------------------------------------------------------------------------
    * @Description Setup method for Arc_Gen_Rating_data_Test
    * --------------------------------------------------------------------------------------
    * @Author   Sai Jordana - saimassimilianno.jordana.contractor@bbva.com / BBVA ARCE
    * @Date     Created: 29/10/2020
    * @param void
    * @return void
    * @example Arc_Gen_Rating_data_Test.setup()
    * --------------------------------------------------------------------------------------
    **/
    @testSetup
    public static void setup() {
        final arce__rating__c newRating = new arce__rating__c();
        newRating.arce__short_rating_value_type__c = 'AAA';
        insert newRating;
    }

    /**
    * --------------------------------------------------------------------------------------
    * @Description Test method to Arc_Gen_RAIPButtons
    * --------------------------------------------------------------------------------------
    * @Author   Sai Jordana - saimassimilianno.jordana.contractor@bbva.com / BBVA ARCE
    * @Date     Created: 29/10/2020
    * @param void
    * @return void
    * @example Arc_Gen_Rating_data_Test.generalRatingDataTest()
    * --------------------------------------------------------------------------------------
    **/
    @isTest
    public static void generalRatingDataTest() {
        new Arc_Gen_Rating_data();
        final List<String> recordsID = new List<String>();
        recordsID.add([SELECT id FROM arce__rating__c LIMIT 1].Id);
        Test.startTest();
        final List<arce__rating__c> ltsValues = Arc_Gen_Rating_data.generalRatingData(recordsID);
        System.assertEquals(ltsValues[0].arce__short_rating_value_type__c, 'AAA', 'There is an error with the method');
        Test.stopTest();
    }
}