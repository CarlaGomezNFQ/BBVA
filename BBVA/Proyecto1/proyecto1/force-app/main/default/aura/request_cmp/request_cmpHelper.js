({
  initialize: function(component, event, helper) {
    var profSheetId = component.get('v.profitabilitySheetId');
    var typology = component.get('v.typology');

    // Get detail content
    var action = component.get('c.requestData');
    action.setParams({
      'profSheetId': profSheetId,
      'typology': typology
    });
    action.setCallback(this, function(response) {
      var state = response.getState();
      let appEvent = $A.get('e.cuco:request_creation_evt');
      if (component.isValid() && state === 'SUCCESS') {
        //store in ret profitability sheet information
        var ret = response.getReturnValue();
        if (ret.success === true) {
          appEvent.setParams({
            'success': true,
            'profitabilityAnalysisId': ret.profAId
          });
          appEvent.fire();
        } else {
          appEvent.setParams({
            'success': false,
            'errorMessage': ret.errMessage
          });
          appEvent.fire();
        }
      } else if (response.getState() === 'ERROR') {
        appEvent.setParams({
          'success': false,
          'errorMessage': response.getError()[0].message
        });
        appEvent.fire();
      }
    });
    $A.enqueueAction(action);
  }
});