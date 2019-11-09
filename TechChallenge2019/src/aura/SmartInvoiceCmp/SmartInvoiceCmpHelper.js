({
    validateShipInvName: function(component, event, helper) {
        var inputVal = component.find("inputShipInvName").get("v.value");
        if (inputVal==='' || inputVal===null || inputVal===undefined) {
            component.find("inputShipInvName").setCustomValidity("");
            component.find("inputShipInvName").setCustomValidity("Name is required");
            component.find("inputShipInvName").reportValidity();
        } else {
            component.find("inputShipInvName").setCustomValidity("");
            helper.openItemAddModal(component, event, helper);
        }
    },
    openItemAddModal: function(component, event, helper) {
      component.set("v.isNewShipModalOpen","false");
      component.set("v.processItemAddAction","true");
   },
   createObjectData: function(component, event) {
        var RowItemList = component.get("v.lineItemList");
        RowItemList.push({
            'sobjectType': 'Item__c',
            'Name': '',
            'Price__c': 0,
            'Quantity__c': 0,
            'Weight__c': 0
        });
        component.set("v.lineItemList", RowItemList);
    },
    
    saveHandler : function(component, event, helper) {
        var saveAction=component.get("c.processInvoiceCreation");
		saveAction.setParams({
            "invoiceId"    : component.get("v.recordId"),
			"invoiceName"  : component.get("v.shipInvoiceName") ,
			"lstLineItems" : component.get("v.lineItemList") 
		});
		helper.jsPromiseHandler(component,helper,saveAction)
		.then(
				$A.getCallback(function(response){
					if(typeof(response) != "undefined"){
                        if(response.isSuccess){
                        	component.set("v.processItemAddAction","false");
                            if(component.get("v.userTheme")=='Theme4d')
								window.location.href='/one/one.app#/sObject/'+response.message+'/view';
                            else
                                window.location.href='/'+response.message;
                        }
                        else{
                            var ar=[];
                            component.set("v.messages",ar);
                            ar.push(response.message);
                            component.set("v.errorType","error");
                            component.set("v.messages",ar);
                        }
					}
				})
			)
		.catch(
				$A.getCallback(function(error){
					var ar=[];
        			component.set("v.messages",ar);
                    ar.push(error.message);
                    component.set("v.errorType","error");
                    component.set("v.messages",ar);
				})
			);
    },
    initHandler : function(component, event, helper) {
        var getThemeAction=component.get("c.getUIThemeDescription");
        var getThemePromise = helper.jsPromiseHandler(component,helper,getThemeAction);
        var loadAction=component.get("c.getInvoiceData");
		loadAction.setParams({ 
			"invoiceId" : component.get("v.recordId") 
		});
		helper.jsPromiseHandler(component,helper,loadAction)
		.then(
            	$A.getCallback(function(response){
					if(typeof(response) != "undefined"){
                        component.set("v.shipInvoiceName",JSON.parse(response.message)[0].Name);
                        var RowItemList = [];
                        if(JSON.parse(response.message)[0].Items__r!=undefined && JSON.parse(response.message)[0].Items__r.records.length>0){
                            var ar=JSON.parse(response.message)[0].Items__r.records;
                            for(var i=0;i<ar.length;i++){
                                RowItemList.push({
                                    'sobjectType': 'Item__c',
                                    'Id'  : ar[i].Id,
                                    'Name': ar[i].Name,
                                    'Price__c': ar[i].Price__c,
                                    'Quantity__c': ar[i].Quantity__c,
                                    'Weight__c': ar[i].Weight__c
                                });
                            }
						}
                        RowItemList.push({
                                'sobjectType': 'Item__c',
                                'Name': '',
                                'Price__c': 0,
                                'Quantity__c': 0,
                                'Weight__c': 0
                            });
                        component.set("v.lineItemList", RowItemList);
                        return getThemePromise;
                    }
				})
			)
        .then(
            	$A.getCallback(function(response){
                    if(typeof(response) != "undefined"){
                       component.set("v.userTheme",response); 
                    }
                })
            )
		.catch(
				$A.getCallback(function(error){
					var ar=[];
        			component.set("v.messages",ar);
                    ar.push(error.message);
                    component.set("v.errorType","error");
                    component.set("v.messages",ar);
				})
			);
    },
})