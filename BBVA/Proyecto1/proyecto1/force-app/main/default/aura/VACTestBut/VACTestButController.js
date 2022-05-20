({
	handleClick : function(component, event, helper) {
        console.log('entro en handleclick');
        console.log(component.get('v.bl_DisplayModal'));
        component.set('v.bl_DisplayModal',true);
        
		//alert('Remedy Servers are down, don\'t panic, coffee machines are still working');
	},
	fn_CloseModal : function(component, event, helper)
	{
		component.set("v.bl_DisplayModal", false);
	}
    
    
})