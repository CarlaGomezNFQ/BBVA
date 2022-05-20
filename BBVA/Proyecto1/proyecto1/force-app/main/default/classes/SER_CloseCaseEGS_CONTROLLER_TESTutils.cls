/*---------------------------------------------------------------------------------------------
    Company:       BBVA
    Description:   Class to test SER_CloseCaseEGS_CONTROLLERutils class.
----------------------------------------------------------------------------------------------*/
public with sharing class  SER_CloseCaseEGS_CONTROLLER_TESTutils {

  /*---------------------------------------------------------------------------------------
      Company:       BBVA
      Description:   Constructor privado.
  ---------------------------------------------------------------------------------------*/
  private SER_CloseCaseEGS_CONTROLLER_TESTutils() {}

  /*-----------------------------------------------------------------------
    Description: createCase.
  ------------------------------------------------------------------------*/
  public static Case createCase(Boolean solution, Boolean masterCase, Boolean children) {
    Account cliente;
    cliente = new Account();
    cliente.Name = 'Cliente Test';
    insert cliente;

    Case casoHijo;

    Case caso;
    caso = new Case();
    caso.SER_Classification__c = 'Incident';
    caso.case_channel_source_type__c = 'H2H';
    caso.gf_case_channel_source_name__c = 'Informes';
    caso.Description = 'Description';
    caso.gf_cust_impact_case_name__c = '4. Low';
    caso.gf_case_cause_on_closure_desc__c = 'Cliente';
    caso.gf_case_area_name__c = 'Client';
    caso.validation_criticality_type__c = '4. Low';
    caso.AccountId = cliente.Id;
    caso.gf_case_creation_type__c = 'Reactive';
    caso.RecordTypeId = SER_RecordTypeUtils.getRecordTypeByName('Case', 'EGS_User');
    caso.gf_case_countries_desc__c = 'ES';
    caso.Subject = 'SubjectTest';
    caso.SER_Business_Case_Type__c = SER_Constant.BUSINESS_EGS;
    if(solution) {
      caso.SER_Solution__c = 'Solution';
    }
    if(masterCase) {
      caso.SER_Is_Master_Case__c = true;
    }
    insert caso;

    if(children) {
      casoHijo = createCase(false, false, false);
      casoHijo.SER_Master_Case__c = caso.Id;
      update casoHijo;
    }

    return children ? casoHijo : caso;
  }

  /*-----------------------------------------------------------------------
    Description: createCaseQuery.
  ------------------------------------------------------------------------*/
  public static Id createCaseQuery(Boolean solution) {
    Account cliente;
    cliente = new Account();
    cliente.Name = 'Cliente Test';
    insert cliente;

    Case caso;
    caso = new Case();
    caso.SER_Classification__c = 'Query';
    caso.case_channel_source_type__c = 'H2H';
    caso.gf_case_channel_source_name__c = 'Informes';
    caso.Description = 'Description';
    caso.AccountId = cliente.Id;
    caso.gf_case_creation_type__c = 'Reactive';
    caso.RecordTypeId = SER_RecordTypeUtils.getRecordTypeByName('Case', 'EGS_User');
    caso.gf_case_countries_desc__c = 'ES';
    caso.Subject = 'SubjectTest2';
    if(solution) {
      caso.SER_Solution__c = 'Solution';
    }
    insert caso;
    return caso.Id;
  }

  /*-----------------------------------------------------------------------
    Description: createTask.
  ------------------------------------------------------------------------*/
  public static Void createTask(Id caseId, Boolean whitRemedy, Boolean actionLine) {
    TaskComment__c lta;
    lta = new TaskComment__c();
    lta.task_desc__c = 'Description';
    insert lta;

    Task tarea;
    tarea = new Task();
    tarea.WhatId = caseId;
    tarea.gf_task_execution_team_name__c = 'Global Client Service';
    tarea.Status = 'Working';
    tarea.RecordTypeId = SER_RecordTypeUtils.getRecordTypeByName('Task', 'SER_Task_EGS');
    tarea.TaskComment__c = lta.Id;
    if(whitRemedy) {
      lta.gf_action_result_desc__c = 'Solution';
      update lta;
      tarea.incidence_id__c = '00000001';
      tarea.Priority = 'Normal';
      tarea.departament_name__c = 'ANS SSTT';
    }
    if(actionLine) {
      tarea.gf_spec_task_op_case_ind_type__c = true;
    }
    insert tarea;
  }

  /*-----------------------------------------------------------------------
    Description: createEmailMessage.
  ------------------------------------------------------------------------*/
  public static EmailMessage createEmail(Id caseId) {
    
    final EmailMessage emailMes = new EmailMessage();
    emailMes.TextBody = 'Test Body ref:_1234ABCd:ref';
    emailMes.HtmlBody = 'Test Body ref:_1234ABCd:ref';
    emailMes.Subject = 'test subject';
    emailMes.ToAddress = 'testemailaddress01@example.com';
    emailMes.CcAddress = 'testemailaddress01@example.com';
    emailMes.ParentId = caseId;
    insert emailMes;
    return emailMes;
  }
}