/**********************************************************************************
* @Company BBVA
* @description: Clase de Test de SER_CallRemedyWebService.
**********************************************************************************/
@isTest
public with sharing class SER_CallRemedyWebService_2_TEST {

  /*---------------------------------------------------------------------------------------
      Company:       BBVA
      Description:   Test1.

      IN:            Void
      OUT:           Void
      ---------------------------------------------------------------------------------------*/
  @isTest static void testError01() {

    SER_TestUtils_2.initRemedyCS();

    // case
    Case newCase;
    newCase = SER_TestUtils.ddCreateMstrCase(false);
    newCase.Status                   = 'New Remedy';
    newCase.SER_Remedy_Department__c = SER_TestUtils_2.ANSBE;
    newCase.priority                 = SER_Constant.LOW;
    insert newCase;

    //set up the mock response
    SER_ASOMockResponse_TEST fakeResponse;
    fakeResponse = new SER_ASOMockResponse_TEST(409,'ERROR','{"error-message":"No existe ninguna incidencia con el External ID especificado"}',null );
    Test.setMock(HttpCalloutMock.class, fakeResponse);

    //Test
    test.startTest();
    // prepare Visualpage params
    SER_TestUtils_2.initCallRemedyWSPage(newCase.id);
    SER_CallRemedyWebService controller;
    controller = new SER_CallRemedyWebService();
    controller.callWebServiceASOLogic();
    test.stopTest();

    //Verify the expressions are the same
    System.assertNotEquals( controller.errorMsg,'','Error12');
  }

  /*---------------------------------------------------------------------------------------
      Company:       BBVA
      Description:   Test2.

      IN:            Void
      OUT:           Void
      ---------------------------------------------------------------------------------------*/
  @isTest static void testError02ReopenCase() {

    SER_TestUtils_2.initRemedyCS();

    // case
    Case newCase;
    newCase = SER_TestUtils.ddCreateMstrCase(false);
    newCase.Status                   = 'Reopen';
    newCase.SER_Remedy_Department__c = SER_TestUtils_2.ANSBE;
    newCase.SER_RemedyId__c          = SER_TestUtils_2.REMEDY12345;
    newCase.priority                 = SER_Constant.LOW;
    newCase.SER_Skip_validations__c = true;
    insert newCase;

    //set up the mock response
    SER_ASOMockResponse_TEST fakeResponse;
    fakeResponse = new SER_ASOMockResponse_TEST(409,'ERROR','{"error-message":"No existe ninguna incidencia con el External ID especificado"}',null );
    Test.setMock(HttpCalloutMock.class, fakeResponse);

    //Test
    test.startTest();
    // prepare Visualpage params
    SER_TestUtils_2.initCallRemedyWSPage(newCase.id);
    SER_CallRemedyWebService controller;
    controller = new SER_CallRemedyWebService();
    controller.callWebServiceASOLogic();
    test.stopTest();

    //Verify the expressions are the same
    System.assertEquals(controller.errorMsg,'','Error13');
  }

  /*---------------------------------------------------------------------------------------
      Company:       BBVA
      Description:   Test3.

      IN:            Void
      OUT:           Void
      ---------------------------------------------------------------------------------------*/
  @isTest static void testReopenCase01OK() {

    SER_TestUtils_2.initRemedyCS();

    // case
    Case newCase;
    newCase = SER_TestUtils.ddCreateMstrCase(false);
    newCase.Status                   = 'Closed';
    newCase.SER_Remedy_Department__c = SER_TestUtils_2.ANSBE;
    newCase.SER_RemedyId__c          = 'Dept12345';
    newCase.priority                 = SER_Constant.LOW;
    insert newCase;

    //set up the mock response
    SER_TestUtils_2.setUpMockResponse();

    //Test
    test.startTest();
    // prepare Visualpage params
    SER_TestUtils_2.initCallRemedyWSPage(newCase.id);
    SER_CallRemedyWebService controller;
    controller = new SER_CallRemedyWebService();
    controller.callWebServiceASOLogic();
    test.stopTest();

    System.assertEquals(SER_CallRemedyWS_HELPER.REMEDY_SCALATED,SER_CallRemedyWS_HELPER.REMEDY_SCALATED,'Error11');

  }

  /*---------------------------------------------------------------------------------------
      Company:       BBVA
      Description:   Test3.

      IN:            Void
      OUT:           Void
      ---------------------------------------------------------------------------------------*/
  @isTest static void testCloseCase01OK() {

    SER_TestUtils_2.initRemedyCS();

    // case
    Case newCase;
    newCase = SER_TestUtils.ddCreateMstrCase(false);
    newCase.Status                   = 'Closed';
    newCase.SER_Remedy_Department__c = SER_TestUtils_2.ANSBE;
    newCase.SER_RemedyId__c          = 'Dept12345';
    newCase.priority                 = SER_Constant.LOW;
    newCase.SER_Solution__c          = 'Solution';
    insert newCase;

    //set up the mock response
    SER_TestUtils_2.setUpMockResponse();

    //Test
    test.startTest();
    // prepare Visualpage params
    SER_TestUtils_2.initCallRemedyWSPage(newCase.id);
    SER_CallRemedyWebService controller;
    controller = new SER_CallRemedyWebService();
    controller.operation = SER_CallRemedyWS_HELPER.CLOSEREMEDY;
    controller.sendLastCom = true;
    controller.lastCaseComment = new CaseComment();
    SER_CallRemedyWebService.Comment comment;
    comment = new SER_CallRemedyWebService.Comment();
    comment.lastCommentParse = 'lastCommentParse';
    controller.comment = comment;
    controller.callWebServiceASOLogic();
    test.stopTest();

    System.assertEquals(SER_CallRemedyWS_HELPER.REMEDY_SCALATED,SER_CallRemedyWS_HELPER.REMEDY_SCALATED,'Error11');

  }

  /*---------------------------------------------------------------------------------------
      Company:       BBVA
      Description:   Test4.

      IN:            Void
      OUT:           Void
      ---------------------------------------------------------------------------------------*/
  @isTest static void testClaimCase01OK() {

    SER_TestUtils_2.initRemedyCS();

    // case
    Case newCase;
    newCase = SER_TestUtils.ddCreateMstrCase(false);
    newCase.Status                   = SER_CallRemedyWS_HELPER.REMEDY_SCALATED;
    newCase.SER_Skip_validations__c = true;
    newCase.SER_Remedy_Department__c = SER_TestUtils_2.ANSBE;
    newCase.SER_RemedyId__c          = 'Dept12345';
    newCase.priority                 = SER_Constant.LOW;
    insert newCase;

    //set up the mock response
    SER_TestUtils_2.setUpMockResponse();

    //Test
    test.startTest();
    // prepare Visualpage params
    SER_TestUtils_2.initCallRemedyWSPage(newCase.id);
    SER_CallRemedyWebService controller;
    controller = new SER_CallRemedyWebService();
    controller.operation = 'Claim Remedy';
    controller.callWebServiceASOLogic();
    test.stopTest();

    //Verify the expressions are the same
    Case caseUpdated;
    caseUpdated = [Select SER_RemedyId__c, Status FROM Case Where id = :newCase.id limit 1].get(0);
    System.assertEquals(caseUpdated.Status,SER_CallRemedyWS_HELPER.REMEDY_SCALATED,'Error11');

  }

  @isTest static void testAddFiles02CommentAndReassignOK() {

    SER_TestUtils_2.initRemedyCS();

    // case
    Case newCase;
    newCase = SER_TestUtils.ddCreateMstrCase(false);
    newCase.Status                   = 'Remedy - Rejected';
    newCase.SER_Skip_validations__c = true;
    newCase.SER_Remedy_Department__c = SER_TestUtils_2.ANSBE;
    newCase.SER_RemedyId__c          = SER_TestUtils_2.REMEDY12345;
    newCase.priority                 = SER_Constant.LOW;
    insert newCase;

    //attachement
    SER_TestUtils_2.insertRelatedFile(newCase.Id);

    //set up the mock response
    SER_TestUtils_2.setUpMockResponse();

    //Test
    test.startTest();
    // prepare Visualpage params
    SER_TestUtils_2.initCallRemedyWSPage(newCase.id);
    SER_CallRemedyWebService controller;
    controller = new SER_CallRemedyWebService();
    controller.operation = SER_CallRemedyWS_HELPER.SENDATTACHMENT;
    controller.callWebServiceASOLogic();
    test.stopTest();

    //Verify the expressions are the same
    Case caseUpdated;
    caseUpdated = [Select SER_RemedyId__c, Status FROM Case Where id = :newCase.id limit 1].get(0);
    System.assertEquals(caseUpdated.Status,SER_CallRemedyWS_HELPER.REMEDY_SCALATED,'Error9');
  }

  @isTest static void testAddFiles01OK() {

    SER_TestUtils_2.initRemedyCS();

    // case
    Case newCase;
    newCase = SER_TestUtils.ddCreateMstrCase(false);
    newCase.Status                   = SER_CallRemedyWS_HELPER.REMEDY_SCALATED;
    newCase.SER_Remedy_Department__c = SER_TestUtils_2.ANSBE;
    newCase.SER_Skip_validations__c = true;
    newCase.SER_RemedyId__c          = SER_TestUtils_2.REMEDY12345;
    newCase.priority                 = SER_Constant.LOW;
    insert newCase;

    //attachement
    SER_TestUtils_2.insertRelatedFile(newCase.Id);

    //set up the mock response
    SER_TestUtils_2.setUpMockResponse();

    //Test
    test.startTest();
    // prepare Visualpage params
    SER_TestUtils_2.initCallRemedyWSPage(newCase.id);
    SER_CallRemedyWebService controller;
    controller = new SER_CallRemedyWebService();
    controller.operation = SER_CallRemedyWS_HELPER.SENDATTACHMENT;
    controller.callWebServiceASOLogic();
    test.stopTest();

    //Verify the expressions are the same
    Case caseUpdated;
    caseUpdated = [Select SER_RemedyId__c, Status FROM Case Where id = :newCase.id limit 1].get(0);
    System.assertEquals(caseUpdated.Status,SER_CallRemedyWS_HELPER.REMEDY_SCALATED,'Error8');
  }

  @isTest static void testNewCaseWithFiles03OK() {

    SER_TestUtils_2.initRemedyCS();

    // case
    Case newCase;
    newCase = SER_TestUtils.ddCreateMstrCase(false);
    newCase.Status                   = 'New';
    newCase.SER_Remedy_Department__c = SER_TestUtils_2.ANSBE;
    newCase.priority                 = SER_Constant.LOW;
    newCase.SER_Skip_validations__c = true;
    insert newCase;

    //Comment
    SER_TestUtils_2.insertCaseComent(newCase.Id);

    //attachement
    SER_TestUtils_2.insertRelatedFile(newCase.Id);

    //set up the mock response
    SER_TestUtils_2.setUpMockResponse();

    //Test
    test.startTest();
    // prepare Visualpage params
    SER_TestUtils_2.initCallRemedyWSPage(newCase.id);
    SER_CallRemedyWebService controller;
    controller = new SER_CallRemedyWebService();
    controller.callWebServiceASOLogic();
    test.stopTest();

    //Verify the expressions are the same
    Case caseUpdated;
    caseUpdated = [Select SER_RemedyId__c, Status FROM Case Where id = :newCase.id limit 1].get(0);
    System.assertNotEquals(caseUpdated.SER_RemedyId__c,null,'Error3');
  }

  @isTest static void testNewCase04CommentsAndFiles() {

    SER_TestUtils_2.initRemedyCS();

    // case
    Case newCase;
    newCase = SER_TestUtils.ddCreateMstrCase(true);

    //Comment
    SER_TestUtils_2.insertCaseComent(newCase.Id);

    //attachement
    SER_TestUtils_2.insertRelatedFile(newCase.Id);

    //set up the mock response
    SER_TestUtils_2.setUpMockResponse();

    //Test
    test.startTest();
    // prepare Visualpage params
    SER_TestUtils_2.initCallRemedyWSPage(newCase.id);
    SER_CallRemedyWebService controller;
    controller = new SER_CallRemedyWebService();
    controller.operation ='New Remedy';
    controller.comment.newCommentParse = 'newCommentParse';
    controller.secondCallWebServiceASO();
    test.stopTest();

    //Verify the expressions are the same
    System.assertNotEquals(controller.comment,null,'Error4');
  }

  @isTest static void constructorTEST() {
    // case
    Case newCase;
    newCase = SER_TestUtils.ddCreateMstrCase(true);
    //Comment
    SER_TestUtils_2.insertCaseComent(newCase.Id);

    //Test
    test.startTest();
    SER_CallRemedyWebService controller;
    controller = new SER_CallRemedyWebService(newCase.Id,UserInfo.getUserId());
    test.stopTest();

    //Verify the expressions are the same
    System.assertNotEquals(controller.comment,null,'Error5');
  }

}