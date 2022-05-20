/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_FinancialStatements_locator
* @Author   javier.soto.carrascosa@bbva.com
* @Date     Created: 2019-09-11
* @Group    ARCE
* ------------------------------------------------------------------------------------------------------
* @Description Class that obtains the data of Financial Statements
* ------------------------------------------------------------------------------------------------------
* @Changes
*
* |2019-09-11 javier.soto.carrascosa@bbva.com
*             Class creation.
* |2020-13-01 mariohumberto.ramirez.contractor@bbva.com
*             Added new methods getEmptyFFSS and setFFSS
*             Fix comments
* |2020-04-14 mariohumberto.ramirez.contractor@bbva.com
*             Added new methods getPreviousFFSS
* |2020-06-29 mariohumberto.ramirez.contractor@bbva.com
*             Deleted deprecated getPreviousFFSS method
* |2020-06-29 saimassimilianno.jordana.contractor@bbva.com
*             field added to getEmptyFFSS query.
* -------------------------------------------------------------------------------------------------------
**/
@SuppressWarnings('sf:UseSingleton')
global without sharing class Arc_Gen_FinancialStatements_locator {
    /**
    * ----------------------------------------------------------------------------------------------------
    * @Description Void Constructor to avoid warning in sonar qube
    * ----------------------------------------------------------------------------------------------------
    * @author javier.soto.carrascosa@bbva.com
    * @date 2019-09-11
    * @param void
    * @return void
    * @example Arc_Gen_FinancialStatements_locator locator = new Arc_Gen_FinancialStatements_locator()
    * ----------------------------------------------------------------------------------------------------
    **/
    @TestVisible
    global Arc_Gen_FinancialStatements_locator() { //NOSONAR
    }
/**
*-------------------------------------------------------------------------------
* @description  Get Financial Statements Info from Id
*--------------------------------------------------------------------------------
* @author javier.soto.carrascosa@bbva.com
* @date 09/11/2019 14:50:32
* @param List<Id>
* @return List<arce__Financial_Statements__c>
* @example global List<arce__Financial_Statements__c> getFSInfo(List<Id> listFS)
*--------------------------------------------------------------------------------
**/
    global static List<arce__Financial_Statements__c> getFSInfo(List<Id> listFS) {
        List<arce__Financial_Statements__c> listFSInfo = new list<arce__Financial_Statements__c>([SELECT Id,
        arce__economic_month_info_number__c,arce__financial_statement_end_date__c,arce__ffss_certification_type__c
        FROM arce__Financial_Statements__c
        WHERE Id =: listFS]);
        return listFSInfo;
    }
    /**
    *--------------------------------------------------------------------------------
    * @Description  method  that gets empty ffss
    *--------------------------------------------------------------------------------
    * @Author   Mario Humberto Ramirez Lio  mariohumberto.ramirez.contractor@bbva.com
    * @Date     Created: 2020-13-01
    * @return   arce__Financial_Statements__c
    * @example  getEmptyFFSS()
    * -------------------------------------------------------------------------------
    */
    global static List<arce__Financial_Statements__c> getEmptyFFSS() {
        return [SELECT Id, arce__financial_statement_id__c FROM arce__Financial_Statements__c WHERE arce__financial_statement_id__c = 'dummyFFSS'];
    }
    /**
    *--------------------------------------------------------------------------------
    * @Description  method  that insert the dummy ffss
    *--------------------------------------------------------------------------------
    * @Author   Mario Humberto Ramirez Lio  mariohumberto.ramirez.contractor@bbva.com
    * @Date     Created: 2020-13-01
    * @return   arce__Financial_Statements__c
    * @example  getEmptyFFSS()
    * -------------------------------------------------------------------------------
    */
    global static arce__Financial_Statements__c setFFSS() {
        arce__Financial_Statements__c ffss = new arce__Financial_Statements__c(arce__financial_statement_id__c = 'dummyFFSS');
        insert ffss;
        return ffss;
    }
    /**
    *--------------------------------------------------------------------------------
    * @Description  Method  that insert the ffss with Ahas Name
    *--------------------------------------------------------------------------------
    * @Author   Sai Jordana  saimassimilianno.jordana.contractor@bbva.com
    * @Date     Created: 2021-02-24
    * @return   arce__Financial_Statements__c
    * @example  setFFSSWAhasName()
    * -------------------------------------------------------------------------------
    */
    global static arce__Financial_Statements__c setFFSSWAhasName(String ahasName) {
        arce__Financial_Statements__c ffss = new arce__Financial_Statements__c(arce__financial_statement_id__c = ahasName);
        insert ffss;
        return ffss;
    }
}