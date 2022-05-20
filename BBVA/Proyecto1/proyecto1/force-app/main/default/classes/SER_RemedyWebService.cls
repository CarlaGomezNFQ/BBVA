/*--------------------------------------------------------------------------------------------------------------------
    Author:        Javier SS
    Company:       Accenture
    Description:   Web Service que se expone para que se invoque desde Remedy y se sincronicen los cambios relaizados
                    entre el ticket Remedy y el Case Salesforce

    History:
    2017-03-27          Javier SS                Creación de la clase
----------------------------------------------------------------------------------------------------------------------*/
global Without Sharing class SER_RemedyWebService {
//
// --------------------------------------------------------------------------
// --> CONSTANTS
// --------------------------------------------------------------------------
//
  //-- Contract Constants
  /*ERR Msg: RemedyId not Found*/
  private static final String ERR_RMDYID = 'Remedy ID not found.';
  /*REQUEST_NULL_ERROR_MSG */
  private static final String ERR_NULL_REQ = 'List of objects is null or Web Service call is not correct.';
  /*NEWSTATUS_ERROR_MSG*/
  public static final String ERR_NEW_STATUS = 'New Status: Invalid value.';
  /*Result.StatusCode 1*/
  private static final String RET_STATUS_1 = '1';
  /*Result.StatusCode 2*/
  private static final String RET_STATUS_2 = '2';
  /*Result.StatusCode 3*/
  private static final String RET_STATUS_3 = '3';
  /*Result.StatusCode 4*/
  private static final String RET_STATUS_4 = '4';
  /*variable para asociar un valor nulo de tipo date */
  private static final DateTime DATE_NULL;
  /*variable 'Remedy'*/
  private static final String REMEDY = 'Remedy - ';

  private SER_RemedyWebService () {
  }
// --------------------------------------------------------------------------
// --> PUBLIC METHODS (WEB SERVICE OPERATIONS)
// --------------------------------------------------------------------------
//
  /**
  * Operaciones RECHAZAR, PENDIENTE USUARIO y RESOLVER: Modifica en el objeto Case el estado que se haya actualizado
  *   en el ticket Remedy, y se añade un comentario.
  *
  * @param entitySyncDto <tt>EntitySyncDto</tt>
  * @return <tt>SyncResultDto</tt>
  */
  webService static SyncResultDto updateStatusRemedyTicket(final EntitySyncDto entitySyncDto) {
    //-- Object to return
    SyncResultDto syncResult;
    syncResult = new SyncResultDto();
    syncResult.errors = new List<Result>();
    syncResult.successes = new List<Result>();

    final boolean blValidaciones = entitySyncDto == null || entitySyncDto.objects == null || entitySyncDto.objects.isEmpty();
    //-- Prevalidations
    if (blValidaciones) {
      syncResult.errors.add(SER_RemedyWebService_HELPER.createResult('',ERR_NULL_REQ,RET_STATUS_2));
    } else {
      //-- Para la inserción en CaseComment/TaskComment se necesita lanzar una query para recuperar el Case/Task ID a partir de los RemedyID.
      //Metemos el resultado en un mapa<remedyId, Id>
      final Set<String> remedyIdSet = SER_RemedyWebService_HELPER.generateRemedyIdSet (entitySyncDto);
      final Map<String,Id> mapCaseToUpdate = SER_RemedyWebService_HELPER.generateMapCase (remedyIdSet);
      final Map<String,Id> mapTaskToUpdate = SER_RemedyWebService_HELPER.generateMapTask (remedyIdSet);
      final Boolean isCase = mapCaseToUpdate.isEmpty() == false;
      final Boolean isTask = mapTaskToUpdate.isEmpty() == false;
      //-- Hacemos la conversión y metemos cada item de RemedyTicket en una Lista de Case para hacer luego el
      // UPDATE de Cases y el INSERT de CaseComments
      final List<Case> casesToUpdateList = new List<Case>();
      final List<CaseComment> newCommentListC = new List<CaseComment>();
      //-- Hacemos la conversión y metemos cada item de RemedyTicket en una Lista de Task para hacer luego el
      // UPDATE de Task y el INSERT de TaskComments
      final List<Task> taskToUpdateList = new List<Task>();
      final List<TaskComment__c> newCommentListT = new List<TaskComment__c>();
      for (RemedyTicket rt : entitySyncDto.objects) {
        //El ticketRemedy debe tener los campos obligatorios informados del ticket Remedy
        final String msgCheckTicket = SER_RemedyWebService_HELPER.checkUpdateStatusRequiredFields(rt,isCase);
        final boolean errCheckTicket = !String.isBlank(msgCheckTicket);
        final boolean errRemedyId = !mapCaseToUpdate.containsKey(rt.remedyId) && !mapTaskToUpdate.containsKey(rt.remedyId);
        if (errCheckTicket) {
          syncResult.errors.add(SER_RemedyWebService_HELPER.createResult(rt.remedyId,msgCheckTicket,msgCheckTicket == ERR_NEW_STATUS ? RET_STATUS_4 : RET_STATUS_3));
        } else if (errRemedyId) {
          syncResult.errors.add(SER_RemedyWebService_HELPER.createResult(rt.remedyId,ERR_RMDYID,RET_STATUS_1));
        } else if(isCase) {
          //Copia los datos establecidos por el contrato de un objeto RemedyTicket a un objecto de Salesforce Case y lo meto en una lista.
          casesToUpdateList.add(createCase(mapCaseToUpdate.get(rt.remedyId), rt, RET_STATUS_1));

          //Si hay comentario se crea un case comment y se mete en una lista
          newCommentListC.add(createCaseComment(mapCaseToUpdate.get(rt.remedyId), rt));
        } else if(isTask) {
          //Copia los datos establecidos por el contrato de un objeto RemedyTicket a un objecto de Salesforce Task y lo meto en una lista.
          taskToUpdateList.add(createTask(mapTaskToUpdate.get(rt.remedyId), rt, RET_STATUS_1));

          //Si hay comentario se crea un case comment y se mete en un alista
          newCommentListT.add(createTaskComment(mapTaskToUpdate.get(rt.remedyId), rt));
        }
      }
      //Actualizamos Registros
      SER_RemedyWebService_HELPER.Params params;
      params = new SER_RemedyWebService_HELPER.Params();
      params.casesToUpdateList = casesToUpdateList;
      params.taskToUpdateList = taskToUpdateList;
      params.newCommentListC = newCommentListC;
      params.newCommentListT = newCommentListT;
      params.syncResult = syncResult;
      syncResult = SER_RemedyWebService_HELPER.updateRecords(params);
    }
    return syncResult;
  }

  /**
  * Operacion AÑADIR COMENTARIO: Añade un comentario relacionado con el objeto Case que se haya actualizado en el ticket Remedy.
  *
  * @param entitySyncDto <tt>EntitySyncDto</tt>
  * @return <tt>SyncResultDto</tt>
  */
  webService static SyncResultDto addCommentRemedyTicket(final EntitySyncDto entitySyncDto) {
    //-- Object to return
    SyncResultDto syncResult;
    syncResult = new SyncResultDto();
    syncResult.errors = new List<Result>();
    syncResult.successes = new List<Result>();

    final boolean blValidaciones = entitySyncDto == null || entitySyncDto.objects == null || entitySyncDto.objects.isEmpty();
    //-- Prevalidations
    if (blValidaciones) {
      syncResult.errors.add(SER_RemedyWebService_HELPER.createResult('',ERR_NULL_REQ, RET_STATUS_2));
    } else {
      //-- Para la inserción en CaseComment se necesita lanzar una query para recuperar el CaseID a partir de los RemedyID.
      //Metemos el resultado en un mapa<remedyId, Id>
      final Set<String> remedyIdSet = SER_RemedyWebService_HELPER.generateRemedyIdSet (entitySyncDto);
      final Map<String,Id> mapCaseToUpdate = SER_RemedyWebService_HELPER.generateMapCase (remedyIdSet);
      final Map<String,Id> mapTaskToUpdate = SER_RemedyWebService_HELPER.generateMapTask (remedyIdSet);
      //-- Hacemos la conversión y metemos cada item de RemedyTicket en una Lista de Case para hacer luego el
      // UPDATE de Cases y el INSERT de CaseComments
      final List<Case> casesToUpdateList = new List<Case>();
      final List<CaseComment> newCommentListC = new List<CaseComment>();
      //-- Hacemos la conversión y metemos cada item de RemedyTicket en una Lista de Task para hacer luego el
      // UPDATE de Task y el INSERT de TaskComments
      final List<Task> taskToUpdateList = new List<Task>();
      final List<TaskComment__c> newCommentListT = new List<TaskComment__c>();
      for (RemedyTicket rt : entitySyncDto.objects) {
        //El ticketRemedy debe tener los campos obligatorios informados del ticket Remedy
        final String msgCheckTicket = SER_RemedyWebService_HELPER.checkAddCommentRequiredFields(rt);
        final boolean errCheckTicket = !String.isBlank(msgCheckTicket);
        final boolean errRemedyId = !mapCaseToUpdate.containsKey(rt.remedyId) && !mapTaskToUpdate.containsKey(rt.remedyId);
        if (errCheckTicket) {
          syncResult.errors.add(SER_RemedyWebService_HELPER.createResult(rt.remedyId, msgCheckTicket, RET_STATUS_3));
        } else if (errRemedyId) {
          syncResult.errors.add(SER_RemedyWebService_HELPER.createResult(rt.remedyId, ERR_RMDYID, RET_STATUS_1));
        } else if(mapCaseToUpdate.isEmpty() == false) {
          //Copia los datos establecidos por el contrato de un objeto RemedyTicket a un objecto de Salesforce Case y lo meto en una lista.
          casesToUpdateList.add(createCase(mapCaseToUpdate.get(rt.remedyId), rt, RET_STATUS_2));

          //Si hay comentario se crea un case comment y se mete en un alista
          newCommentListC.add(createCaseComment(mapCaseToUpdate.get(rt.remedyId), rt));
        } else if(mapTaskToUpdate.isEmpty() == false) {
          //Copia los datos establecidos por el contrato de un objeto RemedyTicket a un objecto de Salesforce Task y lo meto en una lista.
          taskToUpdateList.add(createTask(mapTaskToUpdate.get(rt.remedyId), rt, RET_STATUS_2));

          //Si hay comentario se crea un case comment y se mete en un alista
          newCommentListT.add(createTaskComment(mapTaskToUpdate.get(rt.remedyId), rt));
        }
      }
      //Actualizamos Registros
      SER_RemedyWebService_HELPER.Params params;
      params = new SER_RemedyWebService_HELPER.Params();
      params.casesToUpdateList = casesToUpdateList;
      params.taskToUpdateList = taskToUpdateList;
      params.newCommentListC = newCommentListC;
      params.newCommentListT = newCommentListT;
      params.syncResult = syncResult;
      syncResult = SER_RemedyWebService_HELPER.updateRecords(params);
    }
    return syncResult;
  }

  /**
  * Operacion TRANSFERIR: Modifica en el objeto Case el RemedGroup que se haya actualizado en el ticket Remedy.
  *
  * @param entitySyncDto <tt>EntitySyncDto</tt>
  * @return <tt>SyncResultDto</tt>
  */
  webService static SyncResultDto updateRemedyGroupRemedyTicket(final EntitySyncDto entitySyncDto) {
    //-- Object to return
    SyncResultDto syncResult;
    syncResult = new SyncResultDto();
    syncResult.errors = new List<Result>();
    syncResult.successes = new List<Result>();

    final boolean blValidaciones = entitySyncDto == null || entitySyncDto.objects == null || entitySyncDto.objects.isEmpty();
    //-- Prevalidations
    if (blValidaciones) {
      syncResult.errors.add(SER_RemedyWebService_HELPER.createResult('',ERR_NULL_REQ, RET_STATUS_2));
    } else {
      //-- Para evitar hacer upsert a partir del externalID, cogemos el CaseID de Salesforce a partir de los RemedyID y realizamos update.
      // Metemos el resultado en un mapa<remedyId, Id>
      final Set<String> remedyIdSet = SER_RemedyWebService_HELPER.generateRemedyIdSet (entitySyncDto);
      final Map<String,Id> mapCaseToUpdate = SER_RemedyWebService_HELPER.generateMapCase (remedyIdSet);
      final Map<String,Id> mapTaskToUpdate = SER_RemedyWebService_HELPER.generateMapTask (remedyIdSet);
      //-- Hacemos la conversión y metemos cada item de RemedyTicket en una Lista de Case para hacer luego el
      // UPDATE de Cases y el INSERT de CaseComments
      final List<Case> casesToUpdateList = new List<Case>();
      final List<CaseComment> newCommentListC = new List<CaseComment>();
      //-- Hacemos la conversión y metemos cada item de RemedyTicket en una Lista de Task para hacer luego el
      // UPDATE de Task y el INSERT de TaskComments
      final List<Task> taskToUpdateList = new List<Task>();
      final List<TaskComment__c> newCommentListT = new List<TaskComment__c>();
      for (RemedyTicket rt : entitySyncDto.objects) {
        //El ticketRemedy debe tener los campos obligatorios informados del ticket Remedy
        final String msgCheckTicket = SER_RemedyWebService_HELPER.checkUpdateRemedyGroupRequiredFields(rt);
        final boolean errCheckTicket = !String.isBlank(msgCheckTicket);
        final boolean errRemedyId = !mapCaseToUpdate.containsKey(rt.remedyId) && !mapTaskToUpdate.containsKey(rt.remedyId);
        if (errCheckTicket) {
          syncResult.errors.add(SER_RemedyWebService_HELPER.createResult(rt.remedyId, msgCheckTicket, RET_STATUS_3));
        } else if (errRemedyId) {
          syncResult.errors.add(SER_RemedyWebService_HELPER.createResult(rt.remedyId, ERR_RMDYID, RET_STATUS_1));
        } else if(mapCaseToUpdate.isEmpty() == false) {
          //Copia los datos establecidos por el contrato de un objeto RemedyTicket a un objecto de Salesforce Case y lo meto en una lista.
          casesToUpdateList.add(createCase(mapCaseToUpdate.get(rt.remedyId), rt, RET_STATUS_3));

          //Si hay comentario se crea un case comment y se mete en una lista
          final boolean cmtNoVacio = rt.comment != null && rt.comment.trim() != '';
          if (cmtNoVacio) {newCommentListC.add(createCaseComment(mapCaseToUpdate.get(rt.remedyId), rt));}
        } else if(mapTaskToUpdate.isEmpty() == false) {
          //Copia los datos establecidos por el contrato de un objeto RemedyTicket a un objecto de Salesforce Task y lo meto en una lista.
          taskToUpdateList.add(createTask(mapTaskToUpdate.get(rt.remedyId), rt, RET_STATUS_3));

          //Si hay comentario se crea un case comment y se mete en un alista
          final boolean cmtNoVacio = rt.comment != null && rt.comment.trim() != '';
          if (cmtNoVacio) {newCommentListT.add(createTaskComment(mapTaskToUpdate.get(rt.remedyId), rt));}
        }
      }
      //Actualizamos Registros
      SER_RemedyWebService_HELPER.Params params;
      params = new SER_RemedyWebService_HELPER.Params();
      params.casesToUpdateList = casesToUpdateList;
      params.taskToUpdateList = taskToUpdateList;
      params.newCommentListC = newCommentListC;
      params.newCommentListT = newCommentListT;
      params.syncResult = syncResult;
      syncResult = SER_RemedyWebService_HELPER.updateRecords(params);
    }
    return syncResult;
  }

  /**
  * Operacion FECHA COMPROMISO: Modifica en el objeto Case el RemedGroup que se haya actualizado en el ticket Remedy.
  *
  * @param entitySyncDto <tt>EntitySyncDto</tt>
  * @return <tt>SyncResultDto</tt>
  */
  webService static SyncResultDto updateCommitmentDateRemedyTicket(final EntitySyncDto entitySyncDto) {
    //-- Object to return
    SyncResultDto syncResult;
    syncResult = new SyncResultDto();
    syncResult.errors = new List<Result>();
    syncResult.successes = new List<Result>();

    final boolean blValidaciones = entitySyncDto == null || entitySyncDto.objects == null || entitySyncDto.objects.isEmpty();
    //-- Prevalidations
    if (blValidaciones) {
      final Result result = SER_RemedyWebService_HELPER.createResult('',ERR_NULL_REQ,RET_STATUS_2);
      syncResult.errors.add(result);
    } else {
      //-- Para evitar hacer upsert a partir del externalID, cogemos el CaseID de Salesforce a partir de los RemedyID y realizamos update.
      // Metemos el resultado en un mapa<remedyId, Id>
      final Set<String> remedyIdSet = SER_RemedyWebService_HELPER.generateRemedyIdSet (entitySyncDto);
      final Map<String,Id> mapCaseToUpdate = SER_RemedyWebService_HELPER.generateMapCase (remedyIdSet);
      final Map<String,Id> mapTaskToUpdate = SER_RemedyWebService_HELPER.generateMapTask (remedyIdSet);
      //-- Hacemos la conversión y metemos cada item de RemedyTicket en una Lista de Case para hacer luego el
      // UPDATE de Cases.
      final List<Case> casesToUpdateList = new List<Case>();
      //-- Hacemos la conversión y metemos cada item de RemedyTicket en una Lista de Task para hacer luego el
      // UPDATE de Task.
      final List<Task> taskToUpdateList = new List<Task>();
      for (RemedyTicket rt : entitySyncDto.objects) {
        //El ticketRemedy debe tener los campos obligatorios informados del ticket Remedy
        final String msgCheckTicket = SER_RemedyWebService_HELPER.checkUpdateCommitmentDateRequiredFields(rt);
        final boolean errCheckTicket = !String.isBlank(msgCheckTicket);
        final boolean errRemedyId = !mapCaseToUpdate.containsKey(rt.remedyId) && !mapTaskToUpdate.containsKey(rt.remedyId);
        if (errCheckTicket) {
          final Result result = SER_RemedyWebService_HELPER.createResult(rt.remedyId,msgCheckTicket, RET_STATUS_3);
          syncResult.errors.add(result);
        } else if (errRemedyId) {
          final Result result = SER_RemedyWebService_HELPER.createResult(rt.remedyId, ERR_RMDYID, RET_STATUS_1);
          syncResult.errors.add(result);
        } else if(mapCaseToUpdate.isEmpty() == false) {
          //Copia los datos establecidos por el contrato de un objeto RemedyTicket a un objecto de Salesforce Case y lo meto en una lista.
          casesToUpdateList.add(createCase(mapCaseToUpdate.get(rt.remedyId), rt, RET_STATUS_4));
        } else if(mapTaskToUpdate.isEmpty() == false) {
          //Copia los datos establecidos por el contrato de un objeto RemedyTicket a un objecto de Salesforce Task y lo meto en una lista.
          taskToUpdateList.add(createTask(mapTaskToUpdate.get(rt.remedyId), rt, RET_STATUS_4));
        }
      }
      //Actualizamos Registros
      SER_RemedyWebService_HELPER.Params params;
      params = new SER_RemedyWebService_HELPER.Params();
      params.casesToUpdateList = casesToUpdateList;
      params.taskToUpdateList = taskToUpdateList;
      params.syncResult = syncResult;
      syncResult = SER_RemedyWebService_HELPER.updateRecords(params);
    }
    return syncResult;
  }

//
// --------------------------------------------------------------------------
// --> PRIVATE METHODS
// --------------------------------------------------------------------------
//
  /*
  * createCase
  *
  * @param Id id
  * @param RemedyTicket rt
  * @param String service
  * @return Case
  */
  private static Case createCase(Id caseId, RemedyTicket ticket, String service) {
    Case caso;
    caso = new Case();
    caso.SER_RemedyId__c = ticket.remedyId;
    caso.Id = caseId;
    caso.SER_Skip_validations__c = true;
    if(RET_STATUS_1.equalsIgnoreCase(service)) {
      caso.Status = ticket.newStatus;
    }
    if(RET_STATUS_3.equalsIgnoreCase(service)) {
      caso.SER_Remedy_Transition_Department__c = ticket.transferredRemedyDept;
      caso.SER_Remedy_Transition_Department_ID__c = ticket.idTransferredRemedyDept;
    }
    if(RET_STATUS_4.equalsIgnoreCase(service) && String.isBlank(ticket.commitmentDate)) {
      caso.SER_Commitment_Date__c = DATE_NULL;
    }
    if(RET_STATUS_4.equalsIgnoreCase(service) && String.isNotBlank(ticket.commitmentDate)) {
      final String dateFormat = ticket.commitmentDate.split(' ')[0].split('/')[2] + '-' + ticket.commitmentDate.split(' ')[0].split('/')[1] + '-' + ticket.commitmentDate.split(' ')[0].split('/')[0];
      final String timeFormat = ticket.commitmentDate.split(' ')[1];
      caso.SER_Commitment_Date__c = DateTime.valueOf(dateFormat + ' ' + timeFormat);
    }
    return caso;
  }

  /*
  * createTask
  *
  * @param Id id
  * @param RemedyTicket rt
  * @param String service
  * @return Task
  */
  private static Task createTask(Id taskId, RemedyTicket ticket, String service) {
    Task tarea;
    tarea = new Task();
    tarea.incidence_id__c = ticket.remedyId;
    tarea.Id = taskId;
    tarea.Skip_Validations__c = true;
    if(RET_STATUS_1.equalsIgnoreCase(service)) {
      tarea.Status = ticket.newStatus;
    }
    if(RET_STATUS_3.equalsIgnoreCase(service)) {
      tarea.department_correction_desc__c = ticket.transferredRemedyDept;
      tarea.department_id__c = ticket.idTransferredRemedyDept;
    }
    if(RET_STATUS_4.equalsIgnoreCase(service) && String.isBlank(ticket.commitmentDate)) {
      tarea.incidence_commitment_date__c = DATE_NULL;
    }
    if(RET_STATUS_4.equalsIgnoreCase(service) && String.isNotBlank(ticket.commitmentDate)) {
      final String dateFormat = ticket.commitmentDate.split(' ')[0].split('/')[2] + '-' + ticket.commitmentDate.split(' ')[0].split('/')[1] + '-' + ticket.commitmentDate.split(' ')[0].split('/')[0];
      final String timeFormat = ticket.commitmentDate.split(' ')[1];
      tarea.incidence_commitment_date__c = DateTime.valueOf(dateFormat + ' ' + timeFormat);
    }
    return tarea;
  }

  /*
  * createCaseComment
  *
  * @param Id id
  * @param RemedyTicket rt
  * @return CaseComment
  */
  private static CaseComment createCaseComment(Id caseId, RemedyTicket ticket) {
    CaseComment com;
    com = new CaseComment();
    com.ParentId = caseId;
    com.CommentBody = ticket.comment;
    return com;
  }

  /*
  * RemedyTicket rt
  *
  * @param Id id
  * @param RemedyTicket rt
  * @return TaskComment__c
  */
  private static TaskComment__c createTaskComment(Id taskId, RemedyTicket ticket) {
    TaskComment__c com;
    com = new TaskComment__c();
    com.ParentId__c = taskId;
    com.gf_task_comment_body_desc__c = ticket.comment;
    com.isRemedy__c = true;
    com.gf_task_comment_date__c = Datetime.now();
    Task tarea;
    tarea = [SELECT department_correction_desc__c, departament_name__c FROM Task WHERE Id = :taskId LIMIT 1];
    com.gf_task_comment_creator_name__c = String.isNotBlank(tarea.department_correction_desc__c) ? REMEDY + tarea.department_correction_desc__c : REMEDY + tarea.departament_name__c;

    //Insertamos un comentario en el feed
    FeedItem feedComment;
    feedComment = new FeedItem();
    feedComment.Body = 'Remedy comment: '
          + (String.isNotBlank(tarea.department_correction_desc__c) ? tarea.department_correction_desc__c : tarea.departament_name__c)
          + ' - ' + ticket.comment;
    feedComment.ParentId = taskId;
    feedComment.Title = 'Remedy Comment';
    insert feedComment;

    return com;
  }


// --------------------------------------------------------------------------
// --> CONTRACT STRUCTURE
// --------------------------------------------------------------------------
//
  /*--------------------------------------------------------------------------------------------------------------------
    Author:        Javier SS
    Company:       Accenture
    Description:   Clase que encapsula la información que se recoge en la petición (tickets de remedy a procesar)

    History:
    2017-03-27          Javier SS                Creación de la clase
  ----------------------------------------------------------------------------------------------------------------------*/
  global class EntitySyncDto {
    /*lista de Tickets remedy*/
    Webservice List<RemedyTicket> objects;
  }

  /*--------------------------------------------------------------------------------------------------------------------
    Author:        Javier SS
    Company:       Accenture
    Description:   Clase que encapsula la información de cada ticket Remedy que se ha de procesar

    History:
    2017-03-27          Javier SS                Creación de la clase
  ----------------------------------------------------------------------------------------------------------------------*/
  global class RemedyTicket {
    /*SER_RemedyId__c  */
    Webservice String remedyId;
    /* se añadirá un registro nuevo en CaseComment relacionado con el Case*/
    Webservice String comment;
    /*Status*/
    Webservice String newStatus;
    /*SER_Remedy_Transition_Department__c*/
    Webservice String transferredRemedyDept; //NOSONAR
    /*SER_Remedy_Transition_Department_ID__c*/
    WebService String idTransferredRemedyDept; //NOSONAR
    /*SER_Commitment_Date__c*/
    Webservice String commitmentDate;
  }

  /*--------------------------------------------------------------------------------------------------------------------
    Author:        Javier SS
    Company:       Accenture
    Description:   Clase que encapsula la información devuelta por el servicio (lista de errores y de éxitos

    History:
    2017-03-27          Javier SS                Creación de la clase
  ----------------------------------------------------------------------------------------------------------------------*/
  global class SyncResultDto {
    /*Lista de actualizaciones correctas*/
    Webservice List<Result> successes;
    /*Lista de errores en la actualización*/
    Webservice List<Result> errors;
  }

  /*--------------------------------------------------------------------------------------------------------------------
    Author:        Javier SS
    Company:       Accenture
    Description:   Clase que encapsula la información de la operación de actualización que se realiza
    History:
    2017-03-27          Javier SS                Creación de la clase
  ----------------------------------------------------------------------------------------------------------------------*/
  global class Result {
    /*Id de Remedy*/
    Webservice String remedyId;
    /*código de respuesta */
    Webservice String statusCode;
    /*detalle de error*/
    Webservice String detail;
  }
}