/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_ValidateInfo_utils_Test
* @Author   Sai Jordana - saimassimilianno.jordana.contractor@bbva.com / BBVA ARCE
* @Date     Created: 29/10/2020
* @Group    ARCE
* -----------------------------------------------------------------------------------------------
* @Description test for method class Arc_Gen_ValidateInfo_utils.
* -----------------------------------------------------------------------------------------------
* @Changes
*
* |29-10-2020 Sai Jordana
*             Class creation.
*/
@IsTest
public with sharing class Arc_Gen_ValidateInfo_utils_Test {
    /**
    * --------------------------------------------------------------------------------------
    * @Description Test method to Arc_Gen_ValidateInfo_utils_Test
    * --------------------------------------------------------------------------------------
    * @Author   Sai Jordana - saimassimilianno.jordana.contractor@bbva.com / BBVA ARCE
    * @Date     Created: 29/10/2020
    * @param void
    * @return void
    * @example Arc_Gen_ValidateInfo_utils_Test.sumMapMethodTest()
    * --------------------------------------------------------------------------------------
    **/
    @isTest
    public static void sumMapMethodTest() {
        new Arc_Gen_ValidateInfo_utils();

        final Map<String, Decimal> mapTest = new Map<String, Decimal>();
        mapTest.put('prueba',241500.00);

        Test.startTest();
        final Map<String, Decimal> mapToAssert1 = Arc_Gen_ValidateInfo_utils.sumMapMethod(mapTest,'test','241500.00');
        final Map<String, Decimal> mapToAssert2 = Arc_Gen_ValidateInfo_utils.sumMapMethod(mapTest,'prueba','241500.00');
        System.assertEquals(mapToAssert2.isEmpty(), mapToAssert1.isEmpty(), 'Error sumMapMethodTest');
        Test.stopTest();
    }
    /**
    * --------------------------------------------------------------------------------------
    * @Description Test method to Arc_Gen_ValidateInfo_utils_Test
    * --------------------------------------------------------------------------------------
    * @Author   Sai Jordana - saimassimilianno.jordana.contractor@bbva.com / BBVA ARCE
    * @Date     Created: 29/10/2020
    * @param void
    * @return void
    * @example Arc_Gen_ValidateInfo_utils_Test.isFilledTest()
    * --------------------------------------------------------------------------------------
    **/
    @isTest
    public static void isFilledTest() {
        final String testRing;

        Test.startTest();
        final Boolean toAssert = Arc_Gen_ValidateInfo_utils.isFilled(testRing);
        System.assert(!toAssert, 'Error isFilledTest');
        Test.stopTest();
    }
    /**
    * --------------------------------------------------------------------------------------
    * @Description Test method to Arc_Gen_ValidateInfo_utils_Test
    * --------------------------------------------------------------------------------------
    * @Author   Sai Jordana - saimassimilianno.jordana.contractor@bbva.com / BBVA ARCE
    * @Date     Created: 29/10/2020
    * @param void
    * @return void
    * @example Arc_Gen_ValidateInfo_utils_Test.hasInfoMapTest()
    * --------------------------------------------------------------------------------------
    **/
    @isTest
    public static void hasInfoMapTest() {
        final Map<String,String> testMap;

        Test.startTest();
        final Boolean toAssert = Arc_Gen_ValidateInfo_utils.hasInfoMap(testMap);
        System.assert(!toAssert, 'Error hasInfoMapTest');
        Test.stopTest();
    }
    /**
    * --------------------------------------------------------------------------------------
    * @Description Test method to Arc_Gen_ValidateInfo_utils_Test
    * --------------------------------------------------------------------------------------
    * @Author   Sai Jordana - saimassimilianno.jordana.contractor@bbva.com / BBVA ARCE
    * @Date     Created: 29/10/2020
    * @param void
    * @return void
    * @example Arc_Gen_ValidateInfo_utils_Test.hasInfoMapObjTest()
    * --------------------------------------------------------------------------------------
    **/
    @isTest
    public static void hasInfoMapObjTest() {
        final Map<String,Object> testMap;

        Test.startTest();
        final Boolean toAssert = Arc_Gen_ValidateInfo_utils.hasInfoMapObj(testMap);
        System.assert(!toAssert, 'Error hasInfoMapObjTest');
        Test.stopTest();
    }
    /**
    * --------------------------------------------------------------------------------------
    * @Description Test method to Arc_Gen_ValidateInfo_utils_Test
    * --------------------------------------------------------------------------------------
    * @Author   Sai Jordana - saimassimilianno.jordana.contractor@bbva.com / BBVA ARCE
    * @Date     Created: 29/10/2020
    * @param void
    * @return void
    * @example Arc_Gen_ValidateInfo_utils_Test.hasInfoListMapObjTest()
    * --------------------------------------------------------------------------------------
    **/
    @isTest
    public static void hasInfoListMapObjTest() {
        final List<Map<String,Object>> testListMap;

        Test.startTest();
        final Boolean toAssert = Arc_Gen_ValidateInfo_utils.hasInfoListMapObj(testListMap);
        System.assert(!toAssert, 'Error hasInfoListMapObjTest');
        Test.stopTest();
    }
}