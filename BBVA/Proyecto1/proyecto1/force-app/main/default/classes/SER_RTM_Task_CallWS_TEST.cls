/*---------------------------------------------------------------------------------------------
        Company:       BBVA
        Description:   Class to test SER_RTM_Task_CallWS class.
----------------------------------------------------------------------------------------------*/
@isTest
public class SER_RTM_Task_CallWS_TEST {
  /**Constante 'ANS SSTT'*/
  public static final String ANS_SSTT = 'ANS SSTT';

  /*-----------------------------------------------------------------------
          Description: initData.
  ------------------------------------------------------------------------*/
  private static Task initData() {
    Task tarea;
    tarea = createTask();
    SER_TestUtils_2.initRemedyCS();
    SER_TestUtils_2.insertAttachment(tarea.Id);
    SER_TestUtils_2.setUpMockResponse();

    final TaskComment__c com = new TaskComment__c();
    com.ParentId__c = tarea.Id;
    com.gf_task_comment_body_desc__c = 'CommentBody';
    com.isRemedy__c = true;
    insert com;

    return tarea;
  }

  /*-----------------------------------------------------------------------
          Description: createCase.
  ------------------------------------------------------------------------*/
  private static Task createTask() {
    Case newCase;
    newCase = new Case();
    newCase.RecordTypeId = SER_RecordTypeUtils.getRecordTypeByName('Case','EGS_User');
    newCase.SER_Classification__c = 'Incident';
    newCase.Subject = 'test subject';
    insert newCase;

    TaskComment__c lta;
    lta = new TaskComment__c();
    lta.task_desc__c = 'Description';
    insert lta;

    Task newTask;
    newTask = new Task();
    newTask.Subject = 'Other';
    newTask.WhatId = newCase.Id;
    newTask.RecordTypeId = SER_RecordTypeUtils.getRecordTypeByName('Task','SER_Task_EGS');
    newTask.TaskComment__c = lta.Id;
    insert newTask;
    return newTask;
  }

  /*-----------------------------------------------------------------------
          Description:   Method to test SER_RTM_Task_CallWS.doInit
  ------------------------------------------------------------------------*/
  @isTest
  static void doInitTEST() {
    Task tarea;
    tarea = createTask();
    Test.startTest();
    List<String> optionsList;
    optionsList = SER_RTM_Task_CallWS.doInit(tarea.Id);
    System.assert (!optionsList.isEmpty(),'Error1');
    Test.stopTest();
  }

  /*-----------------------------------------------------------------------
          Description:   Method to test SER_RTM_Task_CallWS.doInitOptions
  ------------------------------------------------------------------------*/
  @isTest
  static void doInitOptionsTEST() {
    Task tarea;
    tarea = createTask();
    tarea.departament_name__c = ANS_SSTT;
    update tarea;
    Test.startTest();
    SER_RTM_Task_CallWS.doInitOptions(tarea.WhatId);
    SER_RTM_Task_CallWS.OptionsResponse response;
    response = SER_RTM_Task_CallWS.doInitOptions(tarea.Id);
    System.assertEquals(ANS_SSTT,response.departament,'Error1');
    tarea.Status = SER_Constant.REMEDYSCALATED;
    update tarea;
    //SER_RTM_Task_CallWS.doInitOptions(tarea.Id, true);
    Test.stopTest();
  }

  /*-----------------------------------------------------------------------
          Description:   Method to test SER_RTM_Task_CallWS.submitTicket
  ------------------------------------------------------------------------*/
  @isTest
  static void submitTicketTEST() {
    Task tarea;
    tarea = initData();
    tarea.departament_name__c = ANS_SSTT;
    update tarea;
    Test.startTest();
    SER_RTM_Task_CallWS.submitTicket(tarea.Id,UserInfo.getUserId(),'Low','Solution','New Remedy',ANS_SSTT,false,'New Comment', false);
    System.assertEquals(null,tarea.incidence_id__c,'Error2');
    Test.stopTest();
  }

  /*-----------------------------------------------------------------------
          Description:   Method to test SER_RTM_Task_CallWS.secondCall
  ------------------------------------------------------------------------*/
  @isTest
  static void secondCallTEST() {
    Task tarea;
    tarea = initData();
    Test.startTest();
    SER_RTM_Task_CallWS.secondCall(tarea.Id,UserInfo.getUserId(),'Low','Solution','New Remedy',ANS_SSTT,false,'New Comment');
    System.assertEquals(tarea,tarea,'Error3');
    Test.stopTest();
  }

  /*-----------------------------------------------------------------------
          Description:   Method to test SER_RTM_Task_CallWS.getRecordTypeId
  ------------------------------------------------------------------------*/
  @isTest
  static void getRecordTypeIdTEST() {
    Task tarea;
    tarea = createTask();
    Test.startTest();
    Id rtId;
    rtId = SER_RTM_Task_CallWS.getRecordTypeId(tarea.Id);
    System.assertEquals(tarea.RecordTypeId,rtId,'Error4');
    Test.stopTest();
  }

  /*-----------------------------------------------------------------------
          Description:   Method to test SER_RTM_Task_CallWS.getTask
  ------------------------------------------------------------------------*/
  @isTest
  static void getTaskTEST() {
    Task tarea;
    tarea = createTask();
    Test.startTest();
    Task tarea2;
    tarea2 = SER_RTM_Task_CallWS.getTask(tarea.Id);
    System.assertEquals(tarea.Id,tarea2.Id,'Error6');
    Test.stopTest();
  }

  /*-----------------------------------------------------------------------
          Description:   Method to test SER_RTM_Task_CallWS.saveTask 
                          y SER_RTM_Task_CallWS.saveLog
  ------------------------------------------------------------------------*/
  @isTest
  static void saveTaskTEST() {
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
    newTask.gf_spec_task_op_case_ind_type__c = true;
    Test.startTest();
    Id taskId;
    taskId = SER_RTM_Task_CallWS.saveTask(newTask, 'description');
    System.assertNotEquals(null,taskId,'Error7');
    SER_RTM_Task_CallWS.saveLog('Error Test', null, null, 'Error message');
    Test.stopTest();
  }

  /**-----------------------------------------------------------------------
  *Description:   Method to test SER_RTM_Task_CallWS.blnCaseActionLine
                  Method to test SER_RTM_Task_CallWS.updIdCaseActionLine
  * @author:      Victor Velandia
  ------------------------------------------------------------------------*/
  @isTest
  static void blnCaseActionLineTEST() {

    Case newCase;
    newCase = new Case();
    newCase.RecordTypeId = SER_RecordTypeUtils.getRecordTypeByName('Case','EGS_User');
    newCase.SER_Classification__c = 'Incident';
    newCase.Subject = 'test subject';
    newCase.SER_LineAction_EGS__c = false;
    insert newCase;

    Test.startTest();
    SER_RTM_Task_CallWS.blnCaseActionLine(newCase.Id);
    newCase.SER_LineAction_EGS__c = true;
    update newCase;
    SER_RTM_Task_CallWS.updIdCaseActionLine(newCase.Id);
    System.assert([SELECT SER_LineAction_EGS__c FROM case WHERE Id = :newCase.Id].SER_LineAction_EGS__c, 'Error9');
    Test.stopTest();
  }

}