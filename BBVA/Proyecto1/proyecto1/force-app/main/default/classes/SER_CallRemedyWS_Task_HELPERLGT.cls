/*---------------------------------------------------------------------------------------
    Company:       BBVA
    Description:   Clase auxiliar de SER_CallRemedyWebServiceLGT_Task.

    History:
    <Date>                  <Author>                <Change Description>
    13/12/2018           Javier Touchard            Initial version(SONAR).
---------------------------------------------------------------------------------------*/
public with sharing class SER_CallRemedyWS_Task_HELPERLGT {

  /*Instancia única de la clase para implementar un patrón Singleton*/
  private static SER_CallRemedyWS_Task_HELPERLGT instance;

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

  /*****************OTROS*****************/
  /*Constante 'No existe ninguna incidencia con el External ID especificado'. RESP_ERROR_ARCHIVED_REMEDY*/
  public static final String ERROR_ARCHIVED = 'No existe ninguna incidencia con el External ID especificado';
  /*Constante 'Incident'*/
  public static final String INCIDENT = 'Incident';
  /*Constante 'REMEDY_PROCESS_STATUS'*/
  public static final set<String> PROCESS_STATUS = new set<String> {'Remedy - Pending information','Remedy - Pending to close','Remedy - Rejected','Remedy - Escalated', 'Reopen'};
  /***************FIN OTROS***************/


  /*---------------------------------------------------------------------------------------
      Company:       BBVA
      Description:   private constructor.
  ---------------------------------------------------------------------------------------*/
  private SER_CallRemedyWS_Task_HELPERLGT() {}

  /*---------------------------------------------------------------------------------------
      Company:       BBVA
      Description:   instantiation method.

      IN:            void
      OUT:           SER_CallRemedyWS_Task_HELPERLGT
  ---------------------------------------------------------------------------------------*/
  public static SER_CallRemedyWS_Task_HELPERLGT getInstance() {   //NOSONAR
    // lazy load the record type - only initialize if it doesn't already exist
    if(instance == null) {
      instance = new SER_CallRemedyWS_Task_HELPERLGT();
    }
    return instance;
  }


  /*---------------------------------------------------------------------------------------
      Company:       BBVA
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
      Company:       BBVA
      Description:   Method that transforms a comment given by the user into a usable format for the
                      webservice call.

      IN:            String
      OUT:           String

      History:
      14/07/2017                  JSS                update method name because is used for any string
                                                      (not only worklog), update replace caracters: '\n'
                                                      -> '\\n',  '\r' -> '\\r'
  ---------------------------------------------------------------------------------------*/
  public static String parseJsonString(String comment, Boolean isParseRemedy) {
    String commentF = '';    //st_FormatedComment
    if(String.isNotBlank(comment)) {
      if (isParseRemedy) {
        commentF = comment.replace('\\\\', '/').replace('\t', '\\\\t').replace('\n', '\\\\n').replace('\r', '\\\\r').replace('\"','\'').replace('%','%%');
      } else {
        commentF = comment.replaceAll('\t',' ');
        commentF = commentF.replaceAll('\r','     ');
        commentF = commentF.replaceAll('\n','     ');
        commentF = commentF.replaceAll('\\\\','/');
      }
    } else {
      commentF = '';
    }
    return commentF;
  }

  /*---------------------------------------------------------------------------------------
      Company:       BBVA
      Description:   Se chequea el departamento del caso.

      IN:             SER_CallRemedyWebServiceLGT_Task wsClass
                      String status
      OUT:            Void
  ---------------------------------------------------------------------------------------*/
  public static void checkDepartament(SER_CallRemedyWebServiceLGT_Task wsClass,String status) {
    if(wsClass.currentTask.departament_name__c == null) {
      wsClass.errorMsg = 'ERRORRemedy Department field must be filled';
    } else {
      Map<String,List<SelectOption> > statusOptMap;
      statusOptMap = SER_CallRemedyWS_Task_HELPERLGT.loadRMStatusOptions();
      wsClass.operationList.addAll(statusOptMap.get(status));
    }
  }

  /*---------------------------------------------------------------------------------------
      Company:       BBVA
      Description:   inserta un nuevo comentario en el caso.

      IN:            SER_CallRemedyWebServiceLGT_Task wsClass
      OUT:           Void
  ---------------------------------------------------------------------------------------*/
  public static void insertNewTaskComment(SER_CallRemedyWebServiceLGT_Task wsClass) {
    if(!wsClass.sendLastCom && String.isNotBlank(wsClass.comment.newComment)) {
      wsClass.newTaskComment.gf_task_comment_body_desc__c = wsClass.comment.newComment.replaceAll('     ','\n');
      wsClass.newTaskComment.ParentId__c = wsClass.currentTask.Id;
      wsClass.newTaskComment.isRemedy__c = true;
      wsClass.newTaskComment.gf_task_comment_date__c = Datetime.now();
      wsClass.newTaskComment.gf_task_comment_creator_name__c = UserInfo.getName();
      insert wsClass.newTaskComment;

      //Insertamos un comentario en el feed
      FeedItem feedComment;
      feedComment = new FeedItem();
      feedComment.Body = 'Remedy comment: ' + wsClass.comment.newComment.replaceAll('     ','\n');
      feedComment.ParentId = wsClass.currentTask.Id;
      feedComment.Title = 'Remedy Comment';
      insert feedComment;
    }
  }

  /*---------------------------------------------------------------------------------------
      Company:       BBVA
      Description:   acciones que se ejecutan cuando el Remedy da un KO.

      IN:             SER_CallRemedyWebServiceLGT_Task wsClass
                      Map <String,Object> mapResp
                      String operation
      OUT:            Void
  ---------------------------------------------------------------------------------------*/
  public static void remedyKO(SER_CallRemedyWebServiceLGT_Task wsClass,Map <String,Object> mapResp,String operation) {
    String errmsg;
    errmsg = (String)mapResp.get('error-message');
    if(operation == REOPENREMEDY && (Integer)mapResp.get('http-status') == 409 && errmsg.contains(ERROR_ARCHIVED)) {
      wsClass.errorMsg = 'ERRORThe Ticket Remedy is archived and can not be reopened. Please clone the Salesforce Case and then create a new associated Ticket Remedy.';
    } else {
      wsClass.errorMsg = 'ERRORRemedy call failed (error ' + (Integer)mapResp.get('http-status') + '):<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' +
                          (String)mapResp.get('system-error-description') + '<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' +
                          (String)mapResp.get('error-message');
    }
  }

  /*---------------------------------------------------------------------------------------
      Company:       BBVA
      Description:   Method to transform Sf Priority field information itno Remedy priority field format.

      IN:            void
      OUT:           String

      History:
      <Date>                  <Author>                <Change Description>
      27/06/2017              Juan Carlos Terrón      Initial version
  ---------------------------------------------------------------------------------------*/
  public static String formattedPriorityField(Task currentTask) {
    String result = '';

    if (String.isBlank(currentTask.Priority)) {
      result = '4000';
      currentTask.Priority = SER_Constant.LOW;
    } else if(currentTask.Priority == SER_Constant.HIGH) {
      result = '2000';
    } else if (currentTask.Priority == SER_Constant.NORMAL) {
      result = '3000';
    } else {     // == "Low" y si llega algo raro
      result = '4000';
      currentTask.Priority = SER_Constant.LOW;
    }
    return result;
  }

}