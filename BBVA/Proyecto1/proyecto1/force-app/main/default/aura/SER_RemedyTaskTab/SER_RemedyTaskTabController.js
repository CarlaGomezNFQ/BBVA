({
  doInit: function(component, event, helper) {
    helper.doInitHelper(component, event, helper, false);
  },

  handleClick: function(component, event, helper) {
    console.log('entro en handleclick de Remedy Tab Controller');
    console.log(component.get('v.bl_DisplayModal'));
    component.set('v.bl_DisplayModal', true);
  },

  fn_CloseModal: function(component, event, helper) {
    component.set('v.bl_DisplayModal', false);
    helper.doInitHelper(component, event, helper, true);
  }
});