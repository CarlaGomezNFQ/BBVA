/**********************************************************************************
* @Company BBVA
* @description: Clase de Test de SER_CallRemedyWebServiceLGT_Task,
*               SER_CallRemedyWS_Task_HELPERLGT y SER_CallRemedyWS_Task_ActionsLGT.
**********************************************************************************/
@isTest
public class SER_CallRemedyWebServiceLGT_Task_3_TEST {
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
          Description: Send Comment OK.
  ------------------------------------------------------------------------*/
  @isTest
  static void sendCommentTEST() {
    Task task;
    task = initData(true, false, false, true);
    task.Status = SER_Constant.REMEDYSCALATED;
    Task.incidence_id__c = SER_Constant.REMEDY_ID;
    update task;
    Test.startTest();
    String response;
    response = SER_RTM_Task_CallWS.submitTicket(task.Id,UserInfo.getUserId(),SER_Constant.MEDIUM,SER_Constant.SOLUTION,SER_Constant.SENDCOMMENT,SER_Constant.ANSSSTT,false,SER_Constant.NEWCOMMENT,false);
    System.assertEquals(SER_Constant.SUBMITED, response, 'Error7');
    Test.stopTest();
  }

  /*-----------------------------------------------------------------------
          Description: Send Comment OK. Remedy - Pending information.
  ------------------------------------------------------------------------*/
  @isTest
  static void sendCommentTEST2() {
    Task task;
    task = initData(true, false, false, true);
    task.Status = SER_Constant.PENDINGINF;
    Task.incidence_id__c = SER_Constant.REMEDY_ID;
    update task;
    Test.startTest();
    String response;
    response = SER_RTM_Task_CallWS.submitTicket(task.Id,UserInfo.getUserId(),SER_Constant.MEDIUM,SER_Constant.SOLUTION,SER_Constant.SENDCOMMENT,SER_Constant.ANSSSTT,false,SER_Constant.NEWCOMMENT,false);
    System.assertEquals(SER_Constant.SUBMITED, response, 'Error8');
    Test.stopTest();
  }

  /*-----------------------------------------------------------------------
          Description: Send Comment OK. Remedy - Pending information.
  ------------------------------------------------------------------------*/
  @isTest
  static void sendCommentTEST3() {
    Task task;
    task = initData(true, false, false, true);
    task.Status = SER_Constant.PENDINGINF;
    Task.incidence_id__c = SER_Constant.REMEDY_ID;
    update task;
    Test.startTest();
    String response;
    response = SER_RTM_Task_CallWS.submitTicket(task.Id,UserInfo.getUserId(),SER_Constant.MEDIUM,SER_Constant.SOLUTION,SER_Constant.SENDCOMMENT,SER_Constant.ANSSSTT,true,SER_Constant.NEWCOMMENT,false);
    System.assertEquals(SER_Constant.SUBMITED, response, 'Error9');
    Test.stopTest();
  }

  /*-----------------------------------------------------------------------
          Description: Reopen Remedy OK.
  ------------------------------------------------------------------------*/
  @isTest
  static void reopenRemedyTEST() {
    Task task;
    task = initData(false, true, true, true);
    task.Status = 'Completed';
    Task.incidence_id__c = SER_Constant.REMEDY_ID;
    update task;
    Test.startTest();
    String response;
    response = SER_RTM_Task_CallWS.submitTicket(task.Id,UserInfo.getUserId(),SER_Constant.MEDIUM,SER_Constant.SOLUTION,SER_CallRemedyWS_Task_HELPERLGT.REOPENREMEDY,SER_Constant.ANSSSTT,false,SER_Constant.NEWCOMMENT,false);
    System.assertEquals(SER_Constant.SUBMITED, response, 'Error17');
    Test.stopTest();
  }

  /*-----------------------------------------------------------------------
          Description: Reopen Remedy OK. SendLastComment
  ------------------------------------------------------------------------*/
  @isTest
  static void reopenRemedyTEST2() {
    Task task;
    task = initData(true, true, true, true);
    task.Status = 'Completed';
    Task.incidence_id__c = SER_Constant.REMEDY_ID;
    update task;
    Test.startTest();
    String response;
    response = SER_RTM_Task_CallWS.submitTicket(task.Id,UserInfo.getUserId(),SER_Constant.MEDIUM,SER_Constant.SOLUTION,SER_CallRemedyWS_Task_HELPERLGT.REOPENREMEDY,SER_Constant.ANSSSTT,true,SER_Constant.NEWCOMMENT,false);
    System.assertEquals(SER_Constant.SUBMITED, response, 'Error18');
    Test.stopTest();
  }

  /*-----------------------------------------------------------------------
          Description: getCommentario OK.
  ------------------------------------------------------------------------*/
  @isTest
  static void getCommentarioTEST() {
    Task task;
    task = initData(true, false, false, true);
    Test.startTest();
    List <TaskComment__c> response;
    response = SER_CallRemedyWebServiceLGT_Task.getCommentario(task.Id);
    System.assertEquals(response.isEmpty(), false, 'Error19');
    Test.stopTest();
  }

  /*-----------------------------------------------------------------------
          Description: Services KOs.
  ------------------------------------------------------------------------*/
  @isTest
  static void errorsTEST() {
    Task task;
    task = initData(false, false, false, true);
    Test.startTest();
    SER_CallRemedyWS_Task_HELPERLGT.getInstance();
    //Creation, comment lenght
    SER_RTM_Task_CallWS.submitTicket(task.Id,UserInfo.getUserId(),SER_Constant.LOW,SER_Constant.SOLUTION,SER_Constant.NEWREMEDY,SER_Constant.ANSSSTT,false,SER_Constant.TOOLONGCOMMENT,false);
    //Creation, blank department
    task.departament_name__c = '';
    update task;
    SER_RTM_Task_CallWS.submitTicket(task.Id,UserInfo.getUserId(),SER_Constant.LOW,SER_Constant.SOLUTION,SER_Constant.NEWREMEDY,null,false,'12345',false);
    //Close, comment lenght
    task.Status = SER_Constant.PENDINGTOCLOSE;
    Task.incidence_id__c = SER_Constant.REMEDY_ID;
    update task;
    SER_RTM_Task_CallWS.submitTicket(task.Id,UserInfo.getUserId(),SER_Constant.MEDIUM,SER_Constant.SOLUTION,SER_CallRemedyWS_Task_HELPERLGT.CLOSEREMEDY,SER_Constant.ANSSSTT,false,SER_Constant.TOOLONGCOMMENT,false);
    //Close, solution mandatory
    SER_RTM_Task_CallWS.submitTicket(task.Id,UserInfo.getUserId(),SER_Constant.MEDIUM,null,SER_CallRemedyWS_Task_HELPERLGT.CLOSEREMEDY,SER_Constant.ANSSSTT,true,'12345',false);
    //Update, comment lenght
    task.Status = SER_Constant.REMEDYSCALATED;
    task.incidence_id__c = SER_Constant.REMEDY_ID;
    update task;
    SER_RTM_Task_CallWS.submitTicket(task.Id,UserInfo.getUserId(),SER_Constant.MEDIUM,SER_Constant.SOLUTION,SER_Constant.UPDATEREMEDY,SER_Constant.ANSSSTT,false,SER_Constant.TOOLONGCOMMENT,false);
    //Claim, comment lenght
    SER_RTM_Task_CallWS.submitTicket(task.Id,UserInfo.getUserId(),SER_Constant.MEDIUM,SER_Constant.SOLUTION,'Claim Remedy',SER_Constant.ANSSSTT,false,SER_Constant.TOOLONGCOMMENT,false);
    //addComment, No Comment
    SER_RTM_Task_CallWS.submitTicket(task.Id,UserInfo.getUserId(),SER_Constant.MEDIUM,SER_Constant.SOLUTION,SER_Constant.SENDCOMMENT,SER_Constant.ANSSSTT,false,'',false);
    //addComment, Comment lenght
    SER_RTM_Task_CallWS.submitTicket(task.Id,UserInfo.getUserId(),SER_Constant.MEDIUM,SER_Constant.SOLUTION,SER_Constant.SENDCOMMENT,SER_Constant.ANSSSTT,false,SER_Constant.TOOLONGCOMMENT,false);
    //addattachment, No Attachmant
    SER_RTM_Task_CallWS.submitTicket(task.Id,UserInfo.getUserId(),SER_Constant.MEDIUM,SER_Constant.SOLUTION,SER_Constant.SENDATTACHMENT,SER_Constant.ANSSSTT,false,SER_Constant.NEWCOMMENT,false);
    //addattachment, Comment lenght
    SER_TestUtils_2.insertAttachment(task.Id);
    SER_RTM_Task_CallWS.submitTicket(task.Id,UserInfo.getUserId(),SER_Constant.MEDIUM,SER_Constant.SOLUTION,SER_Constant.SENDATTACHMENT,SER_Constant.ANSSSTT,false,SER_Constant.TOOLONGCOMMENT,false);
    //Reopen, Blank department
    task.Status = 'Completed';
    update task;
    SER_RTM_Task_CallWS.submitTicket(task.Id,UserInfo.getUserId(),SER_Constant.MEDIUM,SER_Constant.SOLUTION,SER_CallRemedyWS_Task_HELPERLGT.REOPENREMEDY,'',false,SER_Constant.NEWCOMMENT,false);
    //Reopen, Blank Comment
    SER_RTM_Task_CallWS.submitTicket(task.Id,UserInfo.getUserId(),SER_Constant.MEDIUM,SER_Constant.SOLUTION,SER_CallRemedyWS_Task_HELPERLGT.REOPENREMEDY,SER_Constant.ANSSSTT,false,'',false);
    //Reopen, comment lenght
    String response;
    response = SER_RTM_Task_CallWS.submitTicket(task.Id,UserInfo.getUserId(),SER_Constant.MEDIUM,SER_Constant.SOLUTION,SER_CallRemedyWS_Task_HELPERLGT.REOPENREMEDY,SER_Constant.ANSSSTT,false,SER_Constant.TOOLONGCOMMENT,false);
    System.assertEquals('ERRORMax comment length reached, max length is 3500 characters', response, 'Error20');
    Test.stopTest();
  }
}