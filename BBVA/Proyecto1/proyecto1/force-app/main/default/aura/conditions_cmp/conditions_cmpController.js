/* eslint-disable no-unused-expressions */
({
  doInit: function(cmp, event, helper) {
    helper.doInit(cmp, event, helper);
  },

  refreshConditions: function(cmp, event, helper) {
    helper.refreshConditions(cmp, event, helper);
  },

  addConditions: function(cmp, event, helper) {
    var params = {
      action: 'addConditions',
      profAnalysisId: cmp.get('v.recordId'),
      familyId: null,
      conditionId: null
    };
    helper.checkPermission(cmp, params, 'add').then(result => {
      if (result.add) {
        helper.addConditions(cmp, event, helper);
      } else {
        helper.showToast('error', 'Error', result.addMessage);
      }
    }).catch(function(error) {
      $A.reportError('check permission failed', error);
    });
  },

  editConditions: function(cmp, event, helper) {
    var params = {
      action: 'editConditions',
      profAnalysisId: cmp.get('v.recordId'),
      familyId: event.target.id,
      conditionId: null
    };
    helper.checkPermission(cmp, params, 'edit').then(result => {
      if (result.edit) {
        helper.editConditions(cmp, event, helper, params);
      } else {
        helper.showToast('error', 'Error', result.editMessage);
      }
    }).catch(function(error) {
      $A.reportError('check permission failed', error);
    });
  },

  removeCondition: function(cmp, event, helper) {
    var params = {
      action: 'removeConditions',
      profAnalysisId: cmp.get('v.recordId'),
      familyId: null,
      conditionId: event.currentTarget.dataset.id
    };
    helper.checkPermission(cmp, params, 'remove').then(result => {
      if (result.remove) {
        helper.removeCondition(cmp, event, helper, params);
      } else {
        helper.showToast('error', 'Error', result.removeMessage);
      }
    }).catch(function(error) {
      $A.reportError('check permission failed', error);
    });
  },

  handleConditionsSelectContinue: function(cmp, event, helper) {
    helper.handleConditionsSelectContinue(cmp, event, helper);
  }
});