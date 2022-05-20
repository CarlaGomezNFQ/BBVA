({
  doInit: function(cmp, evt, helper) {
    helper.getCommPackages(cmp, evt, helper);
  },
  handleCommPkgEvt: function(cmp, evt, helper) {
    let profAnalysisId = cmp.get('v.recordId');
    let contextId = evt.getParam('contextId');
    if (profAnalysisId === contextId) {
      helper.getCommPackages(cmp, evt, helper);
    }
  }
});