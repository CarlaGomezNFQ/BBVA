/***************************************************************************************
* @author       BBVA
* @date         30-04-2020
* @description  Controlador del aura component SER_LongTextTaskFieldsEGS.

****************************************************************************************/
public with sharing class SER_LongTextTaskFieldsEGS_CONTROLLER {

  /*---------------------------------------------------------------------------------------
      Company:       BBVA
      Description:   Constructor privado.
  ---------------------------------------------------------------------------------------*/
  private SER_LongTextTaskFieldsEGS_CONTROLLER() {}

  /*---------------------------------------------------------------------------------------
      Company:       BBVA.
      Description:   init. Devuelve el Id del TaskComment asociado a la tarea.

      IN:            String taskId.
      OUT:           Response.
  ---------------------------------------------------------------------------------------*/
  @AuraEnabled
  public static Response init(String taskId) {
    Task tarea;
    Response response;
    response = new Response();
    tarea = [SELECT TaskComment__c, RecordType.DeveloperName FROM Task WHERE Id = :taskId];
    if(tarea.TaskComment__c == null) {
      tarea.TaskComment__c = createTaskComment('');
      update tarea;
    }
    response.taskCommentId = tarea.TaskComment__c;
    response.recordType = tarea.RecordType.DeveloperName;
    return response;
  }

  /*---------------------------------------------------------------------------------------
      Company:       BBVA.
      Description:   Crea un TaskComment.

      IN:            String description
      OUT:           TaskComment Id.
  ---------------------------------------------------------------------------------------*/
  public static Id createTaskComment(String description) {
    TaskComment__c newTaskComment;
    newTaskComment = new TaskComment__c(task_desc__c = description);
    insert newTaskComment;
    return newTaskComment.Id;
  }

  /*---------------------------------------------------------------------------------------
      Company:       BBVA.
      Description:   Si la tarea es de EGS y no tiene taskComment asociado 
                      crea un taskComment y lo asocia a la tarea.

      IN:            List<Task> newList.
      OUT:           Void.
  ---------------------------------------------------------------------------------------*/
  public static void addTaskComment(final List<Task> newList) {
    for(Task tarea : newList) {
      Id egsRT;
      egsRT = SER_RecordTypeUtils.getRecordTypeByName('Task', 'SER_Task_EGS');
      if(tarea.RecordTypeId == egsRT && tarea.TaskComment__c == null && String.valueOf(tarea.WhatId).startsWithIgnoreCase('500')) {
        tarea.TaskComment__c = createTaskComment('');
      }
    }
  }


  /**************************************************************************************
  *******************                   WRAPPER                     *********************
  **************************************************************************************/
  /*--------------------------------------------------------------------------------------
      Company:        BBVA
      Description:    Clase interna .
  --------------------------------------------------------------------------------------*/
  public class Response {
    /*priorityOptions*/
    @AuraEnabled
    public String taskCommentId {get; set;}
    /*departamentOpts*/
    @AuraEnabled
    public String recordType {get; set;}
  }

}