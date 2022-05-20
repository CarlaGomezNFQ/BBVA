({
  getCommPackages: function(cmp, evt, helper) {
    $A.util.removeClass(cmp.find('simpleSpinner'), 'slds-hide');
    let action = cmp.get('c.getCommPackages');
    action.setParams({
      'recordId': cmp.get('v.recordId')
    });
    action.setCallback(this, function(response) {
      $A.util.addClass(cmp.find('simpleSpinner'), 'slds-hide');
      if (response.getState() === 'SUCCESS') {
        let retComm = response.getReturnValue();
        if (retComm.lstPW.length === 0) {
          cmp.set('v.showError', true);
        } else {
          cmp.set('v.showExtPkgCancelBanner', false);
          let cancelledCommPkg = [];
          let otherCommPkg = [];
          retComm.lstPW.forEach((commPkg) => {
            if (commPkg.status !== undefined && commPkg.status.id === 'Cancelled' && commPkg.isVisible) {
              cmp.set('v.showExtPkgCancelBanner', true);
              cancelledCommPkg.push(commPkg);
            } else {
              otherCommPkg.push(commPkg);
            }
          });
          let pkgCommArr = [];
          pkgCommArr = cancelledCommPkg.concat(otherCommPkg); // Show first cancelled pkg
          let arrCommVisible = pkgCommArr.filter(pkg => pkg.isVisible);
          cmp.set('v.lstCommPkg', arrCommVisible);
          cmp.set('v.pkgPermissions', retComm.pkgPermissions);
          cmp.set('v.showError', arrCommVisible.length === 0 ? true : false);
        }
      } else if (response.getState() === 'ERROR') {
        helper.showNewToastCommPkg('error', response.getError()[0].message);
      }
    });
    $A.enqueueAction(action);
  },
  showNewToastCommPkg: function(type, message) {
    let titleCommPkgToast;
    switch (type) {
      case 'success':
        titleCommPkgToast = $A.get('$Label.cuco.toast_title_success');
        break;
      case 'warning':
        titleCommPkgToast = $A.get('$Label.cuco.toast_title_warning');
        break;
      case 'error':
        titleCommPkgToast = $A.get('$Label.cuco.toast_title_error');
        break;
    }
    var newCommPkgToast = $A.get('e.force:showToast');
    newCommPkgToast.setParams({
      'title': titleCommPkgToast,
      'type': type,
      'message': message
    });
    newCommPkgToast.fire();
  }
});