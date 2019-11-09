({	
    doInit: function(component, event, helper) {
       if(!helper.isEmpty(component.get("v.recordId"),component, event, helper)){
           helper.initHandler(component,event,helper); 
       }
       else{
            component.set("v.shipInvoiceName","");
       		component.set("v.lineItemList",[]);
       }
    },
	openNewShippingModal: function(component, event, helper) {
      if(helper.isEmpty(component.get("v.recordId"),component, event, helper)){
           component.set("v.shipInvoiceName","");
       	   component.set("v.lineItemList",[]);
           helper.createObjectData(component, event); 
      }
      else{
         helper.initHandler(component,event,helper);
      }
      component.set("v.isNewShipModalOpen", true);
   },
 
   closeNewShippingModal: function(component, event, helper) {
      component.set("v.messages",[]); 
      component.set("v.isNewShipModalOpen", false);
   },
    
   closeItemAddModal: function(component, event, helper) {
      component.set("v.messages",[]);  
      component.set("v.processItemAddAction","false");
   }, 
   LaunchLineItemsEdit : function(component, event, helper) {
      helper.validateShipInvName(component, event, helper);
   },
    
   addNewRow: function(component, event, helper) {
        helper.createObjectData(component, event);
   },
 
   removeDeletedRow: function(component, event, helper) {
       	   var index = event.getParam("indexVar");
           var AllRowsList = component.get("v.lineItemList");
           if(AllRowsList.length>=2){
            AllRowsList.splice(index, 1);
            component.set("v.lineItemList", AllRowsList);
           }
           else{
                var ar=[];
        		component.set("v.messages",ar); 
                ar.push('Atleast one Line Item is Required');
                component.set("v.errorType","warning");
        		component.set("v.messages",ar);
           }
    },
    validateLineItemData: function(component, event, helper) {
        var ar=[];
        component.set("v.messages",ar);
        var allLineItemRows = component.get("v.lineItemList");
        for (var indexVar = 0; indexVar < allLineItemRows.length; indexVar++) {
            if (helper.isEmpty(allLineItemRows[indexVar].Name,component, event, helper)) {
                ar.push('Please enter valid  Name for Item : ['+(indexVar+1)+']<br/>');
            } 
            if(helper.isEmpty(allLineItemRows[indexVar].Price__c,component, event, helper) || allLineItemRows[indexVar].Price__c<=0){
                ar.push('Please enter valid Price for Item :['+(indexVar+1)+']<br/>');
            }
            if(helper.isEmpty(allLineItemRows[indexVar].Quantity__c,component, event, helper) || allLineItemRows[indexVar].Quantity__c<=0){
                ar.push('Please enter valid Quantity for Item :['+(indexVar+1)+']<br/>');
            }
            if(helper.isEmpty(allLineItemRows[indexVar].Weight__c,component, event, helper) || allLineItemRows[indexVar].Weight__c<=0){
                ar.push('Please enter valid Weight for Item :['+(indexVar+1)+']<br/>');
            }
        }
        if(ar.length==0){
            helper.saveHandler(component, event, helper);
        }
        component.set("v.errorType","warning");
        component.set("v.messages",ar);
    },
    showSpinner: function(component, event, helper) {
       // make Spinner attribute true for display loading spinner 
        component.set("v.Spinner", true); 
    },
    
 	// this function automatic call by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
     // make Spinner attribute to false for hide loading spinner    
       component.set("v.Spinner", false);
    },
})