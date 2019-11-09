({
    AddNewRow : function(component, event, helper){
        var ar=[];
        component.set("v.messages",ar);
        if(helper.isEmpty(component.get("v.LineItemInstance").Name,component, event, helper)){
            ar.push('Please enter Item Name<br/>');
        }
        if(helper.isEmpty(component.get("v.LineItemInstance").Price__c,component, event, helper)    || component.get("v.LineItemInstance").Price__c<=0){
            ar.push('Please enter valid Price<br/>');
        }
        if(helper.isEmpty(component.get("v.LineItemInstance").Quantity__c,component, event, helper) || component.get("v.LineItemInstance").Quantity__c<=0){
            ar.push('Please enter valid Quantity<br/>');
        }
        if(helper.isEmpty(component.get("v.LineItemInstance").Weight__c,component, event, helper)   || component.get("v.LineItemInstance").Weight__c<=0){
            ar.push('Please enter valid Weight<br/>');
        }
        if(ar.length==0){
          component.set("v.renderRowReadOnly",true);  
          component.getEvent("AddNewRowItemEvt").fire();   
        }
        component.set("v.messages",ar);
    },
    
    removeRow : function(component, event, helper){ 
       component.getEvent("DeleteRowItemEvt").setParams({"indexVar" : component.get("v.rowIndex") }).fire();
    },
})