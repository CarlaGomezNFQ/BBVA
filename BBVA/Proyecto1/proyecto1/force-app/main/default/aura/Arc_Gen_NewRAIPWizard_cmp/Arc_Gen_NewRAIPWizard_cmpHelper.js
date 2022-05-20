({
  onInit: function(component, event, helper) {
    component.set('v.subscription', null);
    component.set('v.notifications', []);

    // Get the empApi component
    const empApi = component.find('empApi');

    // Uncomment below line to enable debug logging (optional)
    empApi.setDebugFlag(true);

    // Register error listener and pass in the error handler function
    empApi.onError($A.getCallback(error => {
      // Error can be any type of error (subscribe, unsubscribe...)
      console.error('EMP API error: ', error);
    }));
    helper.callbackSuscribe(component, event, helper);

    // Check whether to resume RAIP.
    var arceIdToResume = component.get('v.arceIdToResume');
    var resumeArce = arceIdToResume !== '';

    // Check whether this component is invoked from the EEFF button.
    var changeFfssMode = component.get('v.changeFfssMode');

    component.set('v.initialized', false);
    helper.hideBackButton(component);
    helper.enableNextButton(component, false);
    helper.setLoading(component, true);

    if (changeFfssMode) {
      // Component invoked from FFSS button. Actions: Check config and run wizard.
      let initialPromise = helper.checkTriageConfig(component, event, helper);
      initialPromise.then($A.getCallback(function() {
        component.set('v.initialized', true);
        helper.setWizardSteps(component);
        helper.setLoading(component, false);
        helper.changeSubtitle(component);
        helper.hideBackButton(component);
        helper.setProgressStep(component, 'ffss');
      })).catch($A.getCallback(function() {
        helper.setLoading(component, false);
        helper.showError(component, $A.get('{!$Label.c.Lc_arce_NewARCE_UnexpectedError}'));
      }));
    } else if (resumeArce) {
      // Component invoked from RAIP (resume). Actions: Check config, get RAIP data, call persistence and run wizard.
      let initialPromise = helper.checkTriageConfig(component, event, helper);
      initialPromise.then(function() {
        return helper.getRaipData(component);
      }).then(function() {
        helper.setWizardSteps(component);
        return helper.callPersistenceService(component, helper);
      }).then(function() {
        // Initialize
        helper.initFFSSStep(component, helper);
      }).catch(function() {
        // Check if ARCE has been created. If so, there was an error in the persistence call.
        helper.catchError(component, helper);
      });
    } else {
      // Component invoked from wizard (new). Actions: Check config, create RAIP, call persistence and run wizard.
      let initialPromise = helper.checkTriageConfig(component, event, helper);
      initialPromise.then(function() {
        helper.setWizardSteps(component);
        return helper.newRaip(component);
      }).then(function() {
        return helper.callPersistenceService(component, helper);
      }).then(function() {
        return helper.callRiskFilterService(component, helper);
      }).then(function() {
        helper.initFFSSStep(component, helper);
      }).catch(function() {
        helper.catchError(component, helper);
      });
    }
  },

  initFFSSStep: function(component, helper) {
    component.set('v.initialized', true);
    helper.setLoading(component, false);
    helper.changeSubtitle(component);
    helper.hideBackButton(component);
    helper.setProgressStep(component, 'ffss');
  },

  catchError: function(component, helper) {
    helper.setLoading(component, false);
    const arceId = component.get('v.analysisId');
    if (arceId) {
      helper.showError(component, $A.get('{!$Label.c.Arc_Gen_RAIP_ErrorCreationOrPersistence}'));
    } else {
      helper.showError(component, $A.get('{!$Label.c.Lc_arce_NewARCE_UnexpectedError}'));
    }
  },

  newRaip: function(component) {
    const helper = this; // eslint-disable-line
    // Show spinner.
    this.setLoading(component, true);

    // Call server action.
    var recordId = component.get('v.recordId');
    var actualClient = component.get('v.actualClient');
    var newanalysis = component.get('c.setanalysis');

    var params = {
      'recordId': recordId,
      'isorphan': 'false',
      'orphanNumber': '',
      'accounts': '[]',
      'analysisType': '4',
      'actualClient': actualClient.accNumber
    };
    newanalysis.setParams({
      data: params
    });

    return this.promisifyAndCallAction(newanalysis)
      .then(function(result) {
        var resp = JSON.parse(result);
        if (resp.status === 'NUEVO') {
          component.set('v.existentAnalysis', false);
        } else if (resp.status === 'EXISTENTE') {
          component.set('v.existentAnalysis', true);
        }
        component.set('v.clientNumber', resp.clientnumber);
        component.set('v.analysisId', resp.analysisId);
        component.set('v.accHasAnalysisId', resp.accAnalyGpId);
      })
      .catch(function(errors) {
        helper.showError(component, errors[0].message);
        $A.get('e.force:closeQuickAction').fire();
        throw new Error('Execution failed');
      });
  },

  getRaipData: function(component) {
    // Get RAIP data for existing ARCE.
    var action = component.get('c.getRAIPData');

    action.setParams({
      analysisId: component.get('v.arceIdToResume')
    });

    return this.promisifyAndCallAction(action)
      .then(function(result) {
        const outputJson = JSON.parse(result);
        const serviceResponse = JSON.parse(outputJson.serviceMessage);
        component.set('v.analysisId', serviceResponse.analysisId);
        component.set('v.accHasAnalysisId', serviceResponse.accHasAnalysisId);
        component.set('v.customerId', serviceResponse.customerId);
      });
  },

  checkTriageConfig: function(component, event, helper) {
    const getTriasConfg = this.getTriageConfig(component);
    const getRAIPSelectMetadata = this.getRAIPSelectMetadata(component);
    const getOptionsWf = this.getLabelCombo(component);
    const getOptionsMdl = this.getMdlOptns(component);
    const buttonEEFF = component.get('v.changeFfssMode');
    return Promise.all([getTriasConfg, getRAIPSelectMetadata, getOptionsWf, getOptionsMdl])
      .then(function(responses) {
        const triageConfigRes = responses[0];
        const RAIPSelectMetadata = responses[1];
        const optionsWf = responses[2];
        const optionsModls = responses[3];
        optionsModls[0].label = optionsModls[0].label.toUpperCase();

        component.set('v.ratingToolStepEnabled', !triageConfigRes.triageCallEnabled);
        component.set('v.ratingToolOptions', triageConfigRes.ratingToolList);
        component.set('v.isRAIPSelectWorkflow', RAIPSelectMetadata);
        component.set('v.options', optionsWf);
        component.set('v.optionsMdls', optionsModls);
        if (optionsModls.length && !buttonEEFF) {
          component.set('v.currentStep', 'selectModel');
          helper.enableNextButton(component, true);
        } else if (RAIPSelectMetadata && !buttonEEFF) {
          component.set('v.currentStep', 'selectRAIPWf');
        }
      });
  },

  checkGlobalRunWayConfig: function(component) {
    if (!component.get('v.changeFfssMode')) {
      var actualClient = component.get('v.actualClient');
      var globalId = actualClient.globalId;
      var isNew = component.get('v.arceIdToResume') === '';
      component.set('v.globalCustomerId', globalId);
      var action = component.get('c.globalRunWayConfig');
      this.setLoading(component, true);
      return this.promisifyAndCallAction(action)
        .then(result => {
          var newStep =  isNew && result.gblRunWayEnabled ? 'globalRunWay' : 'ffss';
          component.set('v.globalRunWayStepEnabled', result.gblRunWayEnabled);
          component.set('v.blockLocalOption', result.blockLocalOption);
          component.set('v.currentStep', newStep);
        });
    } else {
      return new Promise((resolve, reject) => {
        component.set('v.currentStep', 'ffss');
        resolve();
      });
    }
  },

  getURLConfig: function(component) {
    var action = component.get('c.localURLs');
    this.setLoading(component, true);
    return this.promisifyAndCallAction(action)
      .then(result => {
        component.set('v.orgURL', result.orgURL);
        component.set('v.vfURL', result.vfURL);
      });
  },

  setWizardSteps: function(component) {
    // List of steps.
    const arceTypeStep = { label: $A.get('{!$Label.c.Arc_Gen_Analysis_ST_ArceType}'), value: 'arceTypeSelection' };
    const groupStructureStep = { label: $A.get('{!$Label.c.Arc_Gen_Analysis_ST_GroupStructure}'), value: 'groupStructure' };
    const globalRunWayStep = { label: $A.get('{!$Label.c.Arc_Gen_Analysis_ST_GlobalRunWay}'), value: 'globalRunWay' };
    const ffssStep = { label: $A.get('{!$Label.c.Arc_Gen_Analysis_ST_FFSS}'), value: 'ffss' };
    const ratingToolStep = { label: $A.get('{!$Label.c.Arc_Gen_Analysis_ST_RatingTool'), value: 'tool' };
    const irpWFV2 = { label: $A.get('{!$Label.c.Arc_Gen_Analysis_ST_SelectWf'), value: 'selectRAIPWf' };
    const redirectToArceStep = { label: $A.get('{!$Label.c.Arc_Gen_Analysis_ST_RedirectToARCE}'), value: 'redirectToArce' };

    // Determine actual step list, depending on whether rating tool needs to be selected.
    const ratingToolStepEnabled = component.get('v.ratingToolStepEnabled');
    const irpWFV2Enable = component.get('v.isRAIPSelectWorkflow');
    const irpWFV2Selected = component.get('v.RAIPSelectComboValue');
    const buttonEEFF = component.get('v.changeFfssMode');
    const globalRunWayStepEnabled = component.get('v.globalRunWayStepEnabled');
    var steps = [];

    if (irpWFV2Enable && !buttonEEFF) {
      if (irpWFV2Selected === $A.get('{!$Label.arce.Arc_Gen_NewRaipRatingApi}') && ratingToolStepEnabled) {
        steps = [arceTypeStep, globalRunWayStep, groupStructureStep, irpWFV2, ffssStep, ratingToolStep, redirectToArceStep];
      } else if (irpWFV2Selected === $A.get('{!$Label.arce.Arc_Gen_NewRaipRatingApi}')) {
        steps = [arceTypeStep, globalRunWayStep, groupStructureStep, irpWFV2, ffssStep, redirectToArceStep];
      } else {
        steps = [arceTypeStep, globalRunWayStep, groupStructureStep, irpWFV2, redirectToArceStep];
      }
    } else if (ratingToolStepEnabled) {
      steps = [arceTypeStep, globalRunWayStep, groupStructureStep, ffssStep, ratingToolStep, redirectToArceStep];
    } else {
      steps = [arceTypeStep, globalRunWayStep, groupStructureStep, ffssStep, redirectToArceStep];
    }

    if (!globalRunWayStepEnabled) {
      steps.splice(1, 1);
    }
    /* Fire event. */
    const wzrdEvent = component.getEvent('wizardEvent');
    wzrdEvent.setParams({
      'eventType': 'setProgressSteps',
      parameters: { steps }
    });
    wzrdEvent.fire();
  },

  callPersistenceService: function(component, helper) {
    var action = component.get('c.callPersistence');
    var analysisId = component.get('v.analysisId');
    var customerId = component.get('v.customerId');
    action.setParams({
      analysisId, customerId
    });
    this.setLoading(component, true);

    return this.promisifyAndCallAction(action);
  },

  callTriageService: function(component) {
    var action = component.get('c.callTriage');
    var analysisId = component.get('v.analysisId');
    var customerId = component.get('v.customerId');
    action.setParams({
      analysisId, customerId
    });
    this.setLoading(component, true);

    return this.promisifyAndCallAction(action)
      .then(result => {
        const response = JSON.parse(result.serviceMessage);
        component.set('v.arceInScope', response.arceInScope);
        component.set('v.riskSegment', response.riskSegment);
      });
  },

  persistData: function(component, event) {
    var helper = this;  // eslint-disable-line
    var action = component.get('c.persistRatingModel');
    action.setParams({
      'accHasAnalysisId': component.get('v.accHasAnalysisId'),
      'ratingModelValue': component.get('v.ratingTool'),
      'raipType': component.get('v.ratingType')
    });

    return this.promisifyAndCallAction(action)
      .then(function(result) {
        const res = JSON.parse(result);
        const toastEvent = $A.get('e.force:showToast');
        if (res.saveStatus === 'true') {
          component.set('v.analysisId', res.analysisId);
          toastEvent.setParams({
            'title': $A.get('{!$Label.c.Lc_arce_newAnalysisSuccess}'),
            'type': 'success',
            'duration': '8000',
            'message': ''
          });
          toastEvent.fire();
        } else {
          helper.showError(component, $A.get('{!$Label.c.Lc_arce_NewARCE_UnexpectedError}'));
          $A.get('e.force:closeQuickAction').fire();
          throw new Error($A.get('{!$Label.c.Lc_arce_NewARCE_UnexpectedError}'));
        }
      });
  },

  handleFfssNext: function(component) {
    const helper = this; // eslint-disable-line
    const ffssTable = component.find('ffss-table');
    this.setLoading(component, true);

    const ratingToolStepEnabled = component.get('v.ratingToolStepEnabled');
    const irpwfv2 = component.get('v.isRAIPSelectWorkflow');

    var promise;
    if (ratingToolStepEnabled) {
      promise = ffssTable.callTablesEngine().then(function() {
        if (irpwfv2) {
          let modlCondt = component.get('v.modlSlctd') && component.get('v.irpTypeSlctd');
          let concatSlctdTool = modlCondt ? component.get('v.modlSlctd').concat(component.get('v.irpTypeSlctd')) : component.get('v.irpTypeSlctd');
          component.set('v.ratingTool', concatSlctdTool);
          helper.handleToolNext(component);
        } else {
          component.set('v.currentStep', 'tool');
          helper.setProgressStep(component, 'tool');
          helper.setLoading(component, false);
          helper.enableNextButton(component, false);
          helper.changeSubtitle(component);
        }
      });
    } else {
      promise = ffssTable.callTablesEngine().then(function() {
        return helper.callTriageService(component);
      }).then(function() {
        return helper.persistData(component);
      }).then(function() {
        helper.redirectToArce(component, component.get('v.analysisId'), component.get('v.arceInScope'), component.get('v.riskSegment'));
      });
    }

    promise.catch(function() {
      helper.showError(component, $A.get('{!$Label.c.Lc_arce_NewARCE_UnexpectedError}'));
      helper.setLoading(component, false);
    });
  },

  handleToolNext: function(component) {
    const helper = this; // eslint-disable-line
    this.setLoading(component, true);

    const persistance = this.persistData(component);
    persistance.then(function() {
      helper.redirectToArce(component, component.get('v.analysisId'), true);
    }).catch(function() {
      helper.showError(component, $A.get('{!$Label.c.Lc_arce_NewARCE_UnexpectedError}'));
      helper.setLoading(component, false);
    });
  },
  handleWFV2Next: function(component, event, helper) {
    const wfSelected = component.get('v.RAIPSelectComboValue');
    if (wfSelected === $A.get('{!$Label.arce.Arc_Gen_NewRaipRatingApi}')) {
      //Si es Seleccionado IRP
      component.set('v.currentStep', 'ffss');
      const updtIrpWf = helper.irpWfUpdt(component);
      updtIrpWf.then(function() {
        helper.changeSubtitle(component);
        helper.setWizardSteps(component);
      }).catch(function() {
        helper.showError(component, $A.get('{!$Label.c.Lc_arce_NewARCE_UnexpectedError}'));
        helper.setLoading(component, false);
      });
    } else {
      //Si es Seleccionado ARP o CRP
      component.set('v.ratingTool', component.get('v.modlSlctd') ? component.get('v.modlSlctd').concat(component.get('v.irpTypeSlctd')) : component.get('v.irpTypeSlctd'));
      const ffssWAhas = helper.newFFSSWAhas(component);
      ffssWAhas.then(function() {
        helper.handleToolNext(component);
      }).catch(function() {
        helper.showError(component, $A.get('{!$Label.c.Lc_arce_NewARCE_UnexpectedError}'));
        helper.setLoading(component, false);
      });
    }
  },

  newFFSSWAhas: function(component) {
    var action = component.get('c.newFFSSWAhas');
    action.setParams({
      'accHasAnalysisId': component.get('v.accHasAnalysisId'),
      'analysisId': component.get('v.analysisId'),
      'flowSelected': component.get('v.RAIPSelectComboValue'),
      'rarRatingTool': component.get('v.IRPRarRatingTool')
    });
    return this.promisifyAndCallAction(action);
  },
  irpWfUpdt: function(component) {
    var action = component.get('c.irpWfUpdt');

    action.setParams({
      'accHasAnalysisId': component.get('v.accHasAnalysisId'),
      'flowSelected': component.get('v.RAIPSelectComboValue')
    });
    return this.promisifyAndCallAction(action);
  },

  handleGlobalRunWayNext: function(component, event, helper) {
    helper.setLoading(component, true);
    if (component.get('v.redirectToExternalOrg') === '2') {
      helper.redirectToOrg(component, helper);
      component.set('v.blockYES', true);
      component.set('v.blockLocalOption', true);
      helper.showWarning(component, $A.get('{!$Label.c.Arc_Gen_RAIP_GBL_redirect_warning}'));
      helper.setLoading(component, false);
    } else {
      component.set('v.currentStep', 'ffss');
      helper.onInit(component, event, helper);
    }
  },

  hideBackButton: function(component) {
    const wzrdEvent = component.getEvent('wizardEvent');
    wzrdEvent.setParams({
      eventType: 'hideBack',
      parameters: { hidden: true }
    });
    wzrdEvent.fire();
  },

  enableNextButton: function(component, enabled) {
    const wzrdEvent = component.getEvent('wizardEvent');
    wzrdEvent.setParams({
      eventType: 'nextEnable',
      parameters: { enabled }
    });
    wzrdEvent.fire();
  },

  setLoading: function(component, loading) {
    const wzrdEvent = component.getEvent('wizardEvent');
    wzrdEvent.setParams({
      eventType: 'setLoading',
      parameters: { loading }
    });
    wzrdEvent.fire();
  },

  redirectToArce: function(component, arceId, arceInScope, riskSegment) {
    const wzrdEvent = component.getEvent('wizardEvent');
    wzrdEvent.setParams({
      eventType: 'redirectToArce',
      parameters: { arceId, arceNotInScope: !arceInScope, riskSegment }
    });
    wzrdEvent.fire();
  },

  showPostpone: function(component, shown) {
    const wzrdEvent = component.getEvent('wizardEvent');
    wzrdEvent.setParams({
      eventType: 'showPostpone',
      parameters: { shown }
    });
    wzrdEvent.fire();
  },

  changeSubtitle: function(component) {
    const wzrdEvent = component.getEvent('wizardEvent');
    const currentStep = component.get('v.currentStep');
    var subtitleText = '';

    switch (currentStep) {
      case 'ffss':
        subtitleText = $A.get('{!$Label.c.Arc_Gen_Analysis_ST_FFSS}');
        break;
      case 'tool':
        subtitleText = $A.get('{!$Label.c.Arc_Gen_Analysis_ST_RatingTool}');
        break;
      case 'selectRAIPWf':
        subtitleText = $A.get('{!$Label.c.Arc_Gen_Analysis_ST_SelectWf}');
        break;
      case 'globalRunWay':
        subtitleText = $A.get('{!$Label.c.Arc_Gen_Analysis_ST_GlobalRunWay}');
        break;
    }

    wzrdEvent.setParams({
      eventType: 'showSubtitle',
      parameters: { text: subtitleText }
    });
    wzrdEvent.fire();
  },
  getRAIPSelectMetadata: function(component) {
    const getRAIPWfMetadata = component.get('c.isRAIPWfMetadata');
    return this.promisifyAndCallAction(getRAIPWfMetadata);
  },
  getTriageConfig: function(component) {
    const getTriConfig = component.get('c.getTriageConfig');
    return this.promisifyAndCallAction(getTriConfig);
  },
  getLabelCombo: function(component) {
    const changeFfssMode = component.get('v.changeFfssMode');
    const getLabCombo = component.get('c.picklistValueOfSelectWf');
    let actualClient = changeFfssMode ? null : component.get('v.actualClient').accNumber;
    getLabCombo.setParams({
      'modelSelected': component.get('v.modlSlctd'),
      'actualClientNum': actualClient
    });
    return this.promisifyAndCallAction(getLabCombo);
  },
  getMdlOptns: function(component) {
    const getOptions = component.get('c.model2012Active');
    return this.promisifyAndCallAction(getOptions);
  },
  setProgressStep: function(component, step) {
    const wzrdEvent = component.getEvent('wizardEvent');
    wzrdEvent.setParams({
      eventType: 'setCurrentProgressStep',
      parameters: { step }
    });
    wzrdEvent.fire();
  },

  showError: function(component, message) {
    const wzrdEvent = component.getEvent('wizardEvent');
    wzrdEvent.setParams({
      eventType: 'showError',
      parameters: { error: message }
    });
    wzrdEvent.fire();
  },
  showWarning: function(component, message) {
    const wzrdEvent = component.getEvent('wizardEvent');
    wzrdEvent.setParams({
      eventType: 'showWarning',
      parameters: { warning: message }
    });
    wzrdEvent.fire();
  },

  redirectToOrg: function(component, helper) {
    var winGoogle = window.open(component.get('v.orgURL'), '_blank');
    setTimeout(function() {
      winGoogle.close();
      var form = document.getElementById('Formulario');
      form.submit();
    }, 5000);
  },

  promisifyAndCallAction: function(action) {
    return new Promise((resolve, reject) => {
      action.setCallback(this, function(response) {
        const status = response.getState();
        if (status === 'SUCCESS') {
          const respValue = response.getReturnValue();

          if (respValue !== null && typeof respValue === 'object') {
            // Check whether response is a ServiceAndSaveResponse object.
            const serviceCode = respValue.serviceCode;
            const saveStatus = respValue.saveStatus;

            if (typeof serviceCode !== 'undefined' && !serviceCode.startsWith('2')) {
              reject(respValue.serviceMessage);
            } else if (saveStatus === 'false') {
              reject(respValue.saveMessage);
            } else {
              resolve(respValue);
            }
          } else {
            resolve(respValue);
          }
        } else {
          reject(response.getError());
        }
      });

      $A.enqueueAction(action);
    });
  },
  callRiskFilterService: function(component, helper) {
    var action = component.get('c.callRiskFilter');
    var customerId = component.get('v.customerId');
    var arceId = component.get('v.analysisId');
    action.setParams({
      customerId,
      arceId
    });
    this.setLoading(component, true);

    return this.promisifyAndCallAction(action);
  },
  callbackSuscribe: function(component, event, helper) {
    // Get the empApi component
    const empApi = component.find('empApi');
    const channel = component.get('v.channel');
    const replayId = -1;
    const callback = function(message) {
      console.log('Event Received : ' + JSON.stringify(message));
      helper.onReceiveNotification(component, message);
    };

    // Subscribe to the channel and save the returned subscription object.
    empApi.subscribe(channel, replayId, callback).then(function(newSubscription) {
      console.log('Subscribed to channel ' + channel);
      component.set('v.subscription', newSubscription);
    });
  },
  unsubscribe: function(component) {
    const empApi = component.find('empApi');
    const subscription = component.get('v.subscription');
    empApi.unsubscribe(subscription, $A.getCallback(unsubscribed => {
      component.set('v.subscription', null);
    }));
  },
  onReceiveNotification: function(component, message) {
    // Extract notification from platform event
    const newNotification = {
      time: $A.localizationService.formatDateTime(
        message.data.payload.CreatedDate, 'HH:mm'),
      message: message.data.payload.arce__Message__c
    };

    // Save notification in history
    const notifications = component.get('v.notifications');
    notifications.push(newNotification);
    component.set('v.notifications', notifications);
    component.set('v.isDisabled', true);

    // Display notification in a toast
    this.showError(component, newNotification.message);
    $A.get('e.force:closeQuickAction').fire();
    this.displayToast(component, 'ERROR', newNotification.message);
  },
  displayToast: function(component, type, message) {
    const toastEvent = $A.get('e.force:showToast');
    toastEvent.setParams({
      type: type,
      message: message,
      duration: 5000
    });
    toastEvent.fire();
  },
  checkRatingTypeByModel: function(component, event, helper) {
    return new Promise((resolve, reject) => {
      var action = component.get('c.checkRatingType');
      var analysis = component.get('v.accHasAnalysisId');
      var modelSel = component.get('v.modlSlctd');
      var changeFfssMode = component.get('v.changeFfssMode');
      action.setParams({
        analysisId: analysis,
        modelSelec: modelSel,
        eeffButton: changeFfssMode
      });
      action.setCallback(this, function(response) {
        var state = response.getState();
        if (state === 'SUCCESS') {
          var responseWrapper = response.getReturnValue();
          component.set('v.ratingTypeOptions', responseWrapper);
          resolve();
        } else {
          reject();
        }
      });
      $A.enqueueAction(action);
    });
  }
});