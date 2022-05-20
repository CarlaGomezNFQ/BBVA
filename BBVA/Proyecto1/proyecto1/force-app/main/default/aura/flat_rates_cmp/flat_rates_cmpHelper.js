({
  getFlatRatesInfo: function(cmp, evt, helper) {
    $A.util.removeClass(cmp.find('simpleSpinner'), 'slds-hide');
    let action = cmp.get('c.getFlatRatesInfo');
    action.setParams({
      'recordId': cmp.get('v.recordId')
    });
    action.setCallback(this, function(response) { // eslint-disable-line max-statements
      $A.util.addClass(cmp.find('simpleSpinner'), 'slds-hide');
      if (response.getState() === 'SUCCESS') {
        let ret = response.getReturnValue();
        let flatRates;
        let sObjectName = cmp.get('v.sObjectName');
        let hasError = false;
        if (sObjectName === 'cuco__profitability_analysis__c') {
          flatRates = ret.flatRatesWrapper.flatRates;
        } else {
          if (ret.success) {
            if (ret.flatRatesWrapper.profSheetDetails !== undefined) {
              flatRates = ret.flatRatesWrapper.profSheetDetails.flatRates;
            }
          } else {
            hasError = true;
            cmp.set('v.errMessage', ret.errorMessage);
          }
        }

        if (!hasError) {
          if (sObjectName === 'cuco__profitability_analysis__c') {
            cmp.set('v.showButtons', true);
            cmp.set('v.canSetupFlatRates', ret.setup);
            cmp.set('v.canRemoveFlatRates', ret.remove);
            cmp.set('v.profAnalysisTypology', ret.typology);
            let newRawConditions = [];
            ret.rawConditions.forEach(function(item) {
              if (item.source !== undefined) {
                newRawConditions.push(item);
              }
            });
            cmp.set('v.rawConditions', newRawConditions);
            helper.checkBannerVisbility(cmp, ret.typology, flatRates);
          } else {
            cmp.set('v.showButtons', false);
            cmp.set('v.showBannerError', false);
          }

          if (flatRates === undefined) {
            cmp.set('v.errMessage', $A.get('$Label.cuco.flat_rates_no_information'));
            cmp.set('v.showError', true);
            cmp.set('v.flatRates', flatRates);
          } else if (!ret.flatRatesWrapper.success) {
            cmp.set('v.errMessage', ret.flatRatesWrapper.errorMessage);
            cmp.set('v.showError', true);
            cmp.set('v.flatRates', flatRates);
          } else {
            helper.setStatus(cmp, flatRates.requestType);
            cmp.set('v.fieldLabelsMap', ret.fieldLabelsMap);
            cmp.set('v.picklistValuesMap', ret.picklistValuesMap);
            cmp.set('v.flatRatesId', ret.flatRatesId);
            cmp.set('v.flatRates', flatRates);
            cmp.set('v.pygData', ret.pygData);
            cmp.set('v.condData', ret.conditionsData);
            cmp.set('v.hasDynamicPricing', ret.dynamicPricing);
            cmp.set('v.showError', false);
          }
        }
      } else if (response.getState() === 'ERROR') {
        helper.showNewToastFlatRates('error', response.getError()[0].message);
      }
    });
    $A.enqueueAction(action);
  },
  setStatus: function(cmp, requestType) {
    let statusValue;
    if (requestType === undefined) {
      statusValue = $A.get('$Label.cuco.flat_valid_status');
    } else {
      switch (requestType) {
        case 'New':
          statusValue = $A.get('$Label.cuco.flat_creation_request');
          break;
        case 'Cancellation':
          statusValue = $A.get('$Label.cuco.flat_cancellation_request');
          break;
        case 'Modification':
          statusValue = $A.get('$Label.cuco.flat_modification_request');
          break;
      }
    }
    cmp.set('v.statusValue', statusValue);
  },
  checkBannerVisbility: function(cmp, typology, flatRates) {
    if ((typology === 'Renewal' || typology === 'Novation')
    && flatRates.priceType === 'EF'
    && flatRates.requestType !== 'Cancellation'
    && flatRates.variableAmountDesc === undefined) {
      cmp.set('v.showBannerError', true);
    } else {
      cmp.set('v.showBannerError', false);
    }
  },
  checkSetupFlatRatesPermissions: function(cmp, helper, paramsSetupFR) {
    return new Promise($A.getCallback(function(resolve, reject) {
      let actionSetupFR = cmp.get('c.checkSetupFlatRatesPermissions');
      actionSetupFR.setParams(paramsSetupFR);
      actionSetupFR.setCallback(this, function(responseSetupFR) {
        if (responseSetupFR.getState() === 'SUCCESS') {
          let retSetupFR = responseSetupFR.getReturnValue();
          resolve(retSetupFR);
        } else if (responseSetupFR.getState() === 'ERROR') {
          $A.util.addClass(cmp.find('simpleSpinner'), 'slds-hide');
          helper.showNewToastFlatRates('error', responseSetupFR.getError()[0].message);
          reject(responseSetupFR.getState());
        }
      });
      $A.enqueueAction(actionSetupFR);
    }));
  },
  checkRemoveFlatRatesPermissions: function(cmp, helper, paramsRemove) {
    return new Promise($A.getCallback(function(resolve, reject) {
      let actionRemove = cmp.get('c.checkRemoveFlatRatesPermissions');
      actionRemove.setParams(paramsRemove);
      actionRemove.setCallback(this, function(responseRemove) {
        if (responseRemove.getState() === 'SUCCESS') {
          let retRemove = responseRemove.getReturnValue();
          resolve(retRemove);
        } else if (responseRemove.getState() === 'ERROR') {
          $A.util.addClass(cmp.find('simpleSpinner'), 'slds-hide');
          helper.showNewToastFlatRates('error', responseRemove.getError()[0].message);
          reject(responseRemove.getState());
        }
      });
      $A.enqueueAction(actionRemove);
    }));
  },
  showFlatRatesNextCmp: function(cmp, helper, nextCmpName, nextCmpParams) {
    helper.createFlatRatesNextCmp(cmp, helper, nextCmpName, nextCmpParams).then($A.getCallback(newCmp => {
      $A.util.addClass(cmp.find('simpleSpinner'), 'slds-hide');
      let body = [];
      body.push(newCmp);
      cmp.set('v.body', body);
    }));
  },
  createFlatRatesNextCmp: function(cmp, helper, cmpName, cmpParams) {
    return new Promise($A.getCallback(function(resolve, reject) {
      $A.createComponent(
        'cuco:' + cmpName,
        cmpParams,
        function(newCmp, status, errorMessage) {
          if (status === 'SUCCESS') {
            resolve(newCmp);
          } else if (status === 'INCOMPLETE' || status === 'ERROR') {
            $A.util.addClass(cmp.find('simpleSpinner'), 'slds-hide');
            helper.showNewToastFlatRates('error', errorMessage);
          }
        }
      );
    }));
  },
  handleConditionsSelectContinue: function(cmp, evt, helper) {
    if (evt.getParam('viewMode') === 'flat') {
      var conditionsSelected = evt.getParam('conditionsSelected');
      let attr = {
        recordId: cmp.get('v.recordId'),
        conditionsSelected: conditionsSelected,
      };
      helper.showFlatRatesNextCmp(cmp, helper, 'flat_rates_setup_cmp', attr);
    }
  },
  handleFlatRatesSetup: function(cmp, evt, helper) {
    let profAnalysisId = cmp.get('v.recordId');
    if (evt.getParam('contextId') === profAnalysisId) {
      let params = {
        profAnalysisFlatRateId: evt.getParam('profAnalysisFlatRateId'),
      };
      helper.showFlatRatesNextCmp(cmp, helper, 'dynamic_pricing_setup_cmp', params);
    }
  },
  showNewToastFlatRates: function(type, message) {
    let titleFlatRatesToast;
    switch (type) {
      case 'success':
        titleFlatRatesToast = $A.get('$Label.cuco.toast_title_success');
        break;
      case 'warning':
        titleFlatRatesToast = $A.get('$Label.cuco.toast_title_warning');
        break;
      case 'error':
        titleFlatRatesToast = $A.get('$Label.cuco.toast_title_error');
        break;
    }
    var newFlatRatesToast = $A.get('e.force:showToast');
    newFlatRatesToast.setParams({
      'title': titleFlatRatesToast,
      'type': type,
      'message': message
    });
    newFlatRatesToast.fire();
  }
});