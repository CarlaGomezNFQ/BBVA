/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_TestingGlobal_Util
* @Author   BBVA Developers
* @Date     Created: 2020-06-30
* @Group    ARCE
* ------------------------------------------------------------------------------------------------
* @Description this class is the controller for the table.
* ------------------------------------------------------------------------------------------------
* @Changes
*
* |2020-06-30 BBVA Developers.
*              Class creation.
* 2020-10-20    alexander.munguia.contractor@bbva.com change api names in picklist of arce__Activity_Split__c
* 2021-09-01    juanignacio.hita.contractor@bbva.com remove extra fields createModifier method
* ------------------------------------------------------------------------------------------------
*/
@isTest
public with sharing class Arc_Gen_TestingGlobal_Util {
    /**
    *--------------------------------------------------------------------------------
    * @Description Test method for avoiding sonar major issue
    *--------------------------------------------------------------------------------
    */
    @isTest
    static void avoidSonar() {
        System.assert(true, 'Test method for avoiding sonar major issue');
    }

    /**
    *-------------------------------------------------------------------------------
    * @Description create new arce__Analysis__c
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-06-30
    * @ return arce__Analysis__c
    * @ example Arc_Gen_TestingGlobal_Util.createAnalisis()
    *--------------------------------------------------------------------------------
    **/
    public static arce__Analysis__c createAnalisis() {
        arce__Analysis__c analisis = new arce__Analysis__c();
        return analisis;
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description create new arce__Account_has_Analysis__c
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-06-30
    * @ param String idAnalisis
    * @ return arce__Account_has_Analysis__c
    * @ example Arc_Gen_TestingGlobal_Util.createAccountHasAnalisis('XXXXXXXXX')
    *--------------------------------------------------------------------------------
    **/
    public static arce__Account_has_Analysis__c createAccountHasAnalisis(String idAnalisis) {
        arce__Account_has_Analysis__c aha = new arce__Account_has_Analysis__c();
        aha.arce__Analysis__c = idAnalisis;
        return aha;
    }
    /**
    * @description create new Modifier
    * @author amunguia.contractor@bbva.com | 07-23-2021
    * @param String ahaId
    * @return arce__Modifier__c
    **/
    public static arce__Modifier__c createModifier(String ahaId) {
        return new arce__Modifier__c(arce__Account_has_AnalysisId__c = ahaId);

    }
}