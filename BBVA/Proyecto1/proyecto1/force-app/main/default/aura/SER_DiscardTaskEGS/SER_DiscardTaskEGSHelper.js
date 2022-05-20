({
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
  }
});