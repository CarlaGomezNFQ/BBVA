({
  retrieveParticipantsInfo: function(cmp, evt, helper) {
    let action = cmp.get('c.retrieveParticipantsInfo');
    action.setParams({
      'recordId': cmp.get('v.recordId'),
      'sObjectName': cmp.get('v.sObjectName')
    });
    action.setCallback(this, function(response) {
      if (response.getState() === 'SUCCESS') {
        let ret = response.getReturnValue();
        if (ret.showInfo) {
          cmp.set('v.tableTitle', ret.tableTitle);
          if (ret.lstEmpty) {
            cmp.set('v.errMessageBanner', ret.errMessage);
            cmp.set('v.showErrBanner', true);
          } else {
            cmp.set('v.showErrBanner', false);
            cmp.set('v.lstParticipantsDetails', ret.lstParticipantsDetails);
            cmp.set('v.showAddButton', ret.showAddButton);
            cmp.set('v.showRemoveButton', ret.showRemoveButton);
          }
        }
        cmp.set('v.showTable', ret.showInfo);
      } else if (response.getState() === 'ERROR') {
        helper.showNewToastParticipant('error', response.getError()[0].message);
      }
    });
    $A.enqueueAction(action);
  },
  handleAdd: function(cmp, evt, helper) {
    $A.util.removeClass(cmp.find('mySpinner'), 'slds-hide');
    let action = cmp.get('c.handleAddAction');
    action.setParams({
      'recordId': cmp.get('v.recordId')
    });
    action.setCallback(this, function(response) {
      if (response.getState() === 'SUCCESS') {
        let ret = response.getReturnValue();
        if (ret.add) {
          helper.showNewCmp(cmp, helper, 'participants_add_cmp', cmp.get('v.recordId'));
        } else {
          $A.util.addClass(cmp.find('mySpinner'), 'slds-hide');
          helper.showNewToastParticipant('warning', ret.addMessage);
        }
      } else if (response.getState() === 'ERROR') {
        helper.showNewToastParticipant('error', response.getError()[0].message);
      }
    });
    $A.enqueueAction(action);
  },
  handleRemove: function(cmp, evt, helper) {
    let position = evt.getSource().get('v.name');
    $A.util.removeClass(cmp.find('mySpinner'), 'slds-hide');
    let accArr = cmp.get('v.lstParticipantsDetails');
    let action = cmp.get('c.handleRemoveAction');
    action.setParams({
      'recordId': cmp.get('v.recordId'),
      'accountId': accArr[position].partWrapper.participantId
    });
    action.setCallback(this, function(response) {
      if (response.getState() === 'SUCCESS') {
        let ret = response.getReturnValue();
        if (ret.remove) {
          if (accArr.length === 1) {
            $A.util.addClass(cmp.find('mySpinner'), 'slds-hide');
            helper.showNewToastParticipant('error', $A.get('$Label.cuco.remove_last_participant_error'));
          } else {
            let currentProfAnalysisParticipant = accArr[position].profAnalysisParticipantId;
            helper.showNewCmp(cmp, helper, 'participants_remove_cmp', currentProfAnalysisParticipant);
          }
        } else {
          $A.util.addClass(cmp.find('mySpinner'), 'slds-hide');
          helper.showNewToastParticipant('warning', ret.removeMessage);
        }
      } else if (response.getState() === 'ERROR') {
        helper.showNewToastParticipant('error', response.getError()[0].message);
      }
    });
    $A.enqueueAction(action);
  },
  showNewCmp: function(cmp, helper, nextCmpName, recordId) {
    helper.createNextCmp(cmp, helper, nextCmpName, recordId).then($A.getCallback(newCmp => {
      $A.util.addClass(cmp.find('mySpinner'), 'slds-hide');
      let body = [];
      body.push(newCmp);
      cmp.set('v.body', body);
    }));
  },
  createNextCmp: function(cmp, helper, cmpName, recordId) {
    return new Promise($A.getCallback(function(resolve, reject) {
      $A.createComponent(
        'cuco:' + cmpName,
        {
          'recordId': recordId
        },
        function(newCmp, status, errorMessage) {
          if (status === 'SUCCESS') {
            resolve(newCmp);
          } else if (status === 'INCOMPLETE' || status === 'ERROR') {
            $A.util.addClass(cmp.find('mySpinner'), 'slds-hide');
            helper.showNewToastParticipant('error', errorMessage);
          }
        }
      );
    }));
  },
  showNewToastParticipant: function(type, message) {
    let titleParticipantToast;
    switch (type) {
      case 'success':
        titleParticipantToast = $A.get('$Label.cuco.toast_title_success');
        break;
      case 'warning':
        titleParticipantToast = $A.get('$Label.cuco.toast_title_warning');
        break;
      case 'error':
        titleParticipantToast = $A.get('$Label.cuco.toast_title_error');
        break;
    }
    var newParticipantToast = $A.get('e.force:showToast');
    newParticipantToast.setParams({
      'title': titleParticipantToast,
      'type': type,
      'message': message
    });
    newParticipantToast.fire();
  }
});