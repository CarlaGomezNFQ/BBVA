/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_SP2_Multitemplate_Service
* @Author   ivan.cons@bbva
* @Date     Created: 2020-07-13
* @Group    ARCE
* ------------------------------------------------------------------------------------------------
* @Description: Utility generic class
* ------------------------------------------------------------------------------------------------
* @Changes
*
* |2020-07-13 ivan.cons.contractor@bbva
*              Class creation.
* |2021-02-15 ivan.cons@bbva
*              Added getDependentValuesJSON overload to get dependent values based on picklist values.
* |2021-07-26 saimassimilianno.jordana.contractor@bbva.com
*              Added Dynamicsobject subClass, and all type of adaptations for 2012 model.
* |2021-09-01 saimassimilianno.jordana.contractor@bbva.com
*              Added updateRecords2012 meth0d to update actvities splits 2012.
* ------------------------------------------------------------------------------------------------
*/
public with sharing class Arc_Gen_Corporate_Utils {

    /**
    *-------------------------------------------------------------------------------
    * @Description Class for Dynamic sObjects instance.
    *--------------------------------------------------------------------------------
    * @ Author saimassimilianno.jordana.contractor@bbva.com
    * @ Date   Created: 2021-07-15
    *--------------------------------------------------------------------------------
    **/
    public class Dynamicsobject {

        /**
        *-------------------------------------------------------------------------------
        * @Description Method to instance objects dynamically.
        *--------------------------------------------------------------------------------
        **/
        public SObject getNewSobject(String objectName) {
            /* Call global describe to get the map of string to token. */
            final Map<String, Schema.SObjectType> globalDesc = Schema.getGlobalDescribe();

            /* Get the token for the sobject based on the type. */
            final Schema.SObjectType objectTokn = globalDesc.get(objectName);

            return objectTokn.newSobject();
        }
    }

    /**
    * --------------------------------------------------------------------------------------
    * @description Get all the fields for an specific object Type separated by commas.
    * @param sObjectType Object type to retrieve fields.
    * @return Returns the comma separated list of fields.
    **/
    public static String getAllFields(String sObjectType) {
        String returnedFields = '';
        for(String field : Schema.getGlobalDescribe().get(sObjectType).getDescribe().Fields.getMap().keySet()){
            returnedFields += field + ',';
        }
        return returnedFields.removeEnd(',');
    }

    /**
    * --------------------------------------------------------------------------------------
    * @description Fills the distribution maps for the chart component.
    * @param distributionMap Map to be filled.
    * @param key Map key.
    * @param value Value to be added.
    **/
    public static void fillDistributionMap(Map<String, Decimal> distributionMap,String key, Decimal value) {
        if(distributionMap.containsKey(key)) {
            Decimal acttyWeigth = distributionMap.get(key) + value;
            distributionMap.put(key, acttyWeigth);
        } else {
            distributionMap.put(key, value);
        }
    }

    /**
    * --------------------------------------------------------------------------------------
    * @description Get the relation API name- values for the requested field.
    * @param sObjectType Object type of the picklist.
    * @param sObjectField Object field of the picklist.
    * @return Map API-value of the picklist.
    **/
    public static Map<String,String> getPicklistLabels(String sObjectType, String sObjectField) {
        Map<String,String> picklistMap = new Map<String,String>();
        List<Schema.PicklistEntry> picklistEntries = Schema.getGlobalDescribe().get(sObjectType).getDescribe().Fields.getMap().get(sObjectField).getDescribe().getPicklistValues();
        for(Schema.PicklistEntry elem : picklistEntries) {
            picklistMap.put(elem.getValue(),elem.getLabel());
        }
        return picklistMap;
    }

    /**
    * --------------------------------------------------------------------------------------
    * @description arce__Qualitative_question__mdt Selector.
    * @return Returns the map with the all qualitative questions.
    **/
    public static Map<String, arce__Qualitative_question__mdt> getAllQualitativeQuestions() {
        Map<String, arce__Qualitative_question__mdt> toReturn = new  Map<String, arce__Qualitative_question__mdt>();
        for(arce__Qualitative_question__mdt question: [Select Label,MasterLabel,arce__Question__c,arce__Question_Values__c, arce__Template__c,arce__Subsection_Name__c FROM arce__Qualitative_question__mdt]) {
            toReturn.put(question.MasterLabel, question);
        }
        return toReturn;
    }

    /**
    * --------------------------------------------------------------------------------------
    * @description Creates the dependent values JSON for the qualitative questions to be shown in the Dyn Form
    * @param availableQuestions Available questions with its possible answers.
    * @return JSON with the questions maped as dependent value.
    **/
    public static String getDependentValuesJSON(List<String> availableQuestions) {
        String questions = '';
        for(String question: availableQuestions) {
            questions += question + ',';
        }
        questions = questions.removeEnd(',');
        List<dyfr__Dependent_value__c> dependentVal = new List<dyfr__Dependent_value__c>{new dyfr__Dependent_value__c(dyfr__LoV_values__c = questions, dyfr__LoV_labels__c = questions)};
        return JSON.serialize(dependentVal, true);
    }

    /**
    * --------------------------------------------------------------------------------------
    * @description Creates the dependent values JSON for the qualitative questions to be shown in the Dyn Form
    * @param availableQuestions Available questions with its possible answers.
    * @param questionMtd Qualitative question metadata with the field information.
    * @return JSON with the questions maped as dependent value, including values for the picklist items.
    **/
    public static String getDependentValuesJSON(arce__Qualitative_question__mdt questionMtd, List<String> availblQstions, String objectToUse) {
        String questions = '';
        String labels = '';
        final Map<String,String> picklistMap = getPicklistLabels(objectToUse, questionMtd.arce__Question__c);
        for(String question: availblQstions) {
            questions += question + ',';
            labels += String.isNotBlank(picklistMap.get(question))?picklistMap.get(question):question;
            labels+= ',';
        }

        questions = questions.removeEnd(',');
        labels = labels.removeEnd(',');
        List<dyfr__Dependent_value__c> dependentVal = new List<dyfr__Dependent_value__c>{new dyfr__Dependent_value__c(dyfr__LoV_values__c = questions, dyfr__LoV_labels__c = labels)};
        return JSON.serialize(dependentVal, true);
    }
    /**
    * @description SObject with the merge fields
    * @author amunguia.contractor@bbva.com | 09-08-2021
    * @param SObject updatedRecord
    * @param SObject currentRecord
    * @param String objectName
    * @return SObject
    **/
    public static SObject mergeRecords(SObject updatedRecord, SObject currentRecord, String objectName) {
        final SObjectType objToken = Schema.getGlobalDescribe().get(objectName);
        final DescribeSObjectResult objDef = objToken.getDescribe();
        final Map<String, SObjectField> fields = objDef.fields.getMap();
        for (String field : fields.keySet()) {
            if (currentRecord.isSet(field)) {
                updatedRecord.put(field, currentRecord.get(field));
            }
        }
        return updatedRecord;
    }
    /**
    *-------------------------------------------------------------------------------
    * @description Method that update a list of Activity split 2012
    --------------------------------------------------------------------------------
    * @date 01/09/2021
    * @param List<sObject> recordsToUpdate
    * @return SaveResult - A wrapper with the results of a DML operation
    * @example global SaveResult updateRecords(List<sObject> recordsToUpdate) {
    **/
    public static arce.Arc_Gen_RatingGlobal_data.SaveResult updateRecords2012(List<sObject> recordsToUpdate) {
      final arce.Arc_Gen_RatingGlobal_data.SaveResult updateResults = new arce.Arc_Gen_RatingGlobal_data.SaveResult();
      try {
        updateResults.status = 'true';
        update(recordsToUpdate);
      } catch(DmlException ex) {
        updateResults.status = 'false';
        updateResults.message = ex.getMessage();
      }
      return updateResults;
    }
}