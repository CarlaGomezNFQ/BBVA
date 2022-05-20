/* eslint-disable no-unused-expressions */
({
  doInit: function(cmp, event, helper) {
    helper.waiting(cmp);
    var action = cmp.get('c.getSelectedFamilies');
    action.setParams({
      profAnalysisId: cmp.get('v.recordId'),
      conditionsSelected: cmp.get('v.conditionsSelected')
    });
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (state === 'SUCCESS') {

        //group by families and call first family
        cmp.set('v.selectedFamilies', response.getReturnValue());

        var selectedFamilies = JSON.parse(cmp.get('v.selectedFamilies'));
        var currentIndex = 0;
        var familyIds = [];
        var familyNames = [];
        var sortFamilies = [];

        for (var key in selectedFamilies) {
          if (key !== undefined) {
            sortFamilies.push({id: key, order: selectedFamilies[key].familyOrder});
          }
        }

        sortFamilies.sort(function(x, y) {
          return x.order - y.order;
        });

        for (var j = 0; j < sortFamilies.length; j++) {
          familyNames.push(selectedFamilies[sortFamilies[j].id].familyName);
          familyIds.push(sortFamilies[j].id);
        }

        cmp.set('v.familyIds', familyIds);
        cmp.set('v.familyNames', familyNames);
        cmp.set('v.currentIndex', currentIndex);
        cmp.set('v.numFamilies', familyIds.length);
        helper.next(cmp, event, helper);

      } else if (state === 'INCOMPLETE') {
        console.log('INCOMPLETE', response);
      } else if (state === 'ERROR') {
        var errors = response.getError();
        if (errors) {
          if (errors[0] && errors[0].message) {
            console.error('Error message: ' + errors[0].message);
          }
        } else {
          console.error('Unknown error');
        }
      }
      helper.doneWaiting(cmp);
    });
    $A.enqueueAction(action);
  },

  next: function(cmp, event, helper) {

    helper.waiting(cmp);

    var selectedFamilies = JSON.parse(cmp.get('v.selectedFamilies'));
    var currentIndex = cmp.get('v.currentIndex');
    var familyIds = cmp.get('v.familyIds');
    var conditionsSelected = selectedFamilies[familyIds[currentIndex]].conditionIds;
    var familyId = familyIds[currentIndex];

    // get json with official, delegated and current for family
    var action = cmp.get('c.getConditionsValues');
    action.setParams({
      profAnalysisId: cmp.get('v.recordId'),
      familyId: familyId,
      conditionsSelected: conditionsSelected
    });
    action.setCallback(this, function(response) {

      var state = response.getState();
      if (state === 'SUCCESS') {

        let attr = {
          'aura:id': 'childEditForm' + currentIndex,
          'conditionAttValuesJSON': response.getReturnValue(),
          'recordId': cmp.get('v.recordId')
        };

        helper.loadComponent(cmp, event, helper, 'conditions_change_cmp', attr).then($A.getCallback(newCmp => {
          let body = [];
          body.push(newCmp);
          cmp.set('v.body', body);
        }));

      } else if (state === 'INCOMPLETE') {
        console.log('INCOMPLETE', response);
      } else if (state === 'ERROR') {
        var errors = response.getError();
        if (errors) {
          if (errors[0] && errors[0].message) {
            console.error('Error message: ' + errors[0].message);
          }
        } else {
          console.error('Unknown error');
        }
      }
      helper.doneWaiting(cmp);
    });
    $A.enqueueAction(action);
  },

  loadComponent: function(cmp, event, helper, cmpName, cmpAttr) {
    return new Promise($A.getCallback(function(resolve, reject) {
      $A.createComponent(
        'cuco:' + cmpName, cmpAttr, function(newCmp, status, errorMessage) {
          if (status === 'SUCCESS') {
            resolve(newCmp);
          } else if (status === 'INCOMPLETE' || status === 'ERROR') {
            this.showToast('Error', 'error', errorMessage);
          }
        }
      );
    }));
  },

  handleContinue: function(cmp, event, helper) {
    helper.waiting(cmp);
    cmp.set('v.showWarning', false);
    var childEditForm = cmp.find('childEditForm' + cmp.get('v.currentIndex'));
    childEditForm.save();
  },

  handleEventSave: function(cmp, event, helper) {
    helper.doneWaiting(cmp);
    helper.refreshConditions(cmp, event, helper);

    var success = event.getParam('success');
    var errorMessages = event.getParam('errorMessages');
    if (success) {

      var nextIndex = cmp.get('v.currentIndex') + 1;
      var familyIds = cmp.get('v.familyIds');

      if (nextIndex < familyIds.length) {
        cmp.set('v.currentIndex', nextIndex);
        helper.next(cmp, event, helper);
      } else {
        helper.destroyCmp(cmp, event, helper);
      }

    } else {
      let errors = JSON.parse(errorMessages);
      cmp.set('v.errors', errors);
      cmp.set('v.showWarning', true);
    }

  },

  refreshConditions: function(cmp, event, helper) {
    let refreshConditionsEvent  = $A.get('e.cuco:refresh_conditions_evt');
    refreshConditionsEvent.setParams({'contextId': cmp.get('v.recordId')});
    refreshConditionsEvent.fire();
  },

  waiting: function(cmp) {
    cmp.set('v.waiting', true);
  },

  doneWaiting: function(cmp) {
    cmp.set('v.waiting', false);
  },

  showToast: function(type, title, message) {
    var toastEvent = $A.get('e.force:showToast');
    toastEvent.setParams({
      title: title,
      message: message,
      duration: 5000,
      key: 'info_alt',
      type: type,
      mode: 'dismissible'
    });
    toastEvent.fire();
  }

});