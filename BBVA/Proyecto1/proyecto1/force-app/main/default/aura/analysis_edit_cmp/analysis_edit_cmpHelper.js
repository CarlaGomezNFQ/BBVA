({
  doInit: function(cmp, evt, helper) {
    let profAnalysis = cmp.get('v.profAnalysis');
    cmp.set('v.hasContractException', profAnalysis.cuco__gf_all_ct_apply_cond_ind_type__c);
    $A.util.addClass(cmp.find('loadSpinner'), 'slds-hide');
  },
  handleSave: function(cmp, evt, helper) {
    $A.util.removeClass(cmp.find('loadSpinner'), 'slds-hide');
    let profAnalysis = cmp.get('v.profAnalysis');
    let hasFillMandatoryFields = helper.checkMandatoryFields(profAnalysis);
    if (hasFillMandatoryFields) {
      cmp.set('v.emptyMandatoryFields', false);
      if (!profAnalysis.cuco__gf_all_ct_apply_cond_ind_type__c) {
        profAnalysis.cuco__gf_pa_all_ct_cond_app_rsn_desc__c = '';
      }
      let refreshAnalysisEvt = $A.get('e.cuco:refresh_analysis_evt');
      refreshAnalysisEvt.setParams({ psAnalysis: profAnalysis });
      refreshAnalysisEvt.fire();
      helper.destroyCmp(cmp, evt, helper);
    } else {
      cmp.set('v.emptyMandatoryFields', true);
      $A.util.addClass(cmp.find('loadSpinner'), 'slds-hide');
    }
  },
  checkMandatoryFields: function(profAnalysis) {
    if (profAnalysis.cuco__gf_all_ct_apply_cond_ind_type__c) {
      return (profAnalysis.cuco__gf_pa_all_ct_cond_app_rsn_desc__c !== undefined && profAnalysis.cuco__gf_pa_all_ct_cond_app_rsn_desc__c !== '');
    } else {
      return true;
    }
  }
});