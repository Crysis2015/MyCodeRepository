({
    getAccountList: function(component, helper, pageNumber, pageSize) {
    	var getAccList=component.get("c.getAccountData");
		getAccList.setParams({
			"pageNumber": pageNumber,
            "pageSize": pageSize
		});


        this.jsPromiseHandler(component,helper,getAccList)
	    .then(
	        $A.getCallback(function(result){
	        	if(typeof(result) != "undefined"){
		        	component.set("v.AccountList", result.accountList);
	                component.set("v.PageNumber", result.pageNumber);
	                component.set("v.TotalRecords", result.totalRecords);
	                component.set("v.RecordStart", result.recordStart);
	                component.set("v.RecordEnd", result.recordEnd);
	                component.set("v.TotalPages", Math.ceil(result.totalRecords / pageSize));
	            }
	        })

	   )
	   .catch(
	        $A.getCallback(function(error){
	             alert("error message="+error.message);
	        })
	     );
    },

    insertAccount: function(component, event, helper) {

    	var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.find("pageSize").get("v.value");
    	var getAccList=component.get("c.getAccountData");
		getAccList.setParams({
			"pageNumber": pageNumber,
            "pageSize": pageSize
		});

		var getAccListAction= this.jsPromiseHandler(component,helper,getAccList);

    	var account = component.get("v.newAccount");
        var createAction = component.get('c.createAccountRecord');
        createAction.setParams({
            newAccount: account
        });

        this.jsPromiseHandler(component,helper,createAction)
	    .then(
	        $A.getCallback(function(result){
	        	if(typeof(result) != "undefined"){
			        return getAccListAction;
	            }
	        })

	   )
	   .then(
	        $A.getCallback(function(result){
	        	if(typeof(result) != "undefined" && result.status=='success'){
	        		component.set("v.AccountList", result.accountList);
	                component.set("v.PageNumber", result.pageNumber);
	                component.set("v.TotalRecords", result.totalRecords);
	                component.set("v.RecordStart", result.recordStart);
	                component.set("v.RecordEnd", result.recordEnd);
	                component.set("v.TotalPages", Math.ceil(result.totalRecords / pageSize));
	        		component.set("v.Spinner", false);
	        		var modal = component.find("accountNewModal");
			        var modalBackdrop = component.find("accountNewModalBackdrop");
			        $A.util.removeClass(modal,"slds-fade-in-open");
			        $A.util.removeClass(modalBackdrop,"slds-backdrop_open");
			        component.set("v.message", "Account Created Successfully! Auto-refreshing in 2 seconds...");
			        component.set("v.messageType", 'info');
			        window.setTimeout(function(){ location.reload(true); },component.get("v.timeOutTimer"));
	            }
	            else if(typeof(result) != "undefined" && result.status=='error'){
	            	component.set("v.Spinner", false);
			        component.set("v.message", result.message);
			        component.set("v.messageType", 'error');
	            }
	        })
	   )
	   .catch(
	        $A.getCallback(function(error){
	        	 component.set("v.Spinner", false);
	        	 var modal = component.find("accountNewModal");
		         var modalBackdrop = component.find("accountNewModalBackdrop");
		         $A.util.removeClass(modal,"slds-fade-in-open");
		         $A.util.removeClass(modalBackdrop,"slds-backdrop_open");
	             //alert("error message="+error.message);
	             component.set("v.message", error.message);
			     component.set("v.messageType", 'error');
	        })
	     );
    },


    deleteAccount : function(component, event,helper) {
        var action = component.get("c.deleteAccounts");
        var accIds=[];
        accIds.push(event.currentTarget.getAttribute("data-id"));
        action.setParams({
        	"accIds": accIds
        });
        this.jsPromiseHandler(component,helper,action)
	   .then(
	        $A.getCallback(function(result){
	        	if(typeof(result) != "undefined" && result.status=='success'){
	        		console.log(result);
	        		component.set("v.Spinner", false);
			        component.set("v.message", "Account Deleted Successfully! Auto-refreshing in 2 seconds...");
			        component.set("v.messageType", 'info');
			        window.setTimeout(function(){ location.reload(true); },component.get("v.timeOutTimer"));
	            }
	            else if(typeof(result) != "undefined" && result.status=='error'){
	            	component.set("v.Spinner", false);
			        component.set("v.message", result.message);
			        component.set("v.messageType", 'error');
	            }
	        })

	   )
	   .catch(
	        $A.getCallback(function(error){
	        	 component.set("v.Spinner", false);
	             //alert("error message="+error.message);
	             component.set("v.message", error.message);
			     component.set("v.messageType", 'error');
	        })
	     );
	},

	deleteAccounts : function(component, event,helper) {
        var action = component.get("c.deleteAccounts");
        action.setParams({
        	"accIds": component.get("v.chosenAccountIds")
        });
        this.jsPromiseHandler(component,helper,action)
	   .then(
	        $A.getCallback(function(result){
	        	if(typeof(result) != "undefined" && result.status=='success'){
	        		console.log(result);
	        		component.set("v.Spinner", false);
			        component.set("v.message", "Accounts Deleted Successfully! Auto-refreshing in 2 seconds...");
			        component.set("v.messageType", 'info');
			        window.setTimeout(function(){ location.reload(true); },component.get("v.timeOutTimer"));
	            }
	            else if(typeof(result) != "undefined" && result.status=='error'){
	            	component.set("v.Spinner", false);
			        component.set("v.message", result.message);
			        component.set("v.messageType", 'error');
	            }
	        })

	   )
	   .catch(
	        $A.getCallback(function(error){
	        	 component.set("v.Spinner", false);
	             //alert("error message="+error.message);
	             component.set("v.message", error.message);
			     component.set("v.messageType", 'error');
	        })
	     );
	},

	fetchAccountSourceOptions: function(component, helper,fieldName) {
        var action = component.get("c.getselectOptions");
        action.setParams({
            "objObject": component.get("v.objInfo"),
            "fld": fieldName
        });
        var opts = [];
        this.jsPromiseHandler(component,helper,action)
	    .then(
	        $A.getCallback(function(result){
	        	console.log(result);
	        	if (result != undefined && result.length > 0) 
                	for (var i = 0; i < result.length; i++) 
                    	opts.push(result[i]);
                component.set("v.accountSourceOptions", opts);
	        })
	   )
	   .catch(
	        $A.getCallback(function(error){
	             component.set("v.message", error.message);
			     component.set("v.messageType", 'error');
	        })
	     );
    },

    massUpdateAccSource: function(component, event,helper) {
        var action = component.get("c.massUpdateSource");
        action.setParams({
            "accIds": component.get("v.chosenAccountIds"),
            "accSource": component.get("v.chosenAccSource")
        });
        var opts = [];
        this.jsPromiseHandler(component,helper,action)
	    .then(
	        $A.getCallback(function(result){
	        	if(typeof(result) != "undefined" && result.status=='success'){
	        		component.set("v.Spinner", false);
			        component.set("v.message", "Accounts Updated Successfully! Auto-refreshing in 2 seconds...");
			        component.set("v.messageType", 'info');
			        component.set("v.isMassUpdate",false);
			        var modal = component.find("accountMassUpdateModal");
			        var modalBackdrop = component.find("accountMassUpdateModalBackdrop");
			        $A.util.removeClass(modal,"slds-fade-in-open");
			        $A.util.removeClass(modalBackdrop,"slds-backdrop_open");
			        window.setTimeout(function(){ location.reload(true); },component.get("v.timeOutTimer"));
	            }
	            else if(typeof(result) != "undefined" && result.status=='error'){
	            	component.set("v.Spinner", false);
			        component.set("v.message", result.message);
			        component.set("v.messageType", 'error');
	            }
	        })

	   )
	   .catch(
	        $A.getCallback(function(error){
	             component.set("v.message", error.message);
			     component.set("v.messageType", 'error');
	        })
	     );
    },

    handleSelections: function(component, event, helper) {
        var selectedAccounts = [];
        var checkvalue = component.find("checkAccount");
         
        if(!Array.isArray(checkvalue)){
            if (checkvalue.get("v.value") == true) {
                selectedAccounts.push(checkvalue.get("v.text"));
            }
        }else{
            for (var i = 0; i < checkvalue.length; i++) {
                if (checkvalue[i].get("v.value") == true) {
                    selectedAccounts.push(checkvalue[i].get("v.text"));
                }
            }
        }
        if(selectedAccounts.length<=0){
            component.set("v.massProcess",false);
            alert('Please select atleast one account!');
        }
        else{
        	component.set("v.massProcess",true);
            var chosenAccSobjects=[];
            for(var i=0;i<selectedAccounts.length;i++)
                for(var j=0; j< component.get("v.AccountList").length; j++)
                    if(component.get("v.AccountList")[j].acc.Id==selectedAccounts[i]){
                        chosenAccSobjects.push(component.get("v.AccountList")[j].acc);
                        break;
                   }

            component.set("v.chosenAccountIds",selectedAccounts);
            component.set("v.chosenAccounts",chosenAccSobjects);
        }
    },
    
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
})