({
    toggleRightSection : function(component, event, helper) { 	
        component.set('v.isRightSidebarCollapsed', !component.get('v.isRightSidebarCollapsed'));
        var size = component.get('v.sizeMainRegion');
        if (component.get('v.isRightSidebarCollapsed')){
        	size = size + 2;
        } else{
            size = size -2;
 		}
        component.set('v.sizeMainRegion',size);
    },
    toggleLeftSection : function(component, event, helper) {             
        component.set('v.isLeftSidebarCollapsed', !component.get('v.isLeftSidebarCollapsed'));
        var size = component.get('v.sizeMainRegion');
        if (component.get('v.isLeftSidebarCollapsed')){
        	size = size + 3;
        } else{
            size = size - 3;
 		}
        component.set('v.sizeMainRegion',size);
    },
    doneRendering : function(component, event, helper) {
        try {
            var stickySectionAura = component.find("stickySection");
            if(window && stickySectionAura){
                console.log("doneRendering stickySection");
                window.onscroll = function() {
                    //Purely informational
                    var html = document.documentElement;
                    var scrollHeight = parseInt(html.scrollHeight);
                    var clientHeight = parseInt(html.clientHeight);
    
                    //This is where it happens, so adjust this per your requirement
                    if(parseInt(window.pageYOffset) > 75) 
                        $A.util.addClass(stickySectionAura, 'stickySection');
                    else
                        $A.util.removeClass(stickySectionAura, 'stickySection');
                }
            }
        } catch(err){
            console.log('-------> doneRendering ERROR: ' + err + ' ** MESSAGE: ' + err.message + ' ** STACK: ' + err.stack);
        }
    }
})