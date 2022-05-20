({
  doInit: function(cmp, evt, helper) {
    helper.doInitialGipChecks(cmp, evt, helper);
  },
  handleAddGipCancel: function(cmp, evt, helper) {
    helper.destroyCmp(cmp, evt, helper);
  },
  handleAddGipSave: function(cmp, evt, helper) {
    $A.util.removeClass(cmp.find('loadSpinner'), 'slds-hide');
    let mapGipValues = helper.getGipFormValues(cmp, evt, helper);
    let checkForm = helper.checkGipForm(cmp, evt, helper, mapGipValues);
    if (checkForm) {
      cmp.set('v.showErrMessage', false);
      helper.addNewGip(cmp, evt, helper, mapGipValues);
    } else {
      $A.util.addClass(cmp.find('loadSpinner'), 'slds-hide');
      cmp.set('v.showErrMessage', true);
    }
  }
});