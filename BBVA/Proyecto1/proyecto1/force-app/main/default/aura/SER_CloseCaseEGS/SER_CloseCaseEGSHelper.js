({
  fn_closeCaseHelper: function(component, event, helper, continuar) {
    if(continuar === false) {
      component.set('v.discard', event.getSource().get("v.name") === 'Discard Case' ? true : false);
    }
    console.log('Entering --> SER_CloseCaseEGS: fn_closeCase');
    $A.util.removeClass(component.find('Spinner'), 'slds-hide');
    var params = {'caseId': component.get('v.recordId'),
      'progress': component.get('v.bl_inProgress'),
      'trateAsMC': true,
      'discard': component.get('v.discard')
    };
    var fnCallback = function(response) {
      helper.trateResponseClose(component, event, helper, response);
    };
    helper.callServer(component, event, 'c.closeCase', params, fnCallback, helper);
  },

  fn_discardCaseHelper: function(component, event, helper, continuar) {
    if(continuar === false) {
      component.set('v.discard', true);
    }
    console.log('Entering --> SER_CloseCaseEGS: fn_openModal');
    $A.util.removeClass(component.find('Spinner'), 'slds-hide');
    var params = {'caseId': component.get('v.recordId'),
      'progress': component.get('v.bl_inProgress'),
      'trateAsMC': true,
      'discard': component.get('v.discard')
    };
    var fnCallback = function(response) {
      helper.trateResponseClose(component, event, helper, response);
    };
    helper.callServer(component, event, 'c.closeCase', params, fnCallback, helper);
  },

  trateResponseClose: function(component, event, helper, response) {
    var rspState = response.getState();
    $A.util.addClass(component.find('Spinner'), 'slds-hide');
    if (rspState === 'SUCCESS') {
      component.set('v.bl_inProgress', false);
      if (response.getReturnValue().substring(0, 5) === 'ERROR') {
        helper.fn_ShowCustomError(helper, response);
      } else if (response.getReturnValue().substring(0, 5) === 'PROGR') {
        console.log('There ara task in progress.');
        var message = response.getReturnValue().substring(5);
        if(message.includes('(Action Line)')) {
          if(component.get('v.discard') === false) {
            component.set('v.bl_continueButton', true);
            message += ' Before close a Master Case its necesary to close all \'Action Line\' Tasks.';
          } else {
            component.set('v.bl_continueButton', false);
            message += ' Do you want to continue?';
          }
        } else {
          component.set('v.bl_continueButton', false);
          message += component.get('v.discard') ? ' Are you sure you want to discard this case?' : ' Are you sure you want to close this case?';
        }
        component.set('v.message', message);
        component.set('v.bl_DisplayModal', true);
      } else {
        console.log('The case has been closed correctly');
        $A.get('e.force:refreshView').fire();
      }
    } else if (rspState === 'ERROR') {
      helper.fn_treatErrors(component, event, helper, response, 'ERROR: CloseCaseEGS.fn_closeCaseHelper', $A.get("{!$Label.c.SER_EGS_Reopen_Error_Notification_Tittle}"));
    } else {
      console.log('Failed with state ' + rspState);
    }
  },

  fn_resolveCaseHelper: function(component, event, helper) {
    console.log('Entering --> SER_CloseCaseEGS: fn_resolveCase');
    $A.util.removeClass(component.find('Spinner'), 'slds-hide');
    var params = {'caseId': component.get('v.recordId'),
      'progress': component.get('v.bl_inProgress')
    };
    var fnCallback = function(response) {
      $A.util.addClass(component.find('Spinner'), 'slds-hide');
      var rspState = response.getState();
      if (rspState === 'SUCCESS') {
        if (response.getReturnValue().substring(0, 5) === 'ERROR') {
          helper.fn_ShowCustomError(helper, response);
        } else {
          console.log('The case has been resolved correctly');
          component.set('v.bl_inProgress', false);
          component.set('v.bl_resolve', false);
          component.set('v.bl_reopen', true);
          component.set('v.bl_close', true);
          $A.get('e.force:refreshView').fire();
        }
      } else if (rspState === 'ERROR') {
        helper.fn_treatErrors(component, event, helper, response, 'ERROR: CloseCaseEGS.fn_resolveCaseHelper', $A.get("{!$Label.c.SER_EGS_Resolve_Error}"));
      } else {
        console.log('Failed with state ' + rspState);
      }
    };
    helper.callServer(component, event, 'c.resolveCase', params, fnCallback, helper);
  },

  fn_reopenCaseHelper: function(component, event, helper) {
    console.log('Entering --> SER_CloseCaseEGS: fn_reopenCaseHelper');
    $A.util.removeClass(component.find('Spinner'), 'slds-hide');
    var params = {'caseId': component.get('v.recordId')};
    var fnCallback = function(response) {
      $A.util.addClass(component.find('Spinner'), 'slds-hide');
      var rspState = response.getState();
      if (rspState === 'SUCCESS') {
        console.log('The case has been reopen correctly');
        component.set('v.bl_resolve', true);
        component.set('v.bl_reopen', false);
        component.set('v.bl_close', false);
        $A.get('e.force:refreshView').fire();
      } else if (rspState === 'ERROR') {
        helper.fn_treatErrors(component, event, helper, response, 'ERROR: CloseCaseEGS.fn_reopenCaseHelper', $A.get("{!$Label.c.SER_EGS_Reopen_Error}"));
      } else {
        console.log('Failed with state ' + rspState);
      }
    };
    helper.callServer(component, event, 'c.reopenCase', params, fnCallback, helper);
  },

  fn_cloneCaseHelper: function(component, event, helper) {
    //get Case record Id
    $A.util.removeClass(component.find('Spinner'), 'slds-hide');
    var action = component.get('c.cloneCase');
    action.setParams({'caseId': component.get('v.recordId')});
    //configure action handler
    action.setCallback(this, function(response) {
      $A.util.addClass(component.find('Spinner'), 'slds-hide');
      var state = response.getState();
      if (state === 'SUCCESS') {
        //Si devuelve algo significa que ha creado un caso nuevo
        if (response.getReturnValue() != null) {
            console.log('saveCloneCase ok');
            component.set('v.caseCloneId', response.getReturnValue());
            $A.get('e.force:refreshView').fire();
            var navEvt = $A.get('e.force:navigateToSObject');
            navEvt.setParams({
            'recordId': component.get('v.caseCloneId'),
            'slideDevName': 'related'
            });
            navEvt.fire();
            var staticLabel = $A.get('$Label.c.SER_Clone_Case_Information_PopUp');
            helper.getMSGResult(staticLabel, 'success', 'Success!');
            helper.fn_cloneEmailMessage(component, event, helper);
        } else { //si no devuelve nada, no lo ha creado porque ya existe uno creado
            var staticLabel2 = $A.get('$Label.c.SER_Clone_Case_Warning_PopUp');
            helper.getMSGResult(staticLabel2, 'warning', 'Warning!');
        }
      } else {
        console.log('Problem getting, response state : ' + state);
        var errors = response.getError();
        if (errors[0] !== null && errors[0].message !== null && errors[0].message !== '') {
          console.log('Error message: ' + errors[0].message);
          helper.getMSGResult(errors[0].message, 'error', 'Error Message');
        }
      }
    });
    $A.enqueueAction(action);
  },
  fn_cloneEmailMessage: function(component, event, helper) {
    //get Case record Id
    var action = component.get('c.cloneEmailMessage');
    action.setParams({'caseId': component.get('v.recordId'),
                     'caseCId': component.get('v.caseCloneId')});
    //configure action handler
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (state === 'SUCCESS') {
        console.log('saveCloneEmailMessage ok');
      } else {
        console.log('Problem getting, response state : ' + state);
        var errors = response.getError();
        if (errors[0] !== null && errors[0].message !== null && errors[0].message !== '') {
          console.log('Error message: ' + errors[0].message);
          helper.getMSGResult(errors[0].message, 'error', 'Error Message');
        }
      }
    });
    $A.enqueueAction(action);
  },
  fn_discardcc: function(component, event, helper) {
    //get Case record Id
    var action = component.get('c.updateCasoP');
    action.setParams({'caseId': component.get('v.recordId')});
    //configure action handler
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (state === 'SUCCESS') {
        console.log('saveDiscardClientComment ok');
        window.location.reload();
      } else {
        console.log('Problem getting, response state : ' + state);
        var errors = response.getError();
        if (errors[0] !== null && errors[0].message !== null && errors[0].message !== '') {
          console.log('Error message: ' + errors[0].message);
          helper.getMSGResult(errors[0].message, 'error', 'Error Message');
        }
      }
    });
    $A.enqueueAction(action);
  },
  fn_treatErrors: function(component, event, helper, response, errorSubject, message) {
    var errors = response.getError();
    if (errors) {
      if (errors[0] && errors[0].message) {
        var messageError = errors[0].message;
        console.log('Error message: ' + messageError);
        helper.saveLog(component, event, helper, errorSubject, component.get('v.recordId'), $A.get('$SObjectType.CurrentUser.Id'), messageError);
        helper.showToastError(message, 'error', helper);
      }
    } else {
      console.log('Unknown error');
    }
  },

  fn_ShowCustomError: function(helper, response) {
    console.log('Error: ' + response.getReturnValue().substring(5));
    helper.showToastError('Error: ' + response.getReturnValue().substring(5), 'error');
  },

  getMSGResult: function(message, type, title) {
    var toastEvent = $A.get('e.force:showToast');
    toastEvent.setParams({
      title: title,
      message: message,
      type: type,
      mode: 'pester',
      duration: '5000'
    });
    toastEvent.fire();
  }
});