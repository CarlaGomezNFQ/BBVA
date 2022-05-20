({
  doInit: function(cmp, evt, helper) {
    helper.fillGipEditForm(cmp, evt, helper);
  },
  handleEditGipCancel: function(cmp, evt, helper) {
    helper.destroyCmp(cmp, evt, helper);
  },
  handleEditGipSave: function(cmp, evt, helper) {
    $A.util.removeClass(cmp.find('loadSpinner'), 'slds-hide');
    let mapGipEditValues = helper.getGipEditFormValues(cmp, evt, helper);
    let checkForm = helper.checkEditGipForm(cmp, evt, helper, mapGipEditValues);
    if (checkForm) {
      cmp.set('v.showErrMessage', false);
      helper.editNewGip(cmp, evt, helper, mapGipEditValues);
    } else {
      $A.util.addClass(cmp.find('loadSpinner'), 'slds-hide');
      cmp.set('v.showErrMessage', true);
    }
  }
});