/*------------------------------------------------------------------
*Author:        bbva.com developers
*Project:      	ARCE - BBVA Bancomer
*Description:   Test class for Arc_Gen_User_Locator
*_______________________________________________________________________________________
*Versión    Date           	Author                              Description
*1.0        14/09/2020      ARCE's TEAM                         Created.
-----------------------------------------------------------------------------------------*/
@isTest
global with sharing class Arc_Gen_User_Locator_Test {
    /**
    *-------------------------------------------------------------------------------
    * @Description Test Arc_Gen_User_Locator.getUserInfo
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-09-14
    *--------------------------------------------------------------------------------
    **/
    @isTest
    global static void getUserInfoTest() {
        Test.startTest();
        final Id userId = UserInfo.getUserId();
        final Arc_Gen_User_Wrapper wrapper = Arc_Gen_User_Locator.getUserInfo(userId);
        final Arc_Gen_User_Wrapper wrapperNull = new Arc_Gen_User_Wrapper();
        System.assertNotEquals(wrapperNull, wrapper, 'Error getUserInfoTest');
        Test.stopTest();
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Test Arc_Gen_User_Locator.getUsers
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-09-14
    *--------------------------------------------------------------------------------
    **/
    @isTest
    global static void getUsersTest() {
        Test.startTest();
        final String inputTerm = 'Not existent';
        final List<Arc_Gen_User_Wrapper>  wrapper = Arc_Gen_User_Locator.getUsers(inputTerm);
        System.assertEquals(true, wrapper.isEmpty(), 'Error getUsersTest');
        Test.stopTest();
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Test Arc_Gen_User_Wrapper
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-09-14
    *--------------------------------------------------------------------------------
    **/
    @isTest
    global static void createWrapperUser() {
        Test.startTest();
        final Arc_Gen_User_Wrapper userWrapper = new Arc_Gen_User_Wrapper();
        final User usuario = new User();
        userWrapper.userBasicInfo = usuario;
        userWrapper.branchId = '';
        userWrapper.branchText = '';
        userWrapper.branchlevel = '';
        userWrapper.businessAgentId = '';
        userWrapper.profileName = '';
        userWrapper.ambitUser = '';
        userWrapper.cr = '';
        userWrapper.officeName = '';
        System.assertEquals('', userWrapper.ambitUser, 'Error createWrapperUser');
        Test.stopTest();
    }

}