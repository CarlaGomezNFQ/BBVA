({
  init: function(component, event, helper) {
	helper.checkPermission(component);
    helper.initDelegation(component, event, helper);
  },
  handleChange: function(component, event, helper) {
    component.set('v.selectedOption', event.getParam('value'));
    helper.fetchUsers(component, event, helper);
  },
  handleChangeUser: function(component, event, helper) {
    component.set('v.selectedOptionUser', event.getParam('value'));
  },
  toPropose: function(component, event, helper) {
    component.set('v.spinnerStatus', true);
    helper.proposeRaip(component, event, helper);
  },
  cancel: function(component, event, helper) {
    helper.cancelAction(component);
  },
  finish: function(component, event, helper) {
    component.set('v.show', 'false');
    $A.get('e.force:refreshView').fire();
  }
});