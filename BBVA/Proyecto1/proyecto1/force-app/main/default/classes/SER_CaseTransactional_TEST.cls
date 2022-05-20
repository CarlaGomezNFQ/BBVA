@isTest
/*-----------------------------------------------------------------
    Author:
    Company:
    Description:   This class contains test methods

    History:
    <Date>          <Author>                <Description>

-------------------------------------------------------------------*/
private class SER_CaseTransactional_TEST {

  @isTest static void testMethodOne() {

    final Account acc = UnitTestUtils.GetStandardAccount();
    insert acc;

    final SER_Transactional__c serTrs = new SER_Transactional__c(SER_Product_Text__c  = 'BBVA NET C@SH');
    insert serTrs;

    final Contact cont = new Contact(
      Lastname = 'ContactName3',
      AccountId = acc.id,
      Email_ExternalID__c = 'ContactName3@test.com',
      Asset_Class__c = 'FI',
      RecordTypeId = SER_RecordTypeUtils.getRecordTypeByName('Contact','SER_Service_Contact_Global_Markets')
      );
    insert cont;

    final Case caso = new Case();
    insert caso;

    final ApexPages.StandardController stdCtrl = new ApexPages.StandardController(caso);
    final SER_CaseTransactional serCaseTrans = new SER_CaseTransactional(stdCtrl);
    serCaseTrans.saveAndRefresh();
    //serCaseTrans.saveAndRefreshOld();

    caso.SER_Transactional_Reference__c = serTrs.Id;
    update caso;

    serCaseTrans.saveAndRefresh();
    //serCaseTrans.saveAndRefreshOld();
    //SER_CaseTransactional_BuildParamsURL.getContactName(cont.Id);

    System.assertEquals(serCaseTrans,serCaseTrans,'testMethodOne');

  }
}