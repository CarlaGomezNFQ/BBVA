({
  doInitHelper: function(component, event, helper, refresh) {
    console.log('entro en Init de Remedy Tab Controller');
    var action = component.get('c.loadTasks');
    action.setParams({
      'recordId': component.get('v.recordId')
    });
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (component.isValid() && state === 'SUCCESS') {
        console.log('SUCCESS');
        component.set('v.task', response.getReturnValue().task);
        component.set('v.bl_isIncidence', response.getReturnValue().isIncidence);
        console.log('isIncidence: ' + response.getReturnValue().isIncidence);
        if(refresh) {
          $A.get('e.force:refreshView').fire();
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
  }
});