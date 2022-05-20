/* eslint-disable no-unused-expressions */
({
  doInit: function(cmp, event, helper) {
    helper.waiting(cmp);
    var action = cmp.get('c.getConditionsValues');
    action.setParams({
      profAnalysisId: cmp.get('v.recordId'),
      familyId: cmp.get('v.familyId'),
      conditionsIncluded: cmp.get('v.conditions')
    });
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (state === 'SUCCESS') {
        cmp.set('v.conditionAttValuesJSON', response.getReturnValue());
        cmp.set('v.loaded', true);
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
      helper.doneWaiting(cmp);
    });
    $A.enqueueAction(action);
  },

  handleContinue: function(cmp, event, helper) {
    helper.waiting(cmp);
    let childEditForm = cmp.find('childEditForm');
    childEditForm.save();
  },

  handleEventSave: function(cmp, event, helper) {
    var success = event.getParam('success');
    var errorMessages = event.getParam('errorMessages');
    if (success) {
      let refreshConditionsEvent  = $A.get('e.cuco:refresh_conditions_evt');
      refreshConditionsEvent.setParams({'contextId': cmp.get('v.recordId')});
      refreshConditionsEvent.fire();
      helper.doneWaiting(cmp);
      helper.destroyCmp(cmp, event, helper);
    } else {
      helper.doneWaiting(cmp);
      let errors = JSON.parse(errorMessages);
      cmp.set('v.errors', errors);
      cmp.set('v.showWarning', true);
    }
  },

  waiting: function(cmp) {
    cmp.set('v.waiting', true);
  },

  doneWaiting: function(cmp) {
    cmp.set('v.waiting', false);
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