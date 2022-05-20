({
  doInit: function(component, event, helper) {
    console.log('Entering --> SER_NewTask : doInit');
    var params = {'taskId': component.get('v.recordId')};
    var fnCallback = function(response) {
      var rspState = response.getState();
      if (rspState === 'SUCCESS') {
        var noneOption = new Object();
        noneOption.label = '--None--';
        noneOption.id = '--None--';
        component.set('v.selectedResolutor', '--None--');
        component.set('v.selecteddepartament', '--None--');

        helper.fillPriorityOptions(component, response, noneOption);
        helper.fillDepartmentOptions(component, response, noneOption);
        helper.fillResolOptions(component, response, noneOption);
        helper.fillTechImpactOptions(component, response, noneOption);

        var selectedRecord = new Object();
        selectedRecord.label = response.getReturnValue().caseNumber;
        selectedRecord.value = response.getReturnValue().caseId;
        component.set('v.selectedRecord', selectedRecord);
        component.set('v.bl_DisplayRemedy', response.getReturnValue().isIncident);
        component.set('v.bl_DisplayModal', true);
        console.log('OK');
      } else if (rspState === 'ERROR') {
        helper.trateErrors(response);
      } else {
        console.log('Failed with state ' + rspState);
      }
    };
    helper.callServer(component, event, 'c.doInitOptions', params, fnCallback, helper);
  },

  fn_SaveTask: function(component, event, helper) {
    console.log('Entering --> SER_NewTask : fn_SaveTask');
    var SER_EGS_ErrorResolutorTeam_lbl      =   $A.get('$Label.c.SER_EGS_ErrorResolutorTeam_lbl');
    var selecTecImpac = component.get("v.selectedTecImpact")[0];
    var mapTechImpact = new Map();
    mapTechImpact.set("1. Critical", 1);
    mapTechImpact.set("2. High", 2);
    mapTechImpact.set("3. Medium", 3);
    mapTechImpact.set("4. Low", 4);
    mapTechImpact.set("5. No Impact", 5);
    console.log('selecTecImpactttt---->>>>' + selecTecImpac);
    if (component.get('v.selectedResolutor') === '--None--') {
      helper.getMsgResult(SER_EGS_ErrorResolutorTeam_lbl, 'error', 'Error:', event);
    } else {
      document.getElementById('saveButton').disabled = true;
      helper.resetError(component);
      $A.util.removeClass(component.find('Spinner'), 'slds-hide');
      var tarea = helper.fn_CreateTask(component);
      var params = {'tarea': tarea,
                    'description' : component.get('v.description')};

      var fncallback = function(response) {
        console.log('Entering -->  fn_SaveTask.fnCallback ---->>>>' + response.getError()[0]);
        var SER_EGS_CreateTaskSucc_lbl       =   $A.get('$Label.c.SER_EGS_CreateTaskSucc_lbl');
        var SER_EGS_ContactAdmin_lbl       =   $A.get('$Label.c.SER_EGS_ContactAdmin_lbl');
        var SER_EGS_HasActionLine_lbl       =   $A.get('$Label.c.SER_EGS_HasActionLine_lbl');

        var state = response.getState();
        if (state === 'SUCCESS') {
          if(response.getReturnValue() === 'ActionLine') {
            helper.reset(component, event);
            $A.util.addClass(component.find('Spinner'), 'slds-hide');
            component.set('v.bl_DisplayModal', false);
            helper.getMsgResult(SER_EGS_HasActionLine_lbl, 'error', 'Error:', event);
          } else {
            console.log('Task successfully created');
            component.set('v.taskId', response.getReturnValue());
            if (component.get('v.selecteddepartament') !== '--None--') {
              console.log('Call Remedy');
              var cmp = component.find('New Remedy');
              var stComment = cmp.get('v.st_Comment');
              var plPriority = component.find('priorityId').get('v.value');
              var plDepartment = component.find('departamentId').get('v.value');
              var params2 = {
                'taskid': response.getReturnValue(),
                'userId': $A.get('$SObjectType.CurrentUser.Id'),
                'priority': plPriority,
                'solution': '',
                'operation': 'New Remedy',
                'remedyDepartment': plDepartment,
                'sendLastComment': false,
                'newComment': stComment,
                'isCloseBtn': false
              };

              var fnCallbackDos = function(response1) {
                helper.callBack2Helper(component, cmp, event, helper, response1, params2);
              };
              helper.callServer(component, event, 'c.submitTicket', params2, fnCallbackDos, helper);
            } else {
              console.log('The process has been completed successfully.');
              helper.closeModal(component, event, helper);
              helper.showToast(SER_EGS_CreateTaskSucc_lbl, 'success', helper);
            }
          }
        } else if (state === 'ERROR') {
          console.log('ERROR: Savetask');
          helper.closeModal(component, event, helper);
          var message3 = response.getError()[0].message;
          helper.saveLog(component, event, helper, 'ERROR: NewTask.saveTask', component.get('v.taskId'), $A.get('$SObjectType.CurrentUser.Id'), message3);
          helper.showToast(SER_EGS_ContactAdmin_lbl, 'error', helper);
        }
      };
      helper.callServer(component, event, 'c.saveTask', params, fncallback, helper);
    }
  },

  fn_CloseModal: function(component, event, helper) {
    component.set('v.bl_DisplayModal', false);
    helper.reset(component, event);
  },
});