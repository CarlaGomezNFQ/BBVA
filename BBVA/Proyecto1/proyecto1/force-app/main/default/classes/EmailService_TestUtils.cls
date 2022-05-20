global with sharing class EmailService_TestUtils { //NOSONAR

  /*Email Addres Routing Rules*/
  public static final string EMAIL_ROUTING = 'cds@bbva.com';
  /*Constant STE*/
  public static final string STE = 'STE';
  /*-------------------------------------------------------------------------------
    Description:   Method to skip all validation and process.
  ---------------------------------------------------------------------------------*/ 
  public static void bypassall() {
    final CIB_ByPass__c bypassinstance = new CIB_ByPAss__c();
    bypassinstance.CIB_migration__c = false;
    bypassinstance.CIB_skip_assert__c = true;
    bypassinstance.CIB_skip_trigger__c = true;
    bypassinstance.CIB_skip_validationrule__c = true;
    bypassinstance.CIB_skip_workflow__c = true;
    bypassinstance.CIB_stop_job__c = false;
    bypassinstance.CIB_DES_DataMigration__c = false;
    bypassinstance.CIB_DES_skip_trigger_in_denorm__c = false;
    bypassinstance.CIB_DES_Delete_Opp_Permission__c = false;
    bypassinstance.SetupOwnerId = UserInfo.getUserId();
    insert bypassinstance;
  }

  /*-------------------------------------------------------------------------------
    Description:   Method that loads Custom Setting RoutingRule for GM.
  ---------------------------------------------------------------------------------*/ 
  public static void loadFilters() {
    final EmailServiceRoutingRule__c filter = new EmailServiceRoutingRule__c();
    filter.name = 'FilterName';
    filter.subject__c = 'Subject';
    filter.FromAddress__c = 'fromaddress@email.com';
    filter.Mailbox__c = EMAIL_ROUTING;
    filter.BusinessType__c = 'GM';
    insert filter;
  }
  
  /*-------------------------------------------------------------------------------
    Description:   Method that loads Custom Setting RoutingRule for EGS.
  ---------------------------------------------------------------------------------*/ 
  public static void loadFiltersEGS() {
    final EmailServiceRoutingRule__c filter = new EmailServiceRoutingRule__c();
    filter.name = 'FilterName';
    filter.subject__c = 'Subject';
    filter.FromAddress__c = 'fromaddress@email.com';
    filter.Mailbox__c = EMAIL_ROUTING;
    filter.BusinessType__c = 'EGS';
    insert filter;
  }

    /*-------------------------------------------------------------------------------
    Description:   Method that loads Custom Setting RoutingRule for STE.
  ---------------------------------------------------------------------------------*/ 
  public static void loadFiltersSTE() {
    final EmailServiceRoutingRule__c filter = new EmailServiceRoutingRule__c();
    filter.name = 'FilterName';
    filter.subject__c = 'Subject2';
    filter.FromAddress__c = 'fromaddress@email.com';
    filter.Mailbox__c = 'emailrule@email.com';
    filter.BusinessType__c = STE;
    insert filter;
  }
    
    /*-------------------------------------------------------------------------------
    Description:   Method that loads another Custom Setting RoutingRule for STE.
  ---------------------------------------------------------------------------------*/ 
  public static void loadFilters2STE() {
    final EmailServiceRoutingRule__c filter2 = new EmailServiceRoutingRule__c();
    filter2.name = 'FilterName2';
    filter2.subject__c = 'Subject2';
    filter2.FromAddress__c = 'fromaddress2@email.com';
    filter2.Mailbox__c = 'emailrule@email.com';
    filter2.BusinessType__c = STE;
    insert filter2;
      
  }
  /*-------------------------------------------------------------------------------
    Description:   Method that loads the mailbox settings for GM.
  ---------------------------------------------------------------------------------*/ 
  public static void loadEmailSettings() {
    final SER_EmailDefaultValues_Assignment__c emailsetting = new SER_EmailDefaultValues_Assignment__c();
    emailsetting.Name = 'emailsetting';
    emailsetting.SER_BusinessType__c = 'GM';
    emailsetting.SER_FromAddres__c = EMAIL_ROUTING;
    emailsetting.SER_MailingGroup__c = 'ALL FI & RV & Derivatives';
    emailsetting.SER_OutboundFromAddress__c = EMAIL_ROUTING;
    emailsetting.SER_OutboundMailbox__c = 'Email CDS';
    emailsetting.SER_Queue__c = 'SER_Settlement_CDS';
    final SER_EmailDefaultValues_Assignment__c defaultgmsetting = new SER_EmailDefaultValues_Assignment__c();
    defaultgmsetting.Name = 'defaultgmsetting';
    defaultgmsetting.SER_BusinessType__c = 'GM';
    defaultgmsetting.SER_FromAddres__c = Label.SER_CustomerServiceMailbox;
    defaultgmsetting.SER_MailingGroup__c = 'Customer & Claim Support';
    defaultgmsetting.SER_OutboundFromAddress__c = Label.SER_CustomerServiceMailbox;
    defaultgmsetting.SER_OutboundMailbox__c = 'Email Customer Support GM';
    defaultgmsetting.SER_Queue__c = 'SER_Customer_Support';

    insert emailsetting;
    insert defaultgmsetting;
  }
  
  /*-------------------------------------------------------------------------------
    Description:   Method that loads the mailbox settings for EGS.
  ---------------------------------------------------------------------------------*/ 
  public static void loadEmailSettingsEGS() {
    final SER_EmailDefaultValues_Assignment__c emailsetting = new SER_EmailDefaultValues_Assignment__c();
    emailsetting.Name = 'emailsetting';
    emailsetting.SER_BusinessType__c = 'EGS';
    emailsetting.SER_FromAddres__c = EMAIL_ROUTING;
    emailsetting.SER_MailingGroup__c = 'ALL FI & RV & Derivatives';
    emailsetting.SER_OutboundFromAddress__c = EMAIL_ROUTING;
    emailsetting.SER_OutboundMailbox__c = 'Email CDS';
    emailsetting.SER_Queue__c = 'SER_Settlement_CDS';
    final SER_EmailDefaultValues_Assignment__c defaultgmsetting = new SER_EmailDefaultValues_Assignment__c();
    defaultgmsetting.Name = 'defaultgmsetting';
    defaultgmsetting.SER_BusinessType__c = 'EGS';
    defaultgmsetting.SER_FromAddres__c = Label.SER_CustomerServiceMailboxEGS;
    defaultgmsetting.SER_MailingGroup__c = 'Customer & Claim Support';
    defaultgmsetting.SER_OutboundFromAddress__c = Label.SER_CustomerServiceMailboxEGS;
    defaultgmsetting.SER_OutboundMailbox__c = 'Email EGS';
    defaultgmsetting.SER_Queue__c = 'Email EGS';

    insert emailsetting;
    insert defaultgmsetting;
  }
    /*-------------------------------------------------------------------------------
    Description:   Method that loads the mailbox settings for STE.
  ---------------------------------------------------------------------------------*/ 
  public static void loadEmailSettingsSTE() {
    final SER_EmailDefaultValues_Assignment__c emailsetting = new SER_EmailDefaultValues_Assignment__c();
    emailsetting.Name = 'BBVANETCASH DE LA RED EXTERIOR';
    emailsetting.SER_BusinessType__c = STE;
    emailsetting.SER_FromAddres__c = EMAIL_ROUTING;
    emailsetting.SER_MailingGroup__c = 'Default STE';
    emailsetting.SER_OutboundFromAddress__c = EMAIL_ROUTING;
    emailsetting.SER_OutboundMailbox__c = 'Email RED EXTERIOR';
    emailsetting.SER_Queue__c = 'SER_Claims_Support_STES';
    final SER_EmailDefaultValues_Assignment__c defaultgmsetting = new SER_EmailDefaultValues_Assignment__c();
    defaultgmsetting.Name = 'ANS BBVANET PORTUGAL';
    defaultgmsetting.SER_BusinessType__c = STE;
    defaultgmsetting.SER_FromAddres__c = Label.SER_CustomerServiceMailboxSTE;
    defaultgmsetting.SER_MailingGroup__c = 'Default STE';
    defaultgmsetting.SER_OutboundFromAddress__c = Label.SER_CustomerServiceMailboxSTE;
    defaultgmsetting.SER_OutboundMailbox__c = 'Email PORTUGAL';
    defaultgmsetting.SER_Queue__c = 'SER_Claims_Support_STE';

    insert emailsetting;
    insert defaultgmsetting;
  }
}