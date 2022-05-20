/*---------------------------------------------------------------------------------------------
    Company:       BBVA
    Description:   Class to test SER_CaseMethodsEGS.
----------------------------------------------------------------------------------------------*/
@isTest
public class SER_CaseMethodsEGS_TEST {

  /*-----------------------------------------------------------------------
      Description:   Method to test SER_CaseMethodsEGS.trackingMasterCase.
                      Se asocia un caso a un caso maestro. OK
  ------------------------------------------------------------------------*/
  @isTest
  static void trackingMasterCaseTEST1() {
    SER_TestUtils_3.initCustomsetting();
    Case masterCase;
    masterCase = SER_CloseCaseEGS_CONTROLLER_TESTutils.createCase(false, true, false);
    Case childrenCase;
    childrenCase = SER_CloseCaseEGS_CONTROLLER_TESTutils.createCase(false, false, false);

    Test.startTest();
      childrenCase.SER_Master_Case__c = masterCase.Id;
      update childrenCase;
      System.assertEquals(1, [SELECT Id FROM FeedItem WHERE ParentId = :masterCase.Id].size(), 'Error1');
    Test.stopTest();
  }

  /*-----------------------------------------------------------------------
      Description:   Method to test SER_CaseMethodsEGS.trackingMasterCase.
                      Un caso que ya esta asociado a un caso maestro se asocia
                      a otro caso maestro distinto. OK
  ------------------------------------------------------------------------*/
  @isTest
  static void trackingMasterCaseTEST2() {
    SER_TestUtils_3.initCustomsetting();
    Case masterCase;
    masterCase = SER_CloseCaseEGS_CONTROLLER_TESTutils.createCase(false, true, false);
    Case childrenCase;
    childrenCase = SER_CloseCaseEGS_CONTROLLER_TESTutils.createCase(false, true, true);
    List<Case> newList;
    newList = new List<Case>();
    Map<Id,Case> oldMap;
    oldMap = new Map<Id,Case>();
    oldMap.put(childrenCase.Id, childrenCase);
    Case newCase;
    newCase = new Case(Id = childrenCase.Id, SER_Master_Case__c = masterCase.Id, RecordTypeId = childrenCase.RecordTypeId);
    newList.add(newCase);

    Test.startTest();
      SER_CaseMethodsEGS.trackingMasterCase(newList, oldMap);
      System.assertEquals(1, [SELECT Id FROM FeedItem WHERE ParentId = :masterCase.Id].size(), 'Error2');
    Test.stopTest();
  }

  /*-----------------------------------------------------------------------
      Description:   Method to test SER_CaseMethodsEGS.trackingMasterCase.
                      Un caso asociado a un caso maestro se des-asocia de
                      ese caso maestro. OK
  ------------------------------------------------------------------------*/
  @isTest
  static void trackingMasterCaseTEST3() {
    SER_TestUtils_3.initCustomsetting();
    Case childrenCase;
    childrenCase = SER_CloseCaseEGS_CONTROLLER_TESTutils.createCase(false, true, true);
    List<Case> newList;
    newList = new List<Case>();
    Map<Id,Case> oldMap;
    oldMap = new Map<Id,Case>();
    oldMap.put(childrenCase.Id, childrenCase);
    Case newCase;
    newCase = new Case(Id = childrenCase.Id, SER_Master_Case__c = SER_BEISearchEngine_CONTROLLER.NULLVALUEID, RecordTypeId = childrenCase.RecordTypeId);
    newList.add(newCase);

    Test.startTest();
      SER_CaseMethodsEGS.trackingMasterCase(newList, oldMap);
      System.assertEquals(2, [SELECT Id FROM FeedItem WHERE ParentId = :childrenCase.SER_Master_Case__c].size(), 'Error2');
    Test.stopTest();
  }

  /*-----------------------------------------------------------------------
      Description:   Method to test SER_CaseMethodsEGS.notifCloseWithMail.
                      Notificación en campana para casos cerrados a los que
                      les llega un email. OK
  ------------------------------------------------------------------------*/
  @isTest
  static void notifCloseWithMailTEST1() {
    Case caso;
    caso = SER_CloseCaseEGS_CONTROLLER_TESTutils.createCase(true, false, false);
    caso.SER_Email_received__c = false;
    update caso;

    Map<Id,Case> oldMap;
    oldMap = new Map<Id,Case>();
    oldMap.put(caso.Id, caso);


    SER_CloseCaseEGS_CONTROLLER.initCloseCase(caso.Id);
    SER_CloseCaseEGS_CONTROLLER.closeCase(caso.Id, true, true, false);
    System.assertEquals(SER_Constant.CLOSED, [SELECT Status FROM Case WHERE Id = :caso.Id].Status, 'Error');
    
    Case casoNuevo = [SELECT Id, SER_Business_Case_Type__c, Status, SER_Email_received__c, CaseNumber FROM Case WHERE Id = :caso.Id];

    casoNuevo.SER_Email_received__c = true;
    update casoNuevo;

    Map<Id,Case> newMap;
    newMap = new Map<Id,Case>();
    newMap.put(casoNuevo.Id, casoNuevo);

    Test.startTest();
    SER_CaseMethodsEGS.notifCloseWithMail(newMap, oldMap);
    Test.stopTest();
  }

  /*-----------------------------------------------------------------------
      Description:   Method to test SER_CaseMethodsEGS.senEmaiNewCaseEGS.
                      Acuse de recibo que se manda cuando se clasifica un caso creado a partir
                      de un email como query o incident. OK
  ------------------------------------------------------------------------*/
  @isTest
  static void senEmaiNewCaseEGSTEST1() {
    Id adminProfileId;
    adminProfileId  = [Select Id from Profile Where Name = 'System Administrator' Limit 1].Id;

    User testUser;
    testUser    = new User(
    Lastname   = 'testing',
    Alias      = 'Alias',
    Email      = 'ppp@ppp.com',
    username   = 'testUser69@testUser.com',
    ProfileId  = adminProfileId,
    ID_User__c = 'XEPrueba',
    isActive   = True,
    EmailEncodingKey = 'UTF-8',
    Timezonesidkey='Europe/London',
    Localesidkey ='en_US',
    languagelocalekey='en_US');
    insert testUser;

    Case caso;
    caso = new Case();
    caso.RecordTypeId = SER_RecordTypeUtils.getRecordTypeByName('Case', 'EGS_User');
    caso.Subject = 'SubjectTest';
    caso.SER_Business_Case_Type__c = SER_Constant.BUSINESS_EGS;
    caso.Origin = 'Email';
    caso.SER_Outbound_Mailbox__c = 'Global Client Service GCS';
    caso.SuppliedEmail = 'test@test.com';
    caso.SER_Classification__c = 'Incident';
    system.runAs(testUser) {
      insert caso;
    }

    List<OrgWideEmailAddress> oweaList;
    oweaList = [SELECT Id, Address FROM OrgWideEmailAddress WHERE DisplayName = 'Global Client Service'];

    EmailMessage email;
    email = new EmailMessage();
    email.Subject = 'Subject Prueba';
    email.FromAddress = 'test1@test1.com';
    email.Incoming = true;
    email.ParentId = caso.Id;
    email.RelatedToId = caso.Id;
    email.SER_EmailServiceCode__c = '<1111111_1@mail.gmail.com>';
    email.ToAddress = oweaList[0].Address;
    email.BccAddress = 'test2@test2.com';
    email.CcAddress = 'test3@test3.com';
    email.HtmlBody = 'HtmlBody';
    email.TextBody = 'TextBody';
    insert email;

    List<Case> newList;
    newList = new List<Case>();
    newList.add(caso);

    Map<Id,Case> oldMap;
    oldMap = new Map<Id,Case>();
    oldMap.put(caso.Id, new Case());

    Test.startTest();
    SER_CaseMethodsEGS.senEmaiNewCaseEGS(newList, oldMap);
    System.assert(!newList.isEmpty(), 'Error_senEmaiNewCaseEGSTEST1');
    Test.stopTest();
  }

}