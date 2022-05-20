({
  doInit: function(cmp, evt, helper) {
    helper.doPreviousChecks(cmp, evt, helper);
  },
  handleRadioButtonChange: function(cmp, evt, helper) {
    helper.handleRadioButtonChange(cmp, evt, helper);
  },
  handleContinue: function(cmp, evt, helper) {
    helper.handleContinue(cmp, evt, helper);
  },
  handleDelete: function(cmp, evt, helper) {
    helper.handleDelete(cmp, evt, helper);
  },
  handleCancel: function(cmp, evt, helper) {
    helper.destroyCmp(cmp, evt, helper);
  }
});