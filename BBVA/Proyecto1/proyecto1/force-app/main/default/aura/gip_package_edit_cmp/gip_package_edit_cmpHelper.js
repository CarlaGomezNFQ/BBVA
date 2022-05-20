({
  fillGipEditForm: function(cmp, evt, helper) {
    $A.util.removeClass(cmp.find('loadSpinner'), 'slds-hide');
    cmp.set('v.title',  $A.get('$Label.cuco.gip_pkg_edit_title'));
    let gipPkg = cmp.get('v.gipPkg');
    cmp.find('pkgDescription').set('v.value', gipPkg.description);
    let lstParticipant = [];
    let participantObj = {
      participantId: gipPkg.participant.id,
      participantName: gipPkg.participant.name
    };
    lstParticipant.push(participantObj);
    cmp.set('v.lstParticipants', lstParticipant);
    cmp.find('accSelection').set('v.value', gipPkg.participant.id);
    cmp.find('clientRepName').set('v.value', gipPkg.clientRepName);
    cmp.find('clientRepDoc').set('v.value', gipPkg.clientRepDocNumber);
    cmp.find('comments').set('v.value', gipPkg.comments);
    $A.util.addClass(cmp.find('loadSpinner'), 'slds-hide');
  },
  getGipEditFormValues: function(cmp, evt, helper) {
    let mapGipEditValues = {};
    mapGipEditValues.pkgDescription = cmp.find('pkgDescription').get('v.value');
    mapGipEditValues.accSelection = cmp.find('accSelection').get('v.value');
    mapGipEditValues.clientRepName = cmp.find('clientRepName').get('v.value');
    mapGipEditValues.clientRepDoc = cmp.find('clientRepDoc').get('v.value');
    mapGipEditValues.comments = cmp.find('comments').get('v.value');
    return mapGipEditValues;
  },
  checkEditGipForm: function(cmp, evt, helper, mapGipEditValues) {
    let validGipForm = true;
    Object.keys(mapGipEditValues).forEach(key => {
      if (mapGipEditValues[key] === '' && key !== 'comments') {
        validGipForm = false;
      }
    });
    return validGipForm;
  },
  editNewGip: function(cmp, evt, helper, mapGipEditValues) {
    let action = cmp.get('c.doPostGipEditActions');
    action.setParams({
      'strPkgWrapper': JSON.stringify(cmp.get('v.gipPkg')),
      'profAnalysisId': cmp.get('v.profAnalysisId'),
      'formParams': mapGipEditValues
    });
    action.setCallback(this, function(response) {
      $A.util.addClass(cmp.find('loadSpinner'), 'slds-hide');
      if (response.getState() === 'SUCCESS') {
        let ret = response.getReturnValue();
        if (ret.isSuccess) {
          let compEventRefreshGipEditPkg = $A.get('e.cuco:refresh_gip_packages_evt');
          compEventRefreshGipEditPkg.setParams({'contextId': cmp.get('v.profAnalysisId')});
          compEventRefreshGipEditPkg.fire();
          helper.destroyCmp(cmp, evt, helper);
        } else {
          helper.showNewToastForfaitPkgEdit(ret.toastType, ret.errMessage);
        }
      } else if (response.getState() === 'ERROR') {
        helper.showNewToastForfaitPkgEdit('error', response.getError()[0].message);
      }
    });
    $A.enqueueAction(action);
  },
  showNewToastGipPkgEdit: function(type, message) {
    let titleGipPkgEditToast;
    switch (type) {
      case 'success':
        titleGipPkgEditToast = $A.get('$Label.cuco.toast_title_success');
        break;
      case 'warning':
        titleGipPkgEditToast = $A.get('$Label.cuco.toast_title_warning');
        break;
      case 'error':
        titleGipPkgEditToast = $A.get('$Label.cuco.toast_title_error');
        break;
    }
    var newGipPkgEditToast = $A.get('e.force:showToast');
    newGipPkgEditToast.setParams({
      'title': titleGipPkgEditToast,
      'type': type,
      'message': message
    });
    newGipPkgEditToast.fire();
  }
});