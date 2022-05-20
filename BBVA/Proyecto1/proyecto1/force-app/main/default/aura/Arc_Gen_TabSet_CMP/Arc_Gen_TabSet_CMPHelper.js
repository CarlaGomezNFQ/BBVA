({
  loadTabsetConfig: function(component, event, helper) {
    let promise = helper.getTemplate(component);
    component.set('v.tabsetDisabled', true);
    promise.then(
      function(resolve1) {
        helper.policieTabStatus(component, event, helper, resolve1);
        let promise2 = helper.getAccHasAnalysis(component, event, helper);
        promise2.then(
          function(resolve2) {
            var accHasAnalysis = component.get('v.accHasAnalysis');
            if (accHasAnalysis.arce__group_asset_header_type__c === '1') {
              helper.updateGroupFields(component, event, helper);
            }
            component.set('v.tabSetConfigured', true);
          }
        ).catch(
          function(error) {
            console.log(error);
            helper.showErrorToast(error);
          }
        );
      }
    ).catch(
      function(error) {
        console.log(error);
        helper.showErrorToast(error);
      }
    );
  },
  getTemplate: function(component, event, helper) {
    return new Promise(function(resolve, reject) {
      var action = component.get('c.getTabsJson');
      action.setParams({
        recordId: component.get('v.idSelect')
      });
      action.setCallback(this, function(response) {
        component.set('v.view', true);
        var state = response.getState();
        if (component.isValid() && state === 'SUCCESS') {
          var resp = JSON.parse(response.getReturnValue());
          if (resp.gblResultResponse) {
            var statusButtons = (resp.gblPermissionEdit === 'true') ? 'Show' : 'Hide';
            var statusButtonsForQVCD = (resp.gblPermissionEdit === 'true') ? true : false;
            var appEvent = $A.get('e.c:Arc_Gen_QVCDEvent');
            appEvent.setParams({
              'permission': statusButtonsForQVCD
            });
            appEvent.fire();
            component.set('v.sectionsLts', resp.lstNamesTemplates);
            component.set('v.selectedTab', resp.lstNamesTemplates[0].nameTemplate);
            component.set(
              'v.dynaAtt',
              '{"lightningEdit":"' +
                resp.gblPermissionEdit +
                '", "cWrappButtons":"' +
                statusButtons +
                '", "columnReduction":"' +
                resp.columnReduction +
                '"}'
            );
            var edit = '{"style":"brand","unactiveStyle":"hidden","active":' + resp.gblPermissionEdit + '}';
            component.set('v.permissionEdit', edit);
            component.set('v.warningMessage', resp.warningMessage);
            var jsonResp = resp.lstNamesTemplates;
            resolve(jsonResp);
          } else {
            reject($A.get('{!$Label.c.Arc_Gen_UnknownError}') + ': ' + resp.gblDescriptionResponse);
          }
        } else {
          reject($A.get('{!$Label.c.Arc_Gen_UnknownError}') + ': ' + JSON.stringify(response.error));
        }
      });
      $A.enqueueAction(action);
    });
  },
  policieTabStatus: function(component, event, helper, jsonResp) {
    var statusPolicies = false;
    for (var i in jsonResp) {
      if (jsonResp[i].devTemplate === '500' && jsonResp[i].isVisible === true) {
        statusPolicies = true;
      }
    }
    var compEvent = $A.get('e.c:Arc_Gen_TabSetEvent');
    compEvent.setParams({
      'policies': statusPolicies
    });
    compEvent.fire();
  },
  callClassCompletitud: function(component, event) {
    return new Promise(function(resolve, reject) {
      var action = component.get('c.callTemplateAnalysisJson');
      let recordId = event.getParam('recordId');
      action.setParams({
        'recordId': recordId
      });
      action.setCallback(this, function(response) {
        if (component.isValid() && response.getState() === 'SUCCESS'  && Object.keys(response.getReturnValue()).length !== 0) {
          var resp = response.getReturnValue();
          var jsonParse = JSON.parse(resp.gblDescriptionResponse);
          component.set('v.jsonResponse', jsonParse);
          component.set('v.changeArceState', resp.changeStatus);
          component.set('v.unitMessage', resp.unitChangeResponse);
          resolve('Resolved');
        } else {
          reject('Rejected');
        }
      });
      $A.enqueueAction(action);
    });
  },
  calculatePercentage: function(component, event, helper) {
    return new Promise(function(resolve, reject) {
      var jsonParse = component.get('v.jsonResponse');
      var lista = component.get('v.sectionsLts');
      var indexAux = [];
      var aux;
      for (var i in lista) {
        if (lista[i] !== undefined) {
          lista[i].percent = jsonParse[i].percent;
          if (lista[i].isVisible !== jsonParse[i].isVisible) {
            aux = i;
            lista[i].isVisible = jsonParse[i].isVisible;
          }
          if (i > aux) {
            indexAux.push(lista[i].isVisible);
            lista[i].isVisible = false;
          }
        }
      }
      component.set('v.lstIndexAux', indexAux);
      component.set('v.sectionsLts', lista);
      component.set('v.indexAux', aux);
      resolve('Resolved');
    });
  },
  restorePercentage: function(component, event, helper) {
    return new Promise(function(resolve, reject) {
      var aux = component.get('v.indexAux');
      var indexAux = component.get('v.lstIndexAux');
      var lista = component.get('v.sectionsLts');
      var contador = 0;
      for (var j in lista) {
        if (aux && j > aux) {
          lista[j].isVisible = indexAux[contador];
          contador++;
        }
      }
      resolve(lista);
    });
  },
  showToast: function(component, event, message) {
    var toastEvent = $A.get('e.force:showToast');
    toastEvent.setParams({
      'type': 'SUCCESS',
      'title': $A.get('{!$Label.c.Lc_arce_newAnalysisSuccess}'),
      'message': message
    });
    toastEvent.fire();
  },
  showErrorToast: function(message) {
    var toastError = $A.get('e.force:showToast');
    toastError.setParams({
      'title': 'Error!',
      'type': 'error',
      'mode': 'sticky',
      'duration': '8000',
      'message': message
    });
    toastError.fire();
  },
  updateGroupFields: function(component, event, helper) {
    var action = component.get('c.updateGroupFields');
    let accHasAn = component.get('v.accHasAnalysis');
    action.setParams({
      'accHasAn': accHasAn
    });
    action.setCallback(this, function(response) {
      if (response.getState() === 'ERROR') {
        helper.showErrorToast(response.getError());
      }
    });
    $A.enqueueAction(action);
  },
  getAccHasAnalysis: function(component, event, helper) {
    return new Promise(function(resolve, reject) {
      var action = component.get('c.getAccHasAnalysis');
      let recordId = component.get('v.idSelect');
      action.setParams({
        'accHasAnId': recordId
      });
      action.setCallback(this, function(response) {
        if (response.getState() === 'SUCCESS') {
          var resp = response.getReturnValue();
          component.set('v.accHasAnalysis', resp);
          resolve();
        } else {
          reject(response.getError());
        }
      });
      $A.enqueueAction(action);
    });
  }
});