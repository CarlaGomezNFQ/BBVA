({
  doInitialChecks: function(cmp, evt, helper) {
    $A.util.removeClass(cmp.find('loadSpinner'), 'slds-hide');
    let commPkg = cmp.get('v.commPkg');
    let isExtPkg = commPkg.isExtended;
    cmp.set('v.originalDecision', isExtPkg);
    cmp.set('v.currentDecision', isExtPkg);
    if (isExtPkg) {
      $A.util.addClass(cmp.find('loadSpinner'), 'slds-hide');
      cmp.set('v.isSuccess', true);
    } else {
      let action = cmp.get('c.doPreviousEditChecks');
      action.setParams({
        'profAnalysisId': cmp.get('v.profAnalysisId'),
        'strPkgWrapper': JSON.stringify(cmp.get('v.commPkg'))
      });
      action.setCallback(this, function(response) {
        $A.util.addClass(cmp.find('loadSpinner'), 'slds-hide');
        if (response.getState() === 'SUCCESS') {
          let ret = response.getReturnValue();
          if (ret.isSuccess) {
            cmp.set('v.isSuccess', true);
          } else {
            $A.util.addClass(cmp.find('loadSpinner'), 'slds-hide');
            helper.showNewToastCommPkgEdit('warning', ret.errMessage);
            helper.destroyCmp(cmp, evt, helper);
          }
        } else if (response.getState() === 'ERROR') {
          helper.showNewToastCommPkgEdit('error', response.getError()[0].message);
        }
      });
      $A.enqueueAction(action);
    }
  },
  handleDecisionClick: function(cmp, evt, helper) {
    let currentDecision = cmp.get('v.currentDecision');
    if (currentDecision) {
      cmp.set('v.currentDecision', false);
    } else {
      cmp.set('v.currentDecision', true);
    }
  },
  handleSave: function(cmp, evt, helper) {
    $A.util.removeClass(cmp.find('loadSpinner'), 'slds-hide');
    let action = cmp.get('c.doEditCommPkgActions');
    let params = {
      'profAnalysisId': cmp.get('v.profAnalysisId'),
      'step': cmp.get('v.step'),
      'decision': cmp.get('v.currentDecision') ? 'extend' : 'deextend'
    };
    action.setParams({
      'strPkgWrapper': JSON.stringify(cmp.get('v.commPkg')),
      'params': params
    });
    action.setCallback(this, function(response) {
      $A.util.addClass(cmp.find('loadSpinner'), 'slds-hide');
      if (response.getState() === 'SUCCESS') {
        let ret = response.getReturnValue();
        if (ret.isSuccess) {

          // Refresh comm package
          let compEventRefreshCommPkg = $A.get('e.cuco:refresh_comm_packages_evt');
          compEventRefreshCommPkg.setParams({'contextId': cmp.get('v.profAnalysisId')});
          compEventRefreshCommPkg.fire();

          // Refresh participants evt
          let appEventCommRefreshConditions = $A.get('e.cuco:refresh_conditions_evt');
          appEventCommRefreshConditions.setParams({
            'contextId': cmp.get('v.profAnalysisId')
          });
          appEventCommRefreshConditions.fire();

          // Refresh flat evt
          let appEventCommRefreshFlat = $A.get('e.cuco:refresh_flat_rates_evt');
          appEventCommRefreshFlat.setParams({
            'contextId': cmp.get('v.profAnalysisId')
          });
          appEventCommRefreshFlat.fire();

          helper.destroyCmp(cmp, evt, helper);
        } else if (ret.errMessage === undefined) {
          cmp.set('v.lstPAC', ret.lstPAC);
          cmp.set('v.step', '2');
        } else {
          helper.showNewToastCommPkgEdit(ret.toastType, ret.errMessage);
        }
      } else if (response.getState() === 'ERROR') {
        helper.showNewToastCommPkgEdit('error', response.getError()[0].message);
      }
    });
    $A.enqueueAction(action);
  },
  showNewToastCommPkgEdit: function(type, message) {
    let titleCommPkgEditToast;
    switch (type) {
      case 'success':
        titleCommPkgEditToast = $A.get('$Label.cuco.toast_title_success');
        break;
      case 'warning':
        titleCommPkgEditToast = $A.get('$Label.cuco.toast_title_warning');
        break;
      case 'error':
        titleCommPkgEditToast = $A.get('$Label.cuco.toast_title_error');
        break;
    }
    var newCommPkgEditToast = $A.get('e.force:showToast');
    newCommPkgEditToast.setParams({
      'title': titleCommPkgEditToast,
      'type': type,
      'message': message
    });
    newCommPkgEditToast.fire();
  }
});