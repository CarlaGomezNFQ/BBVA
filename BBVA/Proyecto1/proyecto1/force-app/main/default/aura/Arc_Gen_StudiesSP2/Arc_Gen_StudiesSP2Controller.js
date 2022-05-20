({
  doInit: function(component, event, helper) {
    component.set('v.columnsSP2', [
      {label: 'Rating ID', fieldName: 'id', type: 'text'},
      {label: 'Date of Analysis', fieldName: 'evalDate', type: 'text'},
      {label: 'Final long scale rating', fieldName: 'scale', type: 'text'},
      {label: 'FFSS Date  (Standalone Rating)', fieldName: 'evaluationDate', type: 'text'},
      {label: 'FFSS ID', fieldName: 'shortId', type: 'text'},
      {label: 'Months of the period', fieldName: 'months', type: 'text'},
      {label: 'Certification type', fieldName: 'certification', type: 'text'},
      {label: 'Audit opinion', fieldName: 'audit', type: 'text'},
      {label: 'Adjustment', fieldName: 'adjustment', type: 'text'},
      {label: 'FFSS Type', fieldName: 'ffssType', type: 'text'},
      {label: 'Rating validity start date', fieldName: 'validity', type: 'text'},
      {label: 'Rating model', fieldName: 'model', type: 'text'},
      {label: 'Rating validated by', fieldName: 'validated', type: 'text'}
    ]);
    component.set('v.recordsPerPageOpts', [
      {'label': '10', 'value': '10'},
      {'label': '15', 'value': '15'},
      {'label': '20', 'value': '20'}
    ]);

    helper.getFFSStable(component);
  },
  doSelect: function(component, event) {
    var selectedRows = event.getParam('selectedRows');
    component.set('v.jsonRow', selectedRows[0]);
    component.set('v.view', true);
  },
  clickNavigation: function(component, event, helper) {
    var buttonElement = event.getSource().get('v.name');
    var currPage = component.get('v.currentPage');
    var totalPages = component.get('v.totalPages');

    switch (buttonElement) {
      case 'first':
        currPage = 1;
        break;
      case 'previous':
        currPage -= currPage > 0 ? 1 : 0;
        break;
      case 'next':
        currPage += currPage <= totalPages - 1 ? 1 : 0; // currPage 1 based || totalPages 1 based
        break;
      case 'last':
        currPage = totalPages;
        break;
    }
    helper.moveToPage(component, currPage);
    component.set('v.currentPage', currPage);
  },
  recPerPageChanged: function(component, event, helper) {
    var newRecPerPage = event.getParam('value');
    helper.initPagination(component, newRecPerPage);
  }
});