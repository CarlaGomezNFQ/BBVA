({ //eslint-disable-line
  doInit: function(cmp, evt, helper) {
    helper.callServerData(cmp, evt, helper);
  },
    changeAttribute : function (component, event, helper) {
        component.set("v.conditionalVar", false);
    }
});