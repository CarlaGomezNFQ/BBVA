({
  saveAllComplete: function(component, event, helper) {
    var saveEvt = $A.get('e.arce:Arc_Gen_RRTM_Wrapper_evt');
    saveEvt.setParams({
      'uniqueNameEvt': component.get('v.uniqueNameEvt')
    });
    saveEvt.fire();
  }
});