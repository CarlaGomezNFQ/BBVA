({
  doInit: function(cmp, evt, helper) {
    helper.doInitForfaitCancel(cmp, evt, helper);
  },
  handleCancelForfaitCancel: function(cmp, evt, helper) {
    helper.destroyCmp(cmp, evt, helper);
  },
  handleCancelForfaitConfirm: function(cmp, evt, helper) {
    helper.handleCancelForfaitConfirm(cmp, evt, helper);
  }
});