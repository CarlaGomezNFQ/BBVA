({
  doInit: function(component, event, helper) {
    console.log('entro en Init de Remedy_TaskComment');
    var action = component.get('c.loadComments');
    action.setParams({
      'recordId': component.get('v.recordId')
    });
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (component.isValid() && state === 'SUCCESS') {
        console.log('SUCCESS');
        component.set('v.comments', response.getReturnValue().comments);
        component.set('v.showComments', response.getReturnValue().showComments);
        console.log('showComments: ' + response.getReturnValue().showComments);
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