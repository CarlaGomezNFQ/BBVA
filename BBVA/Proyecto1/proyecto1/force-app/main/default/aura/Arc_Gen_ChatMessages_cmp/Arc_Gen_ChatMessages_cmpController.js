({
  init: function(component, event, helper) {
    var variant = component.get('v.variant');
    switch (variant.toUpperCase()) {
      case 'SUCCESS': {
        component.set('v.chatEvent', 'slds-chat-event');
        component.set('v.iconName', 'utility:check');
        break;
      }
      case 'ERROR': {
        component.set('v.chatEvent', 'slds-chat-event slds-has-error');
        component.set('v.iconName', 'utility:clear');
        break;
      }
      case 'WARNING': {
        component.set('v.chatEvent', 'slds-chat-event');
        component.set('v.iconName', 'utility:warning');
        break;
      }
      default: {
        component.set('v.chatEvent', 'slds-chat-event');
        component.set('v.iconName', 'utility:' + variant);
        break;
      }
    }
  }
});