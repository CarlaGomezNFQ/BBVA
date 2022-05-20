/*----------------------------------------------------------------------------------
    Author:        BBVA
    Company:       BBVA
    Description:   SER_DiscardTaskEGS controller.

    History:
      <Date>          <Author>             <Description>
    28/07/2020     Cintia Carmona        Initial version
    -----------------------------------------------------------------------------------*/
public without sharing class SER_DiscardTaskEGS_CONTROLLER {

  /*Constante STACKTRACE*/
  public static final String STACKTRACE = ' , StackTrace: ';

  /**
    * description: Private Constructor
    */
  private SER_DiscardTaskEGS_CONTROLLER() {
  }

  /**
    * description: showButton
    * Params       Id caseId
    * Return       String
    **/
  @AuraEnabled
  public static String showButton(Id taskId) {
    Task tarea;
    tarea = new Task();
    try {
      tarea = [SELECT Status FROM Task WHERE Id = :taskId];  //NOSONAR
    } catch (Exception exc) {
      String errorMessage;
      errorMessage = STACKTRACE + exc.getStackTraceString();
      throw new AuraHandledException(Label.SER_Error_Server + ' ' + exc + ' ' + errorMessage);
    }
    return tarea.Status;
  }

  /**
    * description: saveDiscardCtr
    * Params       Id caseId
    * Return       string
    **/
  @AuraEnabled
  public static String saveDiscardCtr(Id taskId) {
    String response;
    response = '';
    Task tarea;
    tarea = new Task();
    String statusRemedy;
    statusRemedy = '';

    try {

      	tarea = [SELECT Id, gf_spec_task_op_case_ind_type__c, Status, Priority, TaskComment__r.gf_action_result_desc__c,
              TaskComment__r.Id, departament_name__c, incidence_id__c, Skip_Validations__c, gf_task_id__c,
              gf_tech_impact_case_name__c, SER_Discarded_Duplicated__c FROM Task WHERE Id = :taskId];


        if (String.isNotBlank(tarea.incidence_id__c)) {
        	//Si la tarea tiene remedy, vamos a guardar su status antes de cerrarlo por si falla y hay que reabrirlo
        	statusRemedy = tarea.Status;
        	//Y una vez guardado, llamamos a cerrar la tarea y a cerrar el remedy
      		closeTask(tarea);
      		//Se cierra el remedy
      		closeRemedy(tarea, statusRemedy);
        } else {
        	//Si la tarea no tiene remedy, simplemente la cerramos
      		closeTask(tarea);
        }


    } catch (Exception exc) {
      String errorMessage;
      errorMessage = STACKTRACE + exc.getStackTraceString();
      throw new AuraHandledException(Label.SER_Error_Server + ' ' + exc + ' ' + errorMessage);
    }

    return response;
  }

  /*---------------------------------------------------------------------------------------
      Company:       BBVA.
      Description:   Cierra las tareas.

      IN:            List<Task> taskList.
      OUT:           Void.
  ---------------------------------------------------------------------------------------*/
  public static void closeTask(Task tarea) {

    List<TaskComment__c> ltaList;
    ltaList = new List<TaskComment__c>();

    if(String.isBlank(tarea.TaskComment__r.gf_action_result_desc__c)) {
    	//Si no tiene solucion le ponemos una solución generica
        ltaList.add(new TaskComment__c(Id = tarea.TaskComment__r.Id, gf_action_result_desc__c = Label.SER_Discard_Task_AuthomaticSolution));
    }
    if(String.isNotBlank(tarea.incidence_id__c) && tarea.Status != SER_Constant.COMPLETED) {
        //Ponemos Skip validations a true para saltarnos las validaciones.
        tarea.Skip_Validations__c = true;
    }
    if(String.isBlank(tarea.gf_tech_impact_case_name__c)) {
        tarea.gf_tech_impact_case_name__c = '5. No Impact';
    }
    tarea.Status = SER_Constant.COMPLETED;
    tarea.SER_Discarded_Duplicated__c = true;
    tarea.RecordTypeId = SER_RecordTypeUtils.getRecordTypeByName('Task', 'SER_Close_Task_EGS');

    if(ltaList.isEmpty() == false) {
      update ltaList;
    }
    //Una vez dada de alta la solución genérica, se modifican los campos de la tarea para dejarla completada
    update tarea;

    //Reseteamos Skip Validations.
    if(tarea.Skip_Validations__c) {
    	tarea.Skip_Validations__c = false;
    }

    update tarea;
  }

  /*-------------------------------------------------------------------------------------------
      Company:       BBVA
      Description:   Cierra los remedys. Proceso Syncrono.

      IN:            Task.
      IN:            Map<Id, String> remedyStatuses.
      IN:            String caseNumber.
      OUT:           Void.
  ---------------------------------------------------------------------------------------------*/
  private static void closeRemedy(Task tarea, String remedyStatus) {
    Map<String, String> taskInfo;
    taskInfo = new Map<String, String>();

    taskInfo.put('Id', tarea.Id);
    taskInfo.put('Priority', tarea.Priority);
    taskInfo.put('Solution', String.isNotBlank(tarea.TaskComment__r.gf_action_result_desc__c) ? tarea.TaskComment__r.gf_action_result_desc__c : Label.SER_Discard_Task_AuthomaticSolution);
    taskInfo.put('Department', tarea.departament_name__c);
    taskInfo.put('taskNumber', tarea.gf_task_id__c);
    System.debug('taskInfo: ' + taskInfo);
    closeRemedy(taskInfo, remedyStatus);
  }

  /*-------------------------------------------------------------------------------------------
      Company:       BBVA
      Description:   Cierra los remedys.

      IN:            Map<String, String> taskInfo.
      IN:            Map<Id, String> remedyStatuses.
      OUT:           String.
  ---------------------------------------------------------------------------------------------*/
  @future (callout=true)
  private static void closeRemedy(Map<String, String> taskInfo, String remedyStatus) {
    try {
      String response;
      response = '';
      //Llamamos al servicio para cerrar los Tickets.
      response = SER_RTM_Task_CallWS.submitTicket(taskInfo.get('Id'), UserInfo.getUserId(), taskInfo.get('Priority'), taskInfo.get('Solution'), SER_CallRemedyWS_Task_HELPERLGT.CLOSEREMEDY, taskInfo.get('Department'), false, '', false);

      //Si algo va mal se llama a manageCloseErrors.
      if(String.isNotBlank(response) && response.substring(0, 5).equalsIgnoreCase('ERROR')) {
        manageCloseErrors(taskInfo, response.substring(5), remedyStatus);
      }
    } catch (Exception exc) {

      //Si algo va mal se llama a manageCloseErrors.
      manageCloseErrors(taskInfo, 'Cause: ' + exc.getCause() + ', message: ' + exc.getMessage() + ', stack trace: ' + exc.getStackTraceString(), remedyStatus);
    }
  }

  /*-------------------------------------------------------------------------------------------
      Company:       BBVA
      Description:   Si algo falla en la llamada a remedy para el cierre del ticket
                      se reabre la tarea asociada al Remedy y notificamos al usuario.

      IN:            Map<String, String> taskInfo.
      IN:            String errorMessage.
      IN:            String remedyStatus.
      OUT:           Void.
  ---------------------------------------------------------------------------------------------*/
  private static void manageCloseErrors(Map<String, String> taskInfo, String errorMessage, String remedyStatus) {
    Task taskToReopen;

    //Notificamos al usuario
    Id notifiTypeId;
    notifiTypeId = [SELECT Id FROM CustomNotificationType WHERE DeveloperName = 'SER_EGS_Close_Case_Error'].Id;
    Http http;
    http = new Http();
    HttpRequest req;
    req = new HttpRequest();
    req.setEndpoint(Url.getOrgDomainUrl().toExternalForm()
        + '/services/data/v46.0/actions/standard/customNotificationAction');
    req.setMethod('POST');
    req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
    req.setHeader('Content-Type', 'application/json');
    CustomNotificationActionInput input;
    input = new CustomNotificationActionInput();
    input.customNotifTypeId = notifiTypeId;
    input.recipientIds = new List<String>{UserInfo.getUserId()};
    input.title = Label.SER_EGS_Discard_Error_Notification_Tittle;
    input.targetId = notifiTypeId;
    input.body = Label.SER_EGS_Discard_Error_Notification_Body.replace('#', taskInfo.get('taskNumber'));
    CustomNotificationAction action;
    action = new CustomNotificationAction();
    action.inputs = new List<CustomNotificationActionInput>{input};
    req.setBody(JSON.serialize(action));
    HttpResponse res;
    res = http.send(req);
    System.debug(res.getBody());


    //Si hay mensaje de error guardamos un log.
    if(String.isNotBlank(errorMessage)) {
      saveLog('ERROR: SER_DiscardTaskEGS_CONTROLLER.closeRemedy', String.valueOf(taskInfo.get('Id')), String.valueOf(UserInfo.getUserId()), errorMessage);
    }
    if(taskInfo.get('Id') != null) {
      //Reabrimos la tarea.
      taskToReopen = [SELECT Id, Status, RecordTypeId, SER_Discarded_Duplicated__c, gf_task_id__c FROM Task WHERE Id = :taskInfo.get('Id')];
      taskToReopen.RecordTypeId = SER_RecordTypeUtils.getRecordTypeByName('Task', 'SER_Task_EGS');
      taskToReopen.Status = remedyStatus;
      taskToReopen.SER_Discarded_Duplicated__c = false;

      //ponemos Skip validations a true para saltarnos las validaciones.
      taskToReopen.Skip_Validations__c = true;
      update taskToReopen;

      //Reseteamos Skip Validations.
      taskToReopen.Skip_Validations__c = false;
      update taskToReopen;
    }
  }

  /*---------------------------------------------------------------------------------------
      Company:       BBVA
      Description:   saveLog.

      IN:            String subject.
      IN:            String recordId.
      IN:            String remedyUser.
      IN:            String errMsg.
      OUT:           Void.
  ---------------------------------------------------------------------------------------*/
  @AuraEnabled
  public static void saveLog(String subject, String recordId, String remedyUser, String errMsg) {
    try {
      CIB_LogUtils.create_RemedyErrorLog(subject, recordId, remedyUser, errMsg);
    } catch(Exception exc) {
      System.debug('An error occurred while saving the CIB_Log: ' + exc);
    }
  }

  /**********************************************************
  *****************    CLASES INTERNAS    *******************
  **********************************************************/
  /*
  * @Description: CustomNotificationAction.
  */
  public class CustomNotificationAction {
    /* inputs */
    public List<CustomNotificationActionInput> inputs { get; set; }
  }

  /*
  * @Description: CustomNotificationActionInput.
  */
  public class CustomNotificationActionInput {
    /* customNotifTypeId */
    public String customNotifTypeId { get; set; }
    /* recipientIds */
    public List<String> recipientIds { get; set; }
    /* title */
    public String title { get; set; }
    /* body */
    public String body { get; set; }
    /* targetId */
    public String targetId { get; set; }
  }
}