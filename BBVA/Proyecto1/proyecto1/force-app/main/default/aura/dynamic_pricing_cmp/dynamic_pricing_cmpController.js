({
  doInit: function(c, e, h) {
    h.doInit(c, e, h);
  },
  toggle: function(component, event, helper) {
    var items = component.get('v.flatWrap.nonCrossDPTable.classificationsList');
    var index = event.getSource().get('v.value');
    items[index].expanded = !items[index].expanded;
    component.set('v.flatWrap.nonCrossDPTable.classificationsList', items);
  },

  toggleSection: function(component, event, helper) {
    var sectionAuraId = event.target.getAttribute('data-auraId');
    var sectionDiv = component.find(sectionAuraId).getElement();
    var noInfoLbl = component.find('noInfo').getElement();
    var sectionState = sectionDiv.getAttribute('class').search('slds-is-open');
    if (sectionState === -1) {
      $A.util.removeClass(sectionDiv, 'slds-is-close');
      $A.util.addClass(sectionDiv, 'slds-is-open');
      $A.util.removeClass(noInfoLbl, 'slds-hide');
    } else {
      $A.util.addClass(noInfoLbl, 'slds-hide');
      $A.util.removeClass(sectionDiv, 'slds-is-open');
      $A.util.addClass(sectionDiv, 'slds-is-close');
    }
  }
});