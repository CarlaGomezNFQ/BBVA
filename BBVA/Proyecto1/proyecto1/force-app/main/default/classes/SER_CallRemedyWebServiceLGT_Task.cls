/**********************************************************************************
* @author       JSS - Accenture
* @date         26/04/2017
* @description  Class intermedia  entre el botón JavaScript que la invoca y las llamadas a los Web Services ASO.
                                Se define como global para poder invocar sus meto2s desde Javasctipt.
                                Los meto2s se definen como @RemoteAction para invocarlos con Javascript Remoting.
* @Revision
    14/07/2017                  JSS                update method parseJsonString.
                                                parseJsonString now is used for
                                                any text string (description, comment worklog)
    27/07/2017                  JSS                method parseJsonString still fails and has
                                                been commented, now this fix is done in page
                                                code (javascript)
                                                Add new variables: newCommentParse, lastCommentParse, newCommentParse
**********************************************************************************/
public with sharing class SER_CallRemedyWebServiceLGT_Task { //NOSONAR

  //Case Object variables
  /*Caso en curso*/
  public Task currentTask {get; set;}
  /*Caso en curso*/
  public Case currentCase {get; set;}
  /*Ultimo commentario*/
  public TaskComment__c lastTaskComment {get; set;}
  /*Ultimo archivo adjunto*/
  public Attachment lastAttachment {get; set;}
  /*Ultimo archivo adjunto*/
  public ContentDocument lastFile {get; set;}

  //Operation selection variables
  /*Operacion*/
  public String operation {get; set;}
  /*Lista de operaciones*/
  public List<SelectOption> operationList {get; set;} //NOSONAR

  //SF Console control variables
  /*tab id detro de console para hacer luego el refresh de la pestaña del caso*/
  public transient String tabid {get; set;}
  /*Mensaje de error*/
  public String errorMsg {get; set;}

  /*Codigo de el empleado*/
  public String employeeCode {get; set;}
  /*Respuesta de el Web Service*/
  public String responseWS {get; set;}

  /*Case Comment fields*/
  public TaskComment__c newTaskComment {get; set;}

  /*Clase interna con los comment fields*/
  public Comment comment {get; set;}

  /*bl_SendLastComment*/
  public Boolean sendLastCom {get; set;}

  /*estado inicial del caso, se utiliza para controlar qué estado tenía cuando ya que se
      pueden realizar varias llamadas a WS concatenadas y se puede hacer update del caso*/
  private final String initTaskStatus;

  /*Instancia de clase auxiliar*/
  private final SER_CallRemedyWS_Task_ActionsLGT actions;

  /*commitmentDate*/
  private Datetime commitmentDate;//NOSONAR

  /*departement origin*/
  private String originDepartment;//NOSONAR
  /*Constante 'Mantener equipo resolutor'*/
  public final String  KEEPDEPARTMENT = 'Mantener equipo resolutor';


  /*--------------------------------------------------------------------------------------
      Company:       BBVA
      Description:   Constructor. Lightning Component Controller

      IN:           String caseId
                    String userId
  --------------------------------------------------------------------------------------*/
  public SER_CallRemedyWebServiceLGT_Task(String taskId, String userId) {
    this.employeeCode = userId;
    this.currentTask = [Select Id, incidence_commitment_date__c, gf_action_result_desc__c, incidence_id__c, Status, open_closed_type__c, data_incidence_date__c, departament_name__c, task_desc__c, createdDate, WhatId, Priority, gf_task_id__c, TaskComment__r.task_desc__c, TaskComment__r.gf_action_result_desc__c, TaskComment__c,
                        (Select Id, ParentId, Name, Description, BodyLength, ContentType, CreatedDate, CreatedById, LastModifiedDate From Attachments Where IsDeleted = false Order by createdDate Desc limit 1) from task where Id =: taskId];
    this.currentCase = [Select Id,caseNumber,SER_Business_Case_Type__c,priority, SER_Classification__c From Case Where Id = :currentTask.WhatId limit 1].get(0);

    List<TaskComment__c> taskComentList;
    taskComentList = [Select Id, ParentId__c, gf_task_comment_body_desc__c, CreatedById, CreatedDate, LastModifiedDate, LastModifiedById, IsDeleted From TaskComment__c Where IsDeleted = false and isRemedy__c = true and ParentId__c = :currentTask.Id Order by createdDate Desc limit 1];
    if(taskComentList.isEmpty() == false) {
      this.lastTaskComment = taskComentList[0];
    }
    this.originDepartment = this.currentTask.departament_name__c;
    this.comment =  new SER_CallRemedyWebServiceLGT_Task.Comment();
    this.comment.lastComment = this.lastTaskComment!=null && String.isNotBlank(this.lastTaskComment.gf_task_comment_body_desc__c) ? this.lastTaskComment.gf_task_comment_body_desc__c : '';
    //ATTACHMENTS
    this.errorMsg = '';
    this.responseWS = '';
    this.operationList = new List<SelectOption>();
    this.initTaskStatus = this.currentTask.Status;
    this.comment.descriptionParse = this.currentTask.TaskComment__r.task_desc__c;

    this.newTaskComment = new TaskComment__c();
    this.comment.remedyMessage = '';
    this.comment.newComment = '';
    this.comment.newCommentParse = '';
    this.comment.lastCommentParse = SER_CallRemedyWS_Task_HELPERLGT.parseJsonString(this.comment.lastComment,false);
    this.actions = new SER_CallRemedyWS_Task_ActionsLGT();
    this.operation = SER_CallRemedyWS_Task_ActionsLGT.validationInitOperation(this);
  }

  // ---------------
  //Methods
  // ---------------

  /*--------------------------------------------------------------------------------------
      Author:         JSS
      Company:        Accenture
      Description:    Controller para invocar los WS de Remedy (ASO). Recibe los datos de un
                      Caso, aplica la lógica para hacer la llamada a uno u otro Web Service
                      de ASO

      IN:             Void
      OUT:            Void

      History:
      <Date>                  <Author>                <Change Description>
      26/04/2017              JSS                      Initial Version
  --------------------------------------------------------------------------------------*/
  public void callWebServiceASOLogic(Boolean isCloseBtn) {   //NOSONAR
    system.debug(Logginglevel.INFO,'>>>> XXX >>> Entrando en callWebServiceASOLogic. Operation: ' + this.operation + '.\r\n Datos del Case: ' + this.currentCase + '.\r\n Datos de la tarea: ' + this.currentTask);
    HttpResponse resp;
    this.errorMsg = '';
    Boolean respOk;
    Boolean secondcall;
    secondcall = false;
    //1 Creation
    if (this.operation.equalsIgnoreCase(SER_CallRemedyWS_Task_HELPERLGT.NEWREMEDY)) {
      resp = actions.creation(this);
      System.debug('NEWREMEDY PASA');
      if (String.isNotBlank(this.comment.newCommentParse) || this.lastTaskComment != null) {
        System.debug('SECONDCALL PASA');
        secondcall = true;
      }
    //2 close
    } else if (this.operation.equalsIgnoreCase(SER_CallRemedyWS_Task_HELPERLGT.CLOSEREMEDY)) {
      resp = actions.close(this);
    //3 update
    } else if (this.operation.equalsIgnoreCase(SER_CallRemedyWS_Task_HELPERLGT.UPDATEREMEDY)) {
      resp = actions.updateRemedy(this);
      secondcall = true;
    //4 Claim
    } else if (this.operation.equalsIgnoreCase(SER_CallRemedyWS_Task_HELPERLGT.CLAIMREMEDY)) {
      resp = actions.claimRemady(this);
    //5 Add Comment
    } else if (this.operation.equalsIgnoreCase(SER_CallRemedyWS_Task_HELPERLGT.SENDCOMMENT)) {    //si no hay Comentarios en el Caso
      resp = actions.addComment(this);
    //6 Add Attachment info
    } else if(this.operation.equalsIgnoreCase(SER_CallRemedyWS_Task_HELPERLGT.SENDATTACHMENT)) {    //si no hay Attached en el Caso
      resp = actions.addattachment(this);
    //8 Reopen
    } else if(this.operation.equalsIgnoreCase(SER_CallRemedyWS_Task_HELPERLGT.REOPENREMEDY)) {    //preparacion parámetros de la Request
      resp = actions.reopen(this);
    }
    // si se ha hecho la llamada se procesa el resultado
    respOk = resp != null;
    if (respOk && secondcall == false) {
      if(String.isblank(this.errorMsg)) {
        this.errorMsg = 'Your ticket has been submitted';
      }
      system.debug('LLamo al finish en primera');
      finishCallWS(resp, isCloseBtn);
    }
  }

  /*--------------------------------------------------------------------------------------
      Company:        BBVA
      Description:    hace una segunda llamada a ASO.

      IN:             Void
      OUT:            Void
  --------------------------------------------------------------------------------------*/
  public void secondCallWebServiceASO() {
    String serviceName;
    String worklog;
    String worklogtype;
    String remedyGroupCode;
    String jsonInput;
    HttpResponse resp;
    Boolean respOk;
    if(this.operation.equalsIgnoreCase(SER_CallRemedyWS_Task_HELPERLGT.NEWREMEDY)) {     //add Comment And Attach after 'NewRemedy'
      //Comment
      if(this.sendLastCom == true) {
        worklog = this.generateAttachmentWorklog();
        worklogtype = '"attach"';
      } else {
        worklog = this.comment.remedyMessage;
        worklogtype = '"comment"';
      }
      System.debug('SC');
      System.debug(this.comment.newCommentParse);
      serviceName = SER_CallRemedyWS_Task_HELPERLGT.MODIFYTICKET2;
      jsonInput = '{'+
                  SER_CallRemedyWS_Task_HELPERLGT.CONSUMERID + ':"' + this.currentTask.Id + '",'+
                  SER_CallRemedyWS_Task_HELPERLGT.WORKLOGS_DESC + ':"' + worklog + '",' +
                  SER_CallRemedyWS_Task_HELPERLGT.WORKLOGS_TYPE + ':'+ worklogtype +
                  '}';

      System.debug('------ second call1 ------ jsoninput: ' + jsonInput);

      resp = MM_GBL_Integration_GenericService.invoke(serviceName,jsonInput);

      //reassign after update
    } else if(this.operation == SER_CallRemedyWS_Task_HELPERLGT.UPDATEREMEDY && SER_CallRemedyWS_Task_HELPERLGT.PROCESS_STATUS.contains(this.initTaskStatus)) {
      //preparacion parámetros de la Request
      serviceName = SER_CallRemedyWS_Task_HELPERLGT.MODIFYTICKET1;
      worklog = 'Case reasignado desde SALESFORCE.';
      if (this.currentTask.departament_name__c != this.KEEPDEPARTMENT) {
        remedyGroupCode = SER_RemedyGroupAssignment__c.getValues(this.currentTask.departament_name__c).SER_Id__c;
      }

      jsonInput = '{'+
                  SER_CallRemedyWS_Task_HELPERLGT.CONSUMERID + ':"' + this.currentTask.Id + '",'+
                  '"actionType":"reassign",'+
                  SER_CallRemedyWS_Task_HELPERLGT.WORKLOGS_DESC + ':"' + worklog + '",' +
                  SER_CallRemedyWS_Task_HELPERLGT.WORKLOGS_SUMMARY + SER_CallRemedyWS_Task_HELPERLGT.JSONBLANKVALUE +
                  SER_CallRemedyWS_Task_HELPERLGT.WORKLOGS_TYPE + SER_CallRemedyWS_Task_HELPERLGT.JSONBLANKVALUE +
                  SER_CallRemedyWS_Task_HELPERLGT.PRIORITYJSON + SER_CallRemedyWS_Task_HELPERLGT.JSONBLANKVALUE +
                  SER_CallRemedyWS_Task_HELPERLGT.IMPACT + SER_CallRemedyWS_Task_HELPERLGT.JSONBLANKVALUE +
                  SER_CallRemedyWS_Task_HELPERLGT.DESCRIPTION + SER_CallRemedyWS_Task_HELPERLGT.JSONBLANKVALUE +
                  SER_CallRemedyWS_Task_HELPERLGT.ASSIGNEE_ID + ':"' + remedyGroupCode + '"'+
                  '}';

      System.debug('------ second call2 ------ jsoninput: ' + jsonInput);

      resp = MM_GBL_Integration_GenericService.invoke(serviceName,jsonInput);
    }
    respOk = resp != null && String.isBlank(this.errorMsg);
    if (respOk) {
      if(String.isblank(this.errorMsg)) {
        this.errorMsg = 'Your ticket has been submitted';
      }
      finishCallWS(resp, false);
    }
  }

  /*--------------------------------------------------------------------------------------
      Company:        BBVA
      Description:    Method que se lanza despues de la llamada al WS que ejecuta update
                      del Caso de Salesforce para actualizar los campos

      IN:             HttpResponse resp
      OUT:            Void
  --------------------------------------------------------------------------------------*/
  private void finishCallWS(HttpResponse resp, Boolean isCloseBtn) {   //NOSONAR
    Map <String,Object> mapResp;
    mapResp = (Map<String, Object>) JSON.deserializeUntyped(resp.getBody());
    Boolean allOk;
    String errorMessage;
    allOk = resp.getStatusCode() == 200 && resp.getStatus() == 'OK';
    if (allOk == false && mapResp.get('error-message') != null) {
      errorMessage = mapResp.get('error-message').tostring() == null ? '' : mapResp.get('error-message').tostring();
      if (errorMessage.contains('El ID del Grupo Asignado no es correcto, o no está configurado para recibir Incidencias.')) {
        allOk = true;
      }
    }
    if (allOk) {
      this.responseWS = (String)mapResp.get('id');
      Boolean otherOperations;
      otherOperations = this.operation == SER_CallRemedyWS_Task_HELPERLGT.UPDATEREMEDY ||
                        this.operation == SER_CallRemedyWS_Task_HELPERLGT.SENDCOMMENT ||
                        this.operation == SER_CallRemedyWS_Task_HELPERLGT.SENDATTACHMENT;

      // actualizaciones en el Case de Salesforce una vez finaliza la llamada al WS correctamente, y segundas llamadas al WS
      if(otherOperations) {
        if (SER_CallRemedyWS_Task_HELPERLGT.PROCESS_STATUS.contains(this.currentTask.Status)) {
          this.currentTask.Status = SER_Constant.REMEDYSCALATED;
          if (this.operation == SER_CallRemedyWS_Task_HELPERLGT.UPDATEREMEDY && this.currentTask.departament_name__c != this.KEEPDEPARTMENT) {
              this.currentTask.department_correction_desc__c = '';
              this.currentTask.department_id__c = '';
          }
          this.currentTask.incidence_commitment_date__c = this.commitmentDate;
        }
        if(this.sendLastCom == false) {
          SER_CallRemedyWS_Task_HELPERLGT.insertNewTaskComment(this);
        }
        this.currentTask.departament_name__c = this.currentTask.departament_name__c == this.KEEPDEPARTMENT  ? this.originDepartment : this.currentTask.departament_name__c;
        update this.currentTask;
      } else if (this.operation.equalsIgnoreCase(SER_CallRemedyWS_Task_HELPERLGT.NEWREMEDY)) {
        this.currentTask.incidence_id__c = this.responseWS;
        this.currentTask.Status = SER_Constant.REMEDYSCALATED;
        update this.currentTask;
        if(this.sendLastCom == false) {
          SER_CallRemedyWS_Task_HELPERLGT.insertNewTaskComment(this);
        }
      } else if(this.operation.equalsIgnoreCase(SER_CallRemedyWS_Task_HELPERLGT.REOPENREMEDY)) {
        this.currentTask.open_closed_type__c = false;
        this.currentTask.Status = SER_Constant.REMEDYSCALATED;
        this.currentTask.department_correction_desc__c = '';
        this.currentTask.department_id__c = '';
        this.currentTask.incidence_commitment_date__c = this.commitmentDate;
        update this.currentTask;
        if(this.sendLastCom == false) {
          SER_CallRemedyWS_Task_HELPERLGT.insertNewTaskComment(this);
        }
      } else if(this.operation.equalsIgnoreCase(SER_CallRemedyWS_Task_HELPERLGT.CLAIMREMEDY)) {
        // Se añade un comentario en el caso indicando que se ha reclamado
        if(this.sendLastCom == false) {
          SER_CallRemedyWS_Task_HELPERLGT.insertNewTaskComment(this);
        }
      } else if(this.operation.equalsIgnoreCase(SER_CallRemedyWS_Task_HELPERLGT.CLOSEREMEDY) && !isCloseBtn) {
        TaskComment__c solution;
        solution = new TaskComment__c(Id = currentTask.TaskComment__c, gf_action_result_desc__c = this.currentTask.TaskComment__r.gf_action_result_desc__c);
        update solution;
        this.currentTask.open_closed_type__c = true;
        this.currentTask.Status = 'Completed';
        update this.currentTask;
        if(this.sendLastCom == false) {
          SER_CallRemedyWS_Task_HELPERLGT.insertNewTaskComment(this);
        }
      }
    } else {
      SER_CallRemedyWS_Task_HELPERLGT.remedyKO(this, mapResp,this.operation);
    }
  }

  /*---------------------------------------------------------------------------------------
      Company:       BBVA
      Description:   Method to retrieve attachment and files realted to the case
  ---------------------------------------------------------------------------------------*/
  public void retrieveFiles() {
    if(!this.currentTask.Attachments.isEmpty()) {
      this.lastAttachment = this.currentTask.Attachments.get(0);
    }
    final List<ContentDocumentLink> contDocLinks = new List<ContentDocumentLink>([select Id, LinkedEntityId, ContentDocumentId from ContentDocumentLink where LinkedEntityId = : this.currentTask.Id limit 1]);
    if(!contDocLinks.isEmpty()) {
      final ContentDocumentLink cdlink = contDocLinks.get(0);
      final List<ContentDocument> contentDocuments = new List<ContentDocument>([select Id, CreatedDate,title,FileType, contentsize,FileExtension from ContentDocument where Id = : cdlink.ContentDocumentId limit 1]);
      this.lastFile = contentDocuments.get(0);
    }
  }

  /*---------------------------------------------------------------------------------------
      Company:       BBVA
      Description:   Method to generate attachment and files realted to the case
  ---------------------------------------------------------------------------------------*/
  public String generateAttachmentWorklog() {
    String worklog;
    if(this.lastAttachment == null && this.lastFile == null) {
      worklog = '';
    } else if(this.lastAttachment != null) {     //NOSONAR
      if(this.lastFile != null && this.lastFile.createddate > this.lastAttachment.createddate) {
        worklog = 'Fichero añadido: \'' + this.lastFile.Title + '\' (' + this.lastFile.FileType + ' - ' + this.lastFile.ContentSize + ' bytes)';
      } else {
        worklog = 'Fichero añadido: \'' + this.lastAttachment.Name + '\' (' + this.lastAttachment.ContentType + ' - ' + this.lastAttachment.BodyLength + ' bytes)';
      }
    } else if (this.lastFile != null) {
      worklog = 'Fichero añadido: \'' + this.lastFile.Title + '\' (' + this.lastFile.FileType + ' - ' + this.lastFile.ContentSize + ' bytes)';
    }
    return worklog;
  }

  /*--------------------------------------------------------------------------------------
        Company:        BBVA
        Description:    Trae el ultimo comentario de la tarea.
  --------------------------------------------------------------------------------------*/
  @AuraEnabled
  public static List <TaskComment__c> getCommentario(String taskId) {
    List <TaskComment__c> listaComment;
    listaComment = new List<TaskComment__c>();
    try {
      if(String.isNotBlank(taskId)) {
        String query;
        query = 'SELECT gf_task_comment_body_desc__c FROM TaskComment__c WHERE ParentId__c = :taskId AND isRemedy__c = true order by CreatedDate desc limit 1 ';
        listaComment = database.query(query);
        system.debug('AQA - Query comment: ' + listaComment);
      }
    } catch(Exception exc) {
      system.debug('Error al traer el último comentario: ' + exc);
      String errorMessage;
      errorMessage = ' , StackTrace: ' + exc.getStackTraceString();
      throw new AuraHandledException(Label.SER_Error_Server + ' ' + exc + ' ' + errorMessage);
    }
    return listaComment;
  }


  /**************************************************************************************
  *******************                   WRAPPER                     *********************
  **************************************************************************************/

  /*--------------------------------------------------------------------------------------
      Company:        BBVA
      Description:    Clase interna con los comentarios del caso.
  --------------------------------------------------------------------------------------*/
  public class Comment {
    /*Comentario nuevo*/
    public String newComment {get; set;}    // used for Salesforce Insert new comment
    /*Ultimo comentario*/
    public String lastComment {get; set;}
    /*used for JSON request*/
    public String newCommentParse {get; set;}
    /*used for JSON request*/
    public String lastCommentParse {get; set;}
    /*used for JSON request*/
    public String descriptionParse {get; set;}
    /*used for JSON request*/
    public String remedyMessage {get; set;}
  }
}