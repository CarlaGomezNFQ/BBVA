/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_ArceAnalysis_Data
* @Author   Mario Humberto Ramirez Lio  mariohumberto.ramirez.contractor@bbva.com
* @Date     Created: 29/07/2019
* @Group    ARCE
* -----------------------------------------------------------------------------------------------
* @Description Data class for object arce__Analysis__c
* -----------------------------------------------------------------------------------------------
* @Changes
*
* |2019-07-29 mariohumberto.ramirez.contractor@bbva.com
*             Class creation.
* |2019-08-27 luisruben.quinto.munoz@bbva.com
*             Deletes reference to arce__id__c.
* |2019-09-25 mariohumberto.ramirez.contractor@bbva.com
*             Added new methods gerArce, getArceForTraceability getIdsOfChildAccount
* |2019-09-30 mariohumberto.ramirez.contractor@bbva.com
*             Added new method getIdsOfChildAccount
* |2019-10-29 eduardoefrain.hernandez.contractor@bbva.com
*             Added new wrapper for global workflow users
* |2019-11-20 javier.soto.carrascosa@bbva.com
*             Added new fields to gerArce
* |2019-12-06 luisarturo.parar.contractor@bbva.com
*             Added field arce__wf_status_id__c
* |2019-12-10 juanmanuel.perez.ortiz.contractor@bbva.com
*             Modified getArceAnalysisData and getWFUsers methods
* |2019-12-18 juanmanuel.perez.ortiz.contractor@bbva.com
*             Add new field arce__Temporal_status__c in getArceAnalysisData and changeStatusArce methods
* |2020-17-01 mariohumberto.ramirez.contractor@bbva.com
*             Change arce__Customer__r.ParentId for arce__group_asset_header_type__c in queries
* |2020-03-30 mariohumberto.ramirez.contractor@bbva.com
*             Added new field arce__proposal_in_prep_action_date__c in method getArceAnalysisData and added new method getLastSancArce
* |2020-03-30 eduardoefrain.hernandez.contractor@bbva.com
*             Add filter to getArcesFromAccounts selector method
* |2020-04-02 joseluis.garcia4.contractor@bbva.com
*             Refactor of New Analysis + RAIP modal
* |2020-04-05 ricardo.almanza.contractor@bbva.com
*             created getArceByRiskAssessm
* |2020-15-04 juanignacio.hita.contractor@bbva.com
*             Add fiedls gerArce method
* |2020-04-29 eduardoefrain.hernandez.contractor@bbva.com
*             Add fields to getArceAnalysisData method
* |2020-05-04 juanmanuel.perez.ortiz.contractor@bbva.com
*             Add fields in getArceAnalysisData method, create method called getArceAnalysisDataToModification
* |2020-05-14 cesaroctavio.villanueva.cebal@bbva.com
*             Added financial sponsor indicator field to arce query
* |2020-05-19 joseluis.garcia4.contractor@bbva.com
*             Add arce__anlys_wkfl_sub_process_type__c to getGroupId() query.
* |2020-06-16 juanmanuel.perez.ortiz.contractor@bbva.com
*             Remove field map in getArceAnalysisDataToModification method
* |2020-06-20 juanignacio.hita.contractor@bbva.com
*             Add arce__rating_prerating_type__c to gerArce method
* |2020-06-20 ricardo.almanza.contractor@bbva.com
*             Modified getArceByRiskAssessm to get arce by account has analysis
* |2020-08-12 mariohumberto.ramirez.contractor@bbva.com
*             Add arce__analysis_risk_expiry_date__c to getArcesFromAccounts(), getLatestArceOfType() methods
*             Add getLastSancArceNoVigorGp() method
* |2020-08-12 juanmanuel.perez.ortiz.contractor@bbva.com
*             Modified method called getArceAnalysisData to add field called arce__triageStatus__c
* |2020-08-12 javier.soto.carrascosa@bbva.com
*             Remove unused methods
* |2020-09-25 juanignacio.hita.contractor@bbva.com
*             Recover getGroupId method and remove auraEnabled
* |2020-12-29 joseluis.garcia4.contractor@bbva.com
*             Add arce__analysis_customer_relation_type__c to gerArce method.
* |2021-01-08 saimassimilianno.jordana.contractor@bbva.com
*             Modify getLatestArceOfType and getArceWCustomAcc methods for custom Account.
* |2021-02-21 luisdavid.rivera.ortiz@bbva.com
*             Eliminated unused fields
* |2021-02-23 juanignacio.hita.contractor@bbva.com
*             Add new fields to gerArce method
* |2021-04-16 jose.hijar.contractor@bbva.com
*             Add field arce__rating_prerating_type__c for query in method getArceAnalysisData
* |2021-04-23 juanignacio.hita.contractor@bbva.com
*             Add getAnlysFldRelatedAha method
* -----------------------------------------------------------------------------------------------
*/
@SuppressWarnings('sf:TooManyMethods, PMD.ExcessivePublicCount, sf:AvoidSoqlWithNegativeLogic')
global without sharing class Arc_Gen_ArceAnalysis_Data {
    /**
    * ----------------------------------------------------------------------------------------------------
    * @Description Void Constructor to avoid warning in sonar qube
    * ----------------------------------------------------------------------------------------------------
    * @Author   Mario Humberto Ramirez Lio  mariohumberto.ramirez.contractor@bbva.com
    * @Date     Created: 29/07/2019
    * @param void
    * @return void
    * @example Arc_Gen_ArceAnalysis_Data data = new Arc_Gen_ArceAnalysis_Data()
    * ----------------------------------------------------------------------------------------------------
    **/
    @TestVisible
    global Arc_Gen_ArceAnalysis_Data() {

    }
    /**
    * -----------------------------------------------------------------------------------------------
    * @Description - Method that return a list of all fields in arce__Analysis__c object
    * -----------------------------------------------------------------------------------------------
    * @Author   Eduardo Efrain Hernandez Rendon  eduardoefrain.hernandez.contractor@bbva.com
    * @Date     Created: 04/12/2019
    * @param riskAssessmentIds - List of ids of the risk assessment to consult
    * @return List<arce__Analysis__c> - List of arce analysis objects
    * @example getArceByRiskAssessm(arceLtsId)
    * -----------------------------------------------------------------------------------------------
    **/
    global static List<arce__Analysis__c> getArceByRiskAssessm(List<String> riskAssessmentIds) {
        Set<String> analysisId = new Set<String>();
        for (arce__Account_has_Analysis__c accsAn: [Select Id, Name, arce__Analysis__c from arce__Account_has_Analysis__c where name IN :riskAssessmentIds]) {
            analysisId.add(accsAn.arce__Analysis__c);
        }
        Return [SELECT Id,Name,OwnerId,arce__parent_analysis_id__c,arce__analysis_customer_relation_type__c,arce__anlys_wkfl_rturn_br_level_type__c,
                                            CurrencyIsoCode,arce__Group__c,arce__Group__r.Name,arce__bbva_committees_type__c,arce__Stage__c,
                                            arce__stage_collective_type__c,arce__wf_status_id__c,arce__anlys_wkfl_edit_br_level_type__c,arce__anlys_wkfl_user_edit_list_desc__c,
                                            arce__anlys_wkfl_committee_name__c,arce__anlys_wkfl_der_cmtee_list_desc__c,arce__anlys_wkfl_discard_reason_desc__c,
                                            arce__anlys_wkfl_discard_reason_id__c,arce__anlys_wkfl_der_br_level_type__c,arce__anlys_wkfl_return_reason_desc__c,
                                            arce__anlys_wkfl_sanction_rslt_type__c,arce__anlys_wkfl_sanction_rsn_desc__c,arce__anlys_wkfl_snctn_br_level_type__c,
                                            arce__anlys_wkfl_stage_type__c,arce__anlys_wkfl_status_stage_type__c,arce__anlys_wkfl_sub_process_type__c,arce__anlys_wkfl_edit_user_name__c
            FROM arce__Analysis__c
            WHERE Id IN :analysisId];
    }
    /**
    * -----------------------------------------------------------------------------------------------
    * @Description - Method that return a list of all fields in arce__Analysis__c object
    * -----------------------------------------------------------------------------------------------
    * @Author   Mario Humberto Ramirez Lio  mariohumberto.ramirez.contractor@bbva.com
    * @Date     Created: 29/07/2019
    * @param arceLtsId - List of ids of the arce__Account_has_Analysis__c object to consult
    * @return List<arce__Analysis__c> - List of all fields in arce__Analysis__c object
    * @example getArceAnalysisData(arceLtsId)
    * -----------------------------------------------------------------------------------------------
    **/
    global static List<arce__Analysis__c> getArceAnalysisData(List<Id> arceLtsId) {
        return [SELECT arce__triageStatus__c,arce__analysis_risk_expiry_date__c,Name,OwnerId,arce__proposal_in_prep_action_date__c,arce__anlys_wkfl_prev_user_name__c,
            arce__Temporal_status__c,arce__parent_analysis_id__c,arce__analysis_customer_relation_type__c,arce__anlys_wkfl_rturn_br_level_type__c,CurrencyIsoCode,arce__Group__c,
            arce__bbva_committees_type__c,arce__Stage__c,arce__stage_collective_type__c,arce__wf_status_id__c,
            arce__anlys_wkfl_edit_br_level_type__c,arce__anlys_wkfl_user_edit_list_desc__c,arce__anlys_wkfl_committee_name__c,arce__anlys_wkfl_der_cmtee_list_desc__c,
            arce__anlys_wkfl_discard_reason_desc__c,arce__anlys_wkfl_discard_reason_id__c,arce__anlys_wkfl_der_br_level_type__c,arce__anlys_wkfl_return_reason_desc__c,
            arce__anlys_wkfl_sanction_rslt_type__c,arce__anlys_wkfl_sanction_rsn_desc__c,arce__anlys_wkfl_snctn_br_level_type__c,arce__anlys_wkfl_stage_type__c,
            arce__anlys_wkfl_status_stage_type__c,arce__anlys_wkfl_sub_process_type__c,arce__anlys_wkfl_edit_user_name__c,arce__controlled_by_sponsor_type__c,
            arce__rating_prerating_type__c
            FROM arce__Analysis__c
            WHERE id = :arceLtsId];
    }
    /**
    * --------------------------------------------------------------------------------------
    * @Description Method that change the status of an Arce Analysis
    * --------------------------------------------------------------------------------------
    * @Author   Mario Humberto Ramirez Lio  mariohumberto.ramirez.contractor@bbva.com
    * @Date     Created: 29/07/2019
    * @param arceAccHasAn - arce__Account_has_Analysis__c object
    * @param analysis - arce__Analysis__c object
    * @param status - string with the desirable status
    * @return void
    * @example changeStatusArce(arceAccHasAn, analysis, status)
    * --------------------------------------------------------------------------------------
    **/
    global static void changeStatusArce(arce__Account_has_Analysis__c arceAccHasAn, arce__Analysis__c analysis, String status) {
        arceAccHasAn.arce__arce_ctmr_flag__c = false;
        arceAccHasAn.arce__anlys_wkfl_sbanlys_status_type__c = '1';
        analysis.arce__wf_status_id__c = status;
        analysis.arce__Temporal_status__c = false;
        upsert analysis;
        upsert arceAccHasAn;
    }
    /**
    * --------------------------------------------------------------------------------------
    * @Description Method that search the customer Id with arce Id
    * --------------------------------------------------------------------------------------
    * @Author   Angel Fuertes Gomez  angel.fuertes2@bbva.com
    * @Date     Created: 29/07/2019
    * @param analysis - arce__Analysis__c object id
    * @return object type arce__Analysis__c
    * @example  public static void changeStatusArce(String recordId)
    * --------------------------------------------------------------------------------------
    **/
    global static arce__Analysis__c getGroupId(String recordId) {
        return [select Id,arce__Group__c,arce__wf_status_id__c,arce__anlys_wkfl_sub_process_type__c from arce__Analysis__c where Id=: recordId limit 1];
    }
    /**
    * ---------------------------------------------------------------------------------------------------
    * @Description - Method to get arce
    * ---------------------------------------------------------------------------------------------------
    * @Author   Angel Fuertes Gomez - angel.fuertes2@bbva.com / BBVA DWP
    * @Date     Created: 2019-05-04
    * @param recordId - id of the arce
    * @return arce__Analysis__c object
    * @example gerArce(inputTerm)
    * ---------------------------------------------------------------------------------------------------
    **/
    global static arce__Analysis__c gerArce(String recordId){
        return [SELECT Id,Name,CreatedDate,arce__parent_analysis_id__c,ownerId,arce__anlys_wkfl_sub_process_type__c,arce__Stage__c,arce__wf_status_id__c,CreatedById,arce__bbva_committees_type__c,
        arce__anlys_wkfl_edit_br_level_type__c,arce__rating_prerating_type__c,arce__analysis_customer_relation_type__c,arce__anlys_wkfl_snctn_br_level_type__c,
        arce__gf_destination_path_id__c,arce__territory_name__c,arce__num_committes_sanction__c, arce__num_users_sanction__c,arce__anlys_arce_type__c
        FROM arce__Analysis__c WHERE id in (SELECT arce__Analysis__c FROM arce__Account_has_Analysis__c WHERE Id=:recordId)];
    }
    /**
    * ---------------------------------------------------------------------------------------------------
    * @Description - Method to updates arce_analysis__c
    * ---------------------------------------------------------------------------------------------------
    * @Author   javier.soto.carrascosa@bbva.com
    * @Date     Created: 2019-10-23
    * @param listArce - List<arce__Analysis__c>
    * @return arce__Analysis__c object
    * @example gerArce(inputTerm)
    * ---------------------------------------------------------------------------------------------------
    **/
    global static void updateArce (List<arce__Analysis__c> listArce) {
        if ( !listArce.isEmpty() ) {
            update listArce;
        }
    }
    /**
    * ---------------------------------------------------------------------------------------------------
    * @Description - Method to updates arce_analysis__c
    * ---------------------------------------------------------------------------------------------------
    * @Author   javier.soto.carrascosa@bbva.com
    * @Date     Created: 2019-10-23
    * @param listArce - List<arce__Analysis__c>
    * @return arce__Analysis__c object
    * @example gerArce(inputTerm)
    * ---------------------------------------------------------------------------------------------------
    **/
    global static List<arce__Analysis__c> insertArce (List<arce__Analysis__c> listArce) {
        if ( !listArce.isEmpty() ) {
            insert listArce;
        }
        return listArce;
    }
    /**
    * ---------------------------------------------------------------------------------------------------
    * @Description - Method to get Arces
    * ---------------------------------------------------------------------------------------------------
    * @Author   Mario Humberto Ramirez Lio  mariohumberto.ramirez.contractor@bbva.com
    * @Date     Created: 2020-13-01
    * @param AccountsIds - List<Id>
    * @return List<arce__Analysis__c> object
    * @example getArcesFromAccounts(AccountsIds)
    * ---------------------------------------------------------------------------------------------------
    **/
    global static List<arce__Analysis__c> getArcesFromAccounts(List<Id> accountsIds) {
        return [SELECT Name,OwnerId,arce__anlys_wkfl_prev_user_name__c,arce__Temporal_status__c,arce__parent_analysis_id__c,arce__analysis_customer_relation_type__c,arce__anlys_wkfl_rturn_br_level_type__c,CurrencyIsoCode,arce__Group__c,arce__bbva_committees_type__c,arce__Stage__c,arce__stage_collective_type__c,arce__wf_status_id__c,arce__anlys_wkfl_edit_br_level_type__c,arce__anlys_wkfl_user_edit_list_desc__c,arce__anlys_wkfl_committee_name__c,arce__anlys_wkfl_der_cmtee_list_desc__c,arce__anlys_wkfl_discard_reason_desc__c,arce__anlys_wkfl_discard_reason_id__c,arce__anlys_wkfl_der_br_level_type__c,arce__anlys_wkfl_return_reason_desc__c,arce__anlys_wkfl_sanction_rslt_type__c,arce__anlys_wkfl_sanction_rsn_desc__c,arce__anlys_wkfl_snctn_br_level_type__c,arce__anlys_wkfl_stage_type__c,arce__anlys_wkfl_status_stage_type__c,arce__anlys_wkfl_sub_process_type__c,arce__anlys_wkfl_edit_user_name__c,
                arce__analysis_risk_expiry_date__c
                FROM arce__Analysis__c
                WHERE arce__Group__c = :accountsIds AND arce__Stage__c != '3' AND arce__anlys_wkfl_sub_process_type__c != '4'
                ORDER BY CreatedDate DESC LIMIT 1];
    }

    /**
    * ---------------------------------------------------------------------------------------------------
    * @Description - Method to get the last active ARCE of a given subprocess type.
    * ---------------------------------------------------------------------------------------------------
    * @Author   joseluis.garcia4.contractor@bbva.com
    * @Date     Created: 2020-04-02
    * @param accountsIds
    * @param subProcessType
    * @return List<arce__Analysis__c> List with the latest arce of the specified type
    * ---------------------------------------------------------------------------------------------------
    **/
    global static List<arce__Analysis__c> getLatestArceOfType(List<Id> accountsIds, String subprocessType) {
        List<arce__Analysis__c> toReturn;
        toReturn = new List<arce__Analysis__c>();

        String analysisId = [SELECT Id, arce__Customer__c, arce__CustomAccountID__c, arce__Analysis__c
                FROM arce__Account_has_Analysis__c
                WHERE arce__Customer__c = :accountsIds AND arce__Analysis__r.arce__Stage__c != '3' AND arce__Analysis__r.arce__anlys_wkfl_sub_process_type__c = :subprocessType AND arce__CustomAccountID__c = null
                LIMIT 1]?.arce__Analysis__c;

        toReturn = analysisId != null ? [SELECT Name,OwnerId,arce__anlys_wkfl_prev_user_name__c,arce__Temporal_status__c,arce__parent_analysis_id__c,arce__analysis_customer_relation_type__c,arce__anlys_wkfl_rturn_br_level_type__c,CurrencyIsoCode,arce__Group__c,arce__bbva_committees_type__c,arce__Stage__c,arce__stage_collective_type__c,arce__wf_status_id__c,arce__anlys_wkfl_edit_br_level_type__c,arce__anlys_wkfl_user_edit_list_desc__c,arce__anlys_wkfl_committee_name__c,arce__anlys_wkfl_der_cmtee_list_desc__c,arce__anlys_wkfl_discard_reason_desc__c,arce__anlys_wkfl_discard_reason_id__c,arce__anlys_wkfl_der_br_level_type__c,arce__anlys_wkfl_return_reason_desc__c,arce__anlys_wkfl_sanction_rslt_type__c,arce__anlys_wkfl_sanction_rsn_desc__c,arce__anlys_wkfl_snctn_br_level_type__c,arce__anlys_wkfl_stage_type__c,arce__anlys_wkfl_status_stage_type__c,arce__anlys_wkfl_sub_process_type__c,arce__anlys_wkfl_edit_user_name__c, //NOSONAR
                    arce__analysis_risk_expiry_date__c
                    FROM arce__Analysis__c
                    WHERE id = :analysisId AND arce__Stage__c != '3' AND arce__anlys_wkfl_sub_process_type__c = :subprocessType
                    ORDER BY CreatedDate DESC LIMIT 1] : toReturn;

        return toReturn;
    }

    /**
    *-------------------------------------------------------------------------------
    * @description editAnalysisFields
    *--------------------------------------------------------------------------------
    * @date		09/01/2020
    * @author	juanignacio.hita.contractor@bbva.com
    * @param	analysisId : analysis arce id
    * @param    fieldValueMap : map of key value with the name of the field and value
    * @return	void
    * @example	Arc_Gen_Workflow_Data.updateAnalysisSctnLevel();
    */
    global static void editAnalysisFields(Id analysisId, Map<String, Object> fieldValueMap) {
        arce__Analysis__c analysis = [SELECT Id FROM arce__Analysis__c WHERE Id =: analysisId];
        for (String fieldName : fieldValueMap.keySet()) {
            analysis.put(fieldName, fieldValueMap.get(fieldName));
        }
        update analysis;
    }
    /**
    * --------------------------------------------------------------------------------------
    * @Description Get the last current and finished ARCE, filtered by the ARCE Id
    * --------------------------------------------------------------------------------------
    * @Author   mariohumberto.ramirez.contractor@bbva.com
    * @Date     Created: 2020-03-30
    * @param    analysis - arce__Analysis__c object id
    * @return   List<arce__Analysis__c>
    * @example  getLastSancArce(recordIds)
    * --------------------------------------------------------------------------------------
    **/

    global static List<arce__Analysis__c> getLastSancArce(Set<Id> recordIds) {
        return [SELECT id, Name, arce__analysis_risk_expiry_date__c, arce__anlys_wkfl_sub_process_type__c,arce__analysis_risk_sanction_date__c, arce__wf_status_id__c, arce__Stage__c, arce__anlys_wkfl_sanction_rslt_type__c FROM arce__Analysis__c
                WHERE id IN: recordIds
                AND (arce__anlys_wkfl_sanction_rslt_type__c = '1' OR arce__anlys_wkfl_sanction_rslt_type__c = '2' )
                AND ( arce__Stage__c = '3' )
                ORDER BY arce__analysis_risk_sanction_date__c DESC LIMIT 1];
    }
    /**
    * --------------------------------------------------------------------------------------
    * @Description To modificatio,get the last current and finished ARCE, filtered by the account Id
    * --------------------------------------------------------------------------------------
    * @Author   juanmanuel.perez.ortiz.contractor@bbva.com
    * @Date     Created: 2020-05-05
    * @param    analysis - arce__Analysis__c object id
    * @return   List<arce__Analysis__c>
    * @example  getLastSancArceByGroup(recordIds)
    * --------------------------------------------------------------------------------------
    **/
    global static List<arce__Analysis__c> getLastSancArceByGroup(Set<Id> recordIds) {
        return [SELECT id, Name, arce__analysis_risk_expiry_date__c, arce__anlys_wkfl_sub_process_type__c,arce__analysis_risk_sanction_date__c, arce__wf_status_id__c, arce__Stage__c, arce__anlys_wkfl_sanction_rslt_type__c FROM arce__Analysis__c
                WHERE arce__Group__c IN: recordIds
                AND (arce__anlys_wkfl_sanction_rslt_type__c = '1' OR arce__anlys_wkfl_sanction_rslt_type__c = '2' )
                AND ( arce__Stage__c = '3' )
                ORDER BY arce__analysis_risk_sanction_date__c DESC LIMIT 1];
    }
    /**
    * -----------------------------------------------------------------------------------------------
    * @Description - Method that return a list of all fields in arce__Analysis__c object to cloned ARCE
    * -----------------------------------------------------------------------------------------------
    * @Author   Juan Manuel Pérez Ortiz  juanmanuel.perez.ortiz.contractor@bbva.com
    * @Date     Created: 04/05/2020
    * @param arceLtsId - List of ids of the arce__Account_has_Analysis__c object to consult
    * @return List<arce__Analysis__c> - List of all fields in arce__Analysis__c object
    * @example getArceAnalysisDataToModification(arceLtsId)
    * -----------------------------------------------------------------------------------------------
    **/
    global static List<arce__Analysis__c> getArceAnalysisDataToModification(List<Id> arceLtsId) {
        return [SELECT Id,arce__analysis_risk_expiry_date__c,Name,RecordType.Name,RecordTypeId,OwnerId,arce__anlys_wkfl_prev_user_name__c,arce__Temporal_status__c,arce__parent_analysis_id__c,arce__analysis_customer_relation_type__c,arce__anlys_wkfl_rturn_br_level_type__c,CurrencyIsoCode,arce__Group__c,arce__Stage__c,arce__stage_collective_type__c,arce__wf_status_id__c,arce__anlys_wkfl_edit_br_level_type__c,arce__anlys_wkfl_user_edit_list_desc__c,arce__anlys_wkfl_committee_name__c,arce__anlys_wkfl_der_cmtee_list_desc__c,arce__anlys_wkfl_discard_reason_desc__c,arce__anlys_wkfl_discard_reason_id__c,arce__anlys_wkfl_der_br_level_type__c,arce__anlys_wkfl_return_reason_desc__c,arce__anlys_wkfl_sanction_rsn_desc__c,arce__anlys_wkfl_snctn_br_level_type__c,arce__anlys_wkfl_stage_type__c,arce__anlys_wkfl_status_stage_type__c,arce__anlys_wkfl_sub_process_type__c,arce__anlys_wkfl_edit_user_name__c,arce__territory_name__c
            FROM arce__Analysis__c
            WHERE id = :arceLtsId];
    }
    /**
    * --------------------------------------------------------------------------------------
    * @Description get the last no vigor finished ARCE
    * --------------------------------------------------------------------------------------
    * @Author   mariohumberto.ramirez.contractor@bbva.com
    * @Date     Created: 2020-07-07
    * @param    recordIds - set of arce__Analysis__c object id
    * @return   List<arce__Analysis__c>
    * @example  getLastSancArceNoVigorGp(recordIds)
    * --------------------------------------------------------------------------------------
    **/
    global static List<arce__Analysis__c> getLastSancArceNoVigorGp(Set<Id> recordIds) {
        return [SELECT id, Name, arce__analysis_risk_expiry_date__c, arce__anlys_wkfl_sub_process_type__c,arce__analysis_risk_sanction_date__c, arce__wf_status_id__c, arce__Stage__c, arce__anlys_wkfl_sanction_rslt_type__c FROM arce__Analysis__c
                WHERE arce__Group__c IN: recordIds
                AND (arce__anlys_wkfl_sanction_rslt_type__c = '1' OR arce__anlys_wkfl_sanction_rslt_type__c = '2' )
                AND ( arce__Stage__c = '3' )
                AND arce__analysis_risk_expiry_date__c <= TODAY
                ORDER BY arce__analysis_risk_sanction_date__c DESC LIMIT 1];
    }
    /**
    * --------------------------------------------------------------------------------------
    * @Description get fields list of analysis related with AHA record
    * --------------------------------------------------------------------------------------
    * @Author   juanignacio.hita.contractor@bbva.com
    * @Date     Created: 2021-04-23
    * @param    ahaId - arce__Account_has_Analysis__c object id
    * @param    fieldList - fields list api name
    * @return   Map<String, Object> : map with api name field as key and value
    * @example  Map<String, Object> analysis = getAnlysFldRelatedAha(ahaId, fieldList);
    * --------------------------------------------------------------------------------------
    **/
    global static Map<String, Object> getAnlysFldRelatedAha(String ahaId, List<String> fieldList) {
        arce__Analysis__c result = null;   //NOSONAR
        if (!fieldList.isEmpty()) {
            final String fieldListStr = String.escapeSingleQuotes(String.join(fieldList, ','));
            final String query = 'SELECT ' + fieldListStr + ' FROM arce__Analysis__c WHERE Id in (SELECT arce__Analysis__c FROM arce__Account_has_Analysis__c WHERE Id= :ahaId) LIMIT 1';
            final List<SObject> resultList = Database.query(query);
            if (!resultList.isEmpty()) {
                result = (arce__Analysis__c) resultList[0];
            }
        }
        return result.getPopulatedFieldsAsMap();
    }
}