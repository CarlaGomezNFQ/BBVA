({
  checkForfaitDetailAddPermissions: function(cmp, helper, paramsForfaitAdd) {
    return new Promise($A.getCallback(function(resolve, reject) {
      let actionForfaitAdd = cmp.get('c.checkForfaitAddPermissions');
      actionForfaitAdd.setParams(paramsForfaitAdd);
      actionForfaitAdd.setCallback(this, function(responseForfaitAdd) {
        if (responseForfaitAdd.getState() === 'SUCCESS') {
          let retForfaitAdd = responseForfaitAdd.getReturnValue();
          resolve(retForfaitAdd);
        } else if (responseForfaitAdd.getState() === 'ERROR') {
          helper.showNewToastForfaitPkgDetail('error', responseForfaitAdd.getError()[0].message);
          reject(responseForfaitAdd.getState());
        }
      });
      $A.enqueueAction(actionForfaitAdd);
    }));
  },
  checkForfaitDetailEditPermissions: function(cmp, helper, paramsForfaitEdit) {
    return new Promise($A.getCallback(function(resolve, reject) {
      let actionForfaitEdit = cmp.get('c.checkForfaitEditPermissions');
      actionForfaitEdit.setParams(paramsForfaitEdit);
      actionForfaitEdit.setCallback(this, function(responseForfaitEdit) {
        if (responseForfaitEdit.getState() === 'SUCCESS') {
          let retForfaitEdit = responseForfaitEdit.getReturnValue();
          resolve(retForfaitEdit);
        } else if (responseForfaitEdit.getState() === 'ERROR') {
          helper.showNewToastForfaitPkgDetail('error', responseForfaitEdit.getError()[0].message);
          reject(responseForfaitEdit.getState());
        }
      });
      $A.enqueueAction(actionForfaitEdit);
    }));
  },
  checkForfaitDetailCancelPermissions: function(cmp, helper, paramsForfaitCancel) {
    return new Promise($A.getCallback(function(resolve, reject) {
      let actionForfaitCancel = cmp.get('c.checkForfaitCancelPermissions');
      actionForfaitCancel.setParams(paramsForfaitCancel);
      actionForfaitCancel.setCallback(this, function(responseForfaitCancel) {
        if (responseForfaitCancel.getState() === 'SUCCESS') {
          let retForfaitCancel = responseForfaitCancel.getReturnValue();
          resolve(retForfaitCancel);
        } else if (responseForfaitCancel.getState() === 'ERROR') {
          helper.showNewToastForfaitPkgDetail('error', responseForfaitCancel.getError()[0].message);
          reject(responseForfaitCancel.getState());
        }
      });
      $A.enqueueAction(actionForfaitCancel);
    }));
  },
  changeForfaitCollapsibleIcon: function(cmp, evt, helper) {
    let iconForfaitCmps = cmp.find('forfaitPkgIconCollapsible');
    let iconForfaitName = iconForfaitCmps.get('v.iconName');
    let forfaitDivDetails = cmp.find('forfaitPkgDetails');

    if (iconForfaitName === 'utility:chevrondown') {
      iconForfaitCmps.set('v.iconName', 'utility:chevronright');
      $A.util.removeClass(forfaitDivDetails, 'slds-show');
      $A.util.addClass(forfaitDivDetails, 'slds-hide');
    } else {
      iconForfaitCmps.set('v.iconName', 'utility:chevrondown');
      $A.util.removeClass(forfaitDivDetails, 'slds-hide');
      $A.util.addClass(forfaitDivDetails, 'slds-show');
    }
  },
  showForfaitDetailPkgNextCmp: function(cmp, helper, nextCmpName, forfaitPkg, recordId) {
    helper.createForfaitDetailNextCmp(cmp, helper, nextCmpName, forfaitPkg, recordId).then($A.getCallback(newCmp => {
      $A.util.addClass(cmp.find('mySpinner'), 'slds-hide');
      let body = [];
      body.push(newCmp);
      cmp.set('v.body', body);
    }));
  },
  createForfaitDetailNextCmp: function(cmp, helper, cmpName, forfaitPkg, recordId) {
    return new Promise($A.getCallback(function(resolve, reject) {
      $A.createComponent(
        'cuco:' + cmpName,
        {
          'profAnalysisId': recordId,
          'forfaitPkg': forfaitPkg
        },
        function(newCmp, status, errorMessage) {
          if (status === 'SUCCESS') {
            resolve(newCmp);
          } else if (status === 'INCOMPLETE' || status === 'ERROR') {
            $A.util.addClass(cmp.find('mySpinner'), 'slds-hide');
            helper.showNewToastForfaitPkgDetail('error', errorMessage);
          }
        }
      );
    }));
  },
  showNewToastForfaitPkgDetail: function(type, message) {
    let titleForfaitPkgDetailToast;
    switch (type) {
      case 'success':
        titleForfaitPkgDetailToast = $A.get('$Label.cuco.toast_title_success');
        break;
      case 'warning':
        titleForfaitPkgDetailToast = $A.get('$Label.cuco.toast_title_warning');
        break;
      case 'error':
        titleForfaitPkgDetailToast = $A.get('$Label.cuco.toast_title_error');
        break;
    }
    var newForfaitPkgDetailToast = $A.get('e.force:showToast');
    newForfaitPkgDetailToast.setParams({
      'title': titleForfaitPkgDetailToast,
      'type': type,
      'message': message
    });
    newForfaitPkgDetailToast.fire();
  }
});