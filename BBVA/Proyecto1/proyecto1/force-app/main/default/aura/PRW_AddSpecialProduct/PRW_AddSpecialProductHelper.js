({
  doInit: function(cmp, event, helper) {
    this.getListProducts(cmp);
  },
  getListProducts: function(component) {
    var action = component.get('c.gtSpecialProducts');
    var promise = this.promisifyAddSpecialAction(action);
    var families = [];
    var familiesObj = [];
    var products = [];
    var productsIds = [];
    var sections = [];
    var sectionsAc = [];


    component.get('v.dataTable').forEach((product, index) => {
      if(product.id_prod !== undefined) {
        productsIds.push(product.id_prod);
      }
    });

    return promise.then(
      $A.getCallback(function(result) {
        result.forEach((product, index) => {
          products.push(
            {
              'prod_name': product.Name,
              'prod_id': product.cuco__gf_psc_condition_id__c,
              'checked': productsIds.includes(product.cuco__gf_psc_condition_id__c),
              'disabled': false, 'id': product.cuco__gf_psc_condition_id__c,
              'family' : product.cuco__gf_psc_family_id__r.Name
            }
          );
          if(familiesObj.length > 0 && familiesObj[familiesObj.length-1].name === product.cuco__gf_psc_family_id__r.Name) {
            if(!productsIds.includes(product.cuco__gf_psc_condition_id__c) && familiesObj[familiesObj.length-1].checked) {
              familiesObj[familiesObj.length-1].indeterminated = true;
              familiesObj[familiesObj.length-1].checked = false;
            } else if(productsIds.includes(product.cuco__gf_psc_condition_id__c) && !familiesObj[familiesObj.length-1].checked) {
              familiesObj[familiesObj.length-1].indeterminated = true;
            }
          } else {
            families.push(product.cuco__gf_psc_family_id__r.Name);
            familiesObj.push(
              {
                'name': product.cuco__gf_psc_family_id__r.Name,
                checked: productsIds.includes(product.cuco__gf_psc_condition_id__c),
                indeterminated: false,
                'section' : product.cuco__gf_psc_family_id__r.cuco__gf_psc_family_product_name__c
              }
            );
          }
          if(!sections.includes(product.cuco__gf_psc_family_id__r.cuco__gf_psc_family_product_name__c)) {
            sections.push(product.cuco__gf_psc_family_id__r.cuco__gf_psc_family_product_name__c);
            sectionsAc.push(product.cuco__gf_psc_family_id__r.cuco__gf_psc_family_product_name__c);
          }
        });
        component.set('v.firstProdIds', productsIds);
        component.set('v.families', familiesObj);
        component.set('v.products', products);
        component.set('v.activeSections', families);
        component.set('v.sections', sections);
        component.set('v.sectionsAccord', sectionsAc);
      }),
      $A.getCallback(function(error) {
        console.error( 'Error calling action "' + action + '" with state: ' + error.message );
      })
    ).catch(function(e){
    });
  },

  toggleGroup: function(cmp, event, helper) {
    const family = event.getSource().get('v.value');
    const products = cmp.find('checkbox').filter(c => c.get('v.name') === family);
    const check = event.getSource().get('v.checked');
    var i = 0;
    $A.util.removeClass(event.getSource(), 'indeterminated');

    products.forEach(product => {
      if (!product.get('v.disabled')) {
        product.set('v.checked', check);
      }
      if (product.get('v.checked')) {
        i++;
      }
    });
    if (i === products.length) {
      event.getSource().set('v.checked', true);
    } else if (i === 0) {
      event.getSource().set('v.checked', false);
    } else {
      event.getSource().set('v.checked', false);
      $A.util.addClass(event.getSource(), 'indeterminated');
    }
  },

  evaluateToggleGroup: function(cmp, event, helper) {
    const family = event.getSource().get('v.name');
    const group = cmp.find('group').filter(c => c.get('v.value') === family);
    const conditions = cmp.find('checkbox').filter(c => c.get('v.name') === family);
    const conditionsCheked = cmp.find('checkbox').filter(c => c.get('v.name') === family && c.get('v.checked'));
    $A.util.removeClass(group[0], 'indeterminated');

    if (conditionsCheked.length === 0) {
      group[0].set('v.checked', false);
    } else if (conditionsCheked.length === conditions.length) {
      group[0].set('v.checked', true);
    } else {
      group[0].set('v.checked', false);
      $A.util.addClass(group[0], 'indeterminated');
    }
  },

  handleContinue: function(cmp, event, helper) {
    const checked = cmp.find('checkbox').filter(c => c.get('v.checked'));
    var canContinue = checked.length !== 0;

    if (!canContinue) {
      cmp.set('v.showNotChecked', true);
      setTimeout(function() {
        cmp.set('v.showNotChecked', false);
      }, 10000);

    } else {
      let productsSelected = [];
      checked.forEach(c => {
        productsSelected.push(c.get('v.value'));
      });
      let productsSelectContinueEvent = cmp.getEvent('productSelectContinueEvt');
      productsSelectContinueEvent.setParams({
        productsSelected: productsSelected,
        products: cmp.get('v.products'),
        firstProdIds: cmp.get('v.firstProdIds')
      });
      productsSelectContinueEvent.fire();
      helper.destroyCmp(cmp, event, helper);
    }
  },

  promisifyAddSpecialAction: function(action) {
    return new Promise((resolve, reject) => {
      action.setCallback(this, function(response) {
        const state = response.getState();
        if (state === 'SUCCESS') {
          const returnValue = response.getReturnValue();
          resolve(returnValue);
        } else if (state === 'ERROR') {
          var errors = response.getError();
          if (errors) {
            if (errors[0] && errors[0].message) {
              reject(Error('Error message: ' + errors[0].message));
            }
          } else {
            reject(Error('Unknown error'));
          }
      }
      });

      $A.enqueueAction(action);
    });
  },
})