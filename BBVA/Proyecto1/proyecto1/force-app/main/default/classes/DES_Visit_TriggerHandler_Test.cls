/*
* @author       Global Desktop
* @date         28/04/2020
* @description  Clase para los test de Visitas
*/
@isTest
public with sharing class DES_Visit_TriggerHandler_Test {

  /*
  * Variable de la clase DES_UtilTestClass
  */
  private final static DES_UtilTestClass UTIL_TEST_CLASS = new DES_UtilTestClass();

  @isTest//NOSONAR
  /*
  *
  *Met0d0 para comprobar el funcionamiento de crearChatter del trigger de oportunidad
  */
  public static void visitFromVenClient() {
    List<Account> accs;
    accs = new List <Account>();
    final Account acc = UTIL_TEST_CLASS.createClient();
    acc.DES_Country_Client__c = 'VE';
    accs.add(acc);
    final Account acc2 = UTIL_TEST_CLASS.createClient();
    acc2.DES_Country_Client__c = 'VE';
    accs.add(acc2);

    insert accs;

    final DES_Subsidiary_Group_Relation__c relation = new DES_Subsidiary_Group_Relation__c();
    relation.participant_child_id__c = acc.Id;
    relation.participant_parent_id__c = acc2.Id;

    insert relation;

    final Id idProfile = [Select Id, Name from Profile Where Name = 'BBVA Desktop GCC Standard'].Id;

    List<User> users;
    users = new List <user>();
    final User user1 = UTIL_TEST_CLASS.createUser(idProfile);
    final User user2 = UTIL_TEST_CLASS.createUser(idProfile,'Heyhey@oppven.com');
    users.add(user1);
    users.add(user2);

    insert users;

    List<DES_BBVA_Management_team__c> lstTeamMag;
    lstTeamMag = new List<DES_BBVA_Management_team__c>();
    final DES_BBVA_Management_team__c teamMmg1 = new DES_BBVA_Management_team__c();
    teamMmg1.DES_Local_Banker_Country__c = 'VE';
    teamMmg1.DES_Member_Role__c = Label.DES_Role_Transactional_Banker;
    teamMmg1.DES_User__c = user1.Id;
    teamMmg1.DES_Client__c = acc2.Id;
    lstTeamMag.add(teamMmg1);

    final DES_BBVA_Management_team__c teamMmg2 = new DES_BBVA_Management_team__c();
    teamMmg2.DES_Local_Banker_Country__c = 'Global';
    teamMmg2.DES_Member_Role__c = Label.DES_ROLE_GLOBAL_BANKER;
    teamMmg2.DES_User__c = user2.Id;
    teamMmg2.DES_Client__c = acc2.Id;
    lstTeamMag.add(teamMmg2);

    insert lstTeamMag;

    dwp_kitv__Visit__c newVisit;
    newVisit = new dwp_kitv__Visit__c();
    newVisit.dwp_kitv__disclosure_info_type__c = 'Not applicable';
    newVisit.Name = 'Test Visit';
    newVisit.dwp_kitv__visit_start_date__c =  Date.valueOf('2020-05-20T06:47:00.000+0000');
    newVisit.dwp_kitv__account_id__c = acc.Id;
    newVisit.dwp_kitv__visit_duration_number__c = '15';

    insert newVisit;

    final List<dwp_kitv__Visit__Share> listToVerify = [Select Id, UserOrGroupId, ParentId from dwp_kitv__Visit__Share Where ParentId = :newVisit.Id AND (UserOrGroupId =:user1.Id OR UserOrGroupId =:user2.Id)];

    system.assertEquals(2,listToVerify.size(),'No se han creado las Manual Sharing Rules necesarias');

  }
}