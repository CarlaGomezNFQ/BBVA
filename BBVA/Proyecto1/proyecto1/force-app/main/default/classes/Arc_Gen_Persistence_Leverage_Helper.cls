/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_Persistence_Leverage_Service
* @Author   mariohumberto.ramirez.contractor@bbva.com
* @Date     Created: 28/02/2020
* @Group    ARCE
* -----------------------------------------------------------------------------------------------
* @Description Class that get data and create json to persist.
* -----------------------------------------------------------------------------------------------
* @Changes
*
* |2020-02-28 mariohumberto.ramirez.contractor@bbva.com
*             Class creation.
* |2020-04-06 mariohumberto.ramirez.contractor@bbva.com
*             Added currency value to the final Json
* |2020-04-20 mariohumberto.ramirez.contractor@bbva.com
*             Set INVESTMENT_GRADE when apiValue = null in the method getClasificationsAdj
* |2020-04-15 berthaelena.tellez.contractor@bbva.com
*             Added value defoult on persistance service
* |2020-09-23 saimassimilianno.jordana.contractor@bbva.com
*             Added arce. namespace to all classes that are now in the arce-dependencies package
* |2020-09-24 joseluis.garcia4.contractor@bbva.com
*             Add getRatingBlock() method for obtaining rating info, delete unused getRatingId().
* -----------------------------------------------------------------------------------------------
*/
public without sharing class Arc_Gen_Persistence_Leverage_Helper {
    /**
    * @Description: Value of LL scope type when it is not excluded.
    */
    private static final String TEST_LL_SCOPE_NOT_EXCLUDED = '2';
    /**
    * ----------------------------------------------------------------------------------------------------
    * @Description Void Constructor to avoid warning in sonar qube
    * ----------------------------------------------------------------------------------------------------
    * @Author mariohumberto.ramirez.contractor@bbva.com
    * @Date 2020-02-28
    * @param void
    * @return coid
    * @example Arc_Gen_Persistence_Leverage_Helper helper = new Arc_Gen_Persistence_Leverage_Helper()
    * ----------------------------------------------------------------------------------------------------
    **/
    @TestVisible
    private Arc_Gen_Persistence_Leverage_Helper() {

    }
    /**
    * ----------------------------------------------------------------------------------------------------
    * @Description return static json key and values to persist
    * ----------------------------------------------------------------------------------------------------
    * @Author mariohumberto.ramirez.contractor@bbva.com
    * @Date 2020-02-28
    * @param var integer
    * @return String
    * @example getmissingJsonKeys(var)
    * ----------------------------------------------------------------------------------------------------
    **/
    public static string getmissingJsonKeys(Integer var, String currencyType) {
        String auxStr;
        switch on var {
            when 0 {
                auxStr = '"grossDebtEbitdaRatio":0';
            }
            when 1 {
                auxStr = '"id": "ADJUSTED_DEBT","amount": 0,"currency":"' + currencyType + '"';
            }
            when 2 {
                auxStr = '"id": "ADJUSTED_EBITDA","amount": 0,"currency":"' + currencyType + '"';
            }
            when 3 {
                auxStr = '"id": "TOTAL_CREDIT_RISK","amount": 0,"currency":"' + currencyType + '"';
            }
        }
        return auxStr;
    }
    /**
    * ----------------------------------------------------------------------------------------------------
    * @Description get the id of the rating to persist
    * ----------------------------------------------------------------------------------------------------
    * @Author mariohumberto.ramirez.contractor@bbva.com
    * @Date 2020-02-28
    * @param List<sObject> listObject - account has analysis object data
    * @return apifieldName - api name of the field to consult
    * @example getTypeOfAnalysis(listObject,apifieldName)
    * ----------------------------------------------------------------------------------------------------
    **/
    public static String getTypeOfAnalysis(List<sObject> listObject, String apifieldName) {
        String retStr = '';
        List<String> auxLts = apifieldName.split('\\.');
        String apiValue = listObject[0].getSobject(auxLts[0]).get(auxLts[1]) == null ? '' : String.valueOf(listObject[0].getSobject(auxLts[0]).get(auxLts[1]));
        switch on apiValue {
            when '1' {
                retStr = 'CONSOLIDATED';
            }
            when '2' {
                retStr = 'INDIVIDUAL';
            }
        }
        return retStr;
    }
    /**
    * ----------------------------------------------------------------------------------------------------
    * @Description get the id of the rating to persist
    * ----------------------------------------------------------------------------------------------------
    * @Author mariohumberto.ramirez.contractor@bbva.com
    * @Date 2020-02-28
    * @param List<sObject> listObject - account has analysis object data
    * @return apifieldName - api name of the field to consult
    * @example getCovenantType(listObject,apifieldName)
    * ----------------------------------------------------------------------------------------------------
    **/
    public static String getCovenantType(List<sObject> listObject, String apifieldName) {
        String retStr = '';
        String apiValue = listObject[0].get(apifieldName) == null ? '' : String.valueOf(listObject[0].get(apifieldName));
        switch on apiValue {
            when '1' {
                retStr = 'NO_COVENANT';
            }
            when '2' {
                retStr = 'COVENANT_LOOSE';
            }
            when '3' {
                retStr = 'COVENANT_LITE';
            }
            when '4' {
                retStr = 'FULL_COVENANT';
            }
            when else {
                retStr = 'NO_COVENANT';
            }
        }
        return retStr;
    }
    /**
    * ----------------------------------------------------------------------------------------------------
    * @Description get the id of the rating to persist
    * ----------------------------------------------------------------------------------------------------
    * @Author mariohumberto.ramirez.contractor@bbva.com
    * @Date 2020-02-28
    * @param List<sObject> listObject - account has analysis object data
    * @return apifieldName - api name of the field to consult
    * @example getClasificationsAdj(listObject,apifieldName)
    * ----------------------------------------------------------------------------------------------------
    **/
    public static String getClasificationsAdj(List<sObject> listObject, String apifieldName) {
        String retStr = '';
        String apiValue = listObject[0].get(apifieldName) == null ? 'N/A' : String.valueOf(listObject[0].get(apifieldName));
        switch on apiValue {
            when 'NI' {
                retStr = 'INVESTMENT_GRADE';
            }
            when 'FS' {
                retStr = 'FINANCIAL_SPONSOR';
            }
            when 'R4' {
                retStr = 'LEVERAGE_RATIO_GREATER_OR_EQUAL_4';
            }
            when 'R6' {
                retStr = 'LEVERAGE_RATIO_GREATER_OR_EQUAL_6';
            }
            when else {
                retStr = 'INVESTMENT_GRADE';
            }
        }
        return retStr;
    }
    /**
    * ----------------------------------------------------------------------------------------------------
    * @Description get the currency selected in policies table
    * ----------------------------------------------------------------------------------------------------
    * @Author mariohumberto.ramirez.contractor@bbva.com
    * @Date 2020-02-28
    * @param List<sObject> listObject - account has analysis object data
    * @return apifieldName - api name of the field to consult
    * @example getCurrencyType(currencyType)
    * ----------------------------------------------------------------------------------------------------
    **/
    public static String getCurrencyType(String currencyType) {
        return '"currency":' + '"' + currencyType + '"';
    }
    /**
    * ----------------------------------------------------------------------------------------------------
    * @Description get the rating information of the rating to persist
    * ----------------------------------------------------------------------------------------------------
    * @Author joseluis.garcia4.contractor@bbva.com
    * @Date 2020-09-24
    * @param arce__Account_has_Analysis__c aha listObject - account has analysis object data
    * @return rating block to be sent with the service input
    * ----------------------------------------------------------------------------------------------------
    **/
    public static String getRatingBlock(arce__Account_has_Analysis__c aha) {
        String output = '';

        if (aha.arce__ll_test_scope_ind_type__c == TEST_LL_SCOPE_NOT_EXCLUDED) {
            // Only populate rating when test is not excluded.
            final String ratingId = aha.arce__ffss_for_rating_id__r.arce__rating_id__r.arce__rating_id__c;
            final String ratingValue = aha.arce__ffss_for_rating_id__r.arce__rating_final__c;
            output = '"rating": { "id": "' + ratingId + '", "shortScaleValue": "' + ratingValue +'" },';
        }

        return output;
    }
}