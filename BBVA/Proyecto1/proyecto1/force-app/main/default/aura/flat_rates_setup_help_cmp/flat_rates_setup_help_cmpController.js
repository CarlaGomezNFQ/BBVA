({
  doInit: function(cmp, evt, helper) {
    cmp.set('v.isSuccess', true);
  },
  handleFlatRatesSetupHelpCancel: function(cmp, evt, helper) {
    let compEvent = cmp.getEvent('flatRatesSetupHelpEvt');
    compEvent.fire();
    cmp.set('v.hide', true);
  }
});