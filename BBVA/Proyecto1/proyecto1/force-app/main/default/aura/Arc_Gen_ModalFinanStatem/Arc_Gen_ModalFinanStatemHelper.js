({
  fetchFinancialStatements: function(component, event, helper) {
    var action = component.get('c.fetchFinancialStatements');
    action.setParams({
      varRecord: component.get('v.accHasAnalysisId'),
      isFinancialRAIP: component.get('v.isFinancialRAIP')
    });
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (state === 'SUCCESS') {
        var responseWrapper = response.getReturnValue();
        if (component.get('v.isFinancialRAIP')) {
          helper.setPreselected(component, event, helper, responseWrapper);
        }
        var ffssListLabel = helper.removeZeroFFSSId(responseWrapper.ffssListLabel);
        component.set('v.acctList', ffssListLabel);
        component.set('v.ffssList', responseWrapper.ffssList);
        component.set('v.validLabel', responseWrapper.validLabel);
      } else if (state === 'ERROR') {
        var errors = response.getError();
        var errorMsg = (errors[0] && errors[0].message) ? errors[0].message : $A.get('{!$Label.c.Cls_arce_GRP_servError}');
        component.set('v.ffssErrorMsg', errorMsg);
      }
      component.set('v.spinnerLoading', false);
    });
    $A.enqueueAction(action);
  },
  setColumns: function(component) {
    component.set('v.mycolumns', [{
      label: $A.get('{!$Label.c.Lc_arce_Date}'),
      fieldName: 'arce__financial_statement_end_date__c',
      type: 'text'
    },
    {
      label: $A.get('{!$Label.c.Lc_arce_Period}'),
      fieldName: 'arce__economic_month_info_number__c',
      type: 'text'
    },
    {
      label: $A.get('{!$Label.c.Lc_arce_Certification}'),
      fieldName: 'arce__ffss_certification_type__c',
      type: 'text'
    },
    {
      label: $A.get('{!$Label.c.Lc_arce_Type}'),
      fieldName: 'arce__ffss_submitted_type__c',
      type: 'text'
    },
    {
      label: $A.get('{!$Label.c.Lc_arce_ValidForRating}'),
      fieldName: 'arce__ffss_valid_type__c',
      type: 'text'
    },
    {
      label: $A.get('{!$Label.c.Lc_arce_AdjustedType}'),
      fieldName: 'arce__ffss_adjusted_type__c',
      type: 'text'
    },
    {
      label: 'Id',
      fieldName: 'shortId',
      type: 'text'
    }
    ]);
  },
  consultEngine: function(component, event, helper) {
    return new Promise(function(resolve, reject) {
      var listIDS = component.get('v.selectedRows2');
      var msg = '';
      var errorMsg = '';
      component.set('v.msgTable', msg);
      component.set('v.errorMsgTable', errorMsg);
      component.set('v.spinnerLoading', true);

      var action = component.get('c.callEngineFinancialState');
      action.setParams({
        recordId: component.get('v.accHasAnalysisId'),
        financialIdList: listIDS,
        isRAIP: component.get('v.isRAIP'),
        isFinancialRAIP: component.get('v.isFinancialRAIP')
      });

      if (listIDS.length === 0) {
        component.set('v.msgTable', 'no');
        component.set('v.errorMsgTable', $A.get('{!$Label.c.Arc_Gen_NotEEFF}'));
        component.set('v.btnStmIsDisabled', false);
        resolve();
      } else {
        action.setCallback(this, function(response) {
          var state = response.getState();
          if (state === 'SUCCESS') {
            var resp = response.getReturnValue();
            if (resp.ratiosStatus === 'Success') {
              msg = 'si';
              component.set('v.ffssValid', resp.ratingValidFFSS);
              component.set('v.fsServiceId', resp.fsServiceId);
              helper.checkValidFFSS(component, resp);
              resolve();
            } else {
              msg = 'no';
              errorMsg = resp.ratiosStatus;
              reject();
            }
          } else {
            msg = 'no';
            errorMsg = response.getError()[0].message;
            reject();
          }
          component.set('v.msgTable', msg);
          component.set('v.errorMsgTable', errorMsg);
          component.set('v.btnStmIsDisabled', false);
        });
      }
      $A.enqueueAction(action);
    });
  },
  checkValidFFSS: function(component, resp) {
    if (resp.ratingValidFFSS === 'yes') {
      var ffssValidId = resp.ratingValidatedFS;
      component.set('v.ffssValidId', ffssValidId);
    }
  },
  consultFSdetails: function(component, event, helper) {
    var action = component.get('c.consultFSdetails');
    action.setParams({
      recordId: component.get('v.accHasAnalysisId'),
      fsServiceId: component.get('v.fsServiceId')
    });
    action.setCallback(this, function(response) {
      if (response.getState() === 'SUCCESS') {
        let resp = response.getReturnValue();
        helper.controlErrors(component, helper, event, resp);
        helper.refreshComponent(component);
      } else {
        var errors = response.getError();
        var errorMsg = (errors[0] && errors[0].message) ? errors[0].message : $A.get('{!$Label.c.Cls_arce_GRP_servError}');
        helper.toastMessage(component, event, 'ERROR', 'Error: ' + errorMsg);
      }
    });
    $A.enqueueAction(action);
  },
  controlErrors: function(component, helper, event, resp) {
    if (resp.gblSuccessOperation === false) {
      helper.toastMessage(component, event, 'ERROR', 'Error: ' + resp.gblResulError);
    } else if (resp.gblSuccessOperation === true && resp.gblRespServiceCode !== 200 && component.get('v.msgTable') === 'si' && component.get('v.ffssValid') === 'yes') {
      helper.toastMessage(component, event, 'ERROR', 'Error: ' + resp.gblRespServiceCode);
    }
  },
  toastMessage: function(component, event, type, message) {
    var toastMess = $A.get('e.force:showToast');
    toastMess.setParams({
      'title': '',
      'type': type,
      'mode': 'sticky',
      'duration': '8000',
      'message': message
    });
    toastMess.fire();
  },
  refreshComponent: function(component) {
    if (component.get('v.isRAIP') === false) {
      var tabRefresh = $A.get('e.dyfr:SaveObject_evt');
      tabRefresh.setParams({
        recordId: component.get('v.accHasAnalysisId')
      });
      tabRefresh.fire();
    }
  },
  evtSelectionFFSS: function(component, selectedRows) {
    var validLabel = component.get('v.validLabel');
    var cmpEvent = component.getEvent('ffssSelectionEvent');
    cmpEvent.setParams({
      'isValidFfss': selectedRows[0].arce__ffss_valid_type__c === validLabel
    });
    cmpEvent.fire();
  },
  evtUpdateBalances: function(component) {
    var cmpEventTrue = component.getEvent('updateBlances');
    cmpEventTrue.setParams({
      'updatedRatios': 'true'
    });
    cmpEventTrue.fire();
  },
  isPreselected: function(component, selectedRows) {
    var preselectedFFSS = new Set(component.get('v.preSelectedRows'));
    var isPreselected = true;
    selectedRows.forEach(function(elem) {
      if (preselectedFFSS.size === 0 || preselectedFFSS.has(elem.arce__financial_statement_id__c)) {
        isPreselected = false;
      }
    });
    return isPreselected;
  },
  setPreselected: function(component, event, helper, responseWrapper) {
    var preSelectedRows = [];
    var preselectedFFSS = new Set(responseWrapper.preselected);

    responseWrapper.ffssListLabel.forEach(function(elem) {
      if (preselectedFFSS.has(elem.arce__financial_statement_id__c)) {
        preSelectedRows.push(elem.arce__financial_statement_id__c);
        component.set('v.btnStmIsDisabled', false);
      }
    });
    component.set('v.preSelectedRows', preSelectedRows);
    component.set('v.selectedRows2', preSelectedRows);
    component.set('v.selectedRows', preSelectedRows);
  },
  removeZeroFFSSId: function(ffssListLabel) {
    ffssListLabel.map(el =>{
      el.shortId = el.arce__financial_statement_id__c.replace(/^0+/, '');
    });
    return ffssListLabel;
  }

});