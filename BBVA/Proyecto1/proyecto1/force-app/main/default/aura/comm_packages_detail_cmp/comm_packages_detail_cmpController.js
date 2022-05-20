({
  doInit: function(cmp, evt, helper) {
    let commPkg = cmp.get('v.commPkg');
    let sObjectName = cmp.get('v.sObjectName');

    if (sObjectName === 'cuco__profitability_analysis__c' && commPkg.status !== undefined
      && (commPkg.status.id === 'Valid' || (commPkg.status.id === 'Cancelled' && commPkg.isExtended))) {
      let commPkgPermissions = cmp.get('v.pkgPermissions');
      if (commPkgPermissions.edit) {
        cmp.set('v.canEditCommPkg', true);
      } else {
        cmp.set('v.canEditCommPkg', false);
      }
    } else {
      cmp.set('v.canEditCommPkg', false);
    }
  },
  handleCommClickCollapsibleIcon: function(cmp, evt, helper) {
    helper.changeCommCollapsibleIcon(cmp, evt, helper);
  },
  handleEditClick: function(cmp, evt, helper) {
    let commPkg = cmp.get('v.commPkg');
    let profAnalysisId = cmp.get('v.recordId');
    let paramsInit = {
      profAnalysisId: profAnalysisId,
      strPkgWrapper: JSON.stringify(commPkg)
    };
    helper.checkCommEditPermissions(cmp, helper, paramsInit).then(response => {
      if (response.edit) {
        helper.showCommPkgEditCmp(cmp, helper, 'comm_package_edit_cmp', commPkg, profAnalysisId);
      } else {
        helper.showNewToastCommPkgDetail('warning', response.editMessage);
      }
    });
  }
});