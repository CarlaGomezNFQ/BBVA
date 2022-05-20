({
  doInit: function(cmp, evt, helper) {
    helper.getForfaitPackages(cmp, evt, helper);
  },
  handleForfaitPkgEvt: function(cmp, evt, helper) {
    let profAnalysisId = cmp.get('v.recordId');
    let contextId = evt.getParam('contextId');
    if (profAnalysisId === contextId) {
      helper.getForfaitPackages(cmp, evt, helper);
    }
  },
  handleAddForfaitPkg: function(cmp, evt, helper) {
    $A.util.removeClass(cmp.find('simpleSpinner'), 'slds-hide');
    let profAnalysisId = cmp.get('v.recordId');
    let paramsInit = {
      profAnalysisId: profAnalysisId
    };
    helper.checkForfaitAddPermissions(cmp, helper, paramsInit).then(response => {
      $A.util.addClass(cmp.find('simpleSpinner'), 'slds-hide');
      if (response.add) {
        helper.showForfaitPkgNextCmp(cmp, helper, 'forfait_package_add_cmp', profAnalysisId);
      } else {
        helper.showNewToastForfaitPkg('warning', response.addMessage);
      }
    });
  }
});