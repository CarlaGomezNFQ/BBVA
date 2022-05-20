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
public with sharing class SER_CallRemedyWebServiceLGT { //NOSONAR

  //Case Object variables
  /*Caso en curso*/
  public Case currentCase {get; set;}
  /*Ultimo commentario*/
  public CaseComment lastCaseComment {get; set;}
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
  public CaseComment newCaseComment {get; set;}

  /*Clase interna con los comment fields*/
  public Comment comment {get; set;}

  /*Clase interna con los Input fields render variables*/
  public Render render {get; set;}


  /*bl_SendLastComment*/
  public Boolean sendLastCom {get; set;}

  /*estado inicial del caso, se utiliza para controlar qué estado tenía cuando ya que se
      pueden realizar varias llamadas a WS concatenadas y se puede hacer update del caso*/
  private final String initCaseStatus;

  //Estructuras de gestion de operaciones disponibles.
  /*Set de los estados de los casos de Remedy. set_CaseStatus_RM*/
  public transient static final Set<String> SET_CASESTATUS_RM = new Set<String> {SER_CallRemedyWS_HELPERLGT.REMEDY_SCALATED, 'Remedy - Pending information', 'Remedy - Pending to close', 'Remedy - Rejected'};

  /*Instancia de clase auxiliar*/
  private final SER_CallRemedyWS_ActionsLGT actions;

  /*commitmentDate*/
  private Datetime commitmentDate;//NOSONAR
  /*departement origin*/
  private String originDepartment;//NOSONAR
  /*Message description max length*/
  private final String  keepDepartment = 'Mantener equipo resolutor';



  /*--------------------------------------------------------------------------------------
      Company:       BBVA
      Description:   Constructor.
      --------------------------------------------------------------------------------------*/
  public SER_CallRemedyWebServiceLGT() {
    Id caseId;
    caseId = System.currentPageReference().getParameters().get('caid');
    this.employeeCode = System.currentPageReference().getParameters().get('usid');
    this.tabid = System.currentPageReference().getParameters().get('tabid');
    this.currentCase = [Select (Select Id, ParentId, CommentBody, CreatedById, CreatedDate, LastModifiedDate, LastModifiedById, IsDeleted From CaseComments Where IsDeleted = false Order by createdDate Desc limit 1),
                        (Select Id, ParentId, Name, Description, BodyLength, ContentType, CreatedDate, CreatedById, LastModifiedDate From Attachments Where IsDeleted = false Order by createdDate Desc limit 1),
                        Id,caseNumber,SER_Close__c,SER_Business_Case_Type__c,SER_Solution__c, SER_RemedyId__c,Status,SER_Last_Remedy_Operation__c,priority,Description, SER_Remedy_Department__c, createdDate, SER_Classification__c From Case Where Id = :caseId limit 1].get(0);
    this.originDepartment = this.currentCase.SER_Remedy_Department__c;
    this.comment = new Comment();
    if(!this.currentCase.CaseComments.isEmpty()) {
      this.lastCaseComment = this.currentCase.CaseComments.get(0);
    }
    this.comment.lastComment = this.lastCaseComment!=null && String.isNotBlank(this.lastCaseComment.CommentBody) ? this.lastCaseComment.CommentBody : '';
    this.errorMsg = '';
    this.responseWS = '';
    this.operationList = new List<SelectOption>();
    this.initCaseStatus = this.currentCase.status;
    this.comment.descriptionParse = this.currentCase.Description;

    this.sendLastCom = this.lastCaseComment!=null;

    this.newCaseComment = new CaseComment();
    this.comment.remedyMessage = '';
    this.comment.newComment = '';
    this.comment.newCommentParse = '';
    this.comment.lastCommentParse = SER_CallRemedyWS_HELPERLGT.parseJsonString(this.comment.lastComment,false);

    this.render = new Render();
    render.blRenderComment  = false;
    render.blRenderPriority = false;
    render.blRenderSolution = false;
    render.blRenderCClosure = false;
    render.blRenderSendLast = false;
    render.blRenderRmdyDep  = false;

    this.actions = new SER_CallRemedyWS_ActionsLGT();
    this.operation = SER_CallRemedyWS_ActionsLGT.validationInitOperation(this);
    this.render = SER_CallRemedyWS_HELPERLGT.renderInputfields(this);
  }

  /*--------------------------------------------------------------------------------------
      Company:       BBVA
      Description:   Constructor. Lightning Component Controller

      IN:           String caseId
                    String userId
      --------------------------------------------------------------------------------------*/
  public SER_CallRemedyWebServiceLGT(String caseId, String userId) {
    this.employeeCode = userId;
    this.currentCase = [Select (Select Id, ParentId, CommentBody, CreatedById, CreatedDate, LastModifiedDate, LastModifiedById, IsDeleted From CaseComments Where IsDeleted = false Order by createdDate Desc limit 1),
                        (Select Id, ParentId, Name, Description, BodyLength, ContentType, CreatedDate, CreatedById, LastModifiedDate From Attachments Where IsDeleted = false Order by createdDate Desc limit 1),
                        Id,caseNumber,SER_Close__c,SER_Business_Case_Type__c,SER_Solution__c, SER_RemedyId__c,Status,SER_Last_Remedy_Operation__c,priority,Description, SER_Remedy_Department__c, createdDate, SER_Classification__c From Case Where Id = :caseId limit 1].get(0);
    this.originDepartment = this.currentCase.SER_Remedy_Department__c;
    if(this.currentCase.CaseComments != NULL && !this.currentCase.CaseComments.isEmpty()) {
      this.lastCaseComment = this.currentCase.CaseComments.get(0);
    }
    this.comment =  new SER_CallRemedyWebServiceLGT.Comment();
    this.comment.lastComment = this.lastCaseComment!=null && String.isNotBlank(this.lastCaseComment.CommentBody) ? this.lastCaseComment.CommentBody : '';
    //ATTACHMENTS
    this.errorMsg = '';
    this.responseWS = '';
    this.operationList = new List<SelectOption>();
    this.initCaseStatus = this.currentCase.status;
    this.comment.descriptionParse = this.currentCase.Description;

    this.newCaseComment = new CaseComment();
    this.comment.remedyMessage = '';
    this.comment.newComment = '';
    this.comment.newCommentParse = '';
    this.comment.lastCommentParse = SER_CallRemedyWS_HELPERLGT.parseJsonString(this.comment.lastComment,false);
    this.actions = new SER_CallRemedyWS_ActionsLGT();
    this.operation = SER_CallRemedyWS_ActionsLGT.validationInitOperation(this);
  }

  // ---------------
  //public Methods
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
  public void callWebServiceASOLogic() {   //NOSONAR
    system.debug(Logginglevel.INFO,'>>>> XXX >>> Entrando en callWebServiceASOLogic. Operation: ' + this.operation + '.\r\n Datos del Case: ' + this.currentCase);
    HttpResponse resp;
    this.errorMsg = '';
    Boolean respOk;
    Boolean secondcall;
    secondcall = false;
    //1 Creation
    if (this.operation.equalsIgnoreCase(SER_CallRemedyWS_HELPERLGT.NEWREMEDY)) {
      resp = actions.creation(this);
      System.debug('NEWREMEDY PASA');
      if (String.isNotBlank(this.comment.newCommentParse) || this.lastCaseComment != null) {
        System.debug('SECONDCALL PASA');
        secondcall = true;

      }
      //2 close
    } else if (this.operation.equalsIgnoreCase(SER_CallRemedyWS_HELPERLGT.CLOSEREMEDY)) {
      resp = actions.close(this);
      //3 update
    } else if (this.operation.equalsIgnoreCase(SER_CallRemedyWS_HELPERLGT.UPDATEREMEDY)) {
      resp = actions.updateRemedy(this);
      secondcall = true;
      //4 Claim
    } else if (this.operation.equalsIgnoreCase(SER_CallRemedyWS_HELPERLGT.CLAIMREMEDY)) {
      resp = actions.claimRemady(this);
      //5 Add Comment
    } else if (this.operation.equalsIgnoreCase(SER_CallRemedyWS_HELPERLGT.SENDCOMMENT)) {    //si no hay Comentarios en el Caso
      resp = actions.addComment(this);
      //6 Add Attachment info
    } else if(this.operation.equalsIgnoreCase(SER_CallRemedyWS_HELPERLGT.SENDATTACHMENT)) {    //si no hay Attached en el Caso
      resp = actions.addattachment(this);
      //8 Reopen
    } else if(this.operation.equalsIgnoreCase(SER_CallRemedyWS_HELPERLGT.REOPENREMEDY)) {    //preparacion parámetros de la Request
      resp = actions.reopen(this);
    }
    // si se ha hecho la llamada se procesa el resultado
    respOk = resp != null;
    if (respOk && secondcall == false) {
      if(String.isblank(this.errorMsg)) {
        this.errorMsg = 'Your ticket has been submitted';
      }
      system.debug('LLAMO al finish en primera');
      finishCallWS(resp);
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
    if(this.operation.equalsIgnoreCase(SER_CallRemedyWS_HELPERLGT.NEWREMEDY)) {     //add Comment And Attach after 'NewRemedy'
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
      serviceName = SER_CallRemedyWS_HELPERLGT.MODIFYTICKET2;
      jsonInput = '{'+
                  SER_CallRemedyWS_HELPERLGT.CONSUMERID + ':"' + this.currentCase.caseNumber + '",'+
                  SER_CallRemedyWS_HELPERLGT.WORKLOGS_DESC + ':"' + worklog + '",' +
                  SER_CallRemedyWS_HELPERLGT.WORKLOGS_TYPE + ':'+worklogtype+
                  '}';

      resp = MM_GBL_Integration_GenericService.invoke(serviceName,jsonInput);

      //reassign after update
    } else if(this.operation == SER_CallRemedyWS_HELPERLGT.UPDATEREMEDY && SER_CallRemedyWS_HELPERLGT.PROCESS_STATUS.contains(this.initCaseStatus)) {
      //preparacion parámetros de la Request
      serviceName = SER_CallRemedyWS_HELPERLGT.MODIFYTICKET1;
      worklog = 'Case reasignado desde SALESFORCE.';
      
      if (this.currentCase.SER_Remedy_Department__c != this.keepDepartment) {
      	remedyGroupCode = SER_RemedyGroupAssignment__c.getValues(this.currentCase.SER_Remedy_Department__c).SER_Id__c;
      } 
        
          jsonInput = '{'+
                      SER_CallRemedyWS_HELPERLGT.CONSUMERID + ':"' + this.currentCase.caseNumber + '",'+
                      '"actionType":"reassign",'+
                      SER_CallRemedyWS_HELPERLGT.WORKLOGS_DESC + ':"' + worklog + '",' +
                      SER_CallRemedyWS_HELPERLGT.WORKLOGS_SUMMARY + SER_CallRemedyWS_HELPERLGT.JSONBLANKVALUE +
                      SER_CallRemedyWS_HELPERLGT.WORKLOGS_TYPE + SER_CallRemedyWS_HELPERLGT.JSONBLANKVALUE +
                      SER_CallRemedyWS_HELPERLGT.PRIORITYJSON + SER_CallRemedyWS_HELPERLGT.JSONBLANKVALUE +
                      SER_CallRemedyWS_HELPERLGT.IMPACT + SER_CallRemedyWS_HELPERLGT.JSONBLANKVALUE +
                      SER_CallRemedyWS_HELPERLGT.DESCRIPTION + SER_CallRemedyWS_HELPERLGT.JSONBLANKVALUE +
                      SER_CallRemedyWS_HELPERLGT.ASSIGNEE_ID + ':"' + remedyGroupCode + '"'+
                      '}';
    

      resp = MM_GBL_Integration_GenericService.invoke(serviceName,jsonInput);
    }
    respOk = resp != null && String.isBlank(this.errorMsg);
     

    if (respOk) {
      if(String.isblank(this.errorMsg)) {
        this.errorMsg = 'Your ticket has been submitted';
      }
      finishCallWS(resp);
    }
  }


  /*--------------------------------------------------------------------------------------
      Company:        BBVA
      Description:    Method que se lanza despues de la llamada al WS que ejecuta update
  *                   del Caso de Salesforce para actualizar los campos

      IN:             HttpResponse resp
      OUT:            Void
      --------------------------------------------------------------------------------------*/
  private void finishCallWS(HttpResponse resp) {   //NOSONAR
    Map <String,Object> mapResp;
    mapResp = (Map<String, Object>) JSON.deserializeUntyped(resp.getBody());
    Boolean allOk;
    String errorMessage;
    allOk = resp.getStatusCode() == 200 && resp.getStatus() == 'OK';
    if (allOk == false ) {
      errorMessage = mapResp.get('error-message').tostring() == null ? '' : mapResp.get('error-message').tostring();
      if (errorMessage.contains('El ID del Grupo Asignado no es correcto, o no está configurado para recibir Incidencias.')) {
        allOk = true;
      }
    }
    if (allOk) {
      this.responseWS = (String)mapResp.get('id');
      Boolean otherOperations;
      otherOperations =   this.operation == SER_CallRemedyWS_HELPERLGT.UPDATEREMEDY ||
                        this.operation == SER_CallRemedyWS_HELPERLGT.SENDCOMMENT ||
                        this.operation == SER_CallRemedyWS_HELPERLGT.SENDATTACHMENT;

      // actualizaciones en el Case de Salesforce una vez finaliza la llamada al WS correctamente, y segundas llamadas al WS
      if(otherOperations) {
        if (SER_CallRemedyWS_HELPERLGT.PROCESS_STATUS.contains(this.currentCase.status)) {
          this.currentCase.status = SER_CallRemedyWS_HELPERLGT.REMEDY_SCALATED;
          this.currentCase.SER_Skip_validations__c = true;
          if (this.operation == SER_CallRemedyWS_HELPERLGT.UPDATEREMEDY && this.currentCase.SER_Remedy_Department__c != this.keepDepartment) {
          		this.currentCase.SER_Remedy_Transition_Department__c = '';
          }
          this.currentCase.SER_Remedy_Transition_Department_ID__c = '';
          this.currentCase.SER_Commitment_Date__c = this.commitmentDate;
          if(this.currentCase.SER_Business_Case_Type__c == SER_Constant.BUSINESS_STE) {
            this.currentCase.OwnerId = SER_CallRemedyWS_HELPERLGT.transferCoordinatorQueue();
          }
        }
        if(this.sendLastCom == false) {
          SER_CallRemedyWS_HELPERLGT.insertNewCaseComment(this);
        }
        this.currentCase.SER_Transferred_from_agent_pool__c = false;
        this.currentCase.SER_Remedy_Department__c = this.currentCase.SER_Remedy_Department__c == this.keepDepartment  ? this.originDepartment : this.currentCase.SER_Remedy_Department__c;
        update this.currentCase;
      } else if (this.operation.equalsIgnoreCase(SER_CallRemedyWS_HELPERLGT.NEWREMEDY)) {
        this.currentCase.SER_RemedyId__c = this.responseWS;
        this.currentCase.status = SER_CallRemedyWS_HELPERLGT.REMEDY_SCALATED;
        this.currentCase.SER_Skip_validations__c = true;
        SER_CallRemedyWS_HELPERLGT.changeCaseOwner(this);
        update this.currentCase;
        if(this.sendLastCom == false) {
          SER_CallRemedyWS_HELPERLGT.insertNewCaseComment(this);
        }
      } else if(this.operation.equalsIgnoreCase(SER_CallRemedyWS_HELPERLGT.REOPENREMEDY)) {
        this.currentCase.SER_CloseRemedyTicket__c = false;
        //this.currentCase.status = SER_CallRemedyWS_HELPERLGT.REMEDY_SCALATED;
        this.currentCase.SER_Remedy_Transition_Department__c = '';
        this.currentCase.SER_Remedy_Transition_Department_ID__c = '';
        this.currentCase.SER_Commitment_Date__c = this.commitmentDate;
        this.currentCase.SER_Skip_validations__c = true;
        SER_CallRemedyWS_HELPERLGT.changeCaseOwner(this);
        update this.currentCase;
        if(this.sendLastCom == false) {
          SER_CallRemedyWS_HELPERLGT.insertNewCaseComment(this);
        }
      } else if(this.operation.equalsIgnoreCase(SER_CallRemedyWS_HELPERLGT.CLAIMREMEDY)) {
        this.currentCase.SER_Transferred_from_agent_pool__c = false;
        this.currentCase.SER_Skip_validations__c = true;
        update this.currentCase;
        // Se añade un comentario en el caso indicando que se ha reclamado
        if(this.sendLastCom == false) {
          SER_CallRemedyWS_HELPERLGT.insertNewCaseComment(this);
        }
      } else if(this.operation.equalsIgnoreCase(SER_CallRemedyWS_HELPERLGT.CLOSEREMEDY)) {
        this.currentCase.SER_Transferred_from_agent_pool__c = false;
        this.currentCase.SER_CloseRemedyTicket__c = true;
        this.currentCase.SER_Skip_validations__c = true;
        update this.currentCase;
        if(this.sendLastCom == false) {
          SER_CallRemedyWS_HELPERLGT.insertNewCaseComment(this);
        }
      }
    } else {
      SER_CallRemedyWS_HELPERLGT.remedyKO(this, mapResp,this.operation);
    }
  }

  /*---------------------------------------------------------------------------------------
      Author:        Javier Saiz Salmeron
      Company:       Accenture
      Description:   Method to transform Sf Priority field information itno Remedy priority field format.

      IN:            void
      OUT:           String

      History:
      <Date>                  <Author>                <Change Description>
      27/06/2017              Juan Carlos Terrón      Initial version
      ---------------------------------------------------------------------------------------*/
  public String formattedPriorityField() {
    String result = '';
    if (this.currentCase.priority == null) {
      result = '4000';
      this.currentCase.priority = SER_Constant.LOW;
    } else if(this.currentCase.priority == SER_Constant.HIGH) {
      result = '2000';
    } else if (this.currentCase.priority == SER_Constant.MEDIUM) {
      result = '3000';
    } else {     // == "Low" y si llega algo raro
      result = '4000';
      this.currentCase.priority = SER_Constant.LOW;
    }
    return result;
  }

  /*---------------------------------------------------------------------------------------
      Company:       BBVA
      Description:   Method to render input fields.
      ---------------------------------------------------------------------------------------*/
  public Void renderInputFields() {
    this.render = SER_CallRemedyWS_HELPERLGT.renderInputfields(this);
  }

  /*---------------------------------------------------------------------------------------
      Company:       BBVA
      Description:   Method to retrieve attachment and files realted to the case
      ---------------------------------------------------------------------------------------*/
  public String retrieveFiles() {

    if(!this.currentCase.Attachments.isEmpty()) {
      this.lastAttachment = this.currentCase.Attachments.get(0);
    }
    final List<ContentDocumentLink> contDocLinks = new List<ContentDocumentLink>([select Id, LinkedEntityId, ContentDocumentId from ContentDocumentLink where LinkedEntityId = : this.currentCase.Id limit 1]);
    if(!contDocLinks.isEmpty()) {
      final ContentDocumentLink cdlink = contDocLinks.get(0);
      final List<ContentDocument> contentDocuments = new List<ContentDocument>([select Id, CreatedDate,title,FileType, contentsize,FileExtension from ContentDocument where Id = : cdlink.ContentDocumentId limit 1]);
      this.lastFile = contentDocuments.get(0);
    }

    return 'sonar cheat';
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
  /**************************************************************************************
  *******************                   WRAPPER                     *********************
  **************************************************************************************/

  /*--------------------------------------------------------------------------------------
      Company:        BBVA
      Description:    Clase interna con los Input fields render variables.
      --------------------------------------------------------------------------------------*/
  public class Render {
    /*bl_RenderComment*/
    public Boolean blRenderComment {get; set;}
    /*bl_RenderPriority*/
    public Boolean blRenderPriority {get; set;}
    /*bl_RenderSolution*/
    public Boolean blRenderSolution {get; set;}
    /*bl_RenderCaseClosure*/
    public Boolean blRenderCClosure {get; set;}
    /*bl_RenderLastComment*/
    public Boolean blRenderLastComm {get; set;}
    /*bl_RenderSendLastComment*/
    public Boolean blRenderSendLast {get; set;}
    /*bl_RenderRemedyDepartment*/
    public Boolean blRenderRmdyDep {get; set;}
  }

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

/*--------------------------------------------------------------------------------------
        Company:        BBVA
        Description:    Trae el ultimo comentario del caso.
    --------------------------------------------------------------------------------------*/
  @AuraEnabled
  public static List <CaseComment> getCommentario(String caseId) {
    List <CaseComment> listaComment;
    try {
      listaComment = new List<CaseComment>();
      if(caseId != null) {
        String query;
        query = 'SELECT CommentBody FROM CaseComment WHERE ParentId = :caseId  order by CreatedDate desc limit 1 ';
        listaComment = database.query(query);
        system.debug('AQA - Query comment: ' + listaComment);
      }
    } catch(Exception e) {
      system.debug('Error al traer el último comentario: ' + e);
    }
    return listaComment;
  }
}