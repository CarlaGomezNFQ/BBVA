/**********************************************************************************
* @Company BBVA
* @description: Clase de Test de SER_CallRemedyWebService.
**********************************************************************************/
@isTest
public with sharing class SER_CallRemedyWebService_TEST {

  /*---------------------------------------------------------------------------------------
      Company:       BBVA
      Description:   Test1.

      IN:            Void
      OUT:           Void
      ---------------------------------------------------------------------------------------*/
  @isTest static void testNewCase03OK() {

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
    SER_TestUtils_2.insertAttachment(newCase.Id);

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


  /*---------------------------------------------------------------------------------------
      Company:       BBVA
      Description:   Test2.

      IN:            Void
      OUT:           Void
      ---------------------------------------------------------------------------------------*/
  @isTest static void testNewCase04CommentsAndAttach() {

    SER_TestUtils_2.initRemedyCS();

    // case
    Case newCase;
    newCase = SER_TestUtils.ddCreateMstrCase(true);

    //Comment
    SER_TestUtils_2.insertCaseComent(newCase.Id);

    //attachement
    SER_TestUtils_2.insertAttachment(newCase.Id);

    //set up the mock response
    SER_TestUtils_2.setUpMockResponse();

    //Test
    test.startTest();
    // prepare Visualpage params
    SER_TestUtils_2.initCallRemedyWSPage(newCase.id);
    SER_CallRemedyWebService controller;
    controller = new SER_CallRemedyWebService();
    controller.operation ='New Remedy';
    controller.secondCallWebServiceASO();
    test.stopTest();

    //Verify the expressions are the same
    System.assertNotEquals(controller.comment,null,'Error4');
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
    newCase.Status                   = 'Reopen';
    newCase.SER_Remedy_Department__c = SER_TestUtils_2.ANSBE;
    newCase.SER_RemedyId__c          = SER_TestUtils_2.REMEDY12345;
    newCase.priority                 = SER_Constant.LOW;
    newCase.SER_Skip_validations__c = true;
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

    //Verify the expressions are the same
    Case caseUpdated;
    caseUpdated = [Select SER_RemedyId__c, Status FROM Case Where id = :newCase.id limit 1].get(0);
    System.assertEquals(caseUpdated.Status,'Reopen','Error5');
  }

  /*---------------------------------------------------------------------------------------
      Company:       BBVA
      Description:   Test4.

      IN:            Void
      OUT:           Void
      ---------------------------------------------------------------------------------------*/
  @isTest static void testAddComment01OK() {

    SER_TestUtils_2.initRemedyCS();

    // case
    Case newCase;
    newCase = SER_TestUtils.ddCreateMstrCase(false);
    newCase.Status                   = SER_CallRemedyWS_HELPER.REMEDY_SCALATED;
    newCase.SER_Remedy_Department__c = SER_TestUtils_2.ANSBE;
    newCase.SER_RemedyId__c          = SER_TestUtils_2.REMEDY12345;
    newCase.priority                 = SER_Constant.LOW;
    newCase.SER_Skip_validations__c = true;
    insert newCase;

    //Comment
    SER_TestUtils_2.insertCaseComent(newCase.Id);

    //set up the mock response
    SER_TestUtils_2.setUpMockResponse();

    //Test
    test.startTest();
    // prepare Visualpage params
    SER_TestUtils_2.initCallRemedyWSPage(newCase.id);
    SER_CallRemedyWebService controller;
    controller = new SER_CallRemedyWebService();
    controller.operation = SER_CallRemedyWS_HELPER.SENDCOMMENT;
    controller.callWebServiceASOLogic();
    test.stopTest();

    //Verify the expressions are the same
    Case caseUpdated;
    caseUpdated = [Select SER_RemedyId__c, Status FROM Case Where id = :newCase.id limit 1].get(0);
    System.assertEquals(caseUpdated.Status,SER_CallRemedyWS_HELPER.REMEDY_SCALATED,'Error6');
  }

  /*---------------------------------------------------------------------------------------
      Company:       BBVA
      Description:   Test5.

      IN:            Void
      OUT:           Void
      ---------------------------------------------------------------------------------------*/
  @isTest static void testAddComment02CommentAndReassignOK() {

    SER_TestUtils_2.initRemedyCS();

    // case
    Case newCase;
    newCase = SER_TestUtils.ddCreateMstrCase(false);
    newCase.Status                   = 'Remedy - Rejected';
    newCase.SER_Remedy_Department__c = SER_TestUtils_2.ANSBE;
    newCase.SER_RemedyId__c          = SER_TestUtils_2.REMEDY12345;
    newCase.priority                 = SER_Constant.LOW;
    newCase.SER_Skip_validations__c = true;
    insert newCase;

    //Comment
    SER_TestUtils_2.insertCaseComent(newCase.Id);

    //set up the mock response
    SER_TestUtils_2.setUpMockResponse();

    //Test
    test.startTest();
    // prepare Visualpage params
    SER_TestUtils_2.initCallRemedyWSPage(newCase.id);
    SER_CallRemedyWebService controller;
    controller = new SER_CallRemedyWebService();
    controller.operation = SER_CallRemedyWS_HELPER.SENDCOMMENT;
    controller.callWebServiceASOLogic();
    test.stopTest();

    //Verify the expressions are the same
    Case caseUpdated;
    caseUpdated = [Select SER_RemedyId__c, Status FROM Case Where id = :newCase.id limit 1].get(0);
    System.assertEquals(caseUpdated.Status,SER_CallRemedyWS_HELPER.REMEDY_SCALATED,'Error7');
  }

  /*---------------------------------------------------------------------------------------
      Company:       BBVA
      Description:   Test6.

      IN:            Void
      OUT:           Void
      ---------------------------------------------------------------------------------------*/
  @isTest static void testAddAttach01OK() {

    SER_TestUtils_2.initRemedyCS();

    // case
    Case newCase;
    newCase = SER_TestUtils.ddCreateMstrCase(false);
    newCase.Status                   = SER_CallRemedyWS_HELPER.REMEDY_SCALATED;
    newCase.SER_Remedy_Department__c = SER_TestUtils_2.ANSBE;
    newCase.SER_RemedyId__c          = SER_TestUtils_2.REMEDY12345;
    newCase.priority                 = SER_Constant.LOW;
    newCase.SER_Skip_validations__c = true;
    insert newCase;

    //attachement
    SER_TestUtils_2.insertAttachment(newCase.Id);

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

  /*---------------------------------------------------------------------------------------
      Company:       BBVA
      Description:   Test7.

      IN:            Void
      OUT:           Void
      ---------------------------------------------------------------------------------------*/
  @isTest static void testAddAttach02CommentAndReassignOK() {

    SER_TestUtils_2.initRemedyCS();

    // case
    Case newCase;
    newCase = SER_TestUtils.ddCreateMstrCase(false);
    newCase.Status                   = 'Remedy - Rejected';
    newCase.SER_Remedy_Department__c = SER_TestUtils_2.ANSBE;
    newCase.SER_RemedyId__c          = SER_TestUtils_2.REMEDY12345;
    newCase.priority                 = SER_Constant.LOW;
    newCase.SER_Skip_validations__c = true;
    insert newCase;

    //attachement
    SER_TestUtils_2.insertAttachment(newCase.Id);

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

  /*---------------------------------------------------------------------------------------
      Company:       BBVA
      Description:   Test8.

      IN:            Void
      OUT:           Void
      ---------------------------------------------------------------------------------------*/
  @isTest static void testUpdateCase01OK() {

    SER_TestUtils_2.initRemedyCS();

    // case
    Case newCase;
    newCase = SER_TestUtils.ddCreateMstrCase(false);
    newCase.Status                   = SER_CallRemedyWS_HELPER.REMEDY_SCALATED;
    newCase.SER_RemedyId__c          = SER_TestUtils_2.REMEDY12345;
    newCase.SER_Remedy_Department__c = SER_TestUtils_2.ANSBE;
    newCase.priority                 = SER_Constant.LOW;
    newCase.SER_Skip_validations__c = true;
    insert newCase;

    CaseComment comentario;
    comentario = new CaseComment();
    comentario.CommentBody = 'CommentBody';
    comentario.ParentId = newCase.Id;
    insert comentario;

    //set up the mock response
    SER_TestUtils_2.setUpMockResponse();

    //Test
    test.startTest();
    // prepare Visualpage params
    SER_TestUtils_2.initCallRemedyWSPage(newCase.id);
    SER_CallRemedyWebService controller;
    controller = new SER_CallRemedyWebService();
    controller.operation = 'Update Remedy';
    controller.sendLastCom = true;
    controller.callWebServiceASOLogic();
    test.stopTest();

    //Verify the expressions are the same
    Case caseUpdated;
    caseUpdated = [Select SER_RemedyId__c, Status FROM Case Where id = :newCase.id limit 1].get(0);
    System.assertEquals(caseUpdated.Status,SER_CallRemedyWS_HELPER.REMEDY_SCALATED,'Error10');
  }

  /*---------------------------------------------------------------------------------------
      Company:       BBVA
      Description:   Test9.

      IN:            Void
      OUT:           Void
      ---------------------------------------------------------------------------------------*/
  @isTest static void testUpdateCase02OK() {

    SER_TestUtils_2.initRemedyCS();

    // case
    Case newCase;
    newCase = SER_TestUtils.ddCreateMstrCase(false);
    newCase.Status                   = 'Remedy - Pending to close';
    newCase.SER_RemedyId__c          = SER_TestUtils_2.REMEDY12345;
    newCase.SER_Remedy_Department__c = SER_TestUtils_2.ANSBE;
    newCase.priority                 = SER_Constant.LOW;
    newCase.SER_Skip_validations__c = true;
    insert newCase;

    //set up the mock response
    SER_TestUtils_2.setUpMockResponse();

    //Test
    test.startTest();
    // prepare Visualpage params
    SER_TestUtils_2.initCallRemedyWSPage(newCase.id);
    SER_CallRemedyWebService controller;
    controller = new SER_CallRemedyWebService();
    controller.operation = 'Update Remedy';
    controller.secondCallWebServiceASO();
    test.stopTest();

    //Verify the expressions are the same
    Case caseUpdated;
    caseUpdated = [Select SER_RemedyId__c, Status FROM Case Where id = :newCase.id limit 1].get(0);
    System.assertEquals(caseUpdated.Status,'Remedy - Pending to close','Error11');
  }

}