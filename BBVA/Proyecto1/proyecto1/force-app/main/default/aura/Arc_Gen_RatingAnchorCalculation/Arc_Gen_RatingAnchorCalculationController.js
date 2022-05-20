({
  doInit: function(component, event, helper) {
    helper.checkCompleteness(component, event, helper)
      .then(function(result) {
        helper.callMultiPersistenceEngine(component, event, helper);
      }).catch(function(err) {
      });
  }
});