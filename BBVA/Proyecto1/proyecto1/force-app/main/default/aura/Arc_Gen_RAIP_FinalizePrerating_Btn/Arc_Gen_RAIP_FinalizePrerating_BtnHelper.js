({
  callFinalizeRaip: function(component, arceId) {
    const action = component.get('c.finalizePrerating');

    action.setParams({ arceId });

    return new Promise(function(resolve, reject) {
      action.setCallback(this, function(response) {
        let state = response.getState();

        if (state === 'SUCCESS') {
          resolve();
        } else {
          reject(response.getError());
        }
      });

      $A.enqueueAction(action);
    });
  },
  refreshTab: function() {
    window.setTimeout($A.getCallback(function() {
      window.location.reload();
    }), 2500);
  }
});