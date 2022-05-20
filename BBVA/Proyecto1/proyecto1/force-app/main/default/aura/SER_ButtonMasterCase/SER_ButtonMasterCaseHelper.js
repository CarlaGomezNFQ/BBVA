({
  getMSGResult: function(message, type, title) {
    var toastEvent = $A.get('e.force:showToast');
    toastEvent.setParams({
      title: title,
      message: message,
      type: type,
      mode: 'pester',
      duration: '5000'
    });
    toastEvent.fire();
  }
});