({
  doInit: function(component, event, helper) {
    let initialPromise = helper.checkGlobalRunWayConfig(component);
    const alertEEFF = $A.get('$Label.c.Arce_Gen_MsgEEFFLessHundredMil');
    initialPromise.then(function() {
      if (component.get('v.currentStep') === 'ffss') {
        helper.onInit(component, event, helper);
        if (!(alertEEFF.length <= 1)) {
          component.set('v.warningEEFF', alertEEFF.split('<br>'));
        }
      } else {
        helper.setProgressStep(component, 'globalRunWay');
        helper.getURLConfig(component);
        component.set('v.initialized', true);
        helper.hideBackButton(component);
        helper.setLoading(component, false);
        helper.enableNextButton(component, false);
        helper.changeSubtitle(component);
        helper.hideBackButton(component);
        const irpwfv2 = component.get('v.isRAIPSelectWorkflow');
        if (irpwfv2) {
          helper.setProgressStep(component, 'selectRAIPWf');
        } else {
          helper.setProgressStep(component, 'ffss');
        }
      }
    }).catch(function() {
      helper.handleCatchError(component);
    });
  },

  handleFfssSelection: function(component, event, helper) {

    let initialPromise = helper.checkRatingTypeByModel(component, event, helper);
    initialPromise.then(function() {
      const isValid = event.getParam('isValidFfss');
      const wasValid = component.get('v.ffssValid');
      component.set('v.ffssValid', isValid);
      component.set('v.ffssSelected', true);

      // Set 'pre-rating' if FFSS is not valid.
      if (!wasValid && isValid) {
        component.set('v.ratingType', '');
        helper.enableNextButton(component, false);
      } else if (!isValid) {
        component.set('v.ratingType', 'prerating');
        helper.enableNextButton(component, true);
      }
    }).catch(function() {
      helper.showError(component, $A.get('There is a problem with FFSS selection'));
    });
  },

  handleRatingTypeChange: function(component, event, helper) {
    helper.enableNextButton(component, true);
  },

  handleRatingToolChange: function(component, event, helper) {
    const selectedTool = event.getParam('value');
    component.set('v.rtngToolSlctd', selectedTool);
    let concatSlctdTool = component.get('v.modlSlctd') ? component.get('v.modlSlctd').concat(component.get('v.irpTypeSlctd'), component.get('v.rtngToolSlctd')) : selectedTool;
    component.set('v.ratingTool', concatSlctdTool);
    helper.enableNextButton(component, selectedTool != null); // eslint-disable-line
  },

  handleNext: function(component, event, helper) {
    const currentStep = component.get('v.currentStep');
    switch (currentStep) {
      case 'globalRunWay':
        helper.handleGlobalRunWayNext(component, event, helper);
        break;
      case 'ffss':
        helper.handleFfssNext(component);
        helper.callbackSuscribe(component, event, helper);
        break;
      case 'tool':
        helper.handleToolNext(component);
        helper.unsubscribe(component);
        break;
      case 'selectRAIPWf':
        helper.handleWFV2Next(component, event, helper);
        break;
      case 'selectModel':
        component.set('v.currentStep', 'selectRAIPWf');
        helper.changeSubtitle(component);
        helper.setWizardSteps(component);
        break;
    }
  },
  handleChange: function(component, event, helper) {
    let selectedIrp = component.get('v.RAIPSelectComboValue');
    component.set('v.irpTypeSlctd', selectedIrp);
    let rarRatingTool = component.get('v.IRPRarRatingTool');
    if (selectedIrp === $A.get('{!$Label.arce.Arc_Gen_NewRaipOverrideApi}') && rarRatingTool) {
      helper.enableNextButton(component, true);
    } else if (selectedIrp === $A.get('{!$Label.arce.Arc_Gen_NewRaipAdjustmentApi}') || selectedIrp === $A.get('{!$Label.arce.Arc_Gen_NewRaipRatingApi}')) {
      helper.enableNextButton(component, true);
    } else if (selectedIrp === $A.get('{!$Label.arce.Arc_Gen_NewRaipOverrideApi}')) {
      helper.enableNextButton(component, false);
    }
  },
  handleRedirectChange: function(component, event, helper) {
    var target = event.getSource();
    component.set('v.redirectToExternalOrg', target.get('v.value'));
    helper.enableNextButton(component, true);
  },
  selectModl: function(component, event, helper) {
    const getOptionsWf = helper.getLabelCombo(component);
    getOptionsWf.then(function(optns) {
      component.set('v.options', optns);
      helper.enableNextButton(component, true);
    }).catch($A.getCallback(function() {
      helper.setLoading(component, false);
      helper.showError(component, $A.get('{!$Label.c.Lc_arce_NewARCE_UnexpectedError}'));
    }));
  }
});