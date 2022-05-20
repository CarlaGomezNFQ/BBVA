/* eslint-disable no-unused-expressions */
({
  doInit: function(cmp, event, helper) {

    var actionMethod;

    if (cmp.get('v.viewMode') === 'general') {
      actionMethod = 'getActiveCatalogConditions';
    } else {
      actionMethod = 'getActiveFlatCatalogConditions';
    }

    //load data
    var action = cmp.get('c.' + actionMethod);
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (state === 'SUCCESS') {

        //helper.handleSuccess(cmp, event, helper);
        var conditions = helper.sortConditions(cmp, response.getReturnValue());
        cmp.set('v.conditions', conditions);

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
    });
    $A.enqueueAction(action);
  },

  sortConditions: function(cmp, data) {

    var groupedConditions;
    var families;
    var sorted = [];
    var activeSections = [];
    var map = [];
    var existingConditions = cmp.get('v.paConditions');
    var viewMode = cmp.get('v.viewMode');
    var checkedInit = [];

    // Group values by Product > Family > Conditions
    var grouped = data.reduce((result, value) => {
      result[value.productName] = result[value.productName] || [];
      result[value.productName][value.familyName] = result[value.productName][value.familyName] || [];
      result[value.productName][value.familyName].push({
        id: value.id,
        name: value.name,
        order: value.order,
        familyLevel: value.familyLevel,
        familyOrder: value.familyOrder,
        familyId: value.familyId
      });
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

    cmp.set('v.activeSections', activeSections[0]);

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
        family.id = families[key2][0].familyId;
        family.value = families[key2];
        family.columns = [];

        let checkedCount = 0;

        family.value.forEach(condition => {
          if (condition.familyLevel) {
            family.familyLevel = true;
          }
          var found = existingConditions.find(element => element.catalogConditionId === condition.id);
          if (found) {
            if (viewMode === 'general') {
              if (['COMMERCIAL_PACKAGE', 'GIP_PACKAGE', 'FORFAIT', 'COMMISSIONS_FLAT'].includes(found.source)) {
                cmp.set('v.showWarning', true);
                condition.checked = false;
              } else {
                condition.checked = true;
                checkedInit.push(condition.id);
                checkedCount++;
              }
              condition.disabled = true;
            } else {
              if (['COMMERCIAL_PACKAGE', 'GIP_PACKAGE', 'FORFAIT'].includes(found.source)) {
                cmp.set('v.showWarning', true);
                condition.disabled = true;
                condition.checked = false;
              } else {
                condition.checked = true;
                condition.disabled = false;
                checkedInit.push(condition.id);
                checkedCount++;
              }
            }
          } else {
            condition.disabled = false;
            condition.checked = false;
          }
        });
        family.checked = (checkedCount === family.value.length);
        family.indeterminated = (checkedCount < family.value.length && checkedCount > 0);

        // open only first product and first family
        if (index1 === 0 && index2 === 0) {
          product.opensection.push(family.section);
        }
        product.value.push(family);
      });
      map.push(product);
    });
    cmp.set('v.checkedInit', checkedInit);
    return map;
  },

  toggleGroup: function(cmp, event, helper) {
    const family = event.getSource().get('v.value');
    const conditions = cmp.find('checkbox').filter(c => c.get('v.name') === family);
    const check = event.getSource().get('v.checked');
    var i = 0;
    $A.util.removeClass(event.getSource(), 'indeterminated');

    conditions.forEach(condition => {
      if (!condition.get('v.disabled')) {
        condition.set('v.checked', check);
      }
      if (condition.get('v.checked')) {
        i++;
      }
    });
    if (i === conditions.length) {
      event.getSource().set('v.checked', true);
    } else if (i === 0) {
      event.getSource().set('v.checked', false);
    } else {
      event.getSource().set('v.checked', false);
      $A.util.addClass(event.getSource(), 'indeterminated');
    }
  },

  evaluateToggleGroup: function(cmp, event, helper) {
    const family = event.getSource().get('v.name');
    const group = cmp.find('group').filter(c => c.get('v.value') === family);
    const conditions = cmp.find('checkbox').filter(c => c.get('v.name') === family);
    const conditionsCheked = cmp.find('checkbox').filter(c => c.get('v.name') === family && c.get('v.checked'));
    $A.util.removeClass(group[0], 'indeterminated');

    if (conditionsCheked.length === 0) {
      group[0].set('v.checked', false);
    } else if (conditionsCheked.length === conditions.length) {
      group[0].set('v.checked', true);
    } else {
      group[0].set('v.checked', false);
      $A.util.addClass(group[0], 'indeterminated');
    }
  },

  handleContinue: function(cmp, event, helper) {
    const viewMode = cmp.get('v.viewMode');
    var canContinue = false;
    const checked = cmp.find('checkbox').filter(c => c.get('v.checked'));

    const checkedInit = cmp.get('v.checkedInit');

    if (viewMode === 'flat') {
      canContinue = checked.length !== 0;
    } else {
      checked.forEach(item => {
        if (!checkedInit.includes(item.get('v.value'))) {
          canContinue = true;
        }
      });
    }

    if (!canContinue) {
      cmp.set('v.showNotChecked', true);
      setTimeout(function() {
        cmp.set('v.showNotChecked', false);
      }, 10000);

    } else {

      let conditionsSelected = [];
      checked.forEach(c => {
        conditionsSelected.push(c.get('v.value'));
      });

      let conditionsSelectContinueEvent = cmp.getEvent('conditionsSelectContinueEvt');
      conditionsSelectContinueEvent.setParams({
        viewMode: viewMode,
        conditionsSelected: conditionsSelected
      });
      conditionsSelectContinueEvent.fire();
      helper.destroyCmp(cmp, event, helper);
    }
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