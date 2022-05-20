({
  doInit: function(cmp, evt, helper) {
    helper.getParticpantHrcy(cmp, evt, helper);
  },
  getParticpantHrcy: function(cmp, evt, helper) {
    $A.util.removeClass(cmp.find('loadSpinner'), 'slds-hide');
    let action = cmp.get('c.getParticpantHrcy');
    action.setParams({
      'recordId': cmp.get('v.inputAttributes.recordId'),
      'sObjectName': cmp.get('v.sObjectName')
    });
    action.setCallback(helper, function(response) {
      $A.util.addClass(cmp.find('loadSpinner'), 'slds-hide');
      if (response.getState() === 'SUCCESS') {
        let ret = response.getReturnValue();
        cmp.set('v.LName', ret.LName);
        cmp.set('v.Name', ret.Name);
        cmp.set('v.Type', ret.Type);
        cmp.set('v.tableTitle', ret.tableTitle);

        //cmp.set('v.tableSubTitle', ret.subtableTitle); Commented for rollback in future, if needed
        cmp.set('v.gridColumns', [
          {
            label: $A.get('$Label.cuco.name'),
            fieldName: 'id',
            type: 'url',
            typeAttributes: {label: {fieldName: 'name'}},
            cellAttributes: {class: {fieldName: 'testCSSClassName'}}
          },
          {
            label: $A.get('$Label.cuco.participants_number'),
            fieldName: 'filiales',
            type: 'text',
            cellAttributes: {class: {fieldName: 'testCSSClassPartNumber'}}
          },
          {
            label: $A.get('$Label.cuco.status'),
            fieldName: 'status', type: 'text',
            cellAttributes: {
              iconName: { fieldName: 'icono'},
              iconPosition: 'left',
              size: 'small',
              class: {fieldName: 'testCSSClassStatus'}}
          },
          {
            label: $A.get('$Label.cuco.last_date'),
            fieldName: 'lastdate',
            type: 'text',
            cellAttributes: {class: {fieldName: 'testCSSClassDate'}}
          },
        ]);
        var data = ret.gritdata;
        if (data !== undefined) {
          var temojson = JSON.parse(JSON.stringify(data).split('items').join('_children'));
          var AllRows = helper.expandAllRows(temojson);
          temojson = helper.datajsonParsed(cmp, evt, helper, temojson);
          cmp.set('v.gridData', JSON.parse(temojson));
          cmp.set('v.currentId', ret.currentId);
          cmp.set('v.currentps', ret.currentps);
          cmp.set('v.gridExpandedRows', AllRows);
        }

        cmp.set('v.isSuccess', true);
      } else if (response.getState() === 'ERROR') {
        helper.showNewToast('Error', 'error', response.getError()[0].message);
      }
    });
    $A.enqueueAction(action);
  },
  handleCreate: function(cmp, evt, helper) {
    $A.util.removeClass(cmp.find('loadSpinner'), 'slds-hide');
    var recordId = cmp.get('v.inputAttributes.recordId');
    let action = cmp.get('c.handleCreatedAction');
    action.setParams({
      'recordId': recordId
    });
    action.setCallback(helper, function(response) {
      $A.util.addClass(cmp.find('loadSpinner'), 'slds-hide');
      if (response.getState() === 'SUCCESS') {
        let ret = response.getReturnValue();
        if (ret.create) {
          helper.doNextComponent(cmp, evt, helper);
        } else {
          cmp.set('v.showErrBanner', true);
          cmp.set('v.errMessageBanner', ret.createMessage);
        }
      } else if (response.getState() === 'ERROR') {
        helper.showNewToast('Error', 'error', response.getError()[0].message);
      }
    });
    $A.enqueueAction(action);
  },
  doNextComponent: function(cmp, evt, helper) {
    var inputObject = cmp.get('v.inputAttributes');
    var compEvent = cmp.getEvent('dynamicFlowWizardContinue');
    compEvent.setParams({'inputAttributes': inputObject, 'nextComponent': 'cuco:pacreation_cmp'});
    compEvent.fire();
  },
  showNewToast: function(title, type, message) {
    var newToast = $A.get('e.force:showToast');
    newToast.setParams({
      'title': title,
      'type': type,
      'message': message
    });
    newToast.fire();
  },
  datajsonParsed: function(cmp, evt, helper, temojson) {
    var jsonParsed = JSON.parse(temojson);
    for (var i = 0; i < jsonParsed.length; i++) {
      jsonParsed[i].testCSSClassName = (jsonParsed[i].label !== $A.get('$Label.cuco.without_inProgress_pa')) ? 'slds-tree__item' : 'testCSSClass1';
      jsonParsed[i].testCSSClassName = jsonParsed[i].testCSSClassName + ' psCss';
      jsonParsed[i].testCSSClassPartNumber = 'psCss';
      jsonParsed[i].testCSSClassStatus = 'psCss slds-text-title_caps';
      jsonParsed[i].testCSSClassDate = 'psCss';

      if (jsonParsed[i]._children.length > 0) {
        for (var k = 0; k < jsonParsed[i]._children.length; k++) {
          jsonParsed[i]._children[k].filiales = '';
          jsonParsed[i]._children[k].testCSSClassName = (jsonParsed[i]._children[k].name !== $A.get('$Label.cuco.without_inProgress_pa'))
            ? 'slds-tree__item'
            : 'testCSSClass1 slds-tree__item';
        }
      }
      var icon = helper.getIcon(jsonParsed[i].status);
      jsonParsed[i].icono = icon;
      if (jsonParsed[i]._children.length === 0) {
        jsonParsed[i].icono = null;
      }
      if (jsonParsed[i].lastdate !== null) {
        jsonParsed[i].lastdate = $A.localizationService.formatDate(jsonParsed[i].lastdate, 'dd/MM/yyyy');
      }
    }
    temojson = JSON.stringify(jsonParsed);
    return temojson;
  },
  getIcon: function(status) {
    let icon;
    switch (status) {
      case  $A.get('$Label.cuco.ps_valid_status'):
        icon = 'utility:check';
        break;
      case $A.get('$Label.cuco.ps_expired_status'):
        icon = 'utility:warning';
        break;
      case $A.get('$Label.cuco.ps_cancelled_status'):
        icon = 'utility:close';
        break;
    }
    return icon;
  },
  viewRecord: function(cmp, event, helper) {
    var recId = event.getParam('row').id;
    var actionName = event.getParam('action').name;
    if (actionName === 'View') {
      var viewRecordEvent = $A.get('e.force:navigateToURL');
      viewRecordEvent.setParams({
        'url': '/' + recId
      });
      viewRecordEvent.fire();
    }
  },
  expandAllRows: function(temojson) {
    var jsonParsed = JSON.parse(temojson);
    let AllRows = [];
    for (var i = 0; i < jsonParsed.length; i++) {
      AllRows.push(jsonParsed[i].name);
    }
    return AllRows;
  },
  btnCancel: function(cmp) {
    var cancEvent = cmp.getEvent('dynamicFlowWizardCancel');
    cancEvent.fire();
  }
});