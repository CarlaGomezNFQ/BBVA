({
  fillForfaitEditForm: function(cmp, evt, helper) {
    $A.util.removeClass(cmp.find('loadSpinner'), 'slds-hide');
    let forfaitPkg = cmp.get('v.forfaitPkg');
    let action = cmp.get('c.doInitialActionsForfaitEdit');
    action.setParams({
      'profAnalysisId': cmp.get('v.profAnalysisId'),
      'pkgCatalogId': forfaitPkg.catalogId,
      'isExtended': forfaitPkg.isExtended
    });
    action.setCallback(this, function(response) {
      if (response.getState() === 'SUCCESS') {
        let ret = response.getReturnValue();
        cmp.set('v.lstChargePeriodicity', ret.lstChargePeriodicity);
        cmp.set('v.showExtensionSection', ret.showExtendedSection);

        let lstPkg = [];
        let pkgObj = {
          Id: forfaitPkg.catalogId,
          label: forfaitPkg.code + '. [' + forfaitPkg.description + ']'
        };
        lstPkg.push(pkgObj);
        cmp.set('v.lstPkg', lstPkg);

        let lstParticipant = [];
        let participantObj = {
          participantId: forfaitPkg.participant.id,
          participantName: forfaitPkg.participant.name
        };
        lstParticipant.push(participantObj);
        cmp.set('v.lstParticipants', lstParticipant);
        cmp.set('v.isSuccess', true);
        cmp.set('v.title',  $A.get('$Label.cuco.forfait_pkg_edit_title'));
        cmp.find('pkgSelection').set('v.value', forfaitPkg.catalogId);
        cmp.find('accSelection').set('v.value', forfaitPkg.participant.accountId);
        cmp.find('chargeAmount').set('v.value', forfaitPkg.chargeAmount);
        cmp.find('chargePeriodicity').set('v.value', forfaitPkg.chargePeriodicity.id);
        cmp.find('clientRepName').set('v.value', forfaitPkg.clientRepName);
        cmp.find('clientRepDoc').set('v.value', forfaitPkg.clientRepDocNumber);
        cmp.find('comments').set('v.value', forfaitPkg.comments);
        cmp.set('v.currentDecision', forfaitPkg.isExtended);
        $A.util.addClass(cmp.find('loadSpinner'), 'slds-hide');
      } else if (response.getState() === 'ERROR') {
        helper.showNewToastForfaitPkgEdit('error', response.getError()[0].message);
      }
    });
    $A.enqueueAction(action);
  },
  getFormForfaitEditValues: function(cmp, evt, helper) {
    let mapValuesForfaitEdit = {};
    mapValuesForfaitEdit.pkgSelection = cmp.find('pkgSelection').get('v.value');
    mapValuesForfaitEdit.accSelection = cmp.find('accSelection').get('v.value');
    mapValuesForfaitEdit.chargeAmount = cmp.find('chargeAmount').get('v.value');
    mapValuesForfaitEdit.chargePeriodicity = cmp.find('chargePeriodicity').get('v.value');
    mapValuesForfaitEdit.clientRepName = cmp.find('clientRepName').get('v.value');
    mapValuesForfaitEdit.clientRepDoc = cmp.find('clientRepDoc').get('v.value');
    mapValuesForfaitEdit.comments = cmp.find('comments').get('v.value');
    return mapValuesForfaitEdit;
  },
  checkForfaitEditForm: function(cmp, evt, helper, mapValuesForfaitEdit) {
    let validForfaitEditForm = true;
    Object.keys(mapValuesForfaitEdit).forEach(key => {
      if (mapValuesForfaitEdit[key] === '' && key !== 'comments') {
        validForfaitEditForm = false;
      }
    });
    return validForfaitEditForm;
  },
  handleForfaitEditSave: function(cmp, evt, helper, mapValuesForfaitEdit) {
    let action = cmp.get('c.doPostForfaitEditActions');
    let forfaitPkg = cmp.get('v.forfaitPkg');
    let params = {
      'profAnalysisId': cmp.get('v.profAnalysisId'),
      'step': cmp.get('v.step'),
      'decision': cmp.get('v.currentDecision') ? 'extend' : 'deextend',
      'makeExtensionActions': cmp.get('v.currentDecision') === forfaitPkg.isExtended ? false : true
    };
    action.setParams({
      'strPkgWrapper': JSON.stringify(cmp.get('v.forfaitPkg')),
      'params': params,
      'formParams': mapValuesForfaitEdit
    });
    action.setCallback(this, function(response) {
      $A.util.addClass(cmp.find('loadSpinner'), 'slds-hide');
      if (response.getState() === 'SUCCESS') {
        let ret = response.getReturnValue();
        if (ret.isSuccess) {

          // Refresh forfait package
          let compEventRefreshForfaitEditPkg = $A.get('e.cuco:refresh_forfait_packages_evt');
          compEventRefreshForfaitEditPkg.setParams({'contextId': cmp.get('v.profAnalysisId')});
          compEventRefreshForfaitEditPkg.fire();

          // Refresh participants evt
          let appEventForfaitRefreshConditions = $A.get('e.cuco:refresh_conditions_evt');
          appEventForfaitRefreshConditions.setParams({
            'contextId': cmp.get('v.profAnalysisId')
          });
          appEventForfaitRefreshConditions.fire();

          // Refresh flat evt
          let appEventForfaitRefreshFlat = $A.get('e.cuco:refresh_flat_rates_evt');
          appEventForfaitRefreshFlat.setParams({
            'contextId': cmp.get('v.profAnalysisId')
          });
          appEventForfaitRefreshFlat.fire();

          helper.destroyCmp(cmp, evt, helper);
        } else if (ret.errMessage === undefined) {
          cmp.set('v.lstPAC', ret.lstPAC);
          cmp.set('v.step', '2');
        } else {
          helper.showNewToastForfaitPkgEdit(ret.toastType, ret.errMessage);
        }
      } else if (response.getState() === 'ERROR') {
        helper.showNewToastForfaitPkgEdit('error', response.getError()[0].message);
      }
    });
    $A.enqueueAction(action);
  },
  showNewToastForfaitPkgEdit: function(type, message) {
    let titleForfaitPkgEditToast;
    switch (type) {
      case 'success':
        titleForfaitPkgEditToast = $A.get('$Label.cuco.toast_title_success');
        break;
      case 'warning':
        titleForfaitPkgEditToast = $A.get('$Label.cuco.toast_title_warning');
        break;
      case 'error':
        titleForfaitPkgEditToast = $A.get('$Label.cuco.toast_title_error');
        break;
    }
    var newForfaitPkgEditToast = $A.get('e.force:showToast');
    newForfaitPkgEditToast.setParams({
      'title': titleForfaitPkgEditToast,
      'type': type,
      'message': message
    });
    newForfaitPkgEditToast.fire();
  }
});