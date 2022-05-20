({
  doInitGipCancel: function(cmp, evt, helper) {
    $A.util.removeClass(cmp.find('loadSpinner'), 'slds-hide');
    let gipPkg = cmp.get('v.gipPkg');
    helper.setModalTitle(cmp, gipPkg);

    // First check: Check is pkg is extended. If not, make second check on apex
    if (gipPkg.isExtended) {
      helper.showNewToastGipPkgCancel('warning', $A.get('$Label.cuco.pkg_remove_with_extension_error'));
      helper.destroyCmp(cmp, evt, helper);
    } else {
      let action = cmp.get('c.doGipCancelChecks');
      action.setParams({
        'profAnalysisId': cmp.get('v.profAnalysisId'),
        'catalogId': gipPkg.catalogId
      });
      action.setCallback(this, function(response) {
        $A.util.addClass(cmp.find('loadSpinner'), 'slds-hide');
        if (response.getState() === 'SUCCESS') {
          let ret = response.getReturnValue();
          if (ret.hasNotParticipant && gipPkg.cancellationRequestId !== undefined) {
            helper.showNewToastGipPkgCancel('warning', $A.get('$Label.cuco.pkg_remove_without_participant_error'));
            helper.destroyCmp(cmp, evt, helper);
          } else {
            helper.setModalMessageContent(cmp, gipPkg);
          }
        } else if (response.getState() === 'ERROR') {
          helper.showNewToastGipPkgCancel('error', response.getError()[0].message);
        }
      });
      $A.enqueueAction(action);
    }
  },
  setModalTitle: function(cmp, gipPkg) {
    if (gipPkg.newRequestId) {
      cmp.set('v.title', $A.get('$Label.cuco.gip_pkg_remove_new_rqt_title'));
    } else if (gipPkg.cancellationRequestId) {
      cmp.set('v.title', $A.get('$Label.cuco.gip_pkg_remove_cancel_rqt_title'));
    } else {
      cmp.set('v.title', $A.get('$Label.cuco.gip_pkg_cancel_title'));
    }
  },
  setModalMessageContent: function(cmp, gipPkg) {
    let preMessage;
    let postMessage;
    if (gipPkg.newRequestId) {
      preMessage = $A.get('$Label.cuco.gip_pkg_new_rqt_conf_pre');
      postMessage = $A.get('$Label.cuco.gip_pkg_new_rqt_conf_post');
    } else if (gipPkg.cancellationRequestId) {
      preMessage = $A.get('$Label.cuco.gip_pkg_cancel_rqt_conf_pre');
      postMessage = $A.get('$Label.cuco.gip_pkg_cancel_rqt_conf_post');
    } else {
      preMessage = $A.get('$Label.cuco.gip_pkg_cancel_conf_pre');
      postMessage = $A.get('$Label.cuco.gip_pkg_cancel_conf_post');
    }
    let confirmationGipMessage = preMessage + ' ' + gipPkg.description + ' ' + postMessage;
    cmp.set('v.confirmationGipMessage', confirmationGipMessage);
    cmp.set('v.isSuccess', true);
  },
  handleCancelGipConfirm: function(cmp, evt, helper) {
    $A.util.removeClass(cmp.find('loadSpinner'), 'slds-hide');
    let gipPkg = cmp.get('v.gipPkg');
    let action = cmp.get('c.doRemoveGipCancelActions');
    action.setParams({
      'profAnalysisId': cmp.get('v.profAnalysisId'),
      'strPkgWrapper': JSON.stringify(gipPkg)
    });
    action.setCallback(this, function(response) {
      $A.util.addClass(cmp.find('loadSpinner'), 'slds-hide');
      if (response.getState() === 'SUCCESS') {
        let ret = response.getReturnValue();
        if (ret.isSuccess) {
          let compEventRefreshGipCancelPkg = $A.get('e.cuco:refresh_gip_packages_evt');
          compEventRefreshGipCancelPkg.setParams({'contextId': cmp.get('v.profAnalysisId')});
          compEventRefreshGipCancelPkg.fire();
          helper.destroyCmp(cmp, evt, helper);
        } else {
          helper.showNewToastGipPkgCancel(ret.toastType, ret.errMessage);
        }
      } else if (response.getState() === 'ERROR') {
        helper.showNewToastGipPkgCancel('error', response.getError()[0].message);
      }
    });
    $A.enqueueAction(action);
  },
  showNewToastGipPkgCancel: function(type, message) {
    let titleGipPkgCancelToast;
    switch (type) {
      case 'success':
        titleGipPkgCancelToast = $A.get('$Label.cuco.toast_title_success');
        break;
      case 'warning':
        titleGipPkgCancelToast = $A.get('$Label.cuco.toast_title_warning');
        break;
      case 'error':
        titleGipPkgCancelToast = $A.get('$Label.cuco.toast_title_error');
        break;
    }
    var newGipPkgCancelToast = $A.get('e.force:showToast');
    newGipPkgCancelToast.setParams({
      'title': titleGipPkgCancelToast,
      'type': type,
      'message': message
    });
    newGipPkgCancelToast.fire();
  }
});