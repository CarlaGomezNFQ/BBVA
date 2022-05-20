({
  checkCompleteness: function(component, event, helper) {
    return new Promise((resolve, reject) => {
      var action = component.get('c.checkCompletenessCtrl');
      var message;
      var typology;
      action.setParams({
        aHasAnalysId: component.get('v.recordId'),
        modelSelctd: '2019'
      });
      component.set('v.isLoading', true);
      action.setCallback(this, function(response) {
        component.set('v.isLoading', false);
        var state = response.getState();
        if (state === 'SUCCESS') {
          var info = response.getReturnValue();
          if (info.length > 0) {
            component.set('v.formIncompleteInfo', info);
            component.set('v.isOpen', true);
            reject();
          } else {
            resolve();
          }
        } else if (state === 'INCOMPLETE') {
          message = 'Incomplete';
          typology = 'Error';
          helper.fireToast(typology, message);
          reject();
        } else if (state === 'ERROR') {
          var errors = response.getError();
          if (errors) {
            if (errors[0] && errors[0].message) {
              message = errors[0].message;
              typology = 'Error';
              helper.fireToast(typology, message);
            }
          } else {
            message = 'Unkwon error';
            typology = 'Error';
            helper.fireToast(typology, message);
          }
          reject();
        }
      });
      $A.enqueueAction(action);
    });
  },
  callAnchorEngine: function(component, event, helper) {
    return new Promise((resolve, reject) => {
      var action = component.get('c.callAnchorEngine');
      action.setParams({
        aHasAnalysId: component.get('v.recordId')
      });
      component.set('v.isLoading', true);
      action.setCallback(this, function(response) {
        component.set('v.isLoading', false);
        var state = response.getState();
        var resp = response.getReturnValue();
        var serviceResponse = JSON.parse(resp.message);
        if (state === 'SUCCESS') {
          component.set('v.isOpen', true);
          if (serviceResponse.errorCode === '200' || serviceResponse.errorCode === '201') {
            var columns = [{label: $A.get('$Label.arce.Lc_arce_ValidateRatingScore'), fieldName: 'anchorScore', type: 'number', cellAttributes: { alignment: 'left' }},
              {label: $A.get('$Label.arce.Arc_Gen_RatingAnchor'), fieldName: 'anchorRating', type: 'text', cellAttributes: { alignment: 'center' }}];
            component.set('v.anchorColumns', columns);
            component.set('v.anchorData', [ {anchorScore: resp.anchorScore, anchorRating: resp.anchorRating} ]);
            component.set('v.showAnchor', true);
            resolve();
          } else {
            component.set('v.success', 'no');
            component.set('v.errorTitle', 'ERROR');
            component.set('v.errorCode', $A.get('{!$Label.arce.Arc_Gen_RatingError_ErrorCode}') + ' ' + serviceResponse.errorCode);
            component.set('v.message', serviceResponse.description);
            reject();
          }

        } else {
          component.set('v.success', 'no');
          component.set('v.errorTitle', 'ERROR');
          component.set('v.errorCode', $A.get('{!$Label.arce.Arc_Gen_RatingError_ErrorCode}') + ' ' + serviceResponse.errorCode);
          component.set('v.message', serviceResponse.description);
          reject();
        }
      });
      $A.enqueueAction(action);
    });
  },
  callMultiPersistenceEngine: function(component, event, helper) {
    return new Promise((resolve, reject) => {
      var action = component.get('c.callMultiPersistenceEngine');
      action.setParams({
        aHasAnalysId: component.get('v.recordId'),
        modelSlctd: component.get('v.model')
      });
      component.set('v.isLoading', true);
      action.setCallback(this, function(response) {
        component.set('v.isLoading', false);
        var state = response.getState();
        if (state === 'SUCCESS')  {
          helper.callAnchorEngine(component, event, helper);
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
    });
  },
  fireToast: function(type, message) {
    let toastError = $A.get('e.force:showToast');
    toastError.setParams({
      'title': type + '!',
      'type': type.toLowerCase(),
      'message': message
    });
    toastError.fire();
  }
});