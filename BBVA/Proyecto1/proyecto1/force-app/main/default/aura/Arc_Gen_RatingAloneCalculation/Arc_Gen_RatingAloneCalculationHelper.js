({
  checkPermission: function(component) {
    return new Promise((resolve, reject) => {
      var action = component.get('c.checkPmnsAlon');
      action.setParams({
        aHasAnalysId: component.get('v.recordId'),
      });
      action.setCallback(this, function(response) {
        var state = response.getState();
        if (state === 'SUCCESS') {
          let permission = response.getReturnValue();
          if (!permission) {
            component.set('v.errorCode', '');
            component.set('v.errorTitle', 'INCOMPLETE');
            component.set('v.message', $A.get('{!$Label.arce.Arc_Gen_AnchorMissing}'));
            reject();
          } else {
            resolve();
          }
        } else if (state === 'ERROR') {
          var errors = response.getError();
          component.set('v.errorCode', '');
          component.set('v.errorTitle', 'ERROR');
          component.set('v.message', errors);
          reject();
        }
      });
      $A.enqueueAction(action);
    });
  },
  checkCompleteness: function(component) {
    return new Promise((resolve, reject) => {
      var action = component.get('c.checkCompletenessCtrl');
      var message;
      var typology;
      action.setParams({
        aHasAnalysId: component.get('v.recordId'),
        modelSelctd: component.get('v.model')
      });
      action.setCallback(this, function(response) {
        try {
          var state = response.getState();
          if (state === 'SUCCESS') {
            var info = response.getReturnValue();
            if (info.length > 0) {
              component.set('v.formIncompleteInfo', info);
              reject();
            } else {
              resolve();
            }
          } else if (state === 'INCOMPLETE') {
            message = 'Incomplete';
            typology = 'Error';
            this.fireToast(typology, message);
            reject();
          } else if (state === 'ERROR') {
            var errors = response.getError();
            if (errors) {
              if (errors[0] && errors[0].message) {
                message = errors[0].message;
                typology = 'Error';
                this.fireToast(typology, message);
              }
            } else {
              message = 'Unkwon error';
              typology = 'Error';
              this.fireToast(typology, message);
            }
            reject();
          }
        } catch (e) {
          message = 'Unkwon error';
          typology = 'Error';
          this.fireToast(typology, message);
          reject();
        }

      });
      $A.enqueueAction(action);
    });
  },
  callMultiPersistenceEngine: function(component, event, helper) {
    return new Promise((resolve, reject) => {
      let modelSlctd = component.get('v.model');
      if (modelSlctd === '2012') {
        var action = component.get('c.callMultiPersistenceEngine');
        action.setParams({
          aHasAnalysId: component.get('v.recordId'),
          modelSlctd: modelSlctd
        });
        component.set('v.isLoading', true);
        action.setCallback(this, function(response) {
          var state = response.getState();
          if (state === 'SUCCESS')  {
            resolve();
          } else {
            var info = response.getError()[0].message;
            component.set('v.success', 'no');
            component.set('v.errorTitle', 'ERROR');
            component.set('v.errorCode', $A.get('{!$Label.arce.Arc_Gen_RatingError_ErrorCode}') + ' 500');
            component.set('v.message', info);
            component.set('v.isOpen', true);
            reject();
          }
        });
        $A.enqueueAction(action);
      } else {
        resolve();
      }
    });
  },
  getRatingId: function(component, event, helper) {
    return new Promise((resolve, reject) => {
      let modelSlctd = component.get('v.model');
      let templateByModel = modelSlctd === '2019' ? 'sp2-re-gbl-01-100' : 'sp2-re-gbl-01-100-2012';
      component.set('v.templateToUse', templateByModel);
      if (modelSlctd === '2012') {
        var action = component.get('c.getRtngId');
        action.setParams({
          aHasAnalysId: component.get('v.recordId'),
        });
        action.setCallback(this, function(response) {
          var state = response.getState();
          if (state === 'SUCCESS') {
            let ratingIdRes = response.getReturnValue();
            if (ratingIdRes.saveStatus && ratingIdRes.serviceCode.includes('20')) {
              resolve();
            } else {
              let message = 'ServiceMessage: ' + ratingIdRes.serviceMessage + ' SaveMessage: ' + ratingIdRes.saveMessage;
              helper.fireToast('Error Getting Rating Id', message);
              reject();
            }
          } else if (state === 'ERROR') {
            var errors = response.getError();
            helper.fireToast('Error Getting Rating Id', errors);
            reject();
          }
        });
        $A.enqueueAction(action);
      } else {
        resolve();
      }
    });
  },
  checkModifiers: function(component, event) {
    return new Promise((resolve, reject) => {
      var action = component.get('c.checkModifiers');
      var message;
      var typology;
      action.setParams({
        aHasAnalysId: component.get('v.recordId'),
        templateName: component.get('v.templateToUse')
      });
      action.setCallback(this, function(response) {
        try {
          var state = response.getState();
          if (state === 'SUCCESS') {
            var info = response.getReturnValue();
            if (info.length > 0) {
              component.set('v.formIncompleteInfo', info);
              reject();
            } else {
              resolve();
            }
          } else if (state === 'INCOMPLETE') {
            message = 'Incomplete';
            typology = 'Error';
            this.fireToast(typology, message);
            reject();
          } else if (state === 'ERROR') {
            var errors = response.getError();
            if (errors) {
              if (errors[0] && errors[0].message) {
                message = errors[0].message;
                typology = 'Error';
                this.fireToast(typology, message);
              }
            } else {
              message = 'Unkwon error';
              typology = 'Error';
              this.fireToast(typology, message);
            }
            reject();
          }
        } catch (e) {
          message = 'Unkwon error';
          typology = 'Error';
          this.fireToast(typology, message);
          reject();
        }
      });
      $A.enqueueAction(action);
    });
  },

  callPersistModifiers: function(component, event) {
    return new Promise(function(res, rej) {
      var action = component.get('c.callPersistModifiers');
      var message;
      var typology;
      action.setParams({
        aHasAnalysId: component.get('v.recordId'),
        methodType: 'persistenceModifiers'
      });
      action.setCallback(this, function(response) {
        try {

          var resp = response.getReturnValue();
          var state = response.getState();
          if (state === 'SUCCESS') {
            if (resp.serviceCode === '200' || resp.serviceCode === '201') {
              res();
            } else {
              var errorWrapper = JSON.parse(resp.serviceMessage);
              component.set('v.errorCode', $A.get('{!$Label.arce.Arc_Gen_RatingError_ErrorCode}') + ' ' + errorWrapper.errorCode);
              component.set('v.errorTitle', errorWrapper.errorTitle);
              component.set('v.message', errorWrapper.errorMessage);
              rej();
            }
          } else {
            component.set('v.message', $A.get('{!$Label.arce.Arc_Gen_HandleErrors_PersistModifiers}'));
            rej();
          }
        } catch (e) {
          message = 'Unkwon error';
          typology = 'Error';
          this.fireToast(typology, message);
          rej();
        }
      });
      $A.enqueueAction(action);
    });
  },
  /*
  getCustomerData: function(component) {
    return new Promise(function(res, rej) {
      var action = component.get('c.getCustomerData');
      action.setParams({
        analysisId: component.get('v.recordId')
      });
      action.setCallback(this, function(response) {
        var resp = response.getReturnValue();
        var state = response.getState();
        if (state === 'SUCCESS') {
          component.set('v.customerName', resp.customerName);
          component.set('v.customerId', resp.customerId);
          res();
        } else {
          this.showToast($A.get('{!$Label.arce.Lc_arce_newAnalysisError}'), resp.errorMessage);
          $A.get('e.force:closeQuickAction').fire();
          rej();
        }
      });
      $A.enqueueAction(action);
    });
  },
  */
  callRatingEngine: function(component) {
    return new Promise(function(resolve, reject) {
      var message;
      var typology;
      var action = component.get('c.callRatingEngine');

      action.setParams({
        analysisId: component.get('v.recordId')
      });

      action.setCallback(this, function(response) {
        try {
          var resp = response.getReturnValue();
          var state = response.getState();

          if (state === 'SUCCESS') {
            if (resp.serviceCode === '200' && resp.saveStatus === 'true') {
              resolve();
            } else if (resp.serviceCode !== '200' && resp.serviceMessage) {
              var errorWrapper = JSON.parse(resp.serviceMessage);
              component.set('v.errorCode', $A.get('{!$Label.arce.Arc_Gen_RatingError_ErrorCode}') + ' ' + errorWrapper.errorCode);
              component.set('v.errorTitle', errorWrapper.errorTitle);
              component.set('v.message', errorWrapper.errorMessage);
              reject();
            }
          } else {
            component.set('v.message', $A.get('{!$Label.arce.Arc_Gen_HandleErrors_Ratings}'));
            reject();
          }
        } catch (e) {
          message = 'Unkwon error';
          typology = 'Error';
          this.fireToast(typology, message);
          reject();
        }
      });
      $A.enqueueAction(action);
    });
  },

  ratingProcessOK: function(component) {
    component.set('v.message', $A.get('{!$Label.arce.Lc_arce_successAndCloseWindow}'));
    component.set('v.success', 'yes');
    this.refreshRating(component);
    component.set('v.isLoading', false);
  },

  cancelAction: function(component) {
    component.set('v.success', 'no');
    component.set('v.isLoading', false);
  },

  fireToast: function(type, message) {
    let toastError = $A.get('e.force:showToast');
    toastError.setParams({
      'title': type + '!',
      'type': type.toLowerCase(),
      'message': message
    });
    toastError.fire();
  },

  refreshRating: function(component) {
    var tabRefresh = $A.get('e.dyfr:SaveObject_evt');
    tabRefresh.setParams({
      'recordId': component.get('v.recordId')
    });
    tabRefresh.fire();
  }

});