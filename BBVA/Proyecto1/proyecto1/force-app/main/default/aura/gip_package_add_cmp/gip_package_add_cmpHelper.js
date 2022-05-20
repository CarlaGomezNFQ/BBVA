({
  doInitialGipChecks: function(cmp, evt, helper) {
    $A.util.removeClass(cmp.find('loadSpinner'), 'slds-hide');
    let action = cmp.get('c.retrieveGipAddData');
    action.setParams({
      'profAnalysisId': cmp.get('v.profAnalysisId')
    });
    action.setCallback(this, function(response) {
      if (response.getState() === 'SUCCESS') {
        let ret = response.getReturnValue();
        cmp.set('v.lstParticipants', ret.lstPW);
        let gipPkg = cmp.get('v.gipPkg');
        cmp.set('v.isSuccess', true);
        if (gipPkg === null) {
          cmp.set('v.title',  $A.get('$Label.cuco.gip_pkg_add_title'));
          cmp.set('v.mode', 'add');
        } else {
          cmp.set('v.title',  $A.get('$Label.cuco.gip_pkg_edit_title'));
          cmp.set('v.mode', 'edit');
          cmp.find('pkgDescription').set('v.value', gipPkg.description);
          cmp.find('accSelection').set('v.value', gipPkg.participant.accountId);
          cmp.find('clientRepName').set('v.value', gipPkg.clientRepName);
          cmp.find('clientRepDoc').set('v.value', gipPkg.clientRepDocNumber);
          cmp.find('bankRepName').set('v.value', gipPkg.bankRepName);
          cmp.find('bankRepDoc').set('v.value', gipPkg.bankRepDocNumber);
          cmp.find('signingLocation').set('v.value', gipPkg.signingLocation);
          cmp.find('comments').set('v.value', gipPkg.comments);
        }
        $A.util.addClass(cmp.find('loadSpinner'), 'slds-hide');
      } else if (response.getState() === 'ERROR') {
        helper.showNewToastGipPkgAdd('error', response.getError()[0].message);
      }
    });
    $A.enqueueAction(action);
  },
  getGipFormValues: function(cmp, evt, helper) {
    let mapGipValues = {};
    mapGipValues.pkgDescription = cmp.find('pkgDescription').get('v.value');
    mapGipValues.accSelection = cmp.find('accSelection').get('v.value');
    mapGipValues.clientRepName = cmp.find('clientRepName').get('v.value');
    mapGipValues.clientRepDoc = cmp.find('clientRepDoc').get('v.value');
    mapGipValues.bankRepName = cmp.find('bankRepName').get('v.value');
    mapGipValues.bankRepDoc = cmp.find('bankRepDoc').get('v.value');
    mapGipValues.signingLocation = cmp.find('signingLocation').get('v.value');
    mapGipValues.comments = cmp.find('comments').get('v.value');
    return mapGipValues;
  },
  checkGipForm: function(cmp, evt, helper, mapGipValues) {
    let validGipForm = true;
    Object.keys(mapGipValues).forEach(key => {
      if (mapGipValues[key] === '' && key !== 'comments') {
        validGipForm = false;
      }
    });
    return validGipForm;
  },
  addNewGip: function(cmp, evt, helper, mapGipValues) {
    let action = cmp.get('c.addNewGipPkg');
    let gipPkg = cmp.get('v.gipPkg');
    if (gipPkg !== null) {
      mapGipValues.pkgSelection = gipPkg.catalogId;
    }
    action.setParams({
      'profAnalysisId': cmp.get('v.profAnalysisId'),
      'formParams': mapGipValues,
      'mode': cmp.get('v.mode')
    });
    action.setCallback(this, function(response) {
      $A.util.addClass(cmp.find('loadSpinner'), 'slds-hide');
      if (response.getState() === 'SUCCESS') {
        let ret = response.getReturnValue();
        if (ret.isSuccess) {
          let compEvtRefreshGipAddPkg = $A.get('e.cuco:refresh_gip_packages_evt');
          compEvtRefreshGipAddPkg.setParams({'contextId': cmp.get('v.profAnalysisId')});
          compEvtRefreshGipAddPkg.fire();
          helper.destroyCmp(cmp, evt, helper);
        } else {
          helper.showNewToastGipPkgAdd(ret.toastType, ret.errMessage);
        }
      } else if (response.getState() === 'ERROR') {
        helper.showNewToastGipPkgAdd('error', response.getError()[0].message);
      }
    });
    $A.enqueueAction(action);
  },
  showNewToastGipPkgAdd: function(type, message) {
    let titleGipPkgAddToast;
    switch (type) {
      case 'success':
        titleGipPkgAddToast = $A.get('$Label.cuco.toast_title_success');
        break;
      case 'warning':
        titleGipPkgAddToast = $A.get('$Label.cuco.toast_title_warning');
        break;
      case 'error':
        titleGipPkgAddToast = $A.get('$Label.cuco.toast_title_error');
        break;
    }
    var newGipPkgAddToast = $A.get('e.force:showToast');
    newGipPkgAddToast.setParams({
      'title': titleGipPkgAddToast,
      'type': type,
      'message': message
    });
    newGipPkgAddToast.fire();
  }
});