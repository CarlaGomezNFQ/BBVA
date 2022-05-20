({
  onInit: function(component, event, helper) {
    var params = {'taskId': component.get('v.id_TaskID'),
      'bnlActionLine': false};
    var fnCallback = function(response) {
      var rspState = response.getState();
      if (rspState === 'SUCCESS') {
        var noneOption = new Object();
        noneOption.label = '--None--';
        helper.fillPriorityOptions(component, response, noneOption);
        helper.fillDepartmentOptions(component, response, noneOption);
        console.log('OK');
      } else if (rspState === 'ERROR') {
        helper.trateErrors(response);
      } else {
        console.log('Failed with state ' + rspState);
      }
    };
    helper.callServer(component, event, 'c.doInitOptions', params, fnCallback, helper);
  }
});