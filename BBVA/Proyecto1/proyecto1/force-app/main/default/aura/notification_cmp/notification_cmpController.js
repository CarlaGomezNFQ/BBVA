({
  doInit: function(cmp, evt, helper) {
    helper.doInitNotification(cmp, evt, helper);
  },
  handleNotificationCancel: function(cmp, evt, helper) {
    let cancelEvent = cmp.getEvent('dynamicFlowWizardCancel');
    cancelEvent.fire();
  },
  handleNotificationSave: function(cmp, evt, helper) {
    helper.doNotificationSave(cmp, evt, helper);
  },
  handleNotificationCommentsChange: function(cmp, evt, helper) {
    let commentsNotificationValue = cmp.find('commentsNotification').get('v.value');
    if (commentsNotificationValue === '') {
      cmp.set('v.saveButtonDisabled', true);
    } else {
      cmp.set('v.saveButtonDisabled', false);
    }
    cmp.set('v.commentsNotificationHiddenValue', commentsNotificationValue);
  }
});