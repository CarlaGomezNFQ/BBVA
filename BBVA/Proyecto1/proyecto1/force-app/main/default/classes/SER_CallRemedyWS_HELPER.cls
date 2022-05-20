/*---------------------------------------------------------------------------------------
    Company:       BBVA
    Description:   Clase auxiliar de SER_CallRemedyWebService.

    History:
    <Date>                  <Author>                <Change Description>
    13/12/2018           Javier Touchard            Initial version(SONAR).
---------------------------------------------------------------------------------------*/
public with sharing class SER_CallRemedyWS_HELPER {

  /*****************OPEREACIONES*****************/
  /**Constante 'comment'*/
  public static final String COMMENT = 'comment';
  /**Constante 'priority'*/
  public static final String PRIORITY = 'priority';
  /**Constante 'caseclosure'*/
  public static final String CASECLOSURE = 'caseclosure';
  /**Constante 'solution'*/
  public static final String SOLUTION = 'solution';
  /**Constante 'lastcomment'*/
  public static final String LASTCOMMENT = 'lastcomment';
  /**Constante 'sendlastcomment*/
  public static final String SENDLASTCOMMENT = 'sendlastcomment';
  /**Constante 'remedydepartment'*/
  public static final String REMEDYDEPARTAMENT = 'remedydepartment';
  /**Constante 'Reopen Remedy'*/
  public static final String REOPENREMEDY = 'Reopen Remedy';
  /**Constante 'Send Attachment'*/
  public static final String SENDATTACHMENT = 'Send Attachment';
  /**Constante 'Send Comment'*/
  public static final String SENDCOMMENT = 'Send Comment';
  /**Constante 'Claim Remedy'*/
  public static final String CLAIMREMEDY = 'Claim Remedy';
  /**Constante 'Update Remedy'*/
  public static final String UPDATEREMEDY = 'Update Remedy';
  /**Constante 'Close Remedy'*/
  public static final String CLOSEREMEDY = 'Close Remedy';
  /**Constante 'New Remedy'*/
  public static final String NEWREMEDY = 'New Remedy';
  /***************FIN OPEREACIONES***************/

  /*****************SERVICE NAME*****************/
  /**Constante 'ModifyTicketRemedy_1'*/
  public static final String MODIFYTICKET1 = 'ModifyTicketRemedy_1';
  /**Constante 'ModifyTicketRemedy_2'*/
  public static final String MODIFYTICKET2 = 'ModifyTicketRemedy_2';
  /**************FIN SERVICE NAME****************/

  /*****************JSON INPUT*****************/
  /**Constante 'workLogs-description'*/
  public static final String WORKLOGS_DESC = '"workLogs-description"';
  /**Constante 'workLogs-summary'*/
  public static final String WORKLOGS_SUMMARY = '"workLogs-summary"';
  /**Constante 'workLogs-type'*/
  public static final String WORKLOGS_TYPE = '"workLogs-type"';
  /**Constante 'priority'*/
  public static final String PRIORITYJSON = '"priority"';
  /**Constante 'impact'*/
  public static final String IMPACT = '"impact"';
  /**Constante 'description'*/
  public static final String DESCRIPTION = '"description"';
  /**Constante 'assignee-id'*/
  public static final String ASSIGNEE_ID = '"assignee-id"';
  /**Constante 'consumerId'*/
  public static final String CONSUMERID = '"consumerId"';
  /**Constante ':"",'*/
  public static final String JSONBLANKVALUE = ':"",';
  /**************FIN JSON INPUT****************/

  /*****************STATUS*****************/
  /**Constante 'Remedy - Escalated'*/
  public static final String REMEDY_SCALATED = 'Remedy - Escalated';
  /***************FIN STATUS***************/

  /*****************OTROS*****************/
  /*Constante 'No existe ninguna incidencia con el External ID especificado'. RESP_ERROR_ARCHIVED_REMEDY*/
  public static final String ERROR_ARCHIVED = 'No existe ninguna incidencia con el External ID especificado';
  /*Constante 'Incidencia'*/
  public static final String INCIDENT = 'Incidencia';
  /*Constante 'REMEDY_PROCESS_STATUS'*/
  public static final set<String> PROCESS_STATUS = new set<String> {'Remedy - Pending information','Remedy - Pending to close','Remedy - Rejected', 'Reopen'};
  /***************FIN OTROS***************/


  /*---------------------------------------------------------------------------------------
      Company:       BBVA
      Description:   private constructor.
  ---------------------------------------------------------------------------------------*/
  private SER_CallRemedyWS_HELPER() {
  }

  /*---------------------------------------------------------------------------------------
      Author:        Juan Carlos Terrón
      Company:       Accenture
      Description:   Loads setup maps that control options displayed in the visualforcepage.

      IN:            void
      OUT:           Map<String, Map<String,Boolean>> operationFM

      History:
      <Date>                  <Author>                <Change Description>
      27/06/2017          Juan Carlos Terrón      Initial version.
  ---------------------------------------------------------------------------------------*/
  public static Map<String, Map<String,Boolean> > loadSetUpStructures() {
    return new Map<String, Map<String,Boolean> >
            {
              NEWREMEDY=> new Map<String,Boolean>
                {
                  COMMENT           => true,
                  PRIORITY          => true,
                  SOLUTION          => false,
                  SENDLASTCOMMENT   => true,
                  REMEDYDEPARTAMENT => true,
                  CASECLOSURE       => false,
                  LASTCOMMENT       => true
                },

              CLOSEREMEDY=> new Map<String,Boolean>
                {
                  COMMENT           => true,
                  PRIORITY          => false,
                  SOLUTION          => true,
                  SENDLASTCOMMENT   => true,
                  REMEDYDEPARTAMENT => false,
                  CASECLOSURE       => false,
                  LASTCOMMENT       => true
                },

              UPDATEREMEDY=> new Map<String,Boolean>
                {
                  COMMENT           => true,
                  PRIORITY          => true,
                  SOLUTION          => false,
                  SENDLASTCOMMENT   => true,
                  REMEDYDEPARTAMENT => false,
                  CASECLOSURE       => false,
                  LASTCOMMENT       => true
                },

              CLAIMREMEDY=> new Map<String,Boolean>
                {
                  COMMENT           => true,
                  PRIORITY          => false,
                  SOLUTION          => false,
                  SENDLASTCOMMENT   => true,
                  REMEDYDEPARTAMENT => false,
                  CASECLOSURE       => false,
                  LASTCOMMENT       => true
                },

              SENDCOMMENT=> new Map<String,Boolean>
                {
                  COMMENT           => true,
                  PRIORITY          => false,
                  SOLUTION          => false,
                  SENDLASTCOMMENT   => true,
                  REMEDYDEPARTAMENT => false,
                  CASECLOSURE       => false,
                  LASTCOMMENT       => true
                },

              SENDATTACHMENT=> new Map<String,Boolean>
                {
                  COMMENT           => true,
                  PRIORITY          => false,
                  SOLUTION          => false,
                  SENDLASTCOMMENT   => true,
                  REMEDYDEPARTAMENT => false,
                  CASECLOSURE       => false,
                  LASTCOMMENT       => true
                },

              REOPENREMEDY=> new Map<String,Boolean>
                {
                  COMMENT           => true,
                  PRIORITY          => true,
                  SOLUTION          => false,
                  SENDLASTCOMMENT   => true,
                  REMEDYDEPARTAMENT => true,
                  CASECLOSURE       => false,
                  LASTCOMMENT       => true
                }
            };
  }

  /*---------------------------------------------------------------------------------------
      Author:        Juan Carlos Terrón
      Company:       Accenture
      Description:   Loads setup maps that control options displayed in the visualforcepage.

      IN:            void
      OUT:           Map<String, List<SelectOption>> statusOptMap

      History:
      <Date>                  <Author>                <Change Description>
      27/06/2017          Juan Carlos Terrón      Initial version.
  ---------------------------------------------------------------------------------------*/
  public static Map<String, List<SelectOption> > loadRMStatusOptions() {
    return new Map<String, List<SelectOption> >
            {
              'New' => new List<SelectOption>
                {
                  new SelectOption(NEWREMEDY,NEWREMEDY)
                },

              'Modify 1' => new List<SelectOption>
                {
                  new SelectOption(SENDCOMMENT,SENDCOMMENT),
                  new SelectOption(SENDATTACHMENT,SENDATTACHMENT),
                  new SelectOption(UPDATEREMEDY,UPDATEREMEDY),
                  new SelectOption(CLOSEREMEDY,CLOSEREMEDY)
                },

              'Modify 2' => new List<SelectOption>
                {
                  new SelectOption(SENDCOMMENT,SENDCOMMENT),
                  new SelectOption(SENDATTACHMENT,SENDATTACHMENT),
                  new SelectOption(UPDATEREMEDY,UPDATEREMEDY),
                  new SelectOption(CLAIMREMEDY,CLAIMREMEDY)
                },

              'Modify 3' => new List<SelectOption>
                {
                  new SelectOption(CLAIMREMEDY,CLAIMREMEDY),
                  new SelectOption(CLOSEREMEDY,CLOSEREMEDY)
                },

              'Reopen' => new List<SelectOption>
                {
                  new SelectOption(REOPENREMEDY,REOPENREMEDY)
                }
            };
  }

  /*---------------------------------------------------------------------------------------
      Author:        Juan Carlos Terrón
      Company:       Accenture
      Description:   Method that transforms a comment given by the user into a usable format for the
                      webservice call.

      IN:            String
      OUT:           String

      History:
      14/07/2017                  JSS                update method name because is used for any string
                                                      (not only worklog), update replace caracters: '\n'
                                                      -> '\\n',  '\r' -> '\\r'
  ---------------------------------------------------------------------------------------*/
  public static String parseJsonString(String comment) {
    String commentF = '';    //st_FormatedComment
    if(String.isNotBlank(comment)) {
      commentF = comment.replaceAll('\t',' ');
      commentF = commentF.replaceAll('\r','          ');
      commentF = commentF.replaceAll('\n','          ');
      commentF = commentF.replaceAll('"','\'');
      commentF = commentF.replaceAll('\\\\','/');
      commentF = commentF.replaceAll('%','%%');
    } else {
      commentF = '';
    }

    return commentF;
  }

  /*---------------------------------------------------------------------------------------
      Company:       BBVA
      Description:   devuelve el Id de STECoordinatorQueue

      IN:            void
      OUT:           Id
  ---------------------------------------------------------------------------------------*/
  public static Id transferCoordinatorQueue() {
    String coordQueueDN;    //id_CoordinatorQueueId
    Id coordQueueId;
    coordQueueDN = String.isNotBlank(Label.SER_STECoordinatorQueue) ? Label.SER_STECoordinatorQueue : '';

    Group coordQueue;    //gp_CoordinatorQueue

    coordQueue = [select Id from Group where DeveloperName = :coordQueueDN limit 1][0];

    if(coordQueue != null) {
      coordQueueId = coordQueue.Id;
    }

    return coordQueueId;
  }

  /*---------------------------------------------------------------------------------------
      Author:        Juan Carlos Terrón
      Company:       Accenture
      Description:   Method that sets de visibility for the inputs on the visualforce
                      depending on the setup maps defined as class variables.
      IN:            SER_CallRemedyWebService wsClass
      OUT:           SER_CallRemedyWebService.Render
  ---------------------------------------------------------------------------------------*/
  public static SER_CallRemedyWebService.Render renderInputfields(SER_CallRemedyWebService wsClass) {
    /*Mapa de campos de la operacion. map_OperationFields*/
    Map<String,Map<String,Boolean> > operationFM;
    operationFM = loadSetUpStructures();

    if( operationFM != null
        && !operationFM.isEmpty()
        && operationFM.containskey(wsClass.operation)) {
      System.debug('JCT - Gestiono RENDER : '+wsClass.operation);
      wsClass.render.blRenderComment  = operationFM.get(wsClass.operation).get(COMMENT) && !wsClass.sendLastCom;
      wsClass.render.blRenderPriority = operationFM.get(wsClass.operation).get(PRIORITY);
      wsClass.render.blRenderCClosure = operationFM.get(wsClass.operation).get(CASECLOSURE);
      wsClass.render.blRenderSolution = operationFM.get(wsClass.operation).get(SOLUTION);
      wsClass.render.blRenderLastComm = operationFM.get(wsClass.operation).get(LASTCOMMENT) && wsClass.lastCaseComment!=null && wsClass.sendLastCom;
      wsClass.render.blRenderSendLast = operationFM.get(wsClass.operation).get(SENDLASTCOMMENT) && wsClass.lastCaseComment!=null;
      wsClass.render.blRenderRmdyDep  = operationFM.get(wsClass.operation).get(REMEDYDEPARTAMENT);
    } else {
      System.debug('JCT - GESTIONO RENDER DEFAULT ');
      wsClass.render.blRenderLastComm = false;
    }

    return wsClass.render;
  }

  /*---------------------------------------------------------------------------------------
      Company:       BBVA
      Description:   Se chequea el departamento del caso.

      IN:            SER_CallRemedyWebService wsClass
                      String status
      OUT:           Void
  ---------------------------------------------------------------------------------------*/
  public static void checkDepartament(SER_CallRemedyWebService wsClass,String status) {
    if(wsClass.currentCase.SER_Remedy_Department__c == null) {
      wsClass.errorMsg = 'Remedy Department field must be filled';
    } else {
      Map<String,List<SelectOption> > statusOptMap;
      statusOptMap = SER_CallRemedyWS_HELPER.loadRMStatusOptions();
      wsClass.operationList.addAll(statusOptMap.get(status));
    }
  }

  /*---------------------------------------------------------------------------------------
      Company:       BBVA
      Description:   inserta un nuevo comentario en el caso.

      IN:            SER_CallRemedyWebService wsClass
      OUT:           Void
  ---------------------------------------------------------------------------------------*/
  public static void insertNewCaseComment(SER_CallRemedyWebService wsClass) {
    if(!wsClass.sendLastCom && String.isNotBlank(wsClass.comment.newComment)) {
      wsClass.newCaseComment.CommentBody = wsClass.comment.newComment;
      wsClass.newCaseComment.ParentId = wsClass.currentCase.Id;
      insert wsClass.newCaseComment;
    }
  }

  /*---------------------------------------------------------------------------------------
      Company:       BBVA
      Description:   se cambia el owner si el caso es de STE.

      IN:            SER_CallRemedyWebService wsClass
      OUT:           Void
  ---------------------------------------------------------------------------------------*/
  public static void changeCaseOwner(SER_CallRemedyWebService wsClass) {
    if(wsClass.currentCase.SER_Business_Case_Type__c == SER_Constant.BUSINESS_STE) {
      wsClass.currentCase.SER_Transferred_from_agent_pool__c = false;
      wsClass.currentCase.OwnerId = transferCoordinatorQueue();
    }
  }

  /*---------------------------------------------------------------------------------------
      Company:       BBVA
      Description:   acciones que se ejecutan cuando el Remedy da un KO.

      IN:            SER_CallRemedyWebService wsClass
                      Map <String,Object> mapResp
                      String operation
      OUT:           Void
  ---------------------------------------------------------------------------------------*/
  public static void remedyKO(SER_CallRemedyWebService wsClass,Map <String,Object> mapResp,String operation) {
    String errmsg;
    errmsg = (String)mapResp.get('error-message');
    if(operation == REOPENREMEDY && (Integer)mapResp.get('http-status') == 409 && errmsg.contains(ERROR_ARCHIVED)) {
      wsClass.errorMsg = 'The Ticket Remedy is archived and can not be reopened. Please clone the Salesforce Case and then create a new associated Ticket Remedy.';
    } else {
      wsClass.errorMsg = 'Remedy call failed (error ' + (Integer)mapResp.get('http-status') + '):<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' +
                          (String)mapResp.get('system-error-description') + '<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' +
                          (String)mapResp.get('error-message');
    }
  }

}