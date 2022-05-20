({
  doInit: function(component, event, helper) {
    var action = component.get('c.getDPData');
    action.setParams({
      flatRateId: component.get('v.profAnalysisFlatRateId')
    });
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (state === 'SUCCESS') {
        var respuesta = response.getReturnValue();
        component.set('v.mapToHandle', JSON.stringify(respuesta));
        respuesta.mapNonCross.forEach(item => item.expanded = true);
        component.set('v.mapNonCross', respuesta.mapNonCross);
        component.set('v.lstCross', respuesta.lstCross);
        component.set('v.dpAttNonCross', respuesta.mapAttNonCross);
        component.set('v.dpAttCross', respuesta.setDPAttCross);
        component.set('v.flatRate', respuesta.flatRate);
        $A.util.addClass(component.find('simpleSpinner'), 'slds-hide');
      }
    });
    $A.enqueueAction(action);
  },
  saveContinue: function(component, event, helper) {
    var inputsNonCross = component.find('inputsNonCross');
    var inputsCross = component.find('inputsCross');

    let lst2Insert = [];
    let lst2Update = [];
    let lst2Delete = [];

    let mapValuesCross = new Map();
    inputsCross.forEach(function(input) {
      let inputArr = input.get('v.name').split('#');
      let inputValue = input.get('v.value');
      if (mapValuesCross.get(inputArr[1])) {
        let currentObj = mapValuesCross.get(inputArr[1]);
        let currentArrAtb = currentObj.attb;
        let attbObj = {};
        attbObj.id = inputArr[2];
        attbObj.value = inputValue;
        currentArrAtb.push(attbObj);
        mapValuesCross.set(inputArr[1], currentObj);
      } else {
        let newObj = {};
        newObj.flatId = inputArr[0];
        newObj.flatName = inputArr[3];
        let attbObj = {};
        attbObj.id = inputArr[2];
        attbObj.value = inputValue;
        let atbArr = [];
        atbArr.push(attbObj);
        newObj.attb = atbArr;
        mapValuesCross.set(inputArr[1], newObj);
      }
    });

    mapValuesCross.forEach(function(obj, key) {
      let attbValues = [];
      obj.attb.forEach(function(attb) {
        attbValues.push(attb.value);
      });
      let emptyValues = attbValues.every(e  => e === '' || e === undefined);
      obj.dynamicPricingId = key;
      if ((obj.flatId === '' || obj.flatId === undefined) && !emptyValues) {
        lst2Insert.push(obj);
      } else if (obj.flatId !== '' && obj.flatId !== undefined && !emptyValues) {
        lst2Update.push(obj);
      } else if (obj.flatId !== '' && obj.flatId !== undefined && emptyValues) {
        lst2Delete.push(obj);
      }
    });

    let mapValuesNonCross = new Map();
    inputsNonCross.forEach(function(input) {
      let inputArr = input.get('v.name').split('#');
      let inputValue = input.get('v.value');
      if (mapValuesNonCross.get(inputArr[1])) {
        let currentObj = mapValuesNonCross.get(inputArr[1]);
        let currentArrAtb = currentObj.attb;
        let attbObj = {};
        attbObj.id = inputArr[2];
        attbObj.value = inputValue;
        currentArrAtb.push(attbObj);
        mapValuesNonCross.set(inputArr[1], currentObj);
      } else {
        let newObj = {};
        newObj.flatId = inputArr[0];
        newObj.flatName = inputArr[3];
        let attbObj = {};
        attbObj.id = inputArr[2];
        attbObj.value = inputValue;
        let atbArr = [];
        atbArr.push(attbObj);
        newObj.attb = atbArr;
        mapValuesNonCross.set(inputArr[1], newObj);
      }
    });

    let errLst = [];
    // eslint-disable-next-line complexity
    mapValuesNonCross.forEach(function(obj, key) {
      let attbValues = [];
      obj.attb.forEach(function(attb) {
        attbValues.push(attb.value);
      });
      let emptyValues = attbValues.every(e  => e === '' || e === undefined);
      let filledValues = attbValues.every(e  => e !== '' && e !== undefined);
      if (!emptyValues && !filledValues) {
        errLst.push(obj);
      } else {
        obj.dynamicPricingId = key;
        if ((obj.flatId === '' || obj.flatId === undefined) && filledValues) {
          lst2Insert.push(obj);
        } else if (obj.flatId !== '' && obj.flatId !== undefined && filledValues) {
          lst2Update.push(obj);
        } else if (obj.flatId !== '' && obj.flatId !== undefined && emptyValues) {
          lst2Delete.push(obj);
        }
      }
    });

    if (errLst.length === 0) {
      let objValues = {};
      objValues.lst2Insert = lst2Insert;
      objValues.lst2Update = lst2Update;
      objValues.lst2Delete = lst2Delete;

      // Get detail content
      var action = component.get('c.doSaveActions');

      action.setParams({
        'strValues': JSON.stringify(objValues),
        'profAnFlatRateId': component.get('v.profAnalysisFlatRateId')
      });
      action.setCallback(this, function(response) {
        var state = response.getState();
        if (component.isValid() && state === 'SUCCESS') {
          var ret = response.getReturnValue();
          if (ret.success === true) {
            helper.showNewToastFlag('success', $A.get('$Label.cuco.flat_rates_setup_success'));

            // Refresh flat cmp
            let appEvent = $A.get('e.cuco:refresh_flat_rates_evt');
            appEvent.setParams({
              'contextId': component.get('v.flatRate').cuco__gf_profitablity_analysis_id__c
            });
            appEvent.fire();

            // Refresh condition  evt
            let appEventDynamicRefreshConditions = $A.get('e.cuco:refresh_conditions_evt');
            appEventDynamicRefreshConditions.setParams({
              'contextId': component.get('v.flatRate').cuco__gf_profitablity_analysis_id__c
            });
            appEventDynamicRefreshConditions.fire();
            component.destroy();
          } else {
            helper.showNewToastFlag('error', ret.message);
            component.destroy();
          }
        } else {
          helper.showNewToastFlag('error', response.getError()[0].message);
        }
      });
      $A.enqueueAction(action);
    } else {
      helper.showNewToastFlag('error', $A.get('$Label.cuco.dp_missing_error'));
    }
  },
  showNewToastFlag: function(type, message) {
    let titleFlagToast;
    switch (type) {
      case 'success':
        titleFlagToast = $A.get('$Label.cuco.toast_title_success');
        break;
      case 'warning':
        titleFlagToast = $A.get('$Label.cuco.toast_title_warning');
        break;
      case 'error':
        titleFlagToast = $A.get('$Label.cuco.toast_title_error');
        break;
    }
    var newFlagToast = $A.get('e.force:showToast');
    newFlagToast.setParams({
      'title': titleFlagToast,
      'type': type,
      'message': message
    });
    newFlagToast.fire();
  }
});