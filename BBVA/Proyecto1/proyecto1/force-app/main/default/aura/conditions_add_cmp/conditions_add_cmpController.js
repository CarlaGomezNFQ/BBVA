/* eslint-disable no-unused-expressions */
({
  doInit: function(cmp, event, helper) {
    helper.doInit(cmp, event, helper);
  },

  refreshView: function(cmp, event, helper) {
    $A.get('e.force:refreshView').fire();
  },

  handleContinue: function(cmp, event, helper) {
    helper.handleContinue(cmp, event, helper);
  },

  handleEventSave: function(cmp, event, helper) {
    helper.handleEventSave(cmp, event, helper);
  },

  handleCancel: function(cmp, event, helper) {
    helper.refreshConditions(cmp, event, helper);
    helper.destroyCmp(cmp, event, helper);
  },

  dismissWarning: function(cmp, event, helper) {
    cmp.set('v.showWarning', false);
  }
});