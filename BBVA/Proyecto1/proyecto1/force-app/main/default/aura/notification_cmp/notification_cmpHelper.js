({
  doInitNotification: function(cmp, evt, helper) {
    cmp.set('v.recordId', cmp.get('v.inputAttributes').recordId);
    cmp.set('v.saveButtonDisabled', true);
    cmp.set('v.isSuccess', true);
  },
  doNotificationSave: function(cmp, evt, helper) {
    let auditNotificationHtml  = document.getElementById('auditBody').innerHTML;
    $A.util.removeClass(cmp.find('simpleSpinner'), 'slds-hide');
    let actionNotification = cmp.get('c.doNotificationSave');
    actionNotification.setParams({
      'profAnalysisId': cmp.get('v.recordId'),
      'notificationComments': cmp.find('commentsNotification').get('v.value'),
      'screenShot': auditNotificationHtml
    });
    actionNotification.setCallback(this, function(responseNotification) {
      $A.util.addClass(cmp.find('simpleSpinner'), 'slds-hide');
      if (responseNotification.getState() === 'SUCCESS') {
        let ret = responseNotification.getReturnValue();
        if (ret.isSuccess) {
          helper.showNewToastNotification('success', ret.message, 'pester');
          $A.get('e.force:refreshView').fire();
          helper.destroyCmp(cmp, evt, helper);
        } else {
          helper.showNewToastNotification('error', ret.errMessage, 'sticky');
        }
      } else if (responseNotification.getState() === 'ERROR') {
        helper.showNewToastNotification('error', responseNotification.getError()[0].message, 'sticky');
        let cancelEvent = cmp.getEvent('dynamicFlowWizardCancel');
        cancelEvent.fire();
      }
    });
    $A.enqueueAction(actionNotification);
  },
  showNewToastNotification: function(type, message, mode) {
    let titleNotificationToast;
    switch (type) {
      case 'success':
        titleNotificationToast = $A.get('$Label.cuco.toast_title_success');
        break;
      case 'warning':
        titleNotificationToast = $A.get('$Label.cuco.toast_title_warning');
        break;
      case 'error':
        titleNotificationToast = $A.get('$Label.cuco.toast_title_error');
        break;
    }
    var newNotificationToast = $A.get('e.force:showToast');
    newNotificationToast.setParams({
      'mode': mode,
      'title': titleNotificationToast,
      'type': type,
      'message': message
    });
    newNotificationToast.fire();
  }
});