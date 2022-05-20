({
  doInitDismissal: function(cmp, evt, helper) {
    $A.util.removeClass(cmp.find('simpleSpinner'), 'slds-hide');
    cmp.set('v.recordId', cmp.get('v.inputAttributes').recordId);
    let action = cmp.get('c.getDismissalBaseInfo');
    action.setParams({
      'profAnalysisId': cmp.get('v.recordId')
    });
    action.setCallback(this, function(response) {
      $A.util.addClass(cmp.find('simpleSpinner'), 'slds-hide');
      if (response.getState() === 'SUCCESS') {
        let ret = response.getReturnValue();
        cmp.set('v.questionLabel', ret.confirmQuestion);
        cmp.set('v.hasPriceApproval', ret.hasPriceApproval);
        cmp.set('v.priceApprovalId', ret.priceApprovalId);
        if (ret.hasPriceApproval && ret.priceApprovalId !== undefined) {
          cmp.set('v.commentsRequired', true);
          cmp.set('v.saveButtonDisabled', true);
          cmp.set('v.commentsLabel', $A.get('$Label.cuco.dismissal_price_comments'));
        } else {
          cmp.set('v.commentsRequired', false);
          cmp.set('v.commentsLabel', $A.get('$Label.cuco.dismissal_comments'));
        }
        cmp.set('v.isSuccess', true);
      } else if (response.getState() === 'ERROR') {
        helper.showNewToastDismissal('error', response.getError()[0].message, 'sticky');
      }
    });
    $A.enqueueAction(action);
  },
  doDismissalSave: function(cmp, evt, helper) {
    $A.util.removeClass(cmp.find('simpleSpinner'), 'slds-hide');
    let auditHtml  = document.getElementById('auditBody').innerHTML;
    let action = cmp.get('c.doDismissalSave');
    action.setParams({
      'profAnalysisId': cmp.get('v.recordId'),
      'dismissalComments': cmp.find('comments').get('v.value'),
      'screenShot': auditHtml
    });
    action.setCallback(this, function(response) {
      $A.util.addClass(cmp.find('simpleSpinner'), 'slds-hide');
      if (response.getState() === 'SUCCESS') {
        let ret = response.getReturnValue();
        if (ret.isSuccess) {
          helper.showNewToastDismissal('success', ret.message, 'pester');
          $A.get('e.force:refreshView').fire();
          helper.destroyCmp(cmp, evt, helper);
        } else {
          helper.showNewToastDismissal('error', ret.errMessage, 'sticky');
          let cancelEvent = cmp.getEvent('dynamicFlowWizardCancel');
          cancelEvent.fire();
        }
      } else if (response.getState() === 'ERROR') {
        helper.showNewToastDismissal('error', response.getError()[0].message, 'sticky');
        let cancelEvent = cmp.getEvent('dynamicFlowWizardCancel');
        cancelEvent.fire();
      }
    });
    $A.enqueueAction(action);
  },
  showNewToastDismissal: function(type, message, mode) {
    let titleDismissalToast;
    switch (type) {
      case 'success':
        titleDismissalToast = $A.get('$Label.cuco.toast_title_success');
        break;
      case 'warning':
        titleDismissalToast = $A.get('$Label.cuco.toast_title_warning');
        break;
      case 'error':
        titleDismissalToast = $A.get('$Label.cuco.toast_title_error');
        break;
    }
    var newDismissalToast = $A.get('e.force:showToast');
    newDismissalToast.setParams({
      'mode': mode,
      'title': titleDismissalToast,
      'type': type,
      'message': message
    });
    newDismissalToast.fire();
  }
});