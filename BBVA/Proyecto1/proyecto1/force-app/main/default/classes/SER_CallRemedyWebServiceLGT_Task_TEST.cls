/**********************************************************************************
* @Company BBVA
* @description: Clase de Test de SER_CallRemedyWebServiceLGT_Task,
*               SER_CallRemedyWS_Task_HELPERLGT y SER_CallRemedyWS_Task_ActionsLGT.
**********************************************************************************/
@isTest
public class SER_CallRemedyWebServiceLGT_Task_TEST {
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
          Description: newTicket OK.
  ------------------------------------------------------------------------*/
  @isTest
  static void newTicketTEST() {
    Task task;
    task = initData(false, false, false, true);
    Test.startTest();
    String response;
    response = SER_RTM_Task_CallWS.submitTicket(task.Id,UserInfo.getUserId(),SER_Constant.LOW,SER_Constant.SOLUTION,SER_Constant.NEWREMEDY,SER_Constant.ANSSSTT,false,SER_Constant.NEWCOMMENT,false);
    SER_RTM_Task_CallWS.secondCall(task.Id,UserInfo.getUserId(),SER_Constant.LOW,SER_Constant.SOLUTION,SER_Constant.NEWREMEDY,SER_Constant.ANSSSTT,false,SER_Constant.NEWCOMMENT);
    System.assertEquals(SER_Constant.SUBMITED, response, 'Error1');
    Test.stopTest();
  }

  /*-----------------------------------------------------------------------
          Description: newTicket KO.
  ------------------------------------------------------------------------*/
  @isTest
  static void newTicketTEST2() {
    Task task;
    task = initData(false, true, true, true);
    SER_ASOMockResponse_TEST fakeResponse;
    fakeResponse = new SER_ASOMockResponse_TEST(300, 'KO','{"id":"INC00000001"}',null );
    Test.setMock(HttpCalloutMock.class, fakeResponse);
    Test.startTest();
    String response;
    response = SER_RTM_Task_CallWS.submitTicket(task.Id,UserInfo.getUserId(),'High',SER_Constant.SOLUTION,SER_Constant.NEWREMEDY,SER_Constant.ANSSSTT,true,SER_Constant.NEWCOMMENT,false);
    SER_RTM_Task_CallWS.secondCall(task.Id,UserInfo.getUserId(),'High',SER_Constant.SOLUTION,SER_Constant.NEWREMEDY,SER_Constant.ANSSSTT,true,SER_Constant.NEWCOMMENT);
    System.assertNotEquals('', response, 'Error2');
    Test.stopTest();
  }

  /*-----------------------------------------------------------------------
          Description: Update Remedy OK.
  ------------------------------------------------------------------------*/
  @isTest
  static void updateTicketTEST() {
    Task task;
    task = initData(true, false, false, true);
    task.Status = SER_Constant.REMEDYSCALATED;
    Task.incidence_id__c = SER_Constant.REMEDY_ID;
    update task;
    Test.startTest();
    String response;
    response = SER_RTM_Task_CallWS.submitTicket(task.Id,UserInfo.getUserId(),SER_Constant.MEDIUM,SER_Constant.SOLUTION,SER_Constant.UPDATEREMEDY,SER_Constant.ANSSSTT,false,SER_Constant.NEWCOMMENT,false);
    SER_RTM_Task_CallWS.secondCall(task.Id,UserInfo.getUserId(),SER_Constant.MEDIUM,SER_Constant.SOLUTION,SER_Constant.UPDATEREMEDY,SER_Constant.ANSSSTT,false,SER_Constant.NEWCOMMENT);
    System.assertEquals('', response, 'Error3');
    Test.stopTest();
  }

  /*-----------------------------------------------------------------------
          Description: Update Remedy OK. SendLastComment
  ------------------------------------------------------------------------*/
  @isTest
  static void updateTicketTEST2() {
    Task task;
    task = initData(true, false, false, true);
    task.Status = SER_Constant.REMEDYSCALATED;
    Task.incidence_id__c = SER_Constant.REMEDY_ID;
    update task;
    Test.startTest();
    String response;
    response = SER_RTM_Task_CallWS.submitTicket(task.Id,UserInfo.getUserId(),'',SER_Constant.SOLUTION,SER_Constant.UPDATEREMEDY,SER_Constant.ANSSSTT,true,SER_Constant.NEWCOMMENT,false);
    SER_RTM_Task_CallWS.secondCall(task.Id,UserInfo.getUserId(),'',SER_Constant.SOLUTION,SER_Constant.UPDATEREMEDY,SER_Constant.ANSSSTT,true,SER_Constant.NEWCOMMENT);
    System.assertEquals('', response, 'Error4');
    Test.stopTest();
  }

  /*-----------------------------------------------------------------------
          Description: Update Remedy OK. No comment
  ------------------------------------------------------------------------*/
  @isTest
  static void updateTicketTEST3() {
    Task task;
    task = initData(false, false, false, true);
    task.Status = SER_Constant.REMEDYSCALATED;
    Task.incidence_id__c = SER_Constant.REMEDY_ID;
    update task;
    Test.startTest();
    String response;
    response = SER_RTM_Task_CallWS.submitTicket(task.Id,UserInfo.getUserId(),SER_Constant.MEDIUM,SER_Constant.SOLUTION,SER_Constant.UPDATEREMEDY,SER_Constant.ANSSSTT,false,'',false);
    SER_RTM_Task_CallWS.secondCall(task.Id,UserInfo.getUserId(),SER_Constant.MEDIUM,SER_Constant.SOLUTION,SER_Constant.UPDATEREMEDY,SER_Constant.ANSSSTT,false,'');
    System.assertEquals('', response, 'Error5');
    Test.stopTest();
  }

  /*-----------------------------------------------------------------------
          Description: Claim Remedy OK.
  ------------------------------------------------------------------------*/
  @isTest
  static void claimRemedyTicketTEST() {
    Task task;
    task = initData(true, false, false, true);
    task.Status = SER_Constant.REMEDYSCALATED;
    Task.incidence_id__c = SER_Constant.REMEDY_ID;
    update task;
    Test.startTest();
    String response;
    response = SER_RTM_Task_CallWS.submitTicket(task.Id,UserInfo.getUserId(),SER_Constant.MEDIUM,SER_Constant.SOLUTION,'Claim Remedy',SER_Constant.ANSSSTT,false,SER_Constant.NEWCOMMENT,false);
    System.assertEquals(SER_Constant.SUBMITED, response, 'Error6');
    Test.stopTest();
  }

  /*-----------------------------------------------------------------------
          Description: Claim Remedy OK. SendLastComment
  ------------------------------------------------------------------------*/
  @isTest
  static void claimRemedyTicketTEST2() {
    Task task;
    task = initData(true, false, false, true);
    task.Status = SER_Constant.REMEDYSCALATED;
    Task.incidence_id__c = SER_Constant.REMEDY_ID;
    update task;
    Test.startTest();
    String response;
    response = SER_RTM_Task_CallWS.submitTicket(task.Id,UserInfo.getUserId(),SER_Constant.MEDIUM,SER_Constant.SOLUTION,'Claim Remedy',SER_Constant.ANSSSTT,true,SER_Constant.NEWCOMMENT,false);
    System.assertEquals(SER_Constant.SUBMITED, response, 'Error7');
    Test.stopTest();
  }
}