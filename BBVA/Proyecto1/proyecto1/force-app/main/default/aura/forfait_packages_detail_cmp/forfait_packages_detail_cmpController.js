({
  doInit: function(cmp, evt, helper) {
    let forfaitPkg = cmp.get('v.forfaitPkg');
    let sObjectName = cmp.get('v.sObjectName');

    let canEditForfaitPkg = false;
    let canCancelForfaitPkg = false;
    let canUndoCancelForfaitPkg = false;

    if (sObjectName === 'cuco__profitability_analysis__c') {
      let commPkgPermissions = cmp.get('v.pkgPermissions');

      // Edit check
      if (commPkgPermissions.edit && forfaitPkg.requestStatus === undefined) { // client_package without pkg req
        canEditForfaitPkg = true;
      } else if (commPkgPermissions.edit && forfaitPkg.requestStatus.id !== 'Cancellation') {
        canEditForfaitPkg = true;
      }

      // Cancel check
      if (commPkgPermissions.cancel && forfaitPkg.requestStatus !== undefined) {
        if (forfaitPkg.requestStatus.id !== 'Cancellation') {
          canCancelForfaitPkg = true;
        } else {
          canUndoCancelForfaitPkg = true;
        }
      } else if (commPkgPermissions.cancel && forfaitPkg.requestStatus === undefined) { // client_package without pkg req
        canCancelForfaitPkg = true;
      }
    }

    cmp.set('v.canEditForfaitPkg', canEditForfaitPkg);
    cmp.set('v.canCancelForfaitPkg', canCancelForfaitPkg);
    cmp.set('v.canUndoCancelForfaitPkg', canUndoCancelForfaitPkg);
  },
  handleForfaitClickCollapsibleIcon: function(cmp, evt, helper) {
    helper.changeForfaitCollapsibleIcon(cmp, evt, helper);
  },
  handleEditClick: function(cmp, evt, helper) {
    let forfaitPkg = cmp.get('v.forfaitPkg');
    let profAnalysisId = cmp.get('v.recordId');

    if (forfaitPkg.newRequestId === undefined) {
      let paramsInit = {
        profAnalysisId: profAnalysisId,
        strPkgWrapper: JSON.stringify(forfaitPkg)
      };
      helper.checkForfaitDetailEditPermissions(cmp, helper, paramsInit).then(response => {
        if (response.edit) {
          helper.showForfaitDetailPkgNextCmp(cmp, helper, 'forfait_package_edit_cmp', forfaitPkg, profAnalysisId);
        } else {
          helper.showNewToastForfaitPkgDetail('warning', response.editMessage);
        }
      });
    } else {
      let paramsInit = {
        profAnalysisId: profAnalysisId
      };
      helper.checkForfaitDetailAddPermissions(cmp, helper, paramsInit).then(response => {
        if (response.add) {
          helper.showForfaitDetailPkgNextCmp(cmp, helper, 'forfait_package_add_cmp', forfaitPkg, profAnalysisId);
        } else {
          helper.showNewToastForfaitPkgDetail('warning', response.addMessage);
        }
      });
    }
  },
  handleCancelClick: function(cmp, evt, helper) {
    let forfaitPkg = cmp.get('v.forfaitPkg');
    let profAnalysisId = cmp.get('v.recordId');
    let paramsInit = {
      profAnalysisId: profAnalysisId,
      strPkgWrapper: JSON.stringify(forfaitPkg)
    };
    helper.checkForfaitDetailCancelPermissions(cmp, helper, paramsInit).then(response => {
      if (response.cancel) {
        helper.showForfaitDetailPkgNextCmp(cmp, helper, 'forfait_package_cancel_cmp', forfaitPkg, profAnalysisId);
      } else {
        helper.showNewToastForfaitPkgDetail('warning', response.cancelMessage);
      }
    });
  }
});