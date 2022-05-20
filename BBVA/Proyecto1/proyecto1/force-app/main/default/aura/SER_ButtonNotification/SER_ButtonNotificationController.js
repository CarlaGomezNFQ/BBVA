({
  doInit: function(component, event, helper) {
    //get Case record Id
    var action = component.get('c.getCase');
    action.setParams({'caseId': component.get('v.recordId')});

    //configure action handler
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (state === 'SUCCESS') {
        console.log('entro al doInit');
        component.set('v.EmailNotCases', response.getReturnValue());
      } else {
        console.log('Problem getting, response state : ' + state);
      }
    });
    $A.enqueueAction(action);
  },
  requestCaseEmailNotification: function(component, event, helper) {
    var action = component.get('c.updateCallCaseEmailNotifications');
    action.setParams({
      'emailNotifiCase': component.get('v.EmailNotCases')
    });
    action.setCallback(this, function(response) {
      var state = response.getState();
      var result = response.getReturnValue();
      if (state === 'SUCCESS') {
        if (result.blnIsSuccess) {
          helper.getMsgResult(result.strSuccessMsg, 'success', 'Success:', event);
        } else {
          helper.getMsgResult(result.strErrorMsg, 'error', 'Error:', event);
        }
      } else if (state === 'ERROR') {
        console.log('Problem updating call, response state ' + state);
      } else {
        console.log('Unknown problem: ' + state);
      }
    });

    //send the request to updateCallNotif
    $A.enqueueAction(action);
  }
});