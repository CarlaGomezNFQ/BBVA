({
  initHandler: function(component, event) {
    return new Promise(function(resolve, reject) {
      var action = component.get('c.calculateParentRatings');
      action.setParams({
        aHasAnalysId: component.get('v.recordId')
      });
      action.setCallback(this, function(response) {
        var state = response.getState();
        if (state === 'SUCCESS') {
          resolve();
          var res = response.getReturnValue();
          if (res.status !== 'Success') {
            component.set('v.cclients', res.cclients);
            resolve();
          } else {
            reject();
          }
        } else {
          reject();
        }
      });
      $A.enqueueAction(action);
    });
  },

  recalculateRating: function(component) {
    return new Promise(function(resolve, reject) {
      var action = component.get('c.recalculateRating');
      action.setParams({
        aHasAnalysId: component.get('v.recordId'),
        cclients: component.get('v.cclients')
      });
      action.setCallback(this, function(response) {
        var resp = response.getReturnValue();
        var state = response.getState();

        if (state === 'SUCCESS') {
          if (resp.status === 'Success') {
            resolve();
          } else {
            component.set('v.errorTitle', resp.status);
            component.set('v.message', resp.message);
            reject();
          }
        } else {
          component.set('v.message', $A.get('{!$Label.arce.Lc_arce_newAnalysisError}'));
          reject();
        }
      });
      $A.enqueueAction(action);
    });
  },

  ratingProcessOK: function(component) {
    component.set('v.message', $A.get('{!$Label.arce.Lc_arce_successAndCloseWindow}'));
    component.set('v.success', 'yes');
    this.refreshRating(component);
    component.set('v.isLoading', 'false');
  },

  cancelAction: function(component) {
    component.set('v.success', 'no');
    component.set('v.isLoading', 'false');
  },

  fireToast: function(type, message) {
    let toastError = $A.get('e.force:showToast');
    toastError.setParams({
      'title': type + '!',
      'type': type.toLowerCase(),
      'message': message
    });
    toastError.fire();
  },

  refreshRating: function(component) {
    var tabRefresh = $A.get('e.dyfr:SaveObject_evt');
    tabRefresh.setParams({
      'recordId': component.get('v.recordId')
    });
    tabRefresh.fire();
  }
});