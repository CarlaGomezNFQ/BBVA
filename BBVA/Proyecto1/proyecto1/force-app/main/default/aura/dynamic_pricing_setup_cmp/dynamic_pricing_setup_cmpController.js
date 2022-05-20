/* eslint-disable no-unused-expressions */
({
  doInit: function(component, event, helper) {
    helper.doInit(component, event, helper);
  },
  handleCancel: function(component, event, helper) {
    // Refresh flat evt
    let appEvent = $A.get('e.cuco:refresh_flat_rates_evt');
    appEvent.setParams({
      'contextId': component.get('v.flatRate').cuco__gf_profitablity_analysis_id__c
    });
    appEvent.fire();

    // Refresh condition  evt
    let appEventDynamicCRefreshConditions = $A.get('e.cuco:refresh_conditions_evt');
    appEventDynamicCRefreshConditions.setParams({
      'contextId': component.get('v.flatRate').cuco__gf_profitablity_analysis_id__c
    });
    appEventDynamicCRefreshConditions.fire();
    component.destroy();
  },
  toggle: function(component, event, helper) {
    var items = component.get('v.mapNonCross');
    var index = event.getSource().get('v.value');
    items[index].expanded = !items[index].expanded;
    component.set('v.mapNonCross', items);
  },
  handleContinue: function(component, event, helper) {
    helper.saveContinue(component, event, helper);
  }
});