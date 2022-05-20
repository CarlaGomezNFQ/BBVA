({
  getForfaitPackages: function(cmp, evt, helper) {
    $A.util.removeClass(cmp.find('simpleSpinner'), 'slds-hide');
    let action = cmp.get('c.getForfaitPackages');
    action.setParams({
      'recordId': cmp.get('v.recordId')
    });
    action.setCallback(this, function(response) {
      $A.util.addClass(cmp.find('simpleSpinner'), 'slds-hide');
      if (response.getState() === 'SUCCESS') {
        let retForfait = response.getReturnValue();
        cmp.set('v.canAddForfaitPkg', retForfait.pkgPermissions.add);
        if (retForfait.lstPW.length === 0) {
          cmp.set('v.showError', true);
        } else {
          let cancelledForfaitPkg = [];
          let otherForfaitPkg = [];
          retForfait.lstPW.forEach((forfaitPkg) => {
            if (forfaitPkg.status !== undefined && forfaitPkg.status.id === 'Cancelled') {
              cmp.set('v.showExtPkgCancelBanner', true);
              cancelledForfaitPkg.push(forfaitPkg);
            } else {
              otherForfaitPkg.push(forfaitPkg);
            }
          });
          let pkgForfaitArr = [];
          pkgForfaitArr = cancelledForfaitPkg.concat(otherForfaitPkg); // Show first cancelled pkg
          let arrForfaitVisible = pkgForfaitArr.filter(pkg => pkg.isVisible);
          cmp.set('v.lstForfaitPkg', arrForfaitVisible);
          cmp.set('v.pkgPermissions', retForfait.pkgPermissions);
          cmp.set('v.showError', arrForfaitVisible.length === 0 ? true : false);
        }
      } else if (response.getState() === 'ERROR') {
        helper.showNewToastForfaitPkg('error', response.getError()[0].message);
      }
    });
    $A.enqueueAction(action);
  },
  showForfaitPkgDetail: function(cmp, evt, helper) {
    let pkgCmp = cmp.find('forfaitPkgDetail');
    let forfaitChevron = cmp.find('forfaitChevron');
    $A.util.toggleClass(pkgCmp, 'slds-hide');
    $A.util.toggleClass(forfaitChevron, 'rotate');
  },
  checkForfaitAddPermissions: function(cmp, helper, params) {
    return new Promise($A.getCallback(function(resolve, reject) {
      let action = cmp.get('c.checkForfaitAddPermissions');
      action.setParams(params);
      action.setCallback(this, function(response) {
        if (response.getState() === 'SUCCESS') {
          let ret = response.getReturnValue();
          resolve(ret);
        } else if (response.getState() === 'ERROR') {
          helper.showNewToastCommPkgDetail('error', response.getError()[0].message);
          reject(response.getState());
        }
      });
      $A.enqueueAction(action);
    }));
  },
  showForfaitPkgNextCmp: function(cmp, helper, nextCmpName, recordId) {
    helper.createForfaitNextCmp(cmp, helper, nextCmpName, recordId).then($A.getCallback(newCmp => {
      $A.util.addClass(cmp.find('mySpinner'), 'slds-hide');
      let body = [];
      body.push(newCmp);
      cmp.set('v.body', body);
    }));
  },
  createForfaitNextCmp: function(cmp, helper, cmpName, recordId) {
    return new Promise($A.getCallback(function(resolve, reject) {
      $A.createComponent(
        'cuco:' + cmpName,
        {
          'profAnalysisId': recordId
        },
        function(newCmp, status, errorMessage) {
          if (status === 'SUCCESS') {
            resolve(newCmp);
          } else if (status === 'INCOMPLETE' || status === 'ERROR') {
            $A.util.addClass(cmp.find('mySpinner'), 'slds-hide');
            helper.showNewToastForfaitPkg('error', errorMessage);
          }
        }
      );
    }));
  },
  showNewToastForfaitPkg: function(type, message) {
    let titleForfaitPkgToast;
    switch (type) {
      case 'success':
        titleForfaitPkgToast = $A.get('$Label.cuco.toast_title_success');
        break;
      case 'warning':
        titleForfaitPkgToast = $A.get('$Label.cuco.toast_title_warning');
        break;
      case 'error':
        titleForfaitPkgToast = $A.get('$Label.cuco.toast_title_error');
        break;
    }
    var newForfaitPkgToast = $A.get('e.force:showToast');
    newForfaitPkgToast.setParams({
      'title': titleForfaitPkgToast,
      'type': type,
      'message': message
    });
    newForfaitPkgToast.fire();
  }
});