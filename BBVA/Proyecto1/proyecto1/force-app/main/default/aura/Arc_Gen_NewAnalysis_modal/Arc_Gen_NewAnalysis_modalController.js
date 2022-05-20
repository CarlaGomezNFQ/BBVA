({
  doInit: function(component, event, helper) {
    // Check whether an ARCE is being resumed.
    const resumeArce = component.get('v.continue');
    const arceTypeToContinue = component.get('v.arceTypeToContinue');
    const resumeAnalysis = resumeArce && arceTypeToContinue === 'analysis';
    helper.getEEFFServiceCheck(component);

    component.set('v.loading', true);
    component.set('v.accountInfo.accounts', '[]');

    // Default to current account. If ARCE is analysis, this value will change.
    component.set('v.idofarceexecutor', component.get('v.recordId'));

    if (resumeArce) {
      component.set('v.selectedArceType', arceTypeToContinue);
      const getAccInfoPromise = helper.getfullaccountforservices(component);
      getAccInfoPromise.then(function() {
        component.set('v.currentStep', resumeAnalysis ? 'analysis' : 'raip');
        component.set('v.loading', false);
      }).catch(function() {
        component.set('v.errorMessage', 'Could not resume ARCE analysis. Please contact your system administrator.');
        component.set('v.loading', false);
      });
    } else {
      // Set list of steps.
      component.set('v.progressSteps', [
        { label: $A.get('{!$Label.c.Arc_Gen_Analysis_ST_ArceType}'), value: 'arceTypeSelection' },
        { label: $A.get('{!$Label.c.Arc_Gen_Analysis_ST_GroupStructure}'), value: 'groupStructure' },
        { label: $A.get('{!$Label.c.Arc_Gen_Analysis_ST_RedirectToARCE}'), value: 'redirectToArce' },
      ]);
      const hasCountry = helper.getCountryLocal(component);
      const getArceTypesPromise = helper.getAvailableArceTypes(component);
      const shouldShowGsPromise = helper.getShouldShowGroupStructureRaip(component);

      Promise.all([getArceTypesPromise, shouldShowGsPromise,hasCountry])
        .then(function(responses) {
          if(responses[2] === true) {
            const availableArces = responses[0];
            const shouldShowGsRaip = responses[1];

            component.set('v.availableArceTypes', availableArces);
            component.set('v.shouldShowGsRaip', shouldShowGsRaip);
            component.set('v.loading', false);
            helper.changeSubtitle(component);
          } else {
            component.set('v.errorMessage', 'ARCE cannot be started since the local client does not have the country of residence informed. Please update the country of residence in the relevant application and start the ARCE again');
            component.set('v.loading', false);
          }
        });
    }
  },

  changeArceSelection: function(component, event, helper) {
    component.set('v.selectedArceType', event.getParam('parameters').arceType);
    component.set('v.nextDisabled', false);
  },

  moveNext: function(component, event, helper) {
    component.set('v.errorMessage', '');
    switch (component.get('v.currentStep')) {
      case 'arceTypeSelection':
        helper.handleArceTypeNext(component);
        return;
      case 'groupStructure':
        helper.handleGroupStructureNext(component);
        return;
      case 'analysis': {
        // Propagate next event into wizard component.
        component.set('v.nextDisabled', true);
        const analysisWizard = component.find('analysis-wizard');
        analysisWizard.onNext();
        return;
      }
      case 'raip': {
        // Propagate next event into wizard component.
        const raipWizard = component.find('raip-wizard');
        raipWizard.onNext();
        return;
      }
    }
  },

  moveBack: function(component, event, helper) {
    component.set('v.errorMessage', '');
    switch (component.get('v.currentStep')) {
      case 'groupStructure':
        component.set('v.currentStep', 'arceTypeSelection');
        component.set('v.currentProgressStep', 'arceTypeSelection');
        component.set('v.backHidden', true);
        helper.changeSubtitle(component);
        return;
      case 'analysis': {
        // Propagate back event into wizard component.
        const analysisWizard = component.find('analysis-wizard');
        analysisWizard.onBack();
        return;
      }
      case 'raip': {
        // Propagate next event into wizard component.
        const raipWizard = component.find('raip-wizard');
        raipWizard.onNext();
        return;
      }
    }
  },

  closeModal: function(component, event, helper) {
    const showCloseButton = component.get('v.showCloseButton');
    if (showCloseButton) {
      // Custom close behaviour.
      const closeModalEvent = component.getEvent('closeModalEvent');
      closeModalEvent.fire();
    } else {
      // Standard quick action close.
      $A.get('e.force:closeQuickAction').fire();
    }
  },

  closeModalCustom: function(component, event, helper) {
    const closeModalEvent = component.getEvent('closeModalEvent');
    closeModalEvent.fire();
  },
  /* eslint-disable */
  handleWizardEvent: function(component, event, helper) {
    const eventType = event.getParam('eventType');
    const parameters = event.getParam('parameters');

    switch (eventType) {
      case 'nextEnable':
        component.set('v.nextDisabled', !parameters.enabled);
        break;
      case 'goBack':
        helper.handleWizardBack(component);
        break;
      case 'hideBack':
        component.set('v.backHidden', parameters.hidden);
        break;
      case 'setLoading':
        helper.evalSetLoading(component, parameters);
        break;
      case 'redirectToArce':
        helper.handleRedirect(component, parameters.arceId, parameters.arceNotInScope, parameters.riskSegment);
        break;
      case 'showSubtitle':
        component.set('v.subtitleText', parameters.text);
        break;
      case 'showWarning':
        component.set('v.warningMessage', parameters.warning);
        component.set('v.nextDisabled', true);
        break;
      case 'showError':
        component.set('v.errorMessage', parameters.error);
        component.set('v.nextDisabled', true);
        break;
      case 'setProgressSteps':
        component.set('v.progressSteps', parameters.steps);
        break;
      case 'setCurrentProgressStep':
        component.set('v.currentProgressStep', parameters.step);
        break;
      case 'renovationMessage':
        helper.showRenovationMessage(component, parameters.arceId);
    }
  }
  /* eslint-enable */
});