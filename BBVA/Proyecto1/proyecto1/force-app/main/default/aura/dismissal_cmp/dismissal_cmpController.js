({
  doInit: function(cmp, evt, helper) {
    helper.doInitDismissal(cmp, evt, helper);
  },
  handleDismissalCancel: function(cmp, evt, helper) {
    let cancelEvent = cmp.getEvent('dynamicFlowWizardCancel');
    cancelEvent.fire();
  },
  handleDismissalSave: function(cmp, evt, helper) {
    helper.doDismissalSave(cmp, evt, helper);
  },
  handleCommentsChange: function(cmp, evt, helper) {
    let commentsValue = cmp.find('comments').get('v.value');
    let hasPriceApproval = cmp.get('v.hasPriceApproval');
    let priceApprovalId = cmp.get('v.priceApprovalId');
    if (hasPriceApproval && priceApprovalId !== undefined) {
      if (commentsValue === '') {
        cmp.set('v.saveButtonDisabled', true);
      } else {
        cmp.set('v.saveButtonDisabled', false);
      }
    }
    cmp.set('v.commentsHiddenValue', commentsValue);
  }
});