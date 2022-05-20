/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_Account_Interface
* @Author   juanignacio.hita.contractor@bbva.com
* @Date     Created: 15/11/2019
* @Group    ARCE
* -----------------------------------------------------------------------------------------------
* @Description Interface "Arc_Gen_Account_Interface"
* -----------------------------------------------------------------------------------------------
* @Changes
*
* |2019-11-15 juanignacio.hita.contractor@bbva.com
*             Interface creation.
* |2019-11-29 manuelhugo.castillo.contractor@bbva.com
*             Add methods 'getAccountByAccNumber','accountsForLookup','getClientsByGroup'
* |2020-01-15 javier.soto.carrascosa@bbva.com
*             Add methods accountUpdate, createGroup
* |2020-04-12 javier.soto.carrascosa@bbva.com
*             Add support to retrieve local field from risk assessment location
* |2020-09-15 javier.soto.carrascosa@bbva.com
*             Remove unused method
* -----------------------------------------------------------------------------------------------
*/
global interface Arc_Gen_Account_Interface {
    /**
    *
    * @Description : Method 'getAccountInfoById' retrieves information of an account given its id
    */
    Map<Id, Arc_Gen_Account_Wrapper> getAccountInfoById(List<Id> listAccountId);
    /**
    *
    * @Description : Method 'getAccountByAccNumber' retrieves information of an account given its Account Number
    */
    Map<String, Arc_Gen_Account_Wrapper> getAccountByAccNumber(List<String> listAccountNum);
    /**
    *
    * @Description : Method 'accountsForLookup' retrieves information of an account given its search Word
    */
    List<Arc_Gen_Account_Wrapper> accountsForLookup(String searchWord);
    /**
    *
    * @Description : Method 'accountUpdate' updates account information from Id and a Map of field name and value
    */
    Arc_Gen_ServiceAndSaveResponse accountUpdate (Map<Id, Map<String,Object>> lstAccUp);
    /**
    *
    * @Description : Method 'createGroup' create a Group Account from a Map of field name and value
    */
    Arc_Gen_ServiceAndSaveResponse createGroup (Map<String,Object> accAttr);
    /**
    *
    * @Description : Method 'getRatingGCPByAccountNumber' retrieves information of an FinancialStatement given its Account Number
    */
    Map<String, arce__Financial_Statements__c> getRatingGCPByAccountNumber(List<String> accNumber);
}