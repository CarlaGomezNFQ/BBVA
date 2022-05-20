/* eslint-disable no-unused-expressions */
({
  checkTitle: function(component, event, helper) {
    var profAnalysisId = component.get('v.inputAttributes').recordId;
    var source = component.get('v.inputAttributes').source;
    component.set('v.recordId', profAnalysisId);
    component.set('v.source', source);

    // Get detail content
    var action = component.get('c.formalize');
    action.setParams({
      'profAnalysisId': profAnalysisId
    });
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (component.isValid() && state === 'SUCCESS') {
        var ret = response.getReturnValue();

        if (ret.typology === $A.get('$Label.cuco.cancellation')) {
          component.set('v.customTitle', $A.get('$Label.cuco.form_cancellation_title'));
        } else {
          component.set('v.customTitle', $A.get('$Label.cuco.form_title'));
        }

        component.set('v.typology', ret.typology);
        component.set('v.formType', ret.formType);
        component.set('v.isActivePrice', ret.isActivePrice);
        component.set('v.originEndDate', ret.originEndDate);
        component.set('v.originStartDate', ret.originStartDate);
        component.set('v.endDate', ret.endDate);
        component.set('v.endDateAudit', $A.localizationService.formatDate(ret.endDate, 'dd/MM/yyyy'));
        component.set('v.profAnalysisStatus', ret.profAnalysisStatus);
        component.set('v.isNotPicassoFail', ret.profAnalysisStatus === 'Pending Send for Manual Formalization' ? true : false);
        component.set('v.profAnalysisStartDate', ret.profAnalysisStartDate);
        if (ret.endDate === null || ret.endDate === undefined) {
          component.set('v.endNotEmpty', false);
        } else {
          var endFormated = helper.formatDate(component, ret.endDate);
          component.set('v.endDateFormat', endFormated);
        }
        component.set('v.arceDate', ret.arceDate);

        helper.manageComments(component, event, helper);
        helper.arceExpiration(component, event, helper);
        $A.util.addClass(component.find('simpleSpinner'), 'slds-hide');
        component.set('v.isSuccess', true);
      }
    });
    $A.enqueueAction(action);
  },
  manageComments: function(component, event, helper) {
    var formType = component.get('v.formType');
    var typology = component.get('v.typology');

    var customMessage;
    if (formType === $A.get('$Label.cuco.form_combined_method')) {
      if (typology === $A.get('$Label.cuco.cancellation')) {
        customMessage = $A.get('$Label.cuco.form_cancellation_manual_comments');
      } else {
        customMessage = $A.get('$Label.cuco.form_manual_comments');
      }
      component.set('v.showComment', true);
    } else if (formType === $A.get('$Label.cuco.form_automatic_method')) {
      if (typology === $A.get('$Label.cuco.cancellation')) {
        customMessage = $A.get('$Label.cuco.form_cancellation_automatic_desc');
      } else {
        customMessage = $A.get('$Label.cuco.form_automatic_desc');
      }
      component.set('v.showComment', false);
    }
    component.set('v.customMessage', customMessage);
    helper.manageDates(component, event, helper);
  },
  manageDates: function(component, event, helper) {
    var typology = component.get('v.typology');
    var originEnd = component.get('v.originEndDate');
    var originEndDate = new Date(originEnd);

    var tooltip;
    var today = new Date();
    var customDate = new Date(today.setDate(today.getDate() + 1));

    var customDateTitle = $A.get('$Label.cuco.form_start_date');
    var customDataTitleEnd = $A.get('$Label.cuco.form_end_date');
    var customDateFormat = helper.formatDate(component, customDate);

    // Logic for custom title and tooltip
    switch (typology) {
      case 'New':
        tooltip = $A.get('$Label.cuco.form_start_new_tooltip');
        component.set('v.isNotCancellation', true);
        break;
      case 'Novation':
        tooltip = $A.get('$Label.cuco.form_start_novation_tooltip');
        component.set('v.isNotCancellation', true);
        break;
      case 'Renewal':
        tooltip = $A.get('$Label.cuco.form_start_renewal_tooltip');
        if (originEndDate >= today) {
          customDate = new Date(originEndDate.setDate(originEndDate.getDate() + 1));
          customDateFormat = helper.formatDate(component, customDate);
        }
        component.set('v.isNotCancellation', true);
        break;
      case 'Cancellation':
        tooltip = $A.get('$Label.cuco.form_start_cancellation_tooltip');
        customDateTitle = $A.get('$Label.cuco.form_cancellation_date');
        break;
    }
    let currentStatus = component.get('v.profAnalysisStatus');
    if (currentStatus === 'Pending Send for Manual Formalization') {
      let currentDate = component.get('v.profAnalysisStartDate');
      customDate = new Date(currentDate);
      customDateFormat = helper.formatDate(component, customDate);
    }
    component.set('v.startDate', customDate);
    component.set('v.customDateTitle', customDateTitle);
    component.set('v.customDataTitleEnd', customDataTitleEnd);
    component.set('v.tooltip', tooltip);
    component.set('v.customDate', customDateFormat);

    var validation = helper.validatePA(component, event, helper);
    component.set('v.labelValidate', validation.label);
    component.set('v.dateValidate', validation.date);
  },
  formatDate: function(component, date) {
    let dateFormat;
    if (date !== undefined) {
      let newDate = new Date(date);
      let formatDay = newDate.toLocaleDateString('es-ES', {day: '2-digit'});
      let formatMonth = newDate.toLocaleDateString('es-ES', {month: '2-digit'});
      let formatYear = newDate.toLocaleDateString('es-ES', {year: 'numeric'});
      dateFormat = formatDay + '/' + formatMonth + '/' + formatYear;
    }
    return dateFormat;
  },
  validatePA: function(component, event, helper) {
    var typology = component.get('v.typology');
    var originEndDate = component.get('v.originEndDate');
    var originStartDate = component.get('v.originStartDate');
    var labelValidate;
    var dateValidate;
    if (originStartDate !== undefined && originEndDate !== undefined) {
      switch (typology) {
        case 'Novation':
          labelValidate = $A.get('$Label.cuco.form_validity_novation');
          break;
        case 'Renewal':
          labelValidate =  $A.get('$Label.cuco.form_validity_renewal');
          break;
        case 'Cancellation':
          labelValidate =  $A.get('$Label.cuco.form_validity_cancellation');
          break;
      }
      let startDate = helper.formatDate(component, originStartDate);
      let endDate = helper.formatDate(component, originEndDate);
      dateValidate = startDate + ' - ' + endDate;
    }
    let tempObj = {};
    tempObj.label = labelValidate;
    tempObj.date = dateValidate;
    return tempObj;
  },
  arceExpiration: function(component, event, helper) {
    var arceDate = component.get('v.arceDate');
    var conditionReturned;
    if (arceDate !== undefined) {
      var newArceDate = helper.formatDate(component, arceDate);
      conditionReturned = $A.get('$Label.cuco.arce_date_message') + ' ' + newArceDate;
      component.set('v.hasArceDate', true);
      component.set('v.warningExpiration', conditionReturned);
    }
  },
  datesComparator: function(component, event, helper, startDate, expiryDate) {
    if (expiryDate === null || expiryDate === undefined) {
      helper.showNewToastForm('error', $A.get('$Label.cuco.form_mandatory_expiry_date'));
    } else {
      if (expiryDate < startDate) {
        helper.showNewToastForm('error', $A.get('$Label.cuco.form_expiry_date_error'));
      } else {
        let customDateStart = new Date(startDate.setMonth(startDate.getMonth() + 12));
        if (expiryDate > customDateStart) {
          helper.showNewToastForm('error', $A.get('$Label.cuco.form_expiry_error'));
        } else {
          component.set('v.endDate', expiryDate);
          helper.saveContinue(component, event, helper);
        }
      }
    }
  },
  saveContinue: function(component, event, helper) {
    $A.util.removeClass(component.find('simpleSpinner'), 'slds-hide');
    var profAnalysisId = component.get('v.recordId');
    var auditHtml  = document.getElementById('auditBody').innerHTML;

    // Get detail content
    var action = component.get('c.callService');

    action.setParams({
      'profAnalysisId': profAnalysisId,
      'startDate': component.get('v.startDate'),
      'expiryDate': component.get('v.endDate'),
      'comments': component.get('v.comments'),
      'screenShot': auditHtml
    });
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (component.isValid() && state === 'SUCCESS') {
        var ret = response.getReturnValue();
        if (ret.success === true) {
          helper.showNewToastForm('success', ret.message);
          $A.get('e.force:refreshView').fire();
          let cancelEvent = component.getEvent('dynamicFlowWizardCancel');
          cancelEvent.fire();
        } else {
          helper.showNewToastForm('error', ret.message);
          $A.get('e.force:refreshView').fire();
          let cancelEvent = component.getEvent('dynamicFlowWizardCancel');
          cancelEvent.fire();
        }
      } else if (response.getState() === 'ERROR') {
        helper.showNewToastForm('error', response.getError()[0].message);
        let cancelEvent = component.getEvent('dynamicFlowWizardCancel');
        cancelEvent.fire();
      }
      $A.util.addClass(component.find('simpleSpinner'), 'slds-hide');
    });
    $A.enqueueAction(action);
  },
  showNewToastForm: function(type, message) {
    let titleFormToast;
    switch (type) {
      case 'success':
        titleFormToast = $A.get('$Label.cuco.toast_title_success');
        break;
      case 'warning':
        titleFormToast = $A.get('$Label.cuco.toast_title_warning');
        break;
      case 'error':
        titleFormToast = $A.get('$Label.cuco.toast_title_error');
        break;
    }
    var newFormToast = $A.get('e.force:showToast');
    newFormToast.setParams({
      'title': titleFormToast,
      'type': type,
      'message': message
    });
    newFormToast.fire();
  },
  managePrice: function(component, event, helper, hasPrice, startDate, endDateSelected) {
    if (hasPrice === false) {
      let inputCmp = component.find('expiryDate');
      let expirySelected = inputCmp.get('v.value');
      if (expirySelected === undefined  || expirySelected === null) {
        helper.showNewToastForm('error', $A.get('$Label.cuco.form_mandatory_expiry_date'));
      } else {
        let expiryDate = new Date(expirySelected);
        helper.datesComparator(component, event, helper, startDate, expiryDate);
      }
    } else {
      let endDate;
      if (endDateSelected !== undefined) {
        endDate = new Date(endDateSelected);
      }
      helper.datesComparator(component, event, helper, startDate, endDate);
    }
  },
  handleChangeDateFormalize: function(component, event, helper) {
    let currentDateFormalize = event.getSource().get('v.value');
    component.set('v.endDateAudit', $A.localizationService.formatDate(currentDateFormalize, 'dd/MM/yyyy'));
  }
});