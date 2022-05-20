({
  getStatus: function(component, event, helper) {
    const action = component.get('c.getBSbuttonsPerm');
    action.setParams({
      aHasAnalysId: component.get('v.recordId')
    });
    action.setCallback(this, function(response) {
      const state = response.getState();
      if (state === 'SUCCESS') {
        let resp = response.getReturnValue();
        component.set('v.validated', resp);
        component.set('v.obtained', true);
      }
    });
    $A.enqueueAction(action);
  }
});