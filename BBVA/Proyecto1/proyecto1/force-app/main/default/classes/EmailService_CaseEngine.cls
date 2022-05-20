/*-------------------------------------------------------------------------------
Author:        Juan Carlos Terr�n
Company:       Accenture
Description:   Method that generates Case for Email Service

History:
<Author>                  <Date>                <Change Description>
Juan Carlos Terr�n                              Initial version.
---------------------------------------------------------------------------------*/
public with sharing class EmailService_CaseEngine {
  /* Methods Get/Set Case */
  public Case newCase {get;set;}
  /* Methods Get/Set Email */
  public InboundEmailWrapper currentEmail {get;set;}
  /* Methods Get/Set Custom Setting Outbond Mailbox */
  public SER_EmailDefaultValues_Assignment__c setting {get;set;}
  /* Business case type EGS */
  public static final String EGS_BUSINESS = 'EGS';
  /* Business case type GM */
  public static final String GM_BUSINESS = 'GM';
   /* Business case type STE */
  public static final String STE_BUSINESS = 'STE';
  /* Business case type GNC */
  public static final String GNC_BUSINESS = 'GNC';
  /* Constant integer 1 */
  public static final integer UNO = 1;
  /* Constant limit length*/  
  public static final integer MAXLENGTH = 30000;
  

/*-------------------------------------------------------------------------------
Author:        Juan Carlos Terr�n
Company:       Accenture
Description:   Method Case Engine
    IN: currentEmail
    OUT: -
History:
<Author>                  <Date>                <Change Description>
Juan Carlos Terr�n                              Initial version.
---------------------------------------------------------------------------------*/
  public EmailService_CaseEngine(InboundEmailWrapper currentEmail) {
    this.newCase = new Case();
    this.currentEmail = currentEmail;
    this.setting = new SER_EmailDefaultValues_Assignment__c();
  }
/*-------------------------------------------------------------------------------
Author:        Juan Carlos Terr�n
Company:       Accenture
Description:   Method Create Case
---------------------------------------------------------------------------------*/
  public Id createCase() {
    Id result;
    try {
			final Id rtId = this.getRecordTypeId();
      system.debug('EmailService_CaseEngine - Create Case - RecordTypeId :  '+rtId);//NOSONAR
      this.newCase.SER_EmailServiceCode__c = currentEmail.messageId;
      system.debug('EmailService_CaseEngine - Create Case - SER_EmailServiceCode__c:  '+this.newCase.SER_EmailServiceCode__c);//NOSONAR
			this.newCase.subject = currentEmail.email.subject;
      system.debug('EmailService_CaseEngine - Create Case - Subect :  '+this.newCase.subject);//NOSONAR
      this.newCase.SuppliedEmail = currentemail.Sender;
      system.debug('EmailService_CaseEngine - Create Case - SuppliedEmail :  '+this.newCase.SuppliedEmail);//NOSONAR
			//this.newCase.SER_EmailToCaseCode__c = currentEmail.reference;
      system.debug('EmailService_CaseEngine - Create Case - SER_EmailToCaseCode__c:  '+this.newCase.SER_EmailToCaseCode__c);//NOSONAR
			this.newCase.SER_MailingGroup__c = setting.SER_MailingGroup__c;
      system.debug('EmailService_CaseEngine - Create Case - SER_MailingGroup__c :  '+this.newCase.SER_MailingGroup__c);//NOSONAR
			this.newCase.SER_Outbound_Mailbox__c = setting.SER_OutboundMailbox__c;
      system.debug('EmailService_CaseEngine - Create Case - SER_Outbound_Mailbox__c :  '+this.newCase.SER_Outbound_Mailbox__c);//NOSONAR
			final Group cola = [select Id, Name from Group where Developername = :setting.SER_Queue__c limit 1][0];
			this.newCase.OwnerId = cola.Id;
      system.debug('EmailService_CaseEngine - Create Case - OwnerId:  '+this.newCase.OwnerId);//NOSONAR
      this.newcase.Origin = setting.SER_Origin__c;
      this.newCase.SER_Skip_validations__c = true;
      system.debug('EmailService_CaseEngine - Create Case - Origin :  '+this.newcase.Origin);//NOSONAR
			//this.newCase.Origin = 'Email';
			this.newCase.SER_Business_Case_Type__c = this.setting.SER_BusinessType__c;
      system.debug('EmailService_CaseEngine - Create Case - SER_Business_Case_Type__c :  '+this.newCase.SER_Business_Case_Type__c);//NOSONAR
      if (this.newCase.SER_Business_Case_Type__c != EGS_BUSINESS) {
        this.newCase.SER_Classification__c = 'Consulta';
        system.debug('EmailService_CaseEngine - Create Case - SER_Classification__c :  '+this.newCase.SER_Classification__c);//NOSONAR
        if(currentEmail.textBody!=null) { this.cutShortDescription(this.newCase, currentEmail.textBody.stripHtmlTags());}
      }
      this.newCase.RecordTypeId = rtId;
      this.getContact();

      if (this.newCase.SER_Business_Case_Type__c == EGS_BUSINESS) {
        this.getGroup();
      }
			insert this.newCase;
			result =  this.newCase.Id;
		} catch (Exception error) {
			system.debug('Create Case Error: '+error.getMessage());
      system.debug('Create Case Error Stack Trace '+error.getStackTraceString());
		}
    return result;
  }

    /*
* Author: Miriam Simon
* Company: UST
* Description:  Method to cut short description field.
*/
    private void cutShortDescription (Case caseShortDes, String description) {
        
        system.debug('EmailService_CaseEngine - Create Case - description sin html length:  '+description.length());//NOSONAR
        if (description.length() > MAXLENGTH) {
            final String endEmailLabel = Label.SER_EndBodyEmailSTE; //(Too long description , to see the rest of the content go to email)
            caseShortDes.Description = description.substring(0, MAXLENGTH-endEmailLabel.length()-2) + ' ' + endEmailLabel;
        } else {
            caseShortDes.Description = description;
        }
        system.debug('EmailService_CaseEngine - Create Case - description :  '+caseShortDes.Description);//NOSONAR
    }

/*-------------------------------------------------------------------------------
Author:        Juan Carlos Terr�n
Company:       Accenture
Description:   Method get RecordTyeId
---------------------------------------------------------------------------------*/
  private Id getRecordTypeId() {
    Id rtId;
    if(this.setting.SER_BusinessType__c == GM_BUSINESS) {
      rtId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GM User').getRecordTypeId();
    } else if(this.setting.SER_BusinessType__c == GNC_BUSINESS) {
      rtId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GNC User').getRecordTypeId();
    } else if(this.setting.SER_BusinessType__c == EGS_BUSINESS) {
      rtId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('EGS User').getRecordTypeId();
    } else {
      rtId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('STE User').getRecordTypeId();
    }
    return rtId;
  }
  private void getContact() {
    final String emailsender = this.currentEmail.Sender;
    system.debug('EmailService_CaseEngine - Get Contact - Email Sender :  '+emailsender);//NOSONAR
    final List<Contact> contacts = new List<Contact>();
    for(Contact cnt : [select Id from Contact where Email_ExternalID__c = :emailsender]) {
      contacts.add(cnt);
    }
    if(contacts.isempty()) {
    System.debug('New Contact');
    } else if(contacts.size() == UNO) {
      this.newCase.contactId = contacts[0].Id;
      system.debug('EmailService_CaseEngine - Get Contact - Contact Id :  '+this.newCase.contactId);//NOSONAR
    }
  }
  private void getGroup() {
    final String contactoId = this.newCase.contactId;
    final boolean process = contactoId != null;
    if(process) {
      System.debug('New Group');
      final Contact cnt = [select Id, AccountId from Contact where Id = :contactoId];

      final String cuentaId = cnt.AccountId;
      final Account cuentaGrupo = [select Id, DES_Main_Parent__c from Account where Id = :cuentaId];

      if(cuentaGrupo.DES_Main_Parent__c == null) {
        system.debug('No group');
      } else {
        this.newCase.gf_group_incidence_case_name__c = cuentaGrupo.DES_Main_Parent__c;
        system.debug('EmailService_CaseEngine - Get Group - Group Id :  '+this.newCase.gf_group_incidence_case_name__c);//NOSONAR
      }
    }
  }
}