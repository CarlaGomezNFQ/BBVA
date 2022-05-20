/*--------------------------------------------------------------------------------------------------------------------
    Author:        Javier SS
    Company:       Accenture
    Description:   TEST de los Web Service que se expone para que se invoque desde Remedy y se sincronicen los
                    cambios relaizados entre el ticket Remedy y el Case Salesforce

    History:
    2017-03-27          Javier SS                Creación de la clase
----------------------------------------------------------------------------------------------------------------------*/
@isTest
private class SER_RemedyWebService_TEST {
  /*Id Remedy genérico*/
  private static final string REMEDY_ID = 'Remedy_1234';
  /*Id Remedy genérico*/
  private static final string REMEDY_ID2 ='Remedy_1111';
  /* Status de caso New*/
  private static final string STATUS_NEW = 'New';
  /* Status de caso New*/
  private static final string STATUS_REJ = 'Remedy - Rejected';
  /*Literal para buscar el recordtype*/
  private static final string NAME_CASE = 'Case';
  /*RecordType STE*/
  private static final string RT_STE = 'SER_STE_User';

  @isTest
  static void testUpdateStatusRemedyTicket() {
    //Data needed
    CIB_ByPassUtils.enableByPassAllSelfUser();
    final Case newCase = SER_TestUtils.ddCrChildCase();
    newCase.SER_Type_EST__c         = '';
    newCase.SER_Subtype_STE__c      = '';
    newCase.SER_Type_GM__c          = '';
    newCase.SER_Subtype_GM__c       = '';
    newCase.SER_RemedyId__c = REMEDY_ID;
    newCase.Status = STATUS_NEW;
    newCase.recordTypeId = (Id) SER_RecordTypeUtils.getRecordTypeByName(NAME_CASE,RT_STE);
    insert newCase;

    //Test
    test.startTest();

    // prepare ws Request
    final SER_RemedyWebService.EntitySyncDto wsRequest = new SER_RemedyWebService.EntitySyncDto();
    wsRequest.objects = new List<SER_RemedyWebService.RemedyTicket>();
    //ticket null data
    final SER_RemedyWebService.RemedyTicket remedyTkt01 = new SER_RemedyWebService.RemedyTicket();
    wsRequest.objects.add(remedyTkt01);

    //ticket correct data
    final SER_RemedyWebService.RemedyTicket remedyTkt02 = new SER_RemedyWebService.RemedyTicket();
    remedyTkt02.remedyId = REMEDY_ID;
    remedyTkt02.comment = 'Comment line_02';
    remedyTkt02.newStatus = STATUS_REJ;
    wsRequest.objects.add(remedyTkt02);
    //ticket incorrect data
    final SER_RemedyWebService.RemedyTicket remedyTkt03 = new SER_RemedyWebService.RemedyTicket();
    remedyTkt03.remedyId = REMEDY_ID2;
    remedyTkt03.comment = 'Comment line_02';
    remedyTkt03.newStatus = STATUS_REJ;
    wsRequest.objects.add(remedyTkt03);
    //ticket incorrect data
    final SER_RemedyWebService.RemedyTicket remedyTkt04 = new SER_RemedyWebService.RemedyTicket();
    remedyTkt04.remedyId = REMEDY_ID2;
    remedyTkt04.comment = 'Comment line_03';
    remedyTkt04.newStatus = STATUS_NEW;
    wsRequest.objects.add(remedyTkt04);

    // ws Response
    final SER_RemedyWebService.SyncResultDto wsResponse = SER_RemedyWebService.updateStatusRemedyTicket(wsRequest);

    system.debug(Logginglevel.INFO,'>>>>>>> wsResponse:' + wsResponse);

    test.stopTest();

    //Verify the expressions are the same
    System.assertEquals(wsResponse.successes.size(), 1,'testUpdateStatusRemedyTicket');
  }

  @isTest
  static void testAddCommentRemedyTicket() {
    //Data needed
    CIB_ByPassUtils.enableByPassAllSelfUser();
    final Case newCase = SER_TestUtils.ddCrChildCase();
    newCase.SER_Type_EST__c         = '';
    newCase.SER_Subtype_STE__c      = '';
    newCase.SER_Type_GM__c          = '';
    newCase.SER_Subtype_GM__c       = '';
    newCase.SER_RemedyId__c = REMEDY_ID;
    newCase.Status = STATUS_NEW;
    newCase.recordTypeId = (Id) SER_RecordTypeUtils.getRecordTypeByName(NAME_CASE,RT_STE);
    insert newCase;

    //Test
    test.startTest();
    // prepare ws Request
    final SER_RemedyWebService.EntitySyncDto wsRequest = new SER_RemedyWebService.EntitySyncDto();
    wsRequest.objects = new List<SER_RemedyWebService.RemedyTicket>();
    //ticket null data
    final SER_RemedyWebService.RemedyTicket remedyTkt01 = new SER_RemedyWebService.RemedyTicket();
    wsRequest.objects.add(remedyTkt01);

    //ticket correct data
    final SER_RemedyWebService.RemedyTicket remedyTkt02 = new SER_RemedyWebService.RemedyTicket();
    remedyTkt02.remedyId = REMEDY_ID;
    remedyTkt02.comment = 'Comment line_02';
    wsRequest.objects.add(remedyTkt02);
    //ticket incorrect data
    final SER_RemedyWebService.RemedyTicket remedyTkt03 = new SER_RemedyWebService.RemedyTicket();
    remedyTkt03.remedyId = REMEDY_ID2;
    remedyTkt03.comment = 'Comment line_03';
    wsRequest.objects.add(remedyTkt03);

    // ws Response
    final SER_RemedyWebService.SyncResultDto wsResponse = SER_RemedyWebService.addCommentRemedyTicket(wsRequest);

    system.debug(Logginglevel.INFO, '>>>>>>> wsResponse:' + wsResponse);

    test.stopTest();
    //Verify the expressions are the same
    System.assertEquals(wsResponse.errors.size(), 2,'testAddCommentRemedyTicket');
  }

  @isTest
  static void testupdateRemedyGroupRemedyTicket() {
    //Data needed
    CIB_ByPassUtils.enableByPassAllSelfUser();
    // User newUser = SER_TestUtils.ddCreateUser('Service Integration',true);
    final Case newCase = SER_TestUtils.ddCrChildCase();
    newCase.SER_Type_EST__c         = '';
    newCase.SER_Subtype_STE__c      = '';
    newCase.SER_Type_GM__c          = '';
    newCase.SER_Subtype_GM__c       = '';
    newCase.SER_RemedyId__c = REMEDY_ID;
    newCase.Status = STATUS_NEW;
    newCase.recordTypeId = (Id) SER_RecordTypeUtils.getRecordTypeByName(NAME_CASE,RT_STE);
    insert newCase;

    //Test
    test.startTest();
    // prepare ws Request
    final SER_RemedyWebService.EntitySyncDto wsRequest = new SER_RemedyWebService.EntitySyncDto();
    wsRequest.objects = new List<SER_RemedyWebService.RemedyTicket>();
    //ticket null data
    final SER_RemedyWebService.RemedyTicket remedyTkt01 = new SER_RemedyWebService.RemedyTicket();
    wsRequest.objects.add(remedyTkt01);

    //ticket correct data
    final SER_RemedyWebService.RemedyTicket remedyTkt02 = new SER_RemedyWebService.RemedyTicket();
    remedyTkt02.remedyId = REMEDY_ID;
    remedyTkt02.transferredRemedyDept = 'Group_02';
    remedyTkt02.idTransferredRemedyDept = 'Code_02';
    remedyTkt02.comment = 'Comment_02';
    wsRequest.objects.add(remedyTkt02);
    //ticket incorrect data
    final SER_RemedyWebService.RemedyTicket remedyTkt03 = new SER_RemedyWebService.RemedyTicket();
    remedyTkt03.remedyId = REMEDY_ID2;
    remedyTkt03.transferredRemedyDept = 'Group_03';
    remedyTkt03.idTransferredRemedyDept = 'Code_03';
    wsRequest.objects.add(remedyTkt03);

    // ws Response
    final SER_RemedyWebService.SyncResultDto wsResponse = SER_RemedyWebService.updateRemedyGroupRemedyTicket(wsRequest);
    system.debug(Logginglevel.INFO, '>>>>>>> wsResponse:' + wsResponse);

    test.stopTest();

    //Verify the expressions are the same
    //System.assertEquals(wsResponse.errors.size(), 2);
    //System.assertEquals(wsResponse.successes.size(), 1);
    final Case caseUpdated = [Select SER_RemedyId__c, SER_Remedy_Transition_Department__c FROM Case Where SER_RemedyId__c = :newCase.SER_RemedyId__c limit 1].get(0);
    System.assertEquals(remedyTkt02.transferredRemedyDept, caseUpdated.SER_Remedy_Transition_Department__c,'testupdateRemedyGroupRemedyTicket');
  }

  @isTest
  static void testUpdateCommitmentDateRemedyTicket() {
    //Data needed
    CIB_ByPassUtils.enableByPassAllSelfUser();
    // User newUser = SER_TestUtils.ddCreateUser('Service Integration',true);
    final Case newCase = SER_TestUtils.ddCrChildCase();
    newCase.SER_Type_EST__c         = '';
    newCase.SER_Subtype_STE__c      = '';
    newCase.SER_Type_GM__c          = '';
    newCase.SER_Subtype_GM__c       = '';
    newCase.SER_RemedyId__c = REMEDY_ID;
    newCase.Status = STATUS_NEW;
    newCase.recordTypeId = (Id) SER_RecordTypeUtils.getRecordTypeByName(NAME_CASE,RT_STE);

    insert newCase;
    //Test
    test.startTest();
    // prepare ws Request
    final SER_RemedyWebService.EntitySyncDto wsRequest = new SER_RemedyWebService.EntitySyncDto();
    wsRequest.objects = new List<SER_RemedyWebService.RemedyTicket>();
    //ticket null data
    final SER_RemedyWebService.RemedyTicket remedyTkt01 = new SER_RemedyWebService.RemedyTicket();
    wsRequest.objects.add(remedyTkt01);

    //ticket correct data
    final SER_RemedyWebService.RemedyTicket remedyTkt02 = new SER_RemedyWebService.RemedyTicket();
    remedyTkt02.remedyId = REMEDY_ID;
    remedyTkt02.commitmentDate = '31/01/2017 12:00:00';
    remedyTkt02.comment = 'Comment_02';
    wsRequest.objects.add(remedyTkt02);
    //ticket incorrect data
    final SER_RemedyWebService.RemedyTicket remedyTkt03 = new SER_RemedyWebService.RemedyTicket();
    remedyTkt03.remedyId = REMEDY_ID2;
    remedyTkt03.commitmentDate = '31/01/2017 12:00:00';
    wsRequest.objects.add(remedyTkt03);

    // ws Response
    final SER_RemedyWebService.SyncResultDto wsResponse = SER_RemedyWebService.updateCommitmentDateRemedyTicket(wsRequest);

    system.debug(Logginglevel.INFO, '>>>>>>> wsResponse:' + wsResponse);

    test.stopTest();
    //Verify the expressions are the same
//        System.assertEquals(wsResponse.errors.size(), 2);
//        System.assertEquals(wsResponse.successes.size(), 1);

    final Case caseUpdated = [Select SER_RemedyId__c, SER_Commitment_Date__c FROM Case Where SER_RemedyId__c = :newCase.SER_RemedyId__c limit 1].get(0);

    system.debug(Logginglevel.INFO,'>>>>>>> remedyTkt02.commitmentDate: ' + remedyTkt02.commitmentDate);
    system.debug(Logginglevel.INFO,'>>>>>>> newCase.SER_Commitment_Date__c: ' + caseUpdated.SER_Commitment_Date__c);
    System.assertEquals(remedyTkt02.commitmentDate, caseUpdated.SER_Commitment_Date__c.format('DD/MM/YYYY HH:mm:ss'),'testUpdateCommitmentDateRemedyTicket');
  }


// --------------------------------------------------------------------------
// --> TEST METHODS con Request Nula
// --------------------------------------------------------------------------
//

  @isTest
  static void testUpdateStatusRemedyTicketError() {
    //Data needed
    CIB_ByPassUtils.enableByPassAllSelfUser();
    // User newUser = SER_TestUtils.ddCreateUser('Service Integration',true);
    final Case newCase = SER_TestUtils.ddCrChildCase();
    newCase.SER_Type_EST__c         = '';
    newCase.SER_Subtype_STE__c      = '';
    newCase.SER_Type_GM__c          = '';
    newCase.SER_Subtype_GM__c       = '';
    newCase.SER_RemedyId__c = REMEDY_ID;
    newCase.Status = STATUS_NEW;
    newCase.recordTypeId = (Id) SER_RecordTypeUtils.getRecordTypeByName(NAME_CASE,RT_STE);
    insert newCase;

    //Test
    test.startTest();
    // prepare ws Request
    final SER_RemedyWebService.EntitySyncDto wsRequest = new SER_RemedyWebService.EntitySyncDto();
    wsRequest.objects = new List<SER_RemedyWebService.RemedyTicket>();

    // ws Response
    final SER_RemedyWebService.SyncResultDto wsResponse = SER_RemedyWebService.updateStatusRemedyTicket(wsRequest);

    system.debug(Logginglevel.INFO, '>>>>>>> wsResponse:' + wsResponse);

    test.stopTest();

    System.assertEquals(wsResponse.successes.size(), 0,'testUpdateStatusRemedyTicketError');
  }

  @isTest
  static void testAddCommentRemedyTicketError() {
    //Data needed
    CIB_ByPassUtils.enableByPassAllSelfUser();
    // User newUser = SER_TestUtils.ddCreateUser('Service Integration',true);
    final Case newCase = SER_TestUtils.ddCrChildCase();
    newCase.SER_Type_EST__c         = '';
    newCase.SER_Subtype_STE__c      = '';
    newCase.SER_Type_GM__c          = '';
    newCase.SER_Subtype_GM__c       = '';
    newCase.SER_RemedyId__c = REMEDY_ID;
    newCase.Status = STATUS_NEW;
    newCase.recordTypeId = (Id) SER_RecordTypeUtils.getRecordTypeByName(NAME_CASE,RT_STE);
    insert newCase;

    //Test
    test.startTest();
    // prepare ws Request
    final SER_RemedyWebService.EntitySyncDto wsRequest = new SER_RemedyWebService.EntitySyncDto();
    wsRequest.objects = new List<SER_RemedyWebService.RemedyTicket>();

    // ws Response
    final SER_RemedyWebService.SyncResultDto wsResponse = SER_RemedyWebService.addCommentRemedyTicket(wsRequest);
    system.debug(Logginglevel.INFO, '>>>>>>> wsResponse:' + wsResponse);

    test.stopTest();
    //Verify the expressions are the same
    System.assertEquals(wsResponse.successes.size(), 0, 'testAddCommentRemedyTicketError');
  }

  @isTest
  static void testUpdateRemedyGroupRemedyTicketError() {
    //Data needed
    CIB_ByPassUtils.enableByPassAllSelfUser();
    // User newUser = SER_TestUtils.ddCreateUser('Service Integration',true);
    final Case newCase = SER_TestUtils.ddCrChildCase();
    newCase.SER_Type_EST__c         = '';
    newCase.SER_Subtype_STE__c      = '';
    newCase.SER_Type_GM__c          = '';
    newCase.SER_Subtype_GM__c       = '';
    newCase.SER_RemedyId__c = REMEDY_ID;
    newCase.Status = STATUS_NEW;
    newCase.recordTypeId = (Id) SER_RecordTypeUtils.getRecordTypeByName(NAME_CASE,RT_STE);
    insert newCase;
    //Test
    test.startTest();
    // prepare ws Request
    final SER_RemedyWebService.EntitySyncDto wsRequest = new SER_RemedyWebService.EntitySyncDto();
    wsRequest.objects = new List<SER_RemedyWebService.RemedyTicket>();

    // ws Response
    final SER_RemedyWebService.SyncResultDto wsResponse = SER_RemedyWebService.updateRemedyGroupRemedyTicket(wsRequest);

    system.debug(Logginglevel.INFO, '>>>>>>> wsResponse:' + wsResponse);

    test.stopTest();
    System.assertEquals(wsResponse.successes.size(), 0,'testUpdateRemedyGroupRemedyTicketError');
  }

  @isTest
  static void testUpdateCommitmentDateRemedyTicketError() {
    //Data needed
    CIB_ByPassUtils.enableByPassAllSelfUser();
    // User newUser = SER_TestUtils.ddCreateUser('Service Integration',true);
    final Case newCase = SER_TestUtils.ddCrChildCase();
    newCase.SER_Type_EST__c         = '';
    newCase.SER_Subtype_STE__c      = '';
    newCase.SER_Type_GM__c          = '';
    newCase.SER_Subtype_GM__c       = '';
    newCase.SER_RemedyId__c = REMEDY_ID;
    newCase.Status = STATUS_NEW;
    newCase.recordTypeId = (Id) SER_RecordTypeUtils.getRecordTypeByName(NAME_CASE,RT_STE);
    insert newCase;

    //Test
    test.startTest();
    // prepare ws Request
    final SER_RemedyWebService.EntitySyncDto wsRequest = new SER_RemedyWebService.EntitySyncDto();
    wsRequest.objects = new List<SER_RemedyWebService.RemedyTicket>();

    // ws Response
    final SER_RemedyWebService.SyncResultDto wsResponse = SER_RemedyWebService.updateCommitmentDateRemedyTicket(wsRequest);

    system.debug(Logginglevel.INFO, '>>>>>>> wsResponse:' + wsResponse);

    test.stopTest();
    //Verify the expressions are the same
    System.assertEquals(wsResponse.errors.size(), 1,'testUpdateCommitmentDateRemedyTicketError');
  }

  @isTest
  static void webServicesTaskTest() {
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
    newTask.incidence_id__c = REMEDY_ID;
    newTask.departament_name__c = 'ANS SSTT';
    newTask.Status = SER_Constant.REMEDYSCALATED;
    insert newTask;

    test.startTest();
    final SER_RemedyWebService.EntitySyncDto wsRequest = new SER_RemedyWebService.EntitySyncDto();
    wsRequest.objects = new List<SER_RemedyWebService.RemedyTicket>();

    final SER_RemedyWebService.RemedyTicket remedyTkt = new SER_RemedyWebService.RemedyTicket();
    remedyTkt.remedyId = REMEDY_ID;
    remedyTkt.comment = 'Comment';
    wsRequest.objects.add(remedyTkt);

    SER_RemedyWebService.addCommentRemedyTicket(wsRequest);

    wsRequest.objects[0].transferredRemedyDept = 'ANS Banca de Empresas';
    wsRequest.objects[0].idTransferredRemedyDept = 'SGP000000007012';
    wsRequest.objects[0].comment = 'Comment2';
    SER_RemedyWebService.updateRemedyGroupRemedyTicket(wsRequest);

    wsRequest.objects[0].commitmentDate = '01/01/2020 12:12:00';
    SER_RemedyWebService.updateCommitmentDateRemedyTicket(wsRequest);

    wsRequest.objects[0].newStatus = 'Remedy - Pending to close';
    wsRequest.objects[0].comment = 'Comment3';
    final SER_RemedyWebService.SyncResultDto wsResponse5 = SER_RemedyWebService.updateStatusRemedyTicket(wsRequest);
    System.assertEquals('0', wsResponse5.successes[0].statusCode, 'ErrorTask1');
    test.stopTest();
  }
}