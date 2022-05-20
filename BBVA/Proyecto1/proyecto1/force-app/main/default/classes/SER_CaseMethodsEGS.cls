/*---------------------------------------------------------------------------------------------
    Company:       BBVA
    Description:   This class contains methods related to EGS Cases.

    History:
    <Date>          <Author>                <Description>
    21/08/2020      Javier Touchard         Initial Version.
----------------------------------------------------------------------------------------------*/
public with sharing class SER_CaseMethodsEGS {
    /*Constante 'Global Client Service'*/
    public static final String GRUPOCLIENT = 'Global Client Service';
    /*Constante 'EGS_Incoming_Email_Close_Case'*/
    public static final String NOTIFTYPE = 'EGS_Incoming_Email_Close_Case';
    /**Record Type'EGS User'*/
    public final static Id RT_EGS;
    /**Record Type 'Closed Case EGS User'*/
    public final static Id RT_CLOSE_EGS;
    static {
        RT_EGS = [SELECT Id FROM RecordType WHERE DeveloperName = 'EGS_User'].Id;
        RT_CLOSE_EGS = [SELECT Id FROM RecordType WHERE DeveloperName = 'Close_Case_EGS_User'].Id;
    }

    /*---------------------------------------------------------------------------------------
        Company:       BBVA
        Description:   private constructor.
    ---------------------------------------------------------------------------------------*/
    private SER_CaseMethodsEGS() {}

    /*-------------------------------------------------------------------------------------------
        Company:       BBVA
        Description:   trackingMasterCase.

        IN:            List<Case> newList.
        IN:            Map<Id,Case> oldMap.
        OUT:           void
    ---------------------------------------------------------------------------------------------*/
    public static void trackingMasterCase(List<Case> newList, Map<Id,Case> oldMap) {
        for(Case caso : newList) {
            Boolean process;
            process = isEGS(caso) && caso.SER_Master_Case__c != oldMap.get(caso.Id).SER_Master_Case__c;

            Boolean addToMastCase;
            addToMastCase = process && caso.SER_Master_Case__c != null && oldMap.get(caso.Id).SER_Master_Case__c == null;
            //Se asocia el caso a un caso maestro
            if(addToMastCase) {
                insertFeedComment(caso.CaseNumber, true, caso.SER_Master_Case__c);
            //Se des-asocia un caso de un caso maestro
            } else if(process && caso.SER_Master_Case__c == null) {
                insertFeedComment(caso.CaseNumber, false, oldMap.get(caso.Id).SER_Master_Case__c);
            //Se des-asocia un caso de un caso maestro y se asocia a otro caso maestro.
            } else if(process && caso.SER_Master_Case__c != null && oldMap.get(caso.Id).SER_Master_Case__c != null) {
                insertFeedComment(caso.CaseNumber, false, oldMap.get(caso.Id).SER_Master_Case__c);
                insertFeedComment(caso.CaseNumber, true, caso.SER_Master_Case__c);
            }
        }
    }

    /*-------------------------------------------------------------------------------------------
        Company:       BBVA
        Description:   The method return true if one of the cases have EGS record type.

        IN:            List<Case> newList.
        OUT:           Boolean
    ---------------------------------------------------------------------------------------------*/
    private static Boolean isEGS(Case caso) {
      Boolean response;
      response = false;
      if(caso.RecordTypeId == RT_EGS || caso.RecordTypeId == RT_CLOSE_EGS ) {
          response = true;
      }
      return response;
    }

    /*-------------------------------------------------------------------------------------------
        Company:       BBVA
        Description:   The method that insert a Feed Comment.

        IN:            String CaseNumber.
        IN:            Boolean add.
        IN:            Id MasterCaseId.
        OUT:           void.
    ---------------------------------------------------------------------------------------------*/
    private static void insertFeedComment(String caseNumber, Boolean add, Id masterCaseId) {
      FeedItem feedComment;
      feedComment = new FeedItem();
      feedComment.Body = 'User ' + userinfo.getName() + (add ? ' has added the case ' : ' has removed the case ') + caseNumber +  + (add ? ' to ' : ' from ') + ' the Master Case.';
      feedComment.ParentId = masterCaseId;
      feedComment.Title = 'Master Case Children';
      insert feedComment;
    }

    /*-------------------------------------------------------------------------------------------
        Author:        Cintia Carmona
        Company:       Accenture
        Description:   Update Severity

        IN:            Map<Id,Case> casosNew.
        IN:            Map<Id,Case> casosOld.
        OUT:           void

        History:
        <Date>            <Author>            <Change Description>
        13/13/2020        Cintia Carmona      Initial Version
    ---------------------------------------------------------------------------------------------*/
    public static void notifCloseWithMail(Map<Id,Case> casosNew, Map<Id,Case> casosOld) {

        List<Case> casesList; 
        casesList = new List<Case>();

        for(Case casoItem : casosNew.values()) {
            Case oldCase = new Case();
            oldCase = casosOld.get(casoItem.Id);

            boolean tratarCaso;
            tratarCaso = casoItem.SER_Business_Case_Type__c != null 
                      && casoItem.SER_Business_Case_Type__c .equalsIgnoreCase('EGS')
                      && casoItem.Status == SER_Constant.CLOSED
                      && casoItem.SER_Email_received__c == true
                      && casoItem.SER_Email_received__c != oldCase.SER_Email_received__c;        

            if(tratarCaso) {
                casesList.add(casoItem);
            }
        }

        if(casesList.isEmpty() == false) {
            for(Case casoNotif : casesList) {
                Case oldCase2 = new Case();
                oldCase2 = casosOld.get(casoNotif.Id);

                sendNotifCase(casoNotif.CaseNumber, oldCase2.LastModifiedById);
               
            }
            
        }
    }

    /*--------------------------------------------------------------------------
        Author:        Cintia Carmona
        Company:       BBVA
        Description:   fill caseMap.

        IN:        List<Case> casesList
        OUT:       Void

        History:
        <Date>            <Author>            <Change Description>
        13/13/2020        Cintia Carmona      Initial Version
  ----------------------------------------------------------------------------*/
    @future (callout=true)
    private static void sendNotifCase(String caseNumber, String lastUser) {

        Id notifiTypeId;
        notifiTypeId = [SELECT Id FROM CustomNotificationType WHERE DeveloperName = :NOTIFTYPE].Id;
        Http http;
        http = new Http();
        HttpRequest req;
        req = new HttpRequest();
        req.setEndpoint(Url.getOrgDomainUrl().toExternalForm()
            + '/services/data/v46.0/actions/standard/customNotificationAction');
        req.setMethod('POST');
        req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
        req.setHeader('Content-Type', 'application/json');
        CustomNotificationActionInput input;
        input = new CustomNotificationActionInput();
        input.customNotifTypeId = notifiTypeId;


//      Se modifica la notificación en campana, ya no va a enviarse al grupo de colaboración, sino al LastModifiedById
//      No se elimina el desarrollo por si hay que volver a enviarla al grupo. 
/*        
        List<CollaborationGroupMember> groupMembers;
        groupMembers = new List<CollaborationGroupMember>();
        groupMembers = [Select id, MemberId from CollaborationGroupMember where CollaborationGroup.Name = :GRUPOCLIENT];        
*/
        List<string> userIdsList;
        userIdsList = new List<string>();
/*        
        if(groupMembers.isEmpty() == false) {
            for(CollaborationGroupMember member : groupMembers) {
                if(member.MemberId != null) {
                    userIdsList.add(member.MemberId);
                }
            }
        }
*/
        userIdsList.add(lastUser);

        input.title = Label.SER_EGS_Incoming_Mail_Notification_Tittle;
        input.targetId = notifiTypeId;
        input.body = Label.SER_EGS_Incoming_Mail_Notification_Body.replace('#', caseNumber);

        if(Test.isRunningTest()) {  //NOSONAR
            input.recipientIds = new List<String>{UserInfo.getUserId()};
        } else if(userIdsList.isEmpty() == false) {
            input.recipientIds = userIdsList;
            CustomNotificationAction action;
            action = new CustomNotificationAction();
            action.inputs = new List<CustomNotificationActionInput>{input};
            req.setBody(JSON.serialize(action));
            HttpResponse res;
            res = http.send(req);
            System.debug(res.getBody());
        }
    }

    /*-------------------------------------------------------------------------------------------
        Company:       BBVA
        Description:   The method send an email when the user classify an E2C case like Quey or incident.

        IN:            List<Case> newList.
        IN:            Case> oldMap.
        OUT:           Void.
    ---------------------------------------------------------------------------------------------*/
    public static void senEmaiNewCaseEGS(List<Case> newList, Map<Id, Case> oldMap) {
        List <EmailTemplate> templateList;
        templateList = [SELECT Id,DeveloperName, Body, HtmlValue FROM EmailTemplate WHERE DeveloperName = 'SER_EGS_New_Incident_GNC_HTML' OR DeveloperName = 'SER_EGS_New_Incident_HTML'];

        List<OrgWideEmailAddress> oweaList;
        oweaList = [SELECT Id, Address FROM OrgWideEmailAddress WHERE DisplayName = 'Global Client Service'];

        List<Case> newCaseList;
        newCaseList = [SELECT Id, Subject, CreatedBy.LastName, SuppliedEmail, SER_Business_Case_Type__c, Origin, SER_Outbound_Mailbox__c, SER_Classification__c, (SELECT Id, Subject, FromAddress, ToAddress, BccAddress, CcAddress, SER_EmailServiceCode__c, HtmlBody, TextBody, Incoming, CreatedDate FROM EmailMessages ORDER BY CreatedDate DESC) FROM Case WHERE Id IN :oldMap.keySet()];

        Boolean isSandbox;
        isSandbox = [select IsSandbox from Organization limit 1].IsSandbox;

        for(Case caso : newCaseList) {
          Boolean sendEmail;
          sendEmail = ((isSandbox && caso.CreatedBy.LastName == 'testing') || (!isSandbox && caso.CreatedBy.LastName == 'EmailService'))
                      && caso.SER_Business_Case_Type__c == 'EGS'
                      && caso.Origin == 'Email'
                      && (caso.SER_Outbound_Mailbox__c == 'Global Client Service GNC' || caso.SER_Outbound_Mailbox__c == 'Global Client Service GCS')
                      && String.isBlank(oldMap.get(caso.Id).SER_Classification__c)
                      && (caso.SER_Classification__c == 'Incident' || caso.SER_Classification__c == 'Query')
                      && !caso.SuppliedEmail.containsIgnoreCase('BBVA.com');

          if(sendEmail) {
            EmailTemplate template;
            for(EmailTemplate temp : templateList) {
              Boolean isGNC;
              isGNC = caso.SER_Outbound_Mailbox__c == 'Global Client Service GNC' && temp.DeveloperName == 'SER_EGS_New_Incident_GNC_HTML';
              Boolean isGCS;
              isGCS = caso.SER_Outbound_Mailbox__c == 'Global Client Service GCS' && temp.DeveloperName == 'SER_EGS_New_Incident_HTML';
              if(isGNC) {
                template = temp;
              } else if(isGCS) {
                template = temp;
              }
            }

            fillMessage(caso, oweaList, template);
          }
        }
    }

    /*-------------------------------------------------------------------------------------------
        Company:       BBVA
        Description:   The method fill the EmailMessage. SER_CaseMethodsEGS.senEmaiNewCaseEGS auxiliar method.

        IN:            Case caso.
        IN:            List<OrgWideEmailAddress> oweaList.
        IN:            EmailTemplate template.
        OUT:           Void.
    ---------------------------------------------------------------------------------------------*/
    private static void fillMessage(Case caso, List<OrgWideEmailAddress> oweaList, EmailTemplate template) {
      Messaging.SingleEmailMessage message;
      message = new Messaging.SingleEmailMessage();
      message.setTemplateId(template.Id);
      message.setWhatId(caso.Id);
      if(String.isNotBlank(caso.EmailMessages[0].Subject)) {
        message.setSubject(caso.EmailMessages[0].Subject);
      }
      message.setTreatBodiesAsTemplate(true);
      message.setUseSignature(false);
      message.setSaveAsActivity(true);

      setAddresess(message, caso,  oweaList);

      String messageTEXT;
      messageTEXT = '';
      String messageHTML;
      messageHTML = '';

      messageTEXT += '--------------- Original Message ---------------\n';
      messageTEXT += 'From: ' + caso.EmailMessages[0].FromAddress + '\n';
      messageTEXT += 'Sent: ' + caso.EmailMessages[0].CreatedDate + '\n';
      messageTEXT += 'To: ' + caso.EmailMessages[0].ToAddress + '\n';
      messageTEXT += 'Subject: ' + caso.EmailMessages[0].Subject + '\n\n';
      messageTEXT += caso.EmailMessages[0].TextBody + '\n\n\n';

      messageHTML += '--------------- Original Message ---------------<br/>';
      messageHTML += '<b>From:</b> ' + caso.EmailMessages[0].FromAddress + '<br/>';
      messageHTML += '<b>Sent:</b> ' + caso.EmailMessages[0].CreatedDate + '<br/>';
      messageHTML += '<b>To:</b> ' + caso.EmailMessages[0].ToAddress + '<br/>';
      messageHTML += '<b>Subject:</b> ' + caso.EmailMessages[0].Subject + '<br/><br/>';
      messageHTML += caso.EmailMessages[0].HtmlBody + '<br/><br/>';

      message.setHtmlBody(template.HtmlValue.replace('{EmailBody}', messageHTML));
      message.setPlainTextBody(template.Body.replace('{EmailBody}', messageTEXT));

      message.setInReplyTo(caso.EmailMessages[0].SER_EmailServiceCode__c);
      message.setReferences(caso.EmailMessages[0].SER_EmailServiceCode__c);
      Messaging.sendEmail(new Messaging.SingleEmailMessage[] { message });
    }

    /*-------------------------------------------------------------------------------------------
        Company:       BBVA
        Description:   The method fill the Addresess fields. SER_CaseMethodsEGS.fillMessage auxiliar method.

        IN:            Messaging.SingleEmailMessage message.
        IN:            Case caso.
        IN:            List<OrgWideEmailAddress> oweaList.
        OUT:           Void.
    ---------------------------------------------------------------------------------------------*/
    private static void setAddresess(Messaging.SingleEmailMessage message, Case caso, List<OrgWideEmailAddress> oweaList) {
      List<String> adresses;
      adresses = new List<String>();
      List<String> toAddresses;
      toAddresses = new List<String>();
      if(String.isNotBlank(caso.EmailMessages[0].ToAddress)) {
        toAddresses = caso.EmailMessages[0].ToAddress.split(';');
      }

      if(caso.EmailMessages[0].Incoming) {
        adresses.add(caso.EmailMessages[0].FromAddress);
      } else {
        adresses.add(caso.EmailMessages[0].ToAddress);
      }

      List<String> bccAddressesO;
      bccAddressesO = new List<String>();
      List<String> bccAddresses;
      bccAddresses = new List<String>();
      if(String.isNotBlank(caso.EmailMessages[0].BccAddress)) {
        bccAddresses = caso.EmailMessages[0].BccAddress.split(';');
      }

      List<String> ccAddressesO;
      ccAddressesO = new List<String>();
      List<String> ccAddresses;
      ccAddresses = new List<String>();
      if(String.isNotBlank(caso.EmailMessages[0].CcAddress)) {
        ccAddresses = caso.EmailMessages[0].CcAddress.split(';');
      }

      for(OrgWideEmailAddress owea : oweaList) {
        Boolean isEmailService;
        isEmailService = (caso.EmailMessages[caso.EmailMessages.size() - 1].ToAddress != null
                              && caso.EmailMessages[caso.EmailMessages.size() - 1].ToAddress.contains(owea.Address)) ||
                        (caso.EmailMessages[caso.EmailMessages.size() - 1].CcAddress != null
                              && caso.EmailMessages[caso.EmailMessages.size() - 1].CcAddress.contains(owea.Address)) ||
                        (caso.EmailMessages[caso.EmailMessages.size() - 1].BccAddress != null
                              && caso.EmailMessages[caso.EmailMessages.size() - 1].BccAddress.contains(owea.Address));
        if(isEmailService) {
          message.setOrgWideEmailAddressId(owea.Id);
          if(caso.EmailMessages[0].Incoming) {
            extractOWDAddress(toAddresses, adresses, owea.Address);
          }
          extractOWDAddress(bccAddresses, bccAddressesO, owea.Address);
          extractOWDAddress(ccAddresses, ccAddressesO, owea.Address);
        }
      }

      message.setToAddresses(adresses);
      message.setBccAddresses(bccAddressesO);
      message.setCcAddresses(ccAddressesO);
    }

    /*-------------------------------------------------------------------------------------------
        Company:       BBVA
        Description:   Extract organization wide Address from all addresses.

        IN:            List<String> list1.
        IN:            List<String> list2.
        IN:            String owaAddress.
        OUT:           Void.
    ---------------------------------------------------------------------------------------------*/
    private static void extractOWDAddress(List<String> list1, List<String> list2, String owaAddress) {
      for(String address : list1) {
        if(address != owaAddress) {
          list2.add(address);
        }
      }
    }



  /**********************************************************
  *****************    CLASES INTERNAS    *******************
  **********************************************************/
  /*
  * @Description: CustomNotificationAction.
  */
  public class CustomNotificationAction {
    /* inputs */
    public List<CustomNotificationActionInput> inputs { get; set; }
  }

  /*
  * @Description: CustomNotificationActionInput.
  */
  public class CustomNotificationActionInput {
    /* customNotifTypeId */
    public String customNotifTypeId { get; set; }
    /* recipientIds */
    public List<String> recipientIds { get; set; }
    /* title */
    public String title { get; set; }
    /* body */
    public String body { get; set; }
    /* targetId */
    public String targetId { get; set; }
  }

}