/***************************************************************************************
* @author       BBVA
* @date         20-02-2020
* @description  Helper de SER_CloseCaseEGS_CONTROLLER.

****************************************************************************************/
public with sharing class SER_CloseCaseEGS_HELPER {
  /*Constante 'Pending IT'*/
  public static final String PENDINGIT = 'Pending IT';
  /*Constante 'EGS_User'*/
  public static final String EGSUSER = 'EGS_User';
  /*Constante STACKTRACE*/
  public static final String TRUESTR = 'true';
  /*Constante 'discard'*/
  public static final String DISCARDSTR = 'discard';
  /*Constante 'yes'*/
  public static final String YESSRT = 'Yes';

  /*---------------------------------------------------------------------------------------
      Company:       BBVA
      Description:   Constructor privado.
  ---------------------------------------------------------------------------------------*/
  private SER_CloseCaseEGS_HELPER() {}

  /*---------------------------------------------------------------------------------------
      Company:       BBVA.
      Description:   Cierra las tareas.

      IN:            List<Task> taskList.
      IN:            Boolean discard.
      OUT:           Void.
  ---------------------------------------------------------------------------------------*/
  public static void closeTask(List<Task> taskList, Boolean discard) {
    List<TaskComment__c> ltaList;
    ltaList = new List<TaskComment__c>();
    for(Task tarea : taskList) {
      if(String.isBlank(tarea.TaskComment__r.gf_action_result_desc__c)) {
        //Si no tiene solucion le ponemos una solución generica
        ltaList.add(new TaskComment__c(Id = tarea.TaskComment__r.Id, gf_action_result_desc__c = Label.SER_EGS_Close_Case_AuthomaticSolution));
      }
      if(String.isNotBlank(tarea.incidence_id__c) && tarea.Status != SER_Constant.COMPLETED) {
        //Ponemos Skip validations a true para saltarnos las validaciones.
        tarea.Skip_Validations__c = true;
        tarea.open_closed_type__c = true;
      }
      if(String.isBlank(tarea.gf_tech_impact_case_name__c)) {
        tarea.gf_tech_impact_case_name__c = '5. No Impact';
      }
      tarea.Status = SER_Constant.COMPLETED;
      tarea.RecordTypeId = SER_RecordTypeUtils.getRecordTypeByName('Task', 'SER_Close_Task_EGS');
      tarea.SER_Discarded_Duplicated__c = discard;
    }
    if(ltaList.isEmpty() == false) {
      update ltaList;
    }
    update taskList;

    //Reseteamos Skip Validations.
    for(Task tarea : taskList) {
      if(tarea.Skip_Validations__c) {
        tarea.Skip_Validations__c = false;
      }
    }
    update taskList;
  }

  /*---------------------------------------------------------------------------------------
      Company:       BBVA.
      Description:   itera sobre las tareas con remedy y llama a closeRemedy por cada tarea.

      IN:            List<Task> taskList.
      IN:            Map<Id, String> remedyStatuses.
      IN:            Case caso.
      IN:            Boolean discard.
      OUT:           Void.
  ---------------------------------------------------------------------------------------*/
  public static void closeRemedys(Map<Task, Case> taskMap, Map<Id, String> remedyStatuses, Boolean discard) {
    for(Task tarea : taskMap.keySet()) {
      closeRemedySync(tarea, remedyStatuses, taskMap.get(tarea), discard);
    }
  }

  /*-------------------------------------------------------------------------------------------
      Company:       BBVA
      Description:   Cierra los remedys. Proceso Syncrono.

      IN:            Task.
      IN:            Map<Id, String> remedyStatuses.
      IN:            Case caso.
      IN:            Boolean discard.
      OUT:           Void.
  ---------------------------------------------------------------------------------------------*/
  private static void closeRemedySync(Task tarea, Map<Id, String> remedyStatuses, Case caso, Boolean discard) {
    Map<String, String> taskInfo;
    taskInfo = new Map<String, String>();
    taskInfo.put('Id', tarea.Id);
    taskInfo.put('Priority', tarea.Priority);
    String solution;
    solution = String.isNotBlank(tarea.TaskComment__r.gf_action_result_desc__c) ? tarea.TaskComment__r.gf_action_result_desc__c : Label.SER_EGS_Close_Case_AuthomaticSolution;
    taskInfo.put('Solution', solution);
    taskInfo.put('Department', tarea.departament_name__c);
    taskInfo.put('CaseNumber', caso.CaseNumber);
    taskInfo.put('taskNumber', tarea.gf_task_id__c);
    Boolean isMasterCase;
    isMasterCase = caso.SER_Is_Master_Case__c || caso.SER_Master_Case__c != null;
    String isMC;
    isMC = isMasterCase ? TRUESTR : 'false';
    taskInfo.put('isMasterCase', isMC);
    if(isMasterCase) {
      String caseNumber;
      caseNumber = caso.SER_Is_Master_Case__c ? caso.CaseNumber : caso.SER_Master_Case__r.CaseNumber;
      taskInfo.put('MasterCase', caseNumber);
    }
    taskInfo.put(DISCARDSTR, discard ? YESSRT : 'No');
    System.debug('taskInfo: ' + taskInfo);
    closeRemedy(taskInfo, remedyStatuses);
  }

  /*-------------------------------------------------------------------------------------------
      Company:       BBVA
      Description:   Cierra los remedys.

      IN:            Map<String, String> taskInfo.
      IN:            Map<Id, String> remedyStatuses.
      OUT:           String.
  ---------------------------------------------------------------------------------------------*/
  @future (callout=true)
  private static void closeRemedy(Map<String, String> taskInfo, Map<Id, String> remedyStatuses) {
    try {
      String response;
      response = '';
      //Llamamos al servicio para cerrar los Tickets.
      response = SER_RTM_Task_CallWS.submitTicket(taskInfo.get('Id'), UserInfo.getUserId(), taskInfo.get('Priority'), taskInfo.get('Solution'), SER_CallRemedyWS_Task_HELPERLGT.CLOSEREMEDY, taskInfo.get('Department'), false, '', true);

      //Si algo va mal se llama a manageCloseErrors.
      if(String.isNotBlank(response) && response.substring(0, 5).equalsIgnoreCase('ERROR')) {
        manageCloseErrors(taskInfo, response.substring(5), remedyStatuses, taskInfo.get(DISCARDSTR) == YESSRT ? true : false);
      }
    } catch (Exception exc) {

      //Si algo va mal se llama a manageCloseErrors.
      manageCloseErrors(taskInfo, 'Cause: ' + exc.getCause() + ', message: ' + exc.getMessage() + ', stack trace: ' + exc.getStackTraceString(), remedyStatuses, taskInfo.get(DISCARDSTR) == YESSRT ? true : false);
    }
  }

  /*-------------------------------------------------------------------------------------------
      Company:       BBVA
      Description:   Si algo falla en la llamada a remedy para el cierre de los tickets
                      se reabre la tarea asociada al Remedy y el caso y se manda una bell
                      notification. Notificamos al usuario.

      IN:            Map<String, String> taskInfo.
      IN:            String errorMessage.
      IN:            Map<Id, String> remedyStatuses.
      IN:            Boolean discard.
      OUT:           Void.
  ---------------------------------------------------------------------------------------------*/
  private static void manageCloseErrors(Map<String, String> taskInfo, String errorMessage, Map<Id, String> remedyStatuses, Boolean discard) {
    Task taskToReopen;

    //Notificamos al usuario
    Id notifiTypeId;
    notifiTypeId = [SELECT Id FROM CustomNotificationType WHERE DeveloperName = 'SER_EGS_Close_Case_Error'].Id;

    // Create a new custom notification
    Messaging.CustomNotification notification;
    notification = new Messaging.CustomNotification();

    // Set the contents for the notification
    notification.setTitle(Label.SER_EGS_Reopen_Error_Notification_Tittle);
    String body;
    body = Label.SER_EGS_Reopen_Error_Notification_Body.replace('*', taskInfo.get('CaseNumber'));
    if(taskInfo.get('isMasterCase') == TRUESTR) {
      body += ' Please, reopen Master Case ' + taskInfo.get('MasterCase') + ' because task ' + taskInfo.get('taskNumber') + ' could not be closed and contact your administrator.';
    } else {
      body += ' Please, reopen Case because task ' + taskInfo.get('taskNumber') + ' could not be closed and contact your administrator.';
    }
    notification.setBody(body);

    // Set the notification type and target
    notification.setNotificationTypeId(notifiTypeId);
    notification.setTargetId(taskInfo.get('Id'));

    // Actually send the notification
    try {
      notification.send(new Set<String>{UserInfo.getUserId()});
    } catch (Exception exc) {
      SER_CloseCaseEGS_CONTROLLER.saveLog('ERROR: SER_CloseCaseEGS_CONTROLLER.closeRemedy - Send Notification', String.valueOf(taskInfo.get('Id')), String.valueOf(UserInfo.getUserId()), exc.getMessage() + ' - ' + exc.getStackTraceString() + '. Error al intentar cerrar la tarea ' + taskInfo.get('Id'));
    }

    //Si hay mensaje de error guardamos un log.
    if(String.isNotBlank(errorMessage)) {
      SER_CloseCaseEGS_CONTROLLER.saveLog('ERROR: SER_CloseCaseEGS_CONTROLLER.closeRemedy', String.valueOf(taskInfo.get('Id')), String.valueOf(UserInfo.getUserId()), errorMessage);
    }

    if(taskInfo.get('Id') != null) {
      //Reabrimos la tarea.
      taskToReopen = [SELECT Id, WhatId, gf_task_id__c FROM Task WHERE Id = :taskInfo.get('Id')];
      taskToReopen.RecordTypeId = SER_RecordTypeUtils.getRecordTypeByName('Task', 'SER_Task_EGS');
      taskToReopen.Status = remedyStatuses.get(taskInfo.get('Id'));
      taskToReopen.open_closed_type__c = false;
      if(discard) {
        taskToReopen.SER_Discarded_Duplicated__c = false;
      }

      //ponemos Skip validations a true para saltarnos las validaciones.
      taskToReopen.Skip_Validations__c = true;
      update taskToReopen;
      taskToReopen.Skip_Validations__c = false;
      update taskToReopen;
    }
  }

  /*-------------------------------------------------------------------------------------------
      Company:      BBVA
      Description:  rellena el campo clasificacion del caso.

      IN:           Boolean discard.
      IN:           Case caso.
      OUT:          String.
  ---------------------------------------------------------------------------------------------*/
  public static String fillClassification(Boolean discard, Case caso) {
    String classification;
    if(discard) {
      classification = caso.SER_Initial_Classification__c;
    } else {
      classification = caso.SER_Classification__c;
    }
    return classification;
  }

  /*-------------------------------------------------------------------------------------------
      Company:      BBVA
      Description:  procesa los master case en su primera vuelta.

      IN:           Boolean discard.
      IN:           Case caso.
      OUT:          String.
  ---------------------------------------------------------------------------------------------*/
  public static String processMasterCase(List<Case> mCChildList, List<Task> taskList, Case caso, Boolean discard) {
    String response;
    response = '';

    //Booleano que controla si hay tareas abiertas de los casos hijos.
    Boolean hasOpenChildTsk;
    hasOpenChildTsk = false;
    for(Case childCase : mCChildList) {
      if(childCase.Tasks.isEmpty() == false) {
        hasOpenChildTsk = true;
        break;
      }
    }

    //Booleano que controla si hay tareas abiertas en el Master Case y en los hijos.
    Boolean hasTask;
    hasTask = hasOpenChildTsk || taskList.isEmpty() == false;

    //Si hay tareas abiertas se llama a fillMasterCaseResponse para crear el mensaje de la ventana modal.
    if(hasTask) {
      response = fillMasterCaseResponse(taskList, caso, hasOpenChildTsk, mCChildList);

    //Si no hay tareas abiertas incluimos el caso maestro en la lista de casos hijos y se llama a trateMasterCase para proceceder al cerrado.
    } else {
      SER_CloseCaseEGS_CONTROLLER.closeCase(caso.Id, true, false, discard);
    }

    return response;
  }


  /*-------------------------------------------------------------------------------------------
      Company:      BBVA
      Description:  rellena el response en los casos en que es Master Case y tiene tareas.

      IN:           List<Task> taskList.
      IN:           Case caso.
      IN:           Boolean hasOpenChildTsk.
      IN:           List<Case> mCChildList.
      OUT:          String.
  ---------------------------------------------------------------------------------------------*/
  public static String fillMasterCaseResponse(List<Task> taskList, Case caso, Boolean hasOpenChildTsk, List<Case> mCChildList) {
    String response;
    response = 'PROGRThere are tasks already in progress: ';
    Integer count1;
    count1 = 1;
    for(Task tarea : taskList) {
      Boolean isActionLine;
      isActionLine = tarea.Status != SER_Constant.COMPLETED && tarea.gf_spec_task_op_case_ind_type__c;
      if(isActionLine) {
        response += tarea.gf_task_id__c + '(Action Line)(Master Case ' + caso.CaseNumber + ')' + (count1 == taskList.size() && hasOpenChildTsk == false ? '. ' : ', ');
      } else if(tarea.Status != SER_Constant.COMPLETED) {
        response += tarea.gf_task_id__c + '(Master Case ' + caso.CaseNumber + ')' + (count1 == taskList.size() && hasOpenChildTsk == false ? '. ' : ', ');
      }
      count1 ++;
    }

    response += fillChildrenOpenTask(mCChildList);

    return response;
  }

  /*-------------------------------------------------------------------------------------------
      Company:      BBVA
      Description:  rellena en el response las tareas de los casos hijos que siguen abiertas.

      IN:           List<Case> mCChildList.
      OUT:          String.
  ---------------------------------------------------------------------------------------------*/
  private static String fillChildrenOpenTask(List<Case> mCChildList) {
    String response;
    response = '';

    Integer taskNumber;
    taskNumber = (Integer)[SELECT COUNT(Id)total FROM Task WHERE (Status = 'New' OR Status = 'Working'
    OR Status = 'Remedy - Escalated' OR Status = 'Remedy - Pending information' OR Status = 'Remedy - Pending to close'
    OR Status = 'Remedy - Rejected') AND WhatId IN :mCChildList][0].get('total');

    Integer countTask;
    countTask = 1;

    for(Case chidCase : mCChildList) {
      if(chidCase.Tasks.isEmpty() == false) {
        for(Task tarea : chidCase.Tasks) {
          if(tarea.gf_spec_task_op_case_ind_type__c) {
            response += tarea.gf_task_id__c + '(Action Line)(Case ' + chidCase.CaseNumber + ')' + (countTask == taskNumber ? '. ' : ', ');
          } else {
            response += tarea.gf_task_id__c + '(Case ' + chidCase.CaseNumber + ')' + (countTask == taskNumber ? '. ' : ', ');
          }
          countTask++;
        }
      }
    }
    return response;
  }

  /*-------------------------------------------------------------------------------------------
      Company:      BBVA
      Description:  Valida los campos obligatorios. Dependiendo de si es una consulta o una incidencia
                    se validan campos diferentes..

      IN:           List<Task> taskList.

      OUT:          Boolean.
  ---------------------------------------------------------------------------------------------*/
  public static Boolean validateRequiredFields(Case caso) {
    Boolean closeTask;
    closeTask = false;
    if(caso.SER_Classification__c == SER_Constant.INCIDENT) {      //Se debe de verificar que los siguientes campos están rellenos
      closeTask = String.isNotBlank(caso.SER_Classification__c) &&
                  String.isNotBlank(caso.case_channel_source_type__c) &&
                  String.isNotBlank(caso.gf_case_channel_source_name__c) &&
                  String.isNotBlank(caso.Description) &&
                  String.isNotBlank(caso.gf_cust_impact_case_name__c) &&
                  String.isNotBlank(caso.SER_Solution__c) &&
                  String.isNotBlank(caso.gf_case_cause_on_closure_desc__c) &&
                  String.isNotBlank(caso.gf_case_area_name__c) &&
                  String.isNotBlank(caso.validation_criticality_type__c) &&
                  caso.AccountId != null &&
                  String.isNotBlank(caso.gf_case_creation_type__c) &&
                  String.isNotBlank(caso.gf_case_environment_name__c) &&
                  String.isNotBlank(caso.Subject) &&
                  String.isNotBlank(caso.gf_case_countries_desc__c);
    } else if(caso.SER_Classification__c == SER_Constant.QUERY) {
      closeTask = String.isNotBlank(caso.SER_Classification__c) &&
                  String.isNotBlank(caso.case_channel_source_type__c) &&
                  String.isNotBlank(caso.gf_case_channel_source_name__c) &&
                  String.isNotBlank(caso.Description) &&
                  String.isNotBlank(caso.SER_Solution__c) &&
                  caso.AccountId != null &&
                  String.isNotBlank(caso.gf_case_environment_name__c) &&
                  String.isNotBlank(caso.Subject);
    }
    return closeTask;
  }

  /*-------------------------------------------------------------------------------------------
      Company:      BBVA
      Description:  Valida los campos obligatorios. Dependiendo de si es una consulta o una incidencia
                    se validan campos diferentes..

      IN:           List<Case> casesToClose.
      IN:           Map<Task, Case> taskWithRemedy.
      IN:           Map<Id, String> remedyStatuses.
      IN:           Boolean discard.
      IN:           List<Task> taskToClose.

      OUT:          Void.
  ---------------------------------------------------------------------------------------------*/
  public static Void closeCaseAndTAsk(List<Case> casesToClose, Map<Task, Case> taskWithRemedy, Map<Id, String> remedyStatuses, Boolean discard, List<Task> taskToClose) {
    if(casesToClose.isEmpty() == false) {
      update casesToClose;
      //Se cierran las tareas.
      //Si tiene Remedys abiertos se cierran.
      if(taskWithRemedy.isEmpty() == false) {
        closeRemedys(taskWithRemedy, remedyStatuses, discard);
      }
      closeTask(taskToClose, discard);
    }
  }
}