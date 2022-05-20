/**********************************************************************************
* @author       BBVA
* @date         31-10-2019
* @description  Class intermedia entre el botón JavaScript que la invoca y las llamadas a los Web Services ASO.

**********************************************************************************/
public with sharing class SER_RTM_Task_CallWS {
  /**Constante 'Mantener equipo resolutor'*/
  public static final String MISMORESOLUTOR = 'Mantener equipo resolutor';
  /**Constante ', getLineNumber: '*/
  public static final String LINENUMBER = ', getLineNumber: ';
  /**Constante ', getStackTraceString: '*/
  public static final String STACKTRACE = ', getStackTraceString: ';

  /*---------------------------------------------------------------------------------------
      Company:       BBVA
      Description:   private constructor.
  ---------------------------------------------------------------------------------------*/
  private SER_RTM_Task_CallWS() {
  }

  /*---------------------------------------------------------------------------------------
      Company:       BBVA
      Description:   Init Method.

      IN:            String taskid
      OUT:           List<String>
  ---------------------------------------------------------------------------------------*/
  @AuraEnabled
  public static List<String> doInit(String taskId) {
    List<String> optionsList;
    optionsList = new List<String>();
    try {
      SER_CallRemedyWebServiceLGT_Task instanceCRWS;
      instanceCRWS = new SER_CallRemedyWebServiceLGT_Task(taskId,'');
      if(instanceCRWS.operationList != null && !instanceCRWS.operationList.isEmpty()) {
        for(SelectOption so : instanceCRWS.operationList) {
          optionsList.add(so.getValue());
        }
      }
      return optionsList;
    } catch(Exception exc) {
      String errorMessage;
      errorMessage = ' Message: ' + exc.getMessage() + ' ,StackTrace: ' + exc.getStackTraceString();
      throw new AuraHandledException(Label.SER_Error_Server + ' ' + exc + ' ' + errorMessage);
    }
  }

  /*---------------------------------------------------------------------------------------
      Company:       BBVA
      Description:   Init field options.

      IN:            String taskId
      OUT:           OptionsResponse
  ---------------------------------------------------------------------------------------*/
  @AuraEnabled
  public static OptionsResponse doInitOptions(String taskId) {
    OptionsResponse response;
    response = new OptionsResponse();
    Case caso;
    Task tarea;
    String taskStatus;
    try {
      final boolean taskIdT =String.isNotBlank(taskId) && taskId.startsWithIgnoreCase('00T');
      final boolean taskId5 =String.isNotBlank(taskId) && taskId.startsWithIgnoreCase('500');
      if(taskIdT) {
        tarea = [SELECT Status, departament_name__c, Priority FROM Task WHERE Id = : taskId LIMIT 1];
        taskStatus = tarea.Status;
        response.departament = tarea.departament_name__c;
        response.priority = tarea.Priority;
      } else if(taskId5) {
        caso = [SELECT Id, CaseNumber, gf_cust_impact_case_name__c, SER_Classification__c FROM Case WHERE Id = : taskId LIMIT 1];
        System.debug(caso);
        response.techImpact = caso.gf_cust_impact_case_name__c;
        response.caseNumber = caso.CaseNumber;
        response.caseId = caso.Id;
        response.isIncident = caso.SER_Classification__c == 'Incident' ? true:false;
      }
      List<String> priorityOptions;
      priorityOptions = new List<String>();
      Schema.DescribeFieldResult fieldResultPO;
      fieldResultPO = Task.Priority.getDescribe();
      List<Schema.PicklistEntry> plePO;
      plePO = fieldResultPO.getPicklistValues();
      for(Schema.PicklistEntry pickListVal : plePO) {
        priorityOptions.add(pickListVal.getLabel());
      }
      response.priorityOpts = priorityOptions;
      response.departamentOpts = getDepartmentOptions(taskStatus);
      response.techImpOpts = criticalityOptions();

      List<String> teamOpts;
      teamOpts = new List<String>();
      Schema.DescribeFieldResult fieldResultTO;
      fieldResultTO = Task.gf_task_execution_team_name__c.getDescribe();
      List<Schema.PicklistEntry> pleTO;
      pleTO = fieldResultTO.getPicklistValues();
      for(Schema.PicklistEntry pickListVal : pleTO) {
        teamOpts.add(pickListVal.getLabel());
      }
      response.teamResolOpts = teamOpts;

      return response;
    } catch(Exception exc) {
      throw new AuraHandledException(Label.SER_Error_Server + ' ' + exc + ' ' + ' Message: ' + exc.getMessage() + ' ,StackTrace: ' + exc.getStackTraceString());
    }
  }

  /*---------------------------------------------------------------------------------------
      Company:       BBVA
      Description:   getDepartmentOptions.

      IN:            String taskStatus
      OUT:           OptionsResponse
  ---------------------------------------------------------------------------------------*/
  private static List<String> getDepartmentOptions(String taskStatus) {
    List<String> departOpts;
    departOpts = new List<String>();
    Schema.DescribeFieldResult fieldResultDO;
    fieldResultDO = Task.departament_name__c.getDescribe();
    List<Schema.PicklistEntry> pleDO;
    pleDO = fieldResultDO.getPicklistValues();
    for(Schema.PicklistEntry pickListVal : pleDO) {
      final boolean remDepart =SER_Constant.REMEDYSCALATED.equalsIgnoreCase(taskStatus) == false && MISMORESOLUTOR.equalsIgnoreCase(pickListVal.getLabel()) == false; 
      if(remDepart) {
        departOpts.add(pickListVal.getLabel());
      } else if(SER_Constant.REMEDYSCALATED.equalsIgnoreCase(taskStatus)) {
        departOpts.add(pickListVal.getLabel());
      }
    }
    return departOpts;
  }

  /*---------------------------------------------------------------------------------------
      Company:       BBVA
      Description:   criticalityOptions.

      OUT:           OptionsResponse
  ---------------------------------------------------------------------------------------*/
  private static List<String> criticalityOptions() {
    List<String> critOpts;
    critOpts = new List<String>();
    Schema.DescribeFieldResult fieldResultCO;
    fieldResultCO = Task.gf_tech_impact_case_name__c.getDescribe();
    List<Schema.PicklistEntry> pleCO;
    pleCO = fieldResultCO.getPicklistValues();
    for(Schema.PicklistEntry pickListVal : pleCO) {
      critOpts.add(pickListVal.getLabel());
    }
    return critOpts;
  }

  /*---------------------------------------------------------------------------------------
      Company:       BBVA
      Description:   submit a ticket.

      IN:            String taskid
      OUT:           String
  ---------------------------------------------------------------------------------------*/
  @AuraEnabled
  public static String  submitTicket(String taskid,String userId,String priority,String solution,String operation,
                                      String remedyDepartment,Boolean sendLastComment,String newComment,Boolean isCloseBtn) {
    System.debug('JCT---PARAM - sendLastComment : '+sendLastComment);
    System.debug('JCT---PARAM - newComment : '+newComment);
    try {
      SER_CallRemedyWebServiceLGT_Task instanceCRWS;
      instanceCRWS = new SER_CallRemedyWebServiceLGT_Task(taskid,userId);
      instanceCRWS.operation = operation;
      if(String.isNotBlank(priority)) {
        instanceCRWS.currentTask.Priority = priority;
      }
      if(String.isNotBlank(remedyDepartment)) {
        instanceCRWS.currentTask.departament_name__c = remedyDepartment;
      }
      if(String.isNotBlank(solution)) {
        instanceCRWS.currentTask.TaskComment__r.gf_action_result_desc__c = SER_CallRemedyWS_Task_HELPERLGT.parseJsonString(solution,false);
      }
      instanceCRWS.sendLastCom = sendLastComment;
      instanceCRWS.comment.newComment = SER_CallRemedyWS_Task_HELPERLGT.parseJsonString(newComment,false);
      instanceCRWS.comment.newCommentParse = SER_CallRemedyWS_Task_HELPERLGT.parseJsonString(newComment,false);
      instanceCRWS.comment.remedyMessage = SER_CallRemedyWS_Task_HELPERLGT.parseJsonString(newComment,true);
      //instanceCRWS.currentTask.Description = SER_CallRemedyWS_Task_HELPERLGT.parseJsonStringRemedy(instanceCRWS.currentTask.Description);
      instanceCRWS.comment.descriptionParse = SER_CallRemedyWS_Task_HELPERLGT.parseJsonString(instanceCRWS.currentTask.TaskComment__r.task_desc__c,true);
      System.debug('------- sendLastCom --------' + instanceCRWS.sendLastCom);
      System.debug('------- newComment --------' + instanceCRWS.comment.newComment);
      System.debug('------- newCommentParse --------' + instanceCRWS.comment.newCommentParse);
      System.debug('------- remedyMessage --------' + instanceCRWS.comment.remedyMessage);
      instanceCRWS.callWebServiceASOLogic(isCloseBtn);
      return instanceCRWS.errorMsg;
    } catch(Exception exc) {
      System.debug('EXMSG : '+exc.getMessage() + LINENUMBER + exc.getLineNumber() + STACKTRACE + exc.getStackTraceString());
      if(System.isFuture()) {
        throw exc;
      } else {
        throw new AuraHandledException(Label.SER_Error_Server + ' ' + exc + LINENUMBER + exc.getLineNumber() + STACKTRACE + exc.getStackTraceString());
      }
    }
  }

  /*---------------------------------------------------------------------------------------
        Company:       BBVA
        Description:   Send the comment to remedy

        IN:            String taskid
        OUT:           String
  ---------------------------------------------------------------------------------------*/
  @AuraEnabled
  public static String  secondCall(String taskid,String userId,String priority,String solution,String operation,
                                    String remedyDepartment,Boolean sendLastComment,String newComment) {
    System.debug('JCT---PARAM - sendLastComment : '+sendLastComment);
    System.debug('JCT---PARAM - newComment : '+newComment);
    try {
      SER_CallRemedyWebServiceLGT_Task instanceCRWS;
      instanceCRWS = new SER_CallRemedyWebServiceLGT_Task(taskid,userId);
      instanceCRWS.operation = operation;
      if(String.isNotBlank(priority)) {
        instanceCRWS.currentTask.Priority = priority;
      }
      if(String.isNotBlank(remedyDepartment)) {
        instanceCRWS.currentTask.departament_name__c = remedyDepartment;
      }
      if(String.isNotBlank(solution)) {
        instanceCRWS.currentTask.TaskComment__r.gf_action_result_desc__c = SER_CallRemedyWS_Task_HELPERLGT.parseJsonString(solution,false);
      }
      instanceCRWS.sendLastCom = sendLastComment;
      instanceCRWS.comment.remedyMessage = SER_CallRemedyWS_Task_HELPERLGT.parseJsonString(newComment,true);
      instanceCRWS.comment.newComment = SER_CallRemedyWS_Task_HELPERLGT.parseJsonString(newComment,false);
      instanceCRWS.comment.newCommentParse = SER_CallRemedyWS_Task_HELPERLGT.parseJsonString(newComment,false);
      instanceCRWS.secondCallWebServiceASO();
      return instanceCRWS.errorMsg;
    } catch(Exception exc) {
      System.debug('EXMSG : ' + exc.getMessage() + LINENUMBER + exc.getLineNumber() + STACKTRACE + exc.getStackTraceString());
      throw new AuraHandledException(Label.SER_Error_Server + ' ' + exc + LINENUMBER + exc.getLineNumber() + STACKTRACE + exc.getStackTraceString());
    }
  }

  /*---------------------------------------------------------------------------------------
      Company:       BBVA
      Description:   return task recordtype id..

      IN:            Id objId
      OUT:           Id
  ---------------------------------------------------------------------------------------*/
  @AuraEnabled
  public static Id getRecordTypeId(Id objId) {
    Task tarea;
    try {
      tarea = [select Id, RecordTypeId from task where id = : objId limit 1][0];
      return tarea.RecordTypeId;
    } catch(Exception exc) {
      CIB_LogUtils.create_Log(exc, 'Error: SER_RTM_Task_CallWS.getRecordTypeId');
      String errorMessage;
      errorMessage = ' , StackTrace: ' + exc.getStackTraceString();
      throw new AuraHandledException(Label.SER_Error_Server + ' ' + exc + ' ' + errorMessage);
    }
  }

  /*---------------------------------------------------------------------------------------
      Company:       BBVA
      Description:   return the task.

      IN:            Id taskId
      OUT:           Task
  ---------------------------------------------------------------------------------------*/
  @AuraEnabled
  public static Task getTask(Id taskId) {
    Task tarea = new Task();
    try {
      tarea =  [
        select Id,
        Status,
        TaskComment__r.gf_action_result_desc__c,
        task_desc__c,
        TaskComment__r.task_desc__c,
        Priority,
        RecordTypeId
        from Task
        where id = :taskId limit 1
      ][0];
      return tarea;
    } catch(Exception exc) {
      String errorMessage;
      errorMessage = ' , StackTrace: ' + exc.getStackTraceString();
      throw new AuraHandledException(Label.SER_Error_Server + ' ' + exc + ' ' + errorMessage);
    }
  }

  /*---------------------------------------------------------------------------------------
      Company:       BBVA
      Description:   save the task.

      IN:            Task tarea.
      IN:            String description.

      OUT:           String. Si va bien devuelve el Id de la tarea, si es una tarea del tipo Action Line
                      y el caso ya tiene una tarea de ese tipo se devuelve el String 'ActionLine'.
  ---------------------------------------------------------------------------------------*/
  @AuraEnabled
  public static String saveTask(Task tarea, String description) {
    System.debug('>>>>  SER_RTM_Task_CallWS.saveTask()');
    System.debug('>>>>  Task: ' + tarea);
    System.debug('>>>>  Description: ' + description);
    try {
      System.debug('--->>> tarea.gf_spec_task_op_case_ind_type__c (Actin Line) ' + tarea.gf_spec_task_op_case_ind_type__c);
      Boolean hasActionLine;
      hasActionLine = false;
      if(tarea.gf_spec_task_op_case_ind_type__c == true) {
        hasActionLine = blnCaseActionLine(tarea.WhatId);
        System.debug('--->>> hasActionLine: ' + hasActionLine);
      }

      if(hasActionLine == false) {
        tarea.RecordTypeId = SER_RecordTypeUtils.getRecordTypeByName('Task', 'SER_Task_EGS');
        tarea.TaskComment__c = SER_LongTextTaskFieldsEGS_CONTROLLER.createTaskComment(description);
        if(String.isNotBlank(description)) {
          tarea.task_desc__c = description.length() > 255 ? description.substring(0, 250) + '...' : description;
        }
        insert tarea;
        System.debug('--->>> Saved Task: ' + tarea.Id);

        if(tarea.gf_spec_task_op_case_ind_type__c == true) {
          updIdCaseActionLine(tarea.WhatId);
        }
      }
      return tarea.Id == null ? 'ActionLine' : String.valueOf(tarea.Id);
    } catch(Exception exc) {
      String errorMessage;
      errorMessage = ' Message: ' + exc.getMessage() + ' ,StackTrace: ' + exc.getStackTraceString();
      throw new AuraHandledException(Label.SER_Error_Server + ' ' + exc + ' ' + errorMessage);
    }
  }

  /*---------------------------------------------------------------------------------------
      Company:       BBVA
      Description:   save the log.

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
    } catch(Exception e) {
      System.debug('Se ha producido un error al salvar el CIB_Log');
    }
  }


  /**--------------------------------------------------------------------------------------
  * Company:        BBVA
  * Description:    blnCaseActionLine
  * @author:        Victor Velandia
  ---------------------------------------------------------------------------------------*/
  public static Boolean blnCaseActionLine ( Id caseId ) { //NOSONAR
    //make your own SOQL here from your desired object where you want to place your lightnign action
    Boolean blnVldActionLine = false;
    System.debug('--->>> blnVldActionLine' + blnVldActionLine);
    list<Case> lstCaseTask;
    lstCaseTask = new list<Case>();
    lstCaseTask = [SELECT id, SER_LineAction_EGS__c,
                    (SELECT id,
                            gf_spec_task_op_case_ind_type__c
                      FROM Tasks
                      WHERE gf_spec_task_op_case_ind_type__c = true)
                  FROM Case
                  WHERE id = :caseId];
    System.debug('--->>> lstCaseTask' + lstCaseTask);
    System.debug('--->>> lstCaseTask' + lstCaseTask.size());
    if(lstCaseTask[0].Tasks.isEmpty() == false) {
      System.debug('--->>> if');
      blnVldActionLine = true;
    } else {
      System.debug('--->>> else');
      blnVldActionLine = false;
    }
    return blnVldActionLine;
  }

  /**--------------------------------------------------------------------------------------
  * Company:        BBVA
  * Description:    updIdCaseActionLine
  * @author:        Victor Velandia
  ---------------------------------------------------------------------------------------*/
  public static Case updIdCaseActionLine( Id idCaseActionLine ) {
    Case objCase;
    objCase =  new Case();
    objCase.Id = idCaseActionLine;
    system.debug('--->>> ObjCase.SER_LineAction_EGS__c '+ objCase.SER_LineAction_EGS__c);
    if(objCase.SER_LineAction_EGS__c == false) {
      objCase.SER_LineAction_EGS__c = True;
    }
    //Update del caso
    Update objCase;
    //Return the error message
    return objCase;
  }

  /**************************************************************************************
  *******************                   WRAPPER                     *********************
  **************************************************************************************/
  /*--------------------------------------------------------------------------------------
      Company:        BBVA
      Description:    Clase interna .
  --------------------------------------------------------------------------------------*/
  public class OptionsResponse {
    /*priorityOptions*/
    @AuraEnabled
    public List<String> priorityOpts {get; set;}
    /*departamentOpts*/
    @AuraEnabled
    public List<String> departamentOpts {get; set;}
    /*teamResolOpts*/
    @AuraEnabled
    public List<String> teamResolOpts {get; set;}
    /*priority*/
    @AuraEnabled
    public String priority {get; set;}
    /*departament*/
    @AuraEnabled
    public String departament {get; set;}
    /*techImpOpts*/
    @AuraEnabled
    public List<String> techImpOpts {get; set;}
    /*techImpact*/
    @AuraEnabled
    public String techImpact {get; set;}
    /*caseNumber*/
    @AuraEnabled
    public String caseNumber {get; set;}
    /*caseId*/
    @AuraEnabled
    public Id caseId {get; set;}
    /*caseId*/
    @AuraEnabled
    public Boolean isIncident {get; set;}
  }

}