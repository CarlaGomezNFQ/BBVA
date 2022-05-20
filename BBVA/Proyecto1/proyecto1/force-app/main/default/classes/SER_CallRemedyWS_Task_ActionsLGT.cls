/*
*    Company:       BBVA
*    Description:   Clase auxiliar de SER_CallRemedyWebServiceLGT_Task.
*/
public with sharing class SER_CallRemedyWS_Task_ActionsLGT {

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
  /*Constant Comment max length*/
  public final Integer MAXCOMMENTLENGTH = 3500;
  /*Constant Message description max length*/
  public final String MESSAGESTRINGLONG = '...  DESCRIPCIÓN DEMASIADO LARGA, PARA ACCEDER AL CONTENIDO COMPLETO POR FAVOR ACCEDA A SALESFORCE';
  /*Constant Message description max length*/
  public final String LENGTHERROR  = 'ERRORMax comment length reached, max length is 3500 characters';


  /*
  * @Description: se valida la operacion inicial.
  * @Params SER_CallRemedyWebServiceLGT_Task wsClass
  * @Return String.
  */
  public static String validationInitOperation(SER_CallRemedyWebServiceLGT_Task wsClass) {
    String initOperation = '';
    wsClass.retrieveFiles();
    Map<String,List<SelectOption> > statusOptMap;

    if (String.isBlank(wsClass.currentTask.incidence_id__c)) {
      if(wsClass.currentCase.SER_Classification__c == SER_CallRemedyWS_Task_HELPERLGT.INCIDENT) {
        statusOptMap = SER_CallRemedyWS_Task_HELPERLGT.loadRMStatusOptions();
        wsClass.operationList.addAll(statusOptMap.get('New'));
        initOperation = SER_CallRemedyWS_Task_HELPERLGT.NEWREMEDY;
      } else {      //si no es de tipo Incidencia mostramos un error
        wsClass.errorMsg = 'ERROROnly Incident cases can create a Remedy ticket.';
      }
    } else if(SER_CallRemedyWS_Task_HELPERLGT.PROCESS_STATUS.contains(wsClass.currentTask.Status) && wsClass.currentTask.Status != 'Completed') {
      if(wsClass.currentTask.Status.equalsIgnoreCase(SER_Constant.REMEDYSCALATED)) {
        SER_CallRemedyWS_Task_HELPERLGT.checkDepartament(wsClass,'Modify 2');
      } else {
        SER_CallRemedyWS_Task_HELPERLGT.checkDepartament(wsClass,'Modify 1');
      }
    } else if(wsClass.currentTask.Status.equalsIgnoreCase('Completed')) {
      statusOptMap = SER_CallRemedyWS_Task_HELPERLGT.loadRMStatusOptions();
      wsClass.operationList.addAll(statusOptMap.get('Reopen'));
      initOperation = SER_CallRemedyWS_Task_HELPERLGT.REOPENREMEDY;
    }
    return initOperation;
  }

  /*
  * @Description: Method to create a new ticket in remedy.
  * @Params SER_CallRemedyWebServiceLGT_Task wsClass
  * @Return HttpResponse.
  */
  public HttpResponse creation(SER_CallRemedyWebServiceLGT_Task wsClass) {
    HttpResponse resp;
    if(wsclass.comment.remedyMessage.length() > this.MAXCOMMENTLENGTH) {
      wsClass.errorMsg = LENGTHERROR;
    } else if(String.isNotBlank(wsClass.currentTask.departament_name__c)) {
      this.serviceName = 'NewTicketRemedy';
      this.priority = SER_CallRemedyWS_Task_HELPERLGT.formattedPriorityField(wsClass.currentTask);
      this.impact = this.priority;
      this.summary = 'Incidencia Procedente de SALESFORCE con Nº CASO: ' + wsClass.currentCase.caseNumber + ' Y Nº TAREA: ' + wsClass.currentTask.gf_task_id__c;
      this.descrip = (String.isBlank(wsClass.comment.descriptionParse) ? '-No hay descripción en SALESFORCE-' : wsClass.comment.descriptionParse);
      this.descrip = String.isNotBlank(this.descrip) && this.descrip.length() > this.MAXCOMMENTLENGTH ? this.descrip.substring(0,3400)+this.MESSAGESTRINGLONG : this.descrip;
      this.remedyGroupCode = SER_RemedyGroupAssignment__c.getValues(wsClass.currentTask.departament_name__c).SER_Id__c;

      String openingDate;
      openingDate = wsClass.currentTask.createdDate.format('yyyy-MM-dd') + 'T' + wsClass.currentTask.createdDate.format('HH:mm:ss');

      this.jsonInput = '{'+
                        SER_CallRemedyWS_Task_HELPERLGT.CONSUMERID + ':"' + wsClass.currentTask.Id + '",'+
                        SER_CallRemedyWS_Task_HELPERLGT.PRIORITYJSON + ':"' + this.priority + '",'+
                        SER_CallRemedyWS_Task_HELPERLGT.IMPACT + ':"' + this.impact + '",'+
                        '"summary":"' + this.summary + '",'+
                        SER_CallRemedyWS_Task_HELPERLGT.DESCRIPTION + ':"' + this.descrip + '",'+
                        SER_CallRemedyWS_Task_HELPERLGT.ASSIGNEE_ID + ':"' + this.remedyGroupCode + '",'+
                        '"openingDate":"' + openingDate + '",'+
                        '"employee-code":"' + wsClass.employeeCode + '",'+
                        '"area":"Europa-España"' +
                        '}';

      System.debug('------ creation ------ jsoninput: ' + jsonInput);

      resp = MM_GBL_Integration_GenericService.invoke(this.serviceName,this.jsonInput);
      wsClass.errorMsg = 'Your ticket has been submitted';
    } else {
      wsClass.errorMsg = 'ERRORRemedy department must be completed.';
    }
    return resp;
  }

  /*
  * @Description: Method to close a ticket in remedy.
  * @Params SER_CallRemedyWebServiceLGT_Task wsClass
  * @Return HttpResponse.
  */
  public HttpResponse close(SER_CallRemedyWebServiceLGT_Task wsClass) {
    HttpResponse resp;
    if(wsclass.comment.remedyMessage.length() > this.MAXCOMMENTLENGTH) {
      wsClass.errorMsg = LENGTHERROR;
    } else if(String.isNotBlank(wsClass.currentTask.TaskComment__r.gf_action_result_desc__c)) {
      this.serviceName = SER_CallRemedyWS_Task_HELPERLGT.MODIFYTICKET1;
      fillstWorkLog(wsClass, 'Case cerrado en SALESFORCE (no hay comentario de cierre)');

      this.jsonInput = '{'+
                        SER_CallRemedyWS_Task_HELPERLGT.CONSUMERID + ':"' + wsClass.currentTask.Id + '",'+
                        '"actionType":"close",'+
                        SER_CallRemedyWS_Task_HELPERLGT.WORKLOGS_DESC + ':"' + this.stWorkLog + '",' +
                        SER_CallRemedyWS_Task_HELPERLGT.WORKLOGS_SUMMARY + SER_CallRemedyWS_Task_HELPERLGT.JSONBLANKVALUE+
                        SER_CallRemedyWS_Task_HELPERLGT.WORKLOGS_TYPE + SER_CallRemedyWS_Task_HELPERLGT.JSONBLANKVALUE+
                        SER_CallRemedyWS_Task_HELPERLGT.PRIORITYJSON + SER_CallRemedyWS_Task_HELPERLGT.JSONBLANKVALUE+
                        SER_CallRemedyWS_Task_HELPERLGT.IMPACT + SER_CallRemedyWS_Task_HELPERLGT.JSONBLANKVALUE+
                        SER_CallRemedyWS_Task_HELPERLGT.DESCRIPTION + SER_CallRemedyWS_Task_HELPERLGT.JSONBLANKVALUE+
                        SER_CallRemedyWS_Task_HELPERLGT.ASSIGNEE_ID + ':""'+
                        '}';

      System.debug('------ close ------ jsoninput: ' + jsonInput);

      resp = MM_GBL_Integration_GenericService.invoke(this.serviceName,this.jsonInput);
    } else {
      wsClass.errorMsg = 'ERRORSolution is mandatory in order to close the case.';
    }
    return resp;
  }

  /*
  * @Description: Method to update a ticket in remedy.
  * @Params SER_CallRemedyWebServiceLGT_Task wsClass
  * @Return HttpResponse.
  */
  public HttpResponse updateRemedy(SER_CallRemedyWebServiceLGT_Task wsClass) {
    HttpResponse resp;
    if(wsclass.comment.remedyMessage.length() > this.MAXCOMMENTLENGTH) {
      wsClass.errorMsg = LENGTHERROR;
    } else {
      /*Ultima comentario de remedy*/
      String lastCommentR;
      /*Tipo de el ultimo comentario*/
      String lastCommentType;
      /*Ultimo comentario*/
      String lastCommentS;        //lastCommentSummary

      this.serviceName = SER_CallRemedyWS_Task_HELPERLGT.MODIFYTICKET1;
      this.priority = SER_CallRemedyWS_Task_HELPERLGT.formattedPriorityField(wsClass.currentTask);
      this.impact = this.priority;
      this.descrip = String.isBlank(wsClass.comment.descriptionParse) ? '-No hay descripción en SALESFORCE-' : wsClass.comment.descriptionParse;     // parseJsonString(this.currentCase.Description));
      this.descrip = String.isNotBlank(this.descrip) && this.descrip.length() > this.MAXCOMMENTLENGTH ? this.descrip.substring(0,3400)+this.MESSAGESTRINGLONG : this.descrip;
      fillstWorkLog(wsClass, 'Caso actualizado en SALESFORCE.');
      lastCommentR = this.stWorkLog;
      lastCommentType = 'Customer Communication';
      lastCommentS = 'Modificada por SALESFORCE';

      this.jsonInput = '{'+
                      SER_CallRemedyWS_Task_HELPERLGT.CONSUMERID + ':"' + wsClass.currentTask.Id + '",'+
                      '"actionType":"update",'+
                      SER_CallRemedyWS_Task_HELPERLGT.WORKLOGS_DESC + ':"' + lastCommentR + '",' +
                      SER_CallRemedyWS_Task_HELPERLGT.WORKLOGS_SUMMARY + ':"' + lastCommentS + '",'+
                      SER_CallRemedyWS_Task_HELPERLGT.WORKLOGS_TYPE + ':"' + lastCommentType + '",'+
                      SER_CallRemedyWS_Task_HELPERLGT.PRIORITYJSON + ':"' + this.priority + '",'+
                      SER_CallRemedyWS_Task_HELPERLGT.IMPACT + ':"' + this.impact + '",'+
                      SER_CallRemedyWS_Task_HELPERLGT.DESCRIPTION + ':"' + this.descrip + '",'+
                      SER_CallRemedyWS_Task_HELPERLGT.ASSIGNEE_ID + ':""'+
                      '}';

      System.debug('------ updateRemedy ------ jsoninput: ' + jsonInput);

      resp =  MM_GBL_Integration_GenericService.invoke(this.serviceName,this.jsonInput);
    }
    return resp;
  }

  /*
  * @Description: claimRemedy.
  * @Params SER_CallRemedyWebServiceLGT_Task wsClass
  * @Return HttpResponse.
  */
  public HttpResponse claimRemady(SER_CallRemedyWebServiceLGT_Task wsClass) {
    HttpResponse resp;
    this.serviceName = SER_CallRemedyWS_Task_HELPERLGT.MODIFYTICKET2;
    if(wsclass.comment.remedyMessage.length() > this.MAXCOMMENTLENGTH) {
      wsClass.errorMsg = LENGTHERROR;
    } else if(!wsClass.sendLastCom && String.isNotBlank(wsClass.comment.newCommentParse)) {
      this.stWorkLog = wsClass.comment.remedyMessage;
    } else if(wsClass.sendLastCom
              && wsClass.lastTaskComment != null
              && String.isNotBlank(wsClass.comment.lastCommentParse)) {
      this.stWorkLog = wsClass.comment.remedyMessage;
    }
    if(String.isBlank(this.stWorkLog)) {
      this.stWorkLog = 'Reclamación del caso por parte de SALESFORCE.';
    }
    if(String.isBlank(wsClass.errorMsg)) {
      this.jsonInput = '{'+
                        SER_CallRemedyWS_Task_HELPERLGT.CONSUMERID + ':"' + wsClass.currentTask.Id + '",'+
                        SER_CallRemedyWS_Task_HELPERLGT.WORKLOGS_DESC + ':"' + this.stWorkLog + '",' +
                        SER_CallRemedyWS_Task_HELPERLGT.WORKLOGS_TYPE + ':"claim"'+
                        '}';

      System.debug('------ claimRemady ------ jsoninput: ' + jsonInput);

      resp = MM_GBL_Integration_GenericService.invoke(this.serviceName,this.jsonInput);
    }
    return resp;
  }

  /*
  * @Description: Method to add a comment to a ticket in remedy.
  * @Params SER_CallRemedyWebServiceLGT_Task wsClass
  * @Return HttpResponse.
  */
  public HttpResponse addComment(SER_CallRemedyWebServiceLGT_Task wsClass) {
    HttpResponse resp;
    Boolean condition1;
    condition1 = (!wsClass.sendLastCom && String.isBlank(wsClass.comment.newCommentParse)) ||
                  (wsClass.sendLastCom && (wsClass.lastTaskComment == null ||
                                          String.isBlank(wsClass.comment.lastCommentParse)));
    if(condition1) {
      System.debug('JCT --- THIS.Send LastComment: ' + wsClass.sendLastCom);
      System.debug('JCT --- THIS.LastComment: ' + wsClass.comment.lastCommentParse);
      System.debug('JCT --- THIS.CommentComment: ' + wsClass.comment.newCommentParse);
      wsClass.errorMsg = 'ERRORThere is no comment.';
    } else if(wsclass.comment.remedyMessage.length() > this.MAXCOMMENTLENGTH) {
      wsClass.errorMsg = LENGTHERROR;
    } else {
      if(!wsClass.sendLastCom && String.isNotBlank(wsClass.comment.newCommentParse)) {
        this.stWorkLog = wsClass.comment.remedyMessage;
      } else if(wsClass.sendLastCom
                && wsClass.lastTaskComment != null
                && String.isNotBlank(wsClass.comment.lastCommentParse)) {
        this.stWorkLog = wsClass.comment.remedyMessage;
      }
      final Boolean condReasign = SER_CallRemedyWS_Task_HELPERLGT.PROCESS_STATUS.contains(wsClass.currentTask.Status) && SER_Constant.REMEDYSCALATED.equals(wsClass.currentTask.Status) == false;
      if (condReasign) {
        //Envío de comentario y Reasignación
        this.serviceName = SER_CallRemedyWS_Task_HELPERLGT.MODIFYTICKET1;
        this.remedyGroupCode = SER_RemedyGroupAssignment__c.getValues(wsClass.currentTask.departament_name__c).SER_Id__c;
        System.debug('JCT - CURRENTCASE : '+wsClass.currentCase);
        System.debug('JCT - CURRENTTASK : '+wsClass.currentTask);
        System.debug('JCT - LAST COMMENT : '+wsClass.comment.lastComment);
        System.debug('JCT - REMEDY GROUP CODE : '+ this.remedyGroupCode);
        this.jsonInput = '{'+
                          SER_CallRemedyWS_Task_HELPERLGT.CONSUMERID + ':"' + wsClass.currentTask.Id + '",'+
                          '"actionType":"reassign",'+
                          SER_CallRemedyWS_Task_HELPERLGT.WORKLOGS_DESC + ':"' + this.stWorkLog + '",' +
                          SER_CallRemedyWS_Task_HELPERLGT.WORKLOGS_SUMMARY + SER_CallRemedyWS_Task_HELPERLGT.JSONBLANKVALUE+
                          SER_CallRemedyWS_Task_HELPERLGT.WORKLOGS_TYPE + SER_CallRemedyWS_Task_HELPERLGT.JSONBLANKVALUE+
                          SER_CallRemedyWS_Task_HELPERLGT.PRIORITYJSON + SER_CallRemedyWS_Task_HELPERLGT.JSONBLANKVALUE+
                          SER_CallRemedyWS_Task_HELPERLGT.IMPACT + SER_CallRemedyWS_Task_HELPERLGT.JSONBLANKVALUE+
                          SER_CallRemedyWS_Task_HELPERLGT.DESCRIPTION + SER_CallRemedyWS_Task_HELPERLGT.JSONBLANKVALUE+
                          SER_CallRemedyWS_Task_HELPERLGT.ASSIGNEE_ID + ':"' + this.remedyGroupCode + '"'+
                          '}';

        System.debug('------ addComment1 ------ jsoninput: ' + jsonInput);
      } else {      //S��lo envío de comentario
        this.serviceName = SER_CallRemedyWS_Task_HELPERLGT.MODIFYTICKET2;
        System.debug('JCT - RMDY Department : '+wsClass.currentTask.departament_name__c);
        this.jsonInput = '{'+
                          SER_CallRemedyWS_Task_HELPERLGT.CONSUMERID + ':"' + wsClass.currentTask.Id + '",'+
                          SER_CallRemedyWS_Task_HELPERLGT.WORKLOGS_DESC + ':"' + this.stWorkLog + '",' +
                          SER_CallRemedyWS_Task_HELPERLGT.WORKLOGS_TYPE + ':"comment"'+
                          '}';

        System.debug('------ addComment2 ------ jsoninput: ' + jsonInput);
      }
      resp = MM_GBL_Integration_GenericService.invoke(this.serviceName,this.jsonInput);
    }
    return resp;
  }

  /*
  * @Description: Method to add an attachment to a ticket in remedy.
  * @Params SER_CallRemedyWebServiceLGT_Task wsClass
  * @Return HttpResponse.
  */
  public HttpResponse addattachment(SER_CallRemedyWebServiceLGT_Task wsClass) {
    HttpResponse response;
    Boolean noAttachment;
    noAttachment = wsClass.lastAttachment == null && wsClass.lastFile == null;
    if (noAttachment) {
      wsClass.errorMsg = 'ERRORThere is no attachment.';
    } else if(wsclass.comment.remedyMessage.length() > this.MAXCOMMENTLENGTH) {
      wsClass.errorMsg = LENGTHERROR;
    } else {
      Boolean newComment;
      newComment = !wsClass.sendLastCom && String.isNotBlank(wsClass.comment.newCommentParse);
      Boolean lastComment;
      lastComment = wsClass.sendLastCom
                    && wsClass.lastTaskComment != null
                    && String.isNotBlank(wsClass.comment.lastCommentParse);
      if(newComment) {
        this.stWorkLog = wsClass.comment.remedyMessage;
      } else if(lastComment) {
        this.stWorkLog = wsClass.comment.remedyMessage;
      } else {
        this.stWorkLog = 'Adjunto añadido al caso.';
      }

      Boolean otherStatus;
      otherStatus = SER_CallRemedyWS_Task_HELPERLGT.PROCESS_STATUS.contains(wsClass.currentTask.Status) && SER_Constant.REMEDYSCALATED.equals(wsClass.currentTask.Status) == false;
      if (otherStatus) {
        //Envío de comentario y Reasignación
        this.serviceName = SER_CallRemedyWS_Task_HELPERLGT.MODIFYTICKET1;
        this.remedyGroupCode = SER_RemedyGroupAssignment__c.getValues(wsClass.currentTask.departament_name__c).SER_Id__c;
        this.jsonInput = '{'+
                          SER_CallRemedyWS_Task_HELPERLGT.CONSUMERID + ':"' + wsClass.currentTask.Id + '",'+
                          '"actionType":"reassign",'+
                          SER_CallRemedyWS_Task_HELPERLGT.WORKLOGS_DESC + ':"' + this.stWorkLog + '",' +
                          SER_CallRemedyWS_Task_HELPERLGT.WORKLOGS_SUMMARY + SER_CallRemedyWS_Task_HELPERLGT.JSONBLANKVALUE+
                          SER_CallRemedyWS_Task_HELPERLGT.WORKLOGS_TYPE + SER_CallRemedyWS_Task_HELPERLGT.JSONBLANKVALUE+
                          SER_CallRemedyWS_Task_HELPERLGT.PRIORITYJSON + SER_CallRemedyWS_Task_HELPERLGT.JSONBLANKVALUE+
                          SER_CallRemedyWS_Task_HELPERLGT.IMPACT + SER_CallRemedyWS_Task_HELPERLGT.JSONBLANKVALUE+
                          SER_CallRemedyWS_Task_HELPERLGT.DESCRIPTION + SER_CallRemedyWS_Task_HELPERLGT.JSONBLANKVALUE+
                          SER_CallRemedyWS_Task_HELPERLGT.ASSIGNEE_ID + ':"' + this.remedyGroupCode + '"'+
                          '}';

        System.debug('------ addattachment1 ------ jsoninput: ' + jsonInput);
      } else {      //Sólo envío de comentario Attachment
        this.serviceName = SER_CallRemedyWS_Task_HELPERLGT.MODIFYTICKET2;
        this.jsonInput = '{'+
                          SER_CallRemedyWS_Task_HELPERLGT.CONSUMERID + ':"' + wsClass.currentTask.Id + '",'+
                          SER_CallRemedyWS_Task_HELPERLGT.WORKLOGS_DESC + ':"' + this.stWorkLog + '",' +
                          SER_CallRemedyWS_Task_HELPERLGT.WORKLOGS_TYPE + ':"attach"'+
                          '}';

        System.debug('------ addattachment2 ------ jsoninput: ' + jsonInput);
      }
      response = MM_GBL_Integration_GenericService.invoke(this.serviceName,this.jsonInput);
    }
    return response;
  }

  /*
  * @Description: Method to reopen a ticket in remedy.
  * @Params SER_CallRemedyWebServiceLGT_Task wsClass
  * @Return HttpResponse.
  */
  public HttpResponse reopen(SER_CallRemedyWebServiceLGT_Task wsClass) {
    HttpResponse resp;
    if(String.isBlank(wsClass.currentTask.departament_name__c)) {
      wsClass.errorMsg = 'ERRORRemedy Department must be completed.';
    } else if (!wsClass.sendLastCom && String.isBlank(wsClass.comment.newCommentParse)) {
      wsClass.errorMsg = 'ERRORComment Required.';
    } else if(wsclass.comment.remedyMessage.length() > this.MAXCOMMENTLENGTH) {
      wsClass.errorMsg = LENGTHERROR;
    } else if(String.isNotBlank(wsClass.currentTask.departament_name__c)) {
      this.serviceName = SER_CallRemedyWS_Task_HELPERLGT.MODIFYTICKET1;
      boolean newComment;
      newComment = !wsClass.sendLastCom && String.isNotBlank(wsClass.comment.newCommentParse);
      Boolean lastComment;
      lastComment = wsClass.sendLastCom
                    && wsClass.lastTaskComment != null
                    && String.isNotBlank(wsClass.comment.lastCommentParse);
      if(newComment) {
        this.stWorkLog = wsClass.comment.remedyMessage;
      } else if(lastComment) {
        this.stWorkLog = wsClass.comment.remedyMessage;
      }
      this.remedyGroupCode = SER_RemedyGroupAssignment__c.getValues(wsClass.currentTask.departament_name__c).SER_Id__c;

      this.jsonInput = '{'+
                        SER_CallRemedyWS_Task_HELPERLGT.CONSUMERID + ':"' + wsClass.currentTask.Id + '",'+
                        '"actionType":"reopen",'+
                        SER_CallRemedyWS_Task_HELPERLGT.WORKLOGS_DESC + ':"' + this.stWorkLog + '",' +
                        SER_CallRemedyWS_Task_HELPERLGT.WORKLOGS_SUMMARY + SER_CallRemedyWS_Task_HELPERLGT.JSONBLANKVALUE+
                        SER_CallRemedyWS_Task_HELPERLGT.WORKLOGS_TYPE + SER_CallRemedyWS_Task_HELPERLGT.JSONBLANKVALUE+
                        SER_CallRemedyWS_Task_HELPERLGT.PRIORITYJSON + SER_CallRemedyWS_Task_HELPERLGT.JSONBLANKVALUE+
                        SER_CallRemedyWS_Task_HELPERLGT.IMPACT + SER_CallRemedyWS_Task_HELPERLGT.JSONBLANKVALUE+
                        SER_CallRemedyWS_Task_HELPERLGT.DESCRIPTION + SER_CallRemedyWS_Task_HELPERLGT.JSONBLANKVALUE+
                        SER_CallRemedyWS_Task_HELPERLGT.ASSIGNEE_ID + ':"' + this.remedyGroupCode + '"'+
                        '}';

      System.debug('------ reopen ------ jsoninput: ' + jsonInput);

      resp = MM_GBL_Integration_GenericService.invoke(this.serviceName,this.jsonInput);
    }
    return resp;
  }

  /*
  * @Description: fillstWorkLog.
  * @Params SER_CallRemedyWebServiceLGT_Task wsClass
  * @Return Void.
  */
  private void fillstWorkLog(SER_CallRemedyWebServiceLGT_Task wsClass, String message) {
      Boolean isNewComment;
      isNewComment = !wsClass.sendLastCom && String.isNotBlank(wsClass.comment.newCommentParse);
      Boolean isLastComment;
      isLastComment = wsClass.sendLastCom && wsClass.lastTaskComment != null && String.isNotBlank(wsClass.comment.lastCommentParse);
      if(isNewComment) {
        this.stWorkLog = wsClass.comment.remedyMessage;
      } else if(isLastComment) {
        this.stWorkLog = wsClass.comment.remedyMessage;
      }
      this.stWorkLog = String.isBlank(this.stWorkLog) ? message : this.stWorkLog;
  }
}