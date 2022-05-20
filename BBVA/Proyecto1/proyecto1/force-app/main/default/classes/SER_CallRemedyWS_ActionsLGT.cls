/*
*    Company:       BBVA
*    Description:   Clase auxiliar de SER_CallRemedyWebServiceLGT.
*/
public with sharing class SER_CallRemedyWS_ActionsLGT {

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
  /*Comment max length*/
  private final Integer maxcommentlength = 3500;
  /*Message description max length*/
  private final String MESSAGESTRINGLONG = '...  DESCRIPCIÓN DEMASIADO LARGA, PARA ACCEDER AL CONTENIDO COMPLETO POR FAVOR ACCEDA A SALESFORCE';



  /*
  * @Description: se valida la operacion inicial.
  * @Params SER_CallRemedyWebServiceLGT wsClass
  * @Return String.
  */
  public static String validationInitOperation(SER_CallRemedyWebServiceLGT wsClass) {
    String initOperation = '';
    wsClass.retrieveFiles();
    Map<String,List<SelectOption> > statusOptMap;

    if (String.isBlank(wsClass.currentCase.SER_RemedyId__c)) {
      if(wsClass.currentCase.SER_Classification__c == SER_CallRemedyWS_HELPERLGT.INCIDENT) {
        statusOptMap = SER_CallRemedyWS_HELPERLGT.loadRMStatusOptions();
        wsClass.operationList.addAll(statusOptMap.get('New'));
        initOperation = SER_CallRemedyWS_HELPERLGT.NEWREMEDY;
      } else {      //si no es de tipo Incidencia mostramos un error
        wsClass.errorMsg = 'Only Incident cases can create a Remedy ticket.';
      }
    } else if(SER_CallRemedyWS_HELPERLGT.PROCESS_STATUS.contains(wsClass.currentCase.status) && wsClass.currentCase.status != 'Closed') {
      if(wsClass.currentCase.status.equalsIgnoreCase('Remedy - Escalated')) {
        SER_CallRemedyWS_HELPERLGT.checkDepartament(wsClass,'Modify 2');
      } else {
        SER_CallRemedyWS_HELPERLGT.checkDepartament(wsClass,'Modify 1');
      }
    } else if(wsClass.currentCase.status.equalsIgnoreCase('Closed')) {
      statusOptMap = SER_CallRemedyWS_HELPERLGT.loadRMStatusOptions();
      wsClass.operationList.addAll(statusOptMap.get('Reopen'));
      initOperation = SER_CallRemedyWS_HELPERLGT.REOPENREMEDY;
    } else if (wsClass.currentCase.status.equalsIgnoreCase(SER_CallRemedyWS_HELPERLGT.REMEDY_SCALATED)) {
      SER_CallRemedyWS_HELPERLGT.checkDepartament(wsClass,'Modify 2');
    } else if (wsClass.currentCase.status.equalsIgnoreCase('Transferred')) {
      SER_CallRemedyWS_HELPERLGT.checkDepartament(wsClass,'Modify 3');
    }

    return initOperation;
  }

  /*
  * @Description: Method to create a new ticket in remedy.
  * @Params SER_CallRemedyWebServiceLGT wsClass
  * @Return HttpResponse.
  */
  public HttpResponse creation(SER_CallRemedyWebServiceLGT wsClass) {
    HttpResponse resp;
    if(wsclass.comment.remedyMessage.length() > this.maxcommentlength) {
      wsClass.errorMsg = 'ERRORMax comment length reached, max length is 3500 characters';
    } else if(String.isNotBlank(wsClass.currentCase.SER_Remedy_Department__c)) {
      this.serviceName = 'NewTicketRemedy';
      this.priority = wsClass.formattedPriorityField();
      this.impact = this.priority;
      this.summary = 'Incidencia Procedente de SALESFORCE con Nº: ' + wsClass.currentCase.caseNumber;
      this.descrip = ( String.isBlank(wsClass.comment.descriptionParse) ? '-No hay descripción en SALESFORCE-' : wsClass.comment.descriptionParse);
      this.remedyGroupCode = SER_RemedyGroupAssignment__c.getValues(wsClass.currentCase.SER_Remedy_Department__c).SER_Id__c;

      String openingDate;
      openingDate = wsClass.currentCase.createdDate.format('yyyy-MM-dd') + 'T' + wsClass.currentCase.createdDate.format('HH:mm:ss');

      this.descrip = String.isNotBlank(this.descrip) && this.descrip.length() > this.maxcommentlength ? this.descrip.substring(0,3400)+this.MESSAGESTRINGLONG : this.descrip;
      
      this.jsonInput = '{'+
                        SER_CallRemedyWS_HELPERLGT.CONSUMERID + ':"' + wsClass.currentCase.caseNumber + '",'+
                        SER_CallRemedyWS_HELPERLGT.PRIORITYJSON + ':"' + this.priority + '",'+
                        SER_CallRemedyWS_HELPERLGT.IMPACT + ':"' + this.impact + '",'+
                        '"summary":"' + this.summary + '",'+
                        SER_CallRemedyWS_HELPERLGT.DESCRIPTION + ':"' + this.descrip + '",'+
                        SER_CallRemedyWS_HELPERLGT.ASSIGNEE_ID + ':"' + this.remedyGroupCode + '",'+
                        '"openingDate":"' + openingDate + '",'+
                        '"employee-code":"' + wsClass.employeeCode + '"'+
                        +'}';

      resp = MM_GBL_Integration_GenericService.invoke(this.serviceName,this.jsonInput);
      wsClass.errorMsg = 'Your ticket has been submitted';
    } else {
      wsClass.errorMsg = 'ERRORRemedy department must be completed.';
    }

    return resp;
  }

  /*
  * @Description: Method to close a ticket in remedy.
  * @Params SER_CallRemedyWebServiceLGT wsClass
  * @Return HttpResponse.
  */
  public HttpResponse close(SER_CallRemedyWebServiceLGT wsClass) {
    HttpResponse resp;
    if(wsclass.comment.remedyMessage.length() > this.maxcommentlength) {
      wsClass.errorMsg = 'ERRORMax comment length reached, max length is 3500 characters';
    } else if(String.isNotBlank(wsClass.currentCase.SER_Solution__c)) {
      this.serviceName = SER_CallRemedyWS_HELPERLGT.MODIFYTICKET1;
      if(!wsClass.sendLastCom && String.isNotBlank(wsClass.comment.newCommentParse)) {
        this.stWorkLog = wsClass.comment.remedyMessage;         //wsClass.parseJsonString(wsClass.comment.newComment);
      } else if(wsClass.sendLastCom
                && wsClass.lastCaseComment != null
                && String.isNotBlank(wsClass.comment.lastCommentParse)) {
        this.stWorkLog = wsClass.comment.remedyMessage;
      }
      if(String.isBlank(this.stWorkLog)) {
        this.stWorkLog = 'Case cerrado en SALESFORCE (no hay comentario de cierre)';
      }

      this.jsonInput = '{'+
                        SER_CallRemedyWS_HELPERLGT.CONSUMERID + ':"' + wsClass.currentCase.caseNumber + '",'+
                        '"actionType":"close",'+
                        SER_CallRemedyWS_HELPERLGT.WORKLOGS_DESC + ':"' + this.stWorkLog + '",' +
                        SER_CallRemedyWS_HELPERLGT.WORKLOGS_SUMMARY + ':"",'+
                        SER_CallRemedyWS_HELPERLGT.WORKLOGS_TYPE + ':"",'+
                        SER_CallRemedyWS_HELPERLGT.PRIORITYJSON + ':"",'+
                        SER_CallRemedyWS_HELPERLGT.IMPACT + ':"",'+
                        SER_CallRemedyWS_HELPERLGT.DESCRIPTION + ':"",'+
                        SER_CallRemedyWS_HELPERLGT.ASSIGNEE_ID + ':""'+
                        '}';

      resp = MM_GBL_Integration_GenericService.invoke(this.serviceName,this.jsonInput);
    } else {
      wsClass.errorMsg = 'ERRORSolution is mandatory in order to close the case.';
    }

    return resp;
  }

  /*
  * @Description: Method to update a ticket in remedy.
  * @Params SER_CallRemedyWebServiceLGT wsClass
  * @Return HttpResponse.
  */
  public HttpResponse updateRemedy(SER_CallRemedyWebServiceLGT wsClass) {
    HttpResponse resp;
    if(wsclass.comment.remedyMessage.length() > this.maxcommentlength) {
      wsClass.errorMsg = 'ERRORMax comment length reached, max length is 3500 characters';
    } else {
      /*Ultima comentario de remedy*/
      String lastCommentR;
      /*Tipo de el ultimo comentario*/
      String lastCommentType;
      /*Ultimo comentario*/
      String lastCommentS;        //lastCommentSummary

      this.serviceName = SER_CallRemedyWS_HELPERLGT.MODIFYTICKET1;
      this.priority = wsClass.formattedPriorityField();
      this.impact = this.priority;
      this.descrip = String.isBlank(wsClass.comment.descriptionParse) ? '-No hay descripción en SALESFORCE-' : wsClass.comment.descriptionParse;     // parseJsonString(this.currentCase.Description));

      if(!wsClass.sendLastCom && String.isNotBlank(wsClass.comment.newCommentParse)) {
        this.stWorkLog = wsClass.comment.remedyMessage;
      } else if(wsClass.sendLastCom && wsClass.lastCaseComment != null && String.isNotBlank(wsClass.comment.lastCommentParse)) {
        this.stWorkLog = wsClass.comment.remedyMessage;
      }
      this.stWorkLog = String.isBlank(this.stWorkLog) ? 'Caso actualizado en SALESFORCE.' : this.stWorkLog;

      lastCommentR = this.stWorkLog;
      lastCommentType = 'Customer Communication';
      lastCommentS = 'Modificada por SALESFORCE';

      this.descrip = String.isNotBlank(this.descrip) && this.descrip.length() > this.maxcommentlength ? this.descrip.substring(0,3400)+this.MESSAGESTRINGLONG : this.descrip;

      this.jsonInput = '{'+
                      SER_CallRemedyWS_HELPERLGT.CONSUMERID + ':"' + wsClass.currentCase.caseNumber + '",'+
                      '"actionType":"update",'+
                      SER_CallRemedyWS_HELPERLGT.WORKLOGS_DESC + ':"' + lastCommentR + '",' +
                      SER_CallRemedyWS_HELPERLGT.WORKLOGS_SUMMARY + ':"' + lastCommentS + '",'+
                      SER_CallRemedyWS_HELPERLGT.WORKLOGS_TYPE + ':"' + lastCommentType + '",'+
                      SER_CallRemedyWS_HELPERLGT.PRIORITYJSON + ':"' + this.priority + '",'+
                      SER_CallRemedyWS_HELPERLGT.IMPACT + ':"' + this.impact + '",'+
                      SER_CallRemedyWS_HELPERLGT.DESCRIPTION + ':"' + this.descrip + '",'+
                      SER_CallRemedyWS_HELPERLGT.ASSIGNEE_ID + ':""'+
                      '}';

      resp =  MM_GBL_Integration_GenericService.invoke(this.serviceName,this.jsonInput);
    }
    return resp;
  }

  /*
  * @Description: claimRemedy.
  * @Params SER_CallRemedyWebServiceLGT wsClass
  * @Return HttpResponse.
  */
  public HttpResponse claimRemady(SER_CallRemedyWebServiceLGT wsClass) {
    this.serviceName = SER_CallRemedyWS_HELPERLGT.MODIFYTICKET2;
    if(wsclass.comment.remedyMessage.length() > this.maxcommentlength) {
      wsClass.errorMsg = 'ERRORMax comment length reached, max length is 3500 characters';
    } else if(!wsClass.sendLastCom && String.isNotBlank(wsClass.comment.newCommentParse)) {
      this.stWorkLog = wsClass.comment.remedyMessage;
    } else if(wsClass.sendLastCom
              && wsClass.lastCaseComment != null
              && String.isNotBlank(wsClass.comment.lastCommentParse)) {
      this.stWorkLog = wsClass.comment.remedyMessage;
    }
    if(String.isBlank(this.stWorkLog)) {
      this.stWorkLog = 'Reclamación del caso por parte de SALESFORCE.';
    }

    this.jsonInput = '{'+
                      SER_CallRemedyWS_HELPERLGT.CONSUMERID + ':"' + wsClass.currentCase.caseNumber + '",'+
                      SER_CallRemedyWS_HELPERLGT.WORKLOGS_DESC + ':"' + this.stWorkLog + '",' +
                      SER_CallRemedyWS_HELPERLGT.WORKLOGS_TYPE + ':"claim"'+
                      '}';

    return MM_GBL_Integration_GenericService.invoke(this.serviceName,this.jsonInput);
  }

  /*
  * @Description: Method to add a comment to a ticket in remedy.
  * @Params SER_CallRemedyWebServiceLGT wsClass
  * @Return HttpResponse.
  */
  public HttpResponse addComment(SER_CallRemedyWebServiceLGT wsClass) {
    HttpResponse resp;
    Boolean condition1;
    condition1 = (!wsClass.sendLastCom && String.isBlank(wsClass.comment.newCommentParse)) ||
                  (wsClass.sendLastCom && (wsClass.lastCaseComment == null ||
                                          String.isBlank(wsClass.comment.lastCommentParse)));
    if(condition1) {
      System.debug('JCT --- THIS.Send LastComment: '+wsClass.sendLastCom);
      System.debug('JCT --- THIS.LastComment: '+wsClass.comment.lastCommentParse);
      System.debug('JCT --- THIS.CommentComment: '+wsClass.comment.newCommentParse);
      wsClass.errorMsg = 'ERRORThere is no comment.';
    } else if(wsclass.comment.remedyMessage.length() > this.maxcommentlength) {
      wsClass.errorMsg = 'ERRORMax comment length reached, max length is 3500 characters';
    } else {

      if(!wsClass.sendLastCom && String.isNotBlank(wsClass.comment.newCommentParse)) {
        this.stWorkLog = wsClass.comment.remedyMessage;
      } else if(wsClass.sendLastCom
                && wsClass.lastCaseComment != null
                && String.isNotBlank(wsClass.comment.lastCommentParse)) {
        this.stWorkLog = wsClass.comment.remedyMessage;
      }
      final Boolean condReasign = SER_CallRemedyWS_HELPERLGT.PROCESS_STATUS.contains(wsClass.currentCase.status)&& 'Remedy - Escalated'.equals(wsClass.currentCase.status) == false;
      if (condReasign) {
        //Envío de comentario y Reasignación
        this.serviceName = SER_CallRemedyWS_HELPERLGT.MODIFYTICKET1;
        this.remedyGroupCode = SER_RemedyGroupAssignment__c.getValues(wsClass.currentCase.SER_Remedy_Department__c).SER_Id__c;
        System.debug('JCT - CURRENTCASE : '+wsClass.currentCase);
        System.debug('JCT - LAST COMMENT : '+wsClass.comment.lastComment);
        System.debug('JCT - REMEDY GROUP CODE : '+ this.remedyGroupCode);
        this.jsonInput = '{'+
                          SER_CallRemedyWS_HELPERLGT.CONSUMERID + ':"' + wsClass.currentCase.caseNumber + '",'+
                          '"actionType":"reassign",'+
                          SER_CallRemedyWS_HELPERLGT.WORKLOGS_DESC + ':"' + this.stWorkLog + '",' +
                          SER_CallRemedyWS_HELPERLGT.WORKLOGS_SUMMARY + ':"",'+
                          SER_CallRemedyWS_HELPERLGT.WORKLOGS_TYPE + ':"",'+
                          SER_CallRemedyWS_HELPERLGT.PRIORITYJSON + ':"",'+
                          SER_CallRemedyWS_HELPERLGT.IMPACT + ':"",'+
                          SER_CallRemedyWS_HELPERLGT.DESCRIPTION + ':"",'+
                          SER_CallRemedyWS_HELPERLGT.ASSIGNEE_ID + ':"' + this.remedyGroupCode + '"'+
                          '}';

      } else {      //S��lo envío de comentario
        this.serviceName = SER_CallRemedyWS_HELPERLGT.MODIFYTICKET2;
        System.debug('JCT - RMDY Department : '+wsClass.currentCase.SER_Remedy_Department__c);
        this.jsonInput = '{'+
                          SER_CallRemedyWS_HELPERLGT.CONSUMERID + ':"' + wsClass.currentCase.caseNumber + '",'+
                          SER_CallRemedyWS_HELPERLGT.WORKLOGS_DESC + ':"' + this.stWorkLog + '",' +
                          SER_CallRemedyWS_HELPERLGT.WORKLOGS_TYPE + ':"comment"'+
                          '}';
      }

      resp = MM_GBL_Integration_GenericService.invoke(this.serviceName,this.jsonInput);
    }

    return resp;
  }

  /*
  * @Description: Method to add an attachment to a ticket in remedy.
  * @Params SER_CallRemedyWebServiceLGT wsClass
  * @Return HttpResponse.
  */
  public HttpResponse addattachment(SER_CallRemedyWebServiceLGT wsClass) {
    HttpResponse response;
    if (wsClass.lastAttachment == null && wsClass.lastFile == null) {
      wsClass.errorMsg = 'ERRORThere is no attachment.';
    } else if(wsclass.comment.remedyMessage.length() > this.maxcommentlength) {
      wsClass.errorMsg = 'ERRORMax comment length reached, max length is 3500 characters';
    } else {
      if(!wsClass.sendLastCom && String.isNotBlank(wsClass.comment.newCommentParse)) {
        this.stWorkLog = wsClass.comment.remedyMessage;
      } else if(wsClass.sendLastCom
                && wsClass.lastCaseComment != null
                && String.isNotBlank(wsClass.comment.lastCommentParse)) {
        this.stWorkLog = wsClass.comment.remedyMessage;
      } else {
        this.stWorkLog = 'Adjunto añadido al caso.';
      }

      if (SER_CallRemedyWS_HELPERLGT.PROCESS_STATUS.contains(wsClass.currentCase.status) && 'Remedy - Escalated'.equals(wsClass.currentCase.status) == false) {
        //Envío de comentario y Reasignación
        this.serviceName = SER_CallRemedyWS_HELPERLGT.MODIFYTICKET1;
        this.remedyGroupCode = SER_RemedyGroupAssignment__c.getValues(wsClass.currentCase.SER_Remedy_Department__c).SER_Id__c;
        this.jsonInput = '{'+
                          SER_CallRemedyWS_HELPERLGT.CONSUMERID + ':"' + wsClass.currentCase.caseNumber + '",'+
                          '"actionType":"reassign",'+
                          SER_CallRemedyWS_HELPERLGT.WORKLOGS_DESC + ':"' + this.stWorkLog + '",' +
                          SER_CallRemedyWS_HELPERLGT.WORKLOGS_SUMMARY + ':"",'+
                          SER_CallRemedyWS_HELPERLGT.WORKLOGS_TYPE + ':"",'+
                          SER_CallRemedyWS_HELPERLGT.PRIORITYJSON + ':"",'+
                          SER_CallRemedyWS_HELPERLGT.IMPACT + ':"",'+
                          SER_CallRemedyWS_HELPERLGT.DESCRIPTION + ':"",'+
                          SER_CallRemedyWS_HELPERLGT.ASSIGNEE_ID + ':"' + this.remedyGroupCode + '"'+
                          '}';

      } else {      //Sólo envío de comentario Attachment
        this.serviceName = SER_CallRemedyWS_HELPERLGT.MODIFYTICKET2;
        this.jsonInput = '{'+
                          SER_CallRemedyWS_HELPERLGT.CONSUMERID + ':"' + wsClass.currentCase.caseNumber + '",'+
                          SER_CallRemedyWS_HELPERLGT.WORKLOGS_DESC + ':"' + this.stWorkLog + '",' +
                          SER_CallRemedyWS_HELPERLGT.WORKLOGS_TYPE + ':"attach"'+
                          '}';

      }
      response = MM_GBL_Integration_GenericService.invoke(this.serviceName,this.jsonInput);
    }

    return response;
  }

  /*
  * @Description: Method to reopen a ticket in remedy.
  * @Params SER_CallRemedyWebServiceLGT wsClass
  * @Return HttpResponse.
  */
  public HttpResponse reopen(SER_CallRemedyWebServiceLGT wsClass) {
    HttpResponse resp;
    if(String.isBlank(wsClass.currentCase.SER_Remedy_Department__c)) {
      wsClass.errorMsg = 'ERRORRemedy Department must be completed.';
    } else if (!wsClass.sendLastCom && String.isBlank(wsClass.comment.newCommentParse)) {
      wsClass.errorMsg = 'ERRORComment Required.';
    } else if(wsclass.comment.remedyMessage.length() > this.maxcommentlength) {
      wsClass.errorMsg = 'ERRORMax comment length reached, max length is 3500 characters';
    } else if(String.isNotBlank(wsClass.currentCase.SER_Remedy_Department__c)) {
      this.serviceName = SER_CallRemedyWS_HELPERLGT.MODIFYTICKET1;
      final boolean isLastComment = !wsClass.sendLastCom && String.isNotBlank(wsClass.comment.newCommentParse);
      if(isLastComment) {
        this.stWorkLog = wsClass.comment.remedyMessage;
      } else if(wsClass.sendLastCom
                && wsClass.lastCaseComment != null
                && String.isNotBlank(wsClass.comment.lastCommentParse)) {
        this.stWorkLog = wsClass.comment.remedyMessage;
      }
      this.remedyGroupCode = SER_RemedyGroupAssignment__c.getValues(wsClass.currentCase.SER_Remedy_Department__c).SER_Id__c;

      this.jsonInput = '{'+
                        SER_CallRemedyWS_HELPERLGT.CONSUMERID + ':"' + wsClass.currentCase.caseNumber + '",'+
                        '"actionType":"reopen",'+
                        SER_CallRemedyWS_HELPERLGT.WORKLOGS_DESC + ':"' + this.stWorkLog + '",' +
                        SER_CallRemedyWS_HELPERLGT.WORKLOGS_SUMMARY + ':"",'+
                        SER_CallRemedyWS_HELPERLGT.WORKLOGS_TYPE + ':"",'+
                        SER_CallRemedyWS_HELPERLGT.PRIORITYJSON + ':"",'+
                        SER_CallRemedyWS_HELPERLGT.IMPACT + ':"",'+
                        SER_CallRemedyWS_HELPERLGT.DESCRIPTION + ':"",'+
                        SER_CallRemedyWS_HELPERLGT.ASSIGNEE_ID + ':"' + this.remedyGroupCode + '"'+
                        '}';


      resp = MM_GBL_Integration_GenericService.invoke(this.serviceName,this.jsonInput);
    }

    return resp;
  }


}