/*---------------------------------------------------------------------------------------------
    Company:       BBVA
    Description:   This class contains methods related to EGS Tasks.

    History:
    <Date>          <Author>                <Description>
    20/07/2020      Javier Touchard         Initial Version.
----------------------------------------------------------------------------------------------*/
public with sharing class SER_TaskMethods_EGS {
  /*Constante EGS RECORD TYPE*/
  public static final Id EGSRT;
  static {
    EGSRT = SER_RecordTypeUtils.getRecordTypeByName('Task', 'SER_Task_EGS');
  }
  /*Constante EGS CLOSE RECORD TYPE*/
  public static final Id EGSCLRT;
  static {
    EGSCLRT = SER_RecordTypeUtils.getRecordTypeByName('Task', 'SER_Close_Task_EGS');
  }

  /*---------------------------------------------------------------------------------------
      Company:       BBVA
      Description:   private constructor.
  ---------------------------------------------------------------------------------------*/
  private SER_TaskMethods_EGS() {}


  /*---------------------------------------------------------------------------------------
      Company:       BBVA
      Description:   validateActionLineTasks.

      IN:            final List<Task> newList.
      IN:            Map<Id, Task> oldMap.
      OUT:           Void.
  ---------------------------------------------------------------------------------------*/
  public static void validateActionLineTasks(final List<Task> newList, Map<Id, Task> oldMap) {
    List<Case> casesToUpdate;
    casesToUpdate = new List<Case>();
    if(oldMap == null) {
      for(Task tarea : newList) {
        Boolean processInsert;
        processInsert = tarea.RecordTypeId == EGSRT && tarea.gf_spec_task_op_case_ind_type__c == true && String.valueOf(tarea.WhatId).startsWithIgnoreCase(SER_Constant.CASE_500);
        if(processInsert) {
          processActionLineTasks(tarea.WhatId, tarea);
        }
      }
    } else {
      for(Task tarea : newList) {
        Boolean processUpdate;
        processUpdate = tarea.RecordTypeId == EGSRT && tarea.gf_spec_task_op_case_ind_type__c == true && oldMap.get(tarea.Id).gf_spec_task_op_case_ind_type__c == false && String.valueOf(tarea.WhatId).startsWithIgnoreCase(SER_Constant.CASE_500);
        Boolean deleteCaseAcLi;
        deleteCaseAcLi = tarea.RecordTypeId == EGSRT && tarea.gf_spec_task_op_case_ind_type__c == false && oldMap.get(tarea.Id).gf_spec_task_op_case_ind_type__c == true && String.valueOf(tarea.WhatId).startsWithIgnoreCase(SER_Constant.CASE_500);
        if(processUpdate) {
          processActionLineTasks(tarea.WhatId, tarea);
        } else if(deleteCaseAcLi) {
          Case objCase;
          objCase =  new Case();
          objCase.Id = tarea.WhatId;
          objCase.SER_LineAction_EGS__c = false;
          casesToUpdate.add(objCase);
        }
      }
    }
    if(casesToUpdate.isEmpty() == false) {
      try {
        update casesToUpdate;
      } catch(Exception exc) {
        String errorMessage;
        errorMessage = ' Message: ' + exc.getMessage() + ' ,StackTrace: ' + exc.getStackTraceString();
        CIB_LogUtils.create_Log('ERROR: SER_TaskMethods_EGS.validateActionLineTasks', errorMessage);
      }
    }
  }

  /*---------------------------------------------------------------------------------------
      Company:       BBVA
      Description:   processActionLineTasks.

      IN:            Id caseId.
      OUT:           Void.
  ---------------------------------------------------------------------------------------*/
  private static void processActionLineTasks(Id caseId, Task tarea) {
    Boolean hasActionLine;
    hasActionLine = SER_RTM_Task_CallWS.blnCaseActionLine(caseId);
    if(hasActionLine) {
      tarea.addError(Label.SER_EGS_HasActionLine_lbl);
    } else {
      SER_RTM_Task_CallWS.updIdCaseActionLine(caseId);
    }
  }

  /*--------------------------------------------------------------------------
    Author:        Cintia Carmona
    Company:       Accenture
    Description:   validate reopening tasks in closed cases .

    IN:        Map<Id,Task> newMap,Map<Id,Task> oldMap 
    OUT:       Void

    History:
    <Date>            <Author>            <Change Description>
    06/08/2020        Cintia Carmona      Initial Version
  ----------------------------------------------------------------------------*/
  public static void checkReopenEGS(List<Task> newList, Map<Id,Task> oldMap) {
    List<Id> idCasos = new List<Id>();
    List<Task> tareasReopen = new List<Task>();

    for(Task tareaItem: newList) {
      Task oldTask = new Task();
      oldTask = oldMap.get(tareaItem.Id);
      boolean tratarTarea;
      tratarTarea = (tareaItem.RecordTypeId == EGSRT ||
                     tareaItem.RecordTypeId == EGSCLRT)
                && String.valueOf(tareaItem.WhatId).startsWithIgnoreCase('500')
                && tareaItem.Status != SER_Constant.COMPLETED
                && oldTask.Status == SER_Constant.COMPLETED;

      if (tratarTarea) {
        idCasos.add(tareaItem.WhatId);
        tareasReopen.add(tareaItem);
      }
    }

    Map<Id,case> mapCasesToProcess;
    mapCasesToProcess = new Map<Id,case>();
    List<Case> casos;
    casos = new List<Case>();

    if(idCasos.isEmpty() == false) {
      casos = [SELECT Id, Status FROM Case WHERE Id IN :idCasos];

      for(Case casoItem: casos) {
        mapCasesToProcess.put(casoItem.Id, casoItem);
      }

      for(Task tarea: tareasReopen) {
        Case casoAct = new Case();
        casoAct = mapCasesToProcess.get(tarea.WhatId);
        if(casoAct.Status == 'Closed' && !tarea.Skip_Validations__c) {
          String errorMessage;
          errorMessage = system.label.SER_EGS_ErrorReopenTask;

          tarea.addError(errorMessage);
        }
      }
    }
  }

 /*--------------------------------------------------------------------------
    Author:        Cintia Carmona
    Company:       Accenture
    Description:   Update status Cases in 'open task' substatus when their task are completed.

    IN:        List<Task> newList
    OUT:       Void

    History:
    <Date>            <Author>            <Change Description>
    20/07/2020        Cintia Carmona      Initial Version
  ----------------------------------------------------------------------------*/
  public static void changeStatusMaster(final List<Task> tasks) {
    List<Id> caseIdsList = new List<Id>();
    
    for(Task tarea : tasks) {
      Boolean count = false;
      if(tarea.WhatId != null) {
        count = tarea.RecordTypeId == EGSRT
                && String.valueOf(tarea.WhatId).startsWithIgnoreCase('500')
                && tarea.Status == SER_Constant.COMPLETED
                && tarea.TaskSubtype != 'Email';
      }
      if(count) {
        caseIdsList.add(tarea.WhatId);
      }
    }

    Map<Case, List<Task>> caseTaskMap = new Map<Case, List<Task>>();
    List<Id> caseIdsMaster = new List<Id>();
    
    if(caseIdsList.isEmpty() == false) {
      List<Task> taskList = new List<Task>();
      taskList = [SELECT Id, WhatId, Status, TaskSubtype FROM Task WHERE WhatId IN :caseIdsList];
      for(Case caso : [SELECT Id, Status, activity_status_type__c, case_status_type__c, SER_Is_Master_Case__c, SER_Master_Case__c FROM Case WHERE Id IN :caseIdsList]) {
        boolean casoHijo;
        casoHijo = caso.SER_Is_Master_Case__c == false 
                && caso.SER_Master_Case__c != null
                && caso.activity_status_type__c == 'Open Tasks';
        if(casoHijo) {
          caseTaskMap.put(caso, new List<Task>());
          caseIdsMaster.add(caso.SER_Master_Case__c);
          for(Task tarea : taskList) {
            Boolean process;
            process = tarea.WhatId == caso.Id 
                    && tarea.TaskSubtype != 'Email';
            if(process) {
              caseTaskMap.get(caso).add(tarea);
            }
          }
        }
      }
    }

    List<Case> caseToUpdate = new List<Case>();
    caseToUpdate = reviewFillCase(caseTaskMap, caseIdsMaster);
    
    if(caseToUpdate.isEmpty() == false) {
      update caseToUpdate;
    }
  }

  /*--------------------------------------------------------------------------
    Author:        Cintia Carmona
    Company:       Accenture
    Description:   Update substatus and status Case.

    IN:        Map<Case, List<Task>>, List<Id> 
    OUT:       List<Task>

    History:
    <Date>            <Author>            <Change Description>
    20/07/2020        Cintia Carmona      Initial Version
  ----------------------------------------------------------------------------*/
  public static List<Case> reviewFillCase(final Map<Case, List<Task>> caseTaskMap, final List<Id> caseIdsMaster) {

    List<Case> caseToUpdate;
    caseToUpdate = new List<Case>();

    List<Case> caseCompleted;
    caseCompleted = new List<Case>();

    if(caseTaskMap.isEmpty() == false) {
      for(Case caso : caseTaskMap.keySet()) {

        final List<Task> taskList = caseTaskMap.get(caso);
        if(taskList.isEmpty() == false) {
          Boolean caseWorking = false;
          for(Task tarea : taskList) {
            final boolean aux = tarea.status !=  Label.SER_EGS_StatusCompleted_lbl;
            if(aux) {
              caseWorking = true;
            }
          }
          if(caseWorking == false) {
            caseCompleted.add(caso);
          }
        }
      }
    }

    if(caseCompleted.isEmpty() == false) {
      List<Case> casosMaster = new List<Case>();
      casosMaster = [SELECT Id, Status, activity_status_type__c, case_status_type__c FROM Case WHERE Id IN :caseIdsMaster];

      for(Case caso : caseCompleted) {
        for(Case master : casosMaster) {
          Boolean process;
          process = master.Id == caso.SER_Master_Case__c; 
          if(process) {
            caso.Status = master.Status;
            caso.case_status_type__c = master.case_status_type__c;
            caso.activity_status_type__c = master.activity_status_type__c;
            caseToUpdate.add(caso);
          }
        }
      }
    }

    return caseToUpdate;
  }

}