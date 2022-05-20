/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_Traceability
* @Author   Angel Fuertes Gomez - angel.fuertes2@bbva.com / BBVA DWP
* @Date     Created: 2019-05-14
* @Group    ARCE
* ------------------------------------------------------------------------------------------------
* @Description Class to record traceability events.
* ------------------------------------------------------------------------------------------------
* @Changes
*
* |2019-05-14 angel.fuertes2@bbva.com
*             Class creation.
* |2020-01-24 Add new methods
* |2020-02-28 juanignacio.hita.contractor@bbva.com
*             Remove methods deprecated (saveEvent, createEvent)
* |2020-12-04 juanignacio.hita.contractor@bbva.com
*             Add analysis_id__c in createTrace method
* -----------------------------------------------------------------------------------------------
*/
public without sharing class Arc_Gen_Traceability {
    /**
    *-------------------------------------------------------------------------------
    * @description builder to avoid error in sonar
    *-------------------------------------------------------------------------------
    * @author  angel.fuertes2@bbva.com
    * @date     14/05/2019
    * @Method      Arc_Gen_Traceability
    * @return      nothing.
    * @example     Arc_Gen_Traceability().
    */
    private Arc_Gen_Traceability() {
    }
    /**
    *-------------------------------------------------------------------------------
    * @description Method to save the events that occurred
    *-------------------------------------------------------------------------------
    * @author  javier.soto.carrascosa@bbva.com
    * @date    24/01/2010
    * @Method      saveTrace
    * @param       recordId - record id
    * @param       Map<String, String> auditAttr Map with traceabillity attributes
    * @param       Map<String, String> addInfo Map with specific ARCE traceability attributes
    * @return      dwp_cvad__Action_Audit__c
    * @example     public static dwp_cvad__Action_Audit__c saveTrace(Id recordId, Map<String, String> auditAttr, Map<String, String> addInfo)
    */
    public static dwp_cvad__Action_Audit__c saveTrace(Id recordId, Map<String, String> auditAttr, Map<String, String> addInfo) {
        final dwp_cvad__Action_Audit__c event = createTrace(recordId,auditAttr,addInfo);
        INSERT event;
        return event;
    }
    /**
    *-------------------------------------------------------------------------------
    * @description Method to create the events that occurred
    *-------------------------------------------------------------------------------
    * @author   javier.soto.carrascosa@bbva.com
    * @date     24/01/2010
    * @Method      createTrace
    * @param       recordId - record id
    * @param       Map<String, String> auditAttr Map with traceabillity attributes
    * @param       Map<String, String> addInfo Map with specific ARCE traceability attributes
    * @return      dwp_cvad__Action_Audit__c
    * @example     public dwp_cvad__Action_Audit__c createTrace(Id recordId, Map<String, String> auditAttr, Map<String, String> addInfo)
    */
    public static dwp_cvad__Action_Audit__c createTrace(Id recordId, Map<String, String> auditAttr, Map<String, String> addInfo) {
        dwp_cvad__Action_Audit__c event = NEW dwp_cvad__Action_Audit__c();
        event.dwp_cvad__action_audit_record_id__c = recordId;
        event.dwp_cvad__action_audit_type__c = 'Arc_Gen_Traceability';
        event.dwp_cvad__action_audit_object_api_name__c = String.valueOf(recordId.getSobjectType());
        event.dwp_cvad__action_audit_name__c = auditAttr.get('title');
        event.dwp_cvad__action_audit_user_id__c = UserInfo.getUserId();
        event.dwp_cvad__action_audit_style__c = auditAttr.get('style');
        event.dwp_cvad__audit_audit_comments__c = auditAttr.get('comments');
        event.dwp_cvad__action_audit_date__c = System.Now();
        event.anlys_wkfl_edit_br_level_type__c = addInfo.get('ambit');
        event.anlys_wkfl_stage_type__c = addInfo.get('stage');
        event.anlys_wkfl_status_stage_type__c = addInfo.get('status');
        event.button_unique_id__c = addInfo.get('action');
        event.analysis_id__c = auditAttr.get('analysisId');
        return event;
    }
    /**
    *-------------------------------------------------------------------------------
    * @description Method to create a Map with traceability attributes
    *-------------------------------------------------------------------------------
    * @author   javier.soto.carrascosa@bbva.com
    * @date     24/01/2010
    * @Method      genAuditAttr
    * @param       String title
    * @param       String style
    * @param       String comments
    * @param       String analysisId
    * @return      Map<String, String>
    * @example     public static Map<String, String> genAuditAttr(String title, String style, String comments)
    */
    public static Map<String, String> genAuditAttr(String title, String style, String comments, String analysisId) {
        Map<String, String> auditAttr = new Map<String, String>();
        auditAttr.put('title',title);
        auditAttr.put('style',style);
        auditAttr.put('comments',comments);
        auditAttr.put('analysisId',analysisId);
        return auditAttr;
    }
    /**
    *-------------------------------------------------------------------------------
    * @description Method to create a Map with workflow traceabilty attributes
    *-------------------------------------------------------------------------------
    * @author   javier.soto.carrascosa@bbva.com
    * @date     24/01/2010
    * @Method      genAuditAttr
    * @param       String title
    * @param       String style
    * @param       String comments
    * @return      Map<String, String>
    * @example     public static Map<String, String> genAuditAttr(String title, String style, String comments)
    */
    public static Map<String, String> genAuditWF(String ambit, String stage, String status, String action) {
        Map<String, String> addInfo = new Map<String, String>();
        addInfo.put('ambit',ambit);
        addInfo.put('stage',stage);
        addInfo.put('status',status);
        addInfo.put('action',action);
        return addInfo;
    }
}