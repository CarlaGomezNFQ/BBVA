/*---------------------------------------------------------------------------------------------
        Company:       BBVA
        Description:   Class to test SER_RemedyTaskTab_CONTROLLER class.
----------------------------------------------------------------------------------------------*/
@isTest
public class SER_RemedyTaskTab_CONTROLLER_TEST {
  /**
  * description: SER_RemedyTaskTab_CONTROLLER.loadTasks
  */
  @isTest
  static void loadTasksTEST() {
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
    Test.startTest();
      SER_RemedyTaskTab_CONTROLLER.getInstance();
      SER_RemedyTaskTab_CONTROLLER.Response response;
      response = SER_RemedyTaskTab_CONTROLLER.loadTasks(newTask.Id);
      System.assert(response.isIncidence, 'Error');
    Test.stopTest();
  }
}