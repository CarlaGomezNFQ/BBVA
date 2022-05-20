/* eslint-disable no-unused-expressions */
({
  doInit: function(component, event, helper) {
    helper.checkTitle(component, event, helper);
  },
  handleFormCancel: function(component, event, helper) {
    let cancelEvent = component.getEvent('dynamicFlowWizardCancel');
    cancelEvent.fire();
  },
  handleFormCommentsChange: function(component, event, helper) {
    let commentsValue = component.find('comments').get('v.value');
    component.set('v.comments', commentsValue);
  },
  checkValidity: function(component, event, helper) {
    let typology = component.get('v.typology');
    let profAnalysisStatus = component.get('v.profAnalysisStatus');
    if (typology === 'Cancellation' || profAnalysisStatus === 'Pending Send for Manual Formalization') {
      helper.saveContinue(component, event, helper);
    } else {
      let hasPrice = component.get('v.isActivePrice');
      let startDate = new Date(component.get('v.startDate'));
      let endDateSelected = component.get('v.endDate');
      helper.managePrice(component, event, helper, hasPrice, startDate, endDateSelected);
    }
  },
  handleChangeDateFormalize: function(component, event, helper) {
    helper.handleChangeDateFormalize(component, event, helper);
  }
});