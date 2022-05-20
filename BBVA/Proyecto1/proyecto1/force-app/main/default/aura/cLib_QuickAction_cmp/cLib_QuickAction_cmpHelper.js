({//eslint-disable-line
  initialize: function(cmp, evt, helper) {
    let promise = helper.getQuickActionMtdt(cmp, evt, helper);
    promise.then(function() {
      helper.fireQuickAction(cmp, evt, helper);
    });
  },
  getQuickActionMtdt: function(cmp, evt, helper) {
    return new Promise(function(resolve) {
      let action = cmp.get('c.getQuickAction');
      action.setParams({devName: cmp.get('v.quickActionName')});
      action.setCallback(this, function(response) {
        if (cmp.isValid() && response.getState() === 'SUCCESS') {
          let ret = response.getReturnValue();
          if (ret !== null) {
            cmp.set('v.quickActionMdt', ret);
            resolve();
          } else {
            helper.fireToast('Error', $A.get('$Label.bbvacep.clib_NoQuickActionFound').replace('{!#}', cmp.get('v.quickActionName')));
            helper.closeQuickAction(cmp);
          }
        } else {
          helper.fireToast('Error', $A.get('$Label.bbvacep.clib_LightningMethodError').replace('{!#}', 'getQuickActionMtdt'));
          helper.closeQuickAction(cmp);
        }
      });
      $A.enqueueAction(action);
    });
  },
  fireQuickAction: function(cmp, evt, helper) {
    let action = cmp.get('c.callQuickActionMethod');
    action.setParams({quickAction: cmp.get('v.quickActionMdt'), recordId: cmp.get('v.recordId')});
    action.setCallback(this, function(response) {
      if (cmp.isValid() && response.getState() === 'SUCCESS') {
        let ret = response.getReturnValue();
        if (cmp.get('v.showToast') && ret && ret.indexOf('#') !== -1) {
          let toastList = ret.split('#');
          helper.fireToast(toastList[0], toastList[1]);
        }
      } else {
        helper.fireToast('Error', $A.get('$Label.bbvacep.clib_LightningMethodError').replace('{!#}', 'fireQuickAction'));
      }
      helper.closeQuickAction(cmp);
    });
    $A.enqueueAction(action);
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
  closeQuickAction: function(cmp) {
    if (cmp.get('v.closeOnComplete')) {
      $A.get('e.force:closeQuickAction').fire();
    }
  }
});