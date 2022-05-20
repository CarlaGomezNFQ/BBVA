({
  doInit: function(cmp, evt, helper) {
    helper.fillForfaitEditForm(cmp, evt, helper);
  },
  handleEditForfaitCancel: function(cmp, evt, helper) {
    helper.destroyCmp(cmp, evt, helper);
  },
  handleDecisionClick: function(cmp, evt, helper) {
    cmp.set('v.currentDecision', !cmp.get('v.currentDecision'));
  },
  handleEditForfaitSave: function(cmp, evt, helper) {
    $A.util.removeClass(cmp.find('loadSpinner'), 'slds-hide');
    let currentStep = cmp.get('v.step');
    if (currentStep === '1') {
      let mapValuesForfaitEdit = helper.getFormForfaitEditValues(cmp, evt, helper);
      let checkForfaitEditForm = helper.checkForfaitEditForm(cmp, evt, helper, mapValuesForfaitEdit);
      if (checkForfaitEditForm) {
        cmp.set('v.showErrMessage', false);
        cmp.set('v.mapFormValues', mapValuesForfaitEdit);
        helper.handleForfaitEditSave(cmp, evt, helper, mapValuesForfaitEdit);
      } else {
        $A.util.addClass(cmp.find('loadSpinner'), 'slds-hide');
        cmp.set('v.showErrMessage', true);
      }
    } else {
      let mapValuesForfaitEdit = cmp.get('v.mapFormValues');
      helper.handleForfaitEditSave(cmp, evt, helper, mapValuesForfaitEdit);
    }
  }
});