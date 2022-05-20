/* eslint-disable no-unused-expressions */
({
  checkStatus: function(component, event, helper) {
    var profAnalysisId = component.get('v.inputAttributes').recordId;

    // Get detail content
    var action = component.get('c.approvePrice');
    action.setParams({
      'profAnalysisId': profAnalysisId
    });
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (component.isValid() && state === 'SUCCESS') {
        var ret = response.getReturnValue();
        if (ret.status === true) {
          helper.doStatusOk(component, event, helper, ret.message, ret.success);
        } else if (ret.status === false) {
          if (ret.message === null || ret.message === undefined) {
            helper.showNewToastApprovePrice('error', $A.get('$Label.cuco.price_approve_error_generic'));
            $A.get('e.force:refreshView').fire();
            helper.destroyCmp(component, event, helper);
          } else {
            helper.showNewToastApprovePrice('error', $A.get('$Label.cuco.price_approve_error_detail') + ' ' + ret.message);
            $A.get('e.force:refreshView').fire();
            helper.destroyCmp(component, event, helper);
          }
        } else {
          helper.doStatusOk(component, event, helper, ret.message, ret.success);
        }
      } else if (response.getState() === 'ERROR') {
        helper.showNewToastApprovePrice('error', response.getError()[0].message);
        $A.get('e.force:refreshView').fire();
        helper.destroyCmp(component, event, helper);
      }
    });
    $A.enqueueAction(action);
  },
  showNewToastApprovePrice: function(type, message) {
    let titleApproveToast;
    let modeToast;
    switch (type) {
      case 'success':
        titleApproveToast = $A.get('$Label.cuco.toast_title_success');
        break;
      case 'warning':
        titleApproveToast = $A.get('$Label.cuco.toast_title_warning');
        break;
      case 'error':
        titleApproveToast = $A.get('$Label.cuco.toast_title_error');
        break;
      case 'errorStick':
        titleApproveToast = $A.get('$Label.cuco.toast_title_error');
        type = 'error';
        modeToast = 'sticky';
        break;
    }
    var newApproveToast = $A.get('e.force:showToast');
    newApproveToast.setParams({
      'title': titleApproveToast,
      'type': type,
      'message': message,
      'mode': modeToast
    });
    newApproveToast.fire();
  },
  doActionSuccess: function(component, event, helper, message) {
    // launch toast with message
    helper.showNewToastApprovePrice('success', message);

    // refresh view and close
    $A.get('e.force:refreshView').fire();
    helper.destroyCmp(component, event, helper);
  },
  doStatusOk: function(component, event, helper, message, success) {
    if (success === true) {
      helper.doActionSuccess(component, event, helper, message);
    } else {
      helper.showNewToastApprovePrice('errorStick', message);
      helper.destroyCmp(component, event, helper);
    }
  }
});