({
  checkCommEditPermissions: function(cmp, helper, paramsCommEdit) {
    return new Promise($A.getCallback(function(resolve, reject) {
      let actionCommEdit = cmp.get('c.checkCommEditPermissions');
      actionCommEdit.setParams(paramsCommEdit);
      actionCommEdit.setCallback(this, function(responseCommEdit) {
        if (responseCommEdit.getState() === 'SUCCESS') {
          let retComEdit = responseCommEdit.getReturnValue();
          resolve(retComEdit);
        } else if (responseCommEdit.getState() === 'ERROR') {
          helper.showNewToastCommPkgDetail('error', responseCommEdit.getError()[0].message);
          reject(responseCommEdit.getState());
        }
      });
      $A.enqueueAction(actionCommEdit);
    }));
  },
  changeCommCollapsibleIcon: function(cmp, evt, helper) {
    let iconCommCmps = cmp.find('commPkgIconCollapsible');
    let iconCommName = iconCommCmps.get('v.iconName');
    let commDivDetails = cmp.find('commPkgDetails');

    if (iconCommName === 'utility:chevrondown') {
      iconCommCmps.set('v.iconName', 'utility:chevronright');
      $A.util.removeClass(commDivDetails, 'slds-show');
      $A.util.addClass(commDivDetails, 'slds-hide');
    } else {
      iconCommCmps.set('v.iconName', 'utility:chevrondown');
      $A.util.removeClass(commDivDetails, 'slds-hide');
      $A.util.addClass(commDivDetails, 'slds-show');
    }
  },
  showCommPkgEditCmp: function(cmp, helper, nextCmpName, commPkg, recordId) {
    helper.createNextCmp(cmp, helper, nextCmpName, commPkg, recordId).then($A.getCallback(newCmp => {
      $A.util.addClass(cmp.find('mySpinner'), 'slds-hide');
      let body = [];
      body.push(newCmp);
      cmp.set('v.body', body);
    }));
  },
  createNextCmp: function(cmp, helper, cmpName, commPkg, recordId) {
    return new Promise($A.getCallback(function(resolve, reject) {
      $A.createComponent(
        'cuco:' + cmpName,
        {
          'profAnalysisId': recordId,
          'commPkg': commPkg
        },
        function(newCmp, status, errorMessage) {
          if (status === 'SUCCESS') {
            resolve(newCmp);
          } else if (status === 'INCOMPLETE' || status === 'ERROR') {
            $A.util.addClass(cmp.find('mySpinner'), 'slds-hide');
            helper.showNewToastCommPkgDetail('error', errorMessage);
          }
        }
      );
    }));
  },
  showNewToastCommPkgDetail: function(type, message) {
    let titleCommPkgDetailToast;
    switch (type) {
      case 'success':
        titleCommPkgDetailToast = $A.get('$Label.cuco.toast_title_success');
        break;
      case 'warning':
        titleCommPkgDetailToast = $A.get('$Label.cuco.toast_title_warning');
        break;
      case 'error':
        titleCommPkgDetailToast = $A.get('$Label.cuco.toast_title_error');
        break;
    }
    var newCommPkgDetailToast = $A.get('e.force:showToast');
    newCommPkgDetailToast.setParams({
      'title': titleCommPkgDetailToast,
      'type': type,
      'message': message
    });
    newCommPkgDetailToast.fire();
  }
});