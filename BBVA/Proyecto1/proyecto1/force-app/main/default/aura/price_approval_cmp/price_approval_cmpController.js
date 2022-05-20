({
  doInit: function(cmp, evt, helper) {
    helper.requestData(cmp, evt, helper);
  },
  handleClick: function(cmp, evt, helper) {
    helper.handleClick(cmp, evt, helper);
  },
  cancelButton: function(cmp, evt, helper) {
    helper.cancelButton(cmp, evt, helper);
  },
  validateFields: function(cmp, evt, helper) {
    helper.validateFields(cmp, evt, helper);
  },
  handleSectionToggle: function(cmp, evt, helper) {
    helper.sectionToggle(cmp, evt, helper);
  },
  handleChangeDate: function(cmp, evt, helper) {
    helper.handleChangeDate(cmp, evt, helper);
  }
});