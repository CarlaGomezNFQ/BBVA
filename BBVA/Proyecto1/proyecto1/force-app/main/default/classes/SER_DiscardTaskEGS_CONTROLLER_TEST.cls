/*---------------------------------------------------------------------------------------------
    Company:       BBVA
    Description:   Class to test SER_DiscardTaskEGS_CONTROLLER_TEST class.
----------------------------------------------------------------------------------------------*/
@isTest
private class SER_DiscardTaskEGS_CONTROLLER_TEST {

  /*-----------------------------------------------------------------------
    Description:   Prueba método showButton. OK.
  ------------------------------------------------------------------------*/
  @isTest
  static void test1() {
    Case caso;
    caso = SER_CloseCaseEGS_CONTROLLER_TESTutils.createCase(true, false, false);

    TaskComment__c lta;
    lta = new TaskComment__c();
    lta.task_desc__c = 'Description';
    insert lta;

    Task tarea;
    tarea = new Task();
    tarea.WhatId = caso.Id;
    tarea.gf_task_execution_team_name__c = 'Global Client Service';
    tarea.Status = 'Working';
    tarea.RecordTypeId = SER_RecordTypeUtils.getRecordTypeByName('Task', 'SER_Task_EGS');
    tarea.TaskComment__c = lta.Id;
    insert tarea;

    Test.startTest();
    String statusTarea;
    statusTarea = SER_DiscardTaskEGS_CONTROLLER.showButton(tarea.Id);
    System.assertEquals(SER_Constant.WORKING, [SELECT Status FROM Task WHERE Id = :tarea.Id].Status, 'Error1');
    Test.stopTest();
  }

  /*-----------------------------------------------------------------------------
    Description:   Descartar tareas sin remedy. test 1 del método saveDiscardCtr
  ------------------------------------------------------------------------------*/
  @isTest
  static void test2() {
   Case caso;
    caso = SER_CloseCaseEGS_CONTROLLER_TESTutils.createCase(true, false, false);
    
    TaskComment__c lta;
    lta = new TaskComment__c();
    lta.task_desc__c = 'Description';
    insert lta;

    Task tarea;
    tarea = new Task();
    tarea.WhatId = caso.Id;
    tarea.gf_task_execution_team_name__c = 'Global Client Service';
    tarea.Status = 'Working';
    tarea.RecordTypeId = SER_RecordTypeUtils.getRecordTypeByName('Task', 'SER_Task_EGS');
    tarea.TaskComment__c = lta.Id;
    insert tarea;

    Test.startTest();
    String responseDiscard;
    responseDiscard = SER_DiscardTaskEGS_CONTROLLER.saveDiscardCtr(tarea.Id);
    System.assertEquals(true, [SELECT SER_Discarded_Duplicated__c FROM Task WHERE Id = :tarea.Id].SER_Discarded_Duplicated__c, 'Error2');
    Test.stopTest();
  }

  /*----------------------------------------------------------------------------------
    Description:   Descartar tareas con remedy. test 2 del método saveDiscardCtr
  -----------------------------------------------------------------------------------*/
  @isTest
  static void test3() {
    SER_TestUtils_2.initRemedyCS();
    SER_TestUtils_2.setUpMockResponse();

    Case caso;
    caso = SER_CloseCaseEGS_CONTROLLER_TESTutils.createCase(true, false, false);

    TaskComment__c lta;
    lta = new TaskComment__c();
    lta.task_desc__c = 'Description';
    insert lta;

    Task tarea;
    tarea = new Task();
    tarea.WhatId = caso.Id;
    tarea.gf_task_execution_team_name__c = 'Global Client Service';
    tarea.Status = 'Working';
    tarea.RecordTypeId = SER_RecordTypeUtils.getRecordTypeByName('Task', 'SER_Task_EGS');
    tarea.TaskComment__c = lta.Id;

    tarea.incidence_id__c = '00000001';
    tarea.Priority = 'Normal';
    tarea.departament_name__c = 'ANS SSTT';
    insert tarea;

    Test.startTest();
    String responseDiscard;
    responseDiscard = SER_DiscardTaskEGS_CONTROLLER.saveDiscardCtr(tarea.Id);
    System.assertEquals(true, [SELECT SER_Discarded_Duplicated__c FROM Task WHERE Id = :tarea.Id].SER_Discarded_Duplicated__c, 'Error3');
    Test.stopTest();
  }

  /*-----------------------------------------------------------------------------------------------------------
    Description:   Descartar tareas con remedy, que falle y reabra la tarea. test 3 del método saveDiscardCtr
  ------------------------------------------------------------------------------------------------------------*/
  @isTest
  static void test4() {
    SER_TestUtils_2.initRemedyCS();
    SER_ASOMockResponse_TEST fakeResponse;
    fakeResponse = new SER_ASOMockResponse_TEST(409,'ERROR','{"error-message":"No existe ninguna incidencia con el External ID especificado"}',null );
    Test.setMock(HttpCalloutMock.class, fakeResponse);

    Case caso;
    caso = SER_CloseCaseEGS_CONTROLLER_TESTutils.createCase(true, false, false);

    TaskComment__c lta;
    lta = new TaskComment__c();
    lta.task_desc__c = 'Description';
    insert lta;

    Task tarea;
    tarea = new Task();
    tarea.WhatId = caso.Id;
    tarea.gf_task_execution_team_name__c = 'Global Client Service';
    tarea.Status = 'Working';
    tarea.RecordTypeId = SER_RecordTypeUtils.getRecordTypeByName('Task', 'SER_Task_EGS');
    tarea.TaskComment__c = lta.Id;

    tarea.incidence_id__c = '00000001';
    tarea.Priority = 'Normal';
    tarea.departament_name__c = 'ANS SSTT';
    insert tarea;

    Test.startTest();
    String responseDiscard;
    responseDiscard = SER_DiscardTaskEGS_CONTROLLER.saveDiscardCtr(tarea.Id);
    System.assertEquals(true, [SELECT SER_Discarded_Duplicated__c FROM Task WHERE Id = :tarea.Id].SER_Discarded_Duplicated__c, 'Error4');
    Test.stopTest();
  }

  /*-----------------------------------------------------------------------------------------------------------
    Description:   Descartar tareas con remedy, que falle y reabra la tarea. test 4 del método saveDiscardCtr
  ------------------------------------------------------------------------------------------------------------*/
  @isTest
  static void test5() {
    SER_TestUtils_2.initRemedyCS();
    SER_ASOMockResponse_TEST fakeResponse;
    fakeResponse = new SER_ASOMockResponse_TEST(409,'ERROR','{"error-message":"No existe ninguna incidencia con el External ID especificado"}',null );
    Test.setMock(HttpCalloutMock.class, fakeResponse);

    Case caso;
    caso = SER_CloseCaseEGS_CONTROLLER_TESTutils.createCase(true, false, false);

    TaskComment__c lta;
    lta = new TaskComment__c();
    lta.task_desc__c = 'Description';
    insert lta;

    Task tarea;
    tarea = new Task();
    tarea.WhatId = caso.Id;
    tarea.gf_task_execution_team_name__c = 'Global Client Service';
    tarea.Status = 'Working';
    tarea.RecordTypeId = SER_RecordTypeUtils.getRecordTypeByName('Task', 'SER_Task_EGS');
    tarea.TaskComment__c = lta.Id;

    tarea.incidence_id__c = '00000001';
    tarea.Priority = 'Normal';
    tarea.departament_name__c = 'ANS SSTT';
    insert tarea;

    Test.startTest();
    String responseDiscard;
    responseDiscard = SER_DiscardTaskEGS_CONTROLLER.saveDiscardCtr(tarea.Id);
    System.assertEquals(true, [SELECT SER_Discarded_Duplicated__c FROM Task WHERE Id = :tarea.Id].SER_Discarded_Duplicated__c, 'Error5');
    Test.stopTest();
  }

  /*-----------------------------------------------------------------------
    Description:   Save Log. OK
  ------------------------------------------------------------------------*/
  @isTest
  static void test6() {
    Case caso;
    caso = SER_CloseCaseEGS_CONTROLLER_TESTutils.createCase(true, false, false);

    TaskComment__c lta;
    lta = new TaskComment__c();
    lta.task_desc__c = 'Description';
    insert lta;

    Task tarea;
    tarea = new Task();
    tarea.WhatId = caso.Id;
    tarea.gf_task_execution_team_name__c = 'Global Client Service';
    tarea.Status = 'Working';
    tarea.RecordTypeId = SER_RecordTypeUtils.getRecordTypeByName('Task', 'SER_Task_EGS');
    tarea.TaskComment__c = lta.Id;
    insert tarea;

    Test.startTest();
    SER_DiscardTaskEGS_CONTROLLER.saveLog('Test', tarea.Id, null, 'Test error');
    System.assertEquals(tarea.Id, [SELECT CIB_RecordId__c FROM CIB_Log__c WHERE CIB_Subject__c = 'Test'].CIB_RecordId__c, 'Error6');
    Test.stopTest();
  }

}