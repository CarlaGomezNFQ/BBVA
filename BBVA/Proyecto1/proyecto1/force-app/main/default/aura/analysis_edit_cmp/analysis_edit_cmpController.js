({
  doInit: function(cmp, evt, helper) {
    helper.doInit(cmp, evt, helper);
  },
  hideToolTip: function(cmp, evt, helper) {
    cmp.set('v.tooltip', false);
  },
  showToolTip: function(cmp, evt, helper) {
    cmp.set('v.tooltip', true);
  },
  handleCheckboxChange: function(cmp, evt, helper) {
    cmp.set('v.hasContractException', cmp.find('checkboxId').get('v.checked'));
  },
  handleCancel: function(cmp, evt, helper) {
    helper.destroyCmp(cmp, evt, helper);
  },
  handleSave: function(cmp, evt, helper) {
    helper.handleSave(cmp, evt, helper);
  }
});