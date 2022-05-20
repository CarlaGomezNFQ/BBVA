({
  doInit: function(component, event, helper) {
    //get Case record Id
    var action = component.get('c.showButton');
    action.setParams({'caseId': component.get('v.recordId')});

    //configure action handler
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (state === 'SUCCESS') {
        console.log('entro al doInit');
        if (response.getReturnValue() === 'STE') {
          component.set('v.blnMasterCase', true);
        } else if (response.getReturnValue() === 'EGS') {
          component.set('v.blnMasterEGS', true);
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
  saveMasterCase: function(component, event, helper) {
    //get Case record Id
    var action = component.get('c.saveMasterCaseCtr');
    action.setParams({'caseId': component.get('v.recordId')});

    //configure action handler
    action.setCallback(this, function(response) {
      component.set('v.showPopUp', false);
      var state = response.getState();
      if (state === 'SUCCESS') {
        console.log('saveMasterCase ok');
        if (response.getReturnValue() ===  component.get('v.recordId')) {
          var staticLabelIf = $A.get('$Label.c.SER_Master_Case_Information_PopUp');
          $A.get('e.force:refreshView').fire();
          helper.getMSGResult(staticLabelIf, 'success', 'Success!');
        } else {
          component.set('v.caseMasterId', response.getReturnValue());
          var navEvt = $A.get('e.force:navigateToSObject');
          navEvt.setParams({
          'recordId': component.get('v.caseMasterId'),
          'slideDevName': 'related'
          });
          navEvt.fire();
          var staticLabel = $A.get('$Label.c.SER_Master_Case_Information_PopUp');
          helper.getMSGResult(staticLabel, 'success', 'Success!');
        }
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