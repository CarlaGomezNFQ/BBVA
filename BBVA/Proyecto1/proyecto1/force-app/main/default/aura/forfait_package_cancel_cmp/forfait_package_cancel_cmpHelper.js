({
  doInitForfaitCancel: function(cmp, evt, helper) {
    $A.util.removeClass(cmp.find('loadSpinner'), 'slds-hide');
    let forfaitPkg = cmp.get('v.forfaitPkg');
    helper.setModalTitle(cmp, forfaitPkg);

    // First check: Check is pkg is extended. If not, make second check on apex
    if (forfaitPkg.isExtended) {
      helper.showNewToastForfaitPkgCancel('warning', $A.get('$Label.cuco.pkg_remove_with_extension_error'));
      helper.destroyCmp(cmp, evt, helper);
    } else {
      let action = cmp.get('c.doForfaitCancelChecks');
      action.setParams({
        'profAnalysisId': cmp.get('v.profAnalysisId'),
        'catalogId': forfaitPkg.catalogId
      });
      action.setCallback(this, function(response) {
        $A.util.addClass(cmp.find('loadSpinner'), 'slds-hide');
        if (response.getState() === 'SUCCESS') {
          let ret = response.getReturnValue();
          if (ret.hasNotParticipant && forfaitPkg.cancellationRequestId !== undefined) {
            helper.showNewToastForfaitPkgCancel('warning', $A.get('$Label.cuco.pkg_remove_without_participant_error'));
            helper.destroyCmp(cmp, evt, helper);
          } else {
            helper.setModalMessageContent(cmp, forfaitPkg);
          }
        } else if (response.getState() === 'ERROR') {
          helper.showNewToastForfaitPkgCancel('error', response.getError()[0].message);
        }
      });
      $A.enqueueAction(action);
    }
  },
  setModalTitle: function(cmp, forfaitPkg) {
    if (forfaitPkg.newRequestId) {
      cmp.set('v.title', $A.get('$Label.cuco.forfait_pkg_remove_new_rqt_title'));
    } else if (forfaitPkg.cancellationRequestId) {
      cmp.set('v.title', $A.get('$Label.cuco.forfait_pkg_remove_cancel_rqt_title'));
    } else {
      cmp.set('v.title', $A.get('$Label.cuco.forfait_pkg_cancel_title'));
    }
  },
  setModalMessageContent: function(cmp, forfaitPkg) {
    let preMessage;
    let postMessage;
    if (forfaitPkg.newRequestId) {
      preMessage = $A.get('$Label.cuco.forfait_pkg_new_rqt_conf_pre');
      postMessage = $A.get('$Label.cuco.forfait_pkg_new_rqt_conf_post');
    } else if (forfaitPkg.cancellationRequestId) {
      preMessage = $A.get('$Label.cuco.forfait_pkg_cancel_rqt_conf_pre');
      postMessage = $A.get('$Label.cuco.forfait_pkg_cancel_rqt_conf_post');
    } else {
      preMessage = $A.get('$Label.cuco.forfait_pkg_cancel_conf_pre');
      postMessage = $A.get('$Label.cuco.forfait_pkg_cancel_conf_post');
    }
    let confirmationMessage = preMessage + ' ' + forfaitPkg.code + ' [' + forfaitPkg.description + '] ' + postMessage;
    cmp.set('v.confirmationMessage', confirmationMessage);
    cmp.set('v.isSuccess', true);
  },
  handleCancelForfaitConfirm: function(cmp, evt, helper) {
    $A.util.removeClass(cmp.find('loadSpinner'), 'slds-hide');
    let forfaitPkg = cmp.get('v.forfaitPkg');
    let action = cmp.get('c.doRemoveForfaitCancelActions');
    action.setParams({
      'profAnalysisId': cmp.get('v.profAnalysisId'),
      'strPkgWrapper': JSON.stringify(forfaitPkg)
    });
    action.setCallback(this, function(response) {
      $A.util.addClass(cmp.find('loadSpinner'), 'slds-hide');
      if (response.getState() === 'SUCCESS') {
        let ret = response.getReturnValue();
        if (ret.isSuccess) {
          let compEventRefreshForfaitCancelPkg = $A.get('e.cuco:refresh_forfait_packages_evt');
          compEventRefreshForfaitCancelPkg.setParams({'contextId': cmp.get('v.profAnalysisId')});
          compEventRefreshForfaitCancelPkg.fire();
          helper.destroyCmp(cmp, evt, helper);
        } else {
          helper.showNewToastForfaitPkgCancel(ret.toastType, ret.errMessage);
        }
      } else if (response.getState() === 'ERROR') {
        helper.showNewToastForfaitPkgCancel('error', response.getError()[0].message);
      }
    });
    $A.enqueueAction(action);
  },
  showNewToastForfaitPkgCancel: function(type, message) {
    let titleForfaitPkgCancelToast;
    switch (type) {
      case 'success':
        titleForfaitPkgCancelToast = $A.get('$Label.cuco.toast_title_success');
        break;
      case 'warning':
        titleForfaitPkgCancelToast = $A.get('$Label.cuco.toast_title_warning');
        break;
      case 'error':
        titleForfaitPkgCancelToast = $A.get('$Label.cuco.toast_title_error');
        break;
    }
    var newForfaitPkgCancelToast = $A.get('e.force:showToast');
    newForfaitPkgCancelToast.setParams({
      'title': titleForfaitPkgCancelToast,
      'type': type,
      'message': message
    });
    newForfaitPkgCancelToast.fire();
  }
});