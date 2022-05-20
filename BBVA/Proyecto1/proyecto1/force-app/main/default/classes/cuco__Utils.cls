/**
* ────────────────────────────────────────────────────────────────────
* Utils class
* Method class that contains utilities for use in any class.
* ────────────────────────────────────────────────────────────────────
* @author      Diego Arias <diego.arias.fernandez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-02-26
* @modified
* @systemLayer Utility
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@SuppressWarnings('sf:DMLWithoutSharingEnabled')
global class Utils {

    /**
    * @description Private constructor to avoid sonar err
    */
    @TestVisible
    private Utils() {}

    /**
    * @description Method that obtains the current active custom metadata record with the general configuration
    * @return pa_general_configuration__mdt, custom metadata record with the general configuration
    */
    global static pa_general_configuration__mdt getGeneralConfiguration() {
        final PaGeneralConfiguration_Selector genConfigSelectorPar = new PaGeneralConfiguration_Selector();
        List<pa_general_configuration__mdt> lstGenConfigPar = new List<pa_general_configuration__mdt>();
        if (Test.isRunningTest()) {
            lstGenConfigPar = genConfigSelectorPar.selectByDeveloperName('Sample');
        } else {
            lstGenConfigPar = genConfigSelectorPar.selectActiveRecord();
        }
        return lstGenConfigPar[0];
    }

    /**
    * @description Method that returns the label of a picklist value
    * @return String, Label of the picklist value
    * @param String objName : API Name of the object MUST include namespace prefix
    * @param String fieldName : API Name of the picklist field MUST include namespace prefix
    * @param String fieldValue : Field value
    */
    global static String getPicklistLabel(String objName, String fieldName, String fieldValue) {
        String prefixedFieldName = (fieldName.substring(0,6) != 'cuco__') ? 'cuco__' + fieldName : fieldName;
        String label = '';
        List<Schema.PicklistEntry> entries = Schema.getGlobalDescribe().get(objName).getDescribe().fields.getMap().get(prefixedFieldName).getDescribe().getPicklistValues();
        for (Schema.PicklistEntry entry : entries) {
            if(entry.getValue() == fieldValue) {
                label = entry.getLabel();
                break;
            }
        }
        return label;
    }

    /**
    * @description Method that returns the labels of a picklist value
    * @param String objName : API Name of the object MUST include namespace prefix
    * @param String fieldName : API Name of the picklist field MUST include namespace prefix
    * @return List<Picklist_Wrapper>, with pair values api name - label of each value of the picklist
    */
    global static List<Picklist_Wrapper> getPicklistLabels(String objName, String fieldName) {
        String prefixedFieldName = (fieldName.substring(0,6) != 'cuco__') ? 'cuco__' + fieldName : fieldName;
        final List<Picklist_Wrapper> lstPicklistValues = new List<Picklist_Wrapper>();
        List<Schema.PicklistEntry> entries = Schema.getGlobalDescribe().get(objName).getDescribe().fields.getMap().get(prefixedFieldName).getDescribe().getPicklistValues();
        for (Schema.PicklistEntry entry : entries) {
            lstPicklistValues.add(new Picklist_Wrapper(entry.getValue(), entry.getLabel()));
        }
        return lstPicklistValues;
    }

    /**
    * @description Retrieves mock configuration from IASO metadata
    * @param serviceName: Name of the metadata record
    * @param statusCode: Status code to add to response (If needed)
    * @return HttpResponse HttpResponse
    */
    global static HttpResponse getResponseMock(String serviceName, Integer statusCode) {
        //TODO There seems to be a bug and getInstance only returns first 255 characters of a textlong field, change when fixed.
        //iaso__GBL_integration_service__mdt serviceProp = iaso__GBL_integration_service__mdt.getInstance(serviceName);
        final iaso__GBL_integration_service__mdt serviceProp = [SELECT iaso__Mock_LTA__c, iaso__Http_Method__c FROM iaso__GBL_integration_service__mdt WHERE DeveloperName =:serviceName LIMIT 1];
        final HttpResponse response = new HttpResponse();
        if (serviceName == 'requestCondNotebookCreation') {
            response.setHeader('location','https://ei-asoexternos.grupobbva.com/ASOMXM/proposals/v0/conditions-notebooks/ES018200000XXXX');
        } else {
            response.setHeader('Content-Type','application/json');
        }
        response.setBody(serviceProp.iaso__Mock_LTA__c);
        if (statusCode == null) {
            response.setStatusCode(serviceProp.iaso__Http_Method__c == 'POST' ? 201 : 200);
        } else {
            response.setStatusCode(statusCode);
        }
        return response;
    }

    /**
    * @description method to invoke service
    * @param serviceName Service Name
    * @return HttpResponse HttpResponse
    */
    global static HttpResponse callWServices(String serviceName, String request) {
        HttpResponse response;
        if(Test.isRunningTest()) {
            response = getResponseMock(serviceName, null);
        } else{
            response = iaso.GBL_Integration_GenericService.invoke(serviceName, request);
        }
        return response;
    }

    /**
    * @description Method that returns the sobject api name from a record id
    * @param recordId : Id of the record that wants to know the object api name
    * @return String with the object api name
    */
    global static String getObjectAPIName(Id recordId) {
        String sObjectName;
        if (recordId != null) {
            sObjectName = recordId.getSObjectType().getDescribe().getName();
        }
        return sObjectName;
    }

    /**
    * @description Method that get field labels associated with the param object
    * @param sObjectName : Name of related object
    * @return Map with api as key, label as value
    */
    global static Map<String, String> getLabelFields(String sObjectName) {
        Map<String, String> retMap = new Map<String, String>();
        Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(sObjectName).getDescribe().fields.getMap();
        for(String fieldName : fieldMap.keySet()){
            retMap.put(fieldName, fieldMap.get(fieldName).getDescribe().getLabel());
        }
        return retMap;
    }

    /**
    * @description Wrapper use to return info on dml operations
    */
    global class DML_Wrapper {

        /**
          * @description Boolean variable to set if DML Operation was successful
          */
        @AuraEnabled
        global Boolean isSuccess {get; set;}

        /**
          * @description String variable to set DML Operation errors, if exist
          */
        @AuraEnabled
        global List<String> lstErrMessage {get; set;}

        /**
          * @description Constructor of DML_Wrapper class
          */
        global DML_Wrapper(Boolean isSuccess, List<String> lstErrMessage) {
            this.isSuccess = isSuccess;
            this.lstErrMessage = lstErrMessage;
        }
    }

    /**
    * @description Wrapper use to return info of picklist values
    */
    global class Picklist_Wrapper {

        /**
          * @description String variable to set api name of picklist field
          */
        @AuraEnabled
        global String apiName {get; set;}

        /**
          * @description String variable to set value name of picklist field
          */
        @AuraEnabled
        global String value {get; set;}

        /**
          * @description Constructor of DML_Wrapper class
          */
        global Picklist_Wrapper(String apiName, String value) {
            this.apiName = apiName;
            this.value = value;
        }
    }
    /**
    * @description if a String is empty or not
    * @param inputField : String with input field to check
    * @return Boolean string empty or not
    */
    global static boolean isFilled(string inputField) {
        boolean hasValue = true;
        if(inputField == null || inputField == '') {
            hasValue = false;
        }
        return hasValue;
    }
    /**
    * @description if a List is empty or not
    * @param inputList : List<Object> to check
    * @return Boolean List empty or not
    */
    global static boolean isFilledList(List<Object> inputList) {
        boolean hasValue = true;
        if(inputList == null || inputList.size() == 0) {
            hasValue = false;
        }
        return hasValue;
    }
    /**
    * @description if an Object is empty or not
    * @param inputList : Object to check
    * @return Boolean Object empty or not
    */
    global static boolean isFilledObject(Object inputObject) {
        boolean hasValue = true;
        if(inputObject == null) {
            hasValue = false;
        }
        return hasValue;
    }

    /**
    * @description Returns a map after checking available actions
    * @param source: String with source received from the component
    * @param profAnalysisId: String with profitability analysis id
    * @return Map<String, Object> with the response
    */
    global static Map<String,Object> checkAvailableAction(String source, String profAnalysisId) {
        final cuco__pa_general_configuration__mdt cmt = Utils.getGeneralConfiguration();
        final Type availableActClass = Type.forName(cmt.cuco__available_actions_itf_name__c);
        final AvailableActions_itf availableActItf = (AvailableActions_itf) availableActClass.newInstance();
        return availableActItf.checkAvailableAction(source, profAnalysisId);
    }
}