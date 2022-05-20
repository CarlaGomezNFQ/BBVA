({
  retrieveTableData: function(cmp, evt, helper) {
    $A.util.removeClass(cmp.find('simpleSpinner'), 'slds-hide');
    cmp.set('v.title', $A.get('$Label.cuco.add_participants_title'));
    let action = cmp.get('c.retrieveTableData');
    action.setParams({
      'recordId': cmp.get('v.recordId')
    });
    action.setCallback(this, function(response) {
      if (response.getState() === 'SUCCESS') {
        let ret = response.getReturnValue();
        if (ret.showTable) {
          cmp.set('v.lstAccsInTable', ret.tableInfo);
          let arrColumn = [
            {label: $A.get('$Label.cuco.subsidiary'),  fieldName: 'accName', type: 'text'},
            {label: $A.get('$Label.cuco.documentNumber'),  fieldName: 'documentNumber', type: 'text'},
            {label: $A.get('$Label.cuco.rating'),  fieldName: 'rating', type: 'text'}
          ];
          let arrData = [];
          ret.tableInfo.forEach(function(item) {
            let dataObj = {
              accName: item.participantName,
              documentNumber: item.documentNumber,
              rating: item.rating,
              participantId: item.participantId
            };
            arrData.push(dataObj);
          });
          cmp.set('v.columns', arrColumn);
          cmp.set('v.data', arrData);
          cmp.set('v.originalData', arrData);
        } else {
          cmp.set('v.errMessageBanner', ret.errMessage);
        }
        cmp.set('v.profAccName', ret.profAccName);
        cmp.set('v.showTable', ret.showTable);
        cmp.set('v.isSuccess', true);
        $A.util.addClass(cmp.find('simpleSpinner'), 'slds-hide');
      } else if (response.getState() === 'ERROR') {
        helper.showNewToastParticipantAddCmp('error', response.getError()[0].message);
      }
    });
    $A.enqueueAction(action);
  },
  doNameFilter: function(cmp, evt, helper) {
    $A.util.removeClass(cmp.find('simpleSpinner'), 'slds-hide');
    let currentValue = document.getElementById('searchInput').value;

    if (currentValue === '') {
      cmp.set('v.showCleanButton', false);
      cmp.set('v.hasActiveFilter', false);
    } else {
      cmp.set('v.showCleanButton', true);
      cmp.set('v.hasActiveFilter', true);
    }

    let originalData = cmp.get('v.originalData');
    let newTableData = [];
    if (currentValue.length > 2) {
      try {
        let regex = new RegExp(currentValue, 'i');

        // filter checks each row, constructs new array where function returns true
        newTableData = originalData.filter(row=>regex.test(row.accName));
      } catch (e) {
        // invalid regex, use full list
        newTableData = originalData;
      }

      // Set new arr fill with current selected accs that pass filter
      let globalRowSelection = cmp.get('v.globalRowSelection');
      let currentRowSelection = [];
      for (let acc of newTableData) {
        if (globalRowSelection.includes(acc.participantId)) {
          currentRowSelection.push(acc.participantId);
        }
      }

      if (currentRowSelection.length > 0) { // Filter because selection evt trigger when table is empty
        cmp.set('v.selectedRows', currentRowSelection);
      }
      cmp.set('v.currentRowSelection', currentRowSelection);
      cmp.set('v.data', newTableData);
      helper.updateSelectedRowNumber(cmp, evt, helper);
    } else {
      // set initial data
      cmp.set('v.data', originalData);
      cmp.set('v.selectedRows', cmp.get('v.globalRowSelection'));
      helper.updateSelectedRowNumber(cmp, evt, helper);
    }

    $A.util.addClass(cmp.find('simpleSpinner'), 'slds-hide');
  },
  cleanSearchInput: function(cmp, evt, helper) {
    $A.util.removeClass(cmp.find('simpleSpinner'), 'slds-hide');
    document.getElementById('searchInput').value = '';
    let originalData = cmp.get('v.originalData');
    cmp.set('v.data', originalData);
    cmp.set('v.hasActiveFilter', false);
    cmp.set('v.selectedRows', cmp.get('v.globalRowSelection'));
    helper.updateSelectedRowNumber(cmp, evt, helper);
    $A.util.addClass(cmp.find('simpleSpinner'), 'slds-hide');
  },
  updateSelectedRows: function(cmp, evt, helper) {
    cmp.set('v.errNoSelectedTable', false);
    let hasActiveFilter = cmp.get('v.hasActiveFilter');

    // If has name filter active
    if (hasActiveFilter) {

      // In the set of accounts filtered by name, those that are selected when the user
      // finish to write on the input
      let currentRowSelection = cmp.get('v.currentRowSelection');

      // Current row selection
      let newArrAccsSelected = cmp.find('participantsAddTable').getSelectedRows();

      if (newArrAccsSelected.length > currentRowSelection.length) { // Select case
        helper.doSelectionActionEvt(cmp, newArrAccsSelected, currentRowSelection);
      } else if (newArrAccsSelected.length < currentRowSelection.length) { // Deselect case
        helper.doDeselectionActionEvt(cmp, newArrAccsSelected, currentRowSelection);
      }
    } else {
      let newGlobalRowArr = [];
      let selectedRows = cmp.find('participantsAddTable').getSelectedRows();
      selectedRows.forEach(function(item) {
        newGlobalRowArr.push(item.participantId);
      });
      cmp.set('v.globalRowSelection', newGlobalRowArr);
    }
    helper.updateSelectedRowNumber(cmp, evt, helper);
  },
  doSelectionActionEvt: function(cmp) {

    let currentRowSelection = cmp.get('v.currentRowSelection');
    let globalRowSelection = cmp.get('v.globalRowSelection');
    let newArrAccsSelected = cmp.find('participantsAddTable').getSelectedRows();

    for (let acc of newArrAccsSelected) {
      if (!currentRowSelection.includes(acc.participantId)) {
        currentRowSelection.push(acc.participantId);
        globalRowSelection.push(acc.participantId);
      }
    }

    cmp.set('v.currentRowSelection', currentRowSelection);
    cmp.set('v.selectedRows', currentRowSelection);
    cmp.set('v.globalRowSelection', globalRowSelection);
  },
  doDeselectionActionEvt: function(cmp) {

    let currentRowSelection = cmp.get('v.currentRowSelection');
    let globalRowSelection = cmp.get('v.globalRowSelection');
    let newArrAccsSelected = cmp.find('participantsAddTable').getSelectedRows();

    let arrAux = [];
    for (let acc of newArrAccsSelected) {
      arrAux.push(acc.participantId);
    }

    let index = 0;
    for (let accId of currentRowSelection) {
      if (!arrAux.includes(accId)) {
        currentRowSelection.splice(index, 1);
        globalRowSelection.splice(index, 1);
      }
      index++;
    }

    cmp.set('v.currentRowSelection', currentRowSelection);
    cmp.set('v.selectedRows', currentRowSelection);
    cmp.set('v.globalRowSelection', globalRowSelection);
  },
  updateSelectedRowNumber: function(cmp, evt, helper) {
    cmp.set('v.numberSelectedRows', cmp.get('v.globalRowSelection').length);
  },
  handleAdd: function(cmp, evt, helper) {
    $A.util.removeClass(cmp.find('simpleSpinner'), 'slds-hide');
    let globalRowSelection = cmp.get('v.globalRowSelection');

    let action = cmp.get('c.manageNewParticipants');
    action.setParams({
      'profAnalysisId': cmp.get('v.recordId'),
      'lstAccId': globalRowSelection
    });
    action.setCallback(this, function(response) {
      if (response.getState() === 'SUCCESS') {
        let ret = response.getReturnValue();
        if (ret.errMessage.length !== 0) {
          // Errors
          if (ret.showToast) {
            helper.showNewToastParticipantAddCmp(ret.toastType, ret.errMessage);
          } else if (ret.showEmptyErr) {
            cmp.set('v.errNoSelectedTable', true);
            cmp.set('v.errMessageNoSelectedTable', ret.errMessage);
          }
        } else {
          // No errors. Fire evt and destroy modal cmp
          helper.showNewToastParticipantAddCmp('success', $A.get('$Label.cuco.add_participants_success'));

          // Refresh participants evt
          let appEvent = $A.get('e.cuco:refresh_participants_evt');
          appEvent.setParams({
            'contextId': cmp.get('v.recordId')
          });
          appEvent.fire();

          // Refresh participants evt
          let appEventCommPartAdd = $A.get('e.cuco:refresh_comm_packages_evt');
          appEventCommPartAdd.setParams({
            'contextId': cmp.get('v.recordId')
          });
          appEventCommPartAdd.fire();

          // Refresh forfait packages evt
          let appEventForfaitPartAdd = $A.get('e.cuco:refresh_forfait_packages_evt');
          appEventForfaitPartAdd.setParams({
            'contextId': cmp.get('v.recordId')
          });
          appEventForfaitPartAdd.fire();

          // Refresh gip package evt
          let appEventGipPartAdd = $A.get('e.cuco:refresh_gip_packages_evt');
          appEventGipPartAdd.setParams({
            'contextId': cmp.get('v.recordId')
          });
          appEventGipPartAdd.fire();
          helper.destroyCmp(cmp, evt, helper);
        }
        $A.util.addClass(cmp.find('simpleSpinner'), 'slds-hide');
      } else if (response.getState() === 'ERROR') {
        helper.showNewToastParticipantAddCmp('error', response.getError()[0].message);
      }
    });
    $A.enqueueAction(action);
  },
  showNewToastParticipantAddCmp: function(type, message) {
    let titleParticipantAddToast;
    switch (type) {
      case 'success':
        titleParticipantAddToast = $A.get('$Label.cuco.toast_title_success');
        break;
      case 'warning':
        titleParticipantAddToast = $A.get('$Label.cuco.toast_title_warning');
        break;
      case 'error':
        titleParticipantAddToast = $A.get('$Label.cuco.toast_title_error');
        break;
    }
    let newToastParticipantAddCmp = $A.get('e.force:showToast');
    newToastParticipantAddCmp.setParams({
      'title': titleParticipantAddToast,
      'type': type,
      'message': message
    });
    newToastParticipantAddCmp.fire();
  }
});