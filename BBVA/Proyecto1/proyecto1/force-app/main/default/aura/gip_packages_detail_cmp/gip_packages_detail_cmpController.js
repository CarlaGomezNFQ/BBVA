({
  doInit: function(cmp, evt, helper) {
    let gipPkg = cmp.get('v.gipPkg');
    let sObjectName = cmp.get('v.sObjectName');

    let canEditGipPkg = false;
    let canCancelGipPkg = false;
    let canUndoCancelGipPkg = false;

    if (sObjectName === 'cuco__profitability_analysis__c') {
      let gipPkgPermissions = cmp.get('v.pkgPermissions');

      // Edit check
      if (gipPkgPermissions.edit && gipPkg.requestStatus === undefined) { // client_package without pkg req
        canEditGipPkg = true;
      } else if (gipPkgPermissions.edit && gipPkg.requestStatus.id !== 'Cancellation') {
        canEditGipPkg = true;
      }

      // Cancel check
      if (gipPkgPermissions.cancel && gipPkg.requestStatus !== undefined) {
        if (gipPkg.requestStatus.id !== 'Cancellation') {
          canCancelGipPkg = true;
        } else {
          canUndoCancelGipPkg = true;
        }
      } else if (gipPkgPermissions.cancel && gipPkg.requestStatus === undefined) { // client_package without pkg req
        canCancelGipPkg = true;
      }
    }
    cmp.set('v.canEditGipPkg', canEditGipPkg);
    cmp.set('v.canCancelGipPkg', canCancelGipPkg);
    cmp.set('v.canUndoCancelGipPkg', canUndoCancelGipPkg);
  },
  handleGipClickCollapsibleIcon: function(cmp, evt, helper) {
    helper.changeGipCollapsibleIcon(cmp, evt, helper);
  },
  handleGipEditClick: function(cmp, evt, helper) {
    let gipPkg = cmp.get('v.gipPkg');
    let profAnalysisId = cmp.get('v.recordId');

    if (gipPkg.newRequestId === undefined) {
      let paramsInit = {
        profAnalysisId: profAnalysisId,
        strPkgWrapper: JSON.stringify(gipPkg)
      };
      helper.checkGipDetailEditPermissions(cmp, helper, paramsInit).then(response => {
        if (response.edit) {
          helper.showGipDetailPkgNextCmp(cmp, helper, 'gip_package_edit_cmp', gipPkg, profAnalysisId);
        } else {
          helper.showNewToastgipPkgDetail('warning', response.editMessage);
        }
      });
    } else {
      let paramsInit = {
        profAnalysisId: profAnalysisId
      };
      helper.checkGipDetailAddPermissions(cmp, helper, paramsInit).then(response => {
        if (response.add) {
          helper.showGipDetailPkgNextCmp(cmp, helper, 'gip_package_add_cmp', gipPkg, profAnalysisId);
        } else {
          helper.showNewToastgipPkgDetail('warning', response.addMessage);
        }
      });
    }
  },
  handleGipCancelClick: function(cmp, evt, helper) {
    let gipPkg = cmp.get('v.gipPkg');
    let profAnalysisId = cmp.get('v.recordId');
    let paramsInit = {
      profAnalysisId: profAnalysisId,
      strPkgWrapper: JSON.stringify(gipPkg)
    };
    helper.checkGipDetailCancelPermissions(cmp, helper, paramsInit).then(response => {
      if (response.cancel) {
        helper.showGipDetailPkgNextCmp(cmp, helper, 'gip_package_cancel_cmp', gipPkg, profAnalysisId);
      } else {
        helper.showNewToastgipPkgDetail('warning', response.cancelMessage);
      }
    });
  }
});