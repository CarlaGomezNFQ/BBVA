({
  doInitialChecks: function(cmp, evt, helper) {
    $A.util.removeClass(cmp.find('loadSpinner'), 'slds-hide');
    let action = cmp.get('c.retrieveForfaitAddData');
    action.setParams({
      'profAnalysisId': cmp.get('v.profAnalysisId')
    });
    action.setCallback(this, function(response) {
      if (response.getState() === 'SUCCESS') {
        let ret = response.getReturnValue();
        ret.lstPsCatPkg.forEach(pkg => pkg.label = pkg.cuco__gf_psc_package_code_id__c + '. [' + pkg.cuco__gf_psc_package_name__c + ']');
        cmp.set('v.lstPkg', ret.lstPsCatPkg);
        cmp.set('v.lstParticipants', ret.lstPW);
        cmp.set('v.lstChargePeriodicity', ret.lstChargePeriodicity);

        let forfaitPkg = cmp.get('v.forfaitPkg');
        cmp.set('v.isSuccess', true);
        if (forfaitPkg === null) {
          cmp.set('v.title',  $A.get('$Label.cuco.forfait_pkg_add_title'));
          cmp.set('v.mode', 'add');
        } else {
          cmp.set('v.title',  $A.get('$Label.cuco.forfait_pkg_edit_title'));
          cmp.set('v.mode', 'edit');
          cmp.find('pkgSelection').set('v.value', forfaitPkg.catalogId);
          cmp.find('accSelection').set('v.value', forfaitPkg.participant.accountId);
          cmp.find('chargeAccount').set('v.value', forfaitPkg.chargeAccount);
          cmp.find('chargeAmount').set('v.value', forfaitPkg.chargeAmount);
          cmp.find('chargePeriodicity').set('v.value', forfaitPkg.chargePeriodicity.id);
          cmp.find('clientRepName').set('v.value', forfaitPkg.clientRepName);
          cmp.find('clientRepDoc').set('v.value', forfaitPkg.clientRepDocNumber);
          cmp.find('bankRepName').set('v.value', forfaitPkg.bankRepName);
          cmp.find('bankRepDoc').set('v.value', forfaitPkg.bankRepDocNumber);
          cmp.find('signingLocation').set('v.value', forfaitPkg.signingLocation);
          cmp.find('comments').set('v.value', forfaitPkg.comments);
        }
        $A.util.addClass(cmp.find('loadSpinner'), 'slds-hide');
      } else if (response.getState() === 'ERROR') {
        helper.showNewToastForfaitPkgAdd('error', response.getError()[0].message);
      }
    });
    $A.enqueueAction(action);
  },
  getFormValues: function(cmp, evt, helper) {
    let mapValues = {};
    mapValues.pkgSelection = cmp.find('pkgSelection').get('v.value');
    mapValues.accSelection = cmp.find('accSelection').get('v.value');
    mapValues.chargeAccount = cmp.find('chargeAccount').get('v.value');
    mapValues.chargeAmount = cmp.find('chargeAmount').get('v.value');
    mapValues.chargePeriodicity = cmp.find('chargePeriodicity').get('v.value');
    mapValues.clientRepName = cmp.find('clientRepName').get('v.value');
    mapValues.clientRepDoc = cmp.find('clientRepDoc').get('v.value');
    mapValues.bankRepName = cmp.find('bankRepName').get('v.value');
    mapValues.bankRepDoc = cmp.find('bankRepDoc').get('v.value');
    mapValues.signingLocation = cmp.find('signingLocation').get('v.value');
    mapValues.comments = cmp.find('comments').get('v.value');
    return mapValues;
  },
  checkForm: function(cmp, evt, helper, mapValues) {
    let validForm = true;
    Object.keys(mapValues).forEach(key => {
      if (mapValues[key] === '' && key !== 'comments') {
        validForm = false;
      }
    });
    return validForm;
  },
  addNewForfait: function(cmp, evt, helper, mapValues) {
    let action = cmp.get('c.addNewForfaitPkg');
    action.setParams({
      'profAnalysisId': cmp.get('v.profAnalysisId'),
      'formParams': mapValues,
      'mode': cmp.get('v.mode')
    });
    action.setCallback(this, function(response) {
      $A.util.addClass(cmp.find('loadSpinner'), 'slds-hide');
      if (response.getState() === 'SUCCESS') {
        let ret = response.getReturnValue();
        if (ret.isSuccess) {
          let compEvtRefreshForfaitAddPkg = $A.get('e.cuco:refresh_forfait_packages_evt');
          compEvtRefreshForfaitAddPkg.setParams({'contextId': cmp.get('v.profAnalysisId')});
          compEvtRefreshForfaitAddPkg.fire();
          helper.destroyCmp(cmp, evt, helper);
        } else {
          helper.showNewToastForfaitPkgAdd(ret.toastType, ret.errMessage);
        }
      } else if (response.getState() === 'ERROR') {
        helper.showNewToastForfaitPkgAdd('error', response.getError()[0].message);
      }
    });
    $A.enqueueAction(action);
  },
  showNewToastForfaitPkgAdd: function(type, message) {
    let titleForfaitPkgAddToast;
    switch (type) {
      case 'success':
        titleForfaitPkgAddToast = $A.get('$Label.cuco.toast_title_success');
        break;
      case 'warning':
        titleForfaitPkgAddToast = $A.get('$Label.cuco.toast_title_warning');
        break;
      case 'error':
        titleForfaitPkgAddToast = $A.get('$Label.cuco.toast_title_error');
        break;
    }
    var newForfaitPkgAddToast = $A.get('e.force:showToast');
    newForfaitPkgAddToast.setParams({
      'title': titleForfaitPkgAddToast,
      'type': type,
      'message': message
    });
    newForfaitPkgAddToast.fire();
  }
});