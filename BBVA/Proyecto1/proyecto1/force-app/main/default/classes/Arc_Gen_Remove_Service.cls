/**
  * @File Name          : public with sharing class Arc_Gen_Remove_Service.cls
  * @Description        : Service class for remove function
  * @Author             : luisarturo.parra.contractor@bbva.com
  * @Group              : ARCE
  * @Last Modified By   : luisruben.quinto.munoz@bbva.com
  * @Last Modified On   : 23/7/2019 22:55:39
  * @Modification Log   :
  *==============================================================================
  * Ver         Date                     Author                 Modification
  *==============================================================================
  * 1.0    20/05/2019 12:50:32   luisarturo.parra.contractor@bbva.com         Initial Version
  * 1.1    21/06/2019 15:46:20   ismaelyovani.obregon.contractor@bbva.com     Sanction 1.0 Q3 Added Method that gets value of picklist.
  * 1.2    26/12/2019 14:50:29   juanmanuel.perez.ortiz.contractor@bbva.com   Add logic to send notifications.
  * 1.3    28/02/2020 09:15:00   juanignacio.hita.contractor@bbva.com         Added traceability to updateRemoveInfo
  * 1.4    03/03/2020 18:26:00   juanignacio.hita.contractor@bbva.com         Changed the object to create traceability
  * 1.5    13/05/2020 17:00:00   joseluis.garcia4.contractor@bbva.com         Change title of traceability audit.
  * 1.6    05/06/2020 17:00:00   juanignacio.hita.contractor@bbva.com         Changed labels in the messages traceability
  * 1.7    04/12/2020 10:17:00   juanignacio.hita.contractor@bbva.com         Adds aha name (analysisId) param in traceability record
  * 1.8    18/02/2021 10:00:00   joseluis.garcia4.contractor@bbva.com         Include call to action persistence service.
  * 1.9    20/02/2021 11:00:00   juanignacio.hita.contractor@bbva.com         Add traceability events funcionality in workflow
  * 1.10   30/04/2021 11:00:00   otiliaramona.veres.contractor@bbva.com       Added an empty constructor method.
  * 1.11   04/05/2021 13:00:00   otiliaramona.veres.contractor@bbva.com       Added annotation '@testVisible' to the empty constructor method.
  * 1.12   06/10/2021 14:00:00   saimassimilianno.jordana.contractor@         Condition added to updateRemoveInfo meth0d to avoid persistence call in SP2.
  **/
public with sharing class Arc_Gen_Remove_Service {
    /**
        * @Description: String with value for FINALIZED_ANALYSIS in ARCE
    */
    static final String FINALIZED_ANALYSIS = '10';
    /**
        * @Description: String with value for STAGE_CLOSED in ARCE
    */
    static final String STAGE_CLOSED = '3';
      /**
    *-------------------------------------------------------------------------------
    * @description Empty constructor method
    *-------------------------------------------------------------------------------
    *@author otiliaramona.veres.contractor@bbva.com
    *@Date   Created:2021-04-30
    */
    @TestVisible
    private Arc_Gen_Remove_Service() { }
    /**
    *-------------------------------------------------------------------------------
    * @description set new values for arce
    --------------------------------------------------------------------------------
    * @author luisarturo.parra.contractor@bbva.com
    * @date 20/05/2019
    * @param String record Id to be uptated
    * @param String reason to remove the arce
    * @return List < arce__Account_has_Analysis__c >
    * @example public static void updateStatusService(String recordId)
    **/
  public static void updateRemoveInfo(Id recordId,String reasonPick, String reasonDesc, String reasonPickLabel) {
    // Update status and create traceability record.
    arce__Analysis__c arceUp = arce.Arc_Gen_ArceAnalysis_Data.gerArce(recordId);

    // Get IRP WorkFLow field.
    final arce__Account_has_Analysis__c accHasAnalysis = arce.Arc_Gen_AccHasAnalysis_Data.getAccHasAnalysis(new List<String>{recordId})[0];
    final String wkIRP = accHasAnalysis.arce__IRP_Workflow__c;

    // Persist action into Oracle if the analysis belongs to enterprise.
    if (String.isEmpty(wkIRP)) {
      arce.Arc_Gen_ActionsPersistence_Service.persistArceAction(arceUp.Id, arce.Arc_Gen_ActionsPersistence_Service.ACTION_DISCARD);
    }

    arceUp.put('arce__wf_status_id__c', FINALIZED_ANALYSIS);
    arceUp.put('arce__Stage__c', STAGE_CLOSED);
    arceUp.put('arce__anlys_wkfl_discard_reason_id__c', reasonPick);
    arceUp.put('arce__anlys_wkfl_discard_reason_desc__c', reasonDesc);
    final List<arce__Analysis__c> arceList = New List<arce__Analysis__c>();
    arceList.add(arceUp);

    // Create current action traceability event record
    Arc_Gen_TraceabilityEvents.Arc_Gen_Traceability_Wrapper wkflWrapper = new Arc_Gen_TraceabilityEvents.Arc_Gen_Traceability_Wrapper(null, accHasAnalysis, arceUp, 'REMOVE');
    wkflWrapper.mapReqAction.put('arce__anlys_wkfl_discard_reason_id__c', reasonPick);
    wkflWrapper.mapReqAction.put('arce__anlys_wkfl_discard_reason_desc__c', reasonDesc);
    wkflWrapper = Arc_Gen_TraceabilityEvents.saveTraceEvent(wkflWrapper);

    arce.Arc_Gen_ArceAnalysis_Data.updateArce(arceList);

    final string traceComments = Label.Cls_arce_ReturnReason + ' ' + reasonDesc;
    final Map<String, String> auditAttr = Arc_Gen_Traceability.genAuditAttr(System.Label.Arc_Gen_ArceRemoveTitle, 'deny', traceComments.abbreviate(255), accHasAnalysis.Name);
    final Map<String, String> auditWF = new Map<String, String>();
    Arc_Gen_Traceability.saveTrace(arceUp.Id, auditAttr, auditWF);

    // Insert new trace record and last update
    Arc_Gen_TraceabilityEvents.updateTraceEvents(wkflWrapper);

    arce.Arc_Gen_GenericUtilities.createNotifications(Arc_Gen_Notifications_Service.getUsersIds(arceUp.Id), arceUp.Id, System.Label.Arc_Gen_ArceRemove + ': ' + arceUp.Name);
  }
    /**
    *-------------------------------------------------------------------------------
    * @description Method that gets value of picklist.
    --------------------------------------------------------------------------------
    * @author ismaelyovani.obregon.contractor@bbva.com
    * @date 21/06/2019
    * @params String varObject  name for the object
    * @params String varField name from the field to get pick list values
    * @return List<map<String,String>> of picklist values
    * @example public static List<map<String,String>> getPickListValue()
    **/
  public static List<map<String,String>> getDiscardReasons() {
      return arce.Arc_Gen_GenericUtilities.getPicklistValuesLabels('arce__Analysis__c','arce__anlys_wkfl_discard_reason_id__c');
  }
}