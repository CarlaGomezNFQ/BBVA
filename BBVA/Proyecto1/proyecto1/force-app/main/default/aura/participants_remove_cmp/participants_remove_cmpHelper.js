({
  doPreviousChecks: function(cmp, evt, helper) {
    $A.util.removeClass(cmp.find('simpleSpinner'), 'slds-hide');
    cmp.set('v.title', $A.get('$Label.cuco.remove_participants_title'));
    let radioButtonValues = [];
    let objValue1 = {'label': $A.get('$Label.cuco.remove_permanently'), 'value': 'permanently'};
    radioButtonValues.push(objValue1);
    let objValue2 = {'label': $A.get('$Label.cuco.remove_temporarily'), 'value': 'temporarily'};
    radioButtonValues.push(objValue2);
    cmp.set('v.optionRadioButton', radioButtonValues);
    let action = cmp.get('c.doPreviousChecks');
    action.setParams({
      'recordId': cmp.get('v.recordId')
    });
    action.setCallback(this, function(response) {
      if (response.getState() === 'SUCCESS') {
        let ret = response.getReturnValue();
        cmp.set('v.stage', ret.stage);
        cmp.set('v.papName', ret.papName);
        cmp.set('v.profAnalysisId', ret.profAnalysisId);
        cmp.set('v.hasReqPkg', ret.hasReqPkg);
        cmp.set('v.hasExtPkg', ret.hasExtPkg);
        cmp.set('v.extPkgName', ret.extPkgName);
        if (ret.stage === 1) { // If have an extended package
          cmp.set('v.participantsRemoveBannerMsg', ret.papName + ' ' + '\n' + $A.get('$Label.cuco.extended_pkg'));
          cmp.set('v.labelRadioButton', $A.get('$Label.cuco.removal_type_confirmation_pre') + ' ' + ret.papName + ' ' + $A.get('$Label.cuco.removal_type_confirmation_post'));
        }
        $A.util.addClass(cmp.find('simpleSpinner'), 'slds-hide');
      } else if (response.getState() === 'ERROR') {
        helper.showNewToastParticipantRemoveCmp('error', response.getError()[0].message);
      }
    });
    $A.enqueueAction(action);
  },
  handleRadioButtonChange: function(cmp, evt, helper) {
    let currentValue = evt.getParam('value');
    cmp.set('v.firstStageAction', currentValue);
    cmp.set('v.hasDisableButton', false);
  },
  handleContinue: function(cmp, evt, helper) {
    cmp.set('v.stage', 2);
  },
  handleDelete: function(cmp, evt, helper) {
    $A.util.removeClass(cmp.find('simpleSpinner'), 'slds-hide');
    let action = cmp.get('c.doRemoveActions');
    action.setParams({
      'recordId': cmp.get('v.recordId'),
      'firstWarning': cmp.get('v.firstStageAction')
    });
    action.setCallback(this, function(response) {
      if (response.getState() === 'SUCCESS') {
        let ret = response.getReturnValue();
        if (ret.errMessage !== '' && ret.errMessage !== undefined) {
          switch (ret.toastType) {
            case 'warning':
              helper.showNewToastParticipantRemoveCmp('warning', ret.errMessage);
              break;
            case 'error':
              helper.showNewToastParticipantRemoveCmp('error', ret.errMessage);
              break;
          }
        } else {
          // No errors. Fire evt and destroy modal cmp
          helper.showNewToastParticipantRemoveCmp('success', $A.get('$Label.cuco.remove_participant_success'));

          // Refresh participants evt
          let appEvent = $A.get('e.cuco:refresh_participants_evt');
          appEvent.setParams({
            'contextId': cmp.get('v.profAnalysisId')
          });
          appEvent.fire();

          // Refresh participants evt
          let appEventCommPartRemove = $A.get('e.cuco:refresh_comm_packages_evt');
          appEventCommPartRemove.setParams({
            'contextId': cmp.get('v.profAnalysisId')
          });
          appEventCommPartRemove.fire();

          // Refresh forfait packages evt
          let appEventForfaitPartRemove = $A.get('e.cuco:refresh_forfait_packages_evt');
          appEventForfaitPartRemove.setParams({
            'contextId': cmp.get('v.profAnalysisId')
          });
          appEventForfaitPartRemove.fire();

          // Refresh gip package evt
          let appEventGipPartRemove = $A.get('e.cuco:refresh_gip_packages_evt');
          appEventGipPartRemove.setParams({
            'contextId': cmp.get('v.profAnalysisId')
          });
          appEventGipPartRemove.fire();

          // Refresh condition  evt
          let appEventGipRefreshConditions = $A.get('e.cuco:refresh_conditions_evt');
          appEventGipRefreshConditions.setParams({
            'contextId': cmp.get('v.profAnalysisId')
          });
          appEventGipRefreshConditions.fire();

          // Refresh flat evt
          let appEventFlatRefreshFlat = $A.get('e.cuco:refresh_flat_rates_evt');
          appEventFlatRefreshFlat.setParams({
            'contextId': cmp.get('v.profAnalysisId')
          });
          appEventFlatRefreshFlat.fire();
          helper.destroyCmp(cmp, evt, helper);
        }
        $A.util.addClass(cmp.find('simpleSpinner'), 'slds-hide');
      } else if (response.getState() === 'ERROR') {
        helper.showNewToastParticipantRemoveCmp('error', response.getError()[0].message);
      }
    });
    $A.enqueueAction(action);
  },
  showNewToastParticipantRemoveCmp: function(type, message) {
    let titleRemoveToast;
    switch (type) {
      case 'success':
        titleRemoveToast = $A.get('$Label.cuco.toast_title_success');
        break;
      case 'warning':
        titleRemoveToast = $A.get('$Label.cuco.toast_title_warning');
        break;
      case 'error':
        titleRemoveToast = $A.get('$Label.cuco.toast_title_error');
        break;
    }
    let newToastParticipantRemoveCmp = $A.get('e.force:showToast');
    newToastParticipantRemoveCmp.setParams({
      'title': titleRemoveToast,
      'type': type,
      'message': message
    });
    newToastParticipantRemoveCmp.fire();
  }
});