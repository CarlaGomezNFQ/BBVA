({
  init: function(component, event, helper) {
    var inputAttrs = component.get('v.inputAttributes');
    component.set('v.recordId', inputAttrs.recordId);

    component.set('v.entityOptions', [
      { label: 'Committee', value: 'COMITE' },
      { label: 'User', value: 'user' }
    ]);
    helper.getRatingData(component);
  },
  validateAction: function(component, event, helper) {
    component.set('v.loading', true);
    helper.validating(component);
  },
  changeAmbit: function(component, event, helper) {
    var ambitId = event.getParam('value');
    component.set('v.loading', true);
    component.set('v.userOptions', []);
    component.set('v.selectedUserId', null);
    var inputAttrs = component.get('v.inputAttributes');
    component.set('v.recordId', inputAttrs.recordId);
    helper.fetchUsers(component, ambitId);
  },
  changeEntity: function(component, event, helper) {
    component.set('v.selectedUserId', null);
    component.set('v.userOptions', []);
  },
  finish: function(component, event, helper) {
    component.set('v.show', false);
    $A.get('e.force:refreshView').fire();
  },
  cancel: function(component, event, helper) {
    component.set('v.show', false);
    component.destroy();
  },
});