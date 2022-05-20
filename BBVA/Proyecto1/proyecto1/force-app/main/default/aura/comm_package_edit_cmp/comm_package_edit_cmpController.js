({
  doInit: function(cmp, evt, helper) {
    helper.doInitialChecks(cmp, evt, helper);
  },
  handleCancel: function(cmp, evt, helper) {
    helper.destroyCmp(cmp, evt, helper);
  },
  handleSave: function(cmp, evt, helper) {
    let originalDecision = cmp.get('v.originalDecision');
    let currentDecision = cmp.get('v.currentDecision');
    if (originalDecision === currentDecision) {
      helper.destroyCmp(cmp, evt, helper);
    } else {
      helper.handleSave(cmp, evt, helper);
    }
  },
  handleDecisionClick: function(cmp, evt, helper) {
    helper.handleDecisionClick(cmp, evt, helper);
  }
});