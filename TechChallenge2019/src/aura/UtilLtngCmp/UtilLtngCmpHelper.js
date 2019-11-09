({
	jsPromiseHandler: function(component,helper,action,callback) {
	    return new Promise(function(resolve, reject) {
	        action.setCallback(this, function(response) {
	            var state = response.getState();
	            if (component.isValid() && state === "SUCCESS") {
	                resolve(response.getReturnValue());
	            }
	            else if (state === "ERROR") {
	                var errors = response.getError();
	                if (errors) {
	                    if (errors[0] && errors[0].message) {
	                        reject(Error("Error message: " + errors[0].message));
	                    }
	                }
	                else {
	                    reject(Error("Unknown error"));
	                }
	            }
	        });
	    $A.enqueueAction(action);
	    });
	},
    isEmpty : function(value,component, event, helper) {
		return (
        // null or undefined
        (value == null) ||
    
        // has length and it's zero
        (value.hasOwnProperty('length') && value.length === 0) ||
    
        // is an Object and has no keys
        (value.constructor === Object && Object.keys(value).length === 0)
      )	
	},
})