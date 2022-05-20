({
  createCarousel: function(component, event, helper) {
    if (component.find('carouselActivity')) {
      component.find('carouselActivity').destroy();
    }
    const params = {
      'aura:id': 'carouselActivity',
      'nameCards': component.get('v.nameCards'),
      'recordId': component.get('v.recordId'),
      'infinite': 'true',
      'slidesToShow': '4',
      'relationMode': 'true',
      'allowCardClick': 'true',
      'showButtons': 'true',
      'sizeTable': '150',
      'refreshOnRefreshView': 'true',
    };
    $A.createComponent('qvcd:GBL_Carousel_CMP', params, function(elem, status, errorMessage) {
      if (status === 'SUCCESS') {
        const body = component.get('v.carousel');
        body.push(elem);
        component.set('v.carousel', body);
      }
    });
  },
  createDinForm: function(component, event, helper) {
    if (component.find('dynamicForm')) {
      component.find('dynamicForm').destroy();
    }
    const cheldfields = component.get('v.childFields.arce__Template_type__c');
    const templateName = component.get('v.templateTypePrefix') + cheldfields;
    const isValidated = component.get('v.isValidated');
    const editButton = '{"style":"neutral","unactiveStyle":"hidden","active":' + isValidated + '}';
    const params = {
      'aura:id': 'dynamicForm',
      'recordId': component.get('v.childId'),
      'templateName': templateName,
      'editButton': editButton
    };
    $A.createComponent('dyfr:Dynamic_Form_cmp', params, function(elem, status, errorMessage) {
      if (status === 'SUCCESS') {
        const body = component.get('v.dynamicForm');
        body.push(elem);
        component.set('v.dynamicForm', body);
      }
    });
  },
  fireToast: function(type, message) {
    const toastError = $A.get('e.force:showToast');
    toastError.setParams({
      'title': type + '!',
      'type': type.toLowerCase(),
      'message': message
    });
    toastError.fire();
  },
  setChart: function(component, event, helper, collectionType) {
    let chartWrapper;
    let message;
    let typology;
    const action = component.get('c.getWrapper');
    action.setParams({
      collectionType: collectionType,
      acttyId: component.get('v.recordId'),
      aHasAnalysId: component.get('v.recordId')
    });
    action.setCallback(this, function(response) {
      const state = response.getState();
      if (state === 'SUCCESS') {
        let collectionModified = collectionType.split(component.get('v.modelSelctd'))[0];
        chartWrapper = response.getReturnValue();
        const chartRefresh = $A.get('e.chgn:chartRefreshEvent');
        chartRefresh.setParams({
          Json_Chart: chartWrapper,
          ID: collectionModified
        });
        chartRefresh.fire();
      } else if (state === 'INCOMPLETE') {
        message = 'Incomplete';
        typology = 'Error';
        helper.fireToast(typology, message);
      } else if (state === 'ERROR') {
        const errors = response.getError();
        if (errors) {
          if (errors[0] && errors[0].message) {
            message = errors[0].message;
            typology = 'Error';
            helper.fireToast(typology, message);
          }
        } else {
          message = 'Unkwon error';
          typology = 'Error';
          helper.fireToast(typology, message);
        }
      }
    });
    $A.enqueueAction(action);
  },
  callMultitemplate: function(component, event, helper, model) {
    const action = component.get('c.callMultitemplateCtrllr');
    action.setParams({
      aHasAnalysId: component.get('v.recordId'),
      modelSlctd: model
    });
    action.setCallback(this, function(response) {
      const state = response.getState();
      let message;
      let typology;
      if (state !== 'SUCCESS') {
        const errors = response.getError();
        if (errors) {
          if (errors[0] && errors[0].message) {
            message = errors[0].message;
            typology = 'Error';
            helper.fireToast(typology, message);
          }
        }
      }
    });
    $A.enqueueAction(action);
  }
});