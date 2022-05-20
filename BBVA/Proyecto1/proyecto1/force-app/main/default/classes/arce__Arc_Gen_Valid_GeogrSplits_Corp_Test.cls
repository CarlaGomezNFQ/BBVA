/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_Valid_GeogrSplits_Corp_Test
* @Author   José Híjar García
* @Date     Created: 2020-10-16
* @Group    ARCE
* ------------------------------------------------------------------------------------------------
* @Description Class for testing Arc_Gen_Validate_GeoSplits_Corp class
* ------------------------------------------------------------------------------------------------
* @Changes
* |2020-10-16 jose.hijar.contractor@bbva.com
*             Class creation.
* -----------------------------------------------------------------------------------------------
*/
@isTest
public with sharing class Arc_Gen_Valid_GeogrSplits_Corp_Test {

    /**
    *-------------------------------------------------------------------------------
    * @Description Tests a successful functional execution
    *--------------------------------------------------------------------------------
    * @Author jose.hijar.contractor@bbva.com
    * @Date   Created: 2020-10-16
    *--------------------------------------------------------------------------------
    **/
    @isTest
    static void beforeSaveDataTestOK() {
        List<Object> objList=new List<Object>();
        String ret;

        Arc_Gen_Validate_GeoSplits_Corp validationClass=new Arc_Gen_Validate_GeoSplits_Corp();
        Arc_Gen_Validate_GeoSplits_Corp.Wrapper retObj;

        objList.add(createGeographyObject('56.23'));

        Test.startTest();
        ret=validationClass.beforeSaveData(objList);
        Test.stopTest();

        retObj=(Arc_Gen_Validate_GeoSplits_Corp.Wrapper)JSON.deserialize(ret, Arc_Gen_Validate_GeoSplits_Corp.Wrapper.class);

        System.assertEquals(true, retObj.validation,'Validation false not passed, expected true');


    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Tests a failed functional execution
    *--------------------------------------------------------------------------------
    * @Author jose.hijar.contractor@bbva.com
    * @Date   Created: 2020-10-16
    *--------------------------------------------------------------------------------
    **/
    @isTest
    static void beforeSaveDataTestKO() {
        List<Object> objList=new List<Object>();
        String ret;

        Arc_Gen_Validate_GeoSplits_Corp validationClass=new Arc_Gen_Validate_GeoSplits_Corp();
        Arc_Gen_Validate_GeoSplits_Corp.Wrapper retObj;

        objList.add(createGeographyObject('156.23'));

        Test.startTest();
        ret=validationClass.beforeSaveData(objList);
        Test.stopTest();

        retObj=(Arc_Gen_Validate_GeoSplits_Corp.Wrapper)JSON.deserialize(ret, Arc_Gen_Validate_GeoSplits_Corp.Wrapper.class);

        System.assertEquals(false, retObj.validation,'Validation true passed, expected false');


    }

    /**
    *-------------------------------------------------------------------------------
    * @Description Tests a failed runtime execution
    *--------------------------------------------------------------------------------
    * @Author jose.hijar.contractor@bbva.com
    * @Date   Created: 2020-10-16
    *--------------------------------------------------------------------------------
    **/
    @isTest
    static void beforeSaveDataTestKO2() {
        List<Object> objList=new List<Object>();
        String ret;

        Arc_Gen_Validate_GeoSplits_Corp validationClass=new Arc_Gen_Validate_GeoSplits_Corp();
        Arc_Gen_Validate_GeoSplits_Corp.Wrapper retObj;

        objList.add(createGeographyObject('dddf'));

        Test.startTest();
        ret=validationClass.beforeSaveData(objList);
        Test.stopTest();

        retObj=(Arc_Gen_Validate_GeoSplits_Corp.Wrapper)JSON.deserialize(ret, Arc_Gen_Validate_GeoSplits_Corp.Wrapper.class);

        System.assertEquals(false, retObj.validation,'Validation true passed, expected false');
    }

    /**
    *-------------------------------------------------------------------------------
    * @Description creates test data object
    *--------------------------------------------------------------------------------
    * @Author jose.hijar.contractor@bbva.com
    * @Date   Created: 2020-10-16
    * @param  String weight of the geography created
    *--------------------------------------------------------------------------------
    **/
    static Object createGeographyObject(String geographyWeight) {

        String str='{'+
            '"arce__Activity_Split__c":"randomIda003N000002N7zOQAS",'+
            '"arce__gf_geography_weight_per__c":"'+geographyWeight+'",'+
            '"arce__Country__c":"1"'+
        '}';
        return JSON.deserializeUntyped(str);
    }
}