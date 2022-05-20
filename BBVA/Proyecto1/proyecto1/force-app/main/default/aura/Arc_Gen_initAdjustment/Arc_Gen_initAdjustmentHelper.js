({
  getRatingId: function(component, event, helper) {
    return new Promise((resolve, reject) => {
      var action = component.get('c.getRtngIdRiskAss');
      action.setParams({
        aHasAnalysId: component.get('v.recordId'),
      });
      action.setCallback(this, function(response) {
        var state = response.getState();
        if (state === 'ERROR') {
          var errors = response.getError();
          helper.fireToast('Error Getting Rating Id', errors, 'ERROR');
          reject();
        } else if (state === 'SUCCESS') {
          let ratingIdRes = response.getReturnValue();
          if (ratingIdRes.saveStatus && ratingIdRes.serviceCode.includes('20')) {
            resolve();
          } else {
            let message = 'ServiceMessage: ' + ratingIdRes.serviceMessage + ' SaveMessage: ' + ratingIdRes.saveMessage + 'status';
            helper.fireToast('Error Getting Rating Id', message, 'ERROR');
            reject();
          }
        }
      });
      $A.enqueueAction(action);
    });
  },
  processInit: function(component, event, helper) {
    return new Promise((resolve, reject) => {
      var action = component.get('c.clientInfo');
      action.setParams({
        aHasAnalysId: component.get('v.recordId'),
      });
      action.setCallback(this, function(response) {
        var state = response.getState();
        if (state === 'SUCCESS') {
          let ratingIdRes = response.getReturnValue();
          if (ratingIdRes.serviceCode === '300') {
            helper.fireToast('Attention', ratingIdRes.serviceMessage, 'WARNING');
            helper.refreshTab(component);
            resolve();
          } else if (ratingIdRes.refreshTab && ratingIdRes.saveStatus && ratingIdRes.serviceCode.includes('20')) {
            helper.refreshTab(component);
            resolve();
          } else if (!ratingIdRes.refreshTab && ratingIdRes.serviceCode.includes('20')) {
            resolve();
          } else {
            let message = 'ServiceMessage: ' + ratingIdRes.serviceMessage + ' SaveMessage: ' + ratingIdRes.saveMessage;
            helper.fireToast('Error Getting Client Data', message, 'ERROR');
            reject();
          }
        } else if (state === 'ERROR') {
          var errors = response.getError();
          helper.fireToast('Error Getting Client Data', errors, 'ERROR');
          reject();
        }
      });
      $A.enqueueAction(action);
    });
  },
  fireToast: function(title, message, type) {
    let toastError = $A.get('e.force:showToast');
    toastError.setParams({
      'title': title + '!',
      'type': type,
      'message': message,
      'duration': 15000
    });
    toastError.fire();
  },

  refreshTab: function(component) {
    var tabRefresh = $A.get('e.dyfr:SaveObject_evt');
    tabRefresh.setParams({
      'recordId': component.get('v.recordId')
    });
    tabRefresh.fire();
  }
});