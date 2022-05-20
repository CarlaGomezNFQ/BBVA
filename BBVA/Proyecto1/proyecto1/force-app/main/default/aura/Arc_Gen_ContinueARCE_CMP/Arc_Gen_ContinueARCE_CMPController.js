({
  initHandler: function(component, event, helper) {
    var actionCall = component.get('c.getGroupId');
    actionCall.setParams({
      recordId: component.get('v.recordId')
    });
    actionCall.setCallback(this, function(response) {
      var state = response.getState();
      if (state === 'SUCCESS') {
        var resp = response.getReturnValue();
        if (resp.arce__wf_status_id__c === '01') {
          component.set('v.idGroup', resp.Local_Client__c);
          component.set('v.arceTypeToContinue', resp.arce__anlys_wkfl_sub_process_type__c === '4' ? 'raip' : 'analysis');
          component.set('v.load', true);
        }
      }
    });
    $A.enqueueAction(actionCall);
  },

  closeModal: function(component, event, helper) {
    var homeEvt = $A.get('e.force:navigateToObjectHome');
    homeEvt.setParams({
      'scope': component.get('v.sObjectName')
    });
    homeEvt.fire();
  }
});