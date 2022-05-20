/*-----------------------------------------------------------------------------
        Author:        Raúl Agüera
        Company:       Accenture
        Description:   Controller VF SER_PhoneCase

        History:
        <Date>          <Author>                <Description>
        17/02/2017      Raúl Agüera             Initial Version
--------------------------------------------------------------------------------*/
public with sharing class SER_CaseTransactional {

  /*Constante para identificar un caso*/
  private static final String SOBJ = 'Case';
  /*Constante para capturar el prefijo global*/
  private static final String SPREFIX = Schema.getGlobalDescribe().get(SOBJ).getDescribe().getKeyPrefix();
  /*Constante con el nombre del producto de Net cash*/
  private static final String SPRODUCTNAME = 'BBVA NET C@SH';
  /*Constante con el nombre del producto de Net cash Portugal*/
  private static final String SPRODUCTNAME_PT = 'BBVA NET CASH PORTUGAL';
  /*Constante con el valor numérico 1*/
  private static final integer UNO = 1;
  /*Constructur para URL*/
  public string sUrl {get; set;}
  /*Constructur para el objeto caso*/
  public Case myCase {get; set;}
  /*Constructur el campo ID del caso */
  public string sCaseId {get; set;}
  /*Consturctor para el campo Case Number*/
  public string sCaseNumber {get; set;}
  /*Constructor para el campo ID del contacto*/
  public string sContactId {get; set;}
  /*Constructor para el campo ID del cliente*/
  public String sAccountId {get; set;}
  /*Constructor para el campo Mailing Group*/
  public String stMailingGroup {get; set;}
  /*Constructor para el campo Mailbox por defecto*/
  public String stDefaultMailbox {get; set;}


/*------------------------------------------------------------------------------
        Author:        Raúl Agüera
        Company:       Accenture
        Description:   SER_CaseTransactional

        History:
        <Date>          <Author>                <Description>
        17/02/2017      Raúl Agüera             Initial Version
---------------------------------------------------------------------------------*/
  public SER_CaseTransactional(ApexPages.StandardController controller) {

    ApexPages.StandardController stdController;
    stdController = controller;

    List<String> listFields;
    listFields = new List<String>();
    listFields.add('CaseNumber');
    listFields.add('AccountId');
    listFields.add('ContactId');
    listFields.add('Origin');
    listFields.add('SER_Transactional_Reference__c');
    listFields.add('SER_Product__c');
    listFields.add('SER_Web_App__c');

    if(!Test.isRunningTest()) { stdController.addFields(listFields); }

    myCase = (Case) stdController.getRecord();

    system.debug('## Constr myCase: ' + myCase);
    sCaseNumber = '';
    sCaseId = '';
    sContactId = System.currentPageReference().getParameters().get('def_contact_id');
    sContactId = String.isBlank(sContactId) ? '' : sContactId;
    system.debug('## sContactId: ' + sContactId);
    sAccountId = System.currentPageReference().getParameters().get('def_account_id');
    sAccountId = String.isBlank(sAccountId) ? '' : sAccountId;

    sUrl = '/' + SPREFIX + '/e?nooverride=1';
  }

  /*------------------------------------------------------------------------------------------------------
      Author:        Raúl Agüera
      Company:       Accenture
      Description:   Search for Transactional__c value and create Case URL Params to call edited Case form

      IN:            -
      OUT:           PageReference

      History:
      <Date>                  <Author>                <Change Description>
      08/03/2017              Raúl Agüera             Initial Version
  --------------------------------------------------------------------------------------------------------*/
  public PageReference saveAndRefresh() {

    string sErrorMsg;
    final string sTransId = myCase.SER_Transactional_Reference__c;

    system.debug('## saveAndRefresh: ' + sTransId);
    if (String.isBlank(sTransId) ) {
      sErrorMsg = Label.SER_No_Input_On;       //'No input on search field'
    } else {
      //Buscamos cuenta asociada a la transacionalidad
      final List<SER_Transactional__c> accTrans = [SELECT Id, SER_Account__c, SER_Product_Text__c
                                                    FROM SER_Transactional__c
                                                    WHERE id = :sTransId];

      if(accTrans.isEmpty()) {
        sErrorMsg = Label.SER_No_Results;         //'No results, please use advanced search option'
      } else if (accTrans.size() > UNO) {
        sErrorMsg = Label.SER_Multiple_Results;         //'Product Reference: Multiple items found. Click icon to refine search.'
      } else {
        sErrorMsg = saveCaseInboundCall(accTrans,sErrorMsg);
      }
    }

    if (String.isNotBlank(sErrorMsg) ) {
      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,sErrorMsg));
    }
    return null;
  }
  /*------------------------------------------------------------------------------------------------------
    Author:        Raúl Agüera
    Company:       Accenture
    Description:   Method aux of saveAndRefresh
  --------------------------------------------------------------------------------------------------------*/
  public String saveCaseInboundCall(List<SER_Transactional__c> accTrans, string sErrorMsg) {
    String sErrorMsgAux = sErrorMsg;
    myCase.Origin = 'Inbound Call';
    //myCase.AccountId = accTrans.get(0).SER_Account__c;
    myCase.AccountId = String.isNotBlank(sAccountId) ? sAccountId : accTrans.get(0).SER_Account__c;
    myCase.SER_Transactional_Reference__c = accTrans.get(0).Id;
    if (String.isNotBlank(sContactId) ) {
      myCase.ContactId = sContactId;
    }
    if (accTrans.get(0).SER_Product_Text__c != null) {
      myCase.SER_Product__c = accTrans.get(0).SER_Product_Text__c;
      if(accTrans.get(0).SER_Product_Text__c == SPRODUCTNAME||accTrans.get(0).SER_Product_Text__c == SPRODUCTNAME_PT) {
        myCase.SER_Web_App__c = 'Web';
      }
    }

    this.fillEmailOutboxControllingField();

    //Database.Saveresult oInsert;
    try {
      insert myCase;

      sCaseNumber = myCase.CaseNumber;
      sCaseId = myCase.Id;
      system.debug('## sCaseId: ' + sCaseId);
    } catch(exception e) {
      sErrorMsgAux = e.getMessage();
      system.debug('## FATAL ERROR' + e.getMessage());
    }
    system.debug('## myCase: ' + myCase);
    return sErrorMsgAux;
  }
  /*------------------------------------------------------------------------
      Author:        Juan Carlos Terrón
      Company:       Accenture
      Description:   Method to preload email outbox controlling field value.

      IN:            None
      OUT:           void

      History:
      <Date>                  <Author>                <Change Description>
      12/06/2017              Juan Carlos Terrón      Initial Version.
  --------------------------------------------------------------------------*/
  public void fillEmailOutboxControllingField() {
    System.debug('JCT - Entro en asignación del mailing group');
    final String stUserID = UserInfo.getUserId();

    List<SER_MailingGroup__c> listMailingGroups = new List<SER_MailingGroup__c>();
    listMailingGroups = [select Id, SER_User__c, SER_MailingGroup__c, SER_DefaultMailbox__c from SER_MailingGroup__c where SER_User__c = :stUserID];

    if(!listMailingGroups.isEmpty() && listMailingGroups.size() == 1) {
      System.debug('JCT - Hay Registros : '+listMailingGroups.size());
      this.myCase.SER_MailingGroup__c =  String.isNotBlank(listMailingGroups[0].SER_MailingGroup__c) ? listMailingGroups[0].SER_MailingGroup__c : '';
      this.myCase.SER_Outbound_Mailbox__c = String.isNotBlank(listMailingGroups[0].SER_MailingGroup__c) && String.isNotBlank(listMailingGroups[0].SER_DefaultMailbox__c) ? listMailingGroups[0].SER_DefaultMailbox__c : '';
    }
  }
}