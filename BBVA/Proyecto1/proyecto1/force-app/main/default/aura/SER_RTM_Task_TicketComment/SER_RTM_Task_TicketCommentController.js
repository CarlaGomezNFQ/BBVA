({
  doInit: function(component, event, helper) {
    var action = component.get('c.getCommentario');
    action.setParams({'taskId': component.get('v.id_TaskID')});
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (state === 'SUCCESS') {
        console.log('SUCCESS');
        if (response.getReturnValue()[0] !== undefined) {
          component.set('v.st_Comment', response.getReturnValue()[0].gf_task_comment_body_desc__c);
          component.set('v.sendLastCom', true);
        } else {
          component.set('v.renderSendLastCom', false);
          var textArea = component.find('ta');
          console.log(textArea);
          textArea.set('v.disabled', false);
        }
      } else if (state === 'ERROR') {
        var errors = response.getError();
        if (errors) {
          if (errors[0] && errors[0].message) {
            console.log('Error message: ' + errors[0].message);
          }
        } else {
          console.log('Unknown error');
        }
      } else {
        console.log('Failed with state ' + state);
      }
    });
    console.log('Comment : ' + component.get('v.st_Comment'));
    $A.enqueueAction(action);
  },

  fn_ToggleSendLastComment: function(component, event, helper) {
    var checkCmp = component.find('checkbox');
    var valueCheck = checkCmp.get('v.value');
    var textArea = component.find('ta');
    console.log(textArea);
    if (valueCheck === false) {
      textArea.set('v.disabled', false);
      textArea.set('v.value', '');
      component.set('v.sendLastCom', false);
      component.set('v.st_Comment', '');
    } else {
      textArea.set('v.disabled', true);
      var action2 = component.get('c.getCommentario');
      action2.setParams({'taskId': component.get('v.id_TaskID')});
      action2.setCallback(this, function(response) {
        var state = response.getState();
        if (state === 'SUCCESS') {
          console.log('SUCCESS');
          if (response.getReturnValue()[0] !== undefined) {
            component.set('v.st_Comment', response.getReturnValue()[0].gf_task_comment_body_desc__c);
            component.set('v.sendLastCom', true);
            console.log('Last Comment: ' + component.get('v.st_Comment'));
          } else {
            component.set('v.renderSendLastCom', false);
            textArea.set('v.disabled', false);
          }
        } else if (state === 'ERROR') {
          var errors = response.getError();
          if (errors) {
            if (errors[0] && errors[0].message) {
              console.log('Error message: ' + errors[0].message);
            }
          } else {
            console.log('Unknown error');
          }
        } else {
          console.log('Failed with state ' + state);
        }
      });
      $A.enqueueAction(action2);
    }
  },
});