/**********************************************************************************
* @Company BBVA
* @description: Clase de Test de SER_LongTextTaskFieldsEGS_CONTROLLER.
**********************************************************************************/
@isTest
public class SER_LongTextTaskFieldsEGS_TEST {

  /*-----------------------------------------------------------------------
          Description: createCase.
  ------------------------------------------------------------------------*/
  private static Task createData() {
    Case newCase;
    newCase = new Case();
    newCase.RecordTypeId = SER_RecordTypeUtils.getRecordTypeByName('Case','EGS_User');
    newCase.SER_Classification__c = 'Incident';
    newCase.Subject = 'test subject';
    insert newCase;

    Task newTask;
    newTask = new Task();
    newTask.Subject = 'Other';
    newTask.WhatId = newCase.Id;
    newTask.RecordTypeId = SER_RecordTypeUtils.getRecordTypeByName('Task','SER_Task_EGS');
    insert newTask;

    return newTask;
  }

  /*-----------------------------------------------------------------------
          Description: init. Sin Task Comment. OK.
  ------------------------------------------------------------------------*/
  @isTest
  static void initTEST1() {
    Task tarea;
    tarea = createData();
    Test.startTest();
      SER_LongTextTaskFieldsEGS_CONTROLLER.Response response;
      response = SER_LongTextTaskFieldsEGS_CONTROLLER.init(tarea.Id);
      System.assertEquals([SELECT TaskComment__C FROM Task WHERE Id = :tarea.Id].TaskComment__C, response.taskCommentId, 'Error1');
    Test.stopTest();
  }

  /*-----------------------------------------------------------------------
          Description: init. Con Task Comment. OK.
  ------------------------------------------------------------------------*/
  @isTest
  static void initTEST2() {
    Task tarea;
    tarea = createData();
    List<Task> newList;
    newList = new List<Task>();
    newList.add(tarea);

    Test.startTest();
      SER_LongTextTaskFieldsEGS_CONTROLLER.addTaskComment(newList);
      SER_LongTextTaskFieldsEGS_CONTROLLER.Response response;
      response = SER_LongTextTaskFieldsEGS_CONTROLLER.init(tarea.Id);
      System.assertEquals([SELECT TaskComment__C FROM Task WHERE Id = :tarea.Id].TaskComment__C, response.taskCommentId, 'Error2');
    Test.stopTest();
  }

}