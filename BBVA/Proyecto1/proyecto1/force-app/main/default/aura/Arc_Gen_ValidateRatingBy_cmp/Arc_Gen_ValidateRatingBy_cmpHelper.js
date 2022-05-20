({
  getRatingData: function(component) {
    var action = component.get('c.getRatingData');
    action.setParams({
      aHaId: component.get('v.recordId')
    });
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (state === 'SUCCESS') {
        var resp = response.getReturnValue();
        var respData = resp.data;
        if (resp.success) {
          component.set('v.ratingId', respData.ratingId);
          component.set('v.subProcessType', respData.subProcessType);
          component.set('v.wkfType', respData.wfType);
          component.set('v.ambitOptions', respData.ambitList);

          var ApiValueCRP = $A.get('$Label.arce.Arc_Gen_NewRaipOverrideApi');
          if(respData.wfType === ApiValueCRP) {
            component.set('v.entityOptions', [
              { label: 'Risk committee', value: 'COMITE' },
              { label: 'User', value: 'user' }
            ]);
          }
          if (
            respData.wfType === ApiValueCRP ||
            respData.ffssCertification === 'PROFORMA' ||
            respData.ffssCertification === 'PRO_FORMA_MERGER' ||
            respData.ffssCertification === 'PRO_FORMA_ACQUISITION'
          ) {
            component.set('v.blockedEntity', true);
            component.set('v.entity', 'COMITE');
          }
        } else {
          component.set('v.errorMessage', resp.message);
        }
        component.set('v.success', resp.success);
      } else {
        component.set('v.show', false);
        this.showToast('error', response.getError()[0].message);

        //$A.get('e.force:closeQuickAction').fire();

      }
      component.set('v.loading', false);
    });
    $A.enqueueAction(action);
  },

  fetchUsers: function(component, ambitId) {
    var action = component.get('c.fetchUsersAha');

    action.setParams({
      selectedAmbit: ambitId,
      aHaId: component.get('v.recordId')
    });

    action.setCallback(this, function(response) {
      var state = response.getState();
      if (state === 'SUCCESS') {
        var resp = response.getReturnValue();
        var respData = resp.data;
        if (resp.success) {
          component.set('v.userOptions', respData.userList);
        } else {
          component.set('v.errorMessage', resp.message);
        }
        component.set('v.success', resp.success);
      } else {
        component.set('v.show', false);
        this.showToast('error', response.getError()[0].message);

        //$A.get('e.force:closeQuickAction').fire();

      }
      component.set('v.loading', false);
    });
    $A.enqueueAction(action);
  },

  validating: function(component) {
    var action = component.get('c.validateRating');
    var slectedEntity = component.get('v.entity');

    action.setParams({
      analysisId: component.get('v.recordId'),
      ratingId: component.get('v.ratingId'),
      validatedById: slectedEntity === 'COMITE' ? slectedEntity : component.get('v.selectedUserId'),
      description: component.get('v.validateDescr')
    });

    action.setCallback(this, function(response) {
      var state = response.getState();
      var resp = response.getReturnValue();
      if (state === 'SUCCESS') {
        if (!resp.success) {
          component.set("v.errorMessage", resp.message);
        }
        component.set('v.success', resp.success);
        this.refreshTab();
      } else {
        component.set("v.success", false);
        component.set('v.show', false);
        this.showToast('error', ' : ' + response.getError()[0].message);

        //$A.get('e.force:closeQuickAction').fire();

      }
      component.set("v.completed", true);
      component.set('v.loading', false);
    });
    $A.enqueueAction(action);
  },

  showToast: function(type, message) {
    var toastEventUE = $A.get('e.force:showToast');
    toastEventUE.setParams({
      title: '',
      type: type,
      mode: 'sticky',
      duration: '8000',
      message: message
    });
    toastEventUE.fire();
  },
  refreshTab: function() {
    window.setTimeout($A.getCallback(function() {
      window.location.reload();
    }), 2500);
  }
});