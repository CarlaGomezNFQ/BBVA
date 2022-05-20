/***************************************************************************************
* @author       BBVA
* @date         11-06-2020
* @description  Class to test SER_BEISearchEngine_CONTROLLER.

****************************************************************************************/
@isTest
public class SER_BEISearchEngine_CONTROLLER_TEST {
  /**CONSTANTE 'REFERENCE'*/
  public static final String REFERENCE = '12345678';
  /**CONSTANTE 'CCLIENT'*/
  public static final String CCLIENT = 'Testing';
  /**CONSTANTE 'LOCALREFERENCE'*/
  public static final String LOCALREFERENCE = 'LocalReference';

  static Id initData(Boolean clientBl, Boolean localClientBl, Boolean referenceBl) {
    Account cliente;
    Local_Client_EGS__c localClient;

    //CASE
    Case caso;
    caso = new Case(RecordTypeId = SER_RecordTypeUtils.getRecordTypeByName('Case','EGS_User'),
                    SER_Business_Case_Type__c = 'EGS', SER_MailingGroup__c = 'EGS',SER_Outbound_Mailbox__c = 'Email EGS');
    insert caso;

    //GROUP
    Account grupo;
    grupo = new Account(SER_CClient__c = 'QA Client EGS', Name = 'QA Client EGS', SER_Global_Reference__c = REFERENCE,
                        SER_Is_Generic_Data__c = true, RecordTypeId = SER_RecordTypeUtils.getRecordTypeByName('Account','Group'), DES_Group_Code__c = 'codeQAClientEGS');
    insert grupo;

    Account matriz;
    matriz = new Account(SER_CClient__c = 'Matriz', Name = 'Matriz', SER_Global_Reference__c = REFERENCE, SER_Is_Generic_Data__c = true,
                          RecordTypeId = SER_RecordTypeUtils.getRecordTypeByName('Account','DES_Subsidiary_Commercial_Client'), gf_bei_id__c = 'TEST02', DES_Main_Parent__c = grupo.Id);
    insert matriz;

    //CLIENT
    if(clientBl) {
      cliente = new Account(SER_CClient__c = CCLIENT, Name = CCLIENT, SER_Global_Reference__c = REFERENCE, SER_Is_Generic_Data__c = true,
                            RecordTypeId = SER_RecordTypeUtils.getRecordTypeByName('Account','DES_Subsidiary_Commercial_Client'), gf_bei_id__c = 'TEST01', DES_Main_Parent__c = grupo.Id);
      insert cliente;
    }

    //LOCAL CLIENT
    if(localClientBl) {
      localClient = new Local_Client_EGS__c(External_Id__c = CCLIENT, Name = CCLIENT, company_customer_id__c = cliente.Id,
                                            country_id__c = 'ES', customer_system_id__c = REFERENCE, gf_bei_id__c = 'TEST01');
      insert localClient;
    }

    //LOCAL REFERENCE
    if(referenceBl) {
      Local_Reference__c localRefTest;
      localRefTest = new Local_Reference__c(External_Id_Ref__c = 'Testing-01', Name = 'Testing Es 01', customer_system_id__c = localClient.Id,
                                              solution_category_id__c = 'B2B', gf_bei_id__c = 'TEST01', gf_local_reference_country_id__c = 'ES');
      insert localRefTest;

      //SERVICE
      Service__c servicio;
      servicio = new Service__c(External_Id_Serv__c = 'Testing Service', Name = 'Testing Service', solution_category_id__c = '1111',
                                gf_product_country_id__c = 'ES', solution_id_path_desc__c = '2222');
      insert servicio;

      //REFERENCIA Y SERVICIO
      LocalRef_and_Service__c refAndServ;
      refAndServ = new LocalRef_and_Service__c(External_Id_RefSer__c = 'Testing Local Reference And Service', gf_reference_id__c = localRefTest.Id,
                                                solution_category_id__c = servicio.Id, country_id__c = 'ES', customer_system_id__c = localClient.Id);
      insert refAndServ;
    }

    return caso.Id;
  }

  /**
  * description: SER_BEISearchEngine_CONTROLLER.createLookUp. Se crea el lookup con un grupo. OK.
  */
  @isTest
  static void createGroupLookUpTEST() {
    SER_TestUtils_3.initCustomsetting();
    Id caseId;
    caseId = initData(false, false, false);
    Id groupId;
    groupId = [SELECT Id FROM ACCOUNT WHERE Name = 'QA Client EGS' LIMIT 1].Id;
    Test.startTest();
      SER_BEISearchEngine_CONTROLLER.createLookUp(caseId, groupId, 'Group');
      System.assertEquals(groupId, [SELECT gf_group_incidence_case_name__c FROM Case WHERE Id = :caseId].gf_group_incidence_case_name__c, 'Error 1');
      //Probamos el borrado del BEI
      Case casoB;
      casoB = new case(Id = caseId, gf_group_incidence_case_name__c = SER_BEISearchEngine_CONTROLLER.nullValueId);
      update casoB;
    Test.stopTest();
  }

  /**
  * description: SER_BEISearchEngine_CONTROLLER.createLookUp. Se crea el lookup con un cliente. OK.
  */
  @isTest
  static void createClientLookUpTEST() {
    SER_TestUtils_3.initCustomsetting();
    Id caseId;
    caseId = initData(true, false, false);
    Id clientId;
    clientId = [SELECT Id FROM ACCOUNT WHERE Name = :CCLIENT LIMIT 1].Id;
    Id groupId;
    groupId = [SELECT Id FROM ACCOUNT WHERE Name = 'QA Client EGS' LIMIT 1].Id;
    Test.startTest();
      SER_BEISearchEngine_CONTROLLER.createLookUp(caseId, clientId, 'Client');
      System.assertEquals(groupId, [SELECT gf_group_incidence_case_name__c FROM Case WHERE Id = :caseId].gf_group_incidence_case_name__c, 'Error 2');
    Test.stopTest();
  }

  /**
  * description: SER_BEISearchEngine_CONTROLLER.createLookUp. Se crea el lookup con un local client. OK.
  */
  @isTest
  static void createlOCALocalClientLookUpTEST() {
    SER_TestUtils_3.initCustomsetting();
    Id caseId;
    caseId = initData(true, true, false);
    Id locClientId;
    locClientId = [SELECT Id FROM Local_Client_EGS__c WHERE Name = :CCLIENT LIMIT 1].Id;
    Id groupId;
    groupId = [SELECT Id FROM ACCOUNT WHERE Name = 'QA Client EGS' LIMIT 1].Id;
    Test.startTest();
      SER_BEISearchEngine_CONTROLLER.createLookUp(caseId, locClientId, 'LocalClient');
      System.assertEquals(groupId, [SELECT gf_group_incidence_case_name__c FROM Case WHERE Id = :caseId].gf_group_incidence_case_name__c, 'Error 3');
    Test.stopTest();
  }

  /**
  * description: SER_BEISearchEngine_CONTROLLER.createLookUp. Se crea el lookup con una local reference. OK.
  */
  @isTest
  static void createLocalReferenceLookUpTEST() {
    SER_TestUtils_3.initCustomsetting();
    Id caseId;
    caseId = initData(true, true, true);
    Id locRefId;
    locRefId = [SELECT Id FROM Local_Reference__c WHERE Name = 'Testing Es 01' LIMIT 1].Id;
    Id groupId;
    groupId = [SELECT Id FROM ACCOUNT WHERE Name = 'QA Client EGS' LIMIT 1].Id;
    Test.startTest();
      SER_BEISearchEngine_CONTROLLER.createLookUp(caseId, locRefId, LOCALREFERENCE);
      System.assertEquals(groupId, [SELECT gf_group_incidence_case_name__c FROM Case WHERE Id = :caseId].gf_group_incidence_case_name__c, 'Error 4');
    Test.stopTest();
  }

  /**
  * description: SER_BEISearchEngine_CONTROLLER.createLookUp. No se manda registro para hacer el lookup. KO.
  */
  @isTest
  static void createLookUpTEST() {
    SER_TestUtils_3.initCustomsetting();
    Id caseId;
    caseId = initData(false, false, false);
    Test.startTest();
      String response;
      response = SER_BEISearchEngine_CONTROLLER.createLookUp(caseId, null, null);
      System.assertEquals('ERRORSelect any record', response, 'Error 5');
    Test.stopTest();
  }

  /**
  * description: SER_BEISearchEngine_CONTROLLER.deleteLookups. Se crea un lookup con una local reference para rellenar
  * toda la estructura y después borramos el client para que se borre toda la esctructura y se rellene la matriz.
  */
  @isTest
  static void deleteLookUpTEST1() {
    SER_TestUtils_3.initCustomsetting();
    Id caseId;
    caseId = initData(true, true, true);
    Id locRefId;
    locRefId = [SELECT Id FROM Local_Reference__c WHERE Name = 'Testing Es 01' LIMIT 1].Id;
    Account grupo;
    grupo = [SELECT Id, DES_Client_Matrix__c FROM ACCOUNT WHERE Name = 'QA Client EGS' LIMIT 1];
    Id matrizId;
    matrizId = [SELECT Id FROM ACCOUNT WHERE Name = 'Matriz' LIMIT 1].Id;
    
    grupo.DES_Client_Matrix__c = matrizId;
    update grupo;

    Test.startTest();
      SER_BEISearchEngine_CONTROLLER.createLookUp(caseId, locRefId, LOCALREFERENCE);

      Case casoDelete;
      casoDelete = [SELECT Id, AccountId FROM Case WHERE Id = :caseId LIMIT 1];
      casoDelete.AccountId = SER_BEISearchEngine_CONTROLLER.nullValueId;
      update casoDelete;

      System.assertEquals(matrizId, [SELECT AccountId FROM Case WHERE Id = :caseId].AccountId, 'Error 5');
    Test.stopTest();
  }

  /**
  * description: SER_BEISearchEngine_CONTROLLER.deleteLookups. Se crea un lookup con una local reference para rellenar
  * toda la estructura y después borramos el grupo para que se borre toda la esctructura.
  */
  @isTest
  static void deleteLookUpTEST2() {
    SER_TestUtils_3.initCustomsetting();
    Id caseId;
    caseId = initData(true, true, true);
    Id locRefId;
    locRefId = [SELECT Id FROM Local_Reference__c WHERE Name = 'Testing Es 01' LIMIT 1].Id;

    Test.startTest();
      SER_BEISearchEngine_CONTROLLER.createLookUp(caseId, locRefId, LOCALREFERENCE);

      Case casoDelete;
      casoDelete = [SELECT Id, gf_group_incidence_case_name__c FROM Case WHERE Id = :caseId LIMIT 1];
      casoDelete.gf_group_incidence_case_name__c = SER_BEISearchEngine_CONTROLLER.nullValueId;
      update casoDelete;

      System.assertEquals(null, [SELECT gf_group_incidence_case_name__c FROM Case WHERE Id = :caseId].gf_group_incidence_case_name__c, 'Error 6');
    Test.stopTest();
  }

  /**
  * description: SER_BEISearchEngine_CONTROLLER.deleteLookups. Se crea un lookup con una local reference para rellenar
  * toda la estructura y después borramos el local Client para que se borre la esctructura por debajo.
  */
  @isTest
  static void deleteLookUpTEST3() {
    SER_TestUtils_3.initCustomsetting();
    Id caseId;
    caseId = initData(true, true, true);
    Id locRefId;
    locRefId = [SELECT Id FROM Local_Reference__c WHERE Name = 'Testing Es 01' LIMIT 1].Id;

    Test.startTest();
      SER_BEISearchEngine_CONTROLLER.createLookUp(caseId, locRefId, LOCALREFERENCE);

      Case casoDelete;
      casoDelete = [SELECT Id, customer_system_id__c FROM Case WHERE Id = :caseId LIMIT 1];
      casoDelete.customer_system_id__c = SER_BEISearchEngine_CONTROLLER.nullValueId;
      update casoDelete;

      System.assertEquals(null, [SELECT customer_system_id__c FROM Case WHERE Id = :caseId].customer_system_id__c, 'Error 7');
    Test.stopTest();
  }

  /**
  * description: SER_BEISearchEngine_CONTROLLER.deleteLookups. Se crea un lookup con una local reference para rellenar
  * toda la estructura y después borramos la referencia para que se borre la esctructura por debajo.
  */
  @isTest
  static void deleteLookUpTEST4() {
    SER_TestUtils_3.initCustomsetting();
    Id caseId;
    caseId = initData(true, true, true);
    Id locRefId;
    locRefId = [SELECT Id FROM Local_Reference__c WHERE Name = 'Testing Es 01' LIMIT 1].Id;

    Test.startTest();
      SER_BEISearchEngine_CONTROLLER.createLookUp(caseId, locRefId, LOCALREFERENCE);

      Case casoDelete;
      casoDelete = [SELECT Id, gf_reference_id__c FROM Case WHERE Id = :caseId LIMIT 1];
      casoDelete.gf_reference_id__c = SER_BEISearchEngine_CONTROLLER.nullValueId;
      update casoDelete;

      System.assertEquals(null, [SELECT gf_reference_id__c FROM Case WHERE Id = :caseId].gf_reference_id__c, 'Error 7');
    Test.stopTest();
  }
}