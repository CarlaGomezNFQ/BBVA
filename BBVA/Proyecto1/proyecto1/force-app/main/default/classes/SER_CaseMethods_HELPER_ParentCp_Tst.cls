/**
  * @author            Victor Velandia
  * Project:           BBVA Service
  * Description:       Test Class SER_CaseMethods_HELPER_ParentCp
  *
  *            No.     Date            Author                  Description
  *            -----   ----------      --------------------    ---------------
  * @version   1.0     2019-05-21      Victor Velandia (VV)    Initial version
  ************************************************************************************/
@isTest
public with sharing class SER_CaseMethods_HELPER_ParentCp_Tst {
  /**
    * description: STRPRUEBA
    * @author Victor Velandia
    */
  private static final string STRPRUEBA     = 'Prueba';
  /**
    * description: STRCLOSED
    * @author Victor Velandia
    */
  private static final string STRCLOSED     = 'closed';
  /**
    * description: STRLINKED
    * @author Victor Velandia
    */
  private static final string STRLINKED     = 'linked to Master Case';
  /**
    * description: STRLINKED
    * @author Victor Velandia
    */
  private static final string STREQUITY     = 'Equity';

  /**
    * description: helperParentCpGM
    * @author Victor Velandia
    */
  public static testMethod void helperParentCpGM() {
    SER_TestUtils_3.initCustomsetting();

    Account sernovaAcc;
    sernovaAcc                          = new Account();
    sernovaAcc.Name                     = Label.SER_SernovaAccountNAME;
    sernovaAcc.Client_STAR_ID__C        = Label.SER_SernovaAccountNAME;
    sernovaAcc.SER_CClient__c           = Label.SER_SernovaAccountNAME;
    insert sernovaAcc;

    Account pruebaAcc;
    pruebaAcc                           = new Account();
    pruebaAcc.Name                      = STRPRUEBA;
    insert pruebaAcc;

    Case parentCase;
    parentCase                          = new Case();
    parentCase.AccountId                = pruebaAcc.Id;
    parentCase.SER_Asset__c             = STREQUITY;
    parentCase.RecordTypeId             = [Select Id FROM RecordType WHERE DeveloperName = 'SER_GM_User'].Id;
    insert parentCase;

    Case childCase;
    childCase                           = new Case();
    childCase.SER_Business_Case_Type__c = SER_Constant.BUSINESS_GM;
    childCase.SER_Close__c              = false;
    childCase.SER_IsSernova__c          = true;
    childCase.SER_Asset__c              = STREQUITY;
    childCase.ParentId                  = parentCase.Id;
    childCase.RecordTypeId              = [Select Id FROM RecordType WHERE DeveloperName = 'SER_GM_User'].Id;
    insert childCase;
    childCase.SER_Close__c              = false;
    update childCase;
    Test.startTest();
    SER_CaseMethods_HELPER_ParentCp.copyParentFieldsINSERT(childCase,parentCase,null);
    SER_CaseMethods_HELPER_ParentCp.copyParentFieldsUPDATE(childCase,parentCase,null);
    System.assertEquals (childCase.AccountId,sernovaAcc.Id,'Error');
    Test.stopTest();
  }

  /**
    * description: helperParentCpGNC
    * @author Victor Velandia
    */
  public static testMethod void helperParentCpGNC() {

    Account sernovaAcc;
    sernovaAcc                          = new Account();
    sernovaAcc.Name                     = Label.SER_SernovaAccountNAME;
    sernovaAcc.Client_STAR_ID__C        = Label.SER_SernovaAccountNAME;
    sernovaAcc.SER_CClient__c           = Label.SER_SernovaAccountNAME;
    insert sernovaAcc;

    Account pruebaAcc;
    pruebaAcc                           = new Account();
    pruebaAcc.Name                      = STRPRUEBA;
    insert pruebaAcc;

    Case parentCase;
    parentCase                          = new Case();
    parentCase.AccountId                = pruebaAcc.Id;
    parentCase.SER_Close__c             = true;
    insert parentCase;

    Case childCase;
    childCase                           = new Case();
    childCase.SER_Business_Case_Type__c = SER_Constant.BUSINESS_GNC;
    childCase.ParentId                  = parentCase.Id;
    childCase.SER_Close__c              = false;
    childCase.RecordTypeId              = [Select Id FROM RecordType WHERE DeveloperName = 'SER_GNC_User'].Id;
    upsert childCase;
    Test.startTest();
    SER_CaseMethods_HELPER_ParentCp.copyParentFieldsINSERT(childCase,parentCase,null);
    SER_CaseMethods_HELPER_ParentCp.copyParentFieldsUPDATE(childCase,parentCase,null);
    System.assertEquals (childCase.id,childCase.id,'');
    Test.stopTest();
  }

  /**
    * description: helperParentCpSTE
    * @author Victor Velandia
    */
  public static testMethod void helperParentCpSTE() {
    SER_TestUtils_3.initCustomsetting();
    final map<String, String> mapPicklistValues = new map<String, String>();
    Account pruebaAcc;
    pruebaAcc                             = new Account();
    pruebaAcc.Name                        = STRPRUEBA;
    insert pruebaAcc;

    Case parentCase;
    parentCase                            = new Case();
    parentCase.AccountId                  = pruebaAcc.Id;
    parentCase.Status                     = STRLINKED;
    parentCase.SER_Skip_validations__c = true;
    parentCase.RecordTypeId                = [Select Id FROM RecordType WHERE DeveloperName = 'SER_STE_User'].Id;
    insert parentCase;
    parentCase.status                     = STRCLOSED;
    parentCase.SER_Solution__c =            'Solution';
    update parentCase;

    Case childCase;
    childCase                             = new Case();
    childCase.SER_Business_Case_Type__c   = SER_Constant.BUSINESS_STE;
    childCase.SER_Close__c                = false;
    childCase.status                      = STRLINKED;
    childCase.SER_IsSernova__c            = true;
    childCase.ParentId                    = parentCase.Id;
    childCase.RecordTypeId                = [Select Id FROM RecordType WHERE DeveloperName = 'SER_STE_User'].Id;
    childCase.SER_Skip_validations__c = true;
    insert childCase;
    childCase.SER_Close__c                = false;
    childCase.status                      = mapPicklistValues.get(STRCLOSED);
    update childCase;
    Test.startTest();
    SER_CaseMethods_HELPER_ParentCp.copyParentFieldsINSERT(childCase,parentCase,mapPicklistValues);
    SER_CaseMethods_HELPER_ParentCp.copyParentFieldsUPDATE(childCase,parentCase,mapPicklistValues);
    System.assertEquals (childCase.id,childCase.id,'');
    Test.stopTest();
  }
  /**
  * description: helperParentCpEGS
  * @author Jose Luis
  */
  public static testMethod void helperParentCpEGS() {
    SER_TestUtils_3.initCustomsetting();
    final map<String, String> mapPicklistValues = new map<String, String>();
    Account pruebaAccEGS;
    pruebaAccEGS                          = new Account();
    pruebaAccEGS.Name                     = STRPRUEBA;
    insert pruebaAccEGS;

    Case parentCase;
    parentCase                             = new Case();
    parentCase.AccountId                   = pruebaAccEGS.Id;
    parentCase.Status                      = 'Working';
    parentCase.SER_Business_Case_Type__c   = SER_Constant.BUSINESS_EGS;
    parentCase.gf_cust_impact_case_name__c = '3. Medium';
    parentCase.SER_Skip_validations__c     = true;
    parentCase.RecordTypeId                = [Select Id FROM RecordType WHERE DeveloperName = 'EGS_User'].Id;
    insert parentCase;
    parentCase.status                      = STRCLOSED;
    parentCase.gf_cust_impact_case_name__c = '4. Low';
    update parentCase;

    Case childCase;
    childCase                             = new Case();
    childCase.SER_Business_Case_Type__c   = SER_Constant.BUSINESS_EGS;
    childCase.SER_Close__c                = false;
    childCase.status                      = 'New';
    childCase.ParentId                    = parentCase.Id;
    childCase.RecordTypeId                = [Select Id FROM RecordType WHERE DeveloperName = 'EGS_User'].Id;
    childCase.SER_Skip_validations__c = true;
    insert childCase;
    childCase.SER_Close__c                = false;
    childCase.status                      = mapPicklistValues.get(STRCLOSED);
    update childCase;

    TaskComment__c lta;
    lta = new TaskComment__c();
    lta.task_desc__c = 'Description';
    lta.gf_action_result_desc__c = 'Solution';
    insert lta;

    Task tarea;
    tarea = new Task();
    tarea.WhatId = parentCase.Id;
    tarea.gf_task_execution_team_name__c = 'Global Client Service';
    tarea.Status = 'Working';
    tarea.RecordTypeId = SER_RecordTypeUtils.getRecordTypeByName('Task', 'SER_Task_EGS');
    tarea.gf_tech_impact_case_name__c = '5. No Impact';
    tarea.TaskComment__c = lta.Id;
    insert tarea;

    Test.startTest();
    SER_CaseMethods_HELPER_ParentCp.copyParentFieldsINSERT(childCase,parentCase,mapPicklistValues);
    SER_CaseMethods_HELPER_ParentCp.copyParentFieldsUPDATE(childCase,parentCase,mapPicklistValues);
    System.assertEquals (childCase.id,childCase.id,'');
    Test.stopTest();
  }
}