({
  doInit: function(component, event, helper) {

    component.set('v.isLoading', true);
    helper.getRatingId(component)
      .then(function(result) {
        return helper.checkPermission(component);
      })
      .then(function(result) {
        return helper.checkCompleteness(component);
      })
      .then(function(result) {
        return helper.checkModifiers(component, event);
      })
      .then(function(result) {
        return helper.callMultiPersistenceEngine(component, event, helper);
      })
      .then(function(result) {
        return helper.callPersistModifiers(component, event);
      })
      .then(function(result) {
        return helper.callRatingEngine(component);
      })
      .then(function(result) {
        helper.ratingProcessOK(component);
      })
      .catch(function(err) {
        helper.cancelAction(component);
      });
  }
});