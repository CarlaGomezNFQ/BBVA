/**********************************************************************************
* @author       Accenture
* @date         12/01/2016
* @description  Clase útil con la lógia para la Task y Events
* @Revision
    2017/10/26 Se deja de utilizar customActivity (Activity__c) y se comentan las líneas de código que ya no aplican
**********************************************************************************/
public with sharing class ActivitiesUtils {
  /* Constante 'SER_Task_EGS' */
  public final static String EGS_RECORDTYPE = 'SER_Task_EGS';
  /* Constante 'SOPORTE SWIFT HOST-TO-HOST' */
  public final static String SOPORTE_SWIFT = 'SOPORTE SWIFT HOST-TO-HOST';
  /* Constante 'Call' */
  public final static String CALL = 'Call';
  /**
  * description: MAPTECHIMBYSEV for TechImpact by Severety
  * @author Victor Velandia
  */
  public final static map<Id, String> MAPTECHIMBYSEV = new map<Id, String>();

  /**
  * description: MAP_TECH_IMPACT for value TechImpact
  * @author Victor Velandia
  */
  private static final Map<string,integer> MAP_TECH_IMPACT;
  static {
    MAP_TECH_IMPACT = new Map<string,integer>{
      '1. Critical'   => 1,
      '2. High'       => 2,
      '3. Medium'     => 3,
      '4. Low'        => 4,
      '5. No Impact'  => 5
    };
  }

  /*-----------------------------------------------------------------------
     Construtor privado
  ------------------------------------------------------------------------*/
  private ActivitiesUtils() {}

  //-- PUBLIC STATIC METHODS
  /*-----------------------------------------------------------------------
    Author:         Juan Carlos Terrón
    Company:        Accenture
    Description:    Fills ContactTriggerHandler map_EmptyEmailContacts static map in order
                    to update Contact email field to match
                    the related Case supplied email.

    IN:        Trigger.newMap(Contact)
    OUT:       Void

    History:
    <Date>          <Author>              <Change Description>
    27/02/2017      Juan Carlos Terrón    Initial Version
  -------------------------------------------------------------------------*/
  public static void check_EmptyContactEmail(Map<Id,Contact> newMap) {
    System.debug('JCT - Entering ActivitiesUtils.fill_ContactEmail()');
    SER_TriggerHelper.set_MetodFired('check_EmptyContactEmail', true);
    Set<Id> set_ContactId = new Set<Id>();
    List<Contact> list_Contacts_T = new List<Contact>();
    for(Contact contacto : newMap.values()) {
      if(String.isBlank(String.valueOf(contacto.Email))) {
        ContactTriggerHandler.map_EmptyEmailContacts.put(contacto.Id, contacto);
      }
    }
    System.debug('JCT - ContactTriggerHandler.map_EmptyEmailContacts : '+ContactTriggerHandler.map_EmptyEmailContacts);
  }

  /*--------------------------------------------------------------------------
    Author:        Brian Capilla
    Company:       Accenture Cloud First
    Description:   Metodo para rellenar el campos SAL_ultima_llamada__c del Account asociado.

    IN:        List<Task> newList
    OUT:       Void

    History:
    <Date>            <Author>            <Change Description>
    29/09/2017      Brian Capilla      Initial Version
  ----------------------------------------------------------------------------*/
  public static void setTimeAccount(List<Task> newList) {
    final String accountPrefix = Utilities.getObjectPrefix('Account');
    final Map<String, Task> mapAccId = new Map<String, Task>();
    final Map<String, Task> mapContId = new Map<String, Task>();
    for(Task ts : newList) {
      if(ts.type == CALL) {
        System.debug(ts.whatid);
        if(ts.whatid != null && String.valueOf(ts.whatid).startsWith(accountPrefix)) {
          mapAccId.put(ts.whatid,ts);
        } else {
          mapContId.put(ts.whoId,ts);
        }
      }
    }
    if(!mapContId.isEmpty()) {
      for(Contact con : [select id, AccountId from Contact where id in :mapContId.keySet()]) {
        if(con.AccountId != null) {
          mapAccId.put(con.AccountId, mapContId.get(con.id));
        }
      }
    }
    final Set<Account> lstToUppd = new Set<Account>();
    if(!mapAccId.isEmpty()) {
      final Set<Account> lstAcc = new Set<Account>();
      lstAcc.addAll([select id, SER_Service_Client__c from Account where id in :mapAccId.keySet()]);
      final List<String> lstAccBus = new List<String>();
      for(Account ac : lstAcc) {
        if(ac.SER_Service_Client__c != null) {
          lstAccBus.add(ac.SER_Service_Client__c);
        }
        lstAccBus.add(ac.id);
      }
      lstAcc.addAll([select id, SER_Service_Client__c from Account where SER_Service_Client__c in :lstAccBus]);
      if(!lstAcc.isEmpty()) {
        for(Account co : lstAcc) {
          if(co.SER_Service_Client__c != null) {
            //Se comenta por que los usuarios Sales ya no tienen acceso a las cuentas de service
            //lstToUppd.add(new Account(id = co.SER_Service_Client__c, SAL_ultima_llamada__c = mapAccId.containsKey(co.id)?mapAccId.get(co.id).CreatedDate:mapAccId.values().get(0).CreatedDate));
            lstToUppd.add(new Account(id = co.id, SAL_ultima_llamada__c = mapAccId.containsKey(co.id)?mapAccId.get(co.id).CreatedDate:mapAccId.values().get(0).CreatedDate));
          }
        }
      }
    }
    if(!lstToUppd.isEmpty()) {
      System.debug('Actualizando Cuentas');
      update new List<Account>(lstToUppd);
    }
  }

  /*--------------------------------------------------------------------------
    Author:        Javier Touchard
    Company:       BBVA
    Description:   Check the case field SER_TaskCreated_EGS__c if case have task.

    IN:        List<Task> newList
    IN:        Boolean isInsert
    OUT:       Void

    History:
    <Date>            <Author>            <Change Description>
    12/12/2019        Javier Touchard     Initial Version
  ----------------------------------------------------------------------------*/
  public static void countCaseTask(final List<Task> tasks) {
    List<Id> caseIdsList;
    caseIdsList = new List<Id>();
    Map<Case, List<Task>> caseTaskMap;
    caseTaskMap = new Map<Case, List<Task>>();
    List<Case> caseToUpdate;
    caseToUpdate = new List<Case>();
    for(Task tarea : tasks) {
      Boolean count;
      count = false;
      if(tarea.WhatId != null) {
        count = tarea.RecordTypeId == SER_RecordTypeUtils.getRecordTypeByName(SER_Constant.TASK, EGS_RECORDTYPE) && String.valueOf(tarea.WhatId).startsWithIgnoreCase(SER_Constant.CASE_500);
      }
      if(count) {
        caseIdsList.add(tarea.WhatId);
      }
    }
    if(caseIdsList.isEmpty() == false) {
      fillCaseMap(caseIdsList, caseTaskMap);
    }
    if(caseTaskMap.isEmpty() == false) {
      for(Case caso : caseTaskMap.keySet()) {
        Boolean hasTask;
        hasTask = caseTaskMap.get(caso).isEmpty() == false && caso.SER_TaskCreated_EGS__c != true;
        Boolean hasNotTask;
        hasNotTask = caseTaskMap.get(caso).isEmpty() && caso.SER_TaskCreated_EGS__c == true; //NOSONAR

        if(MAP_TECH_IMPACT.get(MAPTECHIMBYSEV.get(caso.Id)) < MAP_TECH_IMPACT.get(caso.gf_cust_impact_case_name__c)) {
          caso.validation_criticality_type__c = MAPTECHIMBYSEV.get(caso.Id);
        }
        if(hasTask) {
          caso.SER_TaskCreated_EGS__c = true;
        } else if(hasNotTask) {
          caso.SER_TaskCreated_EGS__c = false;
        }
        caseToUpdate.add(caso);
      }
    }
    if(caseToUpdate.isEmpty() == false) {
      update caseToUpdate;
    }
  }

  /*--------------------------------------------------------------------------
    Author:        Javier Touchard
    Company:       BBVA
    Description:   fill caseTaskMap.

    IN:        List<Id> caseIdsList
    IN:        Map<Case, List<Task>> caseTaskMap
    OUT:       Void

    History:
    <Date>            <Author>            <Change Description>
    09/01/2020        Javier Touchard     Initial Version
  ----------------------------------------------------------------------------*/
  private static void fillCaseMap(List<Id> caseIdsList, Map<Case, List<Task>> caseTaskMap) {
      List<Task> taskList;
      taskList = new List<Task>();

//      MAPTECHIMBYSEV = new map<Id, String>();

      taskList = [SELECT Id, WhatId, gf_tech_impact_case_name__c, Status FROM Task WHERE WhatId IN :caseIdsList];
      for(Case caso : [SELECT Id, SER_TaskCreated_EGS__c, gf_cust_impact_case_name__c, validation_criticality_type__c FROM Case WHERE Id IN :caseIdsList]) {
        caseTaskMap.put(caso, new List<Task>());
        /**
         * BEGIN
         * Description: Validation for TechImpact and update value in Severety
         * @autor: Victor Velandia
         * Date: 05/03/2020
         */
        string strPriorityTech;
        strPriorityTech = '';
        for(Task tarea : taskList) {
          if(String.isBlank(strPriorityTech)) {
            strPriorityTech = tarea.gf_tech_impact_case_name__c;
          } else if(MAP_TECH_IMPACT.get(tarea.gf_tech_impact_case_name__c) < MAP_TECH_IMPACT.get(strPriorityTech)) {
            strPriorityTech = tarea.gf_tech_impact_case_name__c;
          }
          Boolean process;
          process = tarea.WhatId == caso.Id && tarea.Status != Label.SER_EGS_StatusCompleted_lbl;
          if(process) {
            caseTaskMap.get(caso).add(tarea);
          }
        }
        MAPTECHIMBYSEV.put(caso.Id, strPriorityTech);
        /**
         * END
         */
      }
  }
  /*--------------------------------------------------------------------------
    Author:        Cintia Carmona
    Company:       Accenture
    Description:   Update substatus Case.

    IN:        List<Task> newList
    OUT:       Void

    History:
    <Date>            <Author>            <Change Description>
    19/02/2020        Cintia Carmona      Initial Version
  ----------------------------------------------------------------------------*/
	public static void changeStatusWorking(final List<Task> tasks) {
    final List<Id> caseIdsList = new List<Id>();
    final Map<Case, List<Task>> caseTaskMap = new Map<Case, List<Task>>();
    List<Case> caseToUpdate = new List<Case>();
    for(Task tarea : tasks) {
      Boolean count = false;
      if(tarea.WhatId != null) {
        count = tarea.RecordTypeId == SER_RecordTypeUtils.getRecordTypeByName(SER_Constant.TASK, EGS_RECORDTYPE) 
                && String.valueOf(tarea.WhatId).startsWithIgnoreCase(SER_Constant.CASE_500)
                && tarea.TaskSubtype != SER_Constant.EMAIL;
      }
      if(count) {
        caseIdsList.add(tarea.WhatId);
      }
    }
    if(caseIdsList.isEmpty() == false) {
      List<Task> taskList = new List<Task>();
      taskList = [SELECT Id, WhatId, Status, gf_task_execution_team_name__c, TaskSubtype FROM Task WHERE WhatId IN :caseIdsList];
      for(Case caso : [SELECT Id, Status, activity_status_type__c FROM Case WHERE Id IN :caseIdsList AND Status = 'Working' AND activity_status_type__c != 'Open Tasks']) {
        caseTaskMap.put(caso, new List<Task>());
        for(Task tarea : taskList) {
          Boolean process;
          process = tarea.WhatId == caso.Id 
                 && tarea.TaskSubtype != SER_Constant.EMAIL;
          if(process) {
            caseTaskMap.get(caso).add(tarea);
          }
        }
      }
    }

    caseToUpdate = reviewStatus(caseTaskMap);
    
    if(caseToUpdate.isEmpty() == false) {
      update caseToUpdate;
    }
  }
/*--------------------------------------------------------------------------
    Author:        Jose Luis
    Company:       Accenture
    Description:   Update AuxLastModify

    IN:        List<Task> newList
    OUT:       Void

    History:
    <Date>            <Author>            <Change Description>
    17/06/2020        Jose Luis      Initial Version
  ----------------------------------------------------------------------------*/
	public static void updateAuxLastModify(final List<Task> tasks) {
    final datetime myDateTime = datetime.now();
    String fechaLM;
    final Integer FORMAT = 10;
    final Integer month = myDateTime.month();
    final Integer day = myDateTime.day();
    final Integer hour = myDateTime.hour();
    final Integer minutes = myDateTime.minute();
    final Integer second = myDateTime.second();

    fechaLM = myDateTime.year()+'-';

    if (month<FORMAT) {
      fechaLM = fechaLM+'0'+month+'-';
    } else {
      fechaLM = fechaLM+month+'-';
    }
    if (day<FORMAT) {
      fechaLM = fechaLM+'0'+day+' ';
    } else {
      fechaLM = fechaLM+day+' ';
    }
    if (hour<FORMAT) {
      fechaLM = fechaLM+'0'+hour+':';
    } else {
      fechaLM = fechaLM+hour+':';
    }
    if (minutes<FORMAT) {
      fechaLM = fechaLM+'0'+minutes+':';
    } else {
      fechaLM = fechaLM+minutes+':';
    }
    if (second<FORMAT) {
      fechaLM = fechaLM+'0'+second;
    } else {
      fechaLM = fechaLM+second;
    }

    for(Task tarea : tasks) {
      tarea.AuxLastModDate__c = fechaLM;
    }
    
  }
  /*--------------------------------------------------------------------------
    Author:        Cintia Carmona
    Company:       Accenture
    Description:   Update substatus Case.

    IN:        Map<Case, List<Task>>
    OUT:       List<Task>

    History:
    <Date>            <Author>            <Change Description>
    13/03/2020        Cintia Carmona      Initial Version
  ----------------------------------------------------------------------------*/
  public static List<Case> reviewStatus(final Map<Case, List<Task>> caseTaskMap) {

    List<Case> caseToUpdate;
    caseToUpdate = new List<Case>();

    if(caseTaskMap.isEmpty() == false) {
      for(Case caso : caseTaskMap.keySet()) {
        if (caso.Status != SER_Constant.RESOLVED) {
          final List<Task> taskList = caseTaskMap.get(caso);
          if(taskList.isEmpty() == false) {
            Boolean caseWorking = false;
            for(Task tarea : taskList) {
              final boolean auxElseIf = tarea.status !=  Label.SER_EGS_StatusRemedy_Escalated_lbl
                        && tarea.gf_task_execution_team_name__c ==  Label.SER_EGS_TeamResGlobalClientService_lbl; 
              if(tarea.status == Label.SER_EGS_StatusCompleted_lbl) {
                caseWorking = true;
              } else if(auxElseIf) {
                caseWorking = true;
              }
            }
            if(caseWorking) {
              caso.activity_status_type__c = Label.SER_EGS_StatusWorking_lbl;
              caseToUpdate.add(caso);
            } else {
              caso.activity_status_type__c = Label.SER_EGS_StatusPendingIT_lbl;
              caseToUpdate.add(caso);
            }
          }
        }
      }
    }
    return caseToUpdate;
  }
  /*--------------------------------------------------------------------------
    Author:        Cintia Carmona
    Company:       Accenture
    Description:   Check data to send alert email.

    IN:        List<Task> newList
    OUT:       Void

    History:
    <Date>            <Author>            <Change Description>
    05/03/2020        Cintia Carmona      Initial Version
  ----------------------------------------------------------------------------*/
  public static void criticalIssueEGS(final List<Task> tasks) {

    set<Id> idCasos;
    idCasos = new set<Id>();
    Map<Id,Case> mapaCasos = new Map<Id,Case>(); //NOSONAR
    List<Case> casos = new List<Case>();
    Boolean count = false;

    for(Task tarea :tasks) {
      if(tarea.WhatId != null) {
        count = tarea.RecordTypeId == SER_RecordTypeUtils.getRecordTypeByName(SER_Constant.TASK, EGS_RECORDTYPE)
                && String.valueOf(tarea.WhatId).startsWithIgnoreCase(SER_Constant.CASE_500)
                && tarea.SER_Critical_Issue_EGS__c;
      }
      if(count) {
        idCasos.add(tarea.WhatId);
      }
    }

    if(!idCasos.isEmpty()) {
      casos = [SELECT Id, case_channel_source_type__c, gf_case_channel_source_name__c, SER_Classification__c FROM Case WHERE Id IN :idCasos];
    }

    if(!casos.isEmpty()) {

      for(Case caso:casos) {
        mapaCasos.put(caso.Id, caso);
      }
      reviewCritical(mapaCasos, tasks);
    }
  }

  /*--------------------------------------------------------------------------
    Author:        Cintia Carmona
    Company:       Accenture
    Description:   Check data to send alert email.

    IN:        Map<Id,Case>, List<Task> 
    OUT:       Void

    History:
    <Date>            <Author>            <Change Description>
    05/03/2020        Cintia Carmona      Initial Version
  ----------------------------------------------------------------------------*/
  public static void reviewCritical(final Map<Id,Case> mapaCasos, final List<Task> tasks) {

    for(Task tarea:tasks) {
      final Case casoAct = mapaCasos.get(tarea.WhatId);

      final datetime myDateTime = datetime.now();
      final integer userHour = myDateTime.hour();
      final integer userMinute = myDateTime.minute();

      final date selectedDate = date.today();
      final date startDate = date.newInstance(1900, 1, 7);
      final integer dayOfWeek = Math.mod(startDate.daysBetween(selectedDate) , 7);

      final boolean taskCritical =  tarea.SER_Critical_Issue_EGS__c && 
                                    !tarea.Send_Email_Alert__c &&
                                    casoAct.case_channel_source_type__c == Label.SER_Business_Case_Type_GNC &&
                                    casoAct.SER_Classification__c == label.SER_EGS_Incident_lbl &&
                                    ((dayOfWeek > 0 && dayOfWeek < 5 && ((userHour >= 0 && userHour < 8 ) || userHour > 18 || (userHour == 18 && userMinute >= 30))) ||
                                     (dayOfWeek == 5 && ((userHour >= 0 && userHour < 8 ) || userHour > 15 || (userHour == 15 && userMinute >= 30))) ||
                                     (dayOfWeek == 6 && userHour >= 0 && userHour < 2 ) ||
                                     (dayOfWeek == 0 && userHour >= 23));      
      final boolean taskCriticalElse =  tarea.SER_Critical_Issue_EGS__c && 
                                        !tarea.Send_Email_Alert__c &&
                                        casoAct.SER_Classification__c == label.SER_EGS_Incident_lbl &&
                                        ((dayOfWeek > 0 && dayOfWeek < 6 && userHour >= 0 && userHour < 8) ||
                                        (dayOfWeek == 6 && userHour >= 0 && userHour < 2) ||
                                        (dayOfWeek == 0 && userHour >= 23));
      if(taskCritical) {
            tarea.Email_Alert_Team__c = Label.SER_Business_Case_Type_GNC;
            tarea.Send_Email_Alert__c = true;
      } else if(taskCriticalElse) {
            if(casoAct.gf_case_channel_source_name__c == label.SER_EGS_Conectividad_lbl &&
               tarea.departament_name__c == SOPORTE_SWIFT) {
              //tratamiento Swift
              tarea.Email_Alert_Team__c = label.SER_EGS_Soporte_Swift_lbl;
              tarea.Send_Email_Alert__c = true;
            } else {
              //tratamiento otros
              tarea.Email_Alert_Team__c = Label.SER_EGS_TeamResGlobalDirectChannelsGMM_lbl;
              tarea.Send_Email_Alert__c = true;
            }
      }
    }
  }

  /**
  * VASS Latam
  * @author            Victor Velandia
  * Project:           BBVA Service EGS
  * Description:       Method Tech impact
  *
  *            No.     Date            Author                  Description
  *            -----   ----------      --------------------    ---------------
  * @version   1.0     2020-03-02      Victor Velandia (VV)    Method UpdateTechImpact
  * @version   2.0     2020-06-22      Cintia Carmona          Quitamos la validación del TechImpact y añadimos la modificación de Severity
  ************************************************************************************/
  public static void updateTechImpact (final List<Task> tareas) {

    List<Id> caseIdsList;
    caseIdsList = new List<Id>();
    Map<Case, List<Task>> caseTaskMap;
    caseTaskMap = new Map<Case, List<Task>>();
    List<Case> caseToUpdate;
    caseToUpdate = new List<Case>();
    
    for(Task tarea : tareas) {
      Boolean count;
      count = false;
      if(tarea.WhatId != null) {
        count = tarea.RecordTypeId == SER_RecordTypeUtils.getRecordTypeByName(SER_Constant.TASK, EGS_RECORDTYPE) 
             && String.valueOf(tarea.WhatId).startsWithIgnoreCase(SER_Constant.CASE_500);
      }
      if(count) {
        caseIdsList.add(tarea.WhatId);
      }
    }

    if(caseIdsList.isEmpty() == false) {
      fillCaseMap(caseIdsList, caseTaskMap);
    }

    if(caseTaskMap.isEmpty() == false) {
      for(Case caso : caseTaskMap.keySet()) {
        if(MAP_TECH_IMPACT.get(MAPTECHIMBYSEV.get(caso.Id)) < MAP_TECH_IMPACT.get(caso.gf_cust_impact_case_name__c)) {
          caso.validation_criticality_type__c = MAPTECHIMBYSEV.get(caso.Id);
          caseToUpdate.add(caso);
        }
      }
    }

    if(caseToUpdate.isEmpty() == false) {
      update caseToUpdate;
    }
  }

}