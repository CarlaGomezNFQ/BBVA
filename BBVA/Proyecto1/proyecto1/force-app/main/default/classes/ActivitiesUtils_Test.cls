/***********************************************************************************************************************************
* @author       Accenture
* @date         01/03/2016
* @description  Clase de test para ActivitiesUtils_Test
* @Revision     Modificacion del metodo crearData y los testMethod para resolucion de errores
************************************************************************************************************************************/
@isTest
public class ActivitiesUtils_Test {
  /* account */
  public static  Account account;
  /* contact */
  public static  Contact contact;
  /* event */
  public static  Event event;
  /* caso */
  public static  Case caso;
  /*Constant Status Working*/
  final public static string STATUS_WRK = 'Working';
  /*Constant Priority Normal */
  final public static string PRIO_NORMAL = 'Normal';
  /*Constant 'Call' */
  final public static string CALL = 'Call';

  /*
      Method Creat Data
  */
  @testSetup public static void crearData() {
    CIB_User_Org__c csiUserOrgInstanc;
    csiUserOrgInstanc = new CIB_User_Org__c();
    csiUserOrgInstanc.CIB_Is_Sales__c = true;
    insert csiUserOrgInstanc;

    gcal__GBL_Google_Calendar_Sync_Environment__c csGcal;
    csGcal = new gcal__GBL_Google_Calendar_Sync_Environment__c();
    csGcal.Name = 'DEV';
    insert csGcal;

    account = UnitTestUtils.GetStandardAccount();
    insert account;

    User sampleFISalesUser;
    sampleFISalesUser = UnitTestUtils.GetFISalesUser();
    insert sampleFISalesUser;

    caso = new Case();
    insert caso;

    contact = UnitTestUtils.GetContact(account.id);
    contact.Logical_Delete__c = False;
    contact.Asset_Class_Text__c = ConstantsUtils.EQ;
    contact.Email = 'test@example.com';
    contact.ownerId = sampleFISalesUser.Id;
    contact.RecordTypeId = SER_RecordTypeUtils.getRecordTypeByName('Contact','SER_Service_Contact_Global_Markets');
    insert contact;

    Event evento;
    evento = new Event(DurationInMinutes = 8,
                      ActivityDateTime = Date.today(),
                      WhatId = caso.Id,
                      WhoId = contact.Id,
                      IsPublicEquity__c = false);
    insert evento;

    Task task1;
    task1 = new Task(OwnerId = sampleFISalesUser.Id,
                          Status = 'Completed',
                          Priority = PRIO_NORMAL,
                          Subject = CALL,
                          WhatId = account.Id,
                          WhoId = contact.Id,
                          type = CALL,
                          IsPublicEquity__c = false);
    insert task1;

    Task task2;
    task2 = new Task(OwnerId = sampleFISalesUser.Id,
                          Status = 'Completed',
                          Priority = PRIO_NORMAL,
                          Subject = CALL,
                          WhoId = contact.Id,
                          type = CALL,
                          IsPublicEquity__c = false);
    insert task2;
  }

  /*---------------------------------------------------------------------------
          Description:   getRecord
  ----------------------------------------------------------------------------*/
  public static void getRecord() {
    account = [SELECT Id FROM Account LIMIT 1];
    caso = [SELECT Id FROM Case LIMIT 1];
    contact =  [SELECT Id, Logical_Delete__c, Asset_Class__c, Email FROM Contact LIMIT 1];
    event = [SELECT Id, DurationInMinutes, ActivityDateTime, WhatId, WhoId, IsPublicEquity__c FROM Event LIMIT 1];
  }

  /*----------------------------------------------------------------------------
          Description:   Method to test ActivitiesUtils.check_EmptyContactEmail
  -----------------------------------------------------------------------------*/
  @isTest
  public static void checkEmptyContactEmailTEST() {

    gcal__GBL_Google_Calendar_Sync_Environment__c csGcal;
    csGcal = new gcal__GBL_Google_Calendar_Sync_Environment__c();
    csGcal.Name = 'DEV';
    insert csGcal;

    account = UnitTestUtils.GetStandardAccount();
    account.Name = Label.SER_SernovaAccountNAME;
    insert account;

    caso = new Case();
    insert caso;

    getRecord();
    Map<Id, Contact> mapContact;
    mapContact = new Map<id, Contact>();
    mapContact.put(contact.Id, contact);
    Test.startTest();
    ActivitiesUtils.check_EmptyContactEmail(mapContact);
    System.assertEquals(ContactTriggerHandler.map_EmptyEmailContacts.get(contact.Id), null, 'Error');
    Test.stopTest();
  }

  /*---------------------------------------------------------------------------
          Description:   Method to test ActivitiesUtils.check_EmptyContactEmail
  ----------------------------------------------------------------------------*/
  @isTest
  public static void check_setTimeAccount_TEST() {

    account = UnitTestUtils.GetStandardAccount();
    account.Name = Label.SER_SernovaAccountNAME;
    insert account;
    caso = new Case();
    insert caso;

    getRecord();
    Map<Id, Contact> mapContact;
    mapContact = new Map<id, Contact>();
    mapContact.put(contact.Id, contact);
    Test.startTest();
    ActivitiesUtils.check_EmptyContactEmail(mapContact);
    System.assertEquals(ContactTriggerHandler.map_EmptyEmailContacts.get(contact.Id), null, 'Error2');
    Test.stopTest();
  }

  /*-----------------------------------------------------------------------
          Description:   Method to test ActivitiesUtils.countCaseTask
  ------------------------------------------------------------------------*/
  @isTest
  public static void countCaseTaskTEST() {
    CIB_User_Org__c uCs;
    uCs = new CIB_User_Org__c();
    uCs.CIB_Is_Service__c = true;
    uCs.SetupOwnerId = UserInfo.getUserId();
    insert uCs;

    account accountTest;
    accountTest = new account();
    accountTest = UnitTestUtils.GetStandardAccount();
    accountTest.Name = 'Account Prueba Test';
    accountTest.DES_Group_Code__c = '111111';
    insert accountTest;

    Case casoTest;
    casoTest = new Case();
    casoTest.RecordTypeId = SER_RecordTypeUtils.getRecordTypeByName('Case','EGS_User');
    insert casoTest;

    casoTest.SER_Classification__c = 'Incident';
    casoTest.case_channel_source_type__c = 'Relay Bank';
    casoTest.gf_case_channel_source_name__c = 'Datos';
    casoTest.Description = 'Prueba';
    casoTest.AccountId = accountTest.Id;
    casoTest.gf_case_countries_desc__c = 'Global';
    casoTest.gf_case_creation_type__c = 'Reactive';
    casoTest.status = STATUS_WRK;
    casoTest.case_status_type__c = STATUS_WRK;
    casoTest.activity_status_type__c = STATUS_WRK;
    casoTest.SER_Skip_validations__c = true;
    Update casoTest;

    Task taskTest;
    taskTest = new Task(Status = STATUS_WRK,
                    Priority = PRIO_NORMAL,
                    Subject = CALL,
                    RecordTypeId = SER_RecordTypeUtils.getRecordTypeByName('Task', ActivitiesUtils.EGS_RECORDTYPE),
                    WhatId = casoTest.Id);

    Test.startTest();
    insert taskTest;
    delete taskTest;
    System.assert(![SELECT SER_TaskCreated_EGS__c FROM Case WHERE Id = :casoTest.Id].SER_TaskCreated_EGS__c, 'Error');
    Test.stopTest();
  }

  /*-----------------------------------------------------------------------
      Description:   Method to test ActivitiesUtils.changeStatusWorking
  ------------------------------------------------------------------------*/
  @isTest
  public static void changeStatusWorkingTEST() {
    final CIB_User_Org__c uCs = new CIB_User_Org__c();
    uCs.CIB_Is_Service__c = true;
    uCs.SetupOwnerId = UserInfo.getUserId();
    insert uCs;

    account accountTest = new account();
    accountTest = UnitTestUtils.GetStandardAccount();
    accountTest.Name = 'Account Prueba Test';
    accountTest.DES_Group_Code__c = '111111';
    insert accountTest;

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
    taskTest.SER_Critical_Issue_EGS__c = true;
    update taskTest;

    casoTest.gf_cust_impact_case_name__c = '1. Critical';
    update casoTest;
    System.assertEquals(taskTest,taskTest,'Error2');
    Test.stopTest();
  }

  /*-----------------------------------------------------------------------
      Description:   Method to test ActivitiesUtils.changeStatusWorking
  ------------------------------------------------------------------------*/
  @isTest
  public static void criticalIssueEGSTEST() {
    final CIB_User_Org__c uCs = new CIB_User_Org__c();
    uCs.CIB_Is_Service__c = true;
    uCs.SetupOwnerId = UserInfo.getUserId();
    insert uCs;

    account accountTest = new account();
    accountTest = UnitTestUtils.GetStandardAccount();
    accountTest.Name = 'Account Prueba Test';
    accountTest.DES_Group_Code__c = '111111';
    insert accountTest;

    final Case casoTest = new Case();
    casoTest.RecordTypeId = SER_RecordTypeUtils.getRecordTypeByName('Case','EGS_User');
    insert casoTest;

    casoTest.SER_Classification__c = 'Incident';
    casoTest.case_channel_source_type__c = 'GCC';
    casoTest.gf_case_channel_source_name__c = 'Conectividad';
    casoTest.Description = 'Prueba';
    casoTest.AccountId = accountTest.Id;
    casoTest.gf_case_countries_desc__c = 'Global';
    casoTest.gf_case_creation_type__c = 'Reactive';
    casoTest.status = STATUS_WRK;
    casoTest.case_status_type__c = STATUS_WRK;
    casoTest.activity_status_type__c = STATUS_WRK;
    casoTest.SER_Skip_validations__c = true;
    Update casoTest;

    Task taskTest;
    taskTest = new Task(Status = STATUS_WRK,
                    Priority = PRIO_NORMAL,
                    Subject = CALL,
                    RecordTypeId = SER_RecordTypeUtils.getRecordTypeByName('Task', ActivitiesUtils.EGS_RECORDTYPE),
                    WhatId = casoTest.Id,
                    gf_tech_impact_case_name__c = '2. High',
                    gf_task_execution_team_name__c = 'Global Client Service');
    Test.startTest();
    insert taskTest;

    taskTest.SER_Critical_Issue_EGS__c = true;
    update taskTest;
    System.assertEquals(taskTest,taskTest,'Error3');
    Test.stopTest();
  }

}