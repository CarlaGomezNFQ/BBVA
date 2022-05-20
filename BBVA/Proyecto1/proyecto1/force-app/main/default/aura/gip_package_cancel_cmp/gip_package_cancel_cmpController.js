({
  doInit: function(cmp, evt, helper) {
    helper.doInitGipCancel(cmp, evt, helper);
  },
  handleCancelGipCancel: function(cmp, evt, helper) {
    helper.destroyCmp(cmp, evt, helper);
  },
  handleCancelGipConfirm: function(cmp, evt, helper) {
    helper.handleCancelGipConfirm(cmp, evt, helper);
  }
});