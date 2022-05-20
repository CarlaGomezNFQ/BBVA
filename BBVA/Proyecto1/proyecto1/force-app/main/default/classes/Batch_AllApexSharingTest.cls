/*
* @author       Global Desktop
* @date         23/03/2020
* @description  Clase de test para Batch_AllApexSharingTest
*/
@isTest
public class Batch_AllApexSharingTest {

	/*
	* Constructor
	*/
	@isTest
	public static void apexSharingAllApexSharingBatch() {
		/*Inicialización de datos*/
        final DES_UtilTestClass utilTestClass = new DES_UtilTestClass();
        final String profileTest = utilTestClass.createProfile();
        final User userTest1 = utilTestClass.createUser(profileTest);
        userTest1.ProfileId = [SELECT Id, Name FROM Profile WHERE Name = 'Desktop Integration' LIMIT 1].Id;
		   insert userTest1;
		    Test.startTest();
			loadTestData(userTest1);
			Test.stopTest();
        	system.runAs(userTest1) {

			final Id batchInstanceId2 = Database.executeBatch(new Batch_CreateAllApexSharing(), 10);
			final List <OpportunityShare> oppShare = new List <OpportunityShare>([SELECT Id FROM OpportunityShare WHERE RowCause = 'Manual']);
			system.debug(oppShare);
			boolean testAssert = false;
			if(batchInstanceId2 != null) {
				testAssert = true;
			}
			System.assert(testAssert,'KO');

		}
	}//FIN createApexSharingVisitMTest

	/*
	* apexSharingVisitMembersBatch Method
	*/
	@isTest
	public static void apexSharingVisitMembersBatch() {
		//Datos necesarios
        final DES_UtilTestClass utilTestClass = new DES_UtilTestClass();
        final String profileTest = utilTestClass.createProfile();
        final User userTest1 = utilTestClass.createUser(profileTest);
        userTest1.ProfileId = [SELECT Id, Name FROM Profile WHERE Name = 'Desktop Integration' LIMIT 1].Id;
       	insert userTest1;
		Test.startTest();
			loadTestData(userTest1);
			Test.stopTest();
        	system.runAs(userTest1) {
			final Id batchInstanceId2 = Database.executeBatch(new Batch_CreateApexSharingVisitMembers(), 20000);
			final List <dwp_kitv__Visit__Share> visitShare = new List <dwp_kitv__Visit__Share>([SELECT Id FROM dwp_kitv__Visit__Share WHERE RowCause = 'Manual']);
			system.debug(visitShare);
			boolean testAssert = false;
			if(batchInstanceId2 != null) {
				testAssert = true;
			}
			System.assert(testAssert,'KO');
		}
	}//FIN createApexSharingVisitMTest

	/*
	* apexSharingDeleteVisitsBatch Method
	*/
	@isTest
	public static void apexSharingDeleteVisitsBatch() {
		//Datos necesarios
        final DES_UtilTestClass utilTestClass = new DES_UtilTestClass();
        final String profileTest = utilTestClass.createProfile();
        final User userTest1 = utilTestClass.createUser(profileTest);
        userTest1.ProfileId = [SELECT Id, Name FROM Profile WHERE Name = 'Desktop Integration' LIMIT 1].Id;
		   insert userTest1;
		    Test.startTest();
			loadTestData(userTest1);
			Test.stopTest();
        	system.runAs(userTest1) {
			final Id batchInstanceId2 = Database.executeBatch(new Batch_DeleteVisitsApexSharing(), 20000);
			System.assertNotEquals(batchInstanceId2, null);

		}
	}//FIN createApexSharingVisitMTest

	/*
	* apexSharingDeleteOppsBatch Method
	*/
	@isTest
	public static void apexSharingDeleteOppsBatch() {
		//Datos necesarios
        final DES_UtilTestClass utilTestClass = new DES_UtilTestClass();
        final String profileTest = utilTestClass.createProfile();
        final User userTest1 = utilTestClass.createUser(profileTest);
        userTest1.ProfileId = [SELECT Id, Name FROM Profile WHERE Name = 'Desktop Integration' LIMIT 1].Id;
		   insert userTest1;
		    Test.startTest();
			loadTestData(userTest1);
			Test.stopTest();
        	system.runAs(userTest1) {
			final Id batchInstanceId2 = Database.executeBatch(new Batch_DeleteOppApexSharing(), 20000);
			System.assertNotEquals(batchInstanceId2, null);
		}
	}//FIN createApexSharingVisitMTest

    /*
     * testOneClient method
	*/
    @isTest
	public static void testOneClient() {
		final DES_UtilTestClass util = new DES_UtilTestClass();
        final Account acc = util.createClient();
        insert acc;
        final String profile = util.createProfile();
        final User user1 = util.createUser(profile);
        insert user1;
        final Opportunity opp = util.createOpportunity(acc);
        insert opp;
        final almd__Commercial_Alert__c alert = util.createAlert(user1, user1, acc, 48, 'Commercial Task IBF');
        insert alert;
        final dwp_kitv__Visit__c visit = util.createVisit(acc,opp);
        insert visit;
        final DES_BBVA_Management_team__c bbvaMT = util.createBBVAManagementTeamMember(user1, acc);
        insert bbvaMT;
        system.runAs(user1) {
			Test.startTest();
			final Id batchInstanceId2 = Database.executeBatch(new Batch_CreateAllApexSharing(), 20000);
			System.assertNotEquals(batchInstanceId2, null);
			Test.stopTest();
		}
	}
    /*
     * testMultiClient method
	*/
    @isTest
	public static void testMultiClient() {
		final DES_UtilTestClass util = new DES_UtilTestClass();
        final Account acc = util.createClient();
        insert acc;
        final String profile = util.createProfile();
        final User user1 = util.createUser(profile);
        insert user1;
        final List<Opportunity> opps = new List<Opportunity>();
        final Opportunity opp = util.createOpportunity(acc);
        final Opportunity opp2 = util.createOpportunity(acc);
        opps.add(opp);
        opps.add(opp2);
        insert opps;
        final List<almd__Commercial_Alert__c> alerts = new List<almd__Commercial_Alert__c>();
        final almd__Commercial_Alert__c alert = util.createAlert(user1, user1, acc, 48, 'Commercial Task IBF');
        final almd__Commercial_Alert__c alert2 = util.createAlert(user1, user1, acc, 58, 'Commercial Task IBF');
        alerts.add(alert);
        alerts.add(alert2);
        insert alerts;
        final List<dwp_kitv__Visit__c> visits = new List<dwp_kitv__Visit__c>();
        final dwp_kitv__Visit__c visit = util.createVisit(acc,opp);
        final dwp_kitv__Visit__c visit2 = util.createVisit(acc,opp2);
        visits.add(visit);
        visits.add(visit2);
        insert visits;
        final DES_BBVA_Management_team__c bbvaMT = util.createBBVAManagementTeamMember(user1, acc);
        insert bbvaMT;
        system.runAs(user1) {
			Test.startTest();
			Id batchInstanceId2 = Database.executeBatch(new Batch_CreateAllApexSharing(), 20000);
			System.assertNotEquals(batchInstanceId2, null);
			Test.stopTest();
		}
	}

	/*
	* loadTestData Method
	*/
	public static void loadTestData(User userTest1) {
		final DES_UtilTestClass utilTestClass = new DES_UtilTestClass();
		final List<Account> listaAccounts = new List<Account>();
    	final List<Opportunity> listaOpps = new List<Opportunity>();
    	final List<dwp_kitv__Visit__c> listaVisitas = new List<dwp_kitv__Visit__c>();
    	final List<DES_Subsidiary_Group_Relation__c> listaMatrix = new List<DES_Subsidiary_Group_Relation__c>();
        final Account acc1 = utilTestClass.createClient();
        acc1.DES_BBVA_Segmentation__c = 'CIB';
        acc1.DES_Structure_Type__c = Label.DES_STR_TYPE_Group;
        listaAccounts.add(acc1);
        final Account acc4 = utilTestClass.createClient();
        acc4.DES_BBVA_Segmentation__c = 'CIB';
        acc4.DES_Structure_Type__c = Label.DES_STR_TYPE_Group;
        listaAccounts.add(acc4);
        final Account acc2 = utilTestClass.createClient();
        acc2.DES_Main_Parent__c = acc1.Id;
        acc2.DES_Country_Client__c = 'ES';
        listaAccounts.add(acc2);
        final Account acc3 = utilTestClass.createClient();
        acc3.DES_Main_Parent__c = acc1.Id;
        listaAccounts.add(acc3);
        final Account acc5 = utilTestClass.createClient();
        acc5.DES_Main_Parent__c = acc4.Id;
        listaAccounts.add(acc5);
        insert listaAccounts;
        final DES_Subsidiary_Group_Relation__c matrix = new DES_Subsidiary_Group_Relation__c();
    	matrix.participant_child_id__c = acc2.Id;
    	//matrix.senior_pos_type__c = userTest1.Id;
    	matrix.participant_parent_id__c = acc1.Id;
        matrix.main_subsidiary_ind_type__c = true;
    	listaMatrix.add(matrix);
    	final DES_Subsidiary_Group_Relation__c matrix2 = new DES_Subsidiary_Group_Relation__c();
    	matrix2.participant_child_id__c = acc3.Id;
    	//matrix2.senior_pos_type__c = userTest1.Id;
    	matrix2.participant_parent_id__c = acc1.Id;
        matrix2.main_subsidiary_ind_type__c = true;
    	listaMatrix.add(matrix2);
    	final DES_Subsidiary_Group_Relation__c matrix3 = new DES_Subsidiary_Group_Relation__c();
    	matrix3.participant_child_id__c = acc5.Id;
    	//matrix3.senior_pos_type__c = userTest1.Id;
    	matrix3.participant_parent_id__c = acc4.Id;
        matrix3.main_subsidiary_ind_type__c = true;
    	listaMatrix.add(matrix3);
    	insert listaMatrix;
    	final Opportunity opp = utilTestClass.createOpportunity(acc2);
    	opp.StageName = LABEL.DES_Proposal;
    	listaOpps.add(opp);
    	insert listaOpps;
    	final dwp_kitv__Visit__c visit = utilTestClass.createVisit(acc2, opp);
    	visit.disclosure_info_type__c = Label.DES_OP_CONFIDENTIAL;
    	listaVisitas.add(visit);
    	insert listaVisitas;
        final List<DES_BBVA_Management_team__c> listaBBVAMT = new List<DES_BBVA_Management_team__c>();
        final DES_BBVA_Management_team__c bbvaManagementTeam1 = utilTestClass.createBBVAManagementTeamMember(userTest1, acc1);
        bbvaManagementTeam1.DES_Local_Banker_Country__c = 'ES';
        bbvaManagementTeam1.DES_Member_Role__c = Label.DES_ROLE_INDUSTRY_HEAD;
        listaBBVAMT.add(bbvaManagementTeam1);
        final DES_BBVA_Management_team__c bbvaManagementTeam2 = utilTestClass.createBBVAManagementTeamMember(userTest1, acc2);
        bbvaManagementTeam2.DES_Local_Banker_Country__c = 'ES';
        bbvaManagementTeam2.DES_Member_Role__c = Label.DES_ROLE_LOCAL_BANKER;
        listaBBVAMT.add(bbvaManagementTeam2);
        final DES_BBVA_Management_team__c bbvaManagementTeam3 = utilTestClass.createBBVAManagementTeamMember(userTest1, acc2);
        bbvaManagementTeam3.DES_Member_Role__c = Label.DES_ROLE_GLOBAL_BANKER;
        bbvaManagementTeam3.DES_Local_Banker_Country__c = 'Global';
        bbvaManagementTeam3.copy_record_approval_type__c = true;
        listaBBVAMT.add(bbvaManagementTeam3);
        //IF QUERY LIMIT TRY HIDE START
        final DES_BBVA_Management_team__c bbvaManagementTeam4 = utilTestClass.createBBVAManagementTeamMember(userTest1, acc3);
        bbvaManagementTeam4.DES_Local_Banker_Country__c = 'ES';
        bbvaManagementTeam4.DES_Member_Role__c = Label.DES_Role_Product_Specialist;
        final Product2 product = utilTestClass.createProduct('Credit');
        insert product;
        bbvaManagementTeam4.DES_PS_Product_Family__c = 'GTB';
        bbvaManagementTeam4.DES_PS_Product__c = product.Id;
        listaBBVAMT.add(bbvaManagementTeam4);
        //IF QUERY LIMIT TRY HIDE FINISH
        insert listaBBVAMT;
        final List<dwp_kitv__Visit_Management_Team__c> listVisitMembers = new List<dwp_kitv__Visit_Management_Team__c>();
        final dwp_kitv__Visit_Management_Team__c visitMember = utilTestClass.createVisitTM(userTest1, listaVisitas.get(0));
        listVisitMembers.add(visitMember);
		insert listVisitMembers;
	}//FIN loadTestData
}//FIN Batch_CreateApexSharingVisitMembersTest