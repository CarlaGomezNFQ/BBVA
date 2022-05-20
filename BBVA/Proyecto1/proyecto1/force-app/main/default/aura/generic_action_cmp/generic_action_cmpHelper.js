({
  navigateProfAnalysis: function(component, profAnalysisId) {
    var navService = component.find('navService');
    if (!navService) {
      window.location.href = '/'  + profAnalysisId;
    } else {
      navService.navigate({
        type: 'standard__recordPage',
        attributes: {
          actionName: 'view',
          objectApiName: 'cuco__profitability_analysis__c',
          recordId: profAnalysisId
        }
      });
    }
  },
  showError: function(errorMessage) {
    var resultsToast = $A.get('e.force:showToast');
    resultsToast.setParams({
      'title': '',
      'type': 'error',
      'message': errorMessage,
      'duration': '8000'
    });
    resultsToast.fire();
    $A.get('e.force:closeQuickAction').fire();
  }
});