/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_GenericUtilities
* @Author   ismaelyovani.obregon.contractor@bbva.com
* @Date     Created: 2019-06-25
* @Group    ARCE
* ------------------------------------------------------------------------------------------------
* @Description Class of generic utilities
* ------------------------------------------------------------------------------------------------
* @Changes
*
* |2019-06-25 ismaelyovani.obregon.contractor@bbva.com
*             Class creation.
* |2019-06-25 mariohumberto.ramirez.contractor@bbva.com
*             Added new method getRecordTypeData
* |2019-07-16 mariohumberto.ramirez.contractor@bbva.com
*             Added new method getRecordTypeLimExp
* |2019-09-23 mariohumberto.ramirez.contractor@bbva.com
*             Added new method getTypeOfCustomer
*             Added new constants GROUP_CUSTOMER,ORPHAN_CUSTOMER,HEADER,SUBSIDIARY,GROUP,CLIENT
*             ORPHAN
* |2019-09-25 mariohumberto.ramirez.contractor@bbva.com
*             Added new methods getRecordTypeTask, getTypeOfCustomer, createTask, getProfileName
*             getIdsOfSubsidiaries and getAccHasAnalysis.
* |2019-10-21 manuelhugo.castillo.contractor@bbva.com
*             Added new methods getRecType,getAllSObjectRecType,getAllSObjectRecTypeByMapApiName
* |2019-10-28 mariohumberto.ramirez.contractor@bbva.com
*             Added new method getMultiplicationFactor()
* |2019-10-28 eduardoefrain.hernandez.contractor@bbva.com
*             Added method to set the static parameters for ASO services
* |2019-10-28 mariohumberto.ramirez.contractor@bbva.com
*             Added new method convertUnits()
* |2019-10-30 mariohumberto.ramirez.contractor@bbva.com
*             Added new method convertCurrency()
* |2019-10-30 javier.soto.carrascosa@bbva.com
*             Added method getLabelFromValue
* |2019-11-200 javier.soto.carrascosa@bbva.com
*             remove getProfileName
* |2019-11-200 javier.soto.carrascosa@bbva.com
*             remove unused method, add recordtype method
* |2019-12-26 juanmanuel.perez.ortiz.contractor@bbva.com
*             Add new static final variable and create new method to sent notifications
* |2020-13-01 mariohumberto.ramirez.contractor@bbva.com
*             Added new method getUpdateStructure()
*             Change arce__Customer__r.ParentId for arce__group_asset_header_type__c in queries
* |2020-01-24 juanmanuel.perez.ortiz.contractor@bbva.com
*             Remove logic static parameters to ASO services
* |2020-02-08 ricardo.almanza.contractor@bbva.com
*             Added config for oprhans testing
* |2020-03-09 eduardoefrain.hernandez.contractor@bbva.com
*             adedd methods because of Indepentent Rating (RAIP)
* |2020-03-30 eduardoefrain.hernandez.contractor@bbva.com
*             Update convertUnits method
* |2020-04-04 ricardo.almanza.contractor@bbva.com
*             Added SaveResult, getTypeOfCustomerFromStrngs, updateRecords, insertRecords
* |2020-04-05 juanmanuel.perez.ortiz.contractor@bbva.com
*             adedd method called getEventTypeValue to get eventType dynamic value
* |2020-06-03 joseluis.garcia4.contractor@bbva.com
*             Fix NullPointerException in getLabelFromValue() when value is null.
* |2020-06-25 mariohumberto.ramirez.contractor@bbva.com
*             Added new getMapLabelFromValue method
* |2020-04-12 javier.soto.carrascosa@bbva.com
*             Added new populateObjFromMap method
* |2020-08-12 antonio.munoz.perez.contractor@bbva.com
*             Added new getConsolidatedType method
* |2020-08-12 mariohumberto.ramirez.contractor@bbva.com
*             Updated getEventTypeValue method for Hu Renovation
* |2020-08-18 joseluis.garcia4.contractor@bbva.com
*             Added new isButtonAvailable method
* |2020-09-11 moises.martinez.dominguez.contractor@bbva.com
*			  Remove methods getAllSObjectRecType,getAllSObjectRecTypeByMapApiName unused
* |2020-09-11 juanignacio.hita.contractor@bbva.com
*             Add fillMapDynamicLabel method
* |2020-10-26 joseluis.garcia4.contractor@bbva.com
*              Handle empty TDBU indicator for historical ARCEs.
* |2021-01-06 juanmanuel.perez.ortiz.contractor@bbva.com
*             Remove field references for unused fields (namings nivelation)
* |2021-02-23 juanignacio.hita.contractor@bbva.com
*             Adds getConfigComplexityPath method that calculate average path value
* |2021-04-16 jose.hijar.contractor@bbva.com
*             Overload of getEventTypeValue method to add the option to pass a sub-workflow of RATING type
* |2021-04-23 juanignacio.hita.contractor@bbva.com
*             Add getCustomPermissions method
* |2021-07-22 juanignacio.hita.contractor@bbva.com
*             Add isRunningTest condition to getCustomPermissions method
* -----------------------------------------------------------------------------------------------
*/
@SuppressWarnings('PMD.ExcessivePublicCount, sf:TooManyMethods, PMD.ExcessiveClassLength')
global without sharing class Arc_Gen_GenericUtilities {
    /**
        * @Description: Arce config name with the initialized values for complexity of the path field
    */
    static final string CONFIG_COMPLEX_PATH = 'ComplexityPath';
    /**
        * @Description: String with the dev name of the recordtype
    */
    static final string TASK_DEV_NAME = 'Arc_Gen_ARCE_Task';
    /**
        * @Description: String with value "01"
    */
    static final string GROUP_CUSTOMER = '01';
    /**
        * @Description: String with value "02"
    */
    static final string ORPHAN_CUSTOMER = '02';
    /**
        * @Description: String with value "1"
    */
    static final string HEADER = '1';
    /**
        * @Description: String with value "2"
    */
    static final string SUBSIDIARY = '2';
    /**
        * @Description: String with value "Group"
    */
    static final string S_GROUP = 'Group';
    /**
        * @Description: String with value "Client"
    */
    static final string CLIENT = 'Client';
    /**
        * @Description: String with value "Orphan"
    */
    static final string ORPHAN = 'Orphan';
    /**
        * @Description: String with value "High"
    */
    static final string HIGH = 'High';
    /**
        * @Description: String with value "Not Started"
    */
    static final string NOT_STARTED = 'Not Started';
    /**
        * @Description: String with value "Other"
    */
    static final string OTHER = 'Other';
    /**
        * @Description: String with the dev name of the custom metadata update group structure
    */
    static final string UPDATE_GROUP_STRUCT = 'UpdateGroupStructure';
    /**
        * @Description: String with the dev name of the custom metadata update group structure
    */
    static final string GETORPHANANSSTRUCTURE = 'GetOrphanAnsStructure';
    /**
        * @Description: Service response identificator
    */
    global final static String SCORE = 'score';
    /**
        * @Description: Service response identificator
    */
    global final static String LEVEL = 'level';
    /**
        * @Description: Service response identificator
    */
    global final static String VARIABLE_TYPE = 'variableType';
    /**
        * @Description: Service response identificator
    */
    global final static String PARENT_LEVEL = 'parentLevel';
    /**
        * @Description: Service response identificator
    */
    global final static String PARENT_CODE = 'parentCode';
    /**
        * @Description: Service response identificator
    */
    global final static String BLOCK_TYPE = 'blockType';
    /**
        * @Description: Service response identificator
    */
    global final static String VALUE_TEXT = 'value';
    /**
        * @Description: Service response identificator
    */
    global final static String ADJUSTED_VALUE = 'adjustedValue';
    /**
        * @Description: Service response identificator
    */
    global final static String ADJUSTED_SCORE = 'adjustedScore';
    /**
        * @Description: Service response identificator
    */
    global final static String MAXIMUM_SCORE = 'maximumScore';
    /**
        * @Description: Service response identificator
    */
    global final static String MINIMUM_SCORE = 'minimumScore';
    /**
        * @Description: Service response identificator
    */
    global final static String MODIFIER = 'modifier';
    /**
        * @Description: Service response identificator
    */
    global final static String SHORT_VALUE = 'shortScaleValue';
    /**
        * @Description: Service response identificator
    */
    global final static String LONG_VALUE = 'longScaleValue';
    /**
        * @Description: Service response identificator
    */
    global final static String DESCRIPTION = 'description';
    /**
        * @Description: Service response identificator
    */
    global final static String ADJUSTMENT_TYPE = 'adjustmentType';
    /**
        * @Description: Service response identificator
    */
    global final static String DEFAULT_PROBABILITY = 'defaultProbability';

    /**
        * @Description: Service response identificator
    */
    global final static String DATA_TEXT = 'data';
    /**
        * @Description: Service response identificator
    */
    global final static String RATING_TEXT = 'rating';
    /**
        * @Description: Service response identificator
    */
    global final static String FINAL_RATING = 'finalRating';
    /**
        * @Description: Service response identificator
    */
    global final static String SME_INDICATOR = 'isSmallMediumEnterprise';
    /**
        * @Description: Service response identificator
    */
    global final static String ID_TEXT = 'id';
    /**
        * @Description: Service response identificator
    */
    global final static String VARIABLES = 'variables';
    /**
        * @Description: Service response identificator
    */
    global final static String ADJUSTMENTS = 'adjustments';
    /**
        * @Description: Service response identificator
    */
    global final static String CODE_TEXT = 'code';
    /**
        * @Description: Service response identificator
    */
    global final static String CURRENCY_TEXT = 'currency';
    /**
        * @Description: Record types Map
    */
    private static Map<String, Map<String,Id>> mapRecTypes = new Map<String, Map<String,Id>>();
    /**
        * @Description: Record types Map Aux
    */
    private static Map<String, Id> mapAuxObjRecType  = new Map<String, Id>();
    /**
        * @Description: Record type Ids Map
    */
    global class ConversionWrapper {
        /**
        * @Description: Previous Data
        */
        global String previousData {get; set;}
        /**
        * @Description: Actual Data
        */
        global String actualData {get; set;}
        /**
        * @Description: List of the field names
        */
        global List<String> fieldNames  {get; set;}
        /**
        * @Description: List of object Data
        */
        global List<SObject> objDataLts {get; set;}
        /**
        * @Description: Object Data
        */
        global SObject objData {get; set;}
    }
    /**
    * @Class: saveResult
    * @Description: Wrapper that contain the information of a DML Result
    * @author BBVA
    */
    @JsonAccess(serializable='always' deserializable='always')
    global class SaveResult {
        /**
        * @Description: Status of the DML operation
        */
        global String status {get;set;}
        /**
        * @Description: Message if the DML operation fails
        */
        global String message {get;set;}
    }
    global class Acchasanamap {
        global String ids{get;set;}
        global String grouporclient{get;set;}
    }
    @JsonAccess(serializable='always' deserializable='always')
    global class Customerinfo{
      /**variable for CustomerName **/
      global String customerName {get; set;}
      /**customer Id **/
      global String customerId {get; set;}
    }
    private static Map<String, RecordType> mapIdRecordType  = new Map<String, RecordType>();
    static {
    List<RecordType> lstRecType = [SELECT Id, SobjectType, DeveloperName, Name FROM RecordType WHERE IsActive = true];
        for (RecordType objRecType : lstRecType) {
            mapAuxObjRecType = mapRecTypes.get(objRecType.SobjectType);
            if ( mapAuxObjRecType == null ) {
                mapAuxObjRecType = new Map<String, Id>();
                mapRecTypes.put(objRecType.SobjectType, mapAuxObjRecType);
            }
            mapAuxObjRecType.put(objRecType.DeveloperName, objRecType.Id);
            mapAuxObjRecType.put(objRecType.Name, objRecType.Id);
            mapIdRecordType.put(objRecType.id, objRecType);
        }
    }
    /**
    * ----------------------------------------------------------------------------------------------------
    * @Description Void Constructor to avoid warning in sonar qube
    * ----------------------------------------------------------------------------------------------------
    * @author ismaelyovani.obregon.contractor@bbva.com
    * @date 2019-06-25
    * @param void
    * @return void
    * @example Arc_Gen_GenericUtilities generic = new Arc_Gen_GenericUtilities()
    * ----------------------------------------------------------------------------------------------------
    **/
    @TestVisible
    global Arc_Gen_GenericUtilities() {
    }
    /**
    * --------------------------------------------------------------------------------------
    * @description Get all the fields for an specific object Type separated by commas.
    * @param sObjectType Object type to retrieve fields.
    * @return Returns the comma separated list of fields.
    **/
    global static String getAllFields(String sObjectType) {
        String returnedFields = '';
        for(String field : Schema.getGlobalDescribe().get(sObjectType).getDescribe().Fields.getMap().keySet()){
            returnedFields += field + ',';
        }
        return returnedFields.removeEnd(',');
    }
    /**
    * ----------------------------------------------------------------------------------------------------
    * @Description - Method that return's the values of any picklist.
    * ----------------------------------------------------------------------------------------------------
    * @author ismaelyovani.obregon.contractor@bbva.com
    * @date 2019-06-25
    * @param objectType object to get the field
    * @param selectedField to obtain picklist values
    * @return List<String> of pick list values
    * @example global static List<String> getPickListValue(String Object , String PicklistField)
    * ----------------------------------------------------------------------------------------------------
    **/
    global static List<String> getValuesPickList(String objectType,String selectedField) {
        List<String> pickListValues = new List<String>();
        Schema.SObjectType convertToObj = Schema.getGlobalDescribe().get(objectType);
        Schema.DescribeSObjectResult res = convertToObj.getDescribe();
        Schema.DescribeFieldResult fieldResult = res.fields.getMap().get(selectedField).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple) {
            pickListValues.add(pickListVal.getLabel());
        }
        return pickListValues;
    }
    /**
    * ----------------------------------------------------------------------------------------------------
    * @Description - Method that return's the record type data
    * ----------------------------------------------------------------------------------------------------
    * @author ismaelyovani.obregon.contractor@bbva.com
    * @date 2019-06-25
    * @param recordTypeName - recordtype name
    * @return RecordType data queried
    * @example getRecordTypeData(recordTypeName)
    * ----------------------------------------------------------------------------------------------------
    **/
    global static List<RecordType> getRecordTypeData(String recordTypeName) {
        return [SELECT Id, Name FROM RecordType WHERE DeveloperName = :recordTypeName];
    }

    /**
    * ----------------------------------------------------------------------------------------------------
    * @Description - Method that return's a record type id of the Limits Exposure object
    * ----------------------------------------------------------------------------------------------------
    * @Author   mariohumberto.ramirez.contractor@bbva.com
    * @Date     Created: 2019-08-09
    * @param recordTypeDevName - developer name of the record type
    * @return Id of the recordType
    * @example getRecordTypeLimExp(recordTypeDevName)
    * ----------------------------------------------------------------------------------------------------
    **/
    global static Id getRecordTypeLimExp(String recordTypeDevName) {
        return Schema.SObjectType.arce__limits_exposures__c.getRecordTypeInfosByDeveloperName().get(recordTypeDevName).getRecordTypeId();
    }

    /**
    * ----------------------------------------------------------------------------------------------------
    * @Description - Method that return's a record type id of Task object
    * ----------------------------------------------------------------------------------------------------
    * @Author   mariohumberto.ramirez.contractor@bbva.com
    * @Date     Created: 2019-09-25
    * @param recordTypeDevName - developer name of the record type
    * @return Id of the recordType
    * @example getRecordTypeTask(recordTypeDevName)
    * ----------------------------------------------------------------------------------------------------
    **/
    global static Id getRecordTypeTask(String recordTypeDevName) {
        return Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get(recordTypeDevName).getRecordTypeId();
    }

    /**
    * ----------------------------------------------------------------------------------------------------
    * @Description - Method that return's if the client is group or filial
    * ----------------------------------------------------------------------------------------------------
    * @Author   mariohumberto.ramirez.contractor@bbva.com
    * @Date     Created: 2019-09-24
    * @param recordId - Id of the account has analysis object
    * @return String with value "Group" or "Client" or "Orphan"
    * @example getTypeOfCustomer(recordId)
    * ----------------------------------------------------------------------------------------------------
    **/
    global static String getTypeOfCustomer(String recordId) {
        final String typeOfCustomer;
        final arce__Account_has_Analysis__c accHasAn = [SELECT Id,arce__Analysis__c,arce__Analysis__r.arce__analysis_customer_relation_type__c,arce__group_asset_header_type__c
                                                    FROM arce__Account_has_Analysis__c
                                                    WHERE Id = :recordId];
        if (accHasAn.arce__Analysis__r.arce__analysis_customer_relation_type__c == GROUP_CUSTOMER && accHasAn.arce__group_asset_header_type__c == HEADER) {
            typeOfCustomer = S_GROUP;
        } else if (accHasAn.arce__Analysis__r.arce__analysis_customer_relation_type__c == GROUP_CUSTOMER && accHasAn.arce__group_asset_header_type__c == SUBSIDIARY) {
            typeOfCustomer = CLIENT;
        } else if (accHasAn.arce__Analysis__r.arce__analysis_customer_relation_type__c == ORPHAN_CUSTOMER) {
            typeOfCustomer = ORPHAN;
        }
        return typeOfCustomer;
    }

    /**
    * ----------------------------------------------------------------------------------------------------
    * @Description - Method that return's if the client is group or filial
    * ----------------------------------------------------------------------------------------------------
    * @Author   mariohumberto.ramirez.contractor@bbva.com
    * @Date     Created: 2019-09-24
    * @param recordId - Id of the account has analysis object
    * @return String with value "Group" or "Client" or "Orphan"
    * @example getTypeOfCustomer(recordId)
    * ----------------------------------------------------------------------------------------------------
    **/
    global static String getTypeOfCustomerFromStrngs(String rel,String headtype) {
        final String typeOfCustomer;
        if (rel == GROUP_CUSTOMER && headtype == HEADER) {
            typeOfCustomer = S_GROUP;
        } else if (rel == GROUP_CUSTOMER && headtype == SUBSIDIARY) {
            typeOfCustomer = CLIENT;
        } else if (rel == ORPHAN_CUSTOMER) {
            typeOfCustomer = ORPHAN;
        }
        return typeOfCustomer;
    }
    /**
    *-------------------------------------------------------------------------------
    * @description creates notifications for the user the ARCE is assign
    *-------------------------------------------------------------------------------
    * @author   juanmanuel.perez.ortiz.contractor@bbva.com
    * @date     26/12/2019
    * @Method:  createNotifications
    * @param:   ltsMembers list of member
    * @param:   recordId id of the ARCE
    * @param:   message mesage to the user
    */
    global static void createNotifications(List<User> ltsMembers, Id recordId, String message) {
        list<Task> ltsTask = new list<Task>();
        for (User members: ltsMembers) {
            ltsTask.add(createTask(members.Id,recordId,message,TASK_DEV_NAME));
        }
        insert ltsTask;
    }

    /**
    * ----------------------------------------------------------------------------------------------------
    * @Description - Method to create a task
    * ----------------------------------------------------------------------------------------------------
    * @Author   angel.fuertes2@bbva.com
    * @Date     Created: 2019-03-12
    * @param ownerId - id of the owner
    * @param whatId - lookup
    * @param message - String with a custom message
    * @param devNameRT - developer name of the record type
    * @return a task object
    * @example createTask(ownerId,whatId,message,devNameRT)
    * ----------------------------------------------------------------------------------------------------
    **/
    global static task createTask(Id ownerId, Id whatId, String message, String devNameRT) {
        Task tarea = new Task();
        tarea.OwnerId = ownerId;
        tarea.WhatId = whatId;
        tarea.Subject = message;
        tarea.Priority = HIGH;
        tarea.Status = NOT_STARTED;
        tarea.Type = OTHER;
        tarea.recordtypeId = getRecordTypeTask(devNameRT);
        tarea.ActivityDate = Date.today();
        return tarea;
    }
    /**
    * ----------------------------------------------------------------------------------------------------
    * @Description - Method that return a list of Ids of the subsidiaries in the arce analysis
    * ----------------------------------------------------------------------------------------------------
    * @Author   mariohumberto.ramirez.contractor@bbva.com
    * @Date     Created: 2019-09-25
    * @param arceAnalysisId - Id of the arce analysis object
    * @return List<Id> - list of Ids of account has analysis object
    * @example getIdsOfSubsidiaries(arceAnalysisId)
    * ----------------------------------------------------------------------------------------------------
    **/
    global static List<Id> getIdsOfSubsidiaries(Id arceAnalysisId) {
        final List<Id> idAccHasAnLts = new List<Id>();
        final List<arce__Account_has_Analysis__c> acchasData = [SELECT Id, (SELECT Id, arce__Customer__c, arce__Customer__r.Name FROM arce__Account_has_Analysis__r WHERE arce__InReview__c = true AND arce__group_asset_header_type__c = '2')
                                                                FROM arce__Analysis__c
                                                                WHERE Id = :arceAnalysisId].arce__Account_has_Analysis__r;
        for (arce__Account_has_Analysis__c acchas: acchasData) {
            idAccHasAnLts.add(acchas.Id);
        }
        return idAccHasAnLts;
    }
    /**
    * ----------------------------------------------------------------------------------------------------
    * @Description - Method that return a list of account has analysis data
    * ----------------------------------------------------------------------------------------------------
    * @Author   mariohumberto.ramirez.contractor@bbva.com
    * @Date     Created: 2019-09-25
    * @param arceAnalysisId - Id of the arce analysis object
    * @return List<arce__Account_has_Analysis__c> - list of Ids of account has analysis object
    * @example getIdsOfAccHasAnalysis(arceAnalysisId)
    * ----------------------------------------------------------------------------------------------------
    **/
    global static List<arce__Account_has_Analysis__c> getAccHasAnalysis(Id arceAnalysisId) {
        return [SELECT Id, Name, (SELECT Id, arce__InReview__c, arce__Customer__r.OwnerId, arce__Analysis__c, arce__arce_ctmr_flag__c, arce__anlys_wkfl_sbanlys_status_type__c FROM arce__Account_has_Analysis__r WHERE arce__InReview__c = true)
                                                                FROM arce__Analysis__c
                                                                WHERE Id = :arceAnalysisId].arce__Account_has_Analysis__r;
    }
    /*
    * @Description - Method that return record type Id queried by DeveloperName or Name
    * ----------------------------------------------------------------------------------------------------
    * @Author   manuelhugo.castillo.contractor@bbva.com
    * @Date     Created: 2019-10-21
    * @param    devNameObjeto - Object Developer Name
    * @param    devNameTipoRegistro - Developer Name Record Type Object
    * @return   Id - Record Type Id
    * @example  getRecType(developerNameOject,devNameTipoRegistro)
    * ----------------------------------------------------------------------------------------------------
    **/
    global static id getRecType(String devNameObjeto, String devNameTipoRegistro) {
        Map<String, Id> mapObjRecType = mapRecTypes.get(devNameObjeto);
        return mapObjRecType.get(devNameTipoRegistro);
    }
    /**
    * ----------------------------------------------------------------------------------------------------
    * @Description - Method that return a the multiplication factor to change units
    * ----------------------------------------------------------------------------------------------------
    * @Author   mariohumberto.ramirez.contractor@bbva.com
    * @Date     Created: 2019-10-28
    * @param    actualUnit - Api name of the field that contain the current type of unit
    * @param    previousUnit - Api name of the field that contain the previous type of unit
    * @param    accHasAnData - Account has analysis object
    * @return   Double - multiplication factor
    * @example  getMultiplicationFactor(actualUnit,previousUnit)
    * ----------------------------------------------------------------------------------------------------
    **/
    global static Double getMultiplicationFactor(String actualUnit, String previousUnit, SObject obj) {
        Double multiplicationFactor = 1;
        final String combinationOfUnits = (String)obj.get(actualUnit) + ',' + (String)obj.get(previousUnit);
        switch on combinationOfUnits {
            when '1,2', '2,3', '3,4' {
                multiplicationFactor = 1000;
            }
            when '1,3', '2,4' {
                multiplicationFactor = 1000000;
            }
            when '1,4' {
                multiplicationFactor = 1000000000000L;
            }
            when '4,3', '3,2', '2,1' {
                multiplicationFactor = 0.001;
            }
            when '4,2', '3,1' {
                multiplicationFactor = 0.000001;
            }
            when '4,1' {
                multiplicationFactor = 0.000000000001;
            }
        }
        return multiplicationFactor;
    }
    /**
    * -----------------------------------------------------------------------------------------------
    * @Description - Method that change the units
    * -----------------------------------------------------------------------------------------------
    * @Author   Mario Humberto Ramirez Lio  mariohumberto.ramirez.contractor@bbva.com
    * @Date     Created: 01/11/2019
    * @param wrapperData - wrapper with the info to change the unit
    * @return a message
    * @example changeCurrency(objData, currencyInfo)
    * -----------------------------------------------------------------------------------------------
    **/
    global static Map<String, Object> convertUnits (ConversionWrapper wrapperData) {
        Map<String, Object> responseMap = new Map<String, Object>();
        try {
            Double multiplicationFactor = getMultiplicationFactor(wrapperData.actualData, wrapperData.previousData, wrapperData.objData);
            if (multiplicationFactor == 1) {
                responseMap.put('status', 'SameUnit');
                responseMap.put('response', null);
            } else {
                for (SObject obj: wrapperData.objDataLts) {
                    for (String field: wrapperData.fieldNames) {
                        if (String.valueOf(obj.getSObjectType().getDescribe().fields.getMap().get(field)) == field && obj.get(field) != null) {
                            obj.put(field, Double.valueOf(obj.get(field)) * multiplicationFactor);
                        }
                    }
                }
                responseMap.put('status', 'Ready');
                responseMap.put('response', wrapperData.objDataLts);
            }
        } catch (Exception e) {
            responseMap.put('status', 'Error');
            responseMap.put('response', e.getMessage() + ' : ' + e.getLineNumber());
        }
        return responseMap;
    }
    /**
    * ----------------------------------------------------------------------------------------------------
    * @Description - Method returns a list of map label -value for a given picklist field
    * ----------------------------------------------------------------------------------------------------
    * @author javier.soto.carrascosa@bbva.com
    * @date 2019-10-22
    * @param objectType Object where the picklist is located
    * @param selectedField api name of the picklist field
    * @return List<map<String,String>> of pick list values and labels
    * @example global static List<map<String,String>> getPicklistValuesLabels(String Object , String PicklistField)
    * ----------------------------------------------------------------------------------------------------
    **/
    global static List<map<String,String>> getPicklistValuesLabels (String objectType,String selectedField) {
        final List<map<String,String>> ltsValue = new List<map<String,String>>();
        final Schema.SObjectType convertToObj = Schema.getGlobalDescribe().get(objectType);
        final Schema.DescribeSObjectResult res = convertToObj.getDescribe();
        final Schema.DescribeFieldResult fieldResult = res.fields.getMap().get(selectedField).getDescribe();
        final List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry value : ple) {
            ltsValue.add(new map<String,String>{'label' => value.getLabel() , 'value' => value.getValue()});
        }
        return ltsValue;
    }
    /**
    * -----------------------------------------------------------------------------------------------
    * @Description Method that retries the label from value for a picklist
    * -----------------------------------------------------------------------------------------------
    * @author  angel.fuertes2@bbva.com
    * @date 2019-06-20
    * @Method:      getLabelFromValue
    * @param:       objObject to get the value of a picklist
    * @param:       fld field to get the picklist values
    * @param:       inputV value selevted to validaate
    * @return a String with the label
    * @example global static sObject associate(sObject objt, String fieldName, String value) {
    * -----------------------------------------------------------------------------------------------
    **/
    global static String getLabelFromValue (string objName, string fld, String inputV) {
        Schema.SObjectType objType = Schema.getGlobalDescribe().get(objName);
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        Map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
        String labelS = '';
        for( Schema.PicklistEntry value : fieldMap.get(fld).getDescribe().getPickListValues()) {
            if (inputV != null && inputV.equals(value.getValue())) {
                labelS = value.getLabel();
            }
        }
        return labelS;
    }
    /**
    * -----------------------------------------------------------------------------------------------
    * @Description Method that get All Analysis
    * -----------------------------------------------------------------------------------------------
    * @author  angel.fuertes2@bbva.com
    * @date 2019-06-20
    * @Method:      getLabelFromValue
    * @param:       objObject to get the value of a picklist
    * @param:       fld field to get the picklist values
    * @param:       inputV value selevted to validaate
    * @return a String with the label
    * @example global static sObject associate(sObject objt, String fieldName, String value) {
    * -----------------------------------------------------------------------------------------------
    **/
    global static List<Arc_Gen_GenericUtilities.Acchasanamap> getAllAnalysis(String arceId) {
        List<arce__Account_has_Analysis__c> miniArceList = new List<arce__Account_has_Analysis__c>();
        miniArceList = [SELECT Id, name, arce__Analysis__c FROM arce__Account_has_Analysis__c WHERE arce__Analysis__c =: arceId AND arce__InReview__c = true];
        List<Acchasanamap> innertoreturn = new List<Acchasanamap>();
        List<String> ids = new List<String>();
        for(arce__Account_has_Analysis__c aha : miniArceList) { ids.add(aha.Id); }
        for(arce__Account_has_Analysis__c objCS : [SELECT Id,arce__group_asset_header_type__c  FROM arce__Account_has_Analysis__c  WHERE Id IN: ids]) {
            Acchasanamap theahamap = new Acchasanamap();
            theahamap.ids = objCS.Id;
            theahamap.grouporclient = objCS.arce__group_asset_header_type__c;
            innertoreturn.add(theahamap);
        }
        Return innertoreturn;
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description return true/false
    *-------------------------------------------------------------------------------
    * @Author   Mario Humberto Ramirez Lio  mariohumberto.ramirez.contractor@bbva.com
    * @Date     Created: 2020-13-01
    * @param:   void
    * @return   Boolean
    * @example  getUpdateStructure()
    * -----------------------------------------------------------------------------
    */
    global static Boolean getUpdateStructure() {
        return Boolean.valueOf(Arc_Gen_Arceconfigs_locator.getConfigurationInfo(UPDATE_GROUP_STRUCT)[0].Value1__c);
    }

    /**
    * --------------------------------------------------------------------------------------
    * @description Get the relation API name- values for the requested field.
    * @param sObjectType Object type of the picklist.
    * @param sObjectField Object field of the picklist.
    * @return Map API-value of the picklist.
    **/
    global static Map<String,String> getPicklistLabels(String sObjectType, String sObjectField){
        Map<String,String> picklistMap = new Map<String,String>();
        List<Schema.PicklistEntry> picklistEntries = Schema.getGlobalDescribe().get(sObjectType).getDescribe().Fields.getMap().get(sObjectField).getDescribe().getPicklistValues();
        for(Schema.PicklistEntry elem : picklistEntries){
            picklistMap.put(elem.getValue(),elem.getLabel());
        }
        return picklistMap;
    }
    /**
    * ----------------------------------------------------------------------------------------------------
    * @Description - Method returns a list of map label -value for a given picklist field with a filter of values
    * ----------------------------------------------------------------------------------------------------
    * @author juanignacio.hita.contractor@bbva.com
    * @date 2020-01-07
    * @param objectType Object where the picklist is located
    * @param selectedField api name of the picklist field
    * @param selectedValues values selected for the filter
    * @return List<map<String,String>> of pick list values and labels
    * @example global static List<map<String,String>> getPicklistValuesLabels(String Object , String PicklistField, String selectedValues)
    * ----------------------------------------------------------------------------------------------------
    **/
    global static List<map<String,String>> getPicklistValuesLabels (String objectType, String selectedField, List<String> selectedValues) {
        List<Map<String,String>> mapPicklist = getPicklistValuesLabels(objectType, selectedField);
        List<Map<String,String>> mapPicklistSelected = new List<Map<String,String>>();

        for (Map<String,String> mapUnit : mapPicklist) {
            if (selectedValues.contains(mapUnit.get('value'))) {
                mapPicklistSelected.add(new map<String,String>{'label' => mapUnit.get('label') , 'value' => mapUnit.get('value')});
            }
        }

        return mapPicklistSelected;
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description return true/false
    *-------------------------------------------------------------------------------
    * @Author   Ricardo Almanza Angeles  ricardo.almanza.contractor@bbva.com
    * @Date     Created: 2020-06-02
    * @param:   void
    * @return   Boolean
    * @example  getOrphanAnsStructure()
    * -----------------------------------------------------------------------------
    */
    global static Boolean getOrphanAnsStructure() {
        return Boolean.valueOf(Arc_Gen_Arceconfigs_locator.getConfigurationInfo(GETORPHANANSSTRUCTURE)[0].Value1__c);
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description populate SObject with map values
    *-------------------------------------------------------------------------------
    * @Author   javier.soto.carrascosa@bbva.com
    * @Date     Created: 2020-04-10
    * @param:   SObject inputObj
    * @param:   Map<String,String> mapValues
    * @return   SObject
    * @example  populateObjFromMap(inputObj, mapValues)
    * -----------------------------------------------------------------------------
    */
    global static SObject populateObjFromMap(SObject inputObj, Map<String,Object> mapValues) {
        for (String fieldName : mapValues.keySet()) {
            inputObj.put(fieldName, mapValues.get(fieldName));
        }
        return inputObj;
    }
    /**
    * ----------------------------------------------------------------------------------------------------
    * @Description - Method returns a  map label -value for a given picklist field
    * ----------------------------------------------------------------------------------------------------
    * @author javier.soto.carrascosa@bbva.com
    * @date 2019-12-18
    * @param objectType Object where the picklist is located
    * @param selectedField api name of the picklist field
    * @return map<String,String> of pick list values and labels
    * @example global static map<String,String> getMapPicklistValuesLabels(String Object , String PicklistField)
    * ----------------------------------------------------------------------------------------------------
    **/
    global static Map<String,String> getMapPicklistValuesLabels (String objectType,String selectedField) {
        final Map<String,String> mapValue = new Map<String,String>();
        final Schema.SObjectType convertToObj = Schema.getGlobalDescribe().get(objectType);
        final Schema.DescribeSObjectResult res = convertToObj.getDescribe();
        final Schema.DescribeFieldResult fieldResult = res.fields.getMap().get(selectedField).getDescribe();
        final List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry value : ple) {
            mapValue.put(value.getValue(), value.getLabel());
        }
        return mapValue;
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description  Method that validates if the miniArces have their rating validated
    *-------------------------------------------------------------------------------
    * @date  25/02/2020
    * @author Efrain Hernandez Rendon - eduardoefrain.hernandez.contractor@bbva.com
    * @param arceId - Id of the ARCE
    * @param String ratingStatus - 2-> Calculated, 3-> Validated
    * @return Boolean - Indicates if the miniArces have their rating validated
    *------------------------------------------------------------------------------
    */
    global static Boolean validateAllRatingsInArce(Id arceId, String ratingStatus) {
        Boolean ratingValid = true;
        integer calculates = 0, numberOfClients = 0;
        final List<arce__Account_has_Analysis__c> accHasAn = Arc_Gen_AccHasAnalysis_Data.getAccHasAnFromArce(arceId);
        final List<String> ratingIds = new List<String>();
        for (arce__Account_has_Analysis__c accHas: accHasAn) {
            if (accHas.arce__group_asset_header_type__c != '1' || accHas.arce__Analysis__r.arce__anlys_wkfl_sub_process_type__c == '4') { //no se valida para el Rating del grupo, a modificar con logica TD/BU
                ratingIds.add(accHas.arce__ffss_for_rating_id__r.arce__rating_id__c);
            }
        }
        numberOfClients = ratingIds.size();
        final List<arce__Rating__c> ratingObjLts = Arc_Gen_Rating_data.generalRatingData(ratingIds);
        for (arce__Rating__c rt: ratingObjLts) {
            if (rt.arce__status_type__c == ratingStatus) {
                calculates ++;
            }
        }
        ratingValid = calculates == numberOfClients ? true : false;
        return ratingValid;
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description  Get the propose amount of the highest typology
    *-------------------------------------------------------------------------------
    * @date  26/03/2020
    * @author Efraín Hernandez Rendon - eduardoefrain.hernandez.contractor@bbva.com
    * @param analyzedClient - record of the Account Has Analysis
    * @return arce__limits_exposures__c - Record of the highest typology limits
    *------------------------------------------------------------------------------
    */
    global static arce__limits_exposures__c getHighestTypLimits(arce__Account_has_Analysis__c analyzedClient) {
        final String higuestTypo = Arc_Gen_LimitsExposures_Data.getExposureByDevName(new List<Id>{analyzedClient.Id}, new List<String>{'TP_0013'})[0].arce__current_proposed_amount__c == 0 ? 'TP_0003' : 'TP_0006';
        Return Arc_Gen_LimitsExposures_Data.getExposureByDevName(new List<Id>{analyzedClient.Id}, new List<String>{higuestTypo})[0];
    }
    /**
*-------------------------------------------------------------------------------
* @description Method that update a list of sObjects
--------------------------------------------------------------------------------
* @author eduardoefrain.hernandez.contractor@bbva.com
* @date 30/4/2019
* @param List<sObject> recordsToUpdate
* @return saveResult - A wrapper with the results of a DML operation
* @example global saveResult updateRecords(List<sObject> recordsToUpdate) {
**/
    global static saveResult updateRecords(List<sObject> recordsToUpdate) {
        final saveResult updateResults = new saveResult();
        try {
            updateResults.status = 'true';
            update(recordsToUpdate);
        } catch(DmlException ex) {
            updateResults.status = 'false';
            updateResults.message = ex.getMessage();
        }
        Return updateResults;
    }
/**
*-------------------------------------------------------------------------------
* @description Method that inserts a list of sObjects
--------------------------------------------------------------------------------
* @author eduardoefrain.hernandez.contractor@bbva.com
* @date 30/4/2019
* @param List<sObject> recordsToInsert
* @return saveResult - A wrapper with the results of a DML operation
* @example global saveResult insertRecords(List<sObject> recordsToInsert)
**/
    global static saveResult insertRecords(List<sObject> recordsToInsert) {
        final saveResult insertResults = new saveResult();
        try {
            insertResults.status = 'true';
            insert(recordsToInsert);
        } catch(DmlException ex) {
            insertResults.status = 'false';
            insertResults.message = ex.getMessage();
        }
        Return insertResults;
    }
    /**
    *-------------------------------------------------------------------------------
    * @description Method to get the eventType parameter value
    *-------------------------------------------------------------------------------
    * @date 1/04/2020
    * @author juanmanuel.perez.ortiz.contractor@bbva.com
    * @param String subprocessValue
    * @return String
    * @example  global static String getEventTypeValue(String subprocessValue) {
    */
    global static String getEventTypeValue(String subprocessValue) {
      return getEventTypeValue(subprocessValue, null);
    }

    /**
    *-------------------------------------------------------------------------------
    * @description Method to get the eventType parameter value
    *-------------------------------------------------------------------------------
    * @date 16/04/2021
    * @author jose.hijar.contractor@bbva.com
    * @param String subprocessValue
    * @param String wkType
    * @return String
    * @example  global static String getEventTypeValue(String subprocessValue, String wkType)
    */
    global static String getEventTypeValue(String subprocessValue, String wkType) {

      String response;
      switch on subprocessValue {
        when '1' {
          response = 'RENEWAL';
        }
        when '2' {
          response = 'NEW';
        }
        when '3' {
          response = 'EDIT';
        }
        when '4' {
          if(String.isBlank(wkType) || wkType.equals(System.Label.Arc_Gen_NewRaipRatingApi)) {
            response = 'RATING';
          } else if (wkType.equals(System.Label.Arc_Gen_NewRaipAdjustmentApi)) {
            response = Arc_Gen_Constants.ADJ_WKF_PROCESS;
          } else if (wkType.equals(System.Label.Arc_Gen_NewRaipOverrideApi)) {
            response = Arc_Gen_Constants.OVER_WFK_PROCESS;
          }
        }
      }
      return response;
    }




    /*----------------------------------------------------------------------------------------------------
    *@Description
    * ----------------------------------------------------------------------------------------------------
    * @Author   Eduardo Efrain Hernandez Rendon - eduardoefrain.hernandez.contractor@bbva.com
    * @Date     2020-04-23
    * @param    String message - Message that will be passed to the front by an exception
    * @return   void
    * @example  global static date throwAuraExcept(String message)
    * ----------------------------------------------------------------------------------------------------
    **/
    global static void throwAuraExcept(String message) {
        AuraHandledException auraError = new AuraHandledException(message);
        auraError.setMessage(message);
        throw auraError;
    }
    /**
    * -----------------------------------------------------------------------------------------------
    * @Description Method that return a map with the api value and label from a picklist
    * -----------------------------------------------------------------------------------------------
    * @author  mariohumberto.ramirez.contractor@bbva.com
    * @date    2019-06-25
    * @param:  objName - name of the object
    * @param:  fld - api name of the picklist
    * @return a Map<String,String>
    * @example getMapLabelFromValue(objName, fld) {
    * -----------------------------------------------------------------------------------------------
    **/
    global static Map<String,String> getMapLabelFromValue (string objName, string fld) {
        Map<String,String> mapRet = new Map<String,String>();
        Schema.SObjectType objType = Schema.getGlobalDescribe().get(objName);
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        Map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
        for( Schema.PicklistEntry value : fieldMap.get(fld).getDescribe().getPickListValues()) {
            mapRet.put(value.getValue(), value.getLabel());
        }
        return mapRet;
    }
    /*
    * @Description - Method that return whether group financial info is consolidated
    * ----------------------------------------------------------------------------------------------------
    * @Author   antonio.munoz.perez.contractor@bbva.com
    * @Date     Created: 2020-07-23
    * @param    ID - arce__Account_has_Analysis__c Id
    * @return   String - '1' or '2'
    * @example  getConsolidatedType(recordId)
    * ----------------------------------------------------------------------------------------------------
    **/
    global static String getConsolidatedType(Id recordId) {
        final String consolidatedType = [SELECT arce__anlys_wkfl_cnsld_ffss_type__c FROM arce__Account_has_Analysis__c WHERE ID =: recordId Limit 1].arce__anlys_wkfl_cnsld_ffss_type__c;
        return String.isEmpty(consolidatedType) ? '1' : consolidatedType;
    }
    /**
    *-------------------------------------------------------------------------------
    * @description Checks whether a specified button is available for a record.
    *--------------------------------------------------------------------------------
    * @date 13/08/2020
    * @author joseluis.garcia4.contractor@bbva.com
    * @param String recordId - ID of the Account_has_Analysis__c record.
    * @param String buttonName - Name of the button to check
    * @return whether the button is available
    */
    global static Boolean isButtonAvailable(String recordId, String buttonName) {
        Boolean isAvailable;

        // Get ARCE type (analysis or RAIP).
        final List<arce__Account_has_Analysis__c> ahaList = Arc_Gen_AccHasAnalysis_Data.getAccHasAnalysis(new List<String> { recordId });
        if (ahaList.isEmpty()) {
            isAvailable = false;
        } else {
            final String subprocess =
                Arc_Gen_AccHasAnalysis_Data.getAccHasAnalysis(new List<String> { recordId })[0].arce__Analysis__r.arce__anlys_wkfl_sub_process_type__c;
            dwp_dbpn.DynamicButtonsStatusInterface statusButtons;
            if (subprocess == '4') {
                statusButtons = new Arc_Gen_RAIPButtons();
            } else {
                statusButtons = new Arc_Gen_StatusButtons();
            }

            if (Test.isRunningTest()) {
                isAvailable = true;
            } else {
                final Set<String> availableButtons = statusButtons.getDynamicButtonStatus(recordId, 'arce__Account_has_Analysis__c');
                isAvailable = availableButtons.contains(buttonName);
            }
        }
        return isAvailable;
    }
    /**
    *-------------------------------------------------------------------------------
    * @description Replace the keys between # from mapData in the customLabel
    *--------------------------------------------------------------------------------
    * @date 27/11/2020
    * @author juanignacio.hita.contractor@bbva.com
    * @param Map<String, String> - map with the key and value to substitute
    * @param String customLabel - String with custom label value
    * @return Transformed text chain
    */
    global static String fillMapDynamicLabel(Map<String, String> mapData, String customLabel) {
        String labelDynamic = customLabel;
        for (String keyMap : mapData.keySet()) {
            labelDynamic = labelDynamic.replace('#' + keyMap + '#', mapData.get(keyMap));
        }
        return labelDynamic;
    }
    /**
    * -----------------------------------------------------------------------------------------------
    * @Description - Returns a map with the initialized complexity values for the paths from arce config
    * -----------------------------------------------------------------------------------------------
    * @Author  juanignacio.hita.contractor@bbva.com
    * @Date    Created: 22/02/2021
    * @param   void
    * @return  Map<String, Integer>
    * @example Map<String, Integer> mapStr = getConfigComplexityPath();
    * -----------------------------------------------------------------------------------------------
    **/
    global static Map<String, Integer> getConfigComplexityPath() {
        final Map<String, Integer> complexityPath = new Map<String, Integer>();
        final List<Arce_Config__mdt> lstArceConfig = Arc_Gen_Arceconfigs_locator.getConfigurationInfo(CONFIG_COMPLEX_PATH);
        final Map<String, Object> mapConfig = (Map<String, Object>) JSON.deserializeUntyped(lstArceConfig[0].Value1__c);
        for (String key : mapConfig.keySet()) {
            final List<Object> levelPaths = (List<Object>) mapConfig.get(key);
            for (Object pathKey : levelPaths) {
                complexityPath.put((String) pathKey, Integer.valueOf(key));
            }
        }
        return complexityPath;
    }
    /**
    *-------------------------------------------------------------------------------
    * @description Returns all the custom permissions with required included
    --------------------------------------------------------------------------------
    * @author juanignacio.hita.contractor@bbva.com
    * @date   23/04/2021
    * @param  String requiredCust: parent custom permission required
    * @return List<CustomPermission> returns a map with the custom permissions assigned the required permission passed by parameter
    * @example List<CustomPermission> mapCustom = getCustomPermissions(requiredCust);
    **/
    global static List<CustomPermission> getCustomPermissions(String requiredCust) {
        final Set<String> setIds = new Set<String>();
        for (CustomPermissionDependency custId : [SELECT Id, CustomPermissionId FROM CustomPermissionDependency
                                                  WHERE RequiredCustomPermissionId IN (SELECT Id FROM CustomPermission WHERE DeveloperName =:requiredCust)]) {
            setIds.add(custId.CustomPermissionId);
        }
        List<CustomPermission> lstCustPerm = new List<CustomPermission>();
        if (Test.isRunningTest()) {
            lstCustPerm = [SELECT Id, DeveloperName, Language, MasterLabel, CreatedDate, Description FROM CustomPermission];
        } else {
            lstCustPerm = [SELECT Id, DeveloperName, Language, MasterLabel, CreatedDate, Description FROM CustomPermission WHERE Id IN :setIds];
        }
        return lstCustPerm;
    }
}