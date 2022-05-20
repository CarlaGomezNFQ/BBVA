({
  initDelegation: function(component, event, helper) {
    var inputAttributes = component.get('v.inputAttributes');
    var action = component.get('c.initDelegation');
    action.setParams({
      accHasAnalysisId: inputAttributes.recordId
    });
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (state === 'SUCCESS') {
        var resp = JSON.parse(response.getReturnValue());
        if (resp.codStatus === 200) {
          component.set('v.isRatingCalculated', true);
          component.set('v.delegationWrapper', resp);
        } else if (resp.codStatus === 500) {
          helper.executeError(component, helper, 'error', resp.msgInfo);
        }
      } else {
        component.set('v.isRatingCalculated', false);
        helper.executeError(component, helper, 'error', response.getError()[0].message);
      }
      component.set('v.spinnerStatus', false);
    });
    $A.enqueueAction(action);
  },
  fetchUsers: function(component, event, helper) {
    var action = component.get('c.fetchUsers');
    action.setParams({
      selectedAmbit: component.get('v.selectedOption')
    });
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (state === 'SUCCESS') {
        var resp = JSON.parse(response.getReturnValue());
        if (resp.codStatus === 200) {
          component.set('v.deleUserWrapper', resp);
          component.set('v.isRatingCalculated', true);
        } else if (resp.codStatus === 500) {
          helper.executeError(component, helper, 'error', resp.msgInfo);
        }
      } else {
        component.set('v.isRatingCalculated', false);
        helper.executeError(component, helper, 'error', response.getError()[0].message);
      }
      component.set('v.spinnerStatus', false);
    });
    $A.enqueueAction(action);
  },
  proposeRaip: function(component, event, helper) {
    var wrapper = component.get('v.delegationWrapper');
    var action = component.get('c.toProposeRaip');
    action.setParams({
      arceId: wrapper.analysisId,
      selectedAmbit: component.get('v.selectedOption'),
      selectedUser: component.get('v.selectedOptionUser')
    });
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (state === 'SUCCESS') {
        var resp = JSON.parse(response.getReturnValue());
        if (resp.status === 'true') {
          component.set('v.modalStep', '2');
          helper.refreshTab();
        } else {
          helper.executeError(component, helper, 'error', resp.message);
        }
      } else {
        helper.executeError(component, helper, 'error', response.getError()[0].message);
      }
      component.set('v.spinnerStatus', false);
    });
    $A.enqueueAction(action);
  },
  showToast: function(type, message) {
    var toastEventUE = $A.get('e.force:showToast');
    toastEventUE.setParams({
      'title': '',
      'type': type,
      'mode': 'sticky',
      'duration': '8000',
      'message': message
    });
    toastEventUE.fire();
  },
  cancelAction: function(component) {
    component.set('v.show', 'false');
    component.destroy();
  },
  executeError: function(component, helper, type, msgError) {
    component.set('v.selectedOption', '');
    if (type === 'toast') {
      helper.showToast('error', msgError);
      helper.cancelAction(component);
    } else if (type === 'error') {
      component.set('v.showErrorSection', true);
      component.set('v.errorMessage', msgError);
    }
  },
  refreshTab: function() {
    window.setTimeout($A.getCallback(function() {
      window.location.reload();
    }), 2500);
  },
  checkPermission: function(component) {
    var inputAttributes = component.get('v.inputAttributes');
    var action = component.get('c.getPermissionOverlay');
    action.setParams({
      'recordId': inputAttributes.recordId,
    });
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (state === 'SUCCESS') {
        var resp = response.getReturnValue();
        component.set('v.show', resp);
        if (!resp) {
          this.showToast('WARNING', $A.get('$Label.c.Arc_Gen_ProposeOverlay'));
        }
      }
    });
    $A.enqueueAction(action);
  }
});