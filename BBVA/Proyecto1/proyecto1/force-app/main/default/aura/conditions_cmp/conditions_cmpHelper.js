/* eslint-disable no-unused-expressions */
({
  doInit: function(cmp, event, helper) {
    helper.waiting(cmp);
    var action = cmp.get('c.getConditions');
    action.setParams({
      contextId: cmp.get('v.recordId')
    });
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (state === 'SUCCESS') {

        helper.checkCanManagePermissions(cmp, event, helper);

        var conditions = helper.sortConditions(cmp, response.getReturnValue());
        cmp.set('v.rawConditions', response.getReturnValue());
        cmp.set('v.conditions', conditions);
        if (conditions.length < 1) {
          cmp.set('v.noconditions', true);
        } else {
          cmp.set('v.noconditions', false);
        }

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

  refreshConditions: function(cmp, event, helper) {
    var contextId = event.getParam('contextId');
    if (cmp.get('v.recordId') === contextId) {
      helper.doInit(cmp, event, helper);
    }
  },

  sortConditions: function(cmp, data) {

    var groupedConditions;
    var families;
    var sorted = [];
    var activeSections = [];
    var map = [];

    // Group values by Product > Family > Conditions
    // Only conditions with no source
    var grouped = data.reduce((result, value) => {
      if (!value.source) {
        result[value.productName] = result[value.productName] || [];
        result[value.productName][value.familyName] = result[value.productName][value.familyName] || [];
        result[value.productName][value.familyName].push({
          id: value.id,
          catalogConditionId: value.catalogConditionId,
          name: value.name,
          order: value.order,
          familyLevel: value.familyLevel,
          familyOrder: value.familyOrder,
          familyId: value.familyId,
          profitabilityAnalysisId: value.profitabilityAnalysisId,
          attributes: value.attributes
        });
      }
      return result;
    }, {});

    // Sort by conditionVisulizationOrder
    Object.keys(grouped).forEach((product, index) => {
      sorted[product] = [];
      activeSections.push('P' + index);
      families = Object.keys(grouped[product]);
      Object.keys(families).forEach(family => {
        groupedConditions = Object.values(grouped[product][families[family]]).sort((a, b) => (a.order > b.order ? 1 : -1));
        sorted[product][families[family]] = groupedConditions;
      });
    });

    cmp.set('v.activeSections', activeSections);

    // Format as aura iterable Object
    Object.keys(sorted).forEach((key, index1) => {
      var product = {};
      product.name = key;
      product.value = [];
      product.section = 'P' + index1;
      product.opensection = [];
      families = sorted[key];

      Object.keys(families).forEach((key2, index2) => {
        var family = {};
        family.name = key2;
        family.section = 'F' + index1 + index2;
        family.familyLevel = false;
        family.hasConditions = false;
        family.id = families[key2][0].id;
        family.familyId = families[key2][0].familyId;
        family.value = families[key2];
        family.columns = [];
        var listAttr = [];

        family.value.forEach(condition => {
          if (condition.familyLevel) {
            family.familyLevel = true;
          } else {
            condition.attributes.forEach(attr => {
              if (listAttr.indexOf(attr.id) === -1) {
                family.columns.push({id: attr.id, name: attr.name, type: attr.type});
                listAttr.push(attr.id);
              }
            });
            family.hasConditions = true;
          }
        });
        product.opensection.push(family.section);
        product.value.push(family);
      });

      map.push(product);
    });
    return map;
  },

  checkPermission: function(cmp, params, name) {
    return new Promise($A.getCallback(function(resolve, reject) {
      var action = cmp.get('c.checkPermissions');
      action.setParams(params);
      action.setCallback(this, function(response) {
        var state = response.getState();
        if (state === 'SUCCESS') {
          var result = response.getReturnValue();
          resolve(result);
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
          reject(state);
        }
      });
      $A.enqueueAction(action);
    }));
  },

  checkCanManagePermissions: function(cmp, event, helper) {
    helper.waiting(cmp);
    var action = cmp.get('c.checkPermissions');
    action.setParams({
      action: 'manageConditions',
      profAnalysisId: cmp.get('v.recordId'),
      familyId: null,
      conditionId: null
    });
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (state === 'SUCCESS') {
        cmp.set('v.managePermissions', response.getReturnValue());
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
      helper.doneWaiting(cmp);
    });
    $A.enqueueAction(action);
  },

  addConditions: function(cmp, event, helper) {
    helper.waiting(cmp);
    let attr = {
      profAnalysisId: cmp.get('v.recordId'),
      viewMode: 'general',
      paConditions: cmp.get('v.rawConditions'),
      recordId: cmp.get('v.recordId')
    };
    helper.loadComponent(cmp, event, helper, 'conditions_select_cmp', attr).then($A.getCallback(newCmp => {
      let body = [];
      body.push(newCmp);
      cmp.set('v.body', body);
    }));
    helper.doneWaiting(cmp);
  },

  handleConditionsSelectContinue: function(cmp, event, helper) {
    helper.waiting(cmp);
    if (event.getParam('viewMode') === 'general') {
      var conditionsSelected = event.getParam('conditionsSelected');
      let attr = {
        recordId: cmp.get('v.recordId'),
        conditions: cmp.get('v.rawConditions'),
        conditionsSelected: conditionsSelected
      };
      helper.loadComponent(cmp, event, helper, 'conditions_add_cmp', attr).then($A.getCallback(newCmp => {
        let body = [];
        body.push(newCmp);
        cmp.set('v.body', body);
      }));
    }
    helper.doneWaiting(cmp);
  },

  editConditions: function(cmp, event, helper, params) {
    helper.waiting(cmp);
    var includedConditions = [];
    var familyId = params.familyId;
    var conditions = cmp.get('v.conditions');
    conditions.forEach(group => {
      group.value.forEach(family => {
        if (family.familyId === familyId) {
          family.value.forEach(condition => {
            includedConditions.push(condition.catalogConditionId);
          });
        }
      });
    });
    let attr = {
      profAnalysisId: cmp.get('v.recordId'),
      familyId: params.familyId,
      conditions: includedConditions,
      recordId: cmp.get('v.recordId')
    };
    helper.loadComponent(cmp, event, helper, 'conditions_edit_cmp', attr).then($A.getCallback(newCmp => {
      let body = [];
      body.push(newCmp);
      cmp.set('v.body', body);
    }));
    helper.doneWaiting(cmp);
  },

  removeCondition: function(cmp, event, helper, params) {
    let attr = {
      'profAnalysisId': params.profAnalysisId,
      'conditionId': params.conditionId,
      'recordId': cmp.get('v.recordId')
    };
    helper.loadComponent(cmp, event, helper, 'condition_remove_cmp', attr).then($A.getCallback(newCmp => {
      let body = [];
      body.push(newCmp);
      cmp.set('v.body', body);
    }));
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