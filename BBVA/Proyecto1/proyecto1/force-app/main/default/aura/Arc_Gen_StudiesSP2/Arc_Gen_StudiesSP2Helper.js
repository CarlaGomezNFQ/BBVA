({
  getFFSStable: function(component) {
    var action = component.get('c.getJsonTable');
    action.setParams({
      analysisId: component.get('v.recordId')
    });
    action.setCallback(this, function(response) {
      if (component.isValid() && response.getState() === 'SUCCESS') {
        var res = response.getReturnValue();
        component.set('v.spinnerCmp', false);
        component.set('v.allData', res.newObj);
        this.initPagination(component);
      }
    });
    $A.enqueueAction(action);
  },

  initPagination: function(component, recPerPage) {
    recPerPage = parseInt(recPerPage || component.get('v.recordsPerPage'));
    var allData = component.get('v.allData');
    var totalPages = Math.ceil(allData.length / recPerPage) || 1;
    var currPage = 0;
    var dataToDisplay = allData.slice(currPage, recPerPage);
    component.set('v.totalPages', totalPages);
    component.set('v.displayedData', dataToDisplay);
  },

  moveToPage: function(component, newPage) {
    var allData = component.get('v.allData');
    let previousPage = newPage - 1;
    var recPerPage = parseInt(component.get('v.recordsPerPage'));
    var dataToDisplay = allData.slice(previousPage * recPerPage, newPage * recPerPage);
    component.set('v.displayedData', dataToDisplay);
  }
});