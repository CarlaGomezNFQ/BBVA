({
  getExternalDocumentInfo: function(cmp, evt, helper) {
    $A.util.removeClass(cmp.find('simpleSpinner'), 'slds-hide');
    let action = cmp.get('c.getExternalDocumentInfo');
    action.setParams({
      'recordId': cmp.get('v.recordId')
    });
    action.setCallback(this, function(response) {
      $A.util.addClass(cmp.find('simpleSpinner'), 'slds-hide');
      if (response.getState() === 'SUCCESS') {
        let extDocList = response.getReturnValue();
        cmp.set('v.showCmp', extDocList.length !== 0);
        cmp.set('v.extDocList', extDocList);
        cmp.set('v.showAllDocs', false);
      } else if (response.getState() === 'ERROR') {
        helper.showNewToastExternalDocuments('error', response.getError()[0].message);
      }
    });
    $A.enqueueAction(action);
  },
  getPicassoWSResponse: function(cmp, evt, helper, dataDoc) {
    $A.util.removeClass(cmp.find('simpleSpinner'), 'slds-hide');
    let action = cmp.get('c.getPicassoWSResponse');
    action.setParams({
      'operationId': dataDoc[0],
      'docId': dataDoc[1]
    });
    action.setCallback(this, function(response) {
      $A.util.addClass(cmp.find('simpleSpinner'), 'slds-hide');
      if (response.getState() === 'SUCCESS') {
        let ret = response.getReturnValue();
        if (ret.isSuccess) {
          helper.goToURL(cmp, evt, helper, ret.url);
        } else {
          helper.showNewToastExternalDocuments('error', ret.errMessage);
        }
      } else if (response.getState() === 'ERROR') {
        helper.showNewToastExternalDocuments('error', response.getError()[0].message);
      }
    });
    $A.enqueueAction(action);
  },
  goToURL: function(cmp, evt, helper, url) {
    let urlEvent = $A.get('e.force:navigateToURL');
    urlEvent.setParams({
      'url': url
    });
    urlEvent.fire();
  },
  changeDocVisibility: function(cmp, evt, helper) {
    let hasShowAllDocs = cmp.get('v.showAllDocs');
    cmp.set('v.showAllDocs', !hasShowAllDocs);
    evt.getSource().set('v.label', !hasShowAllDocs ? $A.get('$Label.cuco.ext_docs_view_less') : $A.get('$Label.cuco.ext_docs_view_all'));
  },
  showNewToastExternalDocuments: function(type, message) {
    let titleExternalDocumentsToast;
    switch (type) {
      case 'success':
        titleExternalDocumentsToast = $A.get('$Label.cuco.toast_title_success');
        break;
      case 'warning':
        titleExternalDocumentsToast = $A.get('$Label.cuco.toast_title_warning');
        break;
      case 'error':
        titleExternalDocumentsToast = $A.get('$Label.cuco.toast_title_error');
        break;
    }
    var newExternalDocumentsToast = $A.get('e.force:showToast');
    newExternalDocumentsToast.setParams({
      'title': titleExternalDocumentsToast,
      'type': type,
      'message': message
    });
    newExternalDocumentsToast.fire();
  }
});