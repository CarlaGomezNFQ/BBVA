({
  setChart: function(component, event, helper, collectionType) {
    var chartWrapper;
    var action = component.get('c.getWrapper');
    action.setParams({
      collectionType: collectionType,
      acttyId: component.get('v.recordId'),
      aHasAnalysId: component.get('v.recordId')});
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (state === 'SUCCESS') {
        chartWrapper = response.getReturnValue();
        let collectionModified = collectionType.split(component.get('v.modelSelctd'))[0];
        component.set('v.' + collectionModified, chartWrapper);
        component.set('v.loaded' + collectionModified, true);
      } else {
        var errors = response.getError();
        var message;
        var typology = 'Error';
        if (errors) {
          if (errors[0] && errors[0].message) {
            message = 'Error message: ' + errors[0].message;
            helper.fireToast(typology, message);
          }
        } else {
          message = 'Unknown error';
          helper.fireToast(typology, message);
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
      'message': message
    });
    toastError.fire();
  }
});