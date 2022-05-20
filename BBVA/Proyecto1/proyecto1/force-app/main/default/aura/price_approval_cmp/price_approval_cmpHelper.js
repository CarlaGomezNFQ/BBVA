({
  requestData: function(cmp, evt, helper) {

    $A.util.removeClass(cmp.find('simpleSpinner'), 'slds-hide');
    cmp.set('v.title', $A.get('$Label.cuco.price_approval_title'));
    let action = cmp.get('c.requestData');
    action.setParams({
      'recordId': cmp.get('v.inputAttributes').recordId
    });
    action.setCallback(helper, function(response) {
      if (cmp.isValid() && response.getState() === 'SUCCESS') {
        let returnedMap = response.getReturnValue();

        if (returnedMap.priceStatusCode === 200 || returnedMap.priceStatusCode === 201) {
          let priceResponse = JSON.parse(returnedMap.priceResponseBody);

          //set Attributes
          helper.setAttributes(cmp, evt, helper, returnedMap, priceResponse);

          //set decisions
          helper.setDecisions(cmp, evt, helper, returnedMap);

          //set conditions
          cmp.set('v.conditionList', returnedMap.listaConditions);

          //set exceptions
          cmp.set('v.lstExceptions', returnedMap.lstExceptions);

          cmp.set('v.isLoaded', true);
          cmp.set('v.isSuccess', true);
          $A.util.addClass(cmp.find('simpleSpinner'), 'slds-hide');
          $A.util.removeClass(cmp.find('container'), 'slds-hide');

        } else {
          let errorserviceMessage = JSON.parse(returnedMap.priceResponseBody)['error-message'];
          let errorMessage = undefined !== errorserviceMessage ? $A.get('$Label.cuco.price_negotiation_error_detail') + errorserviceMessage : $A.get('$Label.cuco.price_negotiation_error_generic');
          helper.showNewToast('sticky', 'Error', 'error', errorMessage);

          $A.util.addClass(cmp.find('simpleSpinner'), 'slds-hide');
          let cancelEvent = cmp.getEvent('dynamicFlowWizardCancel');
          cancelEvent.fire();
        }
      } else {
        helper.showNewToast('sticky', 'Error', 'error', response.getError()[0].message);
        $A.util.addClass(cmp.find('simpleSpinner'), 'slds-hide');
        let cancelEvent = cmp.getEvent('dynamicFlowWizardCancel');
        cancelEvent.fire();
      }
    });
    $A.enqueueAction(action);
  },
  setAttributes: function(cmp, evt, helper, returnedMap, priceResponse) {
    if (returnedMap.typology === 'Renewal' || returnedMap.typology === 'Novation') {
      cmp.set('v.isRenewal', true);
    }
    cmp.set('v.typology', returnedMap.typology);
    cmp.set('v.proposedEndDate', returnedMap.proposedEndDate);
    cmp.set('v.originEndDate', returnedMap.originEndDate);
    cmp.set('v.originStartDate', returnedMap.originStartDate);
    cmp.set('v.isAtributions', priceResponse.isAtributions);
    cmp.set('v.dateArce', undefined !== returnedMap.dateArce ? $A.get('$Label.cuco.arce_date_message') + ' ' + returnedMap.dateArce : '');
    cmp.set('v.proposedEndDateAudit', $A.localizationService.formatDate(returnedMap.proposedEndDate, 'dd/MM/yyyy'));
  },
  setDecisions: function(cmp, evt, helper, returnedMap) {
    //Decisions
    cmp.set('v.listDecisions', returnedMap.decisionWrapperList);
    var decisionJson = '{"listDecision":[';
    for (var decision in returnedMap.decisionWrapperList) {
      if (undefined !==  returnedMap.decisionWrapperList[decision]) {
        decisionJson = decisionJson + '{"id":"' + returnedMap.decisionWrapperList[decision].id + '","style":"' + returnedMap.decisionWrapperList[decision].style + '","label":"' + returnedMap.decisionWrapperList[decision].name + '"},';
      }
    }
    decisionJson = decisionJson.substring(0, decisionJson.length - 1);
    decisionJson = decisionJson + ']}';
    cmp.set('v.maxPerRow', returnedMap.decisionWrapperList.length);
    cmp.set('v.decisionInputJSONSetup', decisionJson);

  },
  showNewToast: function(mode, title, type, message) {
    var newToast = $A.get('e.force:showToast');
    newToast.setParams({
      'mode': mode,
      'title': title,
      'type': type,
      'message': message
    });
    newToast.fire();
  },
  handleClick: function(cmp, evt, helper) {
    let selection = evt.getParams().selectedDecisionId;
    cmp.set('v.decisionChosen', selection);
    let lstDecisions = cmp.get('v.listDecisions');
    for (var decision in lstDecisions) {
      if (lstDecisions[decision].id === selection) {
        cmp.set('v.decisionLabel', lstDecisions[decision].name);
      }
    }
    cmp.set('v.isDecisionSelected', true);
  },
  cancelButton: function(cmp, evt, helper) {
    helper.destroyCmp(cmp, evt, helper);
  },
  validateFields: function(cmp, evt, helper) {

    var comments = cmp.get('v.comments');
    var proposedEndDate = cmp.get('v.proposedEndDate');

    var commentsOk = false;
    if (undefined !== comments && comments !== null && comments !== '') {
      commentsOk = true;
    } else {
      cmp.find('inputComments').reportValidity();
    }

    var proposedEndDateOk = false;
    if (undefined !== proposedEndDate && proposedEndDate !== null && proposedEndDate !== '') {
      proposedEndDateOk = true;
    } else {
      cmp.find('endDateId').reportValidity();
    }

    //if validations are ok pass to validate dates
    if (commentsOk && proposedEndDateOk) {
      helper.validateDates(cmp, evt, helper);
    }
  },
  validateDates: function(cmp, evt, helper) {
    let dateToday = new Date();
    let jsOriginEndDate = null;
    if (undefined !== cmp.get('v.originEndDate') && cmp.get('v.originEndDate') !== null) {
      jsOriginEndDate = new Date(cmp.get('v.originEndDate').split('-')[0], cmp.get('v.originEndDate').split('-')[1] - 1, cmp.get('v.originEndDate').split('-')[2]);
    }
    let jsProposedEndDate = new Date(cmp.get('v.proposedEndDate').split('-')[0], cmp.get('v.proposedEndDate').split('-')[1] - 1, cmp.get('v.proposedEndDate').split('-')[2]);
    let validationError = false;
    let errorMessage = null;

    if (jsProposedEndDate < dateToday) {
      validationError = true;
      errorMessage = $A.get('$Label.cuco.price_future_date_error');
      helper.showNewToast('sticky', 'Error', 'error', errorMessage);
    }

    if (cmp.get('v.typology') === 'Renewal' && jsOriginEndDate !== null) {
      var originEndDate12 = jsOriginEndDate.setMonth(jsOriginEndDate.getMonth() + 12);
      var dateToday12 = dateToday.setMonth(dateToday.getMonth() + 12);
      if (jsOriginEndDate > dateToday && jsProposedEndDate > originEndDate12) {
        validationError = true;
        errorMessage = $A.get('$Label.cuco.price_renewal_adv_expiry_error');
      } else if (jsOriginEndDate < dateToday && jsProposedEndDate > dateToday12) {
        validationError = true;
        errorMessage = $A.get('$Label.cuco.price_renewal_expiry_error');
        helper.showNewToast('sticky', 'Error', 'error', errorMessage);
      }
    } else {
      if (jsProposedEndDate >= dateToday.setMonth(dateToday.getMonth() + 12)) {
        validationError = true;
        errorMessage = $A.get('$Label.cuco.price_expiry_error');
        helper.showNewToast('sticky', 'Error', 'error', errorMessage);
      }
    }
    helper.goToSave(cmp, evt, helper, validationError, errorMessage);

  },
  goToSave: function(cmp, evt, helper, validationError, errorMessage) {
    if (validationError) {
      helper.showNewToast('sticky', 'Error', 'error', errorMessage);
    } else {
      helper.saveData(cmp, evt, helper);
    }
  },
  saveData: function(cmp, evt, helper) {

    $A.util.removeClass(cmp.find('simpleSpinner'), 'slds-hide');

    let auditHtml  = document.getElementById('auditBody').innerHTML;
    let action = cmp.get('c.persistData');
    let inputAttribute = {};
    inputAttribute.profAnalId = cmp.get('v.inputAttributes').recordId;
    inputAttribute.decisionCode = cmp.get('v.decisionChosen');
    inputAttribute.decisionComments = cmp.get('v.comments');
    inputAttribute.proposedEndDate = cmp.get('v.proposedEndDate');
    inputAttribute.screenshot = auditHtml;

    action.setParams({
      'inputAttributes': inputAttribute
    });
    action.setCallback(this, function(response) {
      if (cmp.isValid() && response.getState() === 'SUCCESS') {
        let returnedMap = response.getReturnValue();
        if (returnedMap.success === true) {
          $A.util.addClass(cmp.find('simpleSpinner'), 'slds-hide');
          helper.showNewToast('dismissible', $A.get('$Label.cuco.toast_title_success'), 'success', returnedMap.message);
          helper.refreshPage();
          helper.closeModal(cmp, evt, helper);
        } else {
          let errorMessage = returnedMap.message;
          helper.showNewToast('sticky', 'Error', 'error', errorMessage);
          $A.util.addClass(cmp.find('simpleSpinner'), 'slds-hide');
          let cancelEvent = cmp.getEvent('dynamicFlowWizardCancel');
          cancelEvent.fire();
        }
      } else {
        helper.showNewToast('sticky', 'Error', 'error', response.getError()[0].message);
        $A.util.addClass(cmp.find('simpleSpinner'), 'slds-hide');
        let cancelEvent = cmp.getEvent('dynamicFlowWizardCancel');
        cancelEvent.fire();
      }
    });
    $A.enqueueAction(action);
  },
  closeModal: function(cmp, evt, helper) {
    helper.destroyCmp(cmp, evt, helper);
  },
  refreshPage: function() {
    $A.get('e.force:refreshView').fire();
  },
  handleChangeDate: function(cmp, evt, helper) {
    let currentDate = evt.getSource().get('v.value');
    cmp.set('v.proposedEndDateAudit', $A.localizationService.formatDate(currentDate, 'dd/MM/yyyy'));
  },
  sectionToggle: function() {}
});