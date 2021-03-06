/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_TabSet_controller_test
* @Author   Mario Humberto Ramirez Lio - mariohumberto.ramirez.contractor@bbva.com
* @Date     Created: 2019-07-17
* @Group    ARCE
* ------------------------------------------------------------------------------------------------
* @Description Test class for code coverage of: Arc_Gen_TabSet_controller, Arc_Gen_TabSet_service
* and  Arc_Gen_TabSet_ServiceHelper
* ------------------------------------------------------------------------------------------------
* @Changes
*
* |11/04/2019 diego.miguel.contractor@bbva.com
*             Class creation.
* |2019-07-17 mariohumberto.ramirez.contractor@bbva.com
*             Documentation and refactor for change in completness.
* |2019-07-29 mariohumberto.ramirez.contractor@bbva.com
*             Add new lines of data in order to increment test coverage.
* |2019-08-08 mariohumberto.ramirez.contractor@bbva.com
*             Add new line Arc_UtilitysDataTest_tst.createIndustryAnalysisData()
*             in order to increment test coverage.
* |2019-08-09 mariohumberto.ramirez.contractor@bbva.com
*             Add new method "testContructorSector" in order to increment test coverage of the
*             Arc_Gen_Sector_Data class.
* |2019-11-20 mariohumberto.ramirez.contractor@bbva.com
*             Update test class
* |2020-01-09 javier.soto.carrascosa@bbva.com
*             Adapt test classess with account wrapper and setupaccounts
* |2020-03-30 eduardoefrain.hernandez.contractor@bbva.com
*             Add test methods to test the units converter of Group Risk Table
* |2020-04-24 eduardoefrain.hernandez.contractor@bbva.com
*             Add test methods to test the update the automated fields in group chrome
* |2020-06-10 cesaroctavio.villanueva.cebal@bbva.com
*             Added limits for getAccountHasAnalysis method
* |2020-08-11 javier.soto.carrascosa@bbva.com
*             Update sector field
* |2020-09-23 saimassimilianno.jordana.contractor@bbva.com
*             Added arce. namespace to all classes that are now in the arce-dependencies package
* -----------------------------------------------------------------------------------------------
*/
@SuppressWarnings('sf:TooManyMethods')
@isTest
public class Arc_Gen_TabSet_controller_test {
    /**
    * --------------------------------------------------------------------------------------
    * @Description Setup method for Arc_Gen_TabSet_controller_test
    * --------------------------------------------------------------------------------------
    * @Author   Mario Humberto Ramirez Lio - mariohumberto.ramirez.contractor@bbva.com
    * @Date     Created: 2019-07-17
    * @param void
    * @return void
    * @example Arc_Gen_TabSet_controller_test.setup()
    * --------------------------------------------------------------------------------------
    **/
    @testSetup static void setup() {
        Arc_UtilitysDataTest_tst.setupAcccounts();
        final Map<String,arce.Arc_Gen_Account_Wrapper> groupAccWrapper = arce.Arc_Gen_Account_Locator.getAccountByAccNumber(new List<String>{'G000001'});
        final arce.Arc_Gen_Account_Wrapper groupAccount = groupAccWrapper.get('G000001');

        final arce__Sector__c newSector = arc_UtilitysDataTest_tst.crearSector('Generic', '100;200;300;400;500;600', '1', null);
        insert newSector;

        final arce__Analysis__c newArce = arc_UtilitysDataTest_tst.crearArceAnalysis('Arce Analysis', null, groupAccount.accId);
        newArce.arce__anlys_wkfl_sub_process_type__c = '2';
        newArce.arce__wf_status_id__c = '03';
        insert newArce;

        final arce__Account_has_Analysis__c newAnalysisGr = arc_UtilitysDataTest_tst.crearAccHasAnalysis(newSector.id, newArce.Id, groupAccount.accId, '1');
        newAnalysisGr.arce__group_asset_header_type__c = '1';
        insert newAnalysisGr;

        final arce__Account_has_Analysis__c newAnalysis = arc_UtilitysDataTest_tst.crearAccHasAnalysis(newSector.id, newArce.Id, groupAccount.accId, '1');
        newAnalysis.arce__group_asset_header_type__c = '2';
        newAnalysis.arce__InReview__c = true;
        newAnalysis.arce__participant_srty_age_number__c = System.today() - 1;
        newAnalysis.arce__customer_qualitative_type__c = '2';
        insert newAnalysis;

        final arce__limits_typology__c typology = Arc_UtilitysDataTest_tst.crearLimitTypology('TOTAL Financial Risk ST & Commercial Risk', null, 'TP_0001');
        insert typology;

        arce__limits_typology__c l1 = Arc_UtilitysDataTest_tst.crearLimitTypology(System.Label.Arc_Gen_ExecRepTipologyTCR, null, null);
        l1.arce__risk_typology_level_id__c = 'TP_0006';
        l1.arce__risk_typology_level_type__c = '1';
        l1.arce__Typology_Order__c = 1;
        l1.arce__risk_typology_active__c = true;
        Insert l1;

        arce__limits_typology__c l1b = Arc_UtilitysDataTest_tst.crearLimitTypology('TOTAL Financial Risk ST & Commercial Risk', null, null);
        l1b.arce__risk_typology_level_id__c = 'TP_0005';
        l1b.arce__risk_typology_level_type__c = '1';
        l1b.arce__Typology_Order__c = 2;
        Insert l1b;

        arce__limits_typology__c l2 = Arc_UtilitysDataTest_tst.crearLimitTypology('Commercial Risk', l1b.Id, null);
        l2.arce__risk_typology_level_id__c = 'TP_0010';
        l2.arce__risk_typology_active__c = true;
        l2.arce__risk_typology_level_type__c = '2';
        l2.arce__risk_typology_parent_id__c = l1.Id;
        Insert l2;
        arce__limits_typology__c projectFinance = Arc_UtilitysDataTest_tst.crearLimitTypology('Project Finance', null, null);
        projectFinance.arce__risk_typology_level_id__c = System.Label.Arc_Gen_ProjectFinance;
        projectFinance.arce__risk_typology_level_type__c = '1';
        projectFinance.arce__Typology_Order__c = 1;
        Insert projectFinance;
        arce__limits_typology__c totalCR = Arc_UtilitysDataTest_tst.crearLimitTypology('TOTAL CORPORATE RISK', null, null);
        totalCR.arce__risk_typology_level_id__c = System.Label.Arc_Gen_TOTAL_CORPORATE_RISK;
        totalCR.arce__risk_typology_level_type__c = '1';
        totalCR.arce__Typology_Order__c = 1;
        Insert totalCR;

        arce__limits_exposures__c lim1 = Arc_UtilitysDataTest_tst.crearLimitExposures(null,null,newAnalysisGr.Id,l1b.Id);
        Insert lim1;
        arce__limits_exposures__c lim2 = Arc_UtilitysDataTest_tst.crearLimitExposures(lim1.Id,null,newAnalysisGr.Id,l2.Id);
        Insert lim2;

        Arc_UtilitysDataTest_tst.setupProducts();
        final Map<Id,Arc_Gen_Product_Wrapper> pWrap = Arc_Gen_Product_Locator.getProductsFromTypology('familyTest');
        final Arc_Gen_Product_Wrapper prodWrapper = pWrap.get(new List<Id>(pWrap.keySet())[0]);

        arce__limits_exposures__c lim1GR = Arc_UtilitysDataTest_tst.crearLimitExposures(null,null,newAnalysisGr.Id,l1b.Id);
        Insert lim1GR;
        arce__limits_exposures__c lim1duplicatedGR = Arc_UtilitysDataTest_tst.crearLimitExposures(null,null,newAnalysisGr.Id,l1b.Id);
        Insert lim1duplicatedGR;
        arce__limits_exposures__c lim2GR = Arc_UtilitysDataTest_tst.crearLimitExposures(lim1.Id,null,newAnalysisGr.Id,l2.Id);
        Insert lim2GR;
        arce__limits_exposures__c limExp1GR = Arc_UtilitysDataTest_tst.crearLimitExposures(null,null,newAnalysisGr.Id,projectFinance.Id);
        limExp1GR.arce__last_approved_amount__c = 1;
        limExp1GR.arce__outstanding_amount__c = 1;
        limExp1GR.arce__current_formalized_amount__c = 1;
        limExp1GR.arce__current_proposed_amount__c = 0;

        Insert limExp1GR;
        arce__limits_exposures__c limExp2GR = Arc_UtilitysDataTest_tst.crearLimitExposures(null,null,newAnalysisGr.Id,totalCR.Id);
        limExp2GR.arce__last_approved_amount__c = 1;
        limExp2GR.arce__outstanding_amount__c = 1;
        limExp2GR.arce__current_formalized_amount__c = 1;
        limExp2GR.arce__current_proposed_amount__c = 1;

        Insert limExp2GR;
        arce__limits_exposures__c limExp3GR = Arc_UtilitysDataTest_tst.crearLimitExposures(null,null,newAnalysisGr.Id,l1.Id);
        limExp3GR.arce__last_approved_amount__c = 1;

        Insert limExp3GR;
        arce__limits_exposures__c modGR = Arc_UtilitysDataTest_tst.crearLimitExposures(lim2.Id,null,newAnalysisGr.Id,null);
        modGR.arce__curr_apprv_deleg_dchan_amount__c = 1;
        modGR.arce__Product_id__c = prodWrapper.productId;
        Insert modGR;

        Arc_UtilitysDataTest_tst createExposures = new Arc_UtilitysDataTest_tst();
        final arce__limits_exposures__c exposure1 = createExposures.crearExposures(typology.Id, newAnalysis.Id, 7);
        insert exposure1;

        Arc_UtilitysDataTest_tst.createBasicDataData();
    }
    /**
    * --------------------------------------------------------------------------------------
    * @Description - Method that returns the JSON to build tabset component
    * --------------------------------------------------------------------------------------
    * @Author   Mario Humberto Ramirez Lio - mariohumberto.ramirez.contractor@bbva.com
    * @Date     Created: 2019-07-17
    * @param void
    * @return void
    * @example Arc_Gen_TabSet_controller_test.testGetTabsSuccess()
    * --------------------------------------------------------------------------------------
    **/
    @isTest static void testGetTabsSuccess() {
        final arce__Account_has_Analysis__c accHasAnls = [SELECT Id FROM arce__Account_has_Analysis__c LIMIT 1];
        Test.startTest();
        final String tabWrapper = Arc_Gen_TabSet_controller.getTabsJson(accHasAnls.Id);
        system.assertEquals(String.isEmpty(tabWrapper), false, 'The result is not empty');
        Test.stopTest();
    }
    /**
    * --------------------------------------------------------------------------------------
    * @Description - Method that returns a message of error
    * --------------------------------------------------------------------------------------
    * @Author   Mario Humberto Ramirez Lio - mariohumberto.ramirez.contractor@bbva.com
    * @Date     Created: 2019-07-17
    * @param void
    * @return void
    * @example Arc_Gen_TabSet_controller_test.testGetTabsError()
    * --------------------------------------------------------------------------------------
    **/
    @isTest static void testGetTabsError() {
        final Account acc = [SELECT Id FROM Account LIMIT 1];
        Test.startTest();
        final String tabWrapper2 = Arc_Gen_TabSet_controller.getTabsJson(acc.id);
        system.assertEquals(String.isEmpty(tabWrapper2), false, 'The result is not empty');
        Test.stopTest();
    }
    /**
    * --------------------------------------------------------------------------------------
    * @Description - Method that returns the JSON to build tabset component
    * --------------------------------------------------------------------------------------
    * @Author   Mario Humberto Ramirez Lio - mariohumberto.ramirez.contractor@bbva.com
    * @Date     Created: 2019-07-17
    * @param void
    * @return void
    * @example Arc_Gen_TabSet_controller_test.testGetComple()
    * --------------------------------------------------------------------------------------
    **/
    @isTest static void testGetComple() {
        final arce__Account_has_Analysis__c accHasAnls = [SELECT Id FROM arce__Account_has_Analysis__c LIMIT 1];
        accHasAnls.arce__group_asset_header_type__c = '2';
        accHasAnls.arce__magnitude_unit_type__c = '1';
        accHasAnls.arce__prev_magnitude_unit_type__c = '2';
        upsert accHasAnls;

        final arce__Analysis__c arceVar = [SELECT Id FROM arce__Analysis__c LIMIT 1];
        arceVar.arce__Stage__c = '1';
        upsert arceVar;

        Test.startTest();
        final Arc_Gen_TabSet_controller.TabsWrapper result = Arc_Gen_TabSet_controller.callTemplateAnalysisJson(accHasAnls.Id);
        system.assertEquals(String.isEmpty(result.gblDescriptionResponse), false, 'The result is not empty');
        Test.stopTest();
    }
    /**
    * --------------------------------------------------------------------------------------
    * @Description - Method that returns the JSON to build tabset component
    * --------------------------------------------------------------------------------------
    * @Author   Mario Humberto Ramirez Lio - mariohumberto.ramirez.contractor@bbva.com
    * @Date     Created: 2019-07-17
    * @param void
    * @return void
    * @example Arc_Gen_TabSet_controller_test.testGetComple2()
    * --------------------------------------------------------------------------------------
    **/
    @isTest static void testGetComple2() {
        final arce__Account_has_Analysis__c accHasAnls = [SELECT Id FROM arce__Account_has_Analysis__c LIMIT 1];
        accHasAnls.arce__group_asset_header_type__c = '2';
        accHasAnls.arce__magnitude_unit_type__c = '1';
        accHasAnls.arce__prev_magnitude_unit_type__c = '3';
        upsert accHasAnls;

        final arce__Analysis__c arceVar = [SELECT Id FROM arce__Analysis__c LIMIT 1];
        arceVar.arce__Stage__c = '2';
        upsert arceVar;

        Arc_UtilitysDataTest_tst.createIndustryAnalysisData();

        Test.startTest();
        final Arc_Gen_TabSet_controller.TabsWrapper result = Arc_Gen_TabSet_controller.callTemplateAnalysisJson(accHasAnls.Id);
        system.assertEquals(String.isEmpty(result.gblDescriptionResponse), false, 'The result is not empty');
        Test.stopTest();
    }
    /**
    * --------------------------------------------------------------------------------------
    * @Description - Method that returns the JSON to build tabset component
    * --------------------------------------------------------------------------------------
    * @Author   Mario Humberto Ramirez Lio - mariohumberto.ramirez.contractor@bbva.com
    * @Date     Created: 2019-07-17
    * @param void
    * @return void
    * @example Arc_Gen_TabSet_controller_test.testMultifactor1()
    * --------------------------------------------------------------------------------------
    **/
    @isTest static void testMultifactor1() {
        final arce__Account_has_Analysis__c accHasAnls = [SELECT Id FROM arce__Account_has_Analysis__c LIMIT 1];
        accHasAnls.arce__group_asset_header_type__c = '2';
        accHasAnls.arce__magnitude_unit_type__c = '1';
        accHasAnls.arce__prev_magnitude_unit_type__c = '4';
        upsert accHasAnls;

        final arce__Analysis__c arceVar = [SELECT Id FROM arce__Analysis__c LIMIT 1];
        arceVar.arce__Stage__c = '2';
        upsert arceVar;

        Arc_UtilitysDataTest_tst.createIndustryAnalysisData();

        Test.startTest();
        final Arc_Gen_TabSet_controller.TabsWrapper result = Arc_Gen_TabSet_controller.callTemplateAnalysisJson(accHasAnls.Id);
        system.assertEquals(String.isEmpty(result.gblDescriptionResponse), false, 'The result is not empty');
        Test.stopTest();
    }
    /**
    * --------------------------------------------------------------------------------------
    * @Description - Method that returns the JSON to build tabset component
    * --------------------------------------------------------------------------------------
    * @Author   Mario Humberto Ramirez Lio - mariohumberto.ramirez.contractor@bbva.com
    * @Date     Created: 2019-07-17
    * @param void
    * @return void
    * @example Arc_Gen_TabSet_controller_test.testMultifactor2()
    * --------------------------------------------------------------------------------------
    **/
    @isTest static void testMultifactor2() {
        final arce__Account_has_Analysis__c accHasAnls = [SELECT Id FROM arce__Account_has_Analysis__c LIMIT 1];
        accHasAnls.arce__group_asset_header_type__c = '2';
        accHasAnls.arce__magnitude_unit_type__c = '4';
        accHasAnls.arce__prev_magnitude_unit_type__c = '3';
        upsert accHasAnls;

        final arce__Analysis__c arceVar = [SELECT Id FROM arce__Analysis__c LIMIT 1];
        arceVar.arce__Stage__c = '2';
        upsert arceVar;

        Arc_UtilitysDataTest_tst.createIndustryAnalysisData();

        Test.startTest();
        final Arc_Gen_TabSet_controller.TabsWrapper result = Arc_Gen_TabSet_controller.callTemplateAnalysisJson(accHasAnls.Id);
        system.assertEquals(String.isEmpty(result.gblDescriptionResponse), false, 'The result is not empty');
        Test.stopTest();
    }
    /**
    * --------------------------------------------------------------------------------------
    * @Description - Method that returns the JSON to build tabset component
    * --------------------------------------------------------------------------------------
    * @Author   Mario Humberto Ramirez Lio - mariohumberto.ramirez.contractor@bbva.com
    * @Date     Created: 2019-07-17
    * @param void
    * @return void
    * @example Arc_Gen_TabSet_controller_test.testMultifactor3()
    * --------------------------------------------------------------------------------------
    **/
    @isTest static void testMultifactor3() {
        final arce__Account_has_Analysis__c accHasAnls = [SELECT Id FROM arce__Account_has_Analysis__c LIMIT 1];
        accHasAnls.arce__group_asset_header_type__c = '2';
        accHasAnls.arce__magnitude_unit_type__c = '4';
        accHasAnls.arce__prev_magnitude_unit_type__c = '2';
        upsert accHasAnls;

        final arce__Analysis__c arceVar = [SELECT Id FROM arce__Analysis__c LIMIT 1];
        arceVar.arce__Stage__c = '2';
        upsert arceVar;

        Arc_UtilitysDataTest_tst.createIndustryAnalysisData();

        Test.startTest();
        final Arc_Gen_TabSet_controller.TabsWrapper result = Arc_Gen_TabSet_controller.callTemplateAnalysisJson(accHasAnls.Id);
        system.assertEquals(String.isEmpty(result.gblDescriptionResponse), false, 'The result is not empty');
        Test.stopTest();
    }
    /**
    * --------------------------------------------------------------------------------------
    * @Description - Method that returns the JSON to build tabset component
    * --------------------------------------------------------------------------------------
    * @Author   Mario Humberto Ramirez Lio - mariohumberto.ramirez.contractor@bbva.com
    * @Date     Created: 2019-07-17
    * @param void
    * @return void
    * @example Arc_Gen_TabSet_controller_test.testMultifactor4()
    * --------------------------------------------------------------------------------------
    **/
    @isTest static void testMultifactor4() {
        final arce__Account_has_Analysis__c accHasAnls = [SELECT Id FROM arce__Account_has_Analysis__c LIMIT 1];
        accHasAnls.arce__group_asset_header_type__c = '2';
        accHasAnls.arce__magnitude_unit_type__c = '4';
        accHasAnls.arce__prev_magnitude_unit_type__c = '1';
        upsert accHasAnls;

        final arce__Analysis__c arceVar = [SELECT Id FROM arce__Analysis__c LIMIT 1];
        arceVar.arce__Stage__c = '2';
        upsert arceVar;

        Arc_UtilitysDataTest_tst.createIndustryAnalysisData();

        Test.startTest();
        final Arc_Gen_TabSet_controller.TabsWrapper result = Arc_Gen_TabSet_controller.callTemplateAnalysisJson(accHasAnls.Id);
        system.assertEquals(String.isEmpty(result.gblDescriptionResponse), false, 'The result is not empty');
        Test.stopTest();
    }
    /**
    * --------------------------------------------------------------------------------------
    * @Description - Method that returns the JSON to build tabset component
    * --------------------------------------------------------------------------------------
    * @Author   Mario Humberto Ramirez Lio - mariohumberto.ramirez.contractor@bbva.com
    * @Date     Created: 2019-07-17
    * @param void
    * @return void
    * @example Arc_Gen_TabSet_controller_test.testMultifactor5()
    * --------------------------------------------------------------------------------------
    **/
    @isTest static void testMultifactor5() {
        final arce__Account_has_Analysis__c accHasAnls = [SELECT Id FROM arce__Account_has_Analysis__c LIMIT 1];
        accHasAnls.arce__group_asset_header_type__c = '2';
        accHasAnls.arce__magnitude_unit_type__c = '1';
        accHasAnls.arce__prev_magnitude_unit_type__c = null;
        upsert accHasAnls;

        final arce__Analysis__c arceVar = [SELECT Id FROM arce__Analysis__c LIMIT 1];
        arceVar.arce__Stage__c = '2';
        upsert arceVar;

        Arc_UtilitysDataTest_tst.createIndustryAnalysisData();

        Test.startTest();
        final Arc_Gen_TabSet_controller.TabsWrapper result = Arc_Gen_TabSet_controller.callTemplateAnalysisJson(accHasAnls.Id);
        system.assertEquals(String.isEmpty(result.gblDescriptionResponse), false, 'The result is not empty');
        Test.stopTest();
    }
    /**
    * --------------------------------------------------------------------------------------
    * @Description - Method that returns the JSON to build tabset component
    * --------------------------------------------------------------------------------------
    * @Author   Mario Humberto Ramirez Lio - mariohumberto.ramirez.contractor@bbva.com
    * @Date     Created: 2019-07-17
    * @param void
    * @return void
    * @example Arc_Gen_TabSet_controller_test.testUnitConversorError()
    * --------------------------------------------------------------------------------------
    **/
    @isTest static void testUnitConversorError() {
        Test.startTest();
        final arce.Arc_Gen_GenericUtilities.ConversionWrapper wrapper = new arce.Arc_Gen_GenericUtilities.ConversionWrapper();
        final Map<String, Object> result = arce.Arc_Gen_GenericUtilities.convertUnits(wrapper);
        system.assertEquals(result.get('status'), 'Error', 'there was a problem in the call to the conversor');
        Test.stopTest();
    }
    /**
    * --------------------------------------------------------------------------------------
    * @Description - Method that tests the units conversor in the group chrome
    * --------------------------------------------------------------------------------------
    * @Author   Eduardo Efraín Hernández Rendón - eduardoefrain.hernandez.contractor@bbva.com
    * @Date     Created: 2020-03-30
    * @param void
    * @return void
    * @example Arc_Gen_TabSet_controller_test.testUnitConversorError()
    * --------------------------------------------------------------------------------------
    **/
    @isTest static void convInGroupDiffUnit() {
        final arce__Account_has_Analysis__c accHasAnls = [SELECT Id FROM arce__Account_has_Analysis__c WHERE arce__group_asset_header_type__c = '1' LIMIT 1];
        accHasAnls.arce__magnitude_unit_type__c = '1';
        accHasAnls.arce__prev_magnitude_unit_type__c = '2';
        update accHasAnls;
        Test.startTest();
        final Arc_Gen_TabSet_controller.TabsWrapper res = Arc_Gen_TabSet_controller.callTemplateAnalysisJson(accHasAnls.Id);
        system.assertEquals(res.changeStatus, true, 'Operation success');
        Test.stopTest();
    }
    /**
    * --------------------------------------------------------------------------------------
    * @Description - Method that tests the units conversor in the group chrome
    * --------------------------------------------------------------------------------------
    * @Author   Eduardo Efraín Hernández Rendón - eduardoefrain.hernandez.contractor@bbva.com
    * @Date     Created: 2020-03-30
    * @param void
    * @return void
    * @example Arc_Gen_TabSet_controller_test.testUnitConversorError()
    * --------------------------------------------------------------------------------------
    **/
    @isTest static void convInGroupSameUnit() {
        final arce__Account_has_Analysis__c accHasAnls = [SELECT Id FROM arce__Account_has_Analysis__c WHERE arce__group_asset_header_type__c = '1' LIMIT 1];
        accHasAnls.arce__magnitude_unit_type__c = '1';
        accHasAnls.arce__prev_magnitude_unit_type__c = '1';
        update accHasAnls;
        Test.startTest();
        final Arc_Gen_TabSet_controller.TabsWrapper res = Arc_Gen_TabSet_controller.callTemplateAnalysisJson(accHasAnls.Id);
        system.assertEquals(res.changeStatus, true, 'Operation success');
        Test.stopTest();
    }
    /**
    * --------------------------------------------------------------------------------------
    * @Description Test method for void constructor
    * --------------------------------------------------------------------------------------
    * @Author   Mario Humberto Ramirez Lio  mariohumberto.ramirez.contractor@bbva.com
    * @Date     Created: 2019-07-17
    * @param void
    * @return void
    * @example Arc_Gen_TabSet_controller_test.testContructorController()
    * --------------------------------------------------------------------------------------
    **/
    @isTest static void testContructorController() {
        Test.startTest();
        final Arc_Gen_TabSet_controller controller = new Arc_Gen_TabSet_controller();
        system.assertEquals(controller, controller, 'The test to void contructor was successfull');
        Test.stopTest();
    }
    /**
    * --------------------------------------------------------------------------------------
    * @Description Test method for void contructor
    * --------------------------------------------------------------------------------------
    * @Author   Mario Humberto Ramirez Lio  mariohumberto.ramirez.contractor@bbva.com
    * @Date     Created: 2019-07-17
    * @param void
    * @return void
    * @example Arc_Gen_TabSet_controller_test.testContructorService()
    * --------------------------------------------------------------------------------------
    **/
    @isTest static void testContructorService() {
        Test.startTest();
        final Arc_Gen_TabSet_service service = new Arc_Gen_TabSet_service();
        system.assertEquals(service, service, 'The test to void contructor was successfull');
        Test.stopTest();
    }
    /**
    * --------------------------------------------------------------------------------------
    * @Description Test method for void contructor
    * --------------------------------------------------------------------------------------
    * @Author   Mario Humberto Ramirez Lio  mariohumberto.ramirez.contractor@bbva.com
    * @Date     Created: 2019-07-17
    * @param void
    * @return void
    * @example Arc_Gen_TabSet_controller_test.testContructorHelper()
    * --------------------------------------------------------------------------------------
    **/
    @isTest static void testContructorHelper() {
        Test.startTest();
        final Arc_Gen_TabsetService_Helper help = new Arc_Gen_TabsetService_Helper();
        system.assertEquals(help, help, 'The test to void contructor was successfull');
        Test.stopTest();
    }
    /**
    * --------------------------------------------------------------------------------------
    * @Description Test method for void contructor
    * --------------------------------------------------------------------------------------
    * @Author   Mario Humberto Ramirez Lio  mariohumberto.ramirez.contractor@bbva.com
    * @Date     Created: 2019-07-29
    * @param void
    * @return void
    * @example Arc_Gen_TabSet_controller_test.testContructorHelper()
    * --------------------------------------------------------------------------------------
    **/
    @isTest static void testContructorData() {
        Test.startTest();
        final arce.Arc_Gen_ArceAnalysis_Data data = new arce.Arc_Gen_ArceAnalysis_Data();
        system.assertEquals(data, data, 'The test to void contructor was successfull');
        Test.stopTest();
    }
    /**
    * --------------------------------------------------------------------------------------
    * @Description Test method for void contructor
    * --------------------------------------------------------------------------------------
    * @Author   Mario Humberto Ramirez Lio  mariohumberto.ramirez.contractor@bbva.com
    * @Date     Created: 2019-07-29
    * @param void
    * @return void
    * @example Arc_Gen_TabSet_controller_test.testContructorData2()
    * --------------------------------------------------------------------------------------
    **/
    @isTest static void testContructorData2() {
        Test.startTest();
        final arce.Arc_Gen_AccHasAnalysis_Data data = new arce.Arc_Gen_AccHasAnalysis_Data();
        system.assertEquals(data, data, 'The test to void contructor was successfull');
        Test.stopTest();
    }
    /**
    * --------------------------------------------------------------------------------------
    * @Description Test method for void contructor
    * --------------------------------------------------------------------------------------
    * @Author   Mario Humberto Ramirez Lio  mariohumberto.ramirez.contractor@bbva.com
    * @Date     Created: 2019-08-09
    * @param void
    * @return void
    * @example Arc_Gen_TabSet_controller_test.testContructorSector()
    * --------------------------------------------------------------------------------------
    **/
    @isTest static void testContructorSector() {
        Test.startTest();
        final Arc_Gen_Sector_Data data = new Arc_Gen_Sector_Data();
        system.assertEquals(data, data, 'The test to the void contructor was successfull');
        Test.stopTest();
    }
    /**
    * --------------------------------------------------------------------------------------
    * @Description Test method to testing the automated fields for the group chrome
    * --------------------------------------------------------------------------------------
    * @Author   Eduardo Efraín Hernández Rendón - eduardoefrain.hernandez.contractor@bbva.com
    * @Date     Created: 2020-29-04
    * @param void
    * @return void
    * @example Arc_Gen_TabSet_controller_test.automatedGroupFields()
    * --------------------------------------------------------------------------------------
    **/
    @isTest static void automatedGroupFields() {
        final arce__Account_has_Analysis__c accHasAnls = [SELECT Id,arce__Analysis__c,arce__group_asset_header_type__c,arce__capital_provision_per__c,arce__participant_srty_age_number__c,arce__customer_qualitative_type__c FROM arce__Account_has_Analysis__c WHERE arce__group_asset_header_type__c = '1' LIMIT 1];
        Test.startTest();
        final Map<String, Object> response =(Map<String, Object>)JSON.deserializeUntyped(Arc_Gen_TabSet_controller.updateGroupFields(accHasAnls));
        system.assertEquals('true', response.get('status'), 'The operation has a true status');
        Test.stopTest();
    }
    /**
    * --------------------------------------------------------------------------------------
    * @Description Test errors to the automated fields for the group chrome
    * --------------------------------------------------------------------------------------
    * @Author   Eduardo Efraín Hernández Rendón - eduardoefrain.hernandez.contractor@bbva.com
    * @Date     Created: 2020-29-04
    * @param void
    * @return void
    * @example Arc_Gen_TabSet_controller_test.automatedGroupFieldsError()
    * --------------------------------------------------------------------------------------
    **/
    @isTest static void automatedGroupFieldsError() {
        final arce__Account_has_Analysis__c accHasAnls = new arce__Account_has_Analysis__c();
        String response;
        Test.startTest();
        try {
            Arc_Gen_TabSet_controller.updateGroupFields(accHasAnls);
        } catch(AuraHandledException ex) {
            response = ex.getMessage();
        }
        system.assertEquals(System.Label.Arc_Gen_empty_table, response, 'Operation Error');
        Test.stopTest();
    }
    /**
    * --------------------------------------------------------------------------------------
    * @Description Test method to get account has analysis data
    * --------------------------------------------------------------------------------------
    * @Author   Eduardo Efraín Hernández Rendón - eduardoefrain.hernandez.contractor@bbva.com
    * @Date     Created: 2020-29-04
    * @param void
    * @return void
    * @example Arc_Gen_TabSet_controller_test.testGettingAccHasAn()
    * --------------------------------------------------------------------------------------
    **/
    @isTest static void testGettingAccHasAn() {
        final arce__Account_has_Analysis__c accHasAnls = [SELECT Id,arce__Analysis__c,arce__group_asset_header_type__c,arce__capital_provision_per__c,arce__participant_srty_age_number__c,arce__customer_qualitative_type__c FROM arce__Account_has_Analysis__c WHERE arce__group_asset_header_type__c = '1' LIMIT 1];
        Test.startTest();
        final arce__Account_has_Analysis__c response = Arc_Gen_TabSet_controller.getAccHasAnalysis(accHasAnls.Id);
        system.assertEquals(response.Id, accHasAnls.Id, 'It gets the data of the account has analysis');
        Test.stopTest();
    }
    /**
    * --------------------------------------------------------------------------------------
    * @Description testing an error occurred when get account has analysis data
    * --------------------------------------------------------------------------------------
    * @Author   Eduardo Efraín Hernández Rendón - eduardoefrain.hernandez.contractor@bbva.com
    * @Date     Created: 2020-29-04
    * @param void
    * @return void
    * @example Arc_Gen_TabSet_controller_test.gettingAccHasAnError()
    * --------------------------------------------------------------------------------------
    **/
    @isTest static void gettingAccHasAnError() {
        final arce__Account_has_Analysis__c accHasAnls = [SELECT Id,arce__Analysis__c,arce__group_asset_header_type__c,arce__capital_provision_per__c,arce__participant_srty_age_number__c,arce__customer_qualitative_type__c FROM arce__Account_has_Analysis__c WHERE arce__group_asset_header_type__c = '1' LIMIT 1];
        String response;
        Test.startTest();
        try {
            Arc_Gen_TabSet_controller.getAccHasAnalysis(accHasAnls.arce__Analysis__c);
        } catch(AuraHandledException ex) {
            response = ex.getMessage();
        }
        system.assertEquals(System.Label.Arc_Gen_empty_table, response, 'Operation Error');
        Test.stopTest();
    }
    /**
    * --------------------------------------------------------------------------------------
    * @Description Test method for void contructor
    * --------------------------------------------------------------------------------------
    * @Author   Eduardo Efraín Hernández Rendón - eduardoefrain.hernandez.contractor@bbva.com
    * @Date     Created: 2020-29-04
    * @param void
    * @return void
    * @example Arc_Gen_TabSet_controller_test.testContructorGroupFields()
    * --------------------------------------------------------------------------------------
    **/
    @isTest static void testContructorGroupFields() {
        Test.startTest();
        final Arc_Gen_SetAutomatedFileds_Service data = new Arc_Gen_SetAutomatedFileds_Service();
        system.assertEquals(data, data, 'The test to the void contructor was successfull');
        Test.stopTest();
    }
}