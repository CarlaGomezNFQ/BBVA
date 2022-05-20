({
  onInit: function(component, event, helper) {
    var params = {'taskId': component.get('v.id_TaskID'),
      'bnlActionLine': false};
    var fnCallback = function(response) {
      var rspState = response.getState();
      if (rspState === 'SUCCESS') {
        var noneOption = new Object();
        noneOption.label = '--None--';
        var optionsP = response.getReturnValue().priorityOpts;
        var priorityOptions = new Array();
        priorityOptions.push(noneOption);
        var x;
        for (x = 0; x < optionsP.length; x++) {
          var option = new Object();
          option.id = optionsP[x];
          option.label = optionsP[x];
          if (optionsP[x] === response.getReturnValue().priority) {
            option.selected = true;
            component.set('v.selectedPriority', optionsP[x]);
          }
          priorityOptions.push(option);
        }
        component.set('v.priorityOptions', priorityOptions);

        var optionsD = response.getReturnValue().departamentOpts;
        var departamentOptions = new Array();
        departamentOptions.push(noneOption);
        var y;
        for (y = 0; y < optionsD.length; y++) {
          var option2 = new Object();
          option2.id = optionsD[y];
          option2.label = optionsD[y];
          if (optionsD[y] === response.getReturnValue().departament) {
            option2.selected = true;
            component.set('v.selecteddepartament', optionsD[y]);
          }
          departamentOptions.push(option2);
        }
        component.set('v.departamentOptions', departamentOptions);
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