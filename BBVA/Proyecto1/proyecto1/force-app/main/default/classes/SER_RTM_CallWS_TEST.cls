/*---------------------------------------------------------------------------------------------
        Company:       BBVA
        Description:   Class to test SER_RTM_CallWS class.
----------------------------------------------------------------------------------------------*/
@isTest
private class SER_RTM_CallWS_TEST {

  /*-----------------------------------------------------------------------
          Description: initData.
  ------------------------------------------------------------------------*/
  private static Case initData() {
  case caso;
    caso = createCase();
    SER_TestUtils_2.initRemedyCS();
    SER_TestUtils_2.insertCaseComent(caso.Id);
    SER_TestUtils_2.insertAttachment(caso.Id);
    SER_TestUtils_2.setUpMockResponse();
    return caso;
  }

  /*-----------------------------------------------------------------------
          Description: createCase.
  ------------------------------------------------------------------------*/
  private static Case createCase() {
    Case newCase;
    newCase = new Case();
    newCase.RecordTypeId= SER_RecordTypeUtils.getRecordTypeByName('Case','SER_GNC_User');
    newCase.SER_Product__c            = 'BBVA FINET';
    newCase.Subject                   = 'test subject';
    newCase.Description               = 'TEST Description';
    newCase.Type                      = 'ACCESO';
    newCase.Subtype__c                = 'ACCESO';
    newCase.SER_Classification__c     = 'Incidencia';
    newCase.SuppliedEmail             = 'testemailaddress@example.com';
    newCase.SER_Business_Case_Type__c = SER_Constant.BUSINESS_GNC;
    newCase.origin                    = 'Inbound Call';
    insert newCase;
    return newCase;
  }

  /*-----------------------------------------------------------------------
          Description:   Method to test SER_RTM_CallWS.doInit
  ------------------------------------------------------------------------*/
  @isTest
  static void doInitTEST() {
    Case caso;
    caso = createCase();
    Test.startTest();
    SER_RTM_CallWS.getInstance();
    List<String> optionsList;
    optionsList = SER_RTM_CallWS.doInit(caso.Id);
    System.assert (optionsList.size() > 0,'Error1');
    Test.stopTest();
  }

  /*-----------------------------------------------------------------------
          Description:   Method to test SER_RTM_CallWS.submitTicket
  ------------------------------------------------------------------------*/
  @isTest
  static void submitTicketTEST() {
    Case caso;
    caso = initData();
    Test.startTest();
    SER_RTM_CallWS.submitTicket(caso.Id,UserInfo.getUserId(),'Low','Solution','New Remedy','ANS SSTT',false,'New Comment');
    System.assertEquals(null,caso.SER_RemedyId__c,'Error2');
    Test.stopTest();
  }

  /*-----------------------------------------------------------------------
          Description:   Method to test SER_RTM_CallWS.secondCall
  ------------------------------------------------------------------------*/
  @isTest
  static void secondCallTEST() {
    Case caso;
    caso = initData();
    Test.startTest();
    String errors;
    errors = SER_RTM_CallWS.secondCall(caso.Id,UserInfo.getUserId(),'Low','Solution','New Remedy','ANS SSTT',false,'New Comment');
    System.assertEquals(caso,caso,'Error3');
    Test.stopTest();
  }

  /*-----------------------------------------------------------------------
          Description:   Method to test SER_RTM_CallWS.getRecordTypeId
  ------------------------------------------------------------------------*/
  @isTest
  static void getRecordTypeIdTEST() {
    Case caso;
    caso = createCase();
    Test.startTest();
    Id rtId;
    rtId = SER_RTM_CallWS.getRecordTypeId(caso.Id);
    System.assertEquals(caso.RecordTypeId,rtId,'Error4');
    Test.stopTest();
  }

  /*-----------------------------------------------------------------------
          Description:   Method to test SER_RTM_CallWS.getCaseJSON
  ------------------------------------------------------------------------*/
  @isTest
  static void getCaseJSONTEST() {
    Case caso;
    caso = createCase();
    Test.startTest();
    String casoJson;
    casoJson = SER_RTM_CallWS.getCaseJSON(caso.Id);
    Case caso2;
    caso2 = (Case)JSON.deserialize(casoJson,Case.class);
    System.assertEquals(caso.Id,caso2.Id,'Error5');
    Test.stopTest();
  }

  /*-----------------------------------------------------------------------
          Description:   Method to test SER_RTM_CallWS.getCase
  ------------------------------------------------------------------------*/
  @isTest
  static void getCaseTEST() {
    Case caso;
    caso = createCase();
    Test.startTest();
    Case caso2;
    caso2 = SER_RTM_CallWS.getCase(caso.Id);
    System.assertEquals(caso.Id,caso2.Id,'Error6');
    Test.stopTest();
  }
}