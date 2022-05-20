({
  doInit: function(cmp, evt, helper) {
    helper.retrieveParticipantsInfo(cmp, evt, helper);
  },
  handleRemove: function(cmp, evt, helper) {
    helper.handleRemove(cmp, evt, helper);
  },
  handleAdd: function(cmp, evt, helper) {
    helper.handleAdd(cmp, evt, helper);
  }
});