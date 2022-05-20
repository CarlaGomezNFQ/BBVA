/*---------------------------------------------------------------------------------------------
        Company:       BBVA
        Description:   Class to test SER_TaskCommentMethods class.
----------------------------------------------------------------------------------------------*/
@isTest
public class SER_TaskCommentMethods_TEST {

  /*-----------------------------------------------------------------------
          Description: createCase.
  ------------------------------------------------------------------------*/
  private static TaskComment__c createData() {
    Case newCase;
    newCase = new Case();
    newCase.RecordTypeId = SER_RecordTypeUtils.getRecordTypeByName('Case','EGS_User');
    newCase.SER_Classification__c = 'Incident';
    newCase.Subject = 'test subject';
    insert newCase;

    TaskComment__c lta;
    lta = new TaskComment__c();
    insert lta;

    Task newTask;
    newTask = new Task();
    newTask.Subject = 'Other';
    newTask.WhatId = newCase.Id;
    newTask.RecordTypeId = SER_RecordTypeUtils.getRecordTypeByName('Task','SER_Task_EGS');
    newTask.TaskComment__c = lta.Id;
    insert newTask;

    return lta;
  }

  /**
  * description: fillTaskDescriptionSolution. Campos description y solution superiores 
  *              a 255 caracteres. OK.
  */
  @isTest
  static void fillTaskDescriptionSolutionTEST1() {
    TaskComment__c lta;
    lta = createData();
    lta.task_desc__c = SER_Constant.TOOLONGCOMMENT;
    lta.gf_action_result_desc__c = SER_Constant.TOOLONGCOMMENT;
    Test.startTest();
    update lta;
    System.assert ([SELECT task_desc__c FROM Task WHERE Subject = 'Other'].task_desc__c.length() < 255, 'Error1');
    Test.stopTest();
  }

  /**
  * description: fillTaskDescriptionSolution. Campos description y solution inferiores 
  *              a 255 caracteres. OK.
  */
  @isTest
  static void fillTaskDescriptionSolutionTEST2() {
    TaskComment__c lta;
    lta = createData();
    lta.task_desc__c = 'Description';
    lta.gf_action_result_desc__c = 'Solution';
    Test.startTest();
    update lta;
    System.assertEquals('Description', [SELECT task_desc__c FROM Task WHERE Subject = 'Other'].task_desc__c, 'Error2');
    Test.stopTest();
  }

}