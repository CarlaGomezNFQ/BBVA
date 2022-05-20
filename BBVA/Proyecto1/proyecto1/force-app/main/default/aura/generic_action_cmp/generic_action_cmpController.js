({
  handleEvent: function(component, event, helper) {
    let status = event.getParam('success');
    if (status === true) {
      let profAnalysisId = event.getParam('profitabilityAnalysisId');
      helper.navigateProfAnalysis(component, profAnalysisId);
    } else {
      let errorMessage = event.getParam('errorMessage');
      helper.showError(errorMessage);
    }
  }
});