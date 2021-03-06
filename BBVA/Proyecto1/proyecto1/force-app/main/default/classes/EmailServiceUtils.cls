/*
  EmailServiceUtils
*/
global  with sharing class EmailServiceUtils {
	/*Email*/
	InboundEmailWrapper email;
	/*Cache Partition*/
	Cache.OrgPartition cachepartition;
	/*Bussiness Case Type*/
	String businessType;
	/*Configurations Map*/
	Map<String,SObject> configurations;
	/*Constant 1*/
	static final integer UNO = 1;
	/*-------------------------------------------------------------------------------
      Author:        Juan Carlos Terr�n
      Company:       Accenture
      Description:   MEthod that generates Utils Email Service..

      IN:            CahePartitionName; email: inbound email; businessType: GM or EGS
      OUT:           void

      History:
      <Author>                  <Date>                <Change Description>
      Juan Carlos Terr�n                              Initial version.
      Jose Luis  				09/03/2020            A�adida funcionalidad para EGS
      ---------------------------------------------------------------------------------*/
	public EmailServiceUtils(String cachePartName, InboundEmailWrapper email,String businessType) {
		if(String.isNotBlank(cachePartName)) {
			this.cachepartition = Cache.Org.getPartition(cachePartName);
		}
		this.email = email;
		this.businessType = businessType;
	}
	/*
  		Methods get Mialbox settings
		  IN: void
		  OUT: Map <String, SER_EmailDefaultValues_Assignment__c>
	*/
	public Map<String,SER_EmailDefaultValues_Assignment__c> getMailboxSettings() {
		final Map<String,SER_EmailDefaultValues_Assignment__c> settings = SER_EmailDefaultValues_Assignment__c.getAll();
		final Map<String,SER_EmailDefaultValues_Assignment__c> mapedSettings = new Map<String,SER_EmailDefaultValues_Assignment__c>();
		for(SER_EmailDefaultValues_Assignment__c config : settings.values()) {
			mapedSettings.put(config.SER_FromAddres__c, config);
		}
		return mapedSettings;
	}
	/*
  		Methods preassing address
		  IN: email
		  OUT: String
	*/
    public String preassignAddress(InboundEmailWrapper email) {
		String result;
		final SER_EmailDefaultValues_Assignment__c middleConfig = SER_EmailDefaultValues_Assignment__c.getInstance('Email Middle Affirmations');
		if((email.email.toAddresses != null && email.email.toAddresses.contains(middleConfig.SER_FromAddres__c)) || (email.email.ccAddresses != null && email.email.ccAddresses.contains(middleConfig.SER_FromAddres__c))) {
			result = middleConfig.SER_FromAddres__c;
		} else {
			final EmailService_RoutingRulesEngine routingengine = new EmailService_RoutingRulesEngine(email,this.businessType);
			result = routingengine.processApplyingRules();
		}
		return result;
	}
	/*
  		Methods assign address
		  IN: String, Email
		  OUT: String
	*/
	public String assignAddress(String defaultAddress,InboundEmailWrapper currentEmail) {
		String result;
		if(currentEmail.definedToAddressesNum == UNO) {
			system.debug('1 TO');
			result = currentEmail.definedToAddresses[0];
		} else if(currentEmail.definedToAddressesNum > UNO) {
			system.debug('>1 TO');
			result = defaultAddress;
		} else {
			if(currentEmail.definedCcAddressesNum == UNO) {
				system.debug('1 CC');
				result = currentEmail.definedCcAddresses[0];
			} else if(currentEmail.definedCcAddressesNum > UNO) {
				system.debug('>1 CC');
				result = defaultAddress;
			} else {
				system.debug('DEFAULT');
				result = defaultAddress;
			}
		}
		return result;
	}
  /*-------------------------------------------------------------------------------
    Author:        Juan Carlos Terr�n
    Company:       Accenture
    Description:   Method that generate Log.

    IN:            Error, Email
    OUT:           Boolean

    History:
    <Author>                  <Date>                <Change Description>
    Juan Carlos Terr�n                              Initial version.
  ---------------------------------------------------------------------------------*/
  public static Boolean generateLog(Exception error,Messaging.InboundEmail email,String business) {
    Boolean result;
    result = false;
    try {
    String subject;
    CIB_Log__c log;
    final String defincasusitries = Label.EmailService_LogAnalizer_Casuistries;
    for(String casuistry : defincasusitries.split(';')) {
      if(error.getMessage().containsignorecase(casuistry)) {
        subject = 'Email Service Error '+business+' - '+casuistry;
        break;
      }
    }
    log = new CIB_log__C();
    log.CIB_ErrorMessage__c += 'MESSAGEID FIELD : ' +email.messageId+'\n';
    log.CIB_ErrorMessage__c += 'Subject :  : ' +email.Subject+'\n';
    log.CIB_ErrorMessage__c += 'From : ' +email.fromAddress+'\n';
    log.CIB_ErrorMessage__c += 'To : ' +email.ToAddresses+'\n';
    log.CIB_ErrorMessage__c += 'Cc : ' +email.CcAddresses+'\n';
    log.CIB_ErrorMessage__c += 'Error Message : '+error.getMessage()+'\nStackTrace : '+error.getStackTraceString();
    if(String.isnotblank(subject)) {
      log.cib_subject__c = subject;
    } else {
      log.cib_subject__c = 'Email Service Error '+business+' - Others';
    }
      insert log;
      result = true;
    } catch (Exception metaerror) {
      CIB_Log__c metalog;
      metalog = new CIB_log__C();
      metalog.CIB_Subject__c = 'Email Service Error '+business+' - MetaLog';
      metalog.CIB_ErrorMessage__c = 'Error Message : '+metaerror.getMessage()+'\nStackTrace : '+metaerror.getStackTraceString();
      insert metalog;
      result = false;
    }
    return result;
  }
/*-------------------------------------------------------------------------------
    Author:        Juan Carlos Terr�n
    Company:       Accenture
    Description:   Method that generate Log.

    IN:            Error, Email
    OUT:           Boolean

    History:
    <Author>                  <Date>                <Change Description>
    Juan Carlos Terr�n                              Initial version.
  ---------------------------------------------------------------------------------*/
  public static void insertCathCibLog(Messaging.InboundEmail email,Exception exc) {
	final CIB_Log__c log = new CIB_Log__c();
    log.CIB_Subject__c = 'EMAIL SERVICE ERROR';
    log.CIB_ErrorMessage__c = 'Email to: ' + email.toAddresses + '. \nccAddresses: ' + email.ccAddresses +'. \nsubject: ' + email.subject + '. \nError Message : '+exc.getMessage()+'\nStack Trace : '+exc.getStackTraceString();
    insert log;
  }
}