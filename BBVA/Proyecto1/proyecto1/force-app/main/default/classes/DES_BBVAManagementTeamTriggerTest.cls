@isTest
public class DES_BBVAManagementTeamTriggerTest {
    private static almd__Commercial_Alert__c createAlert(User user1, User user2, Account acc, Integer i, String rt){
        almd__Commercial_Alert__c comAl1 = new almd__Commercial_Alert__c();
        comAl1.Name = 'Prueba Alerta'+i;
        comAl1.almd__owner_access_alert_id__c = user1.ID_User__c;
        comAl1.almd__User_id__c = user2.Id;
        comAl1.almd__commercial_alert_id__c = 'Id'+i;
        comAl1.almd__participant_id__c = acc.id;
        comAl1.almd__commercial_alert_start_date__c = system.today();
        comAl1.almd__commercial_alert_end_date__c = system.today();
        comAl1.almd__commercial_alert_record_type__c = rt;
        comAl1.almd__commercial_alert_desc__c = 'Prueba';
        comAl1.almd__priority_alert_type__c = 'High';
        comAl1.almd__data_source_name__c = 'Test';
        comAl1.almd__commercial_alert_task_type__c = 'backup';
        return comAl1;
    }

    @isTest(SeeAllData=true)
    public static void DES_BBVAManagementTeamTriggerTest(){
        //Datos necesarios
        DES_UtilTestClass utilTestClass = new DES_UtilTestClass();
        String profileTest = utilTestClass.createProfile();
        User userTest1 = utilTestClass.createUser(profileTest);
        userTest1.ProfileId = [SELECT Id, Name FROM Profile WHERE Name = 'Desktop Integration' LIMIT 1].Id;
        insert userTest1;
        //CIB_User_Org__c userSettings = utilTestClass.createCustomSetting();
        //insert userSettings;

        system.runAs(userTest1){
            Test.startTest();
            List<Account> listaAccounts = new List<Account>();
            List<Opportunity> listaOpps = new List<Opportunity>();
            List<dwp_kitv__Visit__c> listaVisitas = new List<dwp_kitv__Visit__c>();
            List<DES_Subsidiary_Group_Relation__c> listaMatrix = new List<DES_Subsidiary_Group_Relation__c>();
            Account acc1 = utilTestClass.createClient();
            acc1.DES_BBVA_Segmentation__c = 'CIB';
            acc1.DES_Structure_Type__c = Label.DES_STR_TYPE_Group;
            insert acc1;
            Account acc2 = utilTestClass.createClient();
            acc2.DES_Main_Parent__c = acc1.Id;
            acc2.DES_Country_Client__c = 'ES';
            listaAccounts.add(acc2);
            Account acc3 = utilTestClass.createClient();
            acc3.DES_Main_Parent__c = acc1.Id;
            listaAccounts.add(acc3);
            insert listaAccounts;

            DES_Subsidiary_Group_Relation__c matrix = new DES_Subsidiary_Group_Relation__c();
            matrix.participant_child_id__c = acc2.Id;
            matrix.main_subsidiary_ind_type__c = true;
            matrix.participant_parent_id__c = acc1.Id;
            listaMatrix.add(matrix);
            DES_Subsidiary_Group_Relation__c matrix2 = new DES_Subsidiary_Group_Relation__c();
            matrix2.participant_child_id__c = acc3.Id;
            matrix2.main_subsidiary_ind_type__c = true;
            matrix2.participant_parent_id__c = acc1.Id;
            listaMatrix.add(matrix2);
            insert listaMatrix;


            Opportunity opp = utilTestClass.createOpportunity(acc2);
            opp.StageName = LABEL.DES_Proposal;
            listaOpps.add(opp);
            Opportunity opp2 = utilTestClass.createOpportunity(acc2);
            opp2.StageName = LABEL.DES_Proposal;
            listaOpps.add(opp2);
            Opportunity opp3 = utilTestClass.createOpportunity(acc3);
            opp3.StageName = LABEL.DES_Proposal;
            listaOpps.add(opp3);
            insert listaOpps;

            dwp_kitv__Visit__c visit = utilTestClass.createVisit(acc2, opp);
            visit.disclosure_info_type__c = Label.DES_OP_CONFIDENTIAL;
            listaVisitas.add(visit);
            dwp_kitv__Visit__c visit2 = utilTestClass.createVisit(acc2, opp2);
            visit2.disclosure_info_type__c = Label.DES_OP_CONFIDENTIAL;
            listaVisitas.add(visit2);
            insert listaVisitas;

            List<DES_BBVA_Management_team__c> listaBBVAMT = new List<DES_BBVA_Management_team__c>();
            DES_BBVA_Management_team__c bbvaManagementTeam1 = utilTestClass.createBBVAManagementTeamMember(userTest1, acc1);
            bbvaManagementTeam1.DES_Local_Banker_Country__c = 'ES';
            bbvaManagementTeam1.DES_Member_Role__c = Label.DES_ROLE_INDUSTRY_HEAD;
            listaBBVAMT.add(bbvaManagementTeam1);
            DES_BBVA_Management_team__c bbvaManagementTeam2 = utilTestClass.createBBVAManagementTeamMember(userTest1, acc2);
            bbvaManagementTeam2.DES_Local_Banker_Country__c = 'ES';
            bbvaManagementTeam2.DES_Member_Role__c = Label.DES_ROLE_LOCAL_BANKER;
            listaBBVAMT.add(bbvaManagementTeam2);
            DES_BBVA_Management_team__c bbvaManagementTeam3 = utilTestClass.createBBVAManagementTeamMember(userTest1, acc2);
            bbvaManagementTeam3.DES_Member_Role__c = Label.DES_ROLE_GLOBAL_BANKER;
            bbvaManagementTeam3.DES_Local_Banker_Country__c = 'Global';
            bbvaManagementTeam3.copy_record_approval_type__c = true;
            listaBBVAMT.add(bbvaManagementTeam3);
            DES_BBVA_Management_team__c bbvaManagementTeam4 = utilTestClass.createBBVAManagementTeamMember(userTest1, acc3);
            bbvaManagementTeam4.DES_Local_Banker_Country__c = 'ES';
            bbvaManagementTeam4.DES_Member_Role__c = Label.DES_Role_Product_Specialist;
            Product2 product = utilTestClass.createProduct('Credit');
            insert product;
            bbvaManagementTeam4.DES_PS_Product_Family__c = 'GTB';
            bbvaManagementTeam4.DES_PS_Product__c = product.Id;
            listaBBVAMT.add(bbvaManagementTeam4);
            insert listaBBVAMT;
			Test.stopTest();
            /**/List<almd__Commercial_Alert__c> listCA = new List<almd__Commercial_Alert__c>();
            almd__Commercial_Alert__c comAl1 = createAlert(userTest1, userTest1, acc2, 1, 'Commercial Task IBF');
            system.debug('comAl1 -> ' + comAl1.almd__participant_id__c);
	        almd__Commercial_Alert__c comAl2 = createAlert(userTest1, userTest1, acc2, 1, 'Commercial Task IBF');
	        listCA.add(comAl1);
	        listCA.add(comAl2);/**/

            try{
                /**/system.debug('>>>>> listCA SIN ID : ' + listCA);
                insert listCA;
                system.debug('>>>>> listCA : ' + listCA);/**/
                DES_BBVA_Management_team__c bbvaManagementTeamPermissions = utilTestClass.createBBVAManagementTeamMember(userTest1, acc3);
                bbvaManagementTeamPermissions.DES_Local_Banker_Country__c = 'Global';
                bbvaManagementTeamPermissions.DES_Member_Role__c = Label.DES_ROLE_INDUSTRY_HEAD;
                insert bbvaManagementTeamPermissions;
                system.debug('>>>>> bbvaManagementTeamPermissions : ' + bbvaManagementTeamPermissions);
            }catch(Exception e){    }
            listaBBVAMT.get(2).copy_record_approval_type__c = false;
            update listaBBVAMT.get(2);
            //delete listaBBVAMT.get(2);
            List<DES_BBVA_Management_team__c> listaBBVAMTDuplicados = new List<DES_BBVA_Management_team__c>();
            DES_BBVA_Management_team__c bbvaManagementTeam1D = utilTestClass.createBBVAManagementTeamMember(userTest1, acc1);
            bbvaManagementTeam1D.DES_Local_Banker_Country__c = 'ES';
            bbvaManagementTeam1D.DES_Member_Role__c = Label.DES_ROLE_INDUSTRY_HEAD;
            listaBBVAMTDuplicados.add(bbvaManagementTeam1D);
            DES_BBVA_Management_team__c bbvaManagementTeam2D = utilTestClass.createBBVAManagementTeamMember(userTest1, acc2);
            bbvaManagementTeam2D.DES_Local_Banker_Country__c = 'ES';
            bbvaManagementTeam2D.DES_Member_Role__c = Label.DES_Role_Transactional_Banker;
            listaBBVAMTDuplicados.add(bbvaManagementTeam2D);
            DES_BBVA_Management_team__c bbvaManagementTeam3D = utilTestClass.createBBVAManagementTeamMember(userTest1, acc3);
            bbvaManagementTeam3D.DES_Local_Banker_Country__c = 'ES';
            bbvaManagementTeam3D.DES_Member_Role__c = Label.DES_Role_Product_Specialist;
            bbvaManagementTeam3D.DES_PS_Product_Family__c = 'GTB';
            bbvaManagementTeam3D.DES_PS_Product__c = product.Id;
            listaBBVAMTDuplicados.add(bbvaManagementTeam3D);
            try {
                insert listaBBVAMTDuplicados;
            }
            catch(Exception e) {
                system.debug('Exception: ' + e);
            }
            //update listaBBVAMTDuplicados;

            DES_BBVA_Management_team__c bbvaManagementTeamIndiv = utilTestClass.createBBVAManagementTeamMember(userTest1, acc3);
            bbvaManagementTeamIndiv.DES_Local_Banker_Country__c = 'ES';
            bbvaManagementTeamIndiv.DES_Member_Role__c = Label.DES_Role_Product_Specialist;
            bbvaManagementTeamIndiv.DES_PS_Product_Family__c = 'GTB';
            bbvaManagementTeamIndiv.DES_PS_Product__c = product.Id;
            try{
                insert bbvaManagementTeamIndiv;
            }catch(Exception e){
                system.debug('>>>>> EXCEPTION: ' + e);
            }

			String jobId = system.schedule('Test Check', '0 0 2 * * ?', new DES_Schedulable_BBVASharing());

            DES_BBVA_Management_team__c bbvaManagementTeamInactive = utilTestClass.createBBVAManagementTeamMember(userTest1, acc3);
            bbvaManagementTeamInactive.DES_Local_Banker_Country__c = 'ES';
            bbvaManagementTeamInactive.DES_Member_Role__c = Label.DES_Role_Product_Specialist;
            bbvaManagementTeamInactive.DES_PS_Product_Family__c = 'GTB';
            bbvaManagementTeamInactive.DES_PS_Product__c = product.Id;
            bbvaManagementTeamInactive.copy_record_approval_type__c = true;
            try{
                insert bbvaManagementTeamInactive;
            }catch(Exception e){    }


            //Test
            //Test.startTest();
            delete listaBBVAMT;


            //Validaciones
            List<DES_BBVA_Management_team__c> bbvaManagementTeam_assert = [Select Id From DES_BBVA_Management_team__c Where id = :listaBBVAMT.get(0).Id];
            System.assertEquals(0, bbvaManagementTeam_assert.size());

        }

    }

    /**
     * Prueba que los Global Bankers y Industry Head de una cuenta que llegan por integración puedan sustituir a los actuales
     * si el usuario es distinto.
     */
    @isTest
    static void deleteTeamMembersBeforeInsertTest (){

        DES_UtilTestClass utilTestClass = new DES_UtilTestClass();
        String profileTest = utilTestClass.createProfile();

        List<User> usersToInsert = new List<User>();

        User runningUser = utilTestClass.createUserWithProfileName('Desktop Integration', 'runningUser@bbvatest.test');
        usersToInsert.add(runningUser);

        User userTest1 = utilTestClass.createUser(profileTest);
        userTest1.ID_User__c = 'userTest1';
        usersToInsert.add( userTest1 );

        User globalBankerUser = utilTestClass.createUser(profileTest);
        globalBankerUser.username = 'globalBankerUser@testbbva.test';
        globalBankerUser.ID_User__c = 'globalBankerIDUSER';
        globalBankerUser.CommunityNickname = 'globalBankerIDUSERCN';
        usersToInsert.add( globalBankerUser );

        User industryHeadUser = utilTestClass.createUser(profileTest);
        industryHeadUser.username = 'industryHeadUser@testbbva.test';
        industryHeadUser.ID_User__c = 'industryHeadIDUSER';
        industryHeadUser.CommunityNickname = 'industryHeadIDUSERCN';
        usersToInsert.add( industryHeadUser );

        Test.startTest();

        insert usersToInsert;

        system.runAs(runningUser) {

            insert new CIB_Bypass__c( CIB_DES_DataMigration__c = true );

            // create a CIB group
            Account accGroup = utilTestClass.createClient();
            accGroup.DES_BBVA_Segmentation__c = 'CIB';
            accGroup.DES_Structure_Type__c = Label.DES_STR_TYPE_Group;
            accGroup.DES_Group_Code__c = 'accGroup';
            insert accGroup;

            // Add a global banker and an Industry Head
            List<DES_BBVA_Management_team__c> teamMembers = new List<DES_BBVA_Management_team__c>();

            DES_BBVA_Management_team__c globalBankerTM = utilTestClass.createBBVAManagementTeamMember(globalBankerUser, accGroup);
            globalBankerTM.DES_Local_Banker_Country__c = '';
            globalBankerTM.DES_Member_Role__c = Label.DES_ROLE_GLOBAL_BANKER;
            globalBankerTM.DES_Clave_Externa__c = 'accGroup-' + globalBankerUser.ID_User__c + '--' + Label.DES_ROLE_GLOBAL_BANKER;
            teamMembers.add(globalBankerTM);

            DES_BBVA_Management_team__c industryHeadTM = utilTestClass.createBBVAManagementTeamMember(industryHeadUser, accGroup);
            industryHeadTM.DES_Local_Banker_Country__c = '';
            industryHeadTM.DES_Member_Role__c = Label.DES_ROLE_INDUSTRY_HEAD;
            industryHeadTM.DES_Clave_Externa__c = 'accGroup-' + industryHeadUser.ID_User__c + '--' + Label.DES_ROLE_INDUSTRY_HEAD;
            teamMembers.add(industryHeadTM);

            insert teamMembers;

            // NEW TEAM MEMBERS, GLOBAL BANKER AND INDUSTRY HEAD of userTest1
            List<DES_BBVA_Management_team__c> newTeamMembers = new List<DES_BBVA_Management_team__c>();

            DES_BBVA_Management_team__c newGlobalBanker = utilTestClass.createBBVAManagementTeamMember(userTest1, accGroup);
            newGlobalBanker.DES_Local_Banker_Country__c = '';
            newGlobalBanker.DES_Member_Role__c = Label.DES_ROLE_GLOBAL_BANKER;
            newGlobalBanker.DES_Clave_Externa__c = 'accGroup-' + userTest1.ID_User__c + '--' + Label.DES_ROLE_GLOBAL_BANKER;
            newTeamMembers.add(newGlobalBanker);

            DES_BBVA_Management_team__c newIndustryHead = utilTestClass.createBBVAManagementTeamMember(userTest1, accGroup);
            newIndustryHead.DES_Local_Banker_Country__c = '';
            newIndustryHead.DES_Member_Role__c = Label.DES_ROLE_INDUSTRY_HEAD;
            newIndustryHead.DES_Clave_Externa__c = 'accGroup-' + userTest1.ID_User__c + '--' + Label.DES_ROLE_INDUSTRY_HEAD;
            newTeamMembers.add(newIndustryHead);

            insert newTeamMembers;

            // THE ONLY MEMBERS OF THE ACCOUNT SHOULD BE THE LAST ONES, THE TWO TEAM MEMBERS OF userTest1
            List<DES_BBVA_Management_team__c> tms = [
                SELECT DES_Client__r.DES_Group_Code__c, DES_User__r.ID_User__c,
                    DES_Member_Role__c, DES_Clave_Externa__c
                FROM DES_BBVA_Management_team__c
                WHERE (DES_Member_Role__c =: Label.DES_ROLE_GLOBAL_BANKER OR DES_Member_Role__c =: Label.DES_ROLE_INDUSTRY_HEAD)
                AND DES_User__r.ID_User__c = :userTest1.ID_User__c
                AND DES_Clave_Externa__c <> null
                AND DES_Client__r.DES_Group_Code__c = 'accGroup'
            ];

            System.assertEquals(2, tms.size());

        }

        Test.stopTest();

    }
  /*
  * Method Transaction
  */
  @isTest
  static void trasactionMethod() {
    final DES_UtilTestClass utilTestClass = new DES_UtilTestClass();

    final String profileTest = utilTestClass.createProfile();
    final List<User> usersToInsert = new List<User>();
    final User runningUser = utilTestClass.createUserWithProfileName('Desktop Integration', 'runningUser@bbvatest.test');
    usersToInsert.add(runningUser);

    final User userTest1 = utilTestClass.createUser(profileTest);
    userTest1.ID_User__c = 'userTest1';
    usersToInsert.add(userTest1);

    insert usersToInsert;

    system.runAs(runningUser) {
    // create a CIB group
      Account accGroup = utilTestClass.createClient();
      accGroup.DES_BBVA_Segmentation__c = 'CIB';
      accGroup.DES_Structure_Type__c = Label.DES_STR_TYPE_Group;
      accGroup.DES_Group_Code__c = 'accGroup';
      insert accGroup;

      DES_BBVA_Management_team__c oBBVAMt = utilTestClass.createBBVAManagementTeamMember(userTest1, accGroup);
      oBBVAMt.DES_Member_Role__c = Label.DES_Role_Transactional_Banker;
      oBBVAMt.DES_Clave_Externa__c = 'accGroup-Transaction Banker';
      insert oBBVAMt;
    }

    final DES_BBVA_Management_team__c oBBVAMT1 = [SELECT Id, DES_Member_Role__c
      FROM DES_BBVA_Management_team__c
      WHERE DES_Clave_Externa__c = 'accGroup-Transaction Banker'
      LIMIT 1];

    system.debug('++ -> ' + oBBVAMT1.DES_Member_Role__c);
    system.assertEquals(Label.DES_Role_Transactional_Banker, oBBVAMT1.DES_Member_Role__c, 'Not Transactioinal');
  }
}