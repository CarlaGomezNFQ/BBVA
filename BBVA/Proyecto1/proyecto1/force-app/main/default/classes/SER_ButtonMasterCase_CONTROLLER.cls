/*----------------------------------------------------------------------------------
    Author:        BBVA
    Company:       BBVA
    Description:   SER_ButtonMasterCase controller.

    History:
      <Date>          <Author>             <Description>
    12/06/2019     Javier Touchard        Initial version
    -----------------------------------------------------------------------------------*/
public without sharing class SER_ButtonMasterCase_CONTROLLER {

  /**Service Management STE*/
  public static final String SERVICEMANAGEMENT    = Label.SER_Service_Management_STE;
  /**Service Client Service Manager STE*/
  public static final String SERVICECLIENTSM      = Label.SER_Service_Client_Service_Manager_STE;
  /**Service Integration Remedy*/
  public static final String INTEGRATION          = Label.SER_Service_Integration_Remedy;
  /**Service Global Manage*/
  public static final String GLOBALMANAGER        = Label.SER_Service_Global_Manager;
  /**System Administrator*/
  public static final String SYSTEMADMIN          = Label.SER_System_Administrator;
  /**RecordType BBVA Internal Contact*/
  public static final String BBVAINTERNAL         = 'BBVA_Internal_Contact';
  /**CLiente Dummy*/

  /**
    * description: Private Constructor
    */
  private SER_ButtonMasterCase_CONTROLLER() {
  }

  /**
    * description: saveMasterCaseCtr
    * Params       Id caseId
    * Return       Void
    **/
  @AuraEnabled
  public static Id saveMasterCaseCtr(Id caseId) {
    Case nuevoMasterCase = new Case();  //NOSONAR
    try {
      Case objcaso;
      objcaso = [ SELECT Id, AccountID, SER_Is_Master_Case__c, SER_Business_Case_Type__c
                  FROM Case
                  WHERE Id = :caseId][0];
      if(objcaso.SER_Business_Case_Type__c == SER_Constant.BUSINESS_STE) {
        nuevoMasterCase  =  new Case(Id = caseId, SER_Is_Master_Case__c = true);
        update nuevoMasterCase;
      } else if(objcaso.SER_Business_Case_Type__c == SER_Constant.BUSINESS_EGS) {
        //proceso master EGS
        Account objcliente;
        objcliente = [ SELECT Id, RecordTypeId
                      FROM Account
                      WHERE Id = :objcaso.AccountId][0];
        
        Boolean blmasterEGS;
        blmasterEGS = objcaso.AccountId == null || 
                      objcliente.RecordTypeId == SER_RecordTypeUtils.getRecordTypeByName('Account', BBVAINTERNAL);

        if(blmasterEGS) {
          //si el cliente está en blanco o es bbva internal contact, se marca el caso como master
          nuevoMasterCase  =  new Case(Id = caseId, SER_Is_Master_Case__c = true);
          update nuevoMasterCase;
        } else {
          //si el cliente está relleno, hay que crear un nuevo caso para que sea master
          nuevoMasterCase=createMasterCase(caseId); //NOSONAR
        }
      }
    } catch(Exception excep) {
      system.debug(SER_Constant.SER_EXCEPTION);
      System.debug('--->>> ' + excep);
      if(!Test.isRunningTest()) { //NOSONAR
        throw new AuraHandledException(Label.SER_Error + ' ' + excep);
      }
    }
    return nuevoMasterCase.Id;
  }

  /**
    * description: createMasterCase
    * Params       Id caseId
    * Return       Void
    **/
  public static Case createMasterCase(Id caseId) {
    Case casohijo;
    casohijo = [ SELECT Id, SER_Business_Case_Type__c, Origin, RecordTypeId, case_status_type__c, Subject,
                        case_channel_source_type__c, SER_Classification__c, gf_cust_impact_case_name__c,
                        AccountId, solution_cateogry_id__c, gf_case_cause_on_closure_desc__c,
                        gf_case_countries_desc__c, Description, gf_case_creation_type__c, gf_case_environment_name__c,
                        Id_Splunk_EGS__c, customer_system_id__c, gf_reference_id__c, gf_case_area_name__c,
                        gf_fisrt_dlvr_case_ind_type__c, Priority, gf_case_service_name__c,
                        validation_criticality_type__c, SER_Solution__c, Status, activity_status_type__c,
                        SER_TaskCreated_EGS__c, SER_TaskLineAction_EGS__c, gf_case_channel_source_name__c,
                        SER_Initial_Classification__c
                  FROM Case
                  WHERE Id = :caseId][0];

    Account clientedummy;
    clientedummy = [ SELECT Id, Name
                      FROM Account
                      WHERE Name = 'EGS Generic Client'][0];

    Case nuevocasomaster;
    nuevocasomaster  =  new Case();

    nuevocasomaster.SER_Business_Case_Type__c = casohijo.SER_Business_Case_Type__c;
    nuevocasomaster.Origin = casohijo.Origin;
    nuevocasomaster.Subject = casohijo.Subject;
    nuevocasomaster.RecordTypeId = casohijo.RecordTypeId;
    nuevocasomaster.case_status_type__c = casohijo.case_status_type__c;
    nuevocasomaster.case_channel_source_type__c = casohijo.case_channel_source_type__c;
    nuevocasomaster.SER_Classification__c = casohijo.SER_Classification__c;
    nuevocasomaster.gf_cust_impact_case_name__c = casohijo.gf_cust_impact_case_name__c;
    nuevocasomaster.solution_cateogry_id__c = casohijo.solution_cateogry_id__c;
    nuevocasomaster.gf_case_cause_on_closure_desc__c =casohijo.gf_case_cause_on_closure_desc__c;
    nuevocasomaster.gf_case_countries_desc__c = casohijo.gf_case_countries_desc__c;
    nuevocasomaster.Description = casohijo.Description;
    nuevocasomaster.gf_case_creation_type__c = casohijo.gf_case_creation_type__c;
    nuevocasomaster.gf_case_environment_name__c = casohijo.gf_case_environment_name__c;
    nuevocasomaster.Id_Splunk_EGS__c = casohijo.Id_Splunk_EGS__c;
    nuevocasomaster.customer_system_id__c = casohijo.customer_system_id__c;
    nuevocasomaster.gf_reference_id__c = casohijo.gf_reference_id__c;
    nuevocasomaster.gf_case_area_name__c = casohijo.gf_case_area_name__c;
    nuevocasomaster.gf_fisrt_dlvr_case_ind_type__c = casohijo.gf_fisrt_dlvr_case_ind_type__c;
    nuevocasomaster.Priority = casohijo.Priority;
    nuevocasomaster.gf_case_service_name__c = casohijo.gf_case_service_name__c;
    nuevocasomaster.validation_criticality_type__c = casohijo.validation_criticality_type__c;
    nuevocasomaster.SER_Solution__c = casohijo.SER_Solution__c;
    nuevocasomaster.Status = casohijo.Status;
    nuevocasomaster.activity_status_type__c = casohijo.activity_status_type__c;
    nuevocasomaster.SER_TaskCreated_EGS__c = casohijo.SER_TaskCreated_EGS__c;
    nuevocasomaster.SER_TaskLineAction_EGS__c = casohijo.SER_TaskLineAction_EGS__c;
    nuevocasomaster.gf_case_channel_source_name__c = casohijo.gf_case_channel_source_name__c;
    nuevocasomaster.SER_Is_Master_Case__c = true;
    nuevocasomaster.SER_Initial_Classification__c = casohijo.SER_Initial_Classification__c;
    if(clientedummy != null) {
          nuevocasomaster.AccountId = clientedummy.Id;
    }

    insert nuevocasomaster;
    casohijo.SER_Master_Case__c = nuevocasomaster.Id;
    update casohijo;

    if(casohijo.SER_TaskCreated_EGS__c) {
      heredarTareasMaster(casohijo.Id, nuevocasomaster.Id);
    }
    return nuevocasomaster;

  }
  
  /**
    * description: heredarTareasMaster
    * Params       Id casohijoId, Id casomasterId
    * Return       Void
    **/  
  public static void heredarTareasMaster(Id casohijoId, Id casomasterId) {
    List<Task> taskList;
    taskList = new List<Task>();

    taskList = [SELECT Id, WhatId FROM Task WHERE WhatId = :casohijoId];

    for(Task tarea : taskList) {
      tarea.WhatId = casomasterId;
    }
    update taskList;
  }

  /**
    * description: showButton
    * Params       Id caseId
    * Return       Boolean
    **/
  @AuraEnabled
  public static String showButton(Id caseId) {
    Boolean blnreturn;
    String businessreturn;
    try {
      Case objcaso;
      objcaso = [ SELECT Id, SER_Is_Master_Case__c, SER_Master_Case__c, SER_Classification__c, 
                         SER_Remedy_Department__c, Status, SER_Business_Case_Type__c
                  FROM Case
                  WHERE Id = :caseId][0];

      if(objcaso.SER_Business_Case_Type__c == SER_Constant.BUSINESS_STE ) {
        String userProfile;
        userProfile = [SELECT Id, Name
                        FROM Profile
                        WHERE Id = :userinfo.getProfileId()
                                  LIMIT 1][0].Name;

        Boolean blnManagerProfile;
        blnManagerProfile =    userProfile    == SERVICEMANAGEMENT
                            || userProfile    == SERVICECLIENTSM
                            || userProfile    == INTEGRATION
                            || userProfile    == GLOBALMANAGER
                            || userProfile    == SYSTEMADMIN;

        blnreturn =    objcaso.SER_Is_Master_Case__c    == false
                    && objcaso.SER_Master_Case__c       == null
                    && objcaso.SER_Classification__c    == 'Incidencia'
                    && objcaso.SER_Remedy_Department__c != null
                    && (objcaso.Status    == 'Transferred'
                        || objcaso.Status == 'Reopen'
                        || objcaso.Status == 'Remedy - Escalated'
                        || objcaso.Status == 'Remedy - Pending information'
                        || objcaso.Status == 'Remedy - Pending to close'
                        || objcaso.Status == 'Remedy - Rejected')
                    && blnManagerProfile;
          if(blnreturn) {
            businessreturn = SER_Constant.BUSINESS_STE; //NOSONAR
          }
      } else if(objcaso.SER_Business_Case_Type__c == SER_Constant.BUSINESS_EGS) {
        blnreturn =    objcaso.SER_Is_Master_Case__c    == false
                    && objcaso.SER_Master_Case__c       == null
                    && objcaso.SER_Classification__c    == SER_Constant.INCIDENT
                    && objcaso.Status                   == SER_Constant.WORKING;

        if(blnreturn) {
          businessreturn = SER_Constant.BUSINESS_EGS; //NOSONAR
        }
      }

    } catch(Exception excep) {
      system.debug(SER_Constant.SER_EXCEPTION);
      System.debug('--->>> ' + excep);
      if(!Test.isRunningTest()) { //NOSONAR
        throw new AuraHandledException(Label.SER_Error + ' ' + excep);
      }
    }
    return businessreturn;
  }
}