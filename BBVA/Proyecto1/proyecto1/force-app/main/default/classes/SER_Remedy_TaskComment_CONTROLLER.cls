/**
* @author            BBVA
* Project:           BBVA Service
* Description:       Controlador del componente SER_Remedy_TaskComment
*
*            No.     Date            Author
*            -----   ----------      ----------------
* @version   1.0     2019-12-10      Javier Touchard
**************************************************************************************************************************************/
public with sharing class SER_Remedy_TaskComment_CONTROLLER {
  /*Instancia única de la clase para implementar un patrón Singleton*/
  private static SER_Remedy_TaskComment_CONTROLLER instance;

  /* constructor privado*/
  private SER_Remedy_TaskComment_CONTROLLER () {
  }

  /*---------------------------------------------------------------------------------------
      Company:       BBVA
      Description:   instantiation method.

      IN:            void
      OUT:           SER_RTM_CallWS
  ---------------------------------------------------------------------------------------*/
  public static SER_Remedy_TaskComment_CONTROLLER getInstance() {
    // lazy load the record type - only initialize if it doesn't already exist
    if(instance == null) {
      instance = new SER_Remedy_TaskComment_CONTROLLER();
    }
    return instance;
  }

  /*--------------------------------------------------------------------------------
    @author       BBVA
    @date         2019-12-10
    @description  Deviuelve una lista de comentarios asociados a la tarea
    @params       Id recordId
    @return       Response
  ------------------------------------------------------------------------------------*/
  @AuraEnabled
  public static Response loadComments(String recordId) {
    System.debug('---->>> recordId ' + recordId);
    Response response;
    response = new Response();
    List<TaskComment__c> taskComments;
    try {
      taskComments = [SELECT gf_task_comment_creator_name__c,
                        gf_task_comment_date__c,
                        gf_task_comment_body_desc__c
                      FROM TaskComment__c
                      WHERE ParentId__c =: recordId
                      AND isRemedy__c = true
                      ORDER BY gf_task_comment_date__c DESC];
      System.debug('---->>> taskComments ' + taskComments);
      response.comments = taskComments;
      response.showComments = !taskComments.isEmpty();
    } catch (Exception exc) {
      String errorMessage;
      errorMessage = ' , StackTrace: ' + exc.getStackTraceString();
      throw new AuraHandledException(Label.SER_Error_Server + ' ' + exc + ' ' + errorMessage);
    }
    return response;
  }

  /**************************************************************************************
  *******************                   WRAPPER                     *********************
  **************************************************************************************/

  /*--------------------------------------------------------------------------------------
      Company:        BBVA
      Description:    Clase interna .
  --------------------------------------------------------------------------------------*/
  public class Response {
    /*Task Comment list*/
    @AuraEnabled
    public List<TaskComment__c> comments {get; set;}
    /*showComments*/
    @AuraEnabled
    public Boolean showComments {get; set;}
  }

}