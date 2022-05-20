({
  doInit: function(component, event, helper) {
    component.set('v.spinner', 'true');
    helper.getInfoAnalysis(component, event, helper)
      .then(function(resolveInfo) {
        helper.validationsBeforeCall(component, event, helper)
          .then(function(resolve) {
            helper.callRatingEngine(component, helper, 'c.setupRating')
              .then(function(resolve2) {
                if (resolve2 === 'true') {
                  component.set('v.message', $A.get('{!$Label.c.Lc_arce_successAndCloseWindow}'));
                  component.set('v.success', 'yes');
                  helper.refreshRating(component);
                  component.set('v.spinner', 'false');
                }
              })
              .catch(function(error) {
                helper.cancelAction(component);
              });
          })
          .catch(function(error) {
            helper.cancelAction(component);
          });
      })
      .catch(function(error) {
        helper.cancelAction(component);
      });
  }
});