({
  getMsgResult: function(message, type, title, event) {
    var resultsToast = $A.get('e.force:showToast');
    resultsToast.setParams({
      title: title,
      message: message,
      duration: '5000',
      type: type
    });
    $A.get('e.force:closeQuickAction').fire();
    resultsToast.fire();
    $A.get('e.force:refreshView').fire();
  }
});