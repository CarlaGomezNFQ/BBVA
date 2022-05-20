({
  initEng: function(component, event, helper) {
    if (component.get('v.isRAIP')) {
      component.set('v.maxRowSelection', 1);
    }
    helper.setColumns(component);
    helper.fetchFinancialStatements(component, event, helper);
  },
  updateSelectedRows: function(component, event, helper) {
    var selectedRows = event.getParam('selectedRows');
    if (component.get('v.isFinancialRAIP') && helper.isPreselected(component, selectedRows)) {
      helper.toastMessage(component, event, 'info', $A.get('$Label.c.Arc_Gen_CannotSelectFFSS'));
      component.set('v.selectedRows', component.get('v.preSelectedRows'));
    } else {
      var setRows = [];
      if (selectedRows.length > 0) {
        for (var i = 0; i < selectedRows.length; i++) {
          setRows.push(selectedRows[i].arce__financial_statement_id__c);
        }
        component.set('v.selectedRows2', setRows);
        helper.evtSelectionFFSS(component, selectedRows);
        component.set('v.btnStmIsDisabled', false);
      } else {
        component.set('v.btnStmIsDisabled', true);
      }
    }

  },
  callTablesEngine: function(component, event, helper) {
    component.set('v.btnStmIsDisabled', true);
    let promise = helper.consultEngine(component, event, helper);
    return promise.then(function(resolve, reject) {
      helper.consultFSdetails(component, event, helper);
      helper.evtUpdateBalances(component);
      component.set('v.spinnerLoading', false);
    }).catch(function() {
      component.set('v.spinnerLoading', false);
    });
  }
});