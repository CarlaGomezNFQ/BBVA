({
  doInit: function(component, event, helper) {
    component.set('v.bl_DisplayGroup', false);
    component.set('v.bl_DisplayClient', false);
    component.set('v.bl_DisplayLocalClient', true);
    component.set('v.bl_DisplayLocalReference', false);
    component.set('v.selectedObject', 'LocalClient');
    component.set('v.selectedRecord', '');
  },

  fn_onChange: function(component, event, helper) {
    helper.fn_onChangeHelper(component, event, helper);
  },

  fn_creteLookup: function(component, event, helper) {
    component.find('send-button').disabled = true;
    $A.util.removeClass(component.find('Spinner'), 'slds-hide');
    var params = {'caseId': component.get('v.recordId'),
                  'lookupId': component.get('v.selectedRecord').value,
                  'objectType': component.find('BEIId').get('v.value')
    };
    var fnCallback = function(response) {
      $A.util.addClass(component.find('Spinner'), 'slds-hide');
      var rspState = response.getState();
      if (rspState === 'SUCCESS') {
        var msg = response.getReturnValue();
        var msgAux = msg.substring(0, 5) === 'ERROR';
        if (msgAux) {
          component.find('send-button').disabled = false;
          helper.showToastError(msg.substring(5), 'error');
        }
      } else if (rspState === 'ERROR') {
        var errors = response.getError();
        if (errors) {
          if (errors[0] && errors[0].message) {
            helper.showToastError(errors[0].message, 'error');
          }
        } else {
          helper.showToastError($A.get('$Label.c.SER_EGS_ContactAdmin_lbl'), 'error');
        }
      } else {
        helper.showToastError($A.get('$Label.c.SER_EGS_ContactAdmin_lbl'), 'error');
      }
      component.find('BEIId').set('v.value', 'Client');
      helper.fn_onChangeHelper(component, event, helper);
      var object = component.find('BEIId').get('v.value');
      component.find(object).set('v.searchString', '');
      $A.get('e.force:refreshView').fire();
    };
    helper.callServer(component, event, 'c.createLookUp', params, fnCallback, helper);
  },
});