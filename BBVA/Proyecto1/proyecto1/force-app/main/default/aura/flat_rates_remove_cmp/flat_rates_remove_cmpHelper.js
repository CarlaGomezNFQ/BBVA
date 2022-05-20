({
  initCmp: function(cmp, evt, helper) {

    $A.util.removeClass(cmp.find('loadSpinner'), 'slds-hide');
    let action = cmp.get('c.requestData');
    action.setParams({
      'profAnalysisFlatRatesId': cmp.get('v.profAnalysisFlatRatesId')
    });
    action.setCallback(helper, function(response) {
      if (cmp.isValid() && response.getState() === 'SUCCESS') {
        let returnedMap = response.getReturnValue();
        cmp.set('v.profAnalysisFlatRate', returnedMap.returnedFlatRate);
        cmp.set('v.canRemove', returnedMap.canRemove.remove);
        cmp.set('v.requestType', returnedMap.returnedFlatRate.cuco__gf_pa_fr_request_type__c);
        cmp.set('v.cmunDate', returnedMap.contextProfAnal.cuco__gf_auto_form_sys_lst_cmun_date__c);
        helper.labelSettings(cmp, evt, helper);
        helper.validateRemove(cmp, evt, helper, returnedMap);
      } else {
        helper.showNewToast('sticky', 'Error', 'error', response.getError()[0].message);
      }
    });
    $A.enqueueAction(action);
  },
  validateRemove: function(cmp, evt, helper, returnedMap) {

    if (cmp.get('v.canRemove') === true) {
      helper.validateFormalization(cmp, evt, helper);
    } else {
      cmp.set('v.isSuccess', false);
      cmp.set('v.canRemove', false);
      helper.showNewToast('sticky', 'Error', 'error', returnedMap.canRemove.removeMessage);
      helper.handleCancel(cmp, evt, helper);
    }
    $A.util.addClass(cmp.find('loadSpinner'), 'slds-hide');
  },
  validateFormalization: function(cmp, evt, helper) {

    let requestType = cmp.get('v.requestType');
    let cmunDate = cmp.get('v.cmunDate');
    if (undefined !== cmunDate && cmunDate !== null && (requestType === 'Cancellation' || requestType === 'Modification')) {
      var message = null;
      if (requestType === 'Cancellation') {
        message = $A.get('$Label.cuco.flat_previous_form_cancellation_error');
      } else if (requestType === 'Modification') {
        message = $A.get('$Label.cuco.flat_previous_form_modification_error');
      }
      cmp.set('v.canRemove', false);
      cmp.set('v.isSuccess', false);
      helper.showNewToast('sticky', 'Error', 'error', message);
      helper.handleCancel(cmp, evt, helper);
    } else {
      cmp.set('v.canRemove', true);
      cmp.set('v.isSuccess', true);
    }
  },
  labelSettings: function(cmp) {

    if (cmp.get('v.requestType') === 'Cancellation') {
      cmp.set('v.title', $A.get('$Label.cuco.flat_rates_undo_title'));
      cmp.set('v.confirmationMessage', $A.get('$Label.cuco.flat_rates_undo_confirmation'));
      cmp.set('v.buttonLabel', $A.get('$Label.cuco.flat_rates_undo_button'));
    } else {
      cmp.set('v.title', $A.get('$Label.cuco.flat_rates_remove_title'));
      cmp.set('v.confirmationMessage', $A.get('$Label.cuco.flat_rates_remove_confirmation'));
      cmp.set('v.buttonLabel', $A.get('$Label.cuco.flat_rates_remove_button'));
    }
  },
  handleConfirm: function(cmp, evt, helper) {

    $A.util.removeClass(cmp.find('loadSpinner'), 'slds-hide');
    if (cmp.get('v.canRemove') && cmp.get('v.isSuccess')) {
      let action = cmp.get('c.persistData');
      action.setParams({
        'profAnalysisFlatRates': cmp.get('v.profAnalysisFlatRate')
      });
      action.setCallback(helper, function(response) {
        if (cmp.isValid() && response.getState() === 'SUCCESS') {
          let returnedMap = response.getReturnValue();
          helper.endExecutions(cmp, evt, helper, returnedMap);
        } else {
          helper.showNewToast('sticky', 'Error', 'error', response.getError()[0].message);
          $A.util.addClass(cmp.find('loadSpinner'), 'slds-hide');
        }
      });
      $A.enqueueAction(action);
    }
  },
  handleCancel: function(cmp, evt, helper) {
    helper.destroyCmp(cmp, evt, helper);
  },
  endExecutions: function(cmp, evt, helper, returnedMap) {
    if (returnedMap.isSuccess) {
      if (cmp.get('v.requestType') === 'Cancellation') {
        helper.showNewToast('dismissible', $A.get('$Label.cuco.toast_title_success'), 'success', $A.get('$Label.cuco.flat_rates_undo_success'));
      } else {
        helper.showNewToast('dismissible', $A.get('$Label.cuco.toast_title_success'), 'success', $A.get('$Label.cuco.flat_rates_remove_success'));
      }

      // Refresh condition  evt
      let appEventFlatRemoveRefreshConditions = $A.get('e.cuco:refresh_conditions_evt');
      appEventFlatRemoveRefreshConditions.setParams({
        'contextId': cmp.get('v.profAnalysisFlatRate').cuco__gf_profitablity_analysis_id__c
      });
      appEventFlatRemoveRefreshConditions.fire();

      // Refresh flat rates evt
      const appEvent = $A.get('e.cuco:refresh_flat_rates_evt');
      appEvent.setParams({'contextId': cmp.get('v.profAnalysisFlatRate').cuco__gf_profitablity_analysis_id__c});
      appEvent.fire();
    } else {
      helper.showNewToast('sticky', 'Error', 'error', $A.get('$Label.cuco.flat_rates_remove_error') + ' ' + returnedMap.errorMessage);
      $A.util.addClass(cmp.find('loadSpinner'), 'slds-hide');
    }
    helper.handleCancel(cmp, evt, helper);
  },
  showNewToast: function(mode, title, type, message) {

    let newToast = $A.get('e.force:showToast');
    newToast.setParams({
      'mode': mode,
      'title': title,
      'type': type,
      'message': message
    });
    newToast.fire();
  },
});