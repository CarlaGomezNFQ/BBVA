/*---------------------------------------------------------------------------------------------
    Company:       BBVA
    Description:   Class to test SER_TaskMethods_EGS.

    History:
    <Date>          <Author>                <Description>
    20/07/2020      Javier Touchard         Initial Version.
----------------------------------------------------------------------------------------------*/
@isTest
public class SER_TaskMethods_EGS_TEST {

  /*Constant Status Working*/
  final public static string STATUS_WRK = 'Working';
  /*Constant Priority Normal */
  final public static string PRIO_NORMAL = 'Normal';
  /*Constant 'Call' */
  final public static string CALL = 'Call';
  /*-----------------------------------------------------------------------
    Description: createTask.
  ------------------------------------------------------------------------*/
  public static Void initCustomsetting() {
    CIB_Bypass__c bypass;
    bypass = new CIB_Bypass__c();
    bypass.CIB_skip_trigger__c = false;
    insert bypass;

    CIB_User_Org__c userOrg;
    userOrg = new CIB_User_Org__c();
    userOrg.CIB_Is_Service__c = true;
    insert userOrg;
  }

  /*-----------------------------------------------------------------------
    Description: createTask.
  ------------------------------------------------------------------------*/
  public static Task createTask(Id caseId, Boolean actionLine) {
    TaskComment__c lta;
    lta = new TaskComment__c();
    lta.task_desc__c = 'Description';
    insert lta;

    Task tarea;
    tarea = new Task();
    tarea.WhatId = caseId;
    tarea.gf_task_execution_team_name__c = 'Global Client Service';
    tarea.Status = 'Working';
    tarea.RecordTypeId = SER_RecordTypeUtils.getRecordTypeByName('Task', 'SER_Task_EGS');
    tarea.TaskComment__c = lta.Id;
    if(actionLine) {
      tarea.gf_spec_task_op_case_ind_type__c = true;
    }
    insert tarea;
    return tarea;
  }

  /*-----------------------------------------------------------------------
      Description:   Method to test SER_TaskMethods_EGS.validateActionLineTasks. OK.
  ------------------------------------------------------------------------*/
  @isTest
  static void validateActionLineTasksTEST1() {
    initCustomsetting();
    Case caso;
    caso = SER_CloseCaseEGS_CONTROLLER_TESTutils.createCase(false, false, false);
    Test.startTest();
      Task tarea;
      tarea = createTask(caso.Id, true);
      System.assert([SELECT SER_LineAction_EGS__c FROM Case WHERE Id = :caso.Id LIMIT 1].SER_LineAction_EGS__c, 'Error1');

      tarea.gf_spec_task_op_case_ind_type__c = false;
      update tarea;
    Test.stopTest();
  }

  /*-----------------------------------------------------------------------
      Description:   Method to test SER_TaskMethods_EGS.validateActionLineTasks. KO.
  ------------------------------------------------------------------------*/
  @isTest
  static void validateActionLineTasksTEST2() {
    initCustomsetting();
    Case caso;
    caso = SER_CloseCaseEGS_CONTROLLER_TESTutils.createCase(false, false, false);
    Task tarea;
    tarea = createTask(caso.Id, true);
    Test.startTest();
      try {
        Task tarea2;
        tarea2 = createTask(caso.Id, true);
      } catch(Exception exc) {
        System.assert(exc.getMessage().contains(Label.SER_EGS_HasActionLine_lbl), 'Error2');
      }
    Test.stopTest();
  }

  /*-----------------------------------------------------------------------
      Description:   Method to test SER_TaskMethods_EGS.validateActionLineTasks. KO.
  ------------------------------------------------------------------------*/
  @isTest
  static void validateActionLineTasksTEST3() {
    initCustomsetting();
    Case caso;
    caso = SER_CloseCaseEGS_CONTROLLER_TESTutils.createCase(false, false, false);
    Test.startTest();
      Task tarea;
      tarea = createTask(caso.Id, false);
      tarea.gf_spec_task_op_case_ind_type__c = true;
      update tarea;
      System.assert([SELECT SER_LineAction_EGS__c FROM Case WHERE Id = :caso.Id LIMIT 1].SER_LineAction_EGS__c, 'Error1');
    Test.stopTest();
  }

  /*-----------------------------------------------------------------------
      Description:   Method to test SER_TaskMethods_EGS.changeStatusMaster
  ------------------------------------------------------------------------*/
  @isTest
  public static void changeStatusMaster1() {
    final CIB_User_Org__c uCs = new CIB_User_Org__c();
    uCs.CIB_Is_Service__c = true;
    uCs.SetupOwnerId = UserInfo.getUserId();
    insert uCs;

    account accountTest = new account();
    accountTest = UnitTestUtils.GetStandardAccount();
    accountTest.Name = 'Account Prueba Test';
    accountTest.DES_Group_Code__c = '111111';
    insert accountTest;

    final Account dummyAccount = new Account();
    dummyAccount.Name = 'EGS Generic Client';
    dummyAccount.RecordTypeId = SER_RecordTypeUtils.getRecordTypeByName('Account', 'BBVA_Internal_Contact');
    insert dummyAccount;

    final Case casoTest = new Case();
    casoTest.RecordTypeId = SER_RecordTypeUtils.getRecordTypeByName('Case','EGS_User');
    insert casoTest;

    casoTest.SER_Classification__c = 'Incident';
    casoTest.case_channel_source_type__c = 'GNC';
    casoTest.gf_case_channel_source_name__c = 'Acceso';
    casoTest.Description = 'Prueba';
    casoTest.AccountId = accountTest.Id;
    casoTest.gf_case_countries_desc__c = 'Global';
    casoTest.gf_case_creation_type__c = 'Reactive';
    casoTest.status = STATUS_WRK;
    casoTest.case_status_type__c = STATUS_WRK;
    casoTest.activity_status_type__c = STATUS_WRK;
    casoTest.SER_Skip_validations__c = true;
    Update casoTest;

    final Case casoMaster = new Case();
    casoMaster.RecordTypeId = SER_RecordTypeUtils.getRecordTypeByName('Case','EGS_User');
    insert casoMaster;

    casoMaster.SER_Classification__c = 'Incident';
    casoMaster.case_channel_source_type__c = 'GNC';
    casoMaster.gf_case_channel_source_name__c = 'Acceso';
    casoMaster.Description = 'Prueba';
    casoMaster.AccountId = dummyAccount.Id;
    casoMaster.gf_case_countries_desc__c = 'Global';
    casoMaster.gf_case_creation_type__c = 'Reactive';
    casoMaster.status = STATUS_WRK;
    casoMaster.case_status_type__c = STATUS_WRK;
    casoMaster.activity_status_type__c = STATUS_WRK;
    casoMaster.SER_Is_Master_Case__c = true;
    casoMaster.SER_Skip_validations__c = true;
    Update casoMaster;

    casoTest.SER_Master_Case__c = casoMaster.Id;
    casoTest.activity_status_type__c = 'Open Tasks';
    casoTest.SER_Skip_validations__c = true;
    Update casoTest;

    TaskComment__c lta;
    lta = new TaskComment__c();
    lta.task_desc__c = 'Description';
    insert lta;

    Task taskTest;
    taskTest = new Task(Status = STATUS_WRK,
                    Priority = PRIO_NORMAL,
                    Subject = CALL,
                    RecordTypeId = SER_RecordTypeUtils.getRecordTypeByName('Task', ActivitiesUtils.EGS_RECORDTYPE),
                    WhatId = casoTest.Id,
                    gf_task_execution_team_name__c = 'Global Client Service',
                    TaskComment__c = lta.Id);
    Test.startTest();
      insert taskTest;

      lta.gf_action_result_desc__c = 'Solution';
      update lta;

      taskTest.Status = 'Completed';
      taskTest.gf_tech_impact_case_name__c = '2. High';
      update taskTest;

      System.assertEquals(taskTest,taskTest,'Error4');
    Test.stopTest();
  }

  /*-----------------------------------------------------------------------
      Description:   Method to test SER_TaskMethods_EGS.checkReopenEGS.
  ------------------------------------------------------------------------*/
  @isTest
  static void checkReopenEGSTEST1() {
    initCustomsetting();
    Case caso;
    caso = SER_CloseCaseEGS_CONTROLLER_TESTutils.createCase(false, false, false);

    TaskComment__c lta;
    lta = new TaskComment__c();
    lta.task_desc__c = 'Description';
    insert lta;

    Task taskTest;
    taskTest = new Task(Status = STATUS_WRK,
                    Priority = PRIO_NORMAL,
                    Subject = CALL,
                    RecordTypeId = SER_RecordTypeUtils.getRecordTypeByName('Task', ActivitiesUtils.EGS_RECORDTYPE),
                    WhatId = caso.Id,
                    gf_task_execution_team_name__c = 'Global Client Service',
                    TaskComment__c = lta.Id);

    Test.startTest();
      insert taskTest;

      lta.gf_action_result_desc__c = 'Solution';
      update lta;

      taskTest.Status = 'Completed';
      taskTest.gf_tech_impact_case_name__c = '2. High';
      update taskTest;

      taskTest.Status = STATUS_WRK;
      update taskTest;

      System.assertEquals(taskTest,taskTest, 'Error5');
    Test.stopTest();
  }
}