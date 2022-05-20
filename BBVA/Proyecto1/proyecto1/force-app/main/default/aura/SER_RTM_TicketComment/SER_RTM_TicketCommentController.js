({
  doInit: function(component, event, helper) {
    var action = component.get('c.getCommentario');
    action.setParams({'caseId': component.get('v.id_CaseID')});
    action.setCallback(this, function(a) {
      var state = a.getState();
      if (state === 'SUCCESS') {
        console.log('AQA - Id del caso: ' + a.getReturnValue()[0]);
        if (a.getReturnValue()[0] !== undefined) {
          component.set('v.st_Comment', a.getReturnValue()[0].CommentBody);
          component.set('v.sendLastCom', true);
        } else {
          component.set('v.renderSendLastCom', false);
          var textArea = component.find('ta');
          console.log(textArea);
          textArea.set('v.disabled', false);
        }
      }
    });
    console.log('Arnausito : ' + component.get('v.st_Comment'));
    $A.enqueueAction(action);
  },

  fn_ToggleSendLastComment: function(component, event, helper) {
    var action2 = component.get('c.getCommentario');
    action2.setParams({'caseId': component.get('v.id_CaseID')});
    var checkCmp = component.find('checkbox');
    var valueCheck = checkCmp.get('v.value');
    if (valueCheck === false) {
      var textArea = component.find('ta');
      console.log(textArea);
      textArea.set('v.disabled', false);
      component.set('v.sendLastCom', false);
    } else {
      var textArea2 = component.find('ta');
      console.log(textArea2);
      textArea2.set('v.disabled', true);
      var action3 = component.get('c.getCommentario');
      action3.setParams({
        'caseId': component.get('v.id_CaseID')
      });
      action3.setCallback(this, function(a) {
        var state = a.getState();
        if (state === 'SUCCESS') {
          console.log('AQA - Id del caso: ' + a.getReturnValue()[0]);
          if (a.getReturnValue()[0] !== undefined) {
            component.set('v.st_Comment', a.getReturnValue()[0].CommentBody);
            component.set('v.sendLastCom', true);
            console.log('Arnausito : ' + component.get('v.st_Comment'));
          }
        }
      });
      $A.enqueueAction(action2);
    }
  }
});