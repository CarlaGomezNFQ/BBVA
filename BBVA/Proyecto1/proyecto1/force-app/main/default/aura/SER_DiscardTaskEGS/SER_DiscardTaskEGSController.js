({
  doInit: function(component, event, helper) {
    //get Case record Id
    var action = component.get('c.showButton');
    action.setParams({'taskId': component.get('v.recordId')});

    //configure action handler
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (state === 'SUCCESS') {
        console.log('entro al doInit');
        if (response.getReturnValue() === 'Completed') {
          component.set('v.blnDiscard', false);
        } else {
          component.set('v.blnDiscard', true);
        }
      } else {
        component.set('v.showPopUp', false);
        console.log('Problem getting, response state : ' + state);
        var errors = response.getError();
        if (errors[0] !== null && errors[0].message !== null && errors[0].message !== '') {
          console.log('Error message: ' + errors[0].message);
          helper.getMSGResult(errors[0].message, 'error', 'Error Message');
        }
      }
    });
    $A.enqueueAction(action);
  },
  openModal: function(component, event, helper) {
    component.set('v.showPopUp', true);
  },
  closeModel: function(component, event, helper) {
    component.set('v.showPopUp', false);
  },
  saveDiscard: function(component, event, helper) {
    //get Task record Id
    var action = component.get('c.saveDiscardCtr');
    action.setParams({'taskId': component.get('v.recordId')});

    //configure action handler
    action.setCallback(this, function(response) {
      component.set('v.showPopUp', false);
      var state = response.getState();
      if (state === 'SUCCESS') {
        if (response.getReturnValue().substring(0, 5) === 'ERROR') {
          helper.fn_ShowCustomError(helper, response);
        } else {
          console.log('saveDiscard ok');
          var staticLabelIf = $A.get('$Label.c.SER_Discard_Task_Information_PopUp');
          $A.get('e.force:refreshView').fire();
          helper.getMSGResult(staticLabelIf, 'success', 'Success!');
        }
      } else if (state === 'ERROR') {
        helper.fn_treatErrors(component, event, helper, response, 'ERROR: DiscardTaskEGS.saveDiscard', $A.get("{!$Label.c.SER_EGS_Discard_Error_Notification_Tittle}"));
      } else {
        console.log('Problem getting, response state : ' + state);
        var errors = response.getError();
        if (errors[0] !== null && errors[0].message !== null && errors[0].message !== '') {
          console.log('Error message: ' + errors[0].message);
          helper.getMSGResult(errors[0].message, 'error', 'Error Message');
        }
      }
    });
    $A.enqueueAction(action);
  }
});