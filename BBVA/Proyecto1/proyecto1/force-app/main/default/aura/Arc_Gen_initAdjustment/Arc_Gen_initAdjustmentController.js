({
  doInit: function(component, event, helper) {
    helper.getRatingId(component, event, helper)
      .then(function(result) {
        return helper.processInit(component, event, helper);
      }).catch(function(error) {
        let message = error;
        let type = 'Error';
        helper.fireToast(type, message);
      });
  }
});