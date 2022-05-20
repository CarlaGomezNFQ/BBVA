/*-----------------------------------------------------------------------------------------------
    Author:        Rodrigo Fdez-Victorio
    Company:       Accenture
    Description:   Testclass for MasterCase methods

    History:
    <Date>          <Author>                <Description>
    08/07/2017      Juan Carlos Terrón        Initial version
    -------------------------------------------------------------------------------------------------*/
@isTest
public with sharing class SER_CaseMethodsMasterCase_TEST {
  /*-----------------------------------------------------------------------------------------------
          Author:        Rodrigo Fdez-Victorio
          Company:       Accenture
          Description:   Test method for master Case notification

          History:
          <Date>          <Author>                <Description>
          08/07/2017      Juan Carlos Terrón        Initial version
      -------------------------------------------------------------------------------------------------*/
  public static testMethod void  manageMasterCaseNotificationsTEST() {


    final Case caso = new Case(OwnerId = UserInfo.getUserId(),
                                SuppliedEmail = 'aaa1@example.aa',
                                SER_Is_Master_Case__c = true,
                                SER_Send_email_close_master_case__c = false,
                                Status = 'Closed');



    final Case caso2 = new Case(OwnerId = UserInfo.getUserId(),
                                SuppliedEmail = 'aaa1@example.aa',
                                SER_Is_Master_Case__c = true,
                                SER_Send_email_close_master_case__c = true,
                                Status = 'Closed');

    final List<Case> lst_case = new List<Case>();
    lst_case.add(caso2);
    //insert lst_case;

    final Map<Id,Case> map_case_old = new Map<Id,Case>();
    map_case_old.put(caso.Id, caso);

    final Map<Id,Case> map_case_new = new Map<Id,Case>();
    //update lst_case;
    map_case_new.put(caso2.Id, caso2);

    SER_CaseMethodsMasterCase.manageMasterCaseNotifications(lst_case, map_case_new, map_case_old);

    System.debug('ASO___: 1 '+map_case_new);
    System.debug('ASO___: 1 '+map_case_old);
    System.assertEquals (map_case_new,map_case_new,'manageMasterCaseNotificationsTEST');

  }
}