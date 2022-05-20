/*-------------------------------------------------------------------------------
Author:        Miriam Simón 
Company:       UST
Description:   Method that generates Email Service for STE

History:
<Author>                  <Date>                <Change Description>
Miriam Simón  		18/11/20201           Initial version.
---------------------------------------------------------------------------------*/
global with sharing class EmailServiceSTE implements Messaging.InboundEmailHandler {
    
    /* Business case type STE */
  public static final String STE_BUSINESS = 'STE';
    /*
handleInboudEmail
*/
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result;
        try {
            //System.debug('REFERENCES : '+email.references);//NOSONAR
            
            final CIB_Log__c logSTE = new CIB_Log__c(); //LOG de proceso
            logSTE.CIB_Subject__c = 'Email Service Cache testing STE'; //Assign logSTE subject
            logSTE.CIB_ErrorMessage__c = ''; // Initialize logSTE body
            
            final InboundEmailWrapper currentEmailSTE = new InboundEmailWrapper(email,envelope);//WRAPPER
            currentEmailSTE.businessType = STE_BUSINESS;
            //System.debug('EmailService STE - handleInboundEmail - Cache Key : '+currentEmailSTE.cacheKey);//NOSONAR
            logSTE.CIB_ErrorMessage__c += 'MESSAGEID FIELD : ' +currentEmailSTE.email.messageId+'\nSubject :  : ' +currentEmailSTE.email.Subject+'\nFrom : ' +currentEmailSTE.email.fromAddress+'\n';
            
            final EmailService_EmailEngine emailEngineSTE = new EmailService_EmailEngine(currentEmailSTE);//EMAIL ENGINE
            final Boolean isThread = emailEngineSTE.isThread();
            emailEngineSTE.initialize();
            if(isThread) {
                emailEngineSTE.createEmail();
                result = new Messaging.InboundEmailresult();
            } else {
                this.processEmailCase(currentEmailSTE, logSTE, emailEngineSTE);
            }
            
            for(String header : currentEmailSTE.headers.keySet()) {
                logSTE.CIB_ErrorMessage__c += header + ' : ' +currentEmailSTE.headers.get(header)+'\n';
            }
            insert logSTE;
            result = new Messaging.InboundEmailresult();
        } catch (Cache.Org.OrgCacheException ex1) {
            EmailServiceUtils.insertCathCibLog (email,ex1);
            result = new Messaging.InboundEmailresult();
        } catch (Cache.InvalidParamException ex2) { //NOSONAR
            EmailServiceUtils.insertCathCibLog (email,ex2);
            result = new Messaging.InboundEmailresult();
        } catch (Exception error) { //NOSONAR
            System.debug('EmailService - Error Catch - Log Creation : '+EmailServiceUtils.generateLog(error,email,'STE'));//NOSONAR
            result = new Messaging.InboundEmailresult();
        }
        return result;
    }
    
   	/**
   	 * Author: Miriam Simon
   	 * Company: UST
   	 * Description: process email service 
   	 * */
    private void processEmailCase (InboundEmailWrapper currentEmailSTE, CIB_Log__c logSTE, EmailService_EmailEngine emailEngineSTE) {
        final EmailServiceUtils engineSTE = new EmailServiceUtils('local.EmailService',currentEmailSTE,'STE');
        Id caseId;
        final EmailService_CaseEngine caseEngineSTE = new EmailService_CaseEngine(currentEmailSTE);
        final String preassignAddress = engineSTE.preassignAddress(currentEmailSTE);
        final Map<String,SER_EmailDefaultValues_Assignment__c> settings = engineSTE.getMailboxSettings();
        final Set<String> defined = settings.keySet();
        currentEmailSTE.countDefinedAddresses(defined);
        if(String.isNotBlank(preassignAddress)) {
            //System.debug('EmailService STE - processEmailCase - Hay Dirección pre-asignada : '+preassignAddress);//NOSONAR
            final SER_EmailDefaultValues_Assignment__c setting = settings.get(preassignAddress);
            caseEngineSTE.setting = setting;
            caseId = caseEngineSTE.createCase();
        } else {
            final String assignedAddress = engineSTE.assignAddress(Label.SER_CustomerServiceMailboxSTE,currentEmailSTE);
            final SER_EmailDefaultValues_Assignment__c setting = settings.get(assignedAddress);
            caseEngineSTE.setting = setting;
            System.debug('EmailService STE - processEmailCase - caseEngineSTE.setting : '+caseEngineSTE.setting);//NOSONAR
            caseId = caseEngineSTE.createCase();
        }
        System.debug('EmailService STE - processEmailCase - Case ID creado : '+caseId);//NOSONAR
        if(caseId != null) {
            Cache.OrgPartition orgPartition =  Cache.Org.getPartition('local.EmailService'); //NOSONAR
            //System.debug('EmailService STE - processEmailCase - emailId : '+emailId);//NOSONAR
            logSTE.CIB_ErrorMessage__c += 'CASE ID : '+caseId+'\nEMAIL ID : '+emailEngineSTE.createEmail(caseId)+'\n';            
            final InboundEmailWrapper currentEmailCopy = currentEmailSTE;
            currentEmailCopy.email = null; //NOSONAR
            orgPartition.put(currentEmailSTE.cacheKey,currentEmailCopy,300,Cache.Visibility.NAMESPACE,false);
        }
    }
    
}