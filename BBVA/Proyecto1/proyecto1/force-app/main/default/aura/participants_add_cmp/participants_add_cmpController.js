({
  doInit: function(cmp, evt, helper) {
    helper.retrieveTableData(cmp, evt, helper);
  },
  handleCancel: function(cmp, evt, helper) {
    helper.destroyCmp(cmp, evt, helper);
  },
  handleAdd: function(cmp, evt, helper) {
    helper.handleAdd(cmp, evt, helper);
  },
  handleSearchChange: function(cmp, evt, helper) {
    helper.doNameFilter(cmp, evt, helper);
  },
  handleInputCrossClick: function(cmp, evt, helper) {
    helper.cleanSearchInput(cmp, evt, helper);
  },
  handleOnRowSelection: function(cmp, evt, helper) {
    helper.updateSelectedRows(cmp, evt, helper);
  }
});