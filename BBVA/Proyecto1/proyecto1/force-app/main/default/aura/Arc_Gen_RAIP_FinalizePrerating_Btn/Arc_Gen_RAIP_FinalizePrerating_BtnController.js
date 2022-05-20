({
  fetchIdFromUrl: function(component, event, helper) {
    var arceId = '';
    var pathArray = window.location.href.split('/');
    for (let aux = 0; aux < pathArray.length; aux++) {
      if (pathArray[aux] === 'arce__Analysis__c') {
        arceId = pathArray[aux + 1];
      }
    }

    component.set('v.hasRecordId', arceId);
  },

  handleConfirm: function(component, event, helper) {
    // Declare event outside promise as it appears to be undefined if
    // fetched from inside the promise (bug in Salesforce?).

    component.set('v.loading', true);
    component.set('v.errorMessage', '');

    const finalizePromise = helper.callFinalizeRaip(component, component.get('v.hasRecordId'));
    finalizePromise.then(function() {
      // Success toast.
      const toastEvent = $A.get('e.force:showToast');
      toastEvent.setParams({
        title: $A.get('$Label.c.Arc_Gen_Toast_Success'),
        message: $A.get('$Label.c.Arc_Gen_FinalizePreratingSuccess'),
        type: 'success',
        duration: 3000
      });
      toastEvent.fire();

      // Emit refresh event.
      $A.get('e.force:refreshView').fire();

      // Refresh TabSet.
      helper.refreshTab();
    }).catch(function(errors) {
      component.set('v.loading', false);
      component.set('v.errorMessage', errors[0].message);
    });
  },

  handleCancel: function(component, event, helper) {
    // Emit refresh event.
    $A.get('e.force:refreshView').fire();
  }
});