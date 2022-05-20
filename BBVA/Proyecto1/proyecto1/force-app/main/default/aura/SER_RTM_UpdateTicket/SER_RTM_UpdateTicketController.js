({
  onInit: function(component, event, helper) {
    var params = {'objId': component.get('v.id_CaseID')};
    var fnCallback = function(response) {
      console.log('respuesta');
      console.log(response.getReturnValue());
      var rtid = response.getReturnValue();
      var rspState = response.getState();
      if (rspState === 'SUCCESS') {
        component.set('v.id_RTID', rtid);
        helper.preloadDpt(component,event,helper) ;
        console.log('OK');
      } else {
        console.log('ERROR XXX');
      }
    };
    helper.callServer(component, event, 'c.getRecordTypeId', params, fnCallback, helper);
  }
});