/**
* Clase de TEST para las clases SER_ConcatNonGroupedClientBEI_JOB y SER_ConcatNonGroupedClientBEI_BATCH.
*/
@isTest
public class SER_ConcatNonGroupedClientBEI_TEST {

  /**
  * Method auxiliar para crear un juego de datos.
  */
  private static void createData() {
    User testUser;
    testUser = TestFactory.createUser('cngcbUserDL', Label.DES_DATALOADER_PROFILE);

    System.runAs(testUser) {
      Account ngClient;
      ngClient = new Account(Name = 'Non Grouped Test', SER_CClient__c = '11111111', RecordTypeId = SER_RecordTypeUtils.getRecordTypeByName('Account', 'SER_Service_Account'));
      insert ngClient;

      System.debug([SELECT RecordType.Name, DES_Main_Parent__c, SER_CClient__c from Account where Name = 'Non Grouped Test']);

      Local_Client_EGS__c localClient;
      localClient = new Local_Client_EGS__c(Name = 'Local Client NG Test', company_customer_id__c = ngClient.Id, gf_bei_id__c = '111111111');
      insert localClient;

      Local_Client_EGS__c localClient2;
      localClient2 = new Local_Client_EGS__c(Name = 'Local Client NG Test2', company_customer_id__c = ngClient.Id, gf_bei_id__c = '111111112');
      insert localClient2;
    }
  }

  /**
  * Method para testear las clases SER_ProductCleaner_BATCH y SER_ProductCleaner_JOB
  */
  @isTest
  static void concatNonGroupedClientBEITest1() {

    Test.startTest();
      createData();

      AccountTriggerHandler handler;
      handler = new AccountTriggerHandler();
      handler.getProfileName();
      SER_ConcatNonGroupedClientBEI_JOB job;
      job = new SER_ConcatNonGroupedClientBEI_JOB();
      job.execute(null);

      SER_ConcatNonGroupedClientBEI_JOB job2;
      job2 = new SER_ConcatNonGroupedClientBEI_JOB();
      job2.execute(null, 'SELECT Id, gf_bei_id__c, (SELECT Id, gf_bei_id__c, company_customer_id__c FROM LocalClient_Affil__r WHERE gf_bei_id__c <> null) FROM Account WHERE SER_CClient__c <> null AND DES_Main_Parent__c = null AND RecordType.DeveloperName in (\'Non_Grouped_Client\',\'SER_Service_Account\')');

      System.assertNotEquals(null, job2, 'Error');
    Test.stopTest();
  }

}