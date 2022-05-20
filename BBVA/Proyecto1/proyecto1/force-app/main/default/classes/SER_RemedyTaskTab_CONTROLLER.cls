/**
* @author            BBVA
* Project:           BBVA Service
* Description:       Controlador del componente SER_RemedyTaskTab
*
*            No.     Date            Author
*            -----   ----------      ----------------
* @version   1.0     2018-10-30      Javier Touchard
**************************************************************************************************************************************/
public with sharing class SER_RemedyTaskTab_CONTROLLER {

  /*Constante 'Discarded / Duplicated'*/
  public static final String DISCARTED = 'Discarded / Duplicated';

  /*Instancia única de la clase para implementar un patrón Singleton*/
  private static SER_RemedyTaskTab_CONTROLLER instance;

  /* constructor privado*/
  private SER_RemedyTaskTab_CONTROLLER () {
  }

  /*---------------------------------------------------------------------------------------
      Company:       BBVA
      Description:   instantiation method.

      IN:            void
      OUT:           SER_RTM_CallWS
  ---------------------------------------------------------------------------------------*/
  public static SER_RemedyTaskTab_CONTROLLER getInstance() {
    // lazy load the record type - only initialize if it doesn't already exist
    if(instance == null) {
      instance = new SER_RemedyTaskTab_CONTROLLER();
    }
    return instance;
  }

  /*--------------------------------------------------------------------------------
    @author       BBVA
    @date         2018-10-30
    @description  Deviuelve la tarea actual
  ------------------------------------------------------------------------------------*/
  @AuraEnabled
  public static Response loadTasks(Id recordId) {
    System.debug('---->>> recordId ' + recordId);
    Response response;
    response = new Response();
    List<Task> sqlTask;
    Case caso;
    try {
      sqlTask = [SELECT Id,
                        incidence_id__c,
                        Status,
                        Go_to_Remedy_ticket__c,
                        departament_name__c,
                        incidence_commitment_date__c,
                        department_correction_desc__c,
                        WhatId
                  FROM task
                  WHERE Id =: recordId
                  LIMIT 1];
      System.debug('---->>> sqlTask ' + sqlTask);
      response.task = sqlTask[0];
      caso = [SELECT SER_Classification__c FROM Case WHERE Id = :sqlTask[0].WhatId];
      response.isIncidence = SER_CallRemedyWS_Task_HELPERLGT.INCIDENT.equalsIgnoreCase(caso.SER_Classification__c) || (DISCARTED.equalsIgnoreCase(caso.SER_Classification__c) && sqlTask[0].incidence_id__c != null) ? true : false;
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
    /*task*/
    @AuraEnabled
    public Task task {get; set;}
    /*departamentOpts*/
    @AuraEnabled
    public Boolean isIncidence {get; set;}
  }
}