({
  getAvailableArceTypes: function(component) {
    const getTypesAction = component.get('c.getAvailableArceTypes');

    return this.promisifyAndCallAction(getTypesAction);
  },

  getShouldShowGroupStructureRaip: function(component) {
    const getShouldShowGs = component.get('c.shouldShowRaipGroupStructure');

    return this.promisifyAndCallAction(getShouldShowGs);
  },

  handleArceTypeNext: function(component) {
    const helper = this; // eslint-disable-line
    component.set('v.loading', true);
    component.set('v.subtitleText', '');

    // Build group structure.
    const arceType = component.get('v.selectedArceType');
    const skipGroupStructureRaip = !component.get('v.shouldShowGsRaip');
    const skipGroupStructure = arceType === 'raip' && skipGroupStructureRaip;
    const nextStep = skipGroupStructure ? arceType : 'groupStructure';

    const getAccInfoPromise = this.getfullaccountforservices(component, skipGroupStructure);
    getAccInfoPromise.then(function(redirected) {
      component.set('v.loading', false);

      if (!redirected) {
        component.set('v.currentStep', nextStep);
        component.set('v.backHidden', false);
        component.set('v.currentProgressStep', nextStep);
        helper.changeSubtitle(component);
      }
    }).catch(function(err) {
      component.set('v.loading', false);
      if (typeof(err) === 'string') {
        component.set('v.errorMessage', $A.get('$Label.c.Lc_arce_NewARCE_CouldNotCreate').replace('{0}', err));
      } else {
        component.set('v.errorMessage', $A.get('$Label.c.Lc_arce_NewARCE_UnexpectedError'));
      }
      helper.changeSubtitle(component);
    });
  },

  handleGroupStructureNext: function(component) {
    const arceType = component.get('v.selectedArceType');

    component.set('v.currentStep', arceType);
    component.set('v.nextDisabled', true);
    this.changeSubtitle(component);
  },

  handleWizardBack: function(component) {
    // If ARCE type is RAIP and the group structure if skipped, go back to
    // ARCE type selection. Otherwise, go back to group structure.
    const arceType = component.get('v.selectedArceType');
    const skipGroupStructureRaip = !component.get('v.shouldShowGsRaip');
    const skipGroupStructure = arceType === 'raip' && skipGroupStructureRaip;
    const previousStep = skipGroupStructure ? 'arceTypeSelection' : 'groupStructure';
    component.set('v.currentStep', previousStep);
    component.set('v.currentProgressStep', previousStep);
    component.set('v.backHidden', skipGroupStructure);
    component.set('v.nextDisabled', false);
    this.changeSubtitle(component);
  },

  handleRedirect: function(component, arceId, arceNotInScope, riskSegment) {
    var helper = this; // eslint-disable-line

    component.set('v.currentStep', 'redirectToArce');
    component.set('v.currentProgressStep', 'redirectToArce');
    component.set('v.loading', false);
    component.set('v.backHidden', true);
    component.set('v.nextHidden', true);
    component.set('v.arceNotInScope', arceNotInScope);

    // Build text of out-of-scope ARCE
    var baseLabel = $A.get('$Label.c.Arc_Gen_NewARCE_WaitRedirectNotScope');
    var label = baseLabel.replace('{0}', riskSegment);
    component.set('v.outOfScopeText', label);

    helper.changeSubtitle(component);
    setTimeout($A.getCallback(function() {
      helper.redirectAnalysis(component, arceId);
    }), 3000);
  },

  getfullaccountforservices: function(component, skipGroupStructure) {
    var action = component.get('c.getaccdataforservices');
    var helper = this; // eslint-disable-line
    action.setParams({
      recordId: component.get('v.recordId')
    });

    return this.promisifyAndCallAction(action)
      .then(result => {
        component.set('v.firstaccountforfilldata', result);
        return skipGroupStructure ? helper.initializeSkipGroupStructure(component) : helper.chainingpromisesforservice(component);
      });
  },

  initializeSkipGroupStructure: function(component) {
    var helper = this; // eslint-disable-line
    var account = component.get('v.firstaccountforfilldata');
    var CLIENT = 'SUBSIDIARY';
    let clientorgroupnumber = account.accNumber;
    if (account.participantType === CLIENT) {
      // When client.
      return helper.getpreviousArce(component, helper);
    } else {
      // When group.
      let ffssTestCall = helper.ffssTestCall(component, clientorgroupnumber);
      return ffssTestCall.then(function() {
        return helper.getpreviousArce(component, helper);
      });
    }
  },

  chainingpromisesforservice: function(component) {
    var account = component.get('v.firstaccountforfilldata');
    component.set('v.accountInfo.accNumber', account.accNumber);
    var CLIENT = 'SUBSIDIARY';
    var helper = this; // eslint-disable-line

    if (account.participantType === CLIENT) {
      return helper.getpreviousArce(component, helper);
    } else {
      //when is group
      let grpid = account.accId;
      let clientorgroupnumber = account.accNumber;
      component.set('v.accountInfo.groupId', grpid);
      component.set('v.accountInfo.isorphan', false);
      component.set('v.accountInfo.orphanNumber', '');
      component.set('v.idofarceexecutor', component.get('v.recordId'));

      let ffssTestCall = helper.ffssTestCall(component, clientorgroupnumber);
      return ffssTestCall.then(function() {
        return helper.listparticipant(component, clientorgroupnumber);
      }).then(function() {
        return helper.groupstructure(component, component.get('v.listparticipant'), component.get('v.economicparticipant'), clientorgroupnumber, helper);
      }).then(function() {
        return helper.getpreviousArce(component, helper);
      });
    }
  },

  ffssTestCall: function(component, accountNumber) {
    const selectedArceType = component.get('v.selectedArceType');
    const eeffCheck = component.get('v.eeffCheck');
    if (selectedArceType === 'raip' && eeffCheck) {
      const action = component.get('c.performFfssTestCall');
      action.setParams({ accountNumber });

      return this.promisifyAndCallAction(action);
    } else {
      return Promise.resolve();
    }
  },

  listparticipant: function(component, result) {
    var listpartaction = component.get('c.listparticipant');

    // Check if orphan. If it is, call to listParticipants service will be skipped.
    var isOrphan = component.get('v.accountInfo.isorphan');
    listpartaction.setParams({
      'encryptedgroup': result,
      'isOrphan': isOrphan
    });

    return this.promisifyAndCallAction(listpartaction)
      .then(function(response) {
        component.set('v.listparticipant', response);
        var listparticipantsdetails = JSON.parse(response);
        if (listparticipantsdetails.customersdata || listparticipantsdetails.error204message) {
          return Promise.resolve();
        } else if (listparticipantsdetails.servicecallerror || listparticipantsdetails.errormessage) {
          component.set('v.errorMessage', $A.get('{!$Label.c.Arc_Gen_SpinnerMessageError}'));
          return Promise.reject();
        } else {
          return Promise.resolve();
        }
      })
      .catch(function() {
        component.set('v.errorMessage', $A.get('{!$Label.c.Arc_Gen_SpinnerMessageError}'));
        throw new Error('Execution failed');
      });
  },

  /**exectution of economic participant service **/
  economicpartservice: function(component, result) {
    var econpartaction = component.get('c.economicarticipants');

    econpartaction.setParams({
      'encryptedClient': result
    });

    return this.promisifyAndCallAction(econpartaction)
      .then(function(response) {
        component.set('v.economicparticipant', response);
        var economicparticipants = JSON.parse(response);
        component.set('v.accountInfo.isorphan', economicparticipants.isorphan === null ? false : economicparticipants.isorphan);
        if (economicparticipants.isorphan) {
          component.set('v.accountInfo.orphanNumber', economicparticipants.groupinfo.groupid);
        }
        if (economicparticipants.groupinfo) {
          return Promise.resolve(economicparticipants.groupinfo.groupid);
        } else if (economicparticipants.errormessage || economicparticipants.servicecallerror) {
          component.set('v.errorMessage', $A.get('{!$Label.c.Arc_Gen_SpinnerMessageError}'));
          return Promise.reject();
        } else {
          return Promise.resolve();
        }
      })
      .catch(function() {
        component.set('v.errorMessage', $A.get('{!$Label.c.Arc_Gen_SpinnerMessageError}'));
        throw new Error('Execution failed');
      });
  },

  groupstructure: function(component, listparticipant, economicparticipant, clientorgroupnumber, helper) {
    var groupstructure = component.get('c.constructgroupstructure');

    groupstructure.setParams({
      'listparticipant': listparticipant,
      'economicparticipant': economicparticipant,
      'accountNumber': clientorgroupnumber,
      'isOrphan': component.get('v.accountInfo.isorphan')
    });

    return this.promisifyAndCallAction(groupstructure)
      .then(function(result) {
        var resp = JSON.parse(result);
        var arceType = component.get('v.selectedArceType');

        component.set('v.accountInfo.accounts', JSON.stringify(resp.participantsOnline));

        // Save map isHolding with accNumber as key and value of listParticipant service
        component.set('v.isHolding', JSON.stringify(resp.isHolding));

        // If RAIP, idofarceexecutor must be the current account, not the group.
        if (arceType !== 'raip') {
          component.set('v.idofarceexecutor', resp.groupID);
        }
        if (component.get('v.accountInfo.isorphan') && resp.noGroupsInSf === false) {
          component.set('v.accountInfo.groupId', resp.orphanId);
          return Promise.resolve(resp);
        } else if (resp.noGroupsInSf === false) {
          component.set('v.accountInfo.groupId', resp.groupID);
          return Promise.resolve(resp);
        } else {
          component.set('v.errorMessage', $A.get('{!$Label.c.Arc_Gen_NoGroupInARCE}'));
          return Promise.reject();
        }
      })
      .catch(function() {
        component.set('v.errorMessage', $A.get('{!$Label.c.Arc_Gen_SpinnerMessageError}'));
        throw new Error('Execution failed');
      });
  },

  getpreviousArce: function(component, helper) {
    var resumeArce = component.get('v.continue');

    var previousarce = component.get('c.getExistingArce');
    previousarce.setParams({
      'recordId': component.get('v.recordId'),
      'accountswraper': component.get('v.accountInfo.accounts'),
      'arceType': component.get('v.selectedArceType')
    });

    return this.promisifyAndCallAction(previousarce)
      .then(function(result) {
        // Set account number and type.
        component.set('v.clientNumber', result.accountNumber);
        component.set('v.clientOrGroup', result.accHasAnaType);

        // Redirect to current ARCE if it already exists.
        const arceId = result.idARCE;
        var redirect = false;
        if (arceId && !resumeArce && result.wfStage !== '3') {
          helper.handleRedirect(component, arceId);
          redirect = true;
        } else if (arceId && resumeArce) {
          component.set('v.existingArceId', arceId);
        } else if (helper.checkEval(component, result.wfStatus, result.wfStage, result.sanctionType, result.modification, result.renovation)) {
          component.set('v.ModAnalysis', !result.modification);
          component.set('v.NewAnalysis', true);
          component.set('v.RenoAnalysis', !result.renovation);
          component.set('v.existingArceIdToModification', arceId);
        } else {
          component.set('v.ModAnalysis', true);
          component.set('v.NewAnalysis', false);
          component.set('v.RenoAnalysis', true);
        }
        return redirect;
      });
  },

  checkEval: function(component, wfStatus, wfStage, sanctionType, modification, renovation) {
    return wfStatus === '10' && wfStage === '3' && (sanctionType === '1' || sanctionType === '2') && (modification || renovation);
  },

  redirectAnalysis: function(component, arceId) {
    // Refresh view.
    $A.get('e.force:refreshView').fire();

    // Show toast.
    var resultsToast = $A.get('e.force:showToast');
    resultsToast.setParams({
      'title': $A.get('{!$Label.c.Lc_arce_newAnalysisSuccess}'),
      'type': 'success',
      'message': $A.get('{!$Label.c.Lc_arce_redirectingURL}'),
      'duration': '5000'
    });
    resultsToast.fire();

    // Navigate to analysis page.
    var navService = component.find('navService');
    if (!navService) {
      window.location.href = '/'  + arceId;
    } else {
      navService.navigate({
        type: 'standard__recordPage',
        attributes: {
          actionName: 'view',
          objectApiName: 'arce__Analysis__c',
          recordId: arceId
        }
      });
    }
  },

  changeSubtitle: function(component) {
    const currentStep = component.get('v.currentStep');
    var subtitleText = '';

    switch (currentStep) {
      case 'arceTypeSelection':
        subtitleText = $A.get('{!$Label.c.Arc_Gen_Analysis_ST_ArceType}');
        break;
      case 'groupStructure':
        subtitleText = $A.get('{!$Label.c.Arc_Gen_Analysis_ST_GroupStructure}');
        break;
      case 'redirectToArce':
        subtitleText = $A.get('{!$Label.c.Arc_Gen_Analysis_ST_RedirectToARCE}');
        break;
    }

    component.set('v.subtitleText', subtitleText);
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
              reject(returnValue.serviceMessage);
            } else if (saveStatus === 'false') {
              reject(returnValue.saveMessage);
            } else {
              resolve(returnValue);
            }
          } else {
            resolve(returnValue);
          }
        } else {
          reject(response.getError());
        }
      });

      $A.enqueueAction(action);
    });
  },
  showRenovationMessage: function(component, arceId) {
    var helper = this; // eslint-disable-line

    component.set('v.currentStep', 'renovationMessage');
    component.set('v.currentProgressStep', 'redirectToArce');
    component.set('v.loading', false);
    component.set('v.backHidden', true);
    component.set('v.nextHidden', true);

    helper.changeSubtitle(component);
    setTimeout($A.getCallback(function() {
      helper.redirectAnalysis(component, arceId);
    }), 10000);
  },
  evalSetLoading: function(component, parameters) {
    component.set('v.loading', parameters.loading);
    if (parameters.loading) {
      component.set('v.subtitleText', '');
    }
  },
  getEEFFServiceCheck: function(component) {
    var action = component.get('c.getEEFFServiceCheck');

    action.setCallback(this, function(response) {
      var state = response.getState();
      if (state === 'SUCCESS') {
        var res = response.getReturnValue();
        component.set('v.eeffCheck', res);
      }
    });
    $A.enqueueAction(action);
  },
  getCountryLocal: function(component) {
    var action = component.get('c.isCountryAvailable');
    action.setParams({
      recordId: component.get('v.recordId')
    });
    return this.promisifyAndCallAction(action);
  }
});