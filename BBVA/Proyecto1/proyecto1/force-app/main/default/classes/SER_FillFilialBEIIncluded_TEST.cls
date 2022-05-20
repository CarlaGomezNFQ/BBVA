/**
* Clase de TEST para las clases SER_FillFilialBEIIncluded_JOB y SER_FillFilialBEIIncluded_BATCH.
*/
@isTest
public class SER_FillFilialBEIIncluded_TEST {

  /**
  * Method auxiliar para crear un juego de datos.
  */
  private static void createData() {
    User testUser;
    testUser = TestFactory.createUser('cngcbUserDL', Label.DES_DATALOADER_PROFILE);

    System.runAs(testUser) {
      Account filial;
      filial = new Account(Name = 'Filial Test', SER_CClient__c = '11111111', RecordTypeId = SER_RecordTypeUtils.getRecordTypeByName('Account', 'SER_Service_Account'));
      insert filial;

      Local_Client_EGS__c localClient;
      localClient = new Local_Client_EGS__c(Name = 'Local Client NG Test', company_customer_id__c = filial.Id, gf_bei_id__c = '111111111');
      insert localClient;

      Local_Client_EGS__c localClient2;
      localClient2 = new Local_Client_EGS__c(Name = 'Local Client NG Test2', company_customer_id__c = filial.Id, gf_bei_id__c = '111111112');
      insert localClient2;
    }
  }

  /**
  * Method para testear las clases SER_FillFilialBEIIncluded_JOB y SER_FillFilialBEIIncluded_BATCH OK.
  */
  @isTest
  static void fillFilialBEIIncludedTest1() {

    Test.startTest();
      createData();

      SER_FillFilialBEIIncluded_JOB job;
      job = new SER_FillFilialBEIIncluded_JOB();
      job.execute(null);

      SER_FillFilialBEIIncluded_JOB job2;
      job2 = new SER_FillFilialBEIIncluded_JOB();
      job2.execute(null, 'SELECT Id, Name, company_customer_id__c, company_customer_id__r.Name FROM Local_Client_EGS__c WHERE gf_bei_id__c <> null AND company_customer_id__r.gf_bei_id__c = null AND company_customer_id__r.BEI_Included__c = FALSE AND company_customer_id__r.SER_CClient__c <> null');

      System.assertNotEquals(null, job2, 'Error');
    Test.stopTest();
  }

}