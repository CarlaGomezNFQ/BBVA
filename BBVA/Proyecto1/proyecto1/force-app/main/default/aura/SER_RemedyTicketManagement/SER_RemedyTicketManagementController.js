({
  onInit: function(component, event, helper) {

    var params = { 'caseid': component.get('v.id_CaseID') };
    var fnCallback = function(response) {

      var rspState = response.getState();
      if (rspState === 'SUCCESS') {
        var attcase = response.getReturnValue();
        if (attcase) {
          component.set('v.case', attcase);
          console.log('SUCCESS');
        } else {
          console.log('ERROR - Null Case');
        }
      } else {
        console.log('ERROR  YYYY');
      }
    };

    var fnSetTabs = function(response) {
      var rspState = response.getState();
      if (rspState === 'SUCCESS') {
        var listOptions = response.getReturnValue();
        if (listOptions) {
          component.set('v.options', listOptions);
          console.log('SUCCESS');
        } else {
          console.log('ERROR - Null Case');
        }
      } else {
        console.log('ERROR  fnSetTabs');
        console.log(response.getError());
      }
    };
    helper.callServer(component, event, 'c.doInit', params, fnSetTabs, helper);
    helper.callServer(component, event, 'c.getCase', params, fnCallback, helper);
  },
  fn_handleActiveTab: function(component, event, helper) {
    console.log('Entro en fn_handleActiveTab');
    var tab = event.getSource();
    console.log('MOD');
    var option = event.getSource().get('v.id');
    console.log('OPTION -->');
    console.log(option);
    var tabbody = tab.get('v.body');
    console.log('BODY -->');
    console.log(tabbody);
    var llamadaAccion;
    switch (option) {
      case 'New Remedy':
        llamadaAccion = 'c:SER_RTM_NewTicket';
        break;

      case 'Send Comment':
        llamadaAccion = 'c:SER_RTM_SendComment';

        break;

      case 'Send Attachment':
        llamadaAccion = 'c:SER_RTM_SendAttachment';
        break;

      case 'Update Remedy':
        llamadaAccion = 'c:SER_RTM_UpdateTicket';
        break;

      case 'Claim Remedy':
        llamadaAccion = 'c:SER_RTM_ClaimTicket';
        break;

      case 'Close Remedy':
        llamadaAccion = 'c:SER_RTM_CloseTicket';
        break;
      case 'Reopen Remedy':
        llamadaAccion = 'c:SER_RTM_ReopenTicket';
        break;
    }
    if (llamadaAccion === 'c:SER_RTM_SendComment') {
      component.set('v.scc', true);
    }
    console.log(component.get('v.scc'));
    if (component.find(option)) {
      component.set('v.st_SelectedOption', option);
    } else {
      $A.createComponent(llamadaAccion, { 'aura:id': option, 'id_CaseID': component.get('v.id_CaseID') },
        function(cmp, status, emsg) {
          switch (status) {
            case 'SUCCESS':
              console.log('ok el cargar el body');
              tab.set('v.body', cmp);
              component.set('v.st_SelectedOption', option);
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
  fn_CloseModal: function(component, event, helper) {
    component.set('v.isOpen', false);
    var cev = component.getEvent('closemodal');
    cev.fire();
  },
  fn_SubmitForm: function(component, event, helper) {
  },
  fn_RemedySend: function(component, event, helper) {
    console.log('entro en fn_RemedySend');
    document.getElementById('send-button').disabled = true;
    var params;
    var caseid = component.get('v.id_CaseID');
    var userid = $A.get('$SObjectType.CurrentUser.Id');
    var option = component.get('v.st_SelectedOption');
    console.log('option -->' + option);
    console.log(component);
    var cmp = component.find(option);
    console.log('paso el cmp');
    console.log(cmp);
    var cmpComment = cmp.find(option);
    console.log('paso el cmpComment');
    var stComment = cmpComment.get('v.st_Comment');
    var sendLastCom = cmpComment.get('v.sendLastCom');
    var plPriority = '';
    var plDepartment = '';
    var stSolution = '';

    switch (option) {
      case 'Update Remedy':
      case 'Reopen Remedy':
      case 'New Remedy':
        plPriority = cmp.find('priority').get('v.value');
        plDepartment = cmp.find('department').get('v.value');
        params = {
          'caseId': caseid,
          'userId': userid,
          'priority': plPriority,
          'solution': stSolution,
          'operation': option,
          'remedyDepartment': plDepartment,
          'sendLastComment': sendLastCom,
          'newComment': stComment
        };
        break;
      case 'Send Comment':
        console.log('He entrado por sendcomment');
        params = {
          'caseId': caseid,
          'userId': userid,
          'priority': plPriority,
          'solution': stSolution,
          'operation': option,
          'remedyDepartment': plDepartment,
          'sendLastComment': sendLastCom,
          'newComment': stComment
        };
        break;
      case 'Claim Remedy':
      case 'Send Attachment':
        params = {
          'caseId': caseid,
          'userId': userid,
          'priority': plPriority,
          'solution': stSolution,
          'operation': option,
          'remedyDepartment': plDepartment,
          'sendLastComment': sendLastCom,
          'newComment': stComment
        };
        break;
      case 'Close Remedy':
        stSolution = cmp.find('solution').get('v.value');
        params = {
          'caseId': caseid,
          'userId': userid,
          'priority': '',
          'solution': stSolution,
          'operation': option,
          'remedyDepartment': '',
          'sendLastComment': sendLastCom,
          'newComment': stComment
        };
        break;
    }
    var fnCallbackDos = function(response) {
      console.log('Entro en el callback de la segunda llamada al servidor---->>>>' + response.getError()[0]);
      var rspState = response.getState();
      if (rspState === 'SUCCESS') {
        var msg = response.getReturnValue();
        if (msg.substring(0, 5) === 'ERROR') {
          component.set('v.toggleSpinner', false);
          document.getElementById('send-button').disabled = false;
          component.set('v.error', true);
          component.set('v.errormessage', msg.substring(5));
        } else {
          component.set('v.error', false);
          console.log(msg);
          component.set('v.isOpen', false);
          var cev2 = component.getEvent('closemodal');
          cev2.fire();
        }
      } else {
        console.log('ERROR');
        console.log(response.getError()[0]);
      }
    };
    var fnCallback = function(response) {
      console.log('Entro en el callback de la llamada al servidor---->>>>' + response.getError()[0]);
      var rspState = response.getState();
      if (rspState === 'SUCCESS') {
        var msg = response.getReturnValue();
        if (msg.substring(0, 5) === 'ERROR') {
          component.set('v.toggleSpinner', false);
          document.getElementById('send-button').disabled = false;
          component.set('v.error', true);
          component.set('v.errormessage', msg.substring(5));
        } else {
          component.set('v.error', false);
          console.log(msg);
          helper.callServer(component, event, 'c.secondCall', params, fnCallbackDos, helper);
          component.set('v.isOpen', false);
          var cev = component.getEvent('closemodal');
          cev.fire();
        }
      } else {
        console.log('Response');
        console.log(response);
        console.log('ERROR');
        console.log(response.getError());
      }
    };
    console.log('Llamo a la clase');
    console.log('Los parámetros son:');
    console.log(params);
    helper.callServer(component, event, 'c.submitTicket', params, fnCallback, helper);
  }
});