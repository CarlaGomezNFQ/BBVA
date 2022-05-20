/* eslint-disable no-unused-expressions */
({
  doInit: function(cmp, event, helper) {

    helper.waiting(cmp);

    var conditionAttValuesJSON = JSON.parse(cmp.get('v.conditionAttValuesJSON'));
    cmp.set('v.showStandard', conditionAttValuesJSON.standard !== undefined);
    cmp.set('v.showDelegated', conditionAttValuesJSON.delegation !== undefined);

    var items = 3;
    if (conditionAttValuesJSON.standard !== undefined) {
      items++;
    }
    if (conditionAttValuesJSON.delegation !== undefined) {
      items++;
    }
    cmp.set('v.cellwidth', 'width:' + 100 / items + '%');

    var action = cmp.get('c.getConditionsFromJSON');
    action.setParams({
      jsonInput: cmp.get('v.conditionAttValuesJSON')
    });
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (state === 'SUCCESS') {

        var obj = response.getReturnValue();

        //Show informative warning
        cmp.set('v.showInformativeWarning', obj.hasInformativeConditions);

        let hasFamilyLevel = obj.conditions.find(condition => condition.familyLevel === true) !== undefined;
        let hasConditionLevel = obj.conditions.find(condition => condition.familyLevel === false) !== undefined;
        let nConditions = obj.conditions.length;

        //family level elements remaining items must be filled with empty layoutItems
        let famConditions = obj.conditions.filter(condition => condition.familyLevel === true).length;
        let remainingItems = [];

        obj.conditions.forEach(condition => {
          if (!condition.familyLevel) {
            condition.expanded = true;
          }
        });

        if (famConditions > 0 && 4 - famConditions % 4 !== 4) {
          for (var i = 1; i <= 4 - famConditions % 4; i++) {
            remainingItems.push('blank');
          }
        }

        obj.hasFamilyLevel = hasFamilyLevel;
        obj.hasConditionLevel = hasConditionLevel;
        obj.numConditions = nConditions;

        cmp.set('v.conditions', obj);
        cmp.set('v.remainingfamilyItems', remainingItems);

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

  toggleCondition: function(cmp, event, helper) {
    var index = event.currentTarget.id;
    var conditions = cmp.get('v.conditions');
    conditions.conditions.forEach(condition => {
      if (condition.conditionId === index) {
        condition.expanded = !condition.expanded;
      }
    });
    cmp.set('v.conditions', conditions);
  },

  save: function(cmp, event, helper) {
    var inputValues = helper.getInputValues(cmp, event, helper);
    var action = cmp.get('c.validateInputValues');

    action.setParams({
      profAnalysisId: cmp.get('v.recordId'),
      inputValues: JSON.stringify(inputValues)
    });

    action.setCallback(this, function(response) {
      var state = response.getState();
      if (state === 'SUCCESS') {
        var result = JSON.parse(response.getReturnValue());
        if (result.conditions === null) {
          helper.saveValues(cmp, event, helper, inputValues);
        } else {
          let saveConditionsEvent = cmp.getEvent('save_conditions_evt');
          saveConditionsEvent.setParams({
            success: false,
            errorMessages: JSON.stringify(result.conditions)
          });
          saveConditionsEvent.fire();
        }
      } else {
        if (state === 'INCOMPLETE') {
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
      }
    });
    $A.enqueueAction(action);
  },

  saveValues: function(cmp, event, helper, inputValues) {
    var action = cmp.get('c.updateConditions');
    action.setParams({
      profAnalysisId: cmp.get('v.recordId'),
      conditionAttValuesJSON: JSON.stringify(inputValues)
    });

    action.setCallback(this, function(response) {
      var state = response.getState();
      if (state === 'SUCCESS') {
        var result = response.getReturnValue();
        if (result.isSuccess) {
          let saveConditionsEvent = cmp.getEvent('save_conditions_evt');
          saveConditionsEvent.setParams({
            success: result.isSuccess,
            errorMessages: {}
          });
          saveConditionsEvent.fire();
        } else {
          helper.showToast('error', $A.get('$Label.cuco.update_condition_error'));
          console.error(result.lstErrMessage);
        }
      } else {

        if (state === 'INCOMPLETE') {
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
      }
    });
    $A.enqueueAction(action);
  },

  getInputValues: function(cmp, event, helper) { // eslint-disable-line complexity

    var familyFields = cmp.find('familyField');
    var inputFields = cmp.find('inputField');
    var inputValues = JSON.parse('{"conditions":[]}');

    if (familyFields) {
      if (familyFields.length === undefined) { //only one found
        let condition;
        if (familyFields.get('v.type') === 'toggle') {
          condition = {
            id: familyFields.get('v.name'),
            attributes: [ { id: familyFields.get('v.label'), proposed: familyFields.get('v.checked') } ]
          };
        } else {
          condition = {
            id: familyFields.get('v.name'),
            attributes: [ { id: familyFields.get('v.label'), proposed: familyFields.get('v.value') !== undefined ? familyFields.get('v.value').trim() : undefined } ]
          };
        }
        inputValues.conditions.push(condition);
      }
      for (var k = 0; k < familyFields.length; k++) {
        let condition;
        if (familyFields[k].get('v.type') === 'toggle') {
          condition = {
            id: familyFields[k].get('v.name'),
            attributes: [ { id: familyFields[k].get('v.label'), proposed: familyFields[k].get('v.checked') } ]
          };
        } else {
          condition = {
            id: familyFields[k].get('v.name'),
            attributes: [ { id: familyFields[k].get('v.label'), proposed: familyFields[k].get('v.value') !== undefined ? familyFields[k].get('v.value').trim() : undefined } ]
          };
        }
        inputValues.conditions.push(condition);
      }
    }

    if (inputFields) {
      if (inputFields.length === undefined) { // only one found
        let condition = {
          id: inputFields.get('v.name'),
          attributes: [ { id: inputFields.get('v.label'), proposed: inputFields.get('v.value') !== undefined ? inputFields.get('v.value').trim() : undefined } ]
        };
        inputValues.conditions.push(condition);
      }
      for (var i = 0; i < inputFields.length; i++) {
        let found = false;
        for (var j = 0; j < inputValues.conditions.length; j++) {
          if (inputValues.conditions[j].id === inputFields[i].get('v.name')) {
            inputValues.conditions[j].attributes.push({
              id: inputFields[i].get('v.label'),
              proposed: inputFields[i].get('v.value') !== undefined ? inputFields[i].get('v.value').trim() : undefined
            });
            found = true;
            break;
          }
        }
        if (!found) {
          inputValues.conditions.push({
            id: inputFields[i].get('v.name'),
            attributes: [ { id: inputFields[i].get('v.label'), proposed: inputFields[i].get('v.value') !== undefined ? inputFields[i].get('v.value').trim() : undefined } ]});
        }
      }
    }
    return inputValues;
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