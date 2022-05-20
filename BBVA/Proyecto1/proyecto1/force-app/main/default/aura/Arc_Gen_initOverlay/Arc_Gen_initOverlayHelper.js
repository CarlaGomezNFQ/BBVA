({
  initHandler: function(component, event, helper) {
    var action = component.get('c.calculateParentRatings');
    action.setParams({
      aHasAnalysId: component.get('v.recordId')
    });
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (state === 'SUCCESS') {
        var res = response.getReturnValue();
        if (res.status !== 'Success') {
          component.set('v.cclients', res.cclients);
          helper.fireToast(res.status, res.message);
        }
      }
    });
    $A.enqueueAction(action);
  },
  fireToast: function(type, message) {
    let toastError = $A.get('e.force:showToast');
    toastError.setParams({
      'title': type + '!',
      'type': type.toLowerCase(),
      'message': message,
      'duration': 50000
    });
    toastError.fire();
  }
});