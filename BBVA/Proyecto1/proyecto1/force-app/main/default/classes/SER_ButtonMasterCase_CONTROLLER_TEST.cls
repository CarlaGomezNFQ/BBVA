/*---------------------------------------------------------------------------------------------
  Company:       BBVA
  Description:   Class to test SER_ButtonMasterCase_CONTROLLER.

  History:
    <Date>           <Author>               <Description>
    13/06/2019      Javier Touchard         Initial Version.
----------------------------------------------------------------------------------------------*/
@isTest
private class SER_ButtonMasterCase_CONTROLLER_TEST {
  /*-------------------------------------------------------------------------------------------
    Description:   Method to test SER_ButtonMasterCase_CONTROLLER.saveMasterCaseCtr STE.OK.
  ---------------------------------------------------------------------------------------------*/
  @isTest
  static void saveMasterCaseCtrTEST1() {
    SER_TestUtils_3.initCustomsetting();
    Case steCase;
    steCase = SER_TestUtils.ddCreateMstrCase(true);
    Test.startTest();
      SER_ButtonMasterCase_CONTROLLER.saveMasterCaseCtr(steCase.Id);
      System.assert(steCase.SER_Is_Master_Case__c,'Error1');
    Test.stopTest();
  }

  /*-------------------------------------------------------------------------------------------
    Description:   Method to test SER_ButtonMasterCase_CONTROLLER.saveMasterCaseCtr.KO.
  ---------------------------------------------------------------------------------------------*/
  @isTest
  static void saveMasterCaseCtrTEST2() {
    SER_TestUtils_3.initCustomsetting();
    Case steCase;
    steCase = SER_TestUtils.ddCreateCase(true);
    Test.startTest();
      SER_ButtonMasterCase_CONTROLLER.saveMasterCaseCtr(null);
      System.assert(!steCase.SER_Is_Master_Case__c,'Error2');
    Test.stopTest();
  }

  /*-------------------------------------------------------------------------------------------
    Description:   Method to test SER_ButtonMasterCase_CONTROLLER.saveMasterCaseCtr EGS.OK.
  ---------------------------------------------------------------------------------------------*/
  @isTest
  static void saveMasterCaseCtrTEST3() {
    SER_TestUtils_3.initCustomsetting();
    final Account dummyAccount = new Account();
    dummyAccount.Name = 'EGS Generic Client';
    dummyAccount.RecordTypeId = SER_RecordTypeUtils.getRecordTypeByName('Account', 'BBVA_Internal_Contact');
    insert dummyAccount;

    Case egsCase;
    egsCase = SER_TestUtils.ddCrMstrCaseEGS(true);
    egsCase.AccountId                = SER_TestUtils.ddCreateAccount(true).Id;
    egsCase.case_status_type__c      = SER_Constant.WORKING;
    egsCase.Status                   = SER_Constant.WORKING;
    egsCase.activity_status_type__c  = SER_Constant.WORKING;
    egsCase.SER_Skip_validations__c  = true;
    egsCase.SER_TaskCreated_EGS__c   = true;
    update egsCase;

    Task tarea;
    tarea = new Task();
    tarea.WhatId = egsCase.Id;
    tarea.gf_task_execution_team_name__c = 'Global Client Service';
    tarea.Status = SER_Constant.WORKING;
    tarea.RecordTypeId = SER_RecordTypeUtils.getRecordTypeByName('Task', 'SER_Task_EGS');
    insert tarea;
    
    Test.startTest();
      SER_ButtonMasterCase_CONTROLLER.saveMasterCaseCtr(egsCase.Id);
      System.assertEquals(null,egsCase.SER_Master_Case__c,'Error3');
    Test.stopTest();
  }

  /*-------------------------------------------------------------------------------------------
    Description:   Method to test SER_ButtonMasterCase_CONTROLLER.saveMasterCaseCtr EGS.OK.
  ---------------------------------------------------------------------------------------------*/
  @isTest
  static void saveMasterCaseCtrTEST4() {
    SER_TestUtils_3.initCustomsetting();
    final Account dummyAccount = new Account();
    dummyAccount.Name = 'EGS Generic Client';
    dummyAccount.RecordTypeId = SER_RecordTypeUtils.getRecordTypeByName('Account', 'BBVA_Internal_Contact');
    insert dummyAccount;

    Case egsCase;
    egsCase = SER_TestUtils.ddCrMstrCaseEGS(true);
    egsCase.AccountId                = dummyAccount.Id;
    egsCase.case_status_type__c      = SER_Constant.WORKING;
    egsCase.Status                   = SER_Constant.WORKING;
    egsCase.activity_status_type__c  = SER_Constant.WORKING;
    egsCase.SER_Skip_validations__c  = true;
    update egsCase;
    
    Test.startTest();
      SER_ButtonMasterCase_CONTROLLER.saveMasterCaseCtr(egsCase.Id);
      System.assertEquals(null,egsCase.SER_Master_Case__c,'Error3');
    Test.stopTest();
  }

  /*-------------------------------------------------------------------------------------------
    Description:   Method to test SER_ButtonMasterCase_CONTROLLER.showButton STE.OK.
  ---------------------------------------------------------------------------------------------*/
  @isTest
  static void showButtonTEST1() {
    SER_TestUtils_3.initCustomsetting();
    Case steCase;
    steCase = SER_TestUtils.ddCreateMstrCase(true);
    steCase.SER_Remedy_Department__c = 'ANS Banca de Empresas';
    steCase.Status = 'Remedy - Rejected';
    steCase.SER_Skip_validations__c = true;
    steCase.SER_Is_Master_Case__c = false;
    update steCase;
    Test.startTest();
      //Boolean response;
      //response = SER_ButtonMasterCase_CONTROLLER.showButton(steCase.Id);
      //System.assert(response,'Error3');
      string response;
      response = SER_ButtonMasterCase_CONTROLLER.showButton(steCase.Id);
      System.assertEquals('STE',response,'Error4');
    Test.stopTest();
  }

  /*-------------------------------------------------------------------------------------------
    Description:   Method to test SER_ButtonMasterCase_CONTROLLER.showButton STE.KO.
  ---------------------------------------------------------------------------------------------*/
  @isTest
  static void showButtonTEST2() {
    Test.startTest();
      //Boolean response;
      //response = SER_ButtonMasterCase_CONTROLLER.showButton(null);
      //System.assertEquals(null,response,'Error4');
      string response;
      response = SER_ButtonMasterCase_CONTROLLER.showButton(null);
      System.assertEquals(null,response,'Error5');
    Test.stopTest();
  }

  /*-------------------------------------------------------------------------------------------
    Description:   Method to test SER_ButtonMasterCase_CONTROLLER.showButton EGS.OK.
  ---------------------------------------------------------------------------------------------*/
  @isTest
  static void showButtonTEST3() {
    Case egsCase;
    egsCase = SER_TestUtils.ddCrMstrCaseEGS(true);
    egsCase.AccountId                = SER_TestUtils.ddCreateAccount(true).Id;
    egsCase.case_status_type__c      = SER_Constant.WORKING;
    egsCase.Status                   = SER_Constant.WORKING;
    egsCase.activity_status_type__c  = SER_Constant.WORKING;
    egsCase.SER_Skip_validations__c = true;
    update egsCase;

    Test.startTest();
      string response;
      response = SER_ButtonMasterCase_CONTROLLER.showButton(egsCase.Id);
      System.assertEquals('EGS',response,'Error6');
    Test.stopTest();
  }
}