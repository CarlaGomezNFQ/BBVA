({
  doInit: function(cmp, evt, helper) {
    helper.doInitialChecks(cmp, evt, helper);
  },
  handleAddForfaitCancel: function(cmp, evt, helper) {
    helper.destroyCmp(cmp, evt, helper);
  },
  handleAddForfaitSave: function(cmp, evt, helper) {
    $A.util.removeClass(cmp.find('loadSpinner'), 'slds-hide');
    let mapValues = helper.getFormValues(cmp, evt, helper);
    let checkForm = helper.checkForm(cmp, evt, helper, mapValues);
    if (checkForm) {
      cmp.set('v.showErrMessage', false);
      helper.addNewForfait(cmp, evt, helper, mapValues);
    } else {
      $A.util.addClass(cmp.find('loadSpinner'), 'slds-hide');
      cmp.set('v.showErrMessage', true);
    }
  }
});