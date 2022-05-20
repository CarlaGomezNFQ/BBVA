({
  doInit: function(cmp, evt, helper) {
    let action = cmp.get('c.checkAnalysisInProgress');
    action.setParams({
      'profSheetId': cmp.get('v.recordId')
    });
    action.setCallback(this, function(response) {
      if (response.getState() === 'SUCCESS') {
        let ret = response.getReturnValue();
        var messageBarEvt = $A.get('e.mbr:messageBar_evt');
        messageBarEvt.setParams({
          recordId: cmp.get('v.recordId'),
          bannerId: cmp.get('v.paAlertBannerId'),
          display: ret.showBanner,
          message: ret.textToShow,
          iconName: 'utility:info',
          iconVariant: 'inverse',
          style: 'slds-theme_info'
        });
        if (ret.showBanner) {
          cmp.set('v.profAnId', '/' + ret.recordIdToNavigate);
        }
        messageBarEvt.fire();
      } else if (response.getState() === 'ERROR') {
        var toastEvent = $A.get('e.force:showToast');
        toastEvent.setParams({
          'title': 'Error',
          'type': 'error',
          'message': response.getError()[0].message
        });
        toastEvent.fire();
      }
    });
    $A.enqueueAction(action);
  }
});