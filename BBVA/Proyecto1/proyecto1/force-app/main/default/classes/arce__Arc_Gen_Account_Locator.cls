/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_Account_Locator
* @Author   juanignacio.hita.contractor@bbva.com
* @Date     Created: 15/11/2019
* @Group    ARCE
* -----------------------------------------------------------------------------------------------
* @Description Class "Arc_Gen_Account_Locator"
* -----------------------------------------------------------------------------------------------
* @Changes
*
* |2019-11-15 juanignacio.hita.contractor@bbva.com
*             Class creation
* |2019-11-29 manuelhugo.castillo.contractor@bbva.com
*             Add methods 'getAccountByAccNumber','accountsForLookup','getClientsByGroup'
* |2020-01-15 javier.soto.carrascosa@bbva.com
*             Add methods 'accountUpdate', 'createGroup'
* |2020-04-12 javier.soto.carrascosa@bbva.com
*             Add support to retrieve local field from risk assessment location
* |2020-06-30 javier.soto.carrascosa@bbva.com
*             Change getAccLocatorClass method, enforce GBL class execution in tests
* |2020-09-15 javier.soto.carrascosa@bbva.com
*             Remove unused method
* |2021-03-17 alexander.munguia.contractor@bbva.com
*             method getRatingGCPByAccountNumber has been created
* -----------------------------------------------------------------------------------------------
*/
global class Arc_Gen_Account_Locator implements Arc_Gen_Account_Interface {
    /**
    *-------------------------------------------------------------------------------
    * @description  Contrcutor to avoid major
    --------------------------------------------------------------------------------
    * @author manuelhugo.castillo.contractor@bbva.com
    * @date 2019-11-15
    * @example Arc_GBL_Account_Locator()
    **/
    @TestVisible
    private Arc_Gen_Account_Locator() {
    }
    /**
    *-------------------------------------------------------------------------------
    * @description  Method "getAccountInfoById" that retrieves full user information from a list of account Id
    --------------------------------------------------------------------------------
    * @author juanignacio.hita.contractor@bbva.com
    * @date 2019-11-15
    * @param List<Id> listAccountId
    * @return List with Account Wrappers
    * @example List<Id, Arc_Gen_Account_Wrapper> list = Arc_Gen_Account_Locator.getAccountInfoById(listAccountId);
    **/
    global static Map<Id, Arc_Gen_Account_Wrapper> getAccountInfoById(List<Id> listAccountId) {
        Map<Id, Arc_Gen_Account_Wrapper> lstWrapper = new Map<Id, Arc_Gen_Account_Wrapper>();
        Arc_Gen_Account_Interface classLocatorAcc = getAccLocatorClass();
        if (classLocatorAcc != null) {
            try {
                lstWrapper = classLocatorAcc.getAccountInfoById(listAccountId);
            } catch(Exception ex) {
                System.debug(ex.getMessage());
            }
        }
        return lstWrapper;
    }
    /**
    *-------------------------------------------------------------------------------
    * @description  Method "getAccountByAccNumber" gets all account fields filtered by AccountNumber
    --------------------------------------------------------------------------------
    * @author manuelhugo.castillo.contractor@bbva.com
    * @date 2019-11-25
    * @param List<String> listAccountNum
    * @return Map with Account Wrappers
    * @example Map<Id, Arc_Gen_Account_Wrapper> list = Arc_Gen_Account_Locator.getAccountByAccNumber(listAccountNum);
    **/
    global static Map<String, Arc_Gen_Account_Wrapper> getAccountByAccNumber(List<String> listAccountNum) {
        Map<String, Arc_Gen_Account_Wrapper> lstWrapper = new Map<String, Arc_Gen_Account_Wrapper>();
        Arc_Gen_Account_Interface classLocatorAcc = getAccLocatorClass();
        if (classLocatorAcc != null) {
            try {
                lstWrapper = classLocatorAcc.getAccountByAccNumber(listAccountNum);
            } catch(Exception ex) {
                System.debug(ex.getMessage());
            }
        }
        return lstWrapper;
    }
    /**
    *-------------------------------------------------------------------------------
    * @description  Method "accountsForLookup" gets account wrapper filtered by searchWord
    --------------------------------------------------------------------------------
    * @author manuelhugo.castillo.contractor@bbva.com
    * @date 2019-11-25
    * @param String searchWord
    * @return Map with Account Wrappers
    * @example Map<Id, Arc_Gen_Account_Wrapper> list = Arc_Gen_Account_Locator.accountsForLookup(String searchWord);
    **/
    global static List<Arc_Gen_Account_Wrapper> accountsForLookup(String searchWord) {
        List<Arc_Gen_Account_Wrapper> lstWrapper = new List<Arc_Gen_Account_Wrapper>();
        Arc_Gen_Account_Interface classLocatorAcc = getAccLocatorClass();
        if (classLocatorAcc != null) {
            try {
                lstWrapper = classLocatorAcc.accountsForLookup(searchWord);
            } catch(Exception ex) {
                System.debug(ex.getMessage());
            }
        }
        return lstWrapper;
    }
    /**
    *-------------------------------------------------------------------------------
    * @description  Method "accountUpdate" updates Account attributes
    --------------------------------------------------------------------------------
    * @author javier.soto.carrascosa@bbva.com
    * @date 2020-01-15
    * @param Map<Id, Map<String,String>> lstAccUp
    * @return Arc_Gen_ServiceAndSaveResponse
    * @example Arc_Gen_ServiceAndSaveResponse accountUpdate(Map<Id, Map<String,String>> lstAccUp)
    **/
    global static Arc_Gen_ServiceAndSaveResponse accountUpdate(Map<Id, Map<String,Object>> lstAccUp) {
        Arc_Gen_ServiceAndSaveResponse result = new Arc_Gen_ServiceAndSaveResponse();
        Arc_Gen_Account_Interface classLocatorAcc = getAccLocatorClass();
        if (classLocatorAcc != null) {
            try {
                result = classLocatorAcc.accountUpdate(lstAccUp);
            } catch(Exception ex) {
                result.saveStatus = 'false';
                result.saveMessage = ex.getMessage();
            }
        }
        return result;
    }
    /**
    *-------------------------------------------------------------------------------
    * @description  Method "createGroup" create group account
    --------------------------------------------------------------------------------
    * @author javier.soto.carrascosa@bbva.com
    * @date 2020-01-15
    * @param Map<String,String> accAttr
    * @return Arc_Gen_ServiceAndSaveResponse
    * @example Arc_Gen_ServiceAndSaveResponse createGroup(Map<String,String> accAttr)
    **/
    global static Arc_Gen_ServiceAndSaveResponse createGroup(Map<String,Object> accAttr) {
        Arc_Gen_ServiceAndSaveResponse result = new Arc_Gen_ServiceAndSaveResponse();
        Arc_Gen_Account_Interface classLocatorAcc = getAccLocatorClass();
        if (classLocatorAcc != null) {
            try {
                result = classLocatorAcc.createGroup(accAttr);
            } catch(Exception ex) {
                result.saveStatus = 'false';
                result.saveMessage = ex.getMessage();
            }
        }
        return result;
    }
    /**
    *-------------------------------------------------------------------------------
    * @description  Method "getRatingGCPByAccountNumber" gets account wrapper filtered by searchWord
    --------------------------------------------------------------------------------
    * @author alexander.munguia.contractor@bbva.com
    * @date 2021-03-17
    * @param List<String> accNumber
    * @return Map with Financial Statement
    * @example Map<String, arce__Financial_Statements__c> list = Arc_Gen_Account_Locator.getRatingGCPByAccountNumber(List<String> accNumber);
    **/
    global static Map<String, arce__Financial_Statements__c> getRatingGCPByAccountNumber(List<String> accNumber) {
        Map<String, arce__Financial_Statements__c> result = new Map<String, arce__Financial_Statements__c>();
        final Arc_Gen_Account_Interface classLocatorAcc = getAccLocatorClass();
        if (classLocatorAcc != null) {
            try {
                result = classLocatorAcc.getRatingGCPByAccountNumber(accNumber);
            } catch(Exception ex) {
                System.debug(ex.getMessage());
            }
        }
        return result;
    }
    /**
    * ---------------------------------------------------------------------------------------------------
    * @Description - Method "getAccLocatorClass" to find the class with the interface Arc_Gen_Account_Interface
    * ---------------------------------------------------------------------------------------------------
    * @Author   juanignacio.hita.contractor@bbva.com
    * @Date     Created: 2019-11-14
    * @return   Arc_Gen_Account_Interface
    * @example Arc_Gen_Account_Interface accInterface = getAccLocatorClass(nameConfig)
    * ---------------------------------------------------------------------------------------------------
    **/
    global static Arc_Gen_Account_Interface getAccLocatorClass() {
        String interfaceName;
        interfaceName = Test.isRunningTest() ? 'AccountInterfaceMock' : 'AccountInterface';
        List<Arce_Config__mdt> lstArceConfig = Arc_Gen_Arceconfigs_locator.getConfigurationInfo(interfaceName);
        System.Type objType = Type.forName(lstArceConfig.get(0).Value1__c);
        return (Arc_Gen_Account_Interface)objType.newInstance();
    }
}