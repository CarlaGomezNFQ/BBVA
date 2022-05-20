({
    afterScriptsLoaded : function(component, event, helper) {
        component.set('v.ready', true);
        helper.createChart(component);
    },
    navigateToMyComponent : function(component, event, helper) {
        var evt = $A.get('e.force:navigateToComponent');
        evt.setParams({
            componentDef : 'c:RevenuesEvolutionYTD_Detail',
            componentAttributes: {
                recordId : component.get('v.recordId')
            }
        });
        evt.fire();
    }
})