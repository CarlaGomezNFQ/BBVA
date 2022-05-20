({
  checkPermission: function(component) {
    return new Promise((resolve, reject) => {
      var action = component.get('c.checkPmnsOvrl');
      action.setParams({
        aHasAnalysId: component.get('v.recordId'),
      });
      action.setCallback(this, function(response) {
        var state = response.getState();
        if (state === 'SUCCESS') {
          var resp = JSON.parse(response.getReturnValue());
          if (resp.errorCode === '500') {
            component.set('v.errorCode', '');
            component.set('v.errorTitle', 'INCOMPLETE');
            component.set('v.message', resp.errorMessage);
            reject();
          } else {
            resolve();
          }
        } else if (state === 'ERROR') {
          var errors = response.getError();
          component.set('v.errorCode', '');
          component.set('v.errorTitle', 'ERROR');
          component.set('v.message', errors);
          reject();
        }
      });
      $A.enqueueAction(action);
    });
  },
  callPersistOverlay: function(component, event) {
    return new Promise(function(res, rej) {
      var action = component.get('c.callPersistModifiers');
      action.setParams({
        aHasAnalysId: component.get('v.recordId'),
        methodType: 'persistenceOverlays'
      });
      component.set('v.isLoading', true);
      action.setCallback(this, function(response) {
        var state = response.getState();
        var resp = response.getReturnValue();
        if (state === 'SUCCESS') {
          if (resp.serviceCode === '200' || resp.serviceCode === '201') {
            res();
          } else {
            var errorWrapper = JSON.parse(resp.serviceMessage);
            component.set('v.errorCode', $A.get('{!$Label.arce.Arc_Gen_RatingError_ErrorCode}') + ' ' + errorWrapper.errorCode);
            component.set('v.errorTitle', errorWrapper.errorTitle);
            component.set('v.message', errorWrapper.errorMessage);
            rej();
          }
        } else {
          component.set('v.message', $A.get('{!$Label.arce.Arc_Gen_HandleErrors_PersistModifiers}'));
          rej();
        }
      });
      $A.enqueueAction(action);
    });
  },
  callOverlayRating: function(component) {
    return new Promise(function(resolve, reject) {
      var action = component.get('c.callOverlayRating');
      action.setParams({
        aHasAnalysId: component.get('v.recordId')
      });

      action.setCallback(this, function(response) {
        var resp = response.getReturnValue();
        var state = response.getState();

        if (state === 'SUCCESS') {
          if (resp.serviceCode === '200' && resp.saveStatus === 'true') {
            resolve();
          } else if (resp.serviceCode !== '200') {
            var errorWrapper = JSON.parse(resp.serviceMessage);
            component.set('v.errorCode', $A.get('{!$Label.arce.Arc_Gen_RatingError_ErrorCode}') + ' ' + errorWrapper.errorCode);
            component.set('v.errorTitle', errorWrapper.errorTitle);
            component.set('v.message', errorWrapper.errorMessage);
            reject();
          }
        } else {
          component.set('v.message', $A.get('{!$Label.arce.Arc_Gen_HandleErrors_Ratings}'));
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