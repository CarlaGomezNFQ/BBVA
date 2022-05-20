({
  doInit: function(component, event, helper) {
    let availableIRPTypes = [];
    let optionsWf = component.get('v.optionsWF');
    helper.setRatingToolId(component, event, helper);
    for (var i = 0; i < optionsWf.length; i++) {
      availableIRPTypes.push(optionsWf[i].label);
      if (optionsWf[i].label === 'Rating') {
        component.set('v.ratingValue', optionsWf[i].value);
      } else if (optionsWf[i].label === 'Adjustment') {
        component.set('v.adjustmentValue', optionsWf[i].value);
      } else if (optionsWf[i].label === 'Override') {
        component.set('v.overrideValue', optionsWf[i].value);
      }
    }

    const arceTypesObject = {};

    for (var arceType of availableIRPTypes) {
      arceTypesObject[arceType] = true;
    }

    component.set('v.isArceTypeEnabled', arceTypesObject);
  },
  changeArceSelection: function(component, event, helper) {
    component.set('v.processSelected', event.target.value);
  }
});