({
  init: function(component, event, helper) {
    helper.createCarousel(component, event, helper);
  },
  handleRecordChanged: function(component, event, helper) {
    const changeType = event.getParams().changeType;
    if (changeType === 'LOADED') {
      helper.createDinForm(component, event, helper);
    }
  },
  getItemEvent: function(component, event, helper) {
    const nmEvent = event.getParam('nameEvent');
    const nmCards = component.get('v.nameCards');
    if (nmEvent === 'Arc_Gen_Carousel' || nmEvent === nmCards) {
      component.set('v.childId', event.getParam('IdItem'));
      component.find('recordLoader').reloadRecord();
    }
  },
  handleSaveEvent: function(component, event, helper) {
    helper.createCarousel(component, event, helper);
  },
  saveAllComplete: function(component, event, helper) {
    let model = component.get('v.modelSelctd');
    const uniqueName = component.get('v.uniqueName');
    if (uniqueName === 'Main_clients' || uniqueName === 'Main_clients2012') {
      helper.createCarousel(component, event, helper);
      helper.setChart(component, event, helper, 'subActivityChart' + model);
      helper.setChart(component, event, helper, 'geographiesChart' + model);
      helper.callMultitemplate(component, event, helper, model);
    } else if (event.getParam('uniqueNameEvt') === 'Geographic_Splits') {
      helper.setChart(component, event, helper, 'geographiesChart' + model);
    }
  },
});