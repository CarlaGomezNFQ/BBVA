({
  doInit: function(component, event, helper) {
    let model = component.get('v.modelSelctd');
    helper.setChart(component, event, helper, 'geographiesChart' + model);
    helper.setChart(component, event, helper, 'subActivityChart' + model);
  },
  actionSave: function(component, event, helper) {
    let message;
    let typology;
    component.find('aHaRecordData').saveRecord($A.getCallback(function(saveResult) {
      if (saveResult.state === 'SUCCESS' || saveResult.state === 'DRAFT') {
        message = 'The record has been saved successfully.';
        typology = 'Success';
      } else if (saveResult.state === 'INCOMPLETE') {
        message = 'User is offline, device doesn\'t support drafts.';
        typology = 'Error';
      } else if (saveResult.state === 'ERROR') {
        message = 'Problem saving record, error: ' + JSON.stringify(saveResult.error);
        typology = 'Error';
      } else {
        message = 'Unknown problem, state: ' + saveResult.state + ', error: ' + JSON.stringify(saveResult.error);
        typology = 'Error';
      }
      helper.fireToast(typology, message);
    }));
  }
});