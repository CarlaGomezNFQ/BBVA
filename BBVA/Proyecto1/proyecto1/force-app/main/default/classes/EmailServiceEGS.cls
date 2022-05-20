/*-------------------------------------------------------------------------------
Author:        Jose Luis Aranda
Company:       Accenture
Description:   Method that generates Email Service for EGS

History:
<Author>                  <Date>                <Change Description>
Jose Luis  		09/03/2020            Initial version.
---------------------------------------------------------------------------------*/
global with sharing class EmailServiceEGS implements Messaging.InboundEmailHandler {
  /*
    handleInboudEmail
  */
  global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
    Messaging.InboundEmailResult result;
    try {
      //System.debug('REFERENCES : '+email.references);

      final CIB_Log__c logEGS = new CIB_Log__c(); //LOG de proceso
      logEGS.CIB_Subject__c = 'Email Service Cache testing EGS'; //Assign logEGS subject
      logEGS.CIB_ErrorMessage__c = ''; // Initialize logEGS body

      final InboundEmailWrapper currentEmailEGS = new InboundEmailWrapper(email,envelope);//WRAPPER
      //System.debug('EmailService EGS - handleInboundEmail - Cache Key : '+currentEmailEGS.cacheKey);
      logEGS.CIB_ErrorMessage__c += 'MESSAGEID FIELD : ' +currentEmailEGS.email.messageId+'\nSubject :  : ' +currentEmailEGS.email.Subject+'\nFrom : ' +currentEmailEGS.email.fromAddress+'\n';

      final EmailService_EmailEngine emailEngineEGS = new EmailService_EmailEngine(currentEmailEGS);//EMAIL ENGINE
      final Boolean isThread = emailEngineEGS.isThread();
      emailEngineEGS.initialize();
      if(isThread) {
        final Id emailId = emailEngineEGS.createEmail();
        result = new Messaging.InboundEmailresult();
      } else {
        final EmailServiceUtils engineEGS = new EmailServiceUtils('local.EmailService',currentEmailEGS,'EGS');
        Id caseId;
        final EmailService_CaseEngine caseEngineEGS = new EmailService_CaseEngine(currentEmailEGS);
        final String preassignAddress = engineEGS.preassignAddress(currentEmailEGS);
        final Map<String,SER_EmailDefaultValues_Assignment__c> settings = engineEGS.getMailboxSettings();
        final Set<String> defined = settings.keySet();
        currentEmailEGS.countDefinedAddresses(defined);
        if(String.isNotBlank(preassignAddress)) {
          //System.debug('EmailService EGS - handleInboundEmail - Hay Dirección pre-asignada : '+preassignAddress);
          final SER_EmailDefaultValues_Assignment__c setting = settings.get(preassignAddress);
          caseEngineEGS.setting = setting;
          caseId = caseEngineEGS.createCase();
        } else {
            final String assignedAddress = engineEGS.assignAddress(Label.SER_CustomerServiceMailboxEGS,currentEmailEGS);
            final SER_EmailDefaultValues_Assignment__c setting = settings.get(assignedAddress);
          caseEngineEGS.setting = setting;
          caseId = caseEngineEGS.createCase();
        }
      //System.debug('EmailService EGS - handleInboundEmail - Case ID creado : '+caseId);
      if(caseId != null) {
          Cache.OrgPartition orgPartition =  Cache.Org.getPartition('local.EmailService'); //NOSONAR
          //System.debug('EmailService EGS - handleInboundEmail - emailId : '+emailId);
          logEGS.CIB_ErrorMessage__c += 'CASE ID : '+caseId+'\nEMAIL ID : '+emailEngineEGS.createEmail(caseId)+'\n';            
          //final Boolean emailResult =  (emailId != null);
          final InboundEmailWrapper currentEmailCopy = currentEmailEGS;
          currentEmailCopy.email = null; //NOSONAR
          //final Boolean finalduplicity = engine.checkDuplicity(currentEmailEGS);
          orgPartition.put(currentEmailEGS.cacheKey,currentEmailCopy,300,Cache.Visibility.NAMESPACE,false);
        }
      }
      for(String header : currentEmailEGS.headers.keySet()) {
          logEGS.CIB_ErrorMessage__c += header + ' : ' +currentEmailEGS.headers.get(header)+'\n';
      }
        insert logEGS;
        result = new Messaging.InboundEmailresult();
    } catch (Cache.Org.OrgCacheException ex1) {
      EmailServiceUtils.insertCathCibLog (email,ex1);
      result = new Messaging.InboundEmailresult();
    } catch (Cache.InvalidParamException ex2) { //NOSONAR
      EmailServiceUtils.insertCathCibLog (email,ex2);
      result = new Messaging.InboundEmailresult();
    } catch (Exception error) { //NOSONAR
      System.debug('EmailService - Error Catch - Log Creation : '+EmailServiceUtils.generateLog(error,email,'EGS'));
      result = new Messaging.InboundEmailresult();
    }
    return result;
  }
 }