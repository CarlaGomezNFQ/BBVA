/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_DependentValue_Utils
* @Author   amunguia.contractor@bbva.com
* @Date     Created: 18/03/2021
* @Group    ARCE
* -----------------------------------------------------------------------------------------------
* @Description Arc_Gen_DependentValue_Utils
* -----------------------------------------------------------------------------------------------
* @Changes
*
* |18-03-2021 amunguia.contractor@bbva.com
*             Class creation.
* |08-07-2021 amunguia.contractor@bbva.com logic is added to find the names of the cclient
* -----------------------------------------------------------------------------------------------
*/
global with sharing class Arc_Gen_DependentValue_Utils {
    /**
    * --------------------------------------------------------------------------------------
    * Constructor
    **/
    @TestVisible
    private Arc_Gen_DependentValue_Utils() {}
    /**
    * @description a dependent list is created with the gcp not calculated
    * @author amunguia.contractor@bbva.com | 03-18-2021
    * @param arce__Financial_Statements__c ffee
    * @param arce__Account_has_Analysis__c ahaObject
    * @param String accNumber
    * @return dyfr__Dependent_value__c
    **/
    global static dyfr__Dependent_value__c gcpBuilder (arce__Financial_Statements__c ffee, arce__Account_has_Analysis__c ahaObject, String accNumber) {
        final Double ratingGCP = ffee.arce__total_rating_score_number__c == null ? 0 : ffee.arce__total_rating_score_number__c;
        return parseDependentValue(new List<String>{GCP.NO_CALCULADO.name()}, new List<String>{String.valueOf(ratingGCP)}, accNumber);
    }
    /**
    * @description a dependent list is created with parents and list
    * @author amunguia.contractor@bbva.com | 03-18-2021
    * @param Map<String List<String>> parentMap
    * @return List<dyfr__Dependent_value__c>
    **/
    global static List<dyfr__Dependent_value__c> parentBuilder (Map<String,List<String>> parentMap, Map<String, String> accMap) {
        final List<dyfr__Dependent_value__c> result = new List<dyfr__Dependent_value__c>();
        for(String key :parentMap.keySet()) {
            final List<String> label = new List<String>();
            final List<String> value = new List<String>();
            for(String cclient : parentMap.get(key)) {
                if(accMap.containsKey(cclient)) {
                    label.add(accMap.get(cclient) + ' - ' + cclient);
                    value.add(cclient);
                }
            }
            result.add(parseDependentValue(value, label, key));
        }
        return result;
    }
    /**
    * @description dependent value factory
    * @author amunguia.contractor@bbva.com | 03-18-2021
    * @param List<String> newValues
    * @param List<String> newLabels
    * @param String control
    * @return dyfr__Dependent_value__c
    **/
    private static dyfr__Dependent_value__c parseDependentValue (List<String> newValues, List<String> newLabels, String control) {
        final dyfr__Dependent_value__c result = new dyfr__Dependent_value__c();
        result.dyfr__LoV_values__c = String.join(newValues,',');
        result.dyfr__LoV_labels__c = String.join(newLabels,',');
        result.dyfr__Values_control_value__c = String.isBlank(control) ? result.dyfr__Values_control_value__c : control;
        return result;
    }
    /**
    * @description recalculate ratings
    * @author amunguia.contractor@bbva.com | 05-10-2021
    * @param arce__Financial_Statements__c ffee
    * @param arce__Account_has_Analysis__c ahaObject
    * @param String accNumber
    * @return dyfr__Dependent_value__c
    **/
    global static dyfr__Dependent_value__c recalculateRating (arce__Financial_Statements__c ffee, arce__Account_has_Analysis__c ahaObject, String accNumber) {
        final Double ratingGCP = ffee.arce__total_rating_score_number__c == null ? 0 : ffee.arce__total_rating_score_number__c;
        return parseDependentValue(new List<String>{String.valueOf(ratingGCP)}, new List<String>{String.valueOf(ratingGCP)}, accNumber);
    }
    /** @Description: ENUM GCP */
    global enum GCP {NO_CALCULADO}
}