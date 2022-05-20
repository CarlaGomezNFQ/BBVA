({
  doInit: function(component, event, helper) {
    console.log('entro en Init de CloseCaseEGS');
    var action = component.get('c.initCloseCase');
    action.setParams({
      'caseId': component.get('v.recordId')
    });
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (component.isValid() && state === 'SUCCESS') {
        console.log('SUCCESS');
        var resp = response.getReturnValue().split(';');
        if (resp[0] === 'Resolved') {
          component.set('v.bl_close', true);
          component.set('v.bl_reopen', true);
          component.set('v.bl_discard', true);
        } else if (resp[0] === 'Closed') {
          component.set('v.bl_reopen', true);
          component.set('v.bl_discard', false);
          component.set('v.bl_clone', resp[1]);
          component.set('v.bl_discardcc', resp[1]);
        } else {
          component.set('v.bl_resolve', true);
          component.set('v.bl_discard', true);
        }
      } else if (state === 'ERROR') {
        var errors = response.getError();
        if (errors) {
          if (errors[0] && errors[0].message) {
            console.log('Error message: ' + errors[0].message);
          }
        } else {
          console.log('Unknown error');
        }
      } else {
        console.log('Failed with state ' + state);
      }
    });
    $A.enqueueAction(action);
  },

  fn_closeCase: function(component, event, helper) {
    helper.fn_closeCaseHelper(component, event, helper, false);
  },

  fn_reopenCase: function(component, event, helper) {
    helper.fn_reopenCaseHelper(component, event, helper);
  },

  fn_cloneCase: function(component, event, helper) {
    helper.fn_cloneCaseHelper(component, event, helper);
  },

  fn_resolveCase: function(component, event, helper) {
    helper.fn_resolveCaseHelper(component, event, helper);
  },

  fn_discardcc: function(component, event, helper) {
    helper.fn_discardcc(component, event, helper);
  },

  fn_CloseModal: function(component, event, helper) {
    component.set('v.bl_DisplayModal', false);
    component.set('v.bl_confirmDiscard', false);
  },

  fn_Continue: function(component, event, helper) {
    component.set('v.bl_inProgress', true);
    component.set('v.bl_DisplayModal', false);
    helper.fn_closeCaseHelper(component, event, helper, true);
  },

  fn_openModal: function(component, event, helper) {
    component.set('v.bl_confirmDiscard', true);
  },

  fn_continueDiscard: function(component, event, helper) {
    component.set('v.bl_confirmDiscard', false);
    component.set('v.bl_DisplayModal', false);
    helper.fn_discardCaseHelper(component, event, helper, false);
  },
});