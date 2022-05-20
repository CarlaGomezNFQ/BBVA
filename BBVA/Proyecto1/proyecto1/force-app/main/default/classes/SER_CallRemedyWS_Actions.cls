/*
  *    Company:       BBVA
  *    Description:   Clase auxiliar de SER_CallRemedyWebService.
  */
public with sharing class SER_CallRemedyWS_Actions {

  /*Nombre de el servicio*/
  private String serviceName;
  /*Prioridad*/
  private String priority;
  /*Impacto*/
  private String impact;
  /*Sumario*/
  private String summary;
  /*Descripcion*/
  private String descrip;
  /*Codigo del grupo de remedy*/
  private String remedyGroupCode;
  /*Logs*/
  private String stWorkLog;
  /*Json de entrada*/
  private String jsonInput;



  /*
    * @Description: se valida la operacion inicial.
    * @Params SER_CallRemedyWebService wsClass
    * @Return String.
    */
  public static String validationInitOperation(SER_CallRemedyWebService wsClass) {
    String initOperation = '';
    wsClass.retrieveFiles();
    Map<String,List<SelectOption> > statusOptMap;

    if (String.isBlank(wsClass.currentCase.SER_RemedyId__c)) {
      if(wsClass.currentCase.SER_Classification__c == SER_CallRemedyWS_HELPER.INCIDENT) {
        statusOptMap = SER_CallRemedyWS_HELPER.loadRMStatusOptions();
        wsClass.operationList.addAll(statusOptMap.get('New'));
        initOperation = SER_CallRemedyWS_HELPER.NEWREMEDY;
      } else {      //si no es de tipo Incidencia mostramos un error
        wsClass.errorMsg = 'Only Incident cases can create a Remedy ticket.';
      }
    } else if(SER_CallRemedyWS_HELPER.PROCESS_STATUS.contains(wsClass.currentCase.status) && wsClass.currentCase.status != 'Closed') {
      SER_CallRemedyWS_HELPER.checkDepartament(wsClass,'Modify 1');
    } else if(wsClass.currentCase.status.equalsIgnoreCase('Closed')) {
      statusOptMap = SER_CallRemedyWS_HELPER.loadRMStatusOptions();
      wsClass.operationList.addAll(statusOptMap.get('Reopen'));
      initOperation = SER_CallRemedyWS_HELPER.REOPENREMEDY;
    } else if (wsClass.currentCase.status.equalsIgnoreCase(SER_CallRemedyWS_HELPER.REMEDY_SCALATED)) {
      SER_CallRemedyWS_HELPER.checkDepartament(wsClass,'Modify 2');
    } else if (wsClass.currentCase.status.equalsIgnoreCase('Transferred')) {
      SER_CallRemedyWS_HELPER.checkDepartament(wsClass,'Modify 3');
    }

    return initOperation;
  }

  /*
    * @Description: Method to create a new ticket in remedy.
    * @Params SER_CallRemedyWebService wsClass
    * @Return HttpResponse.
    */
  public HttpResponse creation(SER_CallRemedyWebService wsClass) {
    HttpResponse resp;
    if(String.isNotBlank(wsClass.currentCase.SER_Remedy_Department__c)) {
      this.serviceName = 'NewTicketRemedy';
      this.priority = wsClass.formattedPriorityField();
      this.impact = this.priority;
      this.summary = 'Incidencia Procedente de SALESFORCE con Nº: ' + wsClass.currentCase.caseNumber;
      this.descrip = ( String.isBlank(wsClass.comment.descriptionParse) ? '-No hay descripción en SALESFORCE-' : wsClass.comment.descriptionParse);
      this.remedyGroupCode = SER_RemedyGroupAssignment__c.getValues(wsClass.currentCase.SER_Remedy_Department__c).SER_Id__c;

      String openingDate;
      openingDate = wsClass.currentCase.createdDate.format('yyyy-MM-dd') + 'T' + wsClass.currentCase.createdDate.format('HH:mm:ss');

      this.jsonInput = '{' +
                        SER_CallRemedyWS_HELPER.CONSUMERID + ':"' + wsClass.currentCase.caseNumber + '",' +
                        SER_CallRemedyWS_HELPER.PRIORITYJSON + ':"' + this.priority + '",' +
                        SER_CallRemedyWS_HELPER.IMPACT + ':"' + this.impact + '",' +
                        '"summary":"' + this.summary + '",' +
                        SER_CallRemedyWS_HELPER.DESCRIPTION + ':"' + this.descrip + '",' +
                        SER_CallRemedyWS_HELPER.ASSIGNEE_ID + ':"' + this.remedyGroupCode + '",' +
                        '"openingDate":"' + openingDate + '",'+
                        '"employee-code":"' + wsClass.employeeCode + '"' +
                        +'}';

      resp = MM_GBL_Integration_GenericService.invoke(this.serviceName,this.jsonInput);
    } else {
      wsClass.errorMsg = 'Remedy department must be completed.';
    }

    return resp;
  }

  /*
    * @Description: Method to close a ticket in remedy.
    * @Params SER_CallRemedyWebService wsClass
    * @Return HttpResponse.
    */
  public HttpResponse close(SER_CallRemedyWebService wsClass) {
    HttpResponse resp;
    if(String.isNotBlank(wsClass.currentCase.SER_Solution__c)) {
      this.serviceName = SER_CallRemedyWS_HELPER.MODIFYTICKET1;
      if(!wsClass.sendLastCom && String.isNotBlank(wsClass.comment.newCommentParse)) {
        this.stWorkLog = wsClass.comment.newCommentParse;         //wsClass.parseJsonString(wsClass.comment.newComment);
      } else if(wsClass.sendLastCom
                && wsClass.lastCaseComment != null
                && String.isNotBlank(wsClass.comment.lastCommentParse)) {
        this.stWorkLog = wsClass.comment.lastCommentParse;
      }
      if(String.isBlank(this.stWorkLog)) {
        this.stWorkLog = 'Case cerrado en SALESFORCE (no hay comentario de cierre)';
      }

      this.jsonInput = '{' +
                        SER_CallRemedyWS_HELPER.CONSUMERID + ':"' + wsClass.currentCase.caseNumber + '",' +
                        '"actionType":"close",' +
                        SER_CallRemedyWS_HELPER.WORKLOGS_DESC + ':"' + this.stWorkLog + '",' +
                        SER_CallRemedyWS_HELPER.WORKLOGS_SUMMARY + SER_CallRemedyWS_HELPER.JSONBLANKVALUE +
                        SER_CallRemedyWS_HELPER.WORKLOGS_TYPE + SER_CallRemedyWS_HELPER.JSONBLANKVALUE +
                        SER_CallRemedyWS_HELPER.PRIORITYJSON + SER_CallRemedyWS_HELPER.JSONBLANKVALUE +
                        SER_CallRemedyWS_HELPER.IMPACT + SER_CallRemedyWS_HELPER.JSONBLANKVALUE +
                        SER_CallRemedyWS_HELPER.DESCRIPTION + SER_CallRemedyWS_HELPER.JSONBLANKVALUE +
                        SER_CallRemedyWS_HELPER.ASSIGNEE_ID + ':""' +
                        '}';

      resp = MM_GBL_Integration_GenericService.invoke(this.serviceName,this.jsonInput);
    } else {
      wsClass.errorMsg = 'Solution is mandatory in order to close the case.';
    }

    return resp;
  }

  /*
    * @Description: Method to update a ticket in remedy.
    * @Params SER_CallRemedyWebService wsClass
    * @Return HttpResponse.
    */
  public HttpResponse updateRemedy(SER_CallRemedyWebService wsClass) {

    /*Ultima comentario de remedy*/
    String lastCommentR;
    /*Tipo de el ultimo comentario*/
    String lastCommentType;
    /*Ultimo comentario*/
    String lastCommentS;    //lastCommentSummary

    this.serviceName = SER_CallRemedyWS_HELPER.MODIFYTICKET1;
    this.priority = wsClass.formattedPriorityField();
    this.impact = this.priority;
    this.descrip = String.isBlank(wsClass.comment.descriptionParse) ? '-No hay descripción en SALESFORCE-' : wsClass.comment.descriptionParse;     // parseJsonString(this.currentCase.Description));

    if(!wsClass.sendLastCom && String.isNotBlank(wsClass.comment.newCommentParse)) {
      this.stWorkLog = wsClass.comment.newCommentParse;
    } else if(wsClass.sendLastCom && wsClass.lastCaseComment != null && String.isNotBlank(wsClass.comment.lastCommentParse)) {
      this.stWorkLog = wsClass.comment.lastCommentParse;
    }

    if(String.isBlank(this.stWorkLog)) {
      this.stWorkLog = 'Case cerrado en SALESFORCE (no hay comentario de cierre)';
    }

    lastCommentR = this.stWorkLog;
    lastCommentType = 'Customer Communication';
    lastCommentS = 'Modificada por SALESFORCE';

    this.jsonInput = '{' +
                      SER_CallRemedyWS_HELPER.CONSUMERID + ':"' + wsClass.currentCase.caseNumber + '",' +
                      '"actionType":"update",' +
                      SER_CallRemedyWS_HELPER.WORKLOGS_DESC + ':"' + lastCommentR + '",' +
                      SER_CallRemedyWS_HELPER.WORKLOGS_SUMMARY + ':"' + lastCommentS + '",' +
                      SER_CallRemedyWS_HELPER.WORKLOGS_TYPE + ':"' + lastCommentType + '",' +
                      SER_CallRemedyWS_HELPER.PRIORITYJSON + ':"' + this.priority + '",' +
                      SER_CallRemedyWS_HELPER.IMPACT + ':"' + this.impact + '",' +
                      SER_CallRemedyWS_HELPER.DESCRIPTION + ':"' + this.descrip + '",' +
                      SER_CallRemedyWS_HELPER.ASSIGNEE_ID + ':""' +
                      '}';

    return MM_GBL_Integration_GenericService.invoke(this.serviceName,this.jsonInput);
  }

  /*
    * @Description: claimRemedy.
    * @Params SER_CallRemedyWebService wsClass
    * @Return HttpResponse.
    */
  public HttpResponse claimRemady(SER_CallRemedyWebService wsClass) {
    this.serviceName = SER_CallRemedyWS_HELPER.MODIFYTICKET2;
    if(!wsClass.sendLastCom && String.isNotBlank(wsClass.comment.newCommentParse)) {
      this.stWorkLog = wsClass.comment.newCommentParse;
    } else if(wsClass.sendLastCom
              && wsClass.lastCaseComment != null
              && String.isNotBlank(wsClass.comment.lastCommentParse)) {
      this.stWorkLog = wsClass.comment.lastCommentParse;
    }
    if(String.isBlank(this.stWorkLog)) {
      this.stWorkLog = 'Case cerrado en SALESFORCE (no hay comentario de cierre)';
    }

    this.jsonInput = '{'+
                      SER_CallRemedyWS_HELPER.CONSUMERID + ':"' + wsClass.currentCase.caseNumber + '",' +
                      SER_CallRemedyWS_HELPER.WORKLOGS_DESC + ':"' + this.stWorkLog + '",' +
                      SER_CallRemedyWS_HELPER.WORKLOGS_TYPE + ':"claim"' +
                      '}';

    return MM_GBL_Integration_GenericService.invoke(this.serviceName,this.jsonInput);
  }

  /*
    * @Description: Method to add a comment to a ticket in remedy.
    * @Params SER_CallRemedyWebService wsClass
    * @Return HttpResponse.
    */
  public HttpResponse addComment(SER_CallRemedyWebService wsClass) {
    HttpResponse resp;
    Boolean condition1;
    condition1 = (!wsClass.sendLastCom && String.isBlank(wsClass.comment.newCommentParse)) ||
                  (wsClass.sendLastCom && (wsClass.lastCaseComment == null ||
                                          String.isBlank(wsClass.comment.lastCommentParse)));
    if(condition1) {
      System.debug('JCT --- THIS.Send LastComment: '+wsClass.sendLastCom);
      System.debug('JCT --- THIS.LastComment: '+wsClass.comment.lastCommentParse);
      System.debug('JCT --- THIS.CommentComment: '+wsClass.comment.newCommentParse);
      wsClass.errorMsg = 'There is no comment.';
    } else {

      if(!wsClass.sendLastCom && String.isNotBlank(wsClass.comment.newCommentParse)) {
        this.stWorkLog = wsClass.comment.newCommentParse;
      } else if(wsClass.sendLastCom
                && wsClass.lastCaseComment != null
                && String.isNotBlank(wsClass.comment.lastCommentParse)) {
        this.stWorkLog = wsClass.comment.lastCommentParse;
      }

      if (SER_CallRemedyWS_HELPER.PROCESS_STATUS.contains(wsClass.currentCase.status)) {
        //Envío de comentario y Reasignación
        this.serviceName = SER_CallRemedyWS_HELPER.MODIFYTICKET1;
        this.remedyGroupCode = SER_RemedyGroupAssignment__c.getValues(wsClass.currentCase.SER_Remedy_Department__c).SER_Id__c;
        System.debug('JCT - CURRENTCASE : '+wsClass.currentCase);
        System.debug('JCT - LAST COMMENT : '+wsClass.comment.lastComment);
        System.debug('JCT - REMEDY GROUP CODE : '+ this.remedyGroupCode);
        this.jsonInput = '{' +
                          SER_CallRemedyWS_HELPER.CONSUMERID + ':"' + wsClass.currentCase.caseNumber + '",' +
                          '"actionType":"reassign",' +
                          SER_CallRemedyWS_HELPER.WORKLOGS_DESC + ':"' + this.stWorkLog + '",' +
                          SER_CallRemedyWS_HELPER.WORKLOGS_SUMMARY + SER_CallRemedyWS_HELPER.JSONBLANKVALUE +
                          SER_CallRemedyWS_HELPER.WORKLOGS_TYPE + SER_CallRemedyWS_HELPER.JSONBLANKVALUE +
                          SER_CallRemedyWS_HELPER.PRIORITYJSON + SER_CallRemedyWS_HELPER.JSONBLANKVALUE +
                          SER_CallRemedyWS_HELPER.IMPACT + SER_CallRemedyWS_HELPER.JSONBLANKVALUE +
                          SER_CallRemedyWS_HELPER.DESCRIPTION + SER_CallRemedyWS_HELPER.JSONBLANKVALUE +
                          SER_CallRemedyWS_HELPER.ASSIGNEE_ID + ':"' + this.remedyGroupCode + '"' +
                          '}';

      } else {      //Sólo envío de comentario
        this.serviceName = SER_CallRemedyWS_HELPER.MODIFYTICKET2;
        System.debug('JCT - RMDY Department : '+ wsClass.currentCase.SER_Remedy_Department__c);
        this.jsonInput = '{' +
                          SER_CallRemedyWS_HELPER.CONSUMERID + ':"' + wsClass.currentCase.caseNumber + '",' +
                          SER_CallRemedyWS_HELPER.WORKLOGS_DESC + ':"' + this.stWorkLog + '",' +
                          SER_CallRemedyWS_HELPER.WORKLOGS_TYPE + ':"comment"' +
                          '}';
      }

      resp = MM_GBL_Integration_GenericService.invoke(this.serviceName,this.jsonInput);
    }

    return resp;
  }

  /*
    * @Description: Method to add an attachment to a ticket in remedy.
    * @Params SER_CallRemedyWebService wsClass
    * @Return HttpResponse.
    */
  public HttpResponse addattachment(SER_CallRemedyWebService wsClass) {
    HttpResponse response;
    if (wsClass.lastAttachment == null && wsClass.lastFile == null) {
      wsClass.errorMsg = 'There is no attachment.';
    } else {
      if(!wsClass.sendLastCom && String.isNotBlank(wsClass.comment.newCommentParse)) {
        this.stWorkLog = wsClass.comment.newCommentParse;
      } else if(wsClass.sendLastCom
                && wsClass.lastCaseComment != null
                && String.isNotBlank(wsClass.comment.lastCommentParse)) {
        this.stWorkLog = wsClass.comment.lastCommentParse;
      }

      if (SER_CallRemedyWS_HELPER.PROCESS_STATUS.contains(wsClass.currentCase.status)) {
        //Envío de comentario y Reasignación
        this.serviceName = SER_CallRemedyWS_HELPER.MODIFYTICKET1;
        this.remedyGroupCode = SER_RemedyGroupAssignment__c.getValues(wsClass.currentCase.SER_Remedy_Department__c).SER_Id__c;
        this.jsonInput = '{'+
                          SER_CallRemedyWS_HELPER.CONSUMERID + ':"' + wsClass.currentCase.caseNumber + '",' +
                          '"actionType":"reassign",' +
                          SER_CallRemedyWS_HELPER.WORKLOGS_DESC + ':"' + this.stWorkLog + '",' +
                          SER_CallRemedyWS_HELPER.WORKLOGS_SUMMARY + SER_CallRemedyWS_HELPER.JSONBLANKVALUE +
                          SER_CallRemedyWS_HELPER.WORKLOGS_TYPE + SER_CallRemedyWS_HELPER.JSONBLANKVALUE +
                          SER_CallRemedyWS_HELPER.PRIORITYJSON + SER_CallRemedyWS_HELPER.JSONBLANKVALUE +
                          SER_CallRemedyWS_HELPER.IMPACT + SER_CallRemedyWS_HELPER.JSONBLANKVALUE +
                          SER_CallRemedyWS_HELPER.DESCRIPTION + SER_CallRemedyWS_HELPER.JSONBLANKVALUE +
                          SER_CallRemedyWS_HELPER.ASSIGNEE_ID + ':"' + this.remedyGroupCode + '"' +
                          '}';

      } else {      //Sólo envío de comentario Attachment
        this.serviceName = SER_CallRemedyWS_HELPER.MODIFYTICKET2;
        this.jsonInput = '{' +
                          SER_CallRemedyWS_HELPER.CONSUMERID + ':"' + wsClass.currentCase.caseNumber + '",' +
                          SER_CallRemedyWS_HELPER.WORKLOGS_DESC + ':"' + this.stWorkLog + '",' +
                          SER_CallRemedyWS_HELPER.WORKLOGS_TYPE + ':"attach"' +
                          '}';

      }
      response = MM_GBL_Integration_GenericService.invoke(this.serviceName,this.jsonInput);
    }

    return response;
  }

  /*
    * @Description: Method to reopen a ticket in remedy.
    * @Params SER_CallRemedyWebService wsClass
    * @Return HttpResponse.
    */
  public HttpResponse reopen(SER_CallRemedyWebService wsClass) {
    HttpResponse resp;
    if(String.isNotBlank(wsClass.currentCase.SER_Remedy_Department__c)) {
      this.serviceName = SER_CallRemedyWS_HELPER.MODIFYTICKET1;
      if(!wsClass.sendLastCom && String.isNotBlank(wsClass.comment.newCommentParse)) {
        this.stWorkLog = wsClass.comment.newCommentParse;
      } else if(wsClass.sendLastCom
                && wsClass.lastCaseComment != null
                && String.isNotBlank(wsClass.comment.lastCommentParse)) {
        this.stWorkLog = wsClass.comment.lastCommentParse;
      }
      this.remedyGroupCode = SER_RemedyGroupAssignment__c.getValues(wsClass.currentCase.SER_Remedy_Department__c).SER_Id__c;

      this.jsonInput = '{' +
                        SER_CallRemedyWS_HELPER.CONSUMERID + ':"' + wsClass.currentCase.caseNumber + '",' +
                        '"actionType":"reopen",' +
                        SER_CallRemedyWS_HELPER.WORKLOGS_DESC + ':"' + this.stWorkLog + '",' +
                        SER_CallRemedyWS_HELPER.WORKLOGS_SUMMARY + SER_CallRemedyWS_HELPER.JSONBLANKVALUE +
                        SER_CallRemedyWS_HELPER.WORKLOGS_TYPE + SER_CallRemedyWS_HELPER.JSONBLANKVALUE +
                        SER_CallRemedyWS_HELPER.PRIORITYJSON + SER_CallRemedyWS_HELPER.JSONBLANKVALUE +
                        SER_CallRemedyWS_HELPER.IMPACT + SER_CallRemedyWS_HELPER.JSONBLANKVALUE +
                        SER_CallRemedyWS_HELPER.DESCRIPTION + SER_CallRemedyWS_HELPER.JSONBLANKVALUE +
                        SER_CallRemedyWS_HELPER.ASSIGNEE_ID + ':"' + this.remedyGroupCode + '"' +
                        '}';

      resp = MM_GBL_Integration_GenericService.invoke(this.serviceName,this.jsonInput);
    } else {
      wsClass.errorMsg = 'Remedy Department must be completed.';
    }

    return resp;
  }
}