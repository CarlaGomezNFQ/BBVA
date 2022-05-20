/**********************************************************************************
* @Company BBVA
* @description: Clase de Test de SER_CallRemedyWebServiceLGT_Task,
*               SER_CallRemedyWS_Task_HELPERLGT y SER_CallRemedyWS_Task_ActionsLGT.
**********************************************************************************/
@isTest
public class SER_CallRemedyWebServiceLGT_Task_2_TEST {
  /*-----------------------------------------------------------------------
          Description: initData.
  ------------------------------------------------------------------------*/
  static Task initData(Boolean comment, Boolean attachment, Boolean files, Boolean insertResponse) {
    Case newCase;
    newCase = new Case();
    newCase.RecordTypeId = SER_RecordTypeUtils.getRecordTypeByName('Case','EGS_User');
    newCase.SER_Classification__c = 'Incident';
    newCase.Subject = 'test subject';
    newCase.Description = 'Description';
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
    newTask.departament_name__c = SER_Constant.ANSSSTT;
    newTask.Status = 'New';
    newTask.TaskComment__c = lta.Id;
    insert newTask;

    if(comment) {
      final TaskComment__c com = new TaskComment__c();
      com.ParentId__c = newTask.Id;
      com.gf_task_comment_body_desc__c = 'CommentBody';
      com.isRemedy__c = true;
      insert com;
    }
    if(attachment) {
      SER_TestUtils_2.insertAttachment(newTask.Id);
    }
    if(files) {
      SER_TestUtils_2.insertRelatedFile(newTask.Id);
    }
    if(insertResponse) {
      SER_TestUtils_2.setUpMockResponse();
    }

    SER_TestUtils_2.initRemedyCS();
    return newTask;
  }
  /*-----------------------------------------------------------------------
          Description: Send Attachment OK.
  ------------------------------------------------------------------------*/
  @isTest
  static void sendAttachmentTEST() {
    Task task;
    task = initData(false, true, true, true);
    task.Status = SER_Constant.REMEDYSCALATED;
    Task.incidence_id__c = SER_Constant.REMEDY_ID;
    update task;
    Test.startTest();
    String response;
    response = SER_RTM_Task_CallWS.submitTicket(task.Id,UserInfo.getUserId(),SER_Constant.MEDIUM,SER_Constant.SOLUTION,SER_Constant.SENDATTACHMENT,SER_Constant.ANSSSTT,false,SER_Constant.NEWCOMMENT,false);
    System.assertEquals(SER_Constant.SUBMITED, response, 'Error10');
    Test.stopTest();
  }

  /*-----------------------------------------------------------------------
          Description: Send Attachment OK. Remedy - Pending information.
  ------------------------------------------------------------------------*/
  @isTest
  static void sendAttachmentTEST2() {
    Task task;
    task = initData(false, true, true, true);
    task.Status = SER_Constant.PENDINGINF;
    Task.incidence_id__c = SER_Constant.REMEDY_ID;
    update task;
    Test.startTest();
    String response;
    response = SER_RTM_Task_CallWS.submitTicket(task.Id,UserInfo.getUserId(),SER_Constant.MEDIUM,SER_Constant.SOLUTION,SER_Constant.SENDATTACHMENT,SER_Constant.ANSSSTT,false,SER_Constant.NEWCOMMENT,false);
    System.assertEquals(SER_Constant.SUBMITED, response, 'Error11');
    Test.stopTest();
  }

  /*-----------------------------------------------------------------------
          Description: Send Attachment OK. Remedy - Pending information. SendLastComment
  ------------------------------------------------------------------------*/
  @isTest
  static void sendAttachmentTEST3() {
    Task task;
    task = initData(true, true, true, true);
    task.Status = SER_Constant.PENDINGINF;
    Task.incidence_id__c = SER_Constant.REMEDY_ID;
    update task;
    Test.startTest();
    String response;
    response = SER_RTM_Task_CallWS.submitTicket(task.Id,UserInfo.getUserId(),SER_Constant.MEDIUM,SER_Constant.SOLUTION,SER_Constant.SENDATTACHMENT,SER_Constant.ANSSSTT,true,SER_Constant.NEWCOMMENT,false);
    System.assertEquals(SER_Constant.SUBMITED, response, 'Error12');
    Test.stopTest();
  }

  /*-----------------------------------------------------------------------
          Description: Send Attachment OK. Sin comment
  ------------------------------------------------------------------------*/
  @isTest
  static void sendAttachmentTEST4() {
    Task task;
    task = initData(false, true, true, true);
    task.Status = SER_Constant.PENDINGINF;
    Task.incidence_id__c = SER_Constant.REMEDY_ID;
    update task;
    Test.startTest();
    String response;
    response = SER_RTM_Task_CallWS.submitTicket(task.Id,UserInfo.getUserId(),SER_Constant.MEDIUM,SER_Constant.SOLUTION,SER_Constant.SENDATTACHMENT,SER_Constant.ANSSSTT,false,'',false);
    System.assertEquals(SER_Constant.SUBMITED, response, 'Error13');
    Test.stopTest();
  }

  /*-----------------------------------------------------------------------
          Description: Close Remedy OK.
  ------------------------------------------------------------------------*/
  @isTest
  static void closeRemedyTEST() {
    Task task;
    task = initData(false, true, true, true);
    task.Status = SER_Constant.PENDINGTOCLOSE;
    Task.incidence_id__c = SER_Constant.REMEDY_ID;
    update task;
    Test.startTest();
    String response;
    response = SER_RTM_Task_CallWS.submitTicket(task.Id,UserInfo.getUserId(),SER_Constant.MEDIUM,SER_Constant.SOLUTION,SER_CallRemedyWS_Task_HELPERLGT.CLOSEREMEDY,SER_Constant.ANSSSTT,false,SER_Constant.NEWCOMMENT,false);
    System.assertEquals(SER_Constant.SUBMITED, response, 'Error14');
    Test.stopTest();
  }

  /*-----------------------------------------------------------------------
          Description: Close Remedy OK. SendLastComment
  ------------------------------------------------------------------------*/
  @isTest
  static void closeRemedyTEST2() {
    Task task;
    task = initData(true, true, true, true);
    task.Status = SER_Constant.PENDINGTOCLOSE;
    Task.incidence_id__c = SER_Constant.REMEDY_ID;
    update task;
    Test.startTest();
    String response;
    response = SER_RTM_Task_CallWS.submitTicket(task.Id,UserInfo.getUserId(),SER_Constant.MEDIUM,SER_Constant.SOLUTION,SER_CallRemedyWS_Task_HELPERLGT.CLOSEREMEDY,SER_Constant.ANSSSTT,true,SER_Constant.NEWCOMMENT,false);
    System.assertEquals(SER_Constant.SUBMITED, response, 'Error15');
    Test.stopTest();
  }

  /*-----------------------------------------------------------------------
          Description: Close Remedy OK. SendLastComment
  ------------------------------------------------------------------------*/
  @isTest
  static void closeRemedyTEST3() {
    Task task;
    task = initData(false, true, true, true);
    task.Status = SER_Constant.PENDINGTOCLOSE;
    Task.incidence_id__c = SER_Constant.REMEDY_ID;
    update task;
    Test.startTest();
    String response;
    response = SER_RTM_Task_CallWS.submitTicket(task.Id,UserInfo.getUserId(),SER_Constant.MEDIUM,SER_Constant.SOLUTION,SER_CallRemedyWS_Task_HELPERLGT.CLOSEREMEDY,SER_Constant.ANSSSTT,true,'',false);
    System.assertEquals(SER_Constant.SUBMITED, response, 'Error16');
    Test.stopTest();
  }
}