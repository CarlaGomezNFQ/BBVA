({
  doInit: function(cmp, evt, helper) {
    $A.util.removeClass(cmp.find('loadSpinner'), 'slds-hide');
    var action = cmp.get('c.getAnalysisPermissions');
    action.setParams({ profAnalysisId: cmp.get('v.recordId') });
    action.setCallback(this, function(response) {
      $A.util.addClass(cmp.find('loadSpinner'), 'slds-hide');
      var state = response.getState();
      if (state === 'SUCCESS') {
        var ret = response.getReturnValue();
        cmp.set('v.manage', ret.manage);
        cmp.set('v.profAnalysis', ret.profAnalysis);
        if (ret.profAnalysis.cuco__gf_pa_comments_desc__c === undefined || ret.profAnalysis.cuco__gf_pa_comments_desc__c === '') {
          cmp.set('v.hasComments', false);
        } else {
          cmp.set('v.hasComments', true);
        }
      } else if (response.getState() === 'ERROR') {
        helper.showNewToastAnalysis('error', response.getError()[0].message);
      }
    });
    $A.enqueueAction(action);
  },
  handleRefreshAnalysis: function(cmp, evt, helper) {
    $A.util.removeClass(cmp.find('loadSpinner'), 'slds-hide');
    let profAnalysis = evt.getParam('psAnalysis');
    let arrProfAnalysis = [];
    arrProfAnalysis.push(profAnalysis);
    let action = cmp.get('c.updatePAAnalysis');
    action.setParams({ lstProfAnalysis: arrProfAnalysis });
    action.setCallback(this, function(response) {
      $A.util.addClass(cmp.find('loadSpinner'), 'slds-hide');
      var state = response.getState();
      if (state === 'SUCCESS') {
        var ret = response.getReturnValue();
        if (Array.isArray(ret) && ret.length !== 0) {
          helper.showNewToastAnalysis('error', ret.join());
        } else {
          cmp.set('v.profAnalysis', profAnalysis);
          if (profAnalysis.cuco__gf_pa_comments_desc__c === undefined || profAnalysis.cuco__gf_pa_comments_desc__c === '') {
            cmp.set('v.hasComments', false);
          } else {
            cmp.set('v.hasComments', true);
          }
        }
      } else if (response.getState() === 'ERROR') {
        helper.showNewToastAnalysis('error', response.getError()[0].message);
      }
    });
    $A.enqueueAction(action);
  },
  checkPAManagePermissions: function(cmp, helper, paramsPAPermissions) {
    return new Promise($A.getCallback(function(resolve, reject) {
      let actionPAPermissions = cmp.get('c.checkManagePAPermissions');
      actionPAPermissions.setParams(paramsPAPermissions);
      actionPAPermissions.setCallback(this, function(responsePAPermissions) {
        if (responsePAPermissions.getState() === 'SUCCESS') {
          let retPermissions = responsePAPermissions.getReturnValue();
          resolve(retPermissions);
        } else if (responsePAPermissions.getState() === 'ERROR') {
          helper.showNewToastAnalysis('error', responsePAPermissions.getError()[0].message);
          reject(responsePAPermissions.getState());
        }
      });
      $A.enqueueAction(actionPAPermissions);
    }));
  },
  createAnalysisEditCmp: function(cmp, helper, nextCmpName, profAnalysis) {
    helper.createNextCmp(cmp, helper, nextCmpName, profAnalysis).then($A.getCallback(newCmp => {
      $A.util.addClass(cmp.find('loadSpinner'), 'slds-hide');
      let body = [];
      body.push(newCmp);
      cmp.set('v.body', body);
    }));
  },
  createNextCmp: function(cmp, helper, cmpName, profAnalysis) {
    return new Promise($A.getCallback(function(resolve, reject) {
      $A.createComponent(
        'cuco:' + cmpName,
        {
          'profAnalysis': profAnalysis
        },
        function(newCmp, status, errorMessage) {
          if (status === 'SUCCESS') {
            resolve(newCmp);
          } else if (status === 'INCOMPLETE' || status === 'ERROR') {
            $A.util.addClass(cmp.find('loadSpinner'), 'slds-hide');
            helper.showNewToastAnalysis('error', errorMessage);
          }
        }
      );
    }));
  },
  showNewToastAnalysis: function(type, message) {
    let titleAnalysisToast;
    switch (type) {
      case 'success':
        titleAnalysisToast = $A.get('$Label.cuco.toast_title_success');
        break;
      case 'warning':
        titleAnalysisToast = $A.get('$Label.cuco.toast_title_warning');
        break;
      case 'error':
        titleAnalysisToast = $A.get('$Label.cuco.toast_title_error');
        break;
    }
    var newAnalysisToast = $A.get('e.force:showToast');
    newAnalysisToast.setParams({
      'title': titleAnalysisToast,
      'type': type,
      'message': message
    });
    newAnalysisToast.fire();
  }
});