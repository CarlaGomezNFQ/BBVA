/*---------------------------------------------------------------------------------------------
        Company:       BBVA
        Description:   Class to test SER_Remedy_TaskComment_CONTROLLER class.
----------------------------------------------------------------------------------------------*/
@isTest
public class SER_Remedy_TaskComment_CONTROLLER_TEST {
  /**
  * description: SER_RemedyTaskTab_CONTROLLER.loadTasks
  */
  @isTest
  static void loadCommentsTEST() {
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
    newTask.departament_name__c = 'ANS SSTT';
    newTask.Status = SER_Constant.REMEDYSCALATED;
    insert newTask;

    final TaskComment__c com = new TaskComment__c();
    com.ParentId__c = newTask.Id;
    com.gf_task_comment_body_desc__c = 'CommentBody';
    com.isRemedy__c = true;
    com.gf_task_comment_creator_name__c = 'Jose';
    com.gf_task_comment_date__c = DateTime.now();
    insert com;

    Test.startTest();
      SER_Remedy_TaskComment_CONTROLLER.getInstance();
      SER_Remedy_TaskComment_CONTROLLER.Response response;
      response = SER_Remedy_TaskComment_CONTROLLER.loadComments(newTask.Id);
      System.assert(response.showComments, 'Error');
    Test.stopTest();
  }

}