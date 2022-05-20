/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_Valid_ActivSplits_Corp_Test
* @Author   José Híjar García
* @Date     Created: 2020-10-16
* @Group    ARCE
* ------------------------------------------------------------------------------------------------
* @Description Class for testing Arc_Gen_Validate_ActivitySplits_Corp class
* ------------------------------------------------------------------------------------------------
* @Changes
* |2020-10-16 jose.hijar.contractor@bbva.com
*             Class creation.
* -----------------------------------------------------------------------------------------------
*/
@isTest
public class Arc_Gen_Valid_ActivSplits_Corp_Test {

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

        Arc_Gen_Validate_ActivitySplits_Corp validationObj=new Arc_Gen_Validate_ActivitySplits_Corp();
        Arc_Gen_Validate_ActivitySplits_Corp.Wrapper retObj;

        objList.add(createActivityObject('56.23'));

        Test.startTest();
        ret=validationObj.beforeSaveData(objList);
        Test.stopTest();

        retObj=(Arc_Gen_Validate_ActivitySplits_Corp.Wrapper)JSON.deserialize(ret, Arc_Gen_Validate_ActivitySplits_Corp.Wrapper.class);

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

        Arc_Gen_Validate_ActivitySplits_Corp validationObj=new Arc_Gen_Validate_ActivitySplits_Corp();
        Arc_Gen_Validate_ActivitySplits_Corp.Wrapper retObj;

        objList.add(createActivityObject('156.23'));

        Test.startTest();
        ret=validationObj.beforeSaveData(objList);
        Test.stopTest();

        retObj=(Arc_Gen_Validate_ActivitySplits_Corp.Wrapper)JSON.deserialize(ret, Arc_Gen_Validate_ActivitySplits_Corp.Wrapper.class);

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

        Arc_Gen_Validate_ActivitySplits_Corp validationObj=new Arc_Gen_Validate_ActivitySplits_Corp();
        Arc_Gen_Validate_ActivitySplits_Corp.Wrapper retObj;

        objList.add(createActivityObject('dddf'));

        Test.startTest();
        ret=validationObj.beforeSaveData(objList);
        Test.stopTest();

        retObj=(Arc_Gen_Validate_ActivitySplits_Corp.Wrapper)JSON.deserialize(ret, Arc_Gen_Validate_ActivitySplits_Corp.Wrapper.class);

        System.assertEquals(false, retObj.validation,'Validation true passed, expected false');
    }

    /**
    *-------------------------------------------------------------------------------
    * @Description creates test data object
    *--------------------------------------------------------------------------------
    * @Author jose.hijar.contractor@bbva.com
    * @Date   Created: 2020-10-16
    * @param  String weight of the activity created
    *--------------------------------------------------------------------------------
    **/
    static Object createActivityObject(String activityWeight) {

        String str='{ '+
            '"arce__Account_has_Analysis__c":"randomIda003N000002N7zOQAS",'+
            '"arce__gf_subindustry_weight_per__c":"'+activityWeight+'",'+
            '"arce__Template_type__c":"14",'+
            '"arce__gf_subactivity_id__c":"811",'+
            '"arce__gf_company_economic_actvy_id__c":"IBA",'+
            '"arce__Subsector_id__c":"IF",'+
            '"arce__sector_id__c":"I"'+
        '}';
        return JSOn.deserializeUntyped(str);
    }

}