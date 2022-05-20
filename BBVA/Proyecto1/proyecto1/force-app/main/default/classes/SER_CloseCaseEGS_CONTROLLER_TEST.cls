/*---------------------------------------------------------------------------------------------
    Company:       BBVA
    Description:   Class to test SER_CloseCaseEGS_CONTROLLER class.
----------------------------------------------------------------------------------------------*/
@isTest
private class SER_CloseCaseEGS_CONTROLLER_TEST {

  /*-----------------------------------------------------------------------
    Description:   Close a case without tasks. Reopen. OK
  ------------------------------------------------------------------------*/
  @isTest
  static void test1() {
    Case caso;
    caso = SER_CloseCaseEGS_CONTROLLER_TESTutils.createCase(true, false, false);
    Test.startTest();
    SER_CloseCaseEGS_CONTROLLER.initCloseCase(caso.Id);
    SER_CloseCaseEGS_CONTROLLER.closeCase(caso.Id, true, true, false);
    System.assertEquals(SER_Constant.CLOSED, [SELECT Status FROM Case WHERE Id = :caso.Id].Status, 'Error');
    SER_CloseCaseEGS_CONTROLLER.reopenCase(caso.Id);
    Map<Id,Case> oldMap;
    oldMap = new Map<Id,Case>();
    oldMap.put(caso.Id, caso);
    List<Case> newList;
    newList = new List<Case>();
    newList.add(new case(Id = caso.Id, SER_Classification__c = 'Query'));
    SER_CloseCaseEGS_CONTROLLER.fillInitialClassification(newList, oldMap);
    SER_CloseCaseEGS_HELPER.fillClassification(true, caso);
    SER_CloseCaseEGS_HELPER.fillClassification(false, caso);
    Test.stopTest();
  }

  /*-----------------------------------------------------------------------
    Description:   Close a case with tasks. Master Case. Close Task. 1º parte. OK
  ------------------------------------------------------------------------*/
  @isTest
  static void test2() {
    Case caso;
    caso = SER_CloseCaseEGS_CONTROLLER_TESTutils.createCase(true, false, false);
    SER_CloseCaseEGS_CONTROLLER_TESTutils.createTask(caso.Id, false, false);
    Test.startTest();
    String response;
    response = '';
    response = SER_CloseCaseEGS_CONTROLLER.closeCase(caso.Id, false, true, false);
    System.assertEquals('PROGRThere are tasks already in progress.', response, 'Error2');
    Test.stopTest();
  }

  /*-----------------------------------------------------------------------
    Description:   Close a case with tasks. Master Case. Close Task. 2ª parte. OK
  ------------------------------------------------------------------------*/
  @isTest
  static void test3() {
    Case caso;
    caso = SER_CloseCaseEGS_CONTROLLER_TESTutils.createCase(true, false, false);
    SER_CloseCaseEGS_CONTROLLER_TESTutils.createTask(caso.Id, false, false);
    Test.startTest();
    SER_CloseCaseEGS_CONTROLLER.closeCase(caso.Id, true, true, false);
    System.assertEquals(SER_Constant.COMPLETED, [SELECT Status FROM Task WHERE whatId = :caso.Id].Status, 'Error3');
    Test.stopTest();
  }

  /*----------------------------------------------------------------------------------
    Description:   Close a case with tasks and Remedys. Close Task. Close Remedy. OK
  -----------------------------------------------------------------------------------*/
  @isTest
  static void test4() {
    SER_TestUtils_2.initRemedyCS();
    SER_TestUtils_2.setUpMockResponse();
    Case caso;
    caso = SER_CloseCaseEGS_CONTROLLER_TESTutils.createCase(true, false, false);
    SER_CloseCaseEGS_CONTROLLER_TESTutils.createTask(caso.Id, true, false);
    Test.startTest();
    SER_CloseCaseEGS_CONTROLLER.closeCase(caso.Id, true, true, false);
    System.assertEquals(SER_Constant.CLOSED, [SELECT Status FROM Case WHERE Id = :caso.Id].Status, 'Error4');
    Test.stopTest();
  }

  /*-----------------------------------------------------------------------
    Description:   Close a case with tasks Action Line. KO
  ------------------------------------------------------------------------*/
  @isTest
  static void test5() {
    Case caso;
    caso = SER_CloseCaseEGS_CONTROLLER_TESTutils.createCase(true, false, false);
    SER_CloseCaseEGS_CONTROLLER_TESTutils.createTask(caso.Id, false, true);
    Test.startTest();
    String response;
    response = '';
    response = SER_CloseCaseEGS_CONTROLLER.closeCase(caso.Id, true, true, false);
    System.assertEquals('ERRORThis case cannot be closed because it has an "Action Line" task in progress.', response, 'Error5');
    Test.stopTest();
  }

  /*-----------------------------------------------------------------------
    Description:   Close a case whithout Solution. KO
  ------------------------------------------------------------------------*/
  @isTest
  static void test6() {
    Case caso;
    caso = SER_CloseCaseEGS_CONTROLLER_TESTutils.createCase(false, false, false);
    Test.startTest();
    String response;
    response = '';
    response = SER_CloseCaseEGS_CONTROLLER.closeCase(caso.Id, true, true, false);
    System.assertEquals('ERRORThe following fields should be populated to Resolve or Close the case (Classification, Channel, Typology, Environment, Description, Client Impact, Client Name, Country Issue, Detected By, Solution, Origin, Close Category, Severity, Subject)', response, 'Error6');
    Test.stopTest();
  }

  /*-----------------------------------------------------------------------
    Description:   Save Log. OK
  ------------------------------------------------------------------------*/
  @isTest
  static void test7() {
    Case caso;
    caso = SER_CloseCaseEGS_CONTROLLER_TESTutils.createCase(true, false, false);
    Test.startTest();
    SER_CloseCaseEGS_CONTROLLER.saveLog('Test', caso.Id, null, 'Test error');
    System.assertEquals(caso.Id, [SELECT CIB_RecordId__c FROM CIB_Log__c WHERE CIB_Subject__c = 'Test'].CIB_RecordId__c, 'Error7');
    Test.stopTest();
  }

  /*----------------------------------------------------------------------------------
    Description:    Close a case with tasks and Remedys. Close Task. Close Remedy.
                    Reopen Case, task. KO. Master Case.
  -----------------------------------------------------------------------------------*/
  @isTest
  static void test8() {
    SER_TestUtils_2.initRemedyCS();
    SER_ASOMockResponse_TEST fakeResponse;
    fakeResponse = new SER_ASOMockResponse_TEST(409,'ERROR','{"error-message":"No existe ninguna incidencia con el External ID especificado"}',null );
    Test.setMock(HttpCalloutMock.class, fakeResponse);
    Case caso;
    caso = SER_CloseCaseEGS_CONTROLLER_TESTutils.createCase(true, false, false);
    SER_CloseCaseEGS_CONTROLLER_TESTutils.createTask(caso.Id, true, false);
    Case masterCase;
    masterCase = SER_CloseCaseEGS_CONTROLLER_TESTutils.createCase(true, true, false);
    SER_CloseCaseEGS_CONTROLLER_TESTutils.createTask(masterCase.Id, true, false);
    caso.SER_Master_Case__c = masterCase.Id;
    update caso;
    Test.startTest();
    SER_CloseCaseEGS_CONTROLLER.closeCase(masterCase.Id, true, true, false);
    System.assertEquals(SER_Constant.CLOSED, [SELECT Status FROM Case WHERE Id = :caso.Id].Status, 'Error8');
    Test.stopTest();
  }

  /*-----------------------------------------------------------------------
    Description:   Resolve a case. OK.
  ------------------------------------------------------------------------*/
  @isTest
  static void test9() {
    Case caso;
    caso = SER_CloseCaseEGS_CONTROLLER_TESTutils.createCase(true, false, false);
    Test.startTest();
    SER_CloseCaseEGS_CONTROLLER.initCloseCase(caso.Id);
    SER_CloseCaseEGS_CONTROLLER.resolveCase(caso.Id, true);
    System.assertEquals(SER_Constant.RESOLVED, [SELECT Status FROM Case WHERE Id = :caso.Id].Status, 'Error9');
    Test.stopTest();
  }

  /*-----------------------------------------------------------------------
    Description:   Resolve a case whithout Solution. KO
  ------------------------------------------------------------------------*/
  @isTest
  static void test10() {
    Case caso;
    caso = SER_CloseCaseEGS_CONTROLLER_TESTutils.createCase(false, false, false);
    Test.startTest();
    String response;
    response = '';
    response = SER_CloseCaseEGS_CONTROLLER.resolveCase(caso.Id, true);
    System.assertEquals('ERRORThe following fields should be populated to Resolve or Close the case (Classification, Channel, Typology, Environment, Description, Client Impact, Client Name, Country Issue, Detected By, Solution, Origin, Close Category, Severity, Subject)', response, 'Error10');
    Test.stopTest();
  }

  /*-----------------------------------------------------------------------
    Description:   Resolve a case query. OK.
  ------------------------------------------------------------------------*/
  @isTest
  static void test11() {
    Id casoId;
    casoId = SER_CloseCaseEGS_CONTROLLER_TESTutils.createCaseQuery(true);
    Test.startTest();
    SER_CloseCaseEGS_CONTROLLER.initCloseCase(casoId);
    SER_CloseCaseEGS_CONTROLLER.resolveCase(casoId, true);
    System.assertEquals(SER_Constant.RESOLVED, [SELECT Status FROM Case WHERE Id = :casoId].Status, 'Error11');
    Test.stopTest();
  }

  /*-----------------------------------------------------------------------
    Description:   Close a case query without tasks. Reopen. OK
  ------------------------------------------------------------------------*/
  @isTest
  static void test12() {
    Id casoId;
    casoId = SER_CloseCaseEGS_CONTROLLER_TESTutils.createCaseQuery(true);
    Test.startTest();
    SER_CloseCaseEGS_CONTROLLER.initCloseCase(casoId);
    SER_CloseCaseEGS_CONTROLLER.closeCase(casoId, true, true, false);
    System.assertEquals(SER_Constant.CLOSED, [SELECT Status FROM Case WHERE Id = :casoId].Status, 'Error12');
    SER_CloseCaseEGS_CONTROLLER.reopenCase(casoId);
    Test.stopTest();
  }

  /*-----------------------------------------------------------------------
    Description:   Close a case whithout Solution. KO
  ------------------------------------------------------------------------*/
  @isTest
  static void test13() {
    Id casoId;
    casoId = SER_CloseCaseEGS_CONTROLLER_TESTutils.createCaseQuery(false);
    Test.startTest();
    String response;
    response = '';
    response = SER_CloseCaseEGS_CONTROLLER.closeCase(casoId, true, true, false);
    System.assertEquals('ERRORThe following fields should be populated to Resolve or Close the case (Classification, Channel, Typology, Environment, Description, Client Name, Solution, Subject)', response, 'Error13');
    Test.stopTest();
  }

  /*-----------------------------------------------------------------------
    Description:   Resolve a case whithout Solution. KO
  ------------------------------------------------------------------------*/
  @isTest
  static void test14() {
    Id casoId;
    casoId = SER_CloseCaseEGS_CONTROLLER_TESTutils.createCaseQuery(false);
    Test.startTest();
    String response;
    response = '';
    response = SER_CloseCaseEGS_CONTROLLER.resolveCase(casoId, true);
    System.assertEquals('ERRORThe following fields should be populated to Resolve or Close the case (Classification, Channel, Typology, Environment, Description, Client Name, Solution, Subject)', response, 'Error14');
    Test.stopTest();
  }

  /*-----------------------------------------------------------------------
    Description:   Close a Master Case. Close Task. 1º parte. OK. Master Case
  ------------------------------------------------------------------------*/
  @isTest
  static void test15() {
    Case caso;
    caso = SER_CloseCaseEGS_CONTROLLER_TESTutils.createCase(true, false, false);
    Case masterCase;
    masterCase = SER_CloseCaseEGS_CONTROLLER_TESTutils.createCase(true, true, false);
    caso.SER_Master_Case__c = masterCase.Id;
    update caso;
    SER_CloseCaseEGS_CONTROLLER_TESTutils.createTask(caso.Id, false, false);
    SER_CloseCaseEGS_CONTROLLER_TESTutils.createTask(caso.Id, false, true);
    SER_CloseCaseEGS_CONTROLLER_TESTutils.createTask(masterCase.Id, false, true);
    SER_CloseCaseEGS_CONTROLLER_TESTutils.createTask(masterCase.Id, false, false);
    Test.startTest();
    String response;
    response = '';
    response = SER_CloseCaseEGS_CONTROLLER.closeCase(masterCase.Id, false, true, false);
    System.assert(response.contains('PROGRThere are tasks already in progress'), 'Error15');
    Test.stopTest();
  }

  /*-----------------------------------------------------------------------
    Description:   Close a Master Case. Close Task. 1º parte. OK. Master Case
  ------------------------------------------------------------------------*/
  @isTest
  static void test16() {
    Case caso;
    caso = SER_CloseCaseEGS_CONTROLLER_TESTutils.createCase(true, false, false);
    Case masterCase;
    masterCase = SER_CloseCaseEGS_CONTROLLER_TESTutils.createCase(true, true, false);
    caso.SER_Master_Case__c = masterCase.Id;
    update caso;
    Test.startTest();
    String response;
    response = '';
    response = SER_CloseCaseEGS_CONTROLLER.closeCase(masterCase.Id, true, true, false);
    System.assertEquals('', response, 'Error16');
    Test.stopTest();
  }

  /*-----------------------------------------------------------------------
    Description:   Close a case without tasks. Clone. OK
  ------------------------------------------------------------------------*/
  @isTest
  static void test17() {
    Case caso;
    caso = SER_CloseCaseEGS_CONTROLLER_TESTutils.createCase(true, false, false);
    Test.startTest();
    SER_CloseCaseEGS_CONTROLLER.initCloseCase(caso.Id);
    SER_CloseCaseEGS_CONTROLLER.closeCase(caso.Id, true, true, false);
    System.assertEquals(SER_Constant.CLOSED, [SELECT Status FROM Case WHERE Id = :caso.Id].Status, 'Error');
    caso.SER_Email_received__c = true;
    update caso;
    Id casoNuevo;
    casoNuevo = SER_CloseCaseEGS_CONTROLLER.cloneCase(caso.Id);

    EmailMessage mensaje;
    mensaje = SER_CloseCaseEGS_CONTROLLER_TESTutils.createEmail(caso.Id);

    SER_TestUtils_2.insertAttachment(mensaje.Id);
    SER_CloseCaseEGS_CONTROLLER.cloneEmailMessage(caso.Id, casoNuevo);
    SER_CloseCaseEGS_CONTROLLER.updateCasoP(caso.Id);
    Test.stopTest();
  }

  /*-----------------------------------------------------------------------
    Description:   Close a case without tasks. Reopen. OK
  ------------------------------------------------------------------------*/
  @isTest
  static void test18() {
    Case caso;
    caso = SER_CloseCaseEGS_CONTROLLER_TESTutils.createCase(true, false, false);
    Test.startTest();
    SER_CloseCaseEGS_CONTROLLER.initCloseCase(caso.Id);
    SER_CloseCaseEGS_CONTROLLER.closeCase(caso.Id, true, true, true);
    System.assertEquals(SER_Constant.CLOSED, [SELECT Status FROM Case WHERE Id = :caso.Id].Status, 'Error');
    SER_CloseCaseEGS_CONTROLLER.reopenCase(caso.Id);
    Test.stopTest();
  }

}