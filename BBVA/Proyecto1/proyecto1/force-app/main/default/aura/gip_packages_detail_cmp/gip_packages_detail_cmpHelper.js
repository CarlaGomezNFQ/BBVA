({
  checkGipDetailAddPermissions: function(cmp, helper, paramsGipAdd) {
    return new Promise($A.getCallback(function(resolve, reject) {
      let actionGipAdd = cmp.get('c.checkGipAddPermissions');
      actionGipAdd.setParams(paramsGipAdd);
      actionGipAdd.setCallback(this, function(responseGipAdd) {
        if (responseGipAdd.getState() === 'SUCCESS') {
          let retGipAdd = responseGipAdd.getReturnValue();
          resolve(retGipAdd);
        } else if (responseGipAdd.getState() === 'ERROR') {
          helper.showNewToastGipPkgDetail('error', responseGipAdd.getError()[0].message);
          reject(responseGipAdd.getState());
        }
      });
      $A.enqueueAction(actionGipAdd);
    }));
  },
  checkGipDetailEditPermissions: function(cmp, helper, paramsGipEdit) {
    return new Promise($A.getCallback(function(resolve, reject) {
      let actionGipEdit = cmp.get('c.checkGipEditPermissions');
      actionGipEdit.setParams(paramsGipEdit);
      actionGipEdit.setCallback(this, function(responseGipEdit) {
        if (responseGipEdit.getState() === 'SUCCESS') {
          let retGipEdit = responseGipEdit.getReturnValue();
          resolve(retGipEdit);
        } else if (responseGipEdit.getState() === 'ERROR') {
          helper.showNewToastGipPkgDetail('error', responseGipEdit.getError()[0].message);
          reject(responseGipEdit.getState());
        }
      });
      $A.enqueueAction(actionGipEdit);
    }));
  },
  checkGipDetailCancelPermissions: function(cmp, helper, paramsGipCancel) {
    return new Promise($A.getCallback(function(resolve, reject) {
      let actionGipCancel = cmp.get('c.checkGipCancelPermissions');
      actionGipCancel.setParams(paramsGipCancel);
      actionGipCancel.setCallback(this, function(responseGipCancel) {
        if (responseGipCancel.getState() === 'SUCCESS') {
          let retGipCancel = responseGipCancel.getReturnValue();
          resolve(retGipCancel);
        } else if (responseGipCancel.getState() === 'ERROR') {
          helper.showNewToastGipPkgDetail('error', responseGipCancel.getError()[0].message);
          reject(responseGipCancel.getState());
        }
      });
      $A.enqueueAction(actionGipCancel);
    }));
  },
  changeGipCollapsibleIcon: function(cmp, evt, helper) {
    let iconGipCmps = cmp.find('gipPkgIconCollapsible');
    let iconGipName = iconGipCmps.get('v.iconName');
    let gipDivDetails = cmp.find('gipPkgDetails');

    if (iconGipName === 'utility:chevrondown') {
      iconGipCmps.set('v.iconName', 'utility:chevronright');
      $A.util.removeClass(gipDivDetails, 'slds-show');
      $A.util.addClass(gipDivDetails, 'slds-hide');
    } else {
      iconGipCmps.set('v.iconName', 'utility:chevrondown');
      $A.util.removeClass(gipDivDetails, 'slds-hide');
      $A.util.addClass(gipDivDetails, 'slds-show');
    }
  },
  showGipDetailPkgNextCmp: function(cmp, helper, nextCmpName, gipPkg, recordId) {
    helper.createGipDetailNextCmp(cmp, helper, nextCmpName, gipPkg, recordId).then($A.getCallback(newCmp => {
      $A.util.addClass(cmp.find('mySpinner'), 'slds-hide');
      let body = [];
      body.push(newCmp);
      cmp.set('v.body', body);
    }));
  },
  createGipDetailNextCmp: function(cmp, helper, cmpName, gipPkg, recordId) {
    return new Promise($A.getCallback(function(resolve, reject) {
      $A.createComponent(
        'cuco:' + cmpName,
        {
          'profAnalysisId': recordId,
          'gipPkg': gipPkg
        },
        function(newCmp, status, errorMessage) {
          if (status === 'SUCCESS') {
            resolve(newCmp);
          } else if (status === 'INCOMPLETE' || status === 'ERROR') {
            $A.util.addClass(cmp.find('mySpinner'), 'slds-hide');
            helper.showNewToastGipPkgDetail('error', errorMessage);
          }
        }
      );
    }));
  },
  showNewToastGipPkgDetail: function(type, message) {
    let titleGipPkgDetailToast;
    switch (type) {
      case 'success':
        titleGipPkgDetailToast = $A.get('$Label.cuco.toast_title_success');
        break;
      case 'warning':
        titleGipPkgDetailToast = $A.get('$Label.cuco.toast_title_warning');
        break;
      case 'error':
        titleGipPkgDetailToast = $A.get('$Label.cuco.toast_title_error');
        break;
    }
    var newGipPkgDetailToast = $A.get('e.force:showToast');
    newGipPkgDetailToast.setParams({
      'title': titleGipPkgDetailToast,
      'type': type,
      'message': message
    });
    newGipPkgDetailToast.fire();
  }
});