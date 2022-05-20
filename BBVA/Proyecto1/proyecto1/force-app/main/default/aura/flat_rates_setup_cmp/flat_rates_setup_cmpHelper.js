({
  getFlatRatesSetupInfo: function(cmp, evt, helper) {
    $A.util.removeClass(cmp.find('simpleSpinner'), 'slds-hide');
    let recordId = cmp.get('v.recordId');
    if (recordId === undefined) {
      helper.showNewToastFlatRatesSetup('warning', $A.get('$Label.cuco.flat_rates_missing_data'), 'pester');
      helper.destroyCmp(cmp, evt, helper);
    } else {
      let action = cmp.get('c.getFlatRatesSetupInfo');
      action.setParams({
        'recordId': cmp.get('v.recordId'),
        'lstConditions': cmp.get('v.conditionsSelected')
      });
      action.setCallback(this, function(response) {
        $A.util.addClass(cmp.find('simpleSpinner'), 'slds-hide');
        if (response.getState() === 'SUCCESS') {
          let ret = response.getReturnValue();
          cmp.set('v.hasDynamicPricing', ret.dynamicPricing);
          cmp.set('v.paTypology', ret.typology);
          helper.handleFirstSectionData(cmp, ret);
          helper.handleSecondSectionData(cmp, ret);
          helper.handleThirdSectionData(cmp, ret);
          cmp.set('v.isSuccess', true);
        } else if (response.getState() === 'ERROR') {
          helper.showNewToastFlatRatesSetup('error', response.getError()[0].message, 'sticky');
        }
      });
      $A.enqueueAction(action);
    }
  },
  handleFirstSectionData: function(cmp, ret) { //NOSONAR
    let firstSectionData = ret.firstSection;
    if (firstSectionData.requestedFlatRate !== undefined) {
      cmp.set('v.requestedFlatRate', firstSectionData.requestedFlatRate);
      cmp.set('v.currentPriceType', firstSectionData.requestedFlatRate.priceType);
    } else {
      cmp.set('v.requestedFlatRate', {});
    }
    cmp.set('v.labelsFlatRate', firstSectionData.labelsFlatRate);
    cmp.set('v.accountComments', firstSectionData.accountComments);

    // Iteration to change key values of object for lightning select
    let picklistFlatRatesObj = {};
    Object.entries(firstSectionData.picklistFlatRate).forEach(([key, value]) => {
      let newArr = [];
      value.forEach(function(picklistValue) {
        let newValue = {};
        newValue.label = picklistValue.value;
        newValue.value = picklistValue.apiName;
        newArr.push(newValue);
      });
      picklistFlatRatesObj[key] = newArr;
    });
    cmp.set('v.picklistFlatRate', picklistFlatRatesObj);

    if (firstSectionData.currentPSFlatRate !== undefined) {
      // Iteration to set label values from api values on actual col
      let currentPSFlatRate = {};
      Object.entries(firstSectionData.currentPSFlatRate).forEach(([key, value]) => {
        if (typeof value === 'string') {
          Object.entries(picklistFlatRatesObj).forEach(([picklistKey, picklistValues]) => {
            if (picklistKey === key) {
              picklistValues.forEach(function(pValue) {
                if (pValue.value === value) {
                  currentPSFlatRate[key] = pValue.label;
                }
              });
            }
          });
        }
      });
      cmp.set('v.currentPSFlatRate', currentPSFlatRate);
    }
  },
  handleSecondSectionData: function(cmp, ret) {
    let paFlatRateAcc = ret.secondSection.paFlatRateAcc;
    let psCatFlatRatesAcc = ret.secondSection.psCatFlatRatesAcc;

    let paFlatRateAccs = [];
    if (paFlatRateAcc !== undefined) {
      paFlatRateAcc.forEach(function(paFRAcc) {
        let paFlatRateAccObj = {};
        paFlatRateAccObj.id = paFRAcc.Id;
        paFlatRateAccObj.usePercent = paFRAcc.cuco__gf_pa_fr_ac_use_per__c;
        paFlatRateAccObj.name = paFRAcc.cuco__gf_pa_flat_rate_account_id__r.Name;
        paFlatRateAccObj.accId = paFRAcc.cuco__gf_pa_flat_rate_account_id__r.Id;
        paFlatRateAccs.push(paFlatRateAccObj);
      });
    } else {
      paFlatRateAccs.push({});
    }

    cmp.set('v.paFlatRateAccs', paFlatRateAccs);

    let pygCatAccs = [];
    psCatFlatRatesAcc.forEach(function(accCatFlatRates) {
      let pygAccObj = {};
      pygAccObj.id = accCatFlatRates.Id;
      pygAccObj.name = accCatFlatRates.Name;
      pygAccObj.description = accCatFlatRates.cuco__gf_psc_flat_rate_ac_desc__c;
      pygAccObj.code = accCatFlatRates.cuco__gf_psc_flat_rate_ac_id__c;
      pygCatAccs.push(pygAccObj);
    });
    cmp.set('v.pygCatAccs', pygCatAccs);
  },
  handleThirdSectionData: function(cmp, ret) {
    let thirdSectionData = ret.thirdSection;
    cmp.set('v.lstConditions', thirdSectionData.lstConditions);
  },
  doFormValidations: function(cmp, evt, helper) {
    let hasErrors = false;
    let firstValidateHasErr = helper.validateRequiredFields(cmp, evt, helper);     // First validation: Required fields filled

    if (!firstValidateHasErr) {
      hasErrors = helper.validatePyGAccs(cmp, evt, helper); // Second validation: Validate PyG Accs
    } else {
      hasErrors = true;
    }
    return hasErrors;
  },
  validateRequiredFields: function(cmp, evt, helper) {
    let labelsFlatRate = cmp.get('v.labelsFlatRate');
    let currentPriceType = cmp.find('priceType').get('v.value');
    let valuesMap = new Map();
    let hasErrors = false;

    if (currentPriceType === 'EF') { // Variable
      valuesMap.set(labelsFlatRate.variableAmountDesc, cmp.find('variableAmountDesc').get('v.value'));
    } else if (currentPriceType === 'IF') { // Fixed
      valuesMap.set(labelsFlatRate.fixedAmount, cmp.find('fixedAmount').get('v.value'));
    } else {
      valuesMap.set(labelsFlatRate.priceType, cmp.find('priceType').get('v.value'));
    }

    valuesMap.set(labelsFlatRate.chargeType, cmp.find('chargeType').get('v.value'));
    valuesMap.set(labelsFlatRate.periodicityChageType, cmp.find('periodicityChageType').get('v.value'));
    valuesMap.set(labelsFlatRate.currencyType, cmp.find('currencyType').get('v.value'));
    valuesMap.set(labelsFlatRate.chargeDay, cmp.find('chargeDay').get('v.value'));
    valuesMap.set(labelsFlatRate.nonWorkingDayChargeMethod, cmp.find('nonWorkingDayChargeMethod').get('v.value'));
    valuesMap.set(labelsFlatRate.accWithoutBalanceMethod, cmp.find('accWithoutBalanceMethod').get('v.value'));
    valuesMap.set(labelsFlatRate.invoceComments, cmp.find('invoceComments').get('v.value'));

    let errFieldsArr = [];
    valuesMap.forEach((values, keys) => {
      if (values === undefined || values === '') {
        errFieldsArr.push(keys);
      }
    });

    if (errFieldsArr.length !== 0) {
      helper.showNewToastFlatRatesSetup('error', $A.get('$Label.cuco.flat_rates_mandatory_fields') +  ' ' + errFieldsArr.join(', '), 'sticky');
      hasErrors = true;
    }
    return hasErrors;
  },
  validatePyGAccs: function(cmp, evt, helper) {
    let hasErrors = false;
    let paFlatRateAccs = cmp.find('paFlatRateAcc');
    let usePercentValues = cmp.find('usePercent');
    if (!paFlatRateAccs) {
      hasErrors = true;
      helper.showNewToastFlatRatesSetup('error', $A.get('$Label.cuco.flat_rates_minimum_accounts'), 'sticky');
    } else {

      // Get values
      let accountValues = [];
      let percentValues = [];
      if ($A.util.isArray(paFlatRateAccs)) {
        paFlatRateAccs.forEach(paFlatRateAcc => {
          accountValues.push(paFlatRateAcc.get('v.value'));
        });
        usePercentValues.forEach(usePercentValue => {
          percentValues.push(usePercentValue.get('v.value'));
        });
      } else {
        accountValues.push(paFlatRateAccs.get('v.value'));
        percentValues.push(usePercentValues.get('v.value'));
      }

      // Do validations use percent value
      let percentValuesErr = false;
      percentValues.forEach(percentValue => {
        if (percentValue === undefined || percentValue === '') {
          hasErrors = true;
          percentValuesErr = true;
        }
      });
      if (percentValuesErr) {
        helper.showNewToastFlatRatesSetup('error', $A.get('$Label.cuco.flat_rates_mandatory_info_accounts'), 'sticky');
      } else {

        // Do validations accounts
        let hasDuplicates = helper.checkArrDuplicates(accountValues);
        if (hasDuplicates) {
          hasErrors = true;
          helper.showNewToastFlatRatesSetup('error', $A.get('$Label.cuco.flat_rates_duplicated_accounts'), 'sticky');
        }
      }
    }
    return hasErrors;
  },
  checkArrDuplicates: function(arr) {
    let hasDuplicates = false;
    for (let i = 0; i < arr.length; i++) {
      for (let j = 0; j < arr.length; j++) {
        if (i !== j) {
          if (arr[i] === arr[j]) {
            hasDuplicates = true;
            break;
          }
        }
      }
      if (hasDuplicates) {
        break;
      }
    }
    return hasDuplicates;
  },
  getFormValues: function(cmp, evt, helper) {
    let formValuesMap = {};
    let flatRatesMap = {};
    let flatRatesAccountsArr = [];
    let flatRatesConditionArr = [];

    // Flat Rates values
    let currentPriceType = cmp.find('priceType').get('v.value');
    flatRatesMap.priceType = currentPriceType;
    if (currentPriceType === 'EF') { // Variable
      flatRatesMap.variableAmountDesc = cmp.find('variableAmountDesc').get('v.value');
    } else if (currentPriceType === 'IF') { // Fixed
      flatRatesMap.fixedAmount = cmp.find('fixedAmount').get('v.value');
    }
    flatRatesMap.chargeType = cmp.find('chargeType').get('v.value');
    flatRatesMap.periodicityChageType = cmp.find('periodicityChageType').get('v.value');
    flatRatesMap.currencyType = cmp.find('currencyType').get('v.value');
    flatRatesMap.chargeDay = cmp.find('chargeDay').get('v.value');
    flatRatesMap.nonWorkingDayChargeMethod = cmp.find('nonWorkingDayChargeMethod').get('v.value');
    flatRatesMap.accWithoutBalanceMethod = cmp.find('accWithoutBalanceMethod').get('v.value');
    flatRatesMap.invoceComments = cmp.find('invoceComments').get('v.value');
    flatRatesMap.accountComments = cmp.find('accountComments').get('v.value');
    formValuesMap.flatRates = flatRatesMap;

    // Flat Rates Accounts values
    let paFlatRateAccs = cmp.find('paFlatRateAcc');
    let usePercentValues = cmp.find('usePercent');
    let accountValuesArr = [];
    let percentValuesArr = [];
    if ($A.util.isArray(paFlatRateAccs)) {
      paFlatRateAccs.forEach(paFlatRateAcc => {
        accountValuesArr.push(paFlatRateAcc.get('v.value'));
      });
      usePercentValues.forEach(usePercentValue => {
        percentValuesArr.push(usePercentValue.get('v.value'));
      });
    } else {
      accountValuesArr.push(paFlatRateAccs.get('v.value'));
      percentValuesArr.push(usePercentValues.get('v.value'));
    }

    accountValuesArr.forEach(function(accValue, index) {
      let newAccObj = {
        accId: accValue,
        usePercent: percentValuesArr[index]
      };
      flatRatesAccountsArr.push(newAccObj);
    });
    formValuesMap.flatRatesAccounts = flatRatesAccountsArr;

    // Flat Rates Conditions values
    let conditionsValues = cmp.find('condition');
    let conditionsArr = [];
    let estOpVolArr = [];
    if (conditionsValues !== undefined) {
      if ($A.util.isArray(conditionsValues)) {
        conditionsValues.forEach(conditionValue => {
          conditionsArr.push(conditionValue.get('v.name'));
          estOpVolArr.push(conditionValue.get('v.value'));
        });
      } else {
        conditionsArr.push(conditionsValues.get('v.name'));
        estOpVolArr.push(conditionsValues.get('v.value'));
      }

      conditionsArr.forEach(function(conditionValue, index) {
        let newCondObj = {
          conditionId: conditionValue,
          estOpVol: estOpVolArr[index]
        };
        flatRatesConditionArr.push(newCondObj);
      });
    }
    formValuesMap.flatRatesConditions = flatRatesConditionArr;
    return formValuesMap;
  },
  checkSetupFlatRatesSetupPermissions: function(cmp, helper, paramsSetupFRS) {
    return new Promise($A.getCallback(function(resolve, reject) {
      let actionSetupFRS = cmp.get('c.checkSetupFlatRatesSetupPermissions');
      actionSetupFRS.setParams(paramsSetupFRS);
      actionSetupFRS.setCallback(this, function(responseSetupFRS) {
        if (responseSetupFRS.getState() === 'SUCCESS') {
          let retSetupFRS = responseSetupFRS.getReturnValue();
          resolve(retSetupFRS);
        } else if (responseSetupFRS.getState() === 'ERROR') {
          $A.util.addClass(cmp.find('simpleSpinner'), 'slds-hide');
          helper.showNewToastFlatRatesSetup('error', responseSetupFRS.getError()[0].message, 'sticky');
          reject(responseSetupFRS.getState());
        }
      });
      $A.enqueueAction(actionSetupFRS);
    }));
  },
  handleSetupFlatClick: function(cmp, evt, helper) {
    let profAnalysisId = cmp.get('v.recordId');
    let paramsInit = {
      profAnalysisId: profAnalysisId
    };
    helper.checkSetupFlatRatesSetupPermissions(cmp, helper, paramsInit).then(response => {
      if (response.setup) {
        let mapValues = helper.getFormValues(cmp, evt, helper);
        helper.doSaveActions(cmp, evt, helper, mapValues);
      } else {
        $A.util.addClass(cmp.find('simpleSpinner'), 'slds-hide');
        helper.showNewToastFlatRatesSetup('warning', response.setupMessage, 'sticky');
      }
    });
  },
  doSaveActions: function(cmp, evt, helper, mapValues) {
    let action = cmp.get('c.doFlatRatesSetupSave');
    action.setParams({
      'profAnalysisId': cmp.get('v.recordId'),
      'mapData': JSON.stringify(mapValues)
    });
    action.setCallback(this, function(response) {
      $A.util.addClass(cmp.find('simpleSpinner'), 'slds-hide');
      if (response.getState() === 'SUCCESS') {
        let ret = response.getReturnValue();
        if (ret.isSuccess) {
          let hasDynamicPricing = cmp.get('v.hasDynamicPricing');
          if (hasDynamicPricing) {
            let paFlatRateId = ret.profAnalysisFlatRateId;
            let profAnalysisId = cmp.get('v.recordId');
            let flatRatesSetupContinueEvt = cmp.getEvent('flatRatesSetupContinueEvt');
            flatRatesSetupContinueEvt.setParams({
              contextId: profAnalysisId,
              profAnalysisFlatRateId: paFlatRateId
            });
            flatRatesSetupContinueEvt.fire();
            helper.destroyCmp(cmp, evt, helper);
          } else {
            helper.showNewToastFlatRatesSetup('success', $A.get('$Label.cuco.flat_rates_setup_success'), 'sticky');

            // Refresh flat event
            let compEventRefreshFlatRates = $A.get('e.cuco:refresh_flat_rates_evt');
            compEventRefreshFlatRates.setParams({'contextId': cmp.get('v.recordId')});
            compEventRefreshFlatRates.fire();

            // Refresh conditions evt
            let appEventFlatRefreshConditions = $A.get('e.cuco:refresh_conditions_evt');
            appEventFlatRefreshConditions.setParams({
              'contextId': cmp.get('v.recordId')
            });
            appEventFlatRefreshConditions.fire();
            helper.destroyCmp(cmp, evt, helper);
          }
        } else {
          helper.showNewToastFlatRatesSetup('error', $A.get('$Label.cuco.flat_rates_flat_save_error') + ' (' + ret.errMessage + ')', 'sticky');
        }
      } else if (response.getState() === 'ERROR') {
        helper.showNewToastFlatRatesSetup('error', response.getError()[0].message, 'sticky');
      }
    });
    $A.enqueueAction(action);
  },
  showNewToastFlatRatesSetup: function(type, message, mode) {
    let titleFlatRatesSetupToast;
    switch (type) {
      case 'success':
        titleFlatRatesSetupToast = $A.get('$Label.cuco.toast_title_success');
        break;
      case 'warning':
        titleFlatRatesSetupToast = $A.get('$Label.cuco.toast_title_warning');
        break;
      case 'error':
        titleFlatRatesSetupToast = $A.get('$Label.cuco.toast_title_error');
        break;
    }
    var newFlatRatesSetupToast = $A.get('e.force:showToast');
    newFlatRatesSetupToast.setParams({
      'mode': mode,
      'title': titleFlatRatesSetupToast,
      'type': type,
      'message': message
    });
    newFlatRatesSetupToast.fire();
  }
});