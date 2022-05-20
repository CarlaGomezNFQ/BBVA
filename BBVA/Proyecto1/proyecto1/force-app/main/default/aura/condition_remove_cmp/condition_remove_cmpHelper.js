/* eslint-disable no-unused-expressions */
({
  doInit: function(cmp, event, helper) {
    var action = cmp.get('c.getConditionName');
    action.setParams({
      paConditionId: cmp.get('v.conditionId')
    });
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (state === 'SUCCESS') {
        var ret = response.getReturnValue();
        var question = $A.get('$Label.cuco.remove_cond_confirmation_pre') + ' ' + ret.name + ' ' + $A.get('$Label.cuco.remove_cond_confirmation_post');
        cmp.set('v.question', question);
        cmp.set('v.showInformativeWarning', ret.formMethod === 'Informative');
      } else if (state === 'INCOMPLETE') {
        console.log('INCOMPLETE', response);
      } else if (state === 'ERROR') {
        var errors = response.getError();
        if (errors) {
          if (errors[0] && errors[0].message) {
            console.error('Error message: ' + errors[0].message);
          }
        } else {
          console.error('Unknown error');
        }
      }
    });
    $A.enqueueAction(action);
  },

  handleRemove: function(cmp, event, helper) {
    var action = cmp.get('c.removeCondition');
    action.setParams({
      profAnalysisId: cmp.get('v.recordId'),
      conditionId: cmp.get('v.conditionId')
    });
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (state === 'SUCCESS') {
        var result = response.getReturnValue();
        if (result.isSuccess) {
          helper.refreshConditions(cmp, event, helper);
        } else {
          helper.showToast('error', $A.get('$Label.cuco.remove_condition_error'));
          console.error(result.lstErrMessage);
        }
        helper.destroyCmp(cmp, event, helper);
      } else if (state === 'INCOMPLETE') {
        console.log('INCOMPLETE', response);
      } else if (state === 'ERROR') {
        var errors = response.getError();
        if (errors) {
          if (errors[0] && errors[0].message) {
            console.error('Error message: ' + errors[0].message);
          }
        } else {
          console.error('Unknown error');
        }
      }
    });
    $A.enqueueAction(action);
  },

  refreshConditions: function(cmp, event, helper) {
    var evt = $A.get('e.cuco:refresh_conditions_evt');
    evt.setParams({ contextId: cmp.get('v.recordId') });
    evt.fire();
  },

  showToast: function(type, title, message) {
    var toastEvent = $A.get('e.force:showToast');
    toastEvent.setParams({
      title: title,
      message: message,
      duration: 5000,
      key: 'info_alt',
      type: type,
      mode: 'dismissible'
    });
    toastEvent.fire();
  }

});