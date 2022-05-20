({
  doInit: function(cmp, evt, helper) {
    helper.getGipPackages(cmp, evt, helper);
  },
  handleGipPkgEvt: function(cmp, evt, helper) {
    let profAnalysisId = cmp.get('v.recordId');
    let contextId = evt.getParam('contextId');
    if (profAnalysisId === contextId) {
      helper.getGipPackages(cmp, evt, helper);
    }
  },
  handleAddGipPkg: function(cmp, evt, helper) {
    $A.util.removeClass(cmp.find('simpleSpinner'), 'slds-hide');
    let profAnalysisId = cmp.get('v.recordId');
    let paramsInit = {
      profAnalysisId: profAnalysisId
    };
    helper.checkGipAddPermissions(cmp, helper, paramsInit).then(response => {
      $A.util.addClass(cmp.find('simpleSpinner'), 'slds-hide');
      if (response.add) {
        helper.showGipPkgNextCmp(cmp, helper, 'gip_package_add_cmp', profAnalysisId);
      } else {
        helper.showNewToastGipPkg('warning', response.addMessage);
      }
    });
  }
});