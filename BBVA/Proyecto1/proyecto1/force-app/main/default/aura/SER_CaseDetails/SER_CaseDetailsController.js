({
  doInit: function(component, event, helper) {
    console.log('entro en Init de Case Details');
    var action = component.get('c.getCase');
    var taskId = component.get('v.recordId');
    action.setParams({
      'taskId': taskId
    });
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (component.isValid() && state === 'SUCCESS') {
        console.log('SUCCESS');
        component.set('v.case', response.getReturnValue());
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
});