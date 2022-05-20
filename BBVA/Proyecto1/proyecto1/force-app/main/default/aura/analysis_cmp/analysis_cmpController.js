({
  doInit: function(cmp, evt, helper) {
    helper.doInit(cmp, evt, helper);
  },
  hideToolTip: function(cmp, evt, helper) {
    cmp.set('v.showTooltip', false);
  },
  showToolTip: function(cmp, evt, helper) {
    cmp.set('v.showTooltip', true);
  },
  handleRefreshAnalysis: function(cmp, evt, helper) {
    helper.handleRefreshAnalysis(cmp, evt, helper);
  },
  handleEditClick: function(cmp, evt, helper) {
    $A.util.removeClass(cmp.find('loadSpinner'), 'slds-hide');
    let profAnalysis = cmp.get('v.profAnalysis');
    let paramsInit = {
      profAnalysisId: profAnalysis.Id
    };
    helper.checkPAManagePermissions(cmp, helper, paramsInit).then(response => {
      if (response.manage) {
        helper.createAnalysisEditCmp(cmp, helper, 'analysis_edit_cmp', profAnalysis);
      } else {
        helper.showNewToastAnalysis('warning', response.manageMessage);
      }
    });
  }
});