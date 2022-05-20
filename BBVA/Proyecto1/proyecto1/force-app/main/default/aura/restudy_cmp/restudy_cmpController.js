({
  doInit: function(cmp, evt, helper) {
    helper.doInitRestudy(cmp, evt, helper);
  },
  handleRestudyCancel: function(cmp, evt, helper) {
    let cancelEvent = cmp.getEvent('dynamicFlowWizardCancel');
    cancelEvent.fire();
  },
  handleRestudySave: function(cmp, evt, helper) {
    helper.doDismissalSave(cmp, evt, helper);
  },
  handleRestudyCommentsChange: function(cmp, evt, helper) {
    let commentsValue = cmp.find('comments').get('v.value');
    let commentsRequired = cmp.get('v.commentsRequired');
    if (commentsRequired) {
      if (commentsValue === '') {
        cmp.set('v.saveButtonDisabled', true);
      } else {
        cmp.set('v.saveButtonDisabled', false);
      }
    }
    cmp.set('v.commentsHiddenValue', commentsValue);
  }
});