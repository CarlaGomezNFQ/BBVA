({
  getRecordTypeId: function(response) {
    console.log(response);
    return response;
  },
  preloadDpt : function (component,event,helper) {
      console.log('preload');
      console.log(component.get('v.id_CaseID'));
      var action = component.get('c.getCase');
      var params = {'caseid': component.get('v.id_CaseID')};
      action.setParams(params);
        action.setCallback(this,function(response) {
            var caso = response.getReturnValue();
            var rspState = response.getState();
            if (rspState === 'SUCCESS') {
                if(caso.Status === 'Remedy - Escalated'){
                    component.set('v.defaultDepartment', 'Mantener equipo resolutor');
                }
                console.log('OK');
            } else {
                console.log('ERROR XXX');
            }
        });
        $A.enqueueAction(action);
   }
});