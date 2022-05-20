({
  searchRecordsHelper: function(component, event, helper, value) {
    $A.util.removeClass(component.find('Spinner'), 'slds-hide');
    var searchString = component.get('v.searchString');
    component.set('v.message', '');
    component.set('v.recordsList', []);

    // Calling Apex Method
    var action = component.get('c.fetchRecords');
    var requestW = new Object();
    requestW.objectName = component.get('v.objectName');
    requestW.filterField = component.get('v.fieldName');
    requestW.searchString = searchString;
    requestW.value = value;
    requestW.queryFields = component.get('v.queryFields');
    action.setParams({'request': requestW});
    action.setCallback(this, function(response) {
      if (response.getState() === 'SUCCESS') {
        helper.treatResult(component, value, searchString, response);
      } else {
        // If server throws any error
        var errors = response.getError();
        var errorsAux = errors && errors[0] && errors[0].message;
        if (errorsAux) {
          component.set('v.message', errors[0].message);
        }
      }

      // To open the drop down list of records
      if ($A.util.isEmpty(value)) {
        $A.util.addClass(component.find('resultsDiv'), 'slds-is-open');
        $A.util.addClass(component.find('Spinner'), 'slds-hide');
      }
    });
    $A.enqueueAction(action);
  },

  treatResult: function(component, value, searchString, response) {
    var isNotQueryFields;
    isNotQueryFields = component.get('v.queryFields') === '' || component.get('v.queryFields') === null;
    var result;
    if (isNotQueryFields) {
      result = response.getReturnValue().recordsDataList;
    } else {
      result = response.getReturnValue().rdListWFields;
    }
    if (result.length > 0) {
      // To check if value attribute is prepopulated or not
      if ($A.util.isEmpty(value)) {
        component.set('v.recordsList', result);
      } else {
        component.set('v.selectedRecord', isNotQueryFields ? result[0] : result[0][0]);
        component.set('v.recordsList', result);
      }
    } else {
      component.set('v.message', 'No Records Found for "' + searchString + '"');
    }
  }
});