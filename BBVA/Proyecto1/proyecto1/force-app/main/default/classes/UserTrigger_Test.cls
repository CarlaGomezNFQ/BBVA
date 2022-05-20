/***************************************************************************************
* @author       BBVA
* @date         17-06-2020
* @description  Class to test UserTrigger.

****************************************************************************************/
@isTest
@SuppressWarnings('sf:TooManyMethods')
private class UserTrigger_Test {

  /**CONSTANTE 'EUROPE'*/
  public static final String EUROPE = 'Europe/London';
    /**CONSTANTE 'UTF8'*/
  public static final String UTF8 = 'UTF-8';

  /*
  * String
  */
  static final String USERNAME = 'test2@tested.test';

  /*
  * String
  */
  static final String LASTNAME = 'LastNameTest2';

  /*
  * String
  */
  static final String EMAIL = 'Alias2@accenture.com';

  /*
  * String
  */
  static final String ALIAS = 'Alias2';

  /*
  * String
  */
  static final String IDUSER = 'SampleUserID';

  /*
  * String
  */
  static final String IDUSER2 = 'SampleUserID2';


    /**
    *@Author: Global Desktop
    *Description: INsert
    */
    @isTest
    public static void insertDataloaderTest() {

      Id profileDefault = [select id from Profile where Name='Consultation IT' limit 1].id;
        Profile perfil = [select id from Profile where Name='Consultation IT' limit 1];
        System.debug('Profile: '+profileDefault);


        Test.startTest();

        User SampleUser = new User(ProfileId = perfil.Id,
                                   Username= USERNAME,
                                   Lastname=LASTNAME,
                                   Email = EMAIL,
                                   Alias = ALIAS,
                                   CommunityNickname = 'ComunityNickNameTest2',
                                   Timezonesidkey=EUROPE,
                                   Localesidkey='en_US',
                                   EmailEncodingKey = UTF8,
                                   ID_User__c = IDUSER,
                                   Languagelocalekey='en_US');


        insert SampleUser;

            SampleUser.FirstName = 'NameTest';
            update SampleUser;

            //User userNew = UnitTestUtils.GetDataloaderNewUser('ExternaIDTest','FX');
            User userNew = UnitTestUtils.GetFXSalesUser();
            insert userNew;
        Test.stopTest();



        User user1 = [Select Id, Name, ProfileId, UserRoleId From User Where Id =:SampleUser.Id limit 1];
        Id profileFX = [select id from profile where name='Consultation IT' limit 1].id;
        User user2 = [Select Id, Name, ProfileId, UserRoleId From User Where Id =:userNew.Id limit 1];
        System.assertEquals(SampleUser.ProfileId, user1.ProfileId);
        System.assertEquals(SampleUser.UserRoleId, user1.UserRoleId);

    }


    /*
    * ¡OJO! En este testMethod invoca métodos @future de la clase UserLogic, y estos métodos a veces daban problemas porque termina
    * la ejecución del testMethod y los futuros todavía no se habían ejecutado. Esto provocaba que fallaban los Assertion.
    * Parece que la cosa se soluciona simplemente añadiendo un par de "system.debug" justo antes de los Assertion, pero hay que tener cuidado
    */
    @isTest
    public static void permissionSetChatter_Test() {
      //Data needed
      Id profileDefault = [select id from Profile where Name='Consultation IT' limit 1].id;
        Profile perfil = [select id from Profile where Name='Consultation IT' limit 1];
        System.debug('Profile: '+profileDefault);

        //Test
        Test.startTest();

        User SampleUser = new User(ProfileId = perfil.Id,
                                   Username= USERNAME,
                                   Lastname=LASTNAME,
                                   Email = EMAIL,
                                   Alias = ALIAS,
                                   CommunityNickname = 'ComunityNickNameTest2',
                                   Timezonesidkey=EUROPE,
                                   Localesidkey='en_US',
                                   EmailEncodingKey = UTF8,
                                   ID_User__c = IDUSER,
                                   Languagelocalekey='en_US');


        insert SampleUser;

            SampleUser.FirstName = 'NameTest';
            SampleUser.DES_Disable_Chatter__c = true;
            update SampleUser;

            //User userNew = UnitTestUtils.GetDataloaderNewUser('ExternaIDTest','FX');
            User userNew = UnitTestUtils.GetFXSalesUser();
            userNew.DES_Disable_Chatter__c = true;
            insert userNew;

            userNew.DES_Disable_Chatter__c = false;
            update userNew;

        Test.stopTest();


        List<PermissionSetAssignment> psaList = [select Id, PermissionSetId, AssigneeId,Assignee.Username  from PermissionSetAssignment where PermissionSet.Name = :Label.DES_Name_PermissionSet_Chatter];
        List<Id> idList = new List<Id>();
        for (PermissionSetAssignment psa : psaList) {
            idList.add(psa.AssigneeId);
        }

        System.assert(!idList.contains(SampleUser.id), 'Error: method permissionSetChatter_Test first_assertion');
    }

    /**
    *@Author: Global Desktop
    *Description: group
    */
    @isTest
    public static void userToGroupsTest() {

      Test.startTest();
      DES_UtilTestClass utilTestClass = new DES_UtilTestClass();


    List<User> listaUsers = new List<User>();
    String profileTest = utilTestClass.createProfile();
    User userTest1 = utilTestClass.createUser(profileTest);
    userTest1.Entity_name__c = 'DES_LEGAL_Entity_BBVA_PARIS;DES_LEGAL_Entity_BBVA_MADRID';
    userTest1.DES_Country__c = 'ARG';
    listaUsers.add(userTest1);

    User userTest2 = utilTestClass.createUser(profileTest);
    userTest2.Entity_name__c = 'DES_LEGAL_Entity_BBVA_PORTUGAL;DES_LEGAL_Entity_BBVA_MILAN';
    userTest2.username = 'userTest2@none1.es';
    userTest2.CommunityNickname = 'userTest2@none1.es';
    userTest2.ID_User__c = 'userTest2';
    userTest2.DES_Country__c = 'FRA';
    listaUsers.add(userTest2);

    User userTest3 = utilTestClass.createUser(profileTest);
    userTest3.Entity_name__c = 'DES_LEGAL_Entity_BBVA_DEUTSCHLAND; DES_LEGAL_Entity_BBVA_BRUSELAS_IRELAND; DES_LEGAL_Entity_BBVA_NEW_YORK';
    userTest3.username = 'userTest3@none2.es';
    userTest3.CommunityNickname = 'userTest3@usertest3@none.es.es';
    userTest3.ID_User__c = 'userTest3';
    userTest3.DES_Country__c = 'ESP';
    listaUsers.add(userTest3);

    User userTest4 = utilTestClass.createUser(profileTest);
    userTest4.Entity_name__c = 'DES_LEGAL_Entity_BBVA_TAIPEI_TP_DBU';
    userTest4.username = 'userTest4@none2.es';
    userTest4.CommunityNickname = 'userTest4@none2.es';
    userTest4.ID_User__c = 'userTest4';
    userTest4.DES_Country__c = 'ESP';
    listaUsers.add(userTest4);

    system.debug('>>>>> ANTES userTest1.DefaultCurrencyIsoCode: ' + userTest1.DefaultCurrencyIsoCode);
    insert listaUsers;
    system.debug('>>>>> DESPUES userTest1.DefaultCurrencyIsoCode: ' + userTest1.DefaultCurrencyIsoCode);



    listaUsers.get(2).Entity_name__c = 'DES_LEGAL_Entity_BBVA_DEUTSCHLAND; DES_LEGAL_Entity_BBVA_BRUSELAS_IRELAND';

    update listaUsers.get(2);


    userTest1 = [SELECT id, Entity_name__c FROM User WHERE id = :listaUsers.get(2).id];
    System.assertEquals(listaUsers.get(2).Entity_name__c, 'DES_LEGAL_Entity_BBVA_DEUTSCHLAND; DES_LEGAL_Entity_BBVA_BRUSELAS_IRELAND', 'Error');

    Test.stopTest();
    }


    /**
    *@Author: Global Desktop
    *Description: Deleted
    */
    @isTest
    public static void setDeleteGroup() {
      DES_UtilTestClass utilTestClass = new DES_UtilTestClass();


      CIB_Bypass__c bypass = new CIB_Bypass__c(CIB_DES_skip_trigger_in_denorm__c = true);
      upsert bypass;

      String profileTest = utilTestClass.createProfile();
      User userTest = utilTestClass.createUser(profileTest);
      insert userTest;
      CIB_User_Org__c userSettings = utilTestClass.createCustomSetting();

      insert userSettings;

      system.runAs(userTest) {
        Group gggb = new Group();
        gggb.Name = 'DES_LEGAL_Entity_BBVA_NEW_YORK2';
        gggb.DeveloperName = 'DES_LEGAL_Entity_BBVA_NEW_YORK2';
        insert gggb;
        List<User> listaUsersb = new List<User>();
        User userTest1b = utilTestClass.createUser(profileTest);
        userTest1b.username = 'userTest1@none.es';
        userTest1b.CommunityNickname = 'userTest1@none.es';
        userTest1b.ID_User__c = 'userTest1';
        userTest1b.Entity_name__c = 'DES_LEGAL_Entity_BBVA_NEW_YORK2;DES_LEGAL_Entity_BBVA_NEW_YORK2';
        listaUsersb.add(userTest1b);

        User userTest2b = utilTestClass.createUser(profileTest);
        userTest2b.Entity_name__c = 'DES_LEGAL_Entity_BBVA_NEW_YORK2';
        userTest2b.username = 'userTest2@none.es';
        userTest2b.CommunityNickname = 'userTest2@none.es';
        userTest2b.ID_User__c = 'userTest2';
        listaUsersb.add(userTest2b);

        User userTest3b = utilTestClass.createUser(profileTest);
        userTest3b.Entity_name__c = 'BBVA-MADRID-TESORERIA';
        userTest3b.username = 'userTest3@none1.es';
        userTest3b.CommunityNickname = 'userTest3@none1.es';
        userTest3b.ID_User__c = 'userTest3';
        listaUsersb.add(userTest3b);

        User userTest4b = utilTestClass.createUser(profileTest);
        userTest4b.Entity_name__c = 'BBVA-MADRID-TESORERIA;BBVA-MADRID-TESORERIA';
        userTest4b.username = 'userTest4@none1.es';
        userTest4b.CommunityNickname = 'userTest4@none1.es';
        userTest4b.ID_User__c = 'userTest4';
        listaUsersb.add(userTest4b);

        insert listaUsersb;


        Test.startTest();
          update listaUsersb;

          System.assertEquals([SELECT id, UserOrGroupId, GroupId FROM GroupMember WHERE UserOrGroupId = :userTest1b.id].GroupId, gggb.Id, 'Error');

        Test.stopTest();
      }
    }

    /**
    *   @author: Global Desktop
    */
    @isTest
    public static void logicCopySPUsertoGroup() {
      final DES_UtilTestClass utilTestClass = new DES_UtilTestClass();
      final Profile profileSP = [SELECT Id FROM Profile WHERE Name LIKE '%Desktop SP%' LIMIT 1];
      final Profile profBBVAGCCStd = [SELECT Id FROM Profile WHERE Name LIKE '%Desktop GCC Standard%' LIMIT 1];

      Test.startTest();
      User userSP;
      userSP = utilTestClass.createUser((String)profileSP.Id, 'userProfSP@none.es');
      insert userSP;

      User userUpdSP;
      userUpdSP = utilTestClass.createUser((String)profBBVAGCCStd.Id, 'userSPUpd@none.es');
      insert userUpdSP;

      userUpdSP.ProfileId = profileSP.Id;
      update userUpdSP;

      userUpdSP.ProfileId = profBBVAGCCStd.Id;
      update userUpdSP;

      Test.stopTest();
      System.assertEquals(userUpdSP.ProfileId, profBBVAGCCStd.Id, 'Error');

    }

    /**
    *   @author: Service
    */
    @isTest
    public static void mailingGroupTest1() {
      final Profile profileEGS = [SELECT Id FROM Profile WHERE Name = 'Service Client Service Manager EGS' LIMIT 1];

      Test.startTest();
      final User userEGS = new User(ProfileId = profileEGS.Id,
                              Username= 'test1@tested.test',
                              Lastname='LastNameTest1',
                              Email = 'Alias1@accenture.com',
                              Alias = 'Alias1',
                              CommunityNickname = 'ComunityNickNameTest1',
                              Timezonesidkey=EUROPE,
                              Localesidkey='en_US',
                              EmailEncodingKey = UTF8,
                              ID_User__c = 'SampleUserID1',
                              Languagelocalekey='en_US');
      insert userEGS;

      Test.stopTest();
      System.assertEquals('EGS', [SELECT SER_MailingGroup__c FROM SER_MailingGroup__c WHERE SER_User__c = :userEGS.Id].SER_MailingGroup__c, 'Error 1');
}

    /**
    *   @author: Service
    */
    @isTest
    public static void mailingGroupTest2() {
      final Profile profileEGS = [SELECT Id FROM Profile WHERE Name = 'Service Client Service Manager EGS' LIMIT 1];
      final Profile profileGNC = [SELECT Id FROM Profile WHERE Name = 'Service Client Service Manager STE' LIMIT 1];

      Test.startTest();

      final User userGNC = new User(ProfileId = profileGNC.Id,
                              Username= USERNAME,
                              Lastname=LASTNAME,
                              Email = EMAIL,
                              Alias = ALIAS,
                              CommunityNickname = 'ComunityNickNameTest2',
                              Timezonesidkey=EUROPE,
                              Localesidkey='en_US',
                              EmailEncodingKey = UTF8,
                              ID_User__c = IDUSER2,
                              Languagelocalekey='en_US');
      insert userGNC;

      userGNC.ProfileId = profileEGS.Id;
      update userGNC;

      Test.stopTest();
      System.assertEquals(userGNC.ProfileId, profileEGS.Id, 'Error 3');
    }

    /**
    *@Author: Global Desktop
    *Description: Deleted
    */
    @isTest
    public static void assignAmbit() {
      final DES_UtilTestClass utilTestClass = new DES_UtilTestClass();

      final List<Arce_ambit_hierarchy__mdt> ambitMetadatas = new List<Arce_ambit_hierarchy__mdt>([
        SELECT Id, DeveloperName, Action__c, Ambit__c, Description__c, Level__c, Region__c, Selectables__c, canRead__c, canEdit__c
        FROM Arce_ambit_hierarchy__mdt
      ]);
      String ambit1 = '';
      String ambit2 = '';
      String ambit3 = '';
      for(Arce_ambit_hierarchy__mdt ambit : ambitMetadatas) {
        if(ambit.canRead__c && ambit.canEdit__c) {
          ambit1 = ambit.Region__c + ' - ' + ambit.Level__c + (ambit.Description__c == null || ambit.Description__c == '' ? ' -' : ' - ' + ambit.Description__c);
        } else if(!ambit.canRead__c && !ambit.canEdit__c) {
          ambit2 = ambit.Region__c + ' - ' + ambit.Level__c + (ambit.Description__c == null || ambit.Description__c == '' ? ' -' : ' - ' + ambit.Description__c);

        }
      }
      system.debug('** -> ambit1 ' + ambit1);
      String profileTest = utilTestClass.createProfile();
      final User userTest1 = utilTestClass.createUser(profileTest);
      userTest1.gf_user_operation_ambit_name__c = ambit1;
      insert userTest1;
      userTest1.gf_user_operation_ambit_name__c = ambit2;
      update userTest1;
      system.assertNotEquals(null, userTest1.gf_user_operation_ambit_name__c, 'usernotinserted');
    }

    /**
    * Test para checks de creación de usuario de eSales
     */
    @isTest
    public static void assignECommercePermissionSetByRoleTest() {

      Test.startTest();

      Final Id perfil = [SELECT Id FROM Profile WHERE Name = 'BBVA Desktop GM Click To Dial' LIMIT 1].Id;
      Final List<UserRole> usrRole = [SELECT id FROM UserRole WHERE Name='GLOBAL MARKETS E-COMMERCE' OR Name ='GLOBAL MARKETS ECOMMERCE SALES' LIMIT 2];
      Final List<User> sampleUser = new List<User>{new User(ProfileId = perfil,
                                  Username= 'test2@tested.test1',
                                  Lastname='LastNameTest3',
                                  Email = EMAIL,
                                  Alias = 'Alias3',
                                  CommunityNickname = 'ComunityNickNameTest1313',
                                  Timezonesidkey=EUROPE,
                                  Localesidkey='en_US',
                                  EmailEncodingKey = UTF8,
                                  ID_User__c = IDUSER,
                                  Languagelocalekey='en_US',
                                  UserRoleId = usrRole[0].Id), new User(ProfileId = perfil,
                                  Username= USERNAME,
                                  Lastname=LASTNAME,
                                  Email = EMAIL,
                                  Alias = ALIAS,
                                  CommunityNickname = 'ComunityNickNameTest13',
                                  Timezonesidkey=EUROPE,
                                  Localesidkey='en_US',
                                  EmailEncodingKey = UTF8,
                                  ID_User__c = IDUSER2,
                                  Languagelocalekey='en_US',
                                  UserRoleId = usrRole[1].Id)};
      insert sampleUser;
      List<User> updateUsers;
      updateUsers = new List<User>();
      for(User newUser : sampleUser) {
        if(newUser.UserRoleId == usrRole[1].Id) {
          newUser.UserRoleId = usrRole[0].Id;
        } else {
          newUser.UserRoleId = usrRole[1].Id;
        }
        updateUsers.add(newUser);
      }
      update updateUsers;
      Test.stopTest();
      System.assertEquals(sampleUser[1].UserRoleId, usrRole[0].Id, 'El rol es el correcto');
    }

    /**
      * Test para checks de creación de usuario de eSales
      */
    @isTest
    public static void updateECommercePermissionSetByRoleTest() {

      Test.startTest();

      Final Id perfil = [SELECT Id FROM Profile WHERE Name = 'BBVA Desktop GM Click To Dial' LIMIT 1].Id;
      Final List<UserRole> usrRole = [SELECT id FROM UserRole WHERE Name='GLOBAL MARKETS E-COMMERCE' OR Name = 'Global Management' LIMIT 2];
      Final List<User> sampleUser = new List<User>{new User(ProfileId = perfil,
                                  Username= 'test2@tested.test1',
                                  Lastname='LastNameTest3',
                                  Email = EMAIL,
                                  Alias = 'Alias3',
                                  CommunityNickname = 'ComunityNickNameTest1313',
                                  Timezonesidkey=EUROPE,
                                  Localesidkey='en_US',
                                  EmailEncodingKey = UTF8,
                                  ID_User__c = IDUSER,
                                  Languagelocalekey='en_US',
                                  UserRoleId = usrRole[0].Id), new User(ProfileId = perfil,
                                  Username= USERNAME,
                                  Lastname=LASTNAME,
                                  Email = EMAIL,
                                  Alias = ALIAS,
                                  CommunityNickname = 'ComunityNickNameTest13',
                                  Timezonesidkey=EUROPE,
                                  Localesidkey='en_US',
                                  EmailEncodingKey = UTF8,
                                  ID_User__c = IDUSER2,
                                  Languagelocalekey='en_US',
                                  UserRoleId = usrRole[1].Id)};
      insert sampleUser;
      List<User> updateUsers;
      updateUsers = new List<User>();
      for(User newUser : sampleUser) {
        if(newUser.UserRoleId == usrRole[1].Id) {
          newUser.UserRoleId = usrRole[0].Id;
        } else {
          newUser.UserRoleId = usrRole[1].Id;
        }
        updateUsers.add(newUser);
      }
      update updateUsers;
      Test.stopTest();
      System.assertEquals(sampleUser[1].UserRoleId, usrRole[0].Id, 'El rol es el correcto');
    }


    /**
    * Test para checks de creación de usuario de eSales
     */
    @isTest
    public static void updateECommercePermissionSetByRoleTest2() {

      Test.startTest();

      final Id perfil = [SELECT Id FROM Profile WHERE Name = 'BBVA Desktop GM Click To Dial' LIMIT 1].Id;
      final List<UserRole> usrRole = [SELECT id FROM UserRole WHERE Name ='GLOBAL MARKETS ECOMMERCE SALES' OR Name = 'Global Management' LIMIT 2];
      final List<User> sampleUser = new List<User>{new User(ProfileId = perfil,
                                  Username= 'test2@tested.test1',
                                  Lastname='LastNameTest3',
                                  Email = EMAIL,
                                  Alias = 'Alias3',
                                  CommunityNickname = 'ComunityNickNameTest1313',
                                  Timezonesidkey=EUROPE,
                                  Localesidkey='en_US',
                                  EmailEncodingKey = UTF8,
                                  ID_User__c = IDUSER,
                                  Languagelocalekey='en_US',
                                  UserRoleId = usrRole[0].Id), new User(ProfileId = perfil,
                                  Username= USERNAME,
                                  Lastname=LASTNAME,
                                  Email = EMAIL,
                                  Alias = ALIAS,
                                  CommunityNickname = 'ComunityNickNameTest13',
                                  Timezonesidkey=EUROPE,
                                  Localesidkey='en_US',
                                  EmailEncodingKey = UTF8,
                                  ID_User__c = IDUSER2,
                                  Languagelocalekey='en_US',
                                  UserRoleId = usrRole[1].Id)};
      insert sampleUser;
      List<User> updateUsers;
      updateUsers = new List<User>();
      for(User newUser : sampleUser) {
        if(newUser.UserRoleId == usrRole[1].Id) {
          newUser.UserRoleId = usrRole[0].Id;
        } else {
          newUser.UserRoleId = usrRole[1].Id;
        }
        updateUsers.add(newUser);
      }
      update updateUsers;
      Test.stopTest();
      System.assertEquals(sampleUser[1].UserRoleId, usrRole[0].Id, 'El rol es el correcto');
    }

    /**
    *@Author: CIB
    *Description: cucoManagementPG
    */
    @isTest
    public static void cucoManagementPG() {
      final DES_UtilTestClass utilTestClass = new DES_UtilTestClass();
      final String profileTest = utilTestClass.createProfile();
      //Create Parent Group
      final Group grp = new Group();
      grp.name = 'Test Group1';
      grp.Type = 'Regular';
      Insert grp;

      //Create List<User>
      final List<User> listaUsers = new List<User>();
      for (Integer i = 0; i < 2; i++) {
        final User userTest = utilTestClass.createUser(profileTest);
        if(i==0) {
          userTest.gf_manage_cuco__c = true;
        } else {
          userTest.gf_manage_cuco__c = false;
        }
        listaUsers.add(userTest);
      }
      insert listaUsers;

      Test.startTest();
      listaUsers[0].gf_manage_cuco__c = false;
      listaUsers[1].gf_manage_cuco__c = true;
      update listaUsers;
      final Set<Id> resultIds = (new Map<Id,SObject>(listaUsers)).keySet();
      System.assertEquals(1, [SELECT count() FROM GroupMember WHERE UserOrGroupId IN: resultIds], 1);
      Test.stopTest();
    }

  /**
  *@Author: Global Hub
  *Description: Deleted
  */
  @isTest
  public static void assignPricewise() {
    final DES_UtilTestClass utilTestClass = new DES_UtilTestClass();
    final List <PermissionSet> psList = new List<PermissionSet>([
      SELECT Id, Name
      FROM PermissionSet
      WHERE name = 'Pricewise_Available'
    ]);

    String profileTest = utilTestClass.createProfile();
    final User userTest1 = utilTestClass.createUser(profileTest);
    userTest1.gf_pricing_gtb_type__c = true;
    insert userTest1;
    final List<PermissionSetAssignment> currentAssign = new List <PermissionSetAssignment>([
      SELECT Id, PermissionSetId, AssigneeId
      FROM PermissionSetAssignment
      WHERE PermissionSetId = :psList.get(0).Id AND AssigneeId = :userTest1.Id
    ]);
    userTest1.gf_pricing_gtb_type__c = false;
    update userTest1;
    system.assertNotEquals(false, currentAssign.isEmpty(), 'usernotinserted');
  }
}