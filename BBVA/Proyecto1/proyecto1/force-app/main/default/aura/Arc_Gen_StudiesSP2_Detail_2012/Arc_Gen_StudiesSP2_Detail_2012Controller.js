({
  subsectionHide: function(component, event) {
    if (component.get('v.showSubSection') === 'visibleSubSect') {
      component.set('v.showSubSection', 'hideSubSect');
    } else {
      component.set('v.showSubSection', 'visibleSubSect');
    }
  }
});