/*-------------------------------------------------------------------------------
Author:        Juan Carlos Terr�n
Company:       Accenture
Description:   Class that generates Email for Email Service

History:
<Author>                  <Date>                <Change Description>
Juan Carlos Terr�n                              Initial version.
---------------------------------------------------------------------------------*/
public with sharing class EmailService_EmailEngine {
  /* Methods Get/Set threadId */
  public String threadId {get;set;}
  /* Methods Get/Set Email */
  public EmailMessage email {get;set;}
  /* Methods Get/Set wrapper */
  public InboundEmailWrapper wrapper {get;set;}
  /* Methods Get/Set inibound */
  public Messaging.InboundEmail inbound {get;set;}
  /* Methods Get/Set attManager */
  public EmailService_EmailEngine_Attachments attManager {get;set;}
  /* Constant limit length*/
  public static final integer MAXLENGTH = 131000;
  
/*-------------------------------------------------------------------------------
Author:        Juan Carlos Terr�n
Company:       Accenture
Description:   Method Create Email
---------------------------------------------------------------------------------*/
  public EmailService_EmailEngine (InboundEmailWrapper wrapper) {
    this.wrapper = wrapper;
    this.inbound = wrapper.email;
    this.email = new EmailMessage();
    this.attManager = new EmailService_EmailEngine_Attachments(wrapper);
  }

/*-------------------------------------------------------------------------------
Author:        Juan Carlos Terr�n
Company:       Accenture
Description:   Method setAddressFields
---------------------------------------------------------------------------------*/
  private void setAddressFields() {
    final List<String> toaddresses = this.wrapper.addresses.get('to');
    final List<String> ccaddresses = this.wrapper.addresses.get('cc');
    this.email.ToAddress = String.join(toaddresses,';');
    this.email.CcAddress = String.join(ccaddresses,';');
    this.email.FromAddress = this.inbound.FromAddress;
    this.email.FromName = this.inbound.FromName;
  }
/*-------------------------------------------------------------------------------
Author:        Juan Carlos Terr�n
Company:       Accenture
Description:   Method Set Email Body
---------------------------------------------------------------------------------*/
  private void setBody() {
      final string endEmailLabel = Label.SER_EndBodyEmailMessageSTE;
      System.debug('EmailService_EmailEngine - setBody - Label: '+ endEmailLabel + ' ' +endEmailLabel.length());//NOSONAR
      if(String.isNotBlank(this.inbound.HtmlBody)) {
          System.debug('EmailService_EmailEngine - setBody - htmlBody is notBlank');//NOSONAR
          if(this.inbound.HtmlBody.length() > MAXLENGTH) {
              System.debug('EmailService_EmailEngine - setBody - htmlBody es mayor' + this.inbound.HtmlBody.length());//NOSONAR
              this.email.HtmlBody = this.inbound.HtmlBody.substring(0,129999-endEmailLabel.length()-1)+ ' ' + endEmailLabel;
          } else {
              System.debug('EmailService_EmailEngine - setBody - htmlBody es menor' + this.inbound.HtmlBody.length());//NOSONAR
              this.email.HtmlBody = this.inbound.HtmlBody;
          }
      } else {
          this.email.HtmlBody = '';
      }
      
    if(String.isNotBlank(this.inbound.PlainTextBody)) {
        System.debug('EmailService_EmailEngine - setBody - plaintextbody is notBlank');//NOSONAR
      if(this.inbound.PlainTextBody.length() > MAXLENGTH) {
          System.debug('EmailService_EmailEngine - setBody - plaintextbody lenght es mayor' + this.inbound.PlainTextBody.length());//NOSONAR
        this.email.TextBody = this.inbound.PlainTextBody.substring(0,129999-endEmailLabel.length()-1) + ' ' + endEmailLabel;
      } else {
      System.debug('EmailService_EmailEngine - setBody - plaintextbody lenght es menor' + this.inbound.PlainTextBody.length());//NOSONAR
        this.email.TextBody = this.inbound.PlainTextBody;
      }
    } else {
      this.email.TextBody = '';
    }  
  }
  
/*-------------------------------------------------------------------------------
Author:        Juan Carlos Terr�n
Company:       Accenture
    OUT: boolean
Description:   Method Is Thread
---------------------------------------------------------------------------------*/
  public Boolean isThread() {
    Boolean isThread;
    System.debug('EmailService_EmailEngine - isThread - Start');//NOSONAR
    final String emailbody = this.wrapper.textBody;
    System.debug('EmailService_EmailEngine - isThread - emailbody : '+emailbody);//NOSONAR
    final String reference = emailbody.substringBetween('ref:_',':ref');
    System.debug('EmailService_EmailEngine - isThread - reference : '+reference);//NOSONAR
    if(String.isNotBlank(reference)) {
      try {
        String threadIdi = emailbody.substringBetween('ref:_',':ref');
        System.debug('EmailService_EmailEngine - isThread - threadIdi : '+threadIdi);//NOSONAR
        threadIdi = '_'+threadIdi;
        final Id caseId = Cases.getCaseIdFromEmailThreadId(threadIdi);
        System.debug('EmailService_EmailEngine - isThread - caseId : '+caseId);//NOSONAR
        isThread = true;
      } catch(Exception error) {
        System.debug('EmailService_EmailEngine - isThread - error : '+error.getMessage());//NOSONAR
        isThread = false;
      }
    } else {
      System.debug('EmailService_EmailEngine - isThread - No hay referencia --> no es thread');//NOSONAR
      isThread = false;
    }
    return isThread;
  }
  private void setThreadId() {
    System.debug('EmailService_EmailEngine - setThreadId - start');//NOSONAR
    final String threadIds = this.wrapper.textbody.substringBetween('ref:_',':ref');
    System.debug('EmailService_EmailEngine - setThreadId - threadIds : '+threadIds);//NOSONAR
    this.threadId = '_'+threadIds;
  }
/*-------------------------------------------------------------------------------
Author:        Juan Carlos Terr�n
Company:       Accenture
Description:   Method Initialize Email
---------------------------------------------------------------------------------*/
  public void initialize() {
      this.setBody();
      this.setAddressFields();
      this.setThreadId();
  }
/*-------------------------------------------------------------------------------
Author:        Juan Carlos Terr�n
Company:       Accenture
Description:   Method create Email
    IN: - 
    OUT: Id email
---------------------------------------------------------------------------------*/
  public Id createEmail() {
    System.debug('EmailService_EmailEngine - createEmail_Thread - start');//NOSONAR
    this.email.SER_EmailServiceCode__c = this.wrapper.messageId;
    System.debug('EmailService_EmailEngine - createEmail_Thread - SER_EmailServiceCode__c : '+this.email.SER_EmailServiceCode__c);//NOSONAR
    final Id caseId = Cases.getCaseIdFromEmailThreadId(this.threadId);
    System.debug('EmailService_EmailEngine - createEmail_Thread - caseId : '+caseId);//NOSONAR
    this.email.ParentId = caseId;
    System.debug('EmailService_EmailEngine - createEmail_Thread - ParentId : '+this.email.ParentId);//NOSONAR
    this.email.Incoming = true;
    this.email.Subject = this.inbound.Subject;
    System.debug('EmailService_EmailEngine - createEmail_Thread - Subject : '+this.email.Subject);//NOSONAR
    this.email.htmlbody = this.attManager.loadAttachments(caseId, this.email.htmlBody);
    this.email.Status = '0';
    insert this.email;
    this.attManager.linkFilesToEmail(this.email.Id);
    return this.email.Id;
  }
/*-------------------------------------------------------------------------------
Author:        Juan Carlos Terr�n
Company:       Accenture
Description:   Method create Email
    IN: Case Id 
    OUT: Id email
---------------------------------------------------------------------------------*/
  public Id createEmail(Id caseId) {
    System.debug('EmailService_EmailEngine - createEmail_Thread - start');//NOSONAR
    this.email.SER_EmailServiceCode__c = this.wrapper.messageId;
    System.debug('EmailService_EmailEngine - createEmail_Thread - SER_EmailServiceCode__c : '+this.email.SER_EmailServiceCode__c);//NOSONAR
    this.email.ParentId = caseId;
    System.debug('EmailService_EmailEngine - createEmail_Thread - ParentId : '+this.email.ParentId);//NOSONAR
    this.email.Incoming = true;
    this.email.Subject = this.inbound.Subject;
    System.debug('EmailService_EmailEngine - createEmail_Thread - Subject : '+this.email.Subject);//NOSONAR
    this.email.htmlbody = this.attManager.loadAttachments(caseId, this.email.htmlBody);
    this.email.Status = '0';
    insert this.email;
    this.attManager.linkFilesToEmail(this.email.Id);
    return this.email.Id;
  }
}