({
  fn_onChangeHelper: function(component, event, helper) {
    //Recuperamos el valor de la picklist y según lo que haya elegido el usuario le damos visivilidad a un campo lookup sobre el objeto elegido.
    var selectedValue = component.find('BEIId').get('v.value');
    component.set('v.selectedRecord', '');
    if (selectedValue === 'Client') {
      component.set('v.bl_DisplayGroup', false);
      component.set('v.bl_DisplayClient', true);
      component.set('v.bl_DisplayLocalClient', false);
      component.set('v.bl_DisplayLocalReference', false);
    } else if (selectedValue === 'LocalClient') {
      component.set('v.bl_DisplayGroup', false);
      component.set('v.bl_DisplayClient', false);
      component.set('v.bl_DisplayLocalClient', true);
      component.set('v.bl_DisplayLocalReference', false);
    } else if (selectedValue === 'LocalReference') {
      component.set('v.bl_DisplayGroup', false);
      component.set('v.bl_DisplayClient', false);
      component.set('v.bl_DisplayLocalClient', false);
      component.set('v.bl_DisplayLocalReference', true);
    } else if (selectedValue === 'Group') {
      component.set('v.bl_DisplayGroup', true);
      component.set('v.bl_DisplayClient', false);
      component.set('v.bl_DisplayLocalClient', false);
      component.set('v.bl_DisplayLocalReference', false);
    }
  },
});