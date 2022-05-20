({
  doInit: function(cmp, evt, helper) {
    helper.getFlatRatesInfo(cmp, evt, helper);
  },
  handleFlatRatesEvt: function(cmp, evt, helper) {
    let profAnalysisId = cmp.get('v.recordId');
    let contextId = evt.getParam('contextId');
    if (profAnalysisId === contextId) {
      helper.getFlatRatesInfo(cmp, evt, helper);
    }
  },
  handleSetupFlatClick: function(cmp, evt, helper) {
    $A.util.removeClass(cmp.find('simpleSpinner'), 'slds-hide');
    let profAnalysisId = cmp.get('v.recordId');
    let paramsInit = {
      profAnalysisId: profAnalysisId
    };
    helper.checkSetupFlatRatesPermissions(cmp, helper, paramsInit).then(response => {
      if (response.setup) {
        let newCmpParams = {
          profAnalysisId: profAnalysisId,
          viewMode: 'flat',
          paConditions: cmp.get('v.rawConditions')
        };
        helper.showFlatRatesNextCmp(cmp, helper, 'conditions_select_cmp', newCmpParams);
      } else {
        $A.util.addClass(cmp.find('simpleSpinner'), 'slds-hide');
        helper.showNewToastFlatRates('warning', response.setupMessage);
      }
    });
  },
  handleRemoveFlatClick: function(cmp, evt, helper) {
    $A.util.removeClass(cmp.find('simpleSpinner'), 'slds-hide');
    let profAnalysisId = cmp.get('v.recordId');
    let paramsInit = {
      profAnalysisId: profAnalysisId
    };
    helper.checkRemoveFlatRatesPermissions(cmp, helper, paramsInit).then(response => {
      if (response.remove) {
        let flatRatesId = cmp.get('v.flatRatesId');
        let newCmpParams = {
          profAnalysisFlatRatesId: flatRatesId
        };
        helper.showFlatRatesNextCmp(cmp, helper, 'flat_rates_remove_cmp', newCmpParams);
      } else {
        $A.util.addClass(cmp.find('simpleSpinner'), 'slds-hide');
        helper.showNewToastFlatRates('warning', response.removeMessage);
      }
    });
  },
  handleConditionsSelectContinue: function(cmp, evt, helper) {
    helper.handleConditionsSelectContinue(cmp, evt, helper);
  },
  handleFlatRatesSetup: function(cmp, evt, helper) {
    helper.handleFlatRatesSetup(cmp, evt, helper);
  }
});