/*--------------------------------------------------------------------------------------------------------------------
    Author:        BBVA
    Description:   Helper de la clase SER_RemedyWebService.
----------------------------------------------------------------------------------------------------------------------*/
public Without Sharing class SER_RemedyWebService_HELPER {
  /**
  * Mensaje de "Operación satisfactoria" por defecto. Se usa en la respuesta de las operaciones de tipo "Remote Persist",
  * donde pueden haber registros persistidos correctamente y otros fallidos.
  */
  private static final String SUCCESS_MSG = 'Operation successful.';
  /*Result.StatusCode 0*/
  private static final String RET_STATUS_0 = '0';
  /*Mensaje a devolver cuando remedyId es vacío*/
  public static final String TO_RET_ID = 'Remedy ID | ';
  /*NULL_VALUE_REQUIRED_FIELDS_ERROR_MSG*/
  public static final String ERR_NULL_FIELD = 'Null value found in required fields';

  /*
  * Constructor privado.
  */
  private SER_RemedyWebService_HELPER () {
  }


  /*
  * Valida los campos obligatorios establecidos por el contrato para la operación de updateStatusRemedyTicket.
  * Si va bien devuelve una cadena vacía, si algún campo es nulo devuelve el mensaje de error correspondiente.
  *
  * @param Ticket <tt>RemedyTicket</tt> con el RemedyTicket a comprobar.
  * @return <tt>String</tt> con el mensaje de error o <tt>null</tt> si esta OK.
  */
  public static String checkUpdateStatusRequiredFields(SER_RemedyWebService.RemedyTicket pRt, Boolean isCase) {
    set<String> rmdyStatVal;
    rmdyStatVal = obtainStatusValue(isCase);
    //-- String to return
    String toReturn = '';

    if (rmdyStatVal.contains(pRt.newStatus)) {
      //-- Check mandatory fields
      final boolean idVacio = pRt.remedyId == null || pRt.remedyId.trim() == '';
      final boolean statusVacio = pRt.newStatus == null || pRt.newStatus.trim() == '';
      final boolean commentVacio = pRt.comment == null || pRt.comment.trim() == '';
      //EntityId
      if (idVacio) {
        toReturn += TO_RET_ID;
      }
      //NewStatus
      if (statusVacio) {
        toReturn += 'New Status | ';
      }
      //comment
      if (commentVacio) {
        toReturn += 'Comment';
      }
    } else {
      toReturn = SER_RemedyWebService.ERR_NEW_STATUS;
    }

    //-- Return object
    return toReturn == '' ? null : ERR_NULL_FIELD + ': ' + toReturn;
  }

  /*
  * Se obtienen los estados del caso/tarea.
  *
  * @param Ticket <tt>RemedyTicket</tt> con el RemedyTicket a comprobar.
  * @return <tt>String</tt> con el mensaje de error o <tt>null</tt> si esta OK.
  */
  private static set<String> obtainStatusValue(Boolean isCase) {
    //-- get Status values from picklist field
    set<String> rmdyStatVal = new set<String>();
    Schema.DescribeFieldResult fieldResult;
    if(isCase) {
      fieldResult = Case.Status.getDescribe();
    } else {
      fieldResult = Task.Status.getDescribe();
    }
    List<Schema.PicklistEntry> statusListValues;
    statusListValues = fieldResult.getPicklistValues();
    rmdyStatVal = new set<String> ();
    for (Schema.PicklistEntry status : statusListValues) {
      if (status.getValue().startsWith('Remedy')) {
        rmdyStatVal.add(status.getValue());
      }
    }
    return rmdyStatVal;
  }

  /*
  * Valida los campos obligatorios establecidos por el contrato para la operación de addCommentRemedyTicket.
  * Si va bien devuelve una cadena vacía, si algún campo es nulo devuelve el mensaje de error correspondiente.
  *
  * @param Ticket <tt>RemedyTicket</tt> con el RemedyTicket a comprobar.
  * @return <tt>String</tt> con el mensaje de error o <tt>null</tt> si esta OK.
  */
  public static String checkAddCommentRequiredFields(SER_RemedyWebService.RemedyTicket pRt) {
    String toReturn = '';

    //-- Check mandatory fields
    //EntityId
    if (pRt.remedyId == null || pRt.remedyId.trim() == '') {
      toReturn += TO_RET_ID;
    }
    //comment
    if (pRt.comment == null || pRt.comment.trim() == '') {
      toReturn += 'Comment';
    }
    //-- Return object
    return toReturn == '' ? null : ERR_NULL_FIELD + ': ' + toReturn;
  }

  /*
  * Valida los campos obligatorios establecidos por el contrato para la operación de updateRemedyGroup.
  * Si esta OK devuelve una cadena vacía, si algún campo es nulo devuelve el mensaje de error correspondiente.
  *
  * @param Ticket <tt>RemedyTicket</tt> con el RemedyTicket a comprobar.
  * @return <tt>String</tt> con el mensaje de error o <tt>null</tt> si esta OK.
  */
  public static String checkUpdateRemedyGroupRequiredFields(SER_RemedyWebService.RemedyTicket pRt) {
    //-- String to return
    String toReturn = '';

    //-- Check mandatory fields
    //EntityId
    if (pRt.remedyId == null || pRt.remedyId.trim() == '') {
      toReturn += TO_RET_ID;
    }

    //transferredRemedyDept
    if (pRt.transferredRemedyDept == null || pRt.transferredRemedyDept.trim() == '') {
      toReturn += 'Transferred Remedy Dept | ';
    }

    //idTransferredRemedyDept
    if (pRt.idTransferredRemedyDept == null || pRt.idTransferredRemedyDept.trim() == '') {
      toReturn += 'Transferred Remedy Dept ID';
    }
    //-- Return object
    return toReturn == '' ? null : ERR_NULL_FIELD + ': ' + toReturn;
  }

  /*
  * Valida los campos obligatorios establecidos por el contrato para la operación de updateRemedyGroup.
  * Si esta OK devuelve una cadena vacía, si algún campo es nulo devuelve el mensaje de error correspondiente.
  *
  * @param Ticket <tt>RemedyTicket</tt> con el RemedyTicket a comprobar.
  * @return <tt>String</tt> con el mensaje de error o <tt>null</tt> si esta OK.
  */
  public static String checkUpdateCommitmentDateRequiredFields(SER_RemedyWebService.RemedyTicket pRt) {
    //-- String to return
    String toReturn = '';

    //-- Check mandatory fields
    //EntityId
    if (pRt.remedyId == null || pRt.remedyId.trim() == '') {
      toReturn += TO_RET_ID;
    }

    //-- Return object
    return toReturn == '' ? null : ERR_NULL_FIELD + ': ' + toReturn;
  }

  /**
  * Se obtienen los casos a partir del remedyId y se crea un mapa con el remedyId como clave y el id del caso como valor.
  *
  * @param  Set<String> remedyIdSet.
  * @return Map<String,Id>.
  */
  public static Map<String,Id> generateMapCase (Set<String> remedyIdSet) {
    final Map<String,Id> toReturn = new Map<String,Id>();
    final List<Case> lCases = [select Id, SER_RemedyId__c from Case where SER_RemedyId__c in :remedyIdSet];
    for(Case caseAux : lCases) {
      toReturn.put(caseAux.SER_RemedyId__c,caseAux.Id);
    }
    return toReturn;
  }

  /**
  * Se obtienen las tareas a partir del remedyId y se crea un mapa con el remedyId como clave y el id de la tarea como valor.
  *
  * @param  Set<String> remedyIdSet.
  * @return Map<String,Id>.
  */
  public static Map<String,Id> generateMapTask (Set<String> remedyIdSet) {
    final Map<String,Id> toReturn = new Map<String,Id>();
    final List<Task> taskList = [select Id, incidence_id__c, department_correction_desc__c, departament_name__c from 	Task where incidence_id__c in :remedyIdSet];
    for(Task taskAux : taskList) {
      toReturn.put(taskAux.incidence_id__c,taskAux.Id);
    }
    return toReturn;
  }

  /**
  * Saca los remedyIds de EntitySyncDto.objects y los guarda en un Set.
  *
  * @param  final EntitySyncDto entitySyncDto.
  * @return Set<String>.
  */
  public static Set<String> generateRemedyIdSet (SER_RemedyWebService.EntitySyncDto entitySyncDto) {
    final Set<String> remedyIdSet = new Set<String>();
    for(SER_RemedyWebService.RemedyTicket rt : entitySyncDto.objects) {
      if (rt.remedyId != null && rt.remedyId.trim() != '') {
        remedyIdSet.add(rt.remedyId);
      }
    }
    return remedyIdSet;
  }

  /**
  * Genera el response que va a devolver los servicios.
  *
  * @param  String pRemedyId.
  * @param  String pDetail.
  * @param  String pStatusCode
  * @return Result.
  */
  public static SER_RemedyWebService.Result createResult (String pRemedyId, String pDetail, String pStatusCode) {
    //debería ser un constructor de la clase Result, pero se añade para no modificar el wsdl expuesto
    SER_RemedyWebService.Result toReturn;
    toReturn = new SER_RemedyWebService.Result();
    if (!String.isBlank(pRemedyId)) {
      toReturn.remedyId = pRemedyId;
    }
    toReturn.detail = pDetail;
    toReturn.statusCode = pStatusCode;

    return toReturn;
  }

  /**
  * Actualiza los Casos o Tareas e inserta los CaseComments o los TaskComments.
  *
  * @param  Params params.
  * @return Result.
  */
  public static SER_RemedyWebService.SyncResultDto updateRecords (Params params) {
    //Actualizamos los Cases
    Boolean updateCases;
    updateCases = params.casesToUpdateList != null && params.casesToUpdateList.isEmpty() == false;
    if (updateCases) {
      update params.casesToUpdateList;
      //Añadimos la operación satisfactoria a cada Caso
      for(Case cu : params.casesToUpdateList) {
        SER_RemedyWebService.Result result;
        result = createResult (cu.SER_RemedyId__c,SUCCESS_MSG,RET_STATUS_0);
        params.syncResult.successes.add(result);
      }
    //Actualizamos los Tareas
    } else if(params.taskToUpdateList != null && params.taskToUpdateList.isEmpty() == false) {
      try {
          update params.taskToUpdateList;
          for (Task tarea : params.taskToUpdateList) {
            tarea.Skip_Validations__c = false;
          }
          update params.taskToUpdateList;
      } catch(Exception exc) {
        CIB_Log__c log = new CIB_Log__c ();
        log.CIB_Subject__c = 'Remedy';
        log.CIB_ErrorMessage__c = 'message: ' + exc.getMessage() + ' ,tarce: '+ exc.getStackTraceString();
        insert log;
      }
      //Añadimos la operación satisfactoria a cada Tarea
      for(Task ta : params.taskToUpdateList) {
        SER_RemedyWebService.Result result;
        result = createResult (ta.incidence_id__c,SUCCESS_MSG,RET_STATUS_0);
        params.syncResult.successes.add(result);
      }
    }
    //Insertamos los CaseComments
    Boolean insertCaseCom;
    insertCaseCom = params.newCommentListC != null && params.newCommentListC.isEmpty() == false;
    if (insertCaseCom) {
      insert params.newCommentListC;
    } else if(params.newCommentListT != null && params.newCommentListT.isEmpty() == false) {
      insert params.newCommentListT;
    }
    return params.syncResult;
  }


  /**************************************************************************************
  *******************                   WRAPPER                     *********************
  **************************************************************************************/
  /*--------------------------------------------------------------------------------------------------------------------
    Author:        BBVA
    Description:   Clase que encapsula la información necesaria para updateRecords()
  ----------------------------------------------------------------------------------------------------------------------*/
  public class Params {
    /*Casos para actualizar*/
    public List<Case> casesToUpdateList {get; set;}
    /*Tareas para actualizar*/
    public List<Task> taskToUpdateList {get; set;}
    /*CaseComments para actualizar*/
    public List<CaseComment> newCommentListC {get; set;}
    /*TaskComments para actualizar*/
    public List<TaskComment__c> newCommentListT {get; set;}
    /*Respuesta del servicio*/
    public SER_RemedyWebService.SyncResultDto syncResult {get; set;}
  }
}