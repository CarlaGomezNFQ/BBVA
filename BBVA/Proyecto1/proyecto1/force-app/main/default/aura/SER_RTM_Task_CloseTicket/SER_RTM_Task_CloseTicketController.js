({
  onInit: function(component, event, helper) {
    var params = {'taskId': component.get('v.id_TaskID')};
    var fnCallback = function(response) {
      console.log('respuesta');
      console.log(response.getReturnValue());
      var rspState = response.getState();
      if (rspState === 'SUCCESS') {
        component.set('v.st_Solution', response.getReturnValue().TaskComment__r.gf_action_result_desc__c);
        console.log('OK');
      } else if (rspState === 'ERROR') {
        helper.trateErrors(response);
      } else {
        console.log('Failed with state ' + rspState);
      }
    };
    helper.callServer(component, event, 'c.getTask', params, fnCallback, helper);
  },
});