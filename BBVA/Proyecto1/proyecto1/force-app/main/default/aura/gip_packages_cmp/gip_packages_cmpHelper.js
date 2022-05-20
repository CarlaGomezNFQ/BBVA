({
  getGipPackages: function(cmp, evt, helper) {
    $A.util.removeClass(cmp.find('simpleSpinner'), 'slds-hide');
    let action = cmp.get('c.getGipPackages');
    action.setParams({
      'recordId': cmp.get('v.recordId')
    });
    action.setCallback(this, function(response) {
      $A.util.addClass(cmp.find('simpleSpinner'), 'slds-hide');
      if (response.getState() === 'SUCCESS') {
        let retGip = response.getReturnValue();
        cmp.set('v.canAddGipPkg', retGip.pkgPermissions.add);
        if (retGip.lstPW.length === 0) {
          cmp.set('v.showError', true);
        } else {
          let cancelledGipPkg = [];
          let otherGipPkg = [];
          retGip.lstPW.forEach((gipPkg) => {
            if (gipPkg.status !== undefined && gipPkg.status.id === 'Cancelled') {
              cmp.set('v.showExtPkgCancelBanner', true);
              cancelledGipPkg.push(gipPkg);
            } else {
              otherGipPkg.push(gipPkg);
            }
          });
          let pkgGipArr = [];
          pkgGipArr = cancelledGipPkg.concat(otherGipPkg); // Show first cancelled pkg
          let arrGipVisible = pkgGipArr.filter(pkg => pkg.isVisible);
          cmp.set('v.pkgPermissions', retGip.pkgPermissions);
          cmp.set('v.lstGipPkg', arrGipVisible);
          cmp.set('v.showError', arrGipVisible.length === 0 ? true : false);
        }
      } else if (response.getState() === 'ERROR') {
        helper.showNewToastGipPkg('error', response.getError()[0].message);
      }
    });
    $A.enqueueAction(action);
  },
  showGipPkgDetail: function(cmp, evt, helper) {
    let pkgCmp = cmp.find('gipPkgDetail');
    let gipChevron = cmp.find('gipChevron');
    $A.util.toggleClass(pkgCmp, 'slds-hide');
    $A.util.toggleClass(gipChevron, 'rotate');
  },
  checkGipAddPermissions: function(cmp, helper, params) {
    return new Promise($A.getCallback(function(resolve, reject) {
      let action = cmp.get('c.checkGipAddPermissions');
      action.setParams(params);
      action.setCallback(this, function(response) {
        if (response.getState() === 'SUCCESS') {
          let ret = response.getReturnValue();
          resolve(ret);
        } else if (response.getState() === 'ERROR') {
          helper.showNewToastGipPkg('error', response.getError()[0].message);
          reject(response.getState());
        }
      });
      $A.enqueueAction(action);
    }));
  },
  showGipPkgNextCmp: function(cmp, helper, nextCmpName, recordId) {
    helper.createGipNextCmp(cmp, helper, nextCmpName, recordId).then($A.getCallback(newCmp => {
      $A.util.addClass(cmp.find('mySpinner'), 'slds-hide');
      let body = [];
      body.push(newCmp);
      cmp.set('v.body', body);
    }));
  },
  createGipNextCmp: function(cmp, helper, cmpName, recordId) {
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
            helper.showNewToastGipPkg('error', errorMessage);
          }
        }
      );
    }));
  },
  showNewToastGipPkg: function(type, message) {
    let titleGipPkgToast;
    switch (type) {
      case 'success':
        titleGipPkgToast = $A.get('$Label.cuco.toast_title_success');
        break;
      case 'warning':
        titleGipPkgToast = $A.get('$Label.cuco.toast_title_warning');
        break;
      case 'error':
        titleGipPkgToast = $A.get('$Label.cuco.toast_title_error');
        break;
    }
    var newGipPkgToast = $A.get('e.force:showToast');
    newGipPkgToast.setParams({
      'title': titleGipPkgToast,
      'type': type,
      'message': message
    });
    newGipPkgToast.fire();
  }
});