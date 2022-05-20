({
  onInit: function(component, event, helper) {
    console.log('entro en Init de Ticket Management');
    var params = { 'taskId': component.get('v.id_TaskID') };
    var fnCallback = function(response) {
      var rspState = response.getState();
      if (rspState === 'SUCCESS') {
        var attTask = response.getReturnValue();
        if (attTask) {
          component.set('v.task', attTask);
          console.log('SUCCESS');
        } else {
          console.log('ERROR - Null Task');
        }
      } else {
        console.log('ERROR  YYYY');
      }
    };

    var fnSetTabs = function(response) {
      console.log('entro fnSetTabs');
      var rspState = response.getState();
      if (rspState === 'SUCCESS') {
        var listOptions = response.getReturnValue();
        if (listOptions) {
          component.set('v.options', listOptions);
          console.log('SUCCESS');
          console.log('listOptions: ' + listOptions);
        } else {
          console.log('ERROR - Null Task');
        }
      } else {
        console.log('ERROR  tsk.fnSetTabs');
        console.log(response.getError());
      }
    };
    helper.callServer(component, event, 'c.doInit', params, fnSetTabs, helper);
    helper.callServer(component, event, 'c.getTask', params, fnCallback, helper);
  },

  fn_CloseModal: function(component, event, helper) {
    component.set('v.isOpen', false);
    var cev = component.getEvent('closemodal');
    cev.fire();
  },

  fn_handleActiveTab: function(component, event, helper) {
    console.log('Entro en task.fn_handleActiveTab');
    var tab = event.getSource();
    var option = event.getSource().get('v.id');
    console.log('OPTION -->');
    console.log(option);
    var tabbody = tab.get('v.body');
    console.log('BODY -->');
    console.log(tabbody);
    var llamadaAccion;
    llamadaAccion = helper.fillLlamadaAccion(option);
    if (component.find(option)) {
      component.set('v.st_SelectedOption', option);
    } else {
      $A.createComponent(llamadaAccion, { 'aura:id': option, 'id_TaskID': component.get('v.id_TaskID') },
        function(cmp, status, emsg) {
          switch (status) {
            case 'SUCCESS':
              tab.set('v.body', cmp);
              component.set('v.st_SelectedOption', option);
              console.log('ok el cargar el body');
              break;
            case 'INCOMPLETE':
              console.log('incomplete');
              break;
            case 'ERROR':
              console.log(emsg);
              break;
          }
        });
    }
  },

  fn_RemedySend: function(component, event, helper) {
    console.log('entro en task.fn_RemedySend');
    component.set('v.toggleSpinner', true);
    document.getElementById('send-button').disabled = true;
    var params;
    var taskid = component.get('v.id_TaskID');
    var userid = $A.get('$SObjectType.CurrentUser.Id');
    var option = component.get('v.st_SelectedOption');
    console.log('option -->' + option);
    console.log(component);
    var cmp = component.find(option);
    console.log('paso el cmp');
    console.log(cmp);
    var cmpComment = cmp.find(option);
    console.log('paso el cmpComment');
    console.log(cmpComment);
    var stComment = cmpComment.get('v.st_Comment');
    var sendLastCom = cmpComment.get('v.sendLastCom');
    var plPriority = '';
    var plDepartment = '';
    var stSolution = '';

    switch (option) {
      case 'Update Remedy':
      case 'Reopen Remedy':
      case 'New Remedy':
        plPriority = cmp.find('priorityId').get('v.value');
        plDepartment = cmp.find('departamentId').get('v.value');
        params = {
          'taskid': taskid,
          'userId': userid,
          'priority': plPriority,
          'solution': stSolution,
          'operation': option,
          'remedyDepartment': plDepartment,
          'sendLastComment': sendLastCom,
          'newComment': stComment,
          'isCloseBtn': false
        };
        break;
      case 'Send Comment':
        console.log('He entrado por sendcomment');
        params = {
          'taskid': taskid,
          'userId': userid,
          'priority': plPriority,
          'solution': stSolution,
          'operation': option,
          'remedyDepartment': plDepartment,
          'sendLastComment': sendLastCom,
          'newComment': stComment,
          'isCloseBtn': false
        };
        break;
      case 'Claim Remedy':
      case 'Send Attachment':
        params = {
          'taskid': taskid,
          'userId': userid,
          'priority': plPriority,
          'solution': stSolution,
          'operation': option,
          'remedyDepartment': plDepartment,
          'sendLastComment': sendLastCom,
          'newComment': stComment,
          'isCloseBtn': false
        };
        break;
      case 'Close Remedy':
        stSolution = cmp.find('solution').get('v.value');
        params = {
          'taskid': taskid,
          'userId': userid,
          'priority': '',
          'solution': stSolution,
          'operation': option,
          'remedyDepartment': '',
          'sendLastComment': sendLastCom,
          'newComment': stComment,
          'isCloseBtn': false
        };
        break;
    }
    var fnCallbackDos = function(response) {
      console.log('Entro en el callback de la segunda llamada al servidor---->>>>' + response.getError()[0]);
      var rspState = response.getState();
      if (rspState === 'SUCCESS') {
        var msg = response.getReturnValue();
        var msgAux = msg.substring(0, 5) === 'ERROR' && stComment !== undefined;
        if (msgAux) {
          document.getElementById('send-button').disabled = false;
          component.set('v.toggleSpinner', false);
          helper.saveLog(component, event, helper, 'ERROR: Remedy.fn_RemedySend.callback2', component.get('v.taskId'), $A.get('$SObjectType.CurrentUser.Id'), msg.substring(5));
          helper.showToast(msg.substring(5), 'error', helper);
        } else {
          component.set('v.error', false);
          console.log(msg);
          component.set('v.isOpen', false);
          var cev = component.getEvent('closemodal');
          cev.fire();
        }
      } else {
        console.log('ERROR');
        console.log(response.getError()[0]);
        component.set('v.toggleSpinner', false);
        helper.saveLog(component, event, helper, 'ERROR: RemedyComp.secondCall', taskid, $A.get('$SObjectType.CurrentUser.Id'), response.getError()[0].message, 'error');
        var cev2 = component.getEvent('closemodal');
        cev2.fire();
      }
    };
    var fnCallback = function(response) {
      console.log('Entro en el callback de la llamada al servidor---->>>>' + response.getError()[0]);
      var rspState = response.getState();
      if (rspState === 'SUCCESS') {
        var msg = response.getReturnValue();
        if (msg.substring(0, 5) === 'ERROR') {
          component.set('v.toggleSpinner', false);
          helper.saveLog(component, event, helper, 'ERROR: Remedy.fn_RemedySend.callback', component.get('v.taskId'), $A.get('$SObjectType.CurrentUser.Id'), msg.substring(5));
          helper.showToast(msg.substring(5), 'error', helper);
          document.getElementById('send-button').disabled = false;
        } else {
          component.set('v.error', false);
          console.log(msg);
          var aux = component.get('v.st_SelectedOption') === 'New Remedy' || component.get('v.st_SelectedOption') === 'Update Remedy';
          if (aux) {
            helper.callServer(component, event, 'c.secondCall', params, fnCallbackDos, helper);
          } else {
            component.set('v.isOpen', false);
            var cev = component.getEvent('closemodal');
            cev.fire();
          }
        }
      } else {
        console.log('Response');
        console.log(response);
        console.log('ERROR');
        console.log(response.getError());
        component.set('v.toggleSpinner', false);
        helper.saveLog(component, event, helper, 'ERROR: RemedyComp.createRemedy', taskid, $A.get('$SObjectType.CurrentUser.Id'), response.getError()[0].message, 'error');
        helper.showToastError($A.get('$Label.c.SER_EGS_NotCreateRemedy_lbl'), 'error');
        var cev2 = component.getEvent('closemodal');
        cev2.fire();
      }
    };
    console.log('Llamo a la clase');
    console.log('Los parámetros son:');
    console.log(params);
    helper.callServer(component, event, 'c.submitTicket', params, fnCallback, helper);
  }
});