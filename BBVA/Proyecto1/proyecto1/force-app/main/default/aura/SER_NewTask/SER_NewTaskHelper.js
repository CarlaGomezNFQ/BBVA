({
  errorHandler: function(message, component) {
    console.log('Error message: ' + message);
    $A.util.addClass(component.find('Spinner'), 'slds-hide');
    component.set('v.error', true);
    component.set('v.errormessage', message);
    document.getElementById('saveButton').disabled = false;
  },

  showToast: function(message, toastType, helper) {
    helper.showToastError(message, toastType);
  },

  resetError: function(component) {
    component.set('v.error', false);
    component.set('v.errormessage', '');
  },

  reset: function(component, event) {
    component.set('v.selecteddepartament', '');
    component.set('v.selectedResolutor', '');
    component.set('v.comments', '');
    component.set('v.description', '');
    component.set('v.selectedPriority', 'Normal');
    component.set('v.error', false);
    component.set('v.errormessage', '');
  },

  closeModal: function(component, event, helper) {
    helper.reset(component, event);
    $A.util.addClass(component.find('Spinner'), 'slds-hide');
    component.set('v.bl_DisplayModal', false);
    var navEvt = $A.get('e.force:navigateToSObject');
    navEvt.setParams({
      'recordId': component.get('v.taskId'),
      'slideDevName': 'related'
    });
    navEvt.fire();
  },

  getMsgResult: function(message, type, title, event) {
    var resultsToast = $A.get('e.force:showToast');
    resultsToast.setParams({
      title: title,
      message: message,
      duration: '5000',
      type: type
    });
    $A.get('e.force:closeQuickAction').fire();
    resultsToast.fire();
    $A.get('e.force:refreshView').fire();
  },

  fillTechImpactOptions: function(component, response, noneOption) {
    var optionsTcIm = response.getReturnValue().techImpOpts;
    var tecImpactOptions = [];
    tecImpactOptions.push(noneOption);
    var r;
    for (r = 0; r < optionsTcIm.length; r++) {
      var optionTcIm = new Object();
      optionTcIm.id = optionsTcIm[r];
      optionTcIm.label = optionsTcIm[r];
      if (optionsTcIm[r] === response.getReturnValue().techImpact) {
        optionTcIm.selected = true;
      }
      tecImpactOptions.push(optionTcIm);
    }
    component.set('v.tecImpactOptions', tecImpactOptions);
    component.set('v.selectedTecImpact', response.getReturnValue().techImpact);
    component.set('v.caseTecImpact', response.getReturnValue().techImpact);
  },

  fillDepartmentOptions: function(component, response, noneOption) {
    var optionsD = response.getReturnValue().departamentOpts;
    var departamentOptions = [];
    departamentOptions.push(noneOption);
    var y;
    for (y = 0; y < optionsD.length; y++) {
      var option2 = new Object();
      option2.id = optionsD[y];
      option2.label = optionsD[y];
      departamentOptions.push(option2);
    }
    component.set('v.departamentOptions', departamentOptions);
  },

  fillResolOptions: function(component, response, noneOption) {
    var optionsR = response.getReturnValue().teamResolOpts;
    var teamResolOptions = [];
    teamResolOptions.push(noneOption);
    var z;
    for (z = 0; z < optionsR.length; z++) {
      var option3 = new Object();
      option3.id = optionsR[z];
      option3.label = optionsR[z];
      teamResolOptions.push(option3);
    }
    component.set('v.resolutorOptions', teamResolOptions);
  },

  fillPriorityOptions: function(component, response, noneOption) {
    var optionsP = response.getReturnValue().priorityOpts;
    var priorityOptions = [];
    priorityOptions.push(noneOption);
    var x;
    for (x = 0; x < optionsP.length; x++) {
      var option = new Object();
      option.id = optionsP[x];
      option.label = optionsP[x];
      if (optionsP[x] === 'Normal') {
        option.selected = true;
      } else {
        option.selected = false;
      }
      priorityOptions.push(option);
    }
    component.set('v.priorityOptions', priorityOptions);
  },

  fn_CreateTask: function(component) {
    var tarea = new Object();
    tarea.gf_task_execution_team_name__c = component.get('v.selectedResolutor');
    var caso = component.get('v.selectedRecord');
    tarea.WhatId = caso.value;
    tarea.gf_task_notf_ext_supp_ind_type__c = component.find('seCheck').get('v.checked');
    tarea.gf_task_notif_fucib_ind_type__c = component.find('fcCheck').get('v.checked');
    tarea.gf_spec_task_op_case_ind_type__c = component.find('ch_ActionLine').get('v.checked');
    if (component.get('v.selectedTecImpact') !== '--None--') {
      tarea.gf_tech_impact_case_name__c = component.get('v.selectedTecImpact');
    }
    tarea.Description = component.get('v.comments');
    return tarea;
  },

  callBack2Helper: function(component, cmp, event, helper, response1, params2) {
    console.log('Entering -->  fn_SaveTask.fnCallbackDos ---->>>>' + response1.getError()[0]);
    var SER_EGS_NotCreateRemedy_lbl       =   $A.get('$Label.c.SER_EGS_NotCreateRemedy_lbl');
    var rspState = response1.getState();
    if (rspState === 'SUCCESS') {
      var msg = response1.getReturnValue();
      if (msg.substring(0, 5) === 'ERROR') {
        console.log('Se ha producido un error: ' + msg.substring(5));
        helper.closeModal(component, event, helper);
        helper.saveLog(component, event, helper, 'ERROR: NewTask.createRemedy', component.get('v.taskId'), $A.get('$SObjectType.CurrentUser.Id'), msg.substring(5));
        helper.showToast(SER_EGS_NotCreateRemedy_lbl, 'error', helper);
      } else {
        console.log('The remedy has created successfully.');
        console.log(msg);
        helper.resetError(component);

        var fnCallbackTres = function(response2) {
          console.log('Entering -->  fn_SaveTask.fnCallbackTres ---->>>>' + response2.getError()[0]);
          var rspState2 = response2.getState();
          if (rspState2 === 'SUCCESS') {
            helper.manageSuccess(component, cmp, event, helper, response2);
          } else {
            console.log('ERROR: Secon call');
            helper.closeModal(component, event, helper);
            var message = response2.getError()[0].message;
            helper.saveLog(component, event, helper, 'ERROR: NewTask.secondCall', component.get('v.taskId'), $A.get('$SObjectType.CurrentUser.Id'), message);
            helper.showToast(SER_EGS_NotCreateRemedy_lbl, 'error', helper);
          }
        };
        helper.callServer(component, event, 'c.secondCall', params2, fnCallbackTres, helper);
      }
    } else {
      console.log('ERROR: Create Remedy');
      helper.closeModal(component, event, helper);
      var message2 = response1.getError()[0].message;
      helper.saveLog(component, event, helper, 'ERROR: NewTask.createRemedy', component.get('v.taskId'), $A.get('$SObjectType.CurrentUser.Id'), message2);
      helper.showToast(SER_EGS_NotCreateRemedy_lbl, 'error', helper);
    }
  },

  manageSuccess: function(component, cmp, event, helper, response2) {
    var msg2 = response2.getReturnValue();
    if (msg2.substring(0, 5) === 'ERROR' && cmp.get('v.st_Comment') !== undefined) {
      console.log('ERROR: Secon call');
      helper.closeModal(component, event, helper);
      helper.saveLog(component, event, helper, 'ERROR: NewTask.secondCall', component.get('v.taskId'), $A.get('$SObjectType.CurrentUser.Id'), msg2.substring(5));
      helper.showToast($A.get('$Label.c.SER_EGS_NotCreateRemedy_lbl'), 'error', helper);
    } else {
      console.log('Second Call Ok');
      console.log(msg2);
      helper.closeModal(component, event, helper);
      helper.showToast($A.get('$Label.c.SER_EGS_CreateTaskSucc_lbl'), 'success', helper);
    }
  },
});