/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_User_Locator
* @Author   eduardoefrain.hernandez.contractor@bbva.com
* @Date     Created: 28/06/2019
* @Group    ARCE
* -----------------------------------------------------------------------------------------------
* @Description Data class Arc_Gen_User_Locator
* -----------------------------------------------------------------------------------------------
* @Changes
*
* |2019-06-28 eduardoefrain.hernandez.contractor@bbva.com
*             Class creation.
* |2019-06-28 luisruben.quinto.munoz@bbva.com
*             Documentation
* |2019-09-25 mariohumberto.ramirez.contractor@bbva.com
*             Added new method getUsers
* |2019-10-10 eduardoefrain.hernandez.contractor@bbva.com
*             Added federation identifier
* |2019-11-14 juanignacio.hita.contractor@bbva.com
*             Added the implementation interface and search of the interface configurated in the metadata
*             and changed name of the class
* |2020-06-30 javier.soto.carrascosa@bbva.com
*             Change getAccLocatorClass method, enforce GBL class execution in tests
* -----------------------------------------------------------------------------------------------
*/
global without sharing class Arc_Gen_User_Locator implements Arc_Gen_User_Interface {
    /**
    *-------------------------------------------------------------------------------
    * @description  Method that retrieves full user information
    --------------------------------------------------------------------------------
    * @author javier.soto.carrascosa@bbva.com
    * @date 2019-07-15
    * @param Id userId
    * @return wrapper user data
    * @example global static WrapperUser getUserInfo(Id userId) {
    **/
    global static Arc_Gen_User_Wrapper getUserInfo(Id userId) {
        String classLocator = getClassLocaleUser();
        System.Type objType = Type.forName(classLocator);
        Arc_Gen_User_Wrapper wrapper = new Arc_Gen_User_Wrapper();
        try {
            Arc_Gen_User_Interface classLocatorUser = (Arc_Gen_User_Interface)objType.newInstance();
            wrapper = classLocatorUser.getUserInfo(userId);
        } catch(Exception ex) {
            System.debug(ex.getMessage());
        }
        return wrapper;
    }
    /**
    * ---------------------------------------------------------------------------------------------------
    * @Description - Method to find users
    * ---------------------------------------------------------------------------------------------------
    * @Author   Angel Fuertes Gomez - angel.fuertes2@bbva.com / BBVA DWP
    * @Date     Created: 2019-05-04
    * @param inputTerm - String to find users
    * @return a list users
    * @example getUsers(inputTerm)
    * ---------------------------------------------------------------------------------------------------
    **/
    global static List<Arc_Gen_User_Wrapper> getUsers(String inputTerm) {
        String classLocator = getClassLocaleUser();
        System.Type objType = Type.forName(classLocator);
        List<Arc_Gen_User_Wrapper> wrapper = new List<Arc_Gen_User_Wrapper>();
        try {
            Arc_Gen_User_Interface classLocatorUser = (Arc_Gen_User_Interface)objType.newInstance();
            wrapper = classLocatorUser.getUsers(inputTerm);
        } catch(Exception ex) {
            System.debug(ex.getMessage());
        }
        return wrapper;
    }
    /**
    * ---------------------------------------------------------------------------------------------------
    * @Description - Method to find the name class from the metadata config
    * ---------------------------------------------------------------------------------------------------
    * @Author   juanignacio.hita.contractor@bbva.com
    * @Date     Created: 2019-11-14
    * @return   String with the name of the class
    * @example getClassLocaleUser()
    * ---------------------------------------------------------------------------------------------------
    **/
    private static String getClassLocaleUser() {
        String interfaceName;
        interfaceName = Test.isRunningTest() ? 'UserInterfaceMock' : 'UserInterface';
        List<Arce_Config__mdt> lstConfig = [SELECT Id, Config_Name__c, Value1__c FROM Arce_Config__mdt WHERE Config_Name__c =: interfaceName];
        if(lstConfig.isEmpty()) {
            return null;
        } else {
            return lstConfig.get(0).Value1__c;
        }
    }
}