({
  handleSubprocessNext: function(component, event, helper) {
    var thisHelper = this;  // eslint-disable-line
    this.setLoading(component, true);
    var arceType =  'arceTypeSelection';
    var groupStructure =  'groupStructure';
    var subprocess =  'subprocess';
    var justification =  'justification';
    var warningmsg =  'warningmessage';
    var checklist =  'checklist';
    var sector =  'sector';
    var redirectToArce =  'redirectToArce';

    if (component.get('v.subprocess') === '3') {
      // Set list of steps.
      const wzrdEvent = component.getEvent('wizardEvent');
      wzrdEvent.setParams({
        'eventType': 'setProgressSteps',
        parameters: { 'steps': [
          { label: $A.get('{!$Label.c.Arc_Gen_Analysis_ST_ArceType}'), value: arceType },
          { label: $A.get('{!$Label.c.Arc_Gen_Analysis_ST_GroupStructure}'), value: groupStructure },
          { label: $A.get('{!$Label.c.Arc_Gen_Analysis_ST_Subprocess}'), value: subprocess },
          { label: $A.get('{!$Label.c.Arc_Gen_NewAnalysisStepThreeMod}'), value: justification },
          { label: $A.get('{!$Label.c.Arc_Gen_NewAnalysisStepFourMod}'), value: warningmsg },
          { label: $A.get('{!$Label.c.Arc_Gen_Analysis_ST_Checklist}'), value: checklist },
          { label: $A.get('{!$Label.c.Arc_Gen_Analysis_ST_Sector}'), value: sector },
          { label: $A.get('{!$Label.c.Arc_Gen_Analysis_ST_RedirectToARCE}'), value: redirectToArce }
        ]}
      });
      wzrdEvent.fire();
      thisHelper.setLoading(component, false);
      thisHelper.enableNextButton(component, false);
      component.set('v.currentStep', 'justification');
      thisHelper.setProgressStep(component, 'justification');
      thisHelper.changeSubtitle(component);
    } else if (component.get('v.subprocess') === '1') {
      thisHelper.flowArceMod(component)
        .then(function(result) {
          var resultObj = JSON.parse(result);
          component.set('v.analysisId', resultObj.analysisId);
          component.set('v.accHasAnalysisId', resultObj.groupAhaId);
          component.set('v.callCopyingPersistance', resultObj.persistanceStatus);
          thisHelper.setLoading(component, false);
          thisHelper.hideBackButton(component);
          thisHelper.enableNextButton(component, false);
          component.set('v.currentStep', 'checklist');
          thisHelper.setProgressStep(component, 'checklist');
          thisHelper.changeSubtitle(component);
        });
    } else {
      this.newAnalysis(component)
        .then(function() {
          thisHelper.setLoading(component, false);
          thisHelper.hideBackButton(component);
          thisHelper.enableNextButton(component, false);
          component.set('v.currentStep', 'checklist');
          thisHelper.setProgressStep(component, 'checklist');
          thisHelper.changeSubtitle(component);
        })
        .catch(function(err) {
          thisHelper.setLoading(component, false);
          thisHelper.showError(component, $A.get('{!$Label.c.Lc_arce_NewARCE_UnexpectedError}'));
          throw new Error(err[0].message);
        });
    }
  },

  handleJustificationNext: function(component) {
    var helper = this;  // eslint-disable-line
    this.setLoading(component, false);
    helper.enableNextButton(component, true);
    component.set('v.currentStep', 'warningmessage');
    helper.setProgressStep(component, 'warningmessage');
    helper.changeSubtitle(component);
  },

  handleWarningMessageNext: function(component) {
    var helper = this;  // eslint-disable-line
    helper.flowArceMod(component)
      .then(function(result) {
        var resultObj = JSON.parse(result);
        component.set('v.analysisId', resultObj.analysisId);
        component.set('v.accHasAnalysisId', resultObj.groupAhaId);
        component.set('v.callCopyingPersistance', resultObj.persistanceStatus);
        helper.setLoading(component, false);
        helper.enableNextButton(component, false);
        helper.hideBackButton(component);
        component.set('v.currentStep', 'checklist');
        helper.setProgressStep(component, 'checklist');
        helper.changeSubtitle(component);
      });
  },

  handleChecklistNext: function(component) {
    var helper = this;  // eslint-disable-line
    var callTriageEngine = component.get('v.callTriageEngine');
    this.setLoading(component, true);
    this.callPersistenceService(component)
      .then(function() {
        return component.get('v.accountInfo.isorphan') ? Promise.resolve() : helper.callEcoGroupParticipantsPer(component);
      })
      .then(function() {
        // Only call triage engine if configuration is true.
        return callTriageEngine ? helper.callTriageService(component) : Promise.resolve();
      })
      .then(function() {
        var persistanceInd = component.get('v.callCopyingPersistance');
        if (persistanceInd) {
          helper.copyingDataPersistance(component);
        }
      })
      .then(function() {
        helper.setLoading(component, false);
        helper.hideBackButton(component);
        helper.enableNextButton(component, false);
        component.set('v.currentStep', 'sector');
        helper.setProgressStep(component, 'sector');
        if (callTriageEngine) {
          helper.handleSectorNext(component);
        }
        helper.changeSubtitle(component);
      })
      .catch(function(err) {
        helper.setLoading(component, false);
        helper.showError(component, typeof(err) === 'string' ? err : $A.get('{!$Label.c.Lc_arce_NewARCE_UnexpectedError}'));
      });
  },

  handleSectorNext: function(component) {
    var helper = this;  // eslint-disable-line
    var callTriageEngine = component.get('v.callTriageEngine');
    this.setLoading(component, true);

    this.callPathService(component)
      .then(function() {
        var riskFilter = helper.callRiskFilters(component);
        riskFilter.then(function() {
          var updatearce;
          if (callTriageEngine) {
            updatearce = helper.updatesArceToPreparing(component, helper);
          } else {
            updatearce = helper.updateArceSectorAndStatus(component);
          }
          updatearce.then(function() {
            helper.redirectToArce(component, component.get('v.analysisId'));
          }).catch(function() {
            helper.showError(component, $A.get('{!$Label.c.Lc_arce_NewARCE_UnexpectedError}'));
            helper.setLoading(component, false);
          });
        }).catch(function() {
          helper.showError(component, $A.get('{!$Label.c.Lc_arce_NewARCE_UnexpectedError}'));
          helper.setLoading(component, false);
        });
      })
      .catch(function() {
        helper.showError(component, $A.get('{!$Label.c.Lc_arce_PathGeneralError}'));
        component.set('v.currentStep', 'checklist');
        helper.setLoading(component, false);
      });
  },

  copyingDataPersistance: function(component) {
    var helper = this;  // eslint-disable-line
    var participantType = 'GROUP';
    var isOrphan = component.get('v.accountInfo.isorphan');
    var action = component.get('c.callCreateCopyAssessments');
    var relatedAnalysisId = component.get('v.existingArceIdToModification');
    var subprocessType = component.get('v.subprocess');
    var analysisId = component.get('v.analysisId');
    var clientNumber = component.get('v.clientNumber');
    var groupAhaId = component.get('v.accHasAnalysisId');
    if (isOrphan) {
      participantType = 'SUBSIDIARY';
    }
    var parameters = {
      'relatedAnalysisId': relatedAnalysisId,
      'subprocessType': subprocessType,
      'participantType': participantType,
      'analysisId': analysisId,
      'clientNumber': clientNumber,
      'accHasAnalysisId': groupAhaId
    };
    action.setParams({
      data: parameters
    });

    return this.promisifyAndCallAction(action)
      .then(function(result) {
        var serviceCode = result.serviceCode;
        if (serviceCode === '201' || serviceCode === '202') {
          var resultsToastE = $A.get('e.force:showToast');
          resultsToastE.setParams({
            'title': $A.get('{!$Label.c.Lc_arce_Persistance_ToastTitle}'),
            'type': 'SUCCESS',
            'message': $A.get('{!$Label.c.Lc_arce_Persistance_ToastInitMsgOK}'),
            'duration': '5000'
          });
          resultsToastE.fire();
        } else {
          const errorMessage = $A.get('{!$Label.c.Lc_arce_Persistance_ToastInitMsgKO}') + result.serviceMessage;
          helper.showError(component, errorMessage);
          throw new Error(errorMessage);
        }
      })
      .catch(function(error) {
        helper.showError(component, $A.get('{!$Label.c.Lc_arce_Persistance_ToastInitMsgKO}' + error));
        throw new Error($A.get('{!$Label.c.Lc_arce_Persistance_ToastInitMsgKO}'));
      });
  },

  getPersistanceConfig: function(component, helper) {
    const action = component.get('c.getPersistanceCallConfig');
    helper.promisifyAndCallAction(action)
      .then(function(result) {
        var indicator = result;
        component.set('v.callCopyingPersistance', indicator);
      });
  },

  newAnalysis: function(component) {
    var helper = this;  // eslint-disable-line
    // Show spinner.
    this.setLoading(component, true);

    // Call server action.
    var recordId = component.get('v.recordId');
    var newAnalysis = component.get('c.setanalysis');

    var parameters = {
      'recordId': recordId,
      'isorphan': component.get('v.accountInfo.isorphan'),
      'orphanNumber': component.get('v.accountInfo.orphanNumber'),
      'accounts': component.get('v.accountInfo.accounts'),
      'analysisType': component.get('v.subprocess'),
      'isHolding': component.get('v.isHolding')
    };
    newAnalysis.setParams({
      data: parameters
    });

    return this.promisifyAndCallAction(newAnalysis)
      .then(function(result) {
        var response = JSON.parse(result);
        if (response.status === 'NUEVO') {
          component.set('v.existentAnalysis', false);
        } else if (response.status === 'EXISTENTE') {
          component.set('v.existentAnalysis', true);
        }
        component.set('v.analysisId', response.analysisId);
        component.set('v.accHasAnalysisId', response.accAnalyGpId);
        component.set('v.callCopyingPersistance', response.persistanceStatus);
      })
      .catch(function(errors) {
        const errorMessage = errors[0].message;
        helper.showError(component, errorMessage);
        throw new Error(errorMessage);
      });
  },

  callPersistenceService: function(component, helper) {
    var action = component.get('c.callPersistence');
    var analysisId = component.get('v.analysisId');
    action.setParams({
      analysisId: analysisId
    });
    this.setLoading(component, true);

    return this.promisifyAndCallAction(action);
  },

  callTriageService: function(component) {
    var helper = this;  // eslint-disable-line
    var action = component.get('c.callTriage');
    var groupId = component.get('v.accountInfo.groupId');
    action.setParams({
      analysisId: component.get('v.analysisId'),
      customerId: component.get('v.recordId'),
      clientId: groupId
    });

    return this.promisifyAndCallAction(action)
      .catch(function(err) {
        helper.showError(component, 'Error while calling triage service. ' + err);
        component.set('v.currentStep', 'checklist');
        throw new Error(err);
      });
  },

  updatesArceToPreparing: function(component, event, helper) {
    var analysisId = component.get('v.analysisId');
    var action = component.get('c.updateArceToPreparing');
    action.setParams({
      'arceId': analysisId,
      'analysisType': component.get('v.subprocess')
    });

    return this.promisifyAndCallAction(action);
  },

  updateArceSectorAndStatus: function(component) {
    var analysisId = component.get('v.analysisId');
    var sector = component.get('v.selectedSector');
    var indicator = component.get('v.selectedIndicator');
    var subprocess = component.get('v.subprocess');
    var action = component.get('c.updateArceSectorAndStatus');
    action.setParams({
      'arceId': analysisId,
      'sector': sector,
      'indicator': indicator,
      'analysisType': subprocess
    });

    return this.promisifyAndCallAction(action);
  },

  callPathService: function(component) {
    var helper = this;  // eslint-disable-line
    var analysisId = component.get('v.analysisId');
    var customerId = component.get('v.customerId');
    var action = component.get('c.callPathService');
    action.setParams({
      analysisId: analysisId,
      customerId: customerId,
      'isorphan': component.get('v.accountInfo.isorphan')
    });

    return this.promisifyAndCallAction(action);
  },
  callRiskFilters: function(component) {
    var analysisId = component.get('v.analysisId');
    var customerId = component.get('v.customerId');
    var action = component.get('c.callRiskFilters');
    action.setParams({
      analysisId: analysisId,
      customerId: customerId
    });
    return this.promisifyAndCallAction(action);
  },
  checkEnableSectorNext: function(component) {
    const sector = component.get('v.selectedSector');
    const indicator = component.get('v.selectedIndicator');
    const enabled = sector != null && indicator != null;  // eslint-disable-line
    this.enableNextButton(component, enabled);
  },

  hideBackButton: function(component) {
    const wizardEvent = component.getEvent('wizardEvent');
    wizardEvent.setParams({
      eventType: 'hideBack',
      parameters: { hidden: true }
    });
    wizardEvent.fire();
  },

  enableNextButton: function(component, enabled) {
    const wizardEvent = component.getEvent('wizardEvent');
    wizardEvent.setParams({
      eventType: 'nextEnable',
      parameters: { enabled }
    });
    wizardEvent.fire();
  },

  setLoading: function(component, loading) {
    const wizardEvent = component.getEvent('wizardEvent');
    wizardEvent.setParams({
      eventType: 'setLoading',
      parameters: { loading }
    });
    wizardEvent.fire();
  },

  redirectToArce: function(component, arceId) {
    const wizardEvt = component.getEvent('wizardEvent');
    wizardEvt.setParams({
      eventType: component.get('v.subprocess') === '1' ? 'renovationMessage' : 'redirectToArce',
      parameters: { arceId }
    });
    wizardEvt.fire();
  },

  changeSubtitle: function(component) {
    const wizardEvent = component.getEvent('wizardEvent');
    const currentStep = component.get('v.currentStep');
    var subtitle = '';

    switch (currentStep) {
      case 'subprocess':
        subtitle = $A.get('{!$Label.c.Arc_Gen_Analysis_ST_Subprocess}');
        break;
      case 'justification':
        subtitle = $A.get('{!$Label.c.Arc_Gen_NewAnalysisStepThreeMod}');
        break;
      case 'warningmessage':
        subtitle = $A.get('{!$Label.c.Arc_Gen_NewAnalysisStepFourMod}');
        break;
      case 'checklist':
        subtitle = $A.get('{!$Label.c.Arc_Gen_Analysis_ST_Checklist}');
        break;
      case 'sector':
        subtitle = $A.get('{!$Label.c.Arc_Gen_Analysis_ST_Sector}');
        break;
    }

    wizardEvent.setParams({
      eventType: 'showSubtitle',
      parameters: { text: subtitle }
    });
    wizardEvent.fire();
  },

  setProgressStep: function(component, step) {
    const wizardEvent = component.getEvent('wizardEvent');
    wizardEvent.setParams({
      eventType: 'setCurrentProgressStep',
      parameters: { step }
    });
    wizardEvent.fire();
  },

  showError: function(component, message) {
    const wizardEvent = component.getEvent('wizardEvent');
    wizardEvent.setParams({
      eventType: 'showError',
      parameters: { error: message }
    });
    wizardEvent.fire();
  },

  promisifyAndCallAction: function(action) {
    return new Promise((resolve, reject) => {
      action.setCallback(this, function(response) {
        const state = response.getState();
        if (state === 'SUCCESS') {
          const returnValue = response.getReturnValue();
          if (returnValue !== null && typeof returnValue === 'object') {
            // Check whether response is a ServiceAndSaveResponse object.
            const serviceCode = returnValue.serviceCode;
            const saveStatus = returnValue.saveStatus;

            if (typeof serviceCode !== 'undefined' && !serviceCode.startsWith('2')) {
              reject('(' + returnValue.serviceCode + ')' + returnValue.serviceMessage);
            } else if (saveStatus === 'false') {
              reject(returnValue.saveMessage);
            } else {
              resolve(returnValue);
            }
          } else {
            resolve(returnValue);
          }
        } else {
          reject(response.getError()[0].message);
        }
      });

      $A.enqueueAction(action);
    });
  },

  flowArceMod: function(component) {
    this.setLoading(component, true);
    let analysisId = component.get('v.existingArceIdToModification');
    var accountsWrapp = component.get('v.accountInfo.accounts');
    var action = component.get('c.flowModifiedArce');
    return new Promise(function(resolve, reject) {
      var parameters = {
        'analysisId': analysisId,
        'modRenVar': component.get('v.subprocess') === '1' ? 'ren' : component.get('v.justification'),
        'selectedSector': component.get('v.selectedSector'),
        'accountswraper': accountsWrapp,
        'subProcess': component.get('v.subprocess'),
        'persistanceInd': component.get('v.callCopyingPersistance'),
        'isHolding': component.get('v.isHolding')
      };
      action.setParams({
        data: parameters
      });
      action.setCallback(this, function(response) {
        var state = response.getState();
        var resp = response.getReturnValue();
        if (state === 'SUCCESS') {
          resolve(resp);
        } else {
          var mensaje = response.getError()[0].message;
          var resultsToast = $A.get('e.force:showToast');
          resultsToast.setParams({
            'title': $A.get('{!$Label.c.Lc_arce_newAnalysisError}'),
            'type': 'error',
            'message': mensaje,
            'duration': '8000'
          });
          resultsToast.fire();
          $A.get('e.force:closeQuickAction').fire();
          reject();
        }
      });
      $A.enqueueAction(action);
    });
  },
  callEcoGroupParticipantsPer: function(component) {
    var action = component.get('c.callEcoGroupParticipantsPer');
    action.setParams({
      listparticipant: component.get('v.listparticipant'),
      acctsPart: component.get('v.accountInfo.accounts'),
      analysisId: component.get('v.analysisId')
    });
    return this.promisifyAndCallAction(action)
      .then(function(result) {
        if (result.serviceCode !== '200' && result.serviceCode !== '201' && result.serviceCode !== '204') {
          const errorMessage = $A.get('{!$Label.c.Cls_arce_GRP_servError}') + result.serviceMessage;
          this.showError(component, errorMessage);
          throw new Error(errorMessage);
        }
      });
  }
});