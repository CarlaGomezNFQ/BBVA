/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_FinStatDetails_Service
* @Author   mariohumberto.ramirez.contractor@bbva.com
* @Date     Created: 19/12/2019
* @Group    ARCE
* -----------------------------------------------------------------------------------------------
* @Description Service class for Arc_Gen_ModalFinanStatemController
* -----------------------------------------------------------------------------------------------
* @Changes
*
* |2019-12-19 mariohumberto.ramirez.contractor@bbva.com
*             Class creation.
* |2020-09-23 saimassimilianno.jordana.contractor@bbva.com
*             Added arce. namespace to all classes that are now in the arce-dependencies package
* -----------------------------------------------------------------------------------------------
*/
public with sharing class Arc_Gen_FinStatDetails_Service {
    /**
    * ----------------------------------------------------------------------------------------------------
    * @Description Void Constructor to avoid warning in sonar qube
    * ----------------------------------------------------------------------------------------------------
    * @Author   Mario Humberto Ramirez Lio  mariohumberto.ramirez.contractor@bbva.com
    * @Date     Created: 2019-12-19
    * @param void
    * @return void
    * @example Arc_Gen_FinStatDetails_Service service = new Arc_Gen_FinStatDetails_Service()
    * ----------------------------------------------------------------------------------------------------
    **/
    @TestVisible
    private Arc_Gen_FinStatDetails_Service() {

    }
    /**
    *----------------------------------------------------------------------------------------------------------------------------------------
    * @Description method that consult the financial statement details service and set the number of employess of the subsidiary
    *----------------------------------------------------------------------------------------------------------------------------------------
    * @Author mariohumberto.ramirez.contractor@bbva.com
    * @Date Created: 2019-12-19
    * @param recordId - Id of the account_has_analysis
    * @param fsServiceId - Id of the financial statement
    * @return boolean
    * @example setNumberOfEmployes(recordId, recordId) {
    * ----------------------------------------------------------------------------------------------------------------------------------------
    **/
    public static Arc_Gen_ModalFinanStatemController.FinancialDetailsWrapper setNumberOfEmployees(String recordId,String fsServiceId) {
        final Arc_Gen_ModalFinanStatemController.FinancialDetailsWrapper response =  Arc_Gen_FinStatDetails_Service_Helper.getNumberOfEmployees(recordId, fsServiceId);
        final arce__Account_has_Analysis__c acchasAnalysis = new arce__Account_has_Analysis__c();
        acchasAnalysis.Id = recordId;
        acchasAnalysis.arce__employees_number__c = response.employeesNumber;
        arce.Arc_Gen_AccHasAnalysis_Data.upsertObjects(new List<arce__Account_has_Analysis__c>{acchasAnalysis});
        return response;
    }

}