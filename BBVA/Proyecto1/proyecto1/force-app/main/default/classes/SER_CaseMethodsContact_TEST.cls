/*----------------------------------------------------------------------------------
    Author:        BBVA
    Company:       BBVA
    Description:   Testclass for SER_CaseMethodsContact.

    History:
      <Date>          <Author>             <Description>
    06/06/2019     Javier Touchard        Initial version
    -----------------------------------------------------------------------------------*/
@isTest
private class SER_CaseMethodsContact_TEST {

  /*-----------------------------------------------------------------------
      Description: createCase.
      ------------------------------------------------------------------------*/
  private static Case createCase() {
    String rtId;
    rtId = SER_RecordTypeUtils.getRecordTypeByName('Case','SER_GM_User');

    Case newCase;
    newCase = new Case();
    newCase.RecordTypeId              = rtId;
    newCase.Subject                   = 'TEST Subject';
    newCase.Description               = 'TEST Description';
    newCase.Type                       = 'TEST Type';
    newCase.Subtype__c                  = 'TEST Subtype';
    newCase.SER_Type_GM__c               = 'Certificados';
    newCase.SER_Classification__c       = 'Consulta';
    newCase.SuppliedEmail              = 'test@test.com';
    newCase.SER_Business_Case_Type__c = 'GM';
    insert newCase;
    return newCase;
  }

  /*-----------------------------------------------------------------------
      Description: createContact.
      ------------------------------------------------------------------------*/
  public static Contact createContact(String lastname, String email, String phone) {
    final Id recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('SER_Service_Contact_GNC').getRecordTypeId();

    Contact newContact;
    newContact = new Contact();
    newContact.Lastname = lastname;
    newContact.Email = email;
    newContact.Phone = phone;
    newContact.AccountId = SER_TestUtils.ddCreateAccount(true).Id;
    newContact.DES_Scope__c = 'ES';
    newContact.RecordTypeId = recordTypeId;
    insert newContact;
    return newContact;
  }

  /*-----------------------------------------------------------------------
      Description: createContact.
      ------------------------------------------------------------------------*/
  public static SER_Transactional__c createProduct(Id accId) {
    SER_Transactional__c producto;
    producto = new SER_Transactional__c();
    producto.Name = 'SSTTProduct';
    producto.SER_Account__c = accId;
    producto.SER_Product_Text__c = 'BBVA NET C@SH';
    insert producto;
    return producto;
  }

  /*-----------------------------------------------------------------------
      Description: validateContactEmailTEST1.
      ------------------------------------------------------------------------*/
  @isTest
  static void validateContactEmailTEST1() {
    SER_TestUtils_3.initCustomsetting();

    Contact contacto;
    contacto = createContact('lastname','uuu@uuu.com','12345678');

    Case newCase;
    newCase = createCase();

    SER_TriggerHelper.mapFiredTriggers.clear();
    ContactTriggerHandler.map_EmptyEmailContacts.clear();

    test.startTest();
    newCase.ContactId = contacto.Id;
    update newCase;
    System.assertEquals(contacto.Id,newCase.ContactId,'Error1');
    test.stopTest();
  }

  /*-----------------------------------------------------------------------
      Description: validateContactEmailTEST2.
      ------------------------------------------------------------------------*/
  @isTest
  static void validateContactEmailTEST2() {
    SER_TestUtils_3.initCustomsetting();
    Case newCase;
    newCase = createCase();

    Contact contacto;
    contacto = createContact('lastname1','uuu@uuu.com','12345678');
    ContactTriggerHandler.map_EmptyEmailContacts.put(contacto.Id,contacto);

    createContact('lastname2','test@test.com','12345679');

    SER_TriggerHelper.mapFiredTriggers.clear();

    test.startTest();
    newCase.ContactId = contacto.Id;
    update newCase;
    System.assertEquals(contacto.Id,newCase.ContactId,'Error2');
    test.stopTest();
  }

  /*-----------------------------------------------------------------------
      Description: validateContactEmailTEST3.
      ------------------------------------------------------------------------*/
  @isTest
  static void validateContactEmailTEST3() {
    SER_TestUtils_3.initCustomsetting();

    Contact contacto;
    contacto = createContact('lastname3','uuu@uuu.com','12345678');

    SER_Transactional__c product;
    product = createProduct(contacto.AccountId);

    Case newCase;
    newCase = createCase();

    SER_TriggerHelper.mapFiredTriggers.clear();
    ContactTriggerHandler.map_EmptyEmailContacts.clear();

    test.startTest();
    newCase.RecordTypeId = SER_RecordTypeUtils.getRecordTypeByName('Case','SER_STE_User');
    newCase.SER_Business_Case_Type__c = 'STE';
    newCase.SER_Transactional_Reference__c = product.Id;
    newCase.ContactId = contacto.Id;
    newCase.SER_Web_App__c = 'App';
    update newCase;
    System.assertEquals(contacto.Id,newCase.ContactId,'Error3');
    test.stopTest();
  }

  /*-----------------------------------------------------------------------
      Description: fillGroupName1.
      ------------------------------------------------------------------------*/
  @isTest
  static void fillGroupNameTEST1() {
    SER_TestUtils_3.initCustomsetting();

    Account grupo; 
    grupo = SER_TestUtils.ddCreateAccount(true);
    grupo.DES_Group_Code__c = 'grupotest1';
    update grupo; 

    Account filial;
    filial = SER_TestUtils.ddCreateAccount(true);
    filial.DES_Main_Parent__c = grupo.Id;
    update filial;
    
    final Id recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Service_Contact_EGS').getRecordTypeId();

    Contact contacto;
    contacto = new Contact();
    contacto.Lastname = 'lastname4';
    //contacto.Email = 'email';
    contacto.Phone = '000000000';
    contacto.AccountId = filial.Id;
    contacto.RecordTypeId = recordTypeId;
    insert contacto;

    final Case newCase = new Case();

    test.startTest();
    newCase.RecordTypeId = SER_RecordTypeUtils.getRecordTypeByName('Case','EGS_User');
    newCase.SER_Business_Case_Type__c = 'EGS';

    insert newCase;

    newCase.ContactId = contacto.Id;  
    update newCase;  
    System.assertEquals(contacto.Id,newCase.ContactId,'Error4');
    test.stopTest();
    
  }
}