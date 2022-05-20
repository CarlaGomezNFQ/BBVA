/**********************************************************************************
* @author       JSS - Accenture
* @date         26/04/2017
* @description  Class intermedia  entre el botón JavaScript que la invoca y las llamadas a los Web Services ASO.
                                Se define como global para poder invocar sus methodos desde Javasctipt.
                                Los méthodos se definen como @RemoteAction para invocarlos con Javascript Remoting.
* @Revision
    14/07/2017                  JSS             update method parseJsonString. parseJsonString now is used for any
                                            text string (description, comment worklog)
    27/07/2017                  JSS             method parseJsonString still fails and has been commented, now this
                                            fix is done in page code (javascript)
                                                                                        Add new variables: newCommentParse, lastCommentParse, newCommentParse
**********************************************************************************/
public with sharing class SER_RTM_CallWS {

  /*Instancia única de la clase para implementar un patrón Singleton*/
  private static SER_RTM_CallWS instance;


  /*---------------------------------------------------------------------------------------
      Company:       BBVA
      Description:   private constructor.
  ---------------------------------------------------------------------------------------*/
  private SER_RTM_CallWS() {
  }

  /*---------------------------------------------------------------------------------------
      Company:       BBVA
      Description:   instantiation method.

      IN:            void
      OUT:           SER_RTM_CallWS
  ---------------------------------------------------------------------------------------*/
  public static SER_RTM_CallWS getInstance() {
    // lazy load the record type - only initialize if it doesn't already exist
    if(instance == null) {
      instance = new SER_RTM_CallWS();
    }
    return instance;
  }

  /*---------------------------------------------------------------------------------------
      Company:       BBVA
      Description:   Init Method.

      IN:            String caseid
      OUT:           List<String>
  ---------------------------------------------------------------------------------------*/
  @AuraEnabled
  public static List<String> doInit(String caseid) {
    List<String> optionsList;
    optionsList = new List<String>();
    try {
      SER_CallRemedyWebServiceLGT instanceCRWS;
      instanceCRWS = new SER_CallRemedyWebServiceLGT(caseId,'');
      if(instanceCRWS.operationList != null && !instanceCRWS.operationList.isEmpty()) {
        for(SelectOption so : instanceCRWS.operationList) {
          optionsList.add(so.getValue());
        }
      }
      return optionsList;
    } catch(Exception e) {
      throw new AuraHandledException(Label.SER_Error_Server + ' ' + e);
    }
  }

  /*---------------------------------------------------------------------------------------
      Company:       BBVA
      Description:   submit a ticket.

      IN:            String caseid
      OUT:           String
  ---------------------------------------------------------------------------------------*/
  @AuraEnabled
  public static String  submitTicket(String caseId,String userId,String priority,String solution,String operation,
                                      String remedyDepartment,Boolean sendLastComment,String newComment) {
    System.debug('JCT---PARAM - sendLastComment : '+sendLastComment);
    System.debug('JCT---PARAM - newComment : '+newComment);
    try {
      SER_CallRemedyWebServiceLGT instanceCRWS;
      instanceCRWS = new SER_CallRemedyWebServiceLGT(caseId,userId);
      instanceCRWS.operation = operation;
      if(String.isNotBlank(priority)) {
        instanceCRWS.currentCase.Priority = priority;
      }
      if(String.isNotBlank(remedyDepartment)) {
        instanceCRWS.currentCase.SER_Remedy_Department__c = remedyDepartment;
      }
      if(String.isNotBlank(solution)) {
        instanceCRWS.currentCase.SER_Solution__c = SER_CallRemedyWS_HELPERLGT.parseJsonString(solution,false);
      }
      instanceCRWS.sendLastCom = sendLastComment;
      instanceCRWS.comment.newComment = SER_CallRemedyWS_HELPERLGT.parseJsonString(newComment,false);
      instanceCRWS.comment.newCommentParse = SER_CallRemedyWS_HELPERLGT.parseJsonString(newComment,false);
      instanceCRWS.comment.remedyMessage = SER_CallRemedyWS_HELPERLGT.parseJsonString(newComment,true);
      //instanceCRWS.currentCase.Description = SER_CallRemedyWS_HELPERLGT.parseJsonStringRemedy(instanceCRWS.currentCase.Description);
      instanceCRWS.comment.descriptionParse = SER_CallRemedyWS_HELPERLGT.parseJsonString(instanceCRWS.currentCase.Description,true);
      System.debug('PREERROR');
      instanceCRWS.callWebServiceASOLogic();

      return instanceCRWS.errorMsg;
    } catch(Exception e) {

      throw new AuraHandledException(Label.SER_Error_Server + ' ' + e);
    }
  }

/*---------------------------------------------------------------------------------------
        Company:       BBVA
        Description:   Send the comment to remedy

        IN:            String caseid
        OUT:           String
    ---------------------------------------------------------------------------------------*/
  @AuraEnabled
  public static String  secondCall(String caseId,String userId,String priority,String solution,String operation,
                                    String remedyDepartment,Boolean sendLastComment,String newComment) {
    System.debug('JCT---PARAM - sendLastComment : '+sendLastComment);
    System.debug('JCT---PARAM - newComment : '+newComment);
    try {
      SER_CallRemedyWebServiceLGT instanceCRWS;
      instanceCRWS = new SER_CallRemedyWebServiceLGT(caseId,userId);
      instanceCRWS.operation = operation;
      if(String.isNotBlank(priority)) {
        instanceCRWS.currentCase.Priority = priority;
      }
      if(String.isNotBlank(remedyDepartment)) {
        instanceCRWS.currentCase.SER_Remedy_Department__c = remedyDepartment;
      }
      if(String.isNotBlank(solution)) {
        instanceCRWS.currentCase.SER_Solution__c = SER_CallRemedyWS_HELPERLGT.parseJsonString(solution,false);
      }
      instanceCRWS.sendLastCom = sendLastComment;
      instanceCRWS.comment.remedyMessage = SER_CallRemedyWS_HELPERLGT.parseJsonString(newComment,true);
      instanceCRWS.comment.newComment = SER_CallRemedyWS_HELPERLGT.parseJsonString(newComment,false);
      instanceCRWS.comment.newCommentParse = SER_CallRemedyWS_HELPERLGT.parseJsonString(newComment,false);
      instanceCRWS.secondCallWebServiceASO();

      return instanceCRWS.errorMsg;
    } catch(Exception e) {
      System.debug('EXMSG : '+e.getMessage());
      throw new AuraHandledException(Label.SER_Error_Server + ' ' + e);
    }
  }

  /*---------------------------------------------------------------------------------------
      Company:       BBVA
      Description:   return case recordtype id..

      IN:            Id objId
      OUT:           Id
  ---------------------------------------------------------------------------------------*/
  @AuraEnabled
  public static Id getRecordTypeId(Id objId) {
    Case caso;
    try {
      caso = [select Id, RecordTypeId from case where id = : objId limit 1][0];
      return caso.RecordTypeId;
    } catch(Exception e) {
      throw new AuraHandledException(Label.SER_Error_Server + ' ' + e);
    }
  }

  /*---------------------------------------------------------------------------------------
      Company:       BBVA
      Description:   return the case in Json format.

      IN:            Id caseid
      OUT:           String
  ---------------------------------------------------------------------------------------*/
  @AuraEnabled
  public static String getCaseJSON(Id caseid) {
    Case caso;
    String casoJson;
    try {
      caso =  [
        select Id,
        Status,
        RecordTypeId,
        SER_Business_Case_Type__c,
        (select Id,CommentBody from CaseComments order by CreatedDate desc limit 1)
        from Case
        where id = :caseid limit 1
      ][0];
      casoJson = JSON.serialize(caso);
      return casoJson;
    } catch(Exception e) {
      throw new AuraHandledException(Label.SER_Error_Server + ' ' + e);
    }
  }

  /*---------------------------------------------------------------------------------------
      Company:       BBVA
      Description:   return the case.

      IN:            Id caseid
      OUT:           Case
  ---------------------------------------------------------------------------------------*/
  @AuraEnabled
  public static Case getCase(Id caseid) {
    Case caso = new Case();
    try {
      caso =  [
        select Id,
        Status,
        RecordTypeId,
        SER_Business_Case_Type__c,
        (select Id,CommentBody from CaseComments order by CreatedDate desc limit 1)
        from Case
        where id = :caseid limit 1
      ][0];
      return caso;
    } catch(Exception e) {
      throw new AuraHandledException(Label.SER_Error_Server + ' ' + e);
    }
  }
}