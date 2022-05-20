({
  doInit: function(cmp, evt, helper) {
    helper.getFlatRatesSetupInfo(cmp, evt, helper);
  },
  handleFlatRatesSetupCancel: function(cmp, evt, helper) {
    helper.destroyCmp(cmp, evt, helper);
  },
  handlePriceTypeChange: function(cmp, evt) {
    let currentPriceTypeValue = evt.getParam('value');
    cmp.set('v.currentPriceType', currentPriceTypeValue);
  },
  handleFlatRatesHelpButton: function(cmp, evt, helper) {
    cmp.set('v.showHelpCmp', !cmp.get('v.showHelpCmp'));
  },
  handleModalCallback: function(cmp, evt, helper) {
    cmp.set('v.showHelpCmp', !cmp.get('v.showHelpCmp'));
  },
  handleAddPyGAcc: function(cmp, evt, helper) {
    let currentPaFlatRatesAcc = cmp.get('v.paFlatRateAccs');
    currentPaFlatRatesAcc.push({});
    cmp.set('v.paFlatRateAccs', currentPaFlatRatesAcc);
  },
  handleDeletePyG: function(cmp, evt, helper) {
    let currentPaFlatRatesAcc = cmp.get('v.paFlatRateAccs');
    let positionToRemove = evt.getSource().get('v.name');
    currentPaFlatRatesAcc.splice(positionToRemove, 1);
    cmp.set('v.paFlatRateAccs', currentPaFlatRatesAcc);
  },
  handleFlatRatesSetupSave: function(cmp, evt, helper) {
    $A.util.removeClass(cmp.find('simpleSpinner'), 'slds-hide');
    let formHasValidateErrors = helper.doFormValidations(cmp, evt, helper);
    if (!formHasValidateErrors) {
      helper.handleSetupFlatClick(cmp, evt, helper);
    } else {
      $A.util.addClass(cmp.find('simpleSpinner'), 'slds-hide');
    }
  }
});