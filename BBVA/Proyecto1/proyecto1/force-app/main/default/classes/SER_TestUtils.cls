/*---------------------------------------------------------------------------------------------------
    Author:        Juan Carlos Terrón
    Company:       Accenture
    Description:   Class to store test helper methods, like creating dummy data or execution control.

    History:
    <Date>          <Author>                <Description>
    16/03/1993		Juan Carlos Terrón		Initial Version
----------------------------------------------------------------------------------------------------*/
public with sharing class SER_TestUtils {
  /*Cuenta vacía*/
  private static final Account NULL_ACCOUNT;
  /*Caso vacío*/
  private static final Case NULL_CASE;
  /*Contacto vacío*/
  private static final Contact NULL_CONTACT;
  /*Case Type para pruebas */
  private static final string TYPE_ACCESO = 'ACCESO';
  /*Case Type para pruebas */
  private static final string TYPE_GM_OTR = 'Otros';
  /*CONSTANTE 'TEST Subject'*/
  private static final string SUBJECT = 'TEST Subject';

  private SER_TestUtils() {
  }

  /*---------------------------------------------------------------------------------------------------
    Author:        Juan Carlos Terrón
    Company:       Accenture
    Description:   Method to create a Dummy user with a profile given by parameter.

    History:
    <Date>          <Author>                <Description>
    16/03/1993		Juan Carlos Terrón		Initial Version
  ----------------------------------------------------------------------------------------------------*/
  public static User ddCreateUser(String profileName,Boolean forInsert) {
    final User usuario = new User();
    usuario.FirstName = 'TEST';
    usuario.LastName = 'USER';
    if(Test.isRunningTest()) {  //NOSONAR
      usuario.ProfileId = UserInfo.getProfileId();
    } else {
      usuario.ProfileId = SER_ProfileUtils.getProfileId(profileName);
    }

    usuario.Lastname='LastNameTest';
    usuario.Alias = 'Alias';
    usuario.Email = 'Alias@accenture.com';
    usuario.username= createUserName()+'test@accenture.com';
    usuario.CommunityNickname = 'ComunityNickNameTest2';
    usuario.EmailEncodingKey = 'UTF-8';
    usuario.Timezonesidkey='Europe/London';
    usuario.Localesidkey ='en_US';
    usuario.languagelocalekey='en_US';
    usuario.ID_User__c = string.valueOf(system.now());
    usuario.Asset_Class__c = 'FI;FX;EQ';

    if(forInsert) {
      insert usuario;
    }
    return usuario;
  }

  /*---------------------------------------------------------------------------------------------------
    Author:        Juan Carlos Terrón
    Company:       Accenture
    Description:   Method to create a user name depending on the creation date.

    History:
    <Date>          <Author>                <Description>
    16/03/1993		Juan Carlos Terrón		Initial Version
  ----------------------------------------------------------------------------------------------------*/
  public static string createUserName() {
    /*Wrapping*/
    return 'test_' + DateTime.now().format('HHmmssSSS');
  }

  /*---------------------------------------------------------------------------------
    Author:        Juan Carlos Terrón
    Company:       Accenture
    Description:   Method to create a dummy Account.

    History:
    <Date>          <Author>                <Description>
    16/03/1993		Juan Carlos Terrón		Initial Version
  -----------------------------------------------------------------------------------*/
  public static Account ddCreateAccount(Boolean forInsert) {
    Account newAccount = new Account();
    try {
      newAccount.Name = 'newAccount';
      newAccount.Asset_Class__c = 'TEST Asset Class';

      if (forInsert) {
        insert newAccount;
      }
    } catch(Exception error) {
      System.debug('JCT - ddCreateAccount : '+error);
      CIB_LogUtils.create_Log(error, 'ddCreateAccount');
      newAccount = NULL_ACCOUNT;
    }
    return newAccount;
  }

  /*---------------------------------------------------------------------------------
    Author:        Juan Carlos Terrón
    Company:       Accenture
    Description:   Method to create a dummy Case.

    History:
    <Date>          <Author>                <Description>
    16/03/1993		Juan Carlos Terrón		Initial Version
  -----------------------------------------------------------------------------------*/
  public static Case ddCreateCase(Boolean forInsert) {
    Case newCase = new Case();
    try {
      if(forInsert) {
        insert newCase;
      }
    } catch(Exception error) {
      System.debug('JCT - ddCreateCase : '+error);
      CIB_LogUtils.create_Log(error, 'ddCreateCase');
      newCase = NULL_CASE;
    }
    return newCase;
  }

  /*---------------------------------------------------------------------------------
    Author:        Juan Carlos Terrón
    Company:       Accenture
    Description:   Method to create a dummy Master Case.

    History:
    <Date>          <Author>                <Description>
    16/03/1993		Juan Carlos Terrón		Initial Version
  -----------------------------------------------------------------------------------*/
  public static Case ddCreateMstrCase(Boolean forInsert) {
    final Case newCase = new Case();
    final String rtId = SER_RecordTypeUtils.getRecordTypeByName('Case','SER_STE_User');

    newCase.SER_Is_Master_Case__c = true;
    //newCase.SER_Master_Case__c = null;
    newCase.OwnerId                         = UserInfo.getUserId();
    newCase.RecordTypeId                    = rtId;
    newCase.SER_Product__c                  = 'BBVA NET C@SH';
    newCase.Subject                         = SUBJECT;
    newCase.Description                     = 'TEST Description';
    newCase.Type                            = TYPE_ACCESO;
    newCase.Subtype__c                      = TYPE_ACCESO;
    newCase.SER_Type_EST__c                 = 'Acceso - CASH';
    newCase.SER_Subtype_STE__c              = 'Lentitud';
    newCase.SER_Type_GM__c                  = TYPE_GM_OTR;
    newCase.SER_Subtype_GM__c               = TYPE_GM_OTR;
    newCase.SER_Classification__c           = 'Incidencia';
    newCase.SuppliedEmail                   = 'testSuppliedEmailAddress@test.com';
    newCase.SER_Remedy_Department__c        = 'ANS sstt';
    newCase.Status                          = 'Transferred';
    newCase.SER_Skip_validations__c         = true;

    if(forInsert) {
      insert newCase;
    }
    return newCase;
  }

  /*---------------------------------------------------------------------------------
    Author:        Cintia Carmona del Valle
    Company:       Accenture
    Description:   Method to create a Master Case EGS.

    History:
    <Date>          <Author>                  <Description>
    18/03/2020    Cintia Carmona del Valle    Initial Version
  -----------------------------------------------------------------------------------*/
  public static Case ddCrMstrCaseEGS(Boolean forInsert) {
    final Case newCase = new Case();
    final String rtId = SER_RecordTypeUtils.getRecordTypeByName('Case', 'EGS_User');

    newCase.OwnerId                           = UserInfo.getUserId();
    newCase.RecordTypeId                      = rtId;
    newCase.SER_Business_Case_Type__c         = 'EGS';
    newCase.Origin                            = 'Email';
    newCase.case_status_type__c               = 'New';
    newCase.case_channel_source_type__c       = 'GNC';
    newCase.SER_Classification__c             = 'Incident';
    newCase.gf_case_cause_on_closure_desc__c  = 'Cliente';
    newCase.gf_case_countries_desc__c         = 'Global';
    newCase.Description                       = 'Prueba Test';
    newCase.Subject                           = SUBJECT;
    newCase.gf_case_creation_type__c                     = 'Reactive';
    newCase.gf_case_area_name__c              = 'Client';
    newCase.gf_case_service_name__c           = 'Adeudos';
    newCase.validation_criticality_type__c    = '4. Low';
    newCase.Status                            = 'New';
    newCase.gf_case_channel_source_name__c    = 'Acceso';

    if(forInsert) {
      insert newCase;
    }
    return newCase;
  }

  /*---------------------------------------------------------------------------------
    Author:        Juan Carlos Terrón
    Company:       Accenture
    Description:   Method to create a dummy child case.

    History:
    <Date>          <Author>                <Description>
    16/03/1993		Juan Carlos Terrón		Initial Version
  -----------------------------------------------------------------------------------*/
  public static Case ddCrChildCase() {
    Case newCase = new Case();
    try {
      newCase.SER_Is_Master_Case__c = false;
      //newCase.SER_Master_Case__c = null;
      newCase.Subject                         = SUBJECT;
      newCase.Description                     = 'TEST Description';
      newCase.Type                            = 'TEST Type';
      newCase.Subtype__c                      = 'TEST Subtype';
      newCase.SER_Type_EST__c                 = TYPE_ACCESO;
      newCase.SER_Subtype_STE__c              = TYPE_ACCESO;
      newCase.SER_Type_GM__c                  = 'Certificados';
      newCase.SER_Subtype_GM__c               = 'BASF';
      newCase.SER_Classification__c           = 'Consulta';
      newCase.SuppliedEmail                   = 'testSuppliedEmailAddress@test.com';
    } catch(Exception ex) {
      newCase = NULL_CASE;
    }
    return newCase;
  }

  /*---------------------------------------------------------------------------------
    Author:        Juan Carlos Terrón
    Company:       Accenture
    Description:   Method to create a dummy child case from masterCase given by parameter.

    History:
    <Date>          <Author>                <Description>
    16/03/1993		Juan Carlos Terrón		Initial Version
  -----------------------------------------------------------------------------------*/
  public static Case ddCrChildCase(String masterCaseId, Boolean forInsert) {
    Case newCase = new Case();
    try {
      newCase.SER_Is_Master_Case__c = false;
      newCase.SER_Master_Case__c = masterCaseId;

      final String rtId = SER_RecordTypeUtils.getRecordTypeByName('Case','SER_STE_User');

      newCase.OwnerId                                 = UserInfo.getUserId();
      newCase.RecordTypeId                    = rtId;
      newCase.SER_Product__c                  = 'BBVA NET C@SH';
      newCase.Subject                         = SUBJECT;
      newCase.Description                     = 'TEST Description';
      newCase.Type                            = TYPE_ACCESO;
      newCase.Subtype__c                      = TYPE_ACCESO;
      newCase.SER_Type_EST__c                 = 'Acceso - CASH';
      newCase.SER_Subtype_STE__c              = 'Lentitud';
      newCase.SER_Type_GM__c                  = TYPE_GM_OTR;
      newCase.SER_Subtype_GM__c               = TYPE_GM_OTR;
      newCase.SER_Classification__c           = 'Incidencia';
      newCase.SuppliedEmail                   = 'testSuppliedEmailAddress@test.com';
      if(forInsert) {
        insert newCase;
      }
    } catch(Exception ex) {
      newCase = NULL_CASE;
    }
    return newCase;
  }

  /*---------------------------------------------------------------------------------
    Author:        Juan Carlos Terrón
    Company:       Accenture
    Description:   Wrapping.

    History:
    <Date>          <Author>                <Description>
    16/03/1993		Juan Carlos Terrón		Initial Version
  -----------------------------------------------------------------------------------*/
  public static Case ddUpsertCase(Case caso) {
    /*Wrapping*/
    return null;
  }

  /*---------------------------------------------------------------------------------
    Author:        Juan Carlos Terrón
    Company:       Accenture
    Description:   CONTACT DUMMY DATA.

    History:
    <Date>          <Author>                <Description>
    16/03/1993		Juan Carlos Terrón		Initial Version
  -----------------------------------------------------------------------------------*/
  public static Contact ddCreateContact(Boolean forInsert) {
    Contact newContact = new Contact();
    try {
      newContact.FirstName = 'FirstName';
      newContact.Lastname = 'LastName';
      newContact.Phone = '000000000';
      newContact.AccountId=ddCreateAccount(true).Id;
      newContact.RecordTypeId = SER_RecordTypeUtils.getRecordTypeByName('Contact','SER_Service_Contact_Global_Markets');

      if(forInsert) {
        insert newContact;
      }
    } catch(Exception error) {
      System.debug('JCT - ddCreateContact : '+error);
      CIB_LogUtils.create_Log(error, 'ddCreateContact');
      newContact = NULL_CONTACT;
    }

    return newContact;
  }
}