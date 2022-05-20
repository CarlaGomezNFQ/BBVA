({
  init: function(cmp, event, helper) {
    helper.setColumns(cmp);
    helper.setData(cmp);
  },

  update: function(cmp, event, helper) {
    var cmpwrapper = event.getParam('conditionWrp');
    cmp.set('v.conditionWrp', cmpwrapper);
    helper.setDataService(cmp);
  },

  handleAdd: function(cmp, event, helper) {
    let newCmpParams = {
      dataTable : cmp.get('v.data')
    };
    var cmpname = 'PRW_AddFlatProduct'
    if(cmp.get('v.isSpecialCond')) {
      cmpname = 'PRW_AddSpecialProduct';
    }
    helper.showFlatRatesAddCmp(cmp, helper,cmpname, newCmpParams).then($A.getCallback(newCmp => {
      let body = [];
      body.push(newCmp);
      cmp.set('v.body', body);
    }));
  },

  handleProductsSelectContinue: function(cmp, event, helper) {
    helper.handleProductsSelectContinue(cmp, event, helper);
  },

  handleCellEdition: function (cmp, event, helper) {
    var draftValues = event.getParam('draftValues');
    helper.handleCellChange(cmp, event, draftValues);
  },

  handleRowAction: function (cmp, event, helper) {
    var action = event.getParam('action');
    var row = event.getParam('row');

    if(action.name === 'delete') {
      helper.handleDelete(cmp,row);
    }
    if(action.iconName === 'utility:anywhere_chat') {
      let newCmpParams = {
        products : row
      };
      var cmpname = 'PRW_ViewComments'

      helper.showFlatRatesAddCmp(cmp, helper,cmpname, newCmpParams).then($A.getCallback(newCmp => { //NOSONAR
        let body = [];
        body.push(newCmp);
        cmp.set('v.body', body);
      }));
    }
  },
  handleResponseEvent: function (cmp, event, helper) {
    helper.handleResponse(cmp, event, helper);
  }
})