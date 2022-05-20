({
  doInitRestudy: function(cmp, evt, helper) {
    cmp.set('v.recordId', cmp.get('v.inputAttributes').recordId);
    $A.util.removeClass(cmp.find('simpleSpinner'), 'slds-hide');
    let a = cmp.get('c.getRestudyBaseInfo');
    a.setParams({
      'profAnalysisId': cmp.get('v.recordId')
    });
    a.setCallback(this, function(response) {
      $A.util.addClass(cmp.find('simpleSpinner'), 'slds-hide');
      if (response.getState() === 'SUCCESS') {
        let ret = response.getReturnValue();
        cmp.set('v.commentsLabel', ret.commentsLabel);
        cmp.set('v.commentsRequired', ret.requiredComments);
        if (ret.requiredComments) {
          cmp.set('v.saveButtonDisabled', true);
        }
        cmp.set('v.isSuccess', true);
      } else if (response.getState() === 'ERROR') {
        helper.showNewToastRestudy('error', response.getError()[0].message, 'sticky');
        let cancelEvent = cmp.getEvent('dynamicFlowWizardCancel');
        cancelEvent.fire();
      }
    });
    $A.enqueueAction(a);
  },
  doDismissalSave: function(cmp, evt, helper) {
    $A.util.removeClass(cmp.find('simpleSpinner'), 'slds-hide');
    let auditHtml  = document.getElementById('auditBody').innerHTML;
    let a = cmp.get('c.doRestudySave');
    a.setParams({
      'profAnalysisId': cmp.get('v.recordId'),
      'restudyComments': cmp.find('comments').get('v.value'),
      'screenShot': auditHtml
    });
    a.setCallback(this, function(response) {
      $A.util.addClass(cmp.find('simpleSpinner'), 'slds-hide');
      if (response.getState() === 'SUCCESS') {
        let ret = response.getReturnValue();
        if (ret.isSuccess) {
          helper.showNewToastRestudy('success', ret.message, 'pester');
          $A.get('e.force:refreshView').fire();
          helper.destroyCmp(cmp, evt, helper);
        } else {
          helper.showNewToastRestudy('error', ret.errMessage, 'sticky');
        }
      } else if (response.getState() === 'ERROR') {
        helper.showNewToastRestudy('error', response.getError()[0].message, 'sticky');
        let cancelEvent = cmp.getEvent('dynamicFlowWizardCancel');
        cancelEvent.fire();
      }
    });
    $A.enqueueAction(a);
  },
  showNewToastRestudy: function(type, message, mode) {
    let titleRestudyToast;
    switch (type) {
      case 'success':
        titleRestudyToast = $A.get('$Label.cuco.toast_title_success');
        break;
      case 'warning':
        titleRestudyToast = $A.get('$Label.cuco.toast_title_warning');
        break;
      case 'error':
        titleRestudyToast = $A.get('$Label.cuco.toast_title_error');
        break;
    }
    var newRestudyToast = $A.get('e.force:showToast');
    newRestudyToast.setParams({
      'mode': mode,
      'title': titleRestudyToast,
      'type': type,
      'message': message
    });
    newRestudyToast.fire();
  }
});