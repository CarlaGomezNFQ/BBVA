/**
* @author            BBVA
* Project:           BBVA Service
* Description:       Clase con los me2dos que se van a llamar desde el Trigger 
*                    SER_TaskComment_TRIGGER.
*********************************************************************************************/
public with sharing class SER_TaskCommentMethods {

  /*-----------------------------------------------------------------------
    Construtor privado
  ------------------------------------------------------------------------*/
  private SER_TaskCommentMethods() {}

  /*-----------------------------------------------------------------------
    Author:         BBVA Service
    Company:        BBVA
    Description:    Fills description and solution Task Fields

    IN:             List<TaskComment__C> newList
    IN:             Map<Id, TaskComment__C> oldMap
    OUT:            Void
  -------------------------------------------------------------------------*/
  public static void fillTaskDescriptionSolution(List<TaskComment__C> newList, Map<Id, TaskComment__C> oldMap) {
    System.debug('Entering SER_TaskCommentMethods.fillTaskDescriptionSolution()');
    Set<Id> ltaIdSet;
    ltaIdSet = new Set<Id>();
    List<Task> taskToUpdate;
    for(TaskComment__c lta : newList) {
      Boolean changeDesc;
      changeDesc = lta.isRemedy__c == false && lta.task_desc__c != oldMap.get(lta.Id).task_desc__c;
      if(changeDesc) {
        ltaIdSet.add(lta.Id);
      }
      Boolean changeSolution;
      changeSolution = lta.isRemedy__c == false && lta.gf_action_result_desc__c != oldMap.get(lta.Id).gf_action_result_desc__c;
      if(changeSolution) {
        ltaIdSet.add(lta.Id);
      }
    }

    if(ltaIdSet.isEmpty() == false) {
      taskToUpdate = trateLTAFields(ltaIdSet);

      if(taskToUpdate.isEmpty() == false) {
        update taskToUpdate;
      }
    }
  }

  /*-----------------------------------------------------------------------
    Author:         BBVA Service
    Company:        BBVA
    Description:    trateLTAFields.

    IN:             Set<Id> ltaIdSet
    OUT:            List<Task>
  -------------------------------------------------------------------------*/
  private static List<Task> trateLTAFields(Set<Id> ltaIdSet) {
    System.debug('Entering SER_TaskCommentMethods.trateLTAFields()');
    List<Task> taskToUpdate;
    taskToUpdate = new List<Task>();
    List<Task> taskList;
    taskList = [SELECT Id, TaskComment__r.task_desc__c, TaskComment__r.gf_action_result_desc__c FROM Task WHERE TaskComment__c IN :ltaIdSet];

    for(Task tarea : taskList) {
      Boolean trimDesc;
      trimDesc = String.isNotBlank(tarea.TaskComment__r.task_desc__c) && tarea.TaskComment__r.task_desc__c.length() > 255;
      if(trimDesc) {
        tarea.task_desc__c = tarea.TaskComment__r.task_desc__c.substring(0, 250) + '...';
      } else if (String.isNotBlank(tarea.TaskComment__r.task_desc__c)) {
        tarea.task_desc__c = tarea.TaskComment__r.task_desc__c;
      }
      Boolean trimSolution;
      trimSolution = String.isNotBlank(tarea.TaskComment__r.gf_action_result_desc__c) && tarea.TaskComment__r.gf_action_result_desc__c.length() > 255;
      if(trimSolution) {
        tarea.gf_action_result_desc__c = tarea.TaskComment__r.gf_action_result_desc__c.substring(0, 250) + '...';
      } else if (String.isNotBlank(tarea.TaskComment__r.gf_action_result_desc__c)) {
        tarea.gf_action_result_desc__c = tarea.TaskComment__r.gf_action_result_desc__c;
      }
      taskToUpdate.add(tarea);
    }
    return taskToUpdate;
  }

}