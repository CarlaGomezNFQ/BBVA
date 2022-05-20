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

  refreshView: function(cmp, event, helper) {
    $A.get('e.force:refreshView').fire();
  },

  handleContinue: function(cmp, event, helper) {
    helper.handleContinue(cmp, event, helper);
  },

  handleCancel: function(cmp, event, helper) {
    helper.destroyCmp(cmp, event, helper);
  },

  toggleGroup: function(cmp, event, helper) {
    helper.toggleGroup(cmp, event, helper);
  },

  evaluateToggleGroup: function(cmp, event, helper) {
    helper.evaluateToggleGroup(cmp, event, helper);
  },

  dismissWarning: function(cmp, event, helper) {
    cmp.set('v.showWarning', false);
  },

  dismissNotChecked: function(cmp, event, helper) {
    cmp.set('v.showNotChecked', false);
  }

});