/*---------------------------------------------------------------------------------------------
        Company:       BBVA
        Description:   Class to test SER_CaseDetails_CONTROLLER class.
----------------------------------------------------------------------------------------------*/
@isTest
public class SER_CaseDetails_CONTROLLER_TEST {
  /**
  * description: SER_CaseDetails_CONTROLLER.getCase Test. OK
  */
  @isTest
  static void getCaseTEST() {
    Case newCase;
    newCase = new Case();
    newCase.SER_Classification__c = 'Incidencia';
    newCase.Subject = 'test subject';
    insert newCase;

    Task newTask;
    newTask = new Task();
    newTask.Subject = 'Other';
    newTask.WhatId = newCase.Id;
    newTask.RecordTypeId = SER_RecordTypeUtils.getRecordTypeByName('Task','SER_Task_EGS');
    newTask.departament_name__c = 'ANS SSTT';
    newTask.Status = SER_Constant.REMEDYSCALATED;

    CIB_User_Org__c cset;
    cset = new CIB_User_Org__c();
    cset.CIB_Is_Service__c = true;
    cset.Name = 'User Org (User)';
    insert cset;

    Test.startTest();
      insert newTask;
      Case caso;
      caso = SER_CaseDetails_CONTROLLER.getCase(newTask.Id);
      System.assertNotEquals(null, caso, 'Error');
    Test.stopTest();
  }

  /**
  * description: SER_CaseDetails_CONTROLLER.getCase Test. KO.
  */
  @isTest
  static void getCaseTEST2() {
    Case newCase;
    newCase = new Case();
    newCase.SER_Classification__c = 'Incidencia';
    newCase.Subject = 'test subject';
    insert newCase;

    Test.startTest();
      Try {
        SER_CaseDetails_CONTROLLER.getCase(newCase.Id);
      } catch(Exception exc) {
        System.assertEquals('Script-thrown exception', exc.getMessage(), 'Error2');
      }
    Test.stopTest();
  }
}