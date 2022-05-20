/* eslint-disable no-unused-expressions */
({
  doInit: function(cmp, event, helper) {
    helper.doInit(cmp, event, helper);
  },

  waiting: function(cmp) {
    cmp.set('v.waiting', true);
  },

  doneWaiting: function(cmp) {
    cmp.set('v.waiting', false);
  },

  handleRemove: function(cmp, event, helper) {
    helper.handleRemove(cmp, event, helper);
  },

  handleCancel: function(cmp, event, helper) {
    helper.destroyCmp(cmp, event, helper);
  }
});