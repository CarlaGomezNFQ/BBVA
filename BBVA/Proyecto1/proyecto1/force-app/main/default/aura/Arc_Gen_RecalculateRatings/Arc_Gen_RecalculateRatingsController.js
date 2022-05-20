({
  doInit: function(component, event, helper) {
    helper.initHandler(component, event, helper)
      .then(function(result) {
        return helper.recalculateRating(component);
      })
      .then(function(result) {
        helper.ratingProcessOK(component);
      })
      .catch(function(err) {
        helper.cancelAction(component);
      });
  }
});