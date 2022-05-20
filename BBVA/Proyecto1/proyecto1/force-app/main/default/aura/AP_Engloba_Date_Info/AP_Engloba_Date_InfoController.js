({
	doInit : function(component, event, helper) {

        var action = component.get("c.getEnglobaData");
        	action.setParams({
           	'recordId': component.get('v.recordId')
       });

        // Register the callback function
        action.setCallback(this, function(response) {
            // Set the component attributes using values returned by the API call
            	console.log(response.getState());
            	console.log(response.getReturnValue());
                component.set("v.mensaje", "YTD " + response.getReturnValue());
        });
        // Invoke the service

        $A.enqueueAction(action);
    }
})