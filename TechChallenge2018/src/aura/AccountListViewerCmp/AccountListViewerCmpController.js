({
    doInit: function(component, event, helper) {
        var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.find("pageSize").get("v.value"); 
        helper.getAccountList(component, helper, pageNumber, pageSize);
        helper.fetchAccountSourceOptions(component, helper,'AccountSource');
    },
     
    handleNext: function(component, event, helper) {
        var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.find("pageSize").get("v.value");
        pageNumber++;
        helper.getAccountList(component, helper, pageNumber, pageSize);
    },
     
    handlePrev: function(component, event, helper) {
        var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.find("pageSize").get("v.value");
        pageNumber--;
        helper.getAccountList(component, helper, pageNumber, pageSize);
    },
     
    onSelectChange: function(component, event, helper) {
        var page = 1
        var pageSize = component.find("pageSize").get("v.value");
        helper.getAccountList(component, helper, page, pageSize);
    },

    getAccountDetails: function(component, event, helper) {
        component.set("v.eachAccount",component.get("v.AccountList")[event.currentTarget.getAttribute("data-index")].acc);
    },

    // this function automatic call by aura:waiting event  
    showSpinner: function(component, event, helper) {
       // make Spinner attribute true for display loading spinner 
        component.set("v.Spinner", true); 
   },
    
 // this function automatic call by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
     // make Spinner attribute to false for hide loading spinner    
       component.set("v.Spinner", false);
    },

    openNewAccountModal: function(component, event, helper) {
        component.set("v.isNew",true);
        var modal = component.find("accountNewModal");
        var modalBackdrop = component.find("accountNewModalBackdrop");
        $A.util.addClass(modal,"slds-fade-in-open");
        $A.util.addClass(modalBackdrop,"slds-backdrop_open");
    },

    // Function used to close the contact modal
    closeNewAccountModal: function(component, event, helper) {
        component.set("v.isNew",false);
        var modal = component.find("accountNewModal");
        var modalBackdrop = component.find("accountNewModalBackdrop");
        $A.util.removeClass(modal,"slds-fade-in-open");
        $A.util.removeClass(modalBackdrop,"slds-backdrop_open");
    },


    openEditAccountModal: function(component, event, helper) {
        component.set("v.isEdit",true);
        component.set("v.editAccId",event.currentTarget.getAttribute("data-id"));
        var modal = component.find("accountEditModal");
        var modalBackdrop = component.find("accountEditModalBackdrop");
        $A.util.addClass(modal,"slds-fade-in-open");
        $A.util.addClass(modalBackdrop,"slds-backdrop_open");
        component.set("v.Spinner", true); 
    },

    // Function used to close the contact modal
    closeEditAccountModal: function(component, event, helper) {
        component.set("v.isEdit",false);
        var modal = component.find("accountEditModal");
        var modalBackdrop = component.find("accountEditModalBackdrop");
        $A.util.removeClass(modal,"slds-fade-in-open");
        $A.util.removeClass(modalBackdrop,"slds-backdrop_open");
    },

    createAccount: function(component, event, helper) {
        component.set("v.Spinner", true); 
        helper.insertAccount(component, event, helper);
    },
    updateAccount: function(component, event, helper) {
        try {
            component.find("edit").get("e.recordSave").fire();
        }catch (e) {
            console.log(e);
            }
        window.location.reload();// This will refresh the app to get the latest updated data.  
    },
    deleteAccount: function(component, event, helper) {
        if(confirm('Are you sure?'))
            helper.deleteAccount(component, event,helper);  
    },

     massUpdateAccounts: function(component, event, helper) {
        helper.handleSelections(component, event, helper);
        if(component.get("v.massProcess")){
            component.set("v.isMassUpdate",true);
            var modal = component.find("accountMassUpdateModal");
            var modalBackdrop = component.find("accountMassUpdateModalBackdrop");
            $A.util.addClass(modal,"slds-fade-in-open");
            $A.util.addClass(modalBackdrop,"slds-backdrop_open");
        }
    },

    closeMassUpdateAccountModal: function(component, event, helper) {
        component.set("v.isMassUpdate",false);
        var modal = component.find("accountMassUpdateModal");
        var modalBackdrop = component.find("accountMassUpdateModalBackdrop");
        $A.util.removeClass(modal,"slds-fade-in-open");
        $A.util.removeClass(modalBackdrop,"slds-backdrop_open");
    },

    onPicklistChange: function(component, event, helper) {
        component.set("v.chosenAccSource",component.find("accSource").get("v.value"));
    },
    massUpdateAccountSource: function(component, event, helper) {
        if(component.get("v.chosenAccSource")==undefined || component.get("v.chosenAccSource")==null)
            alert("Please make an Account Source selection!");
        else
            helper.massUpdateAccSource(component,event,helper);
    },
    massDeleteAccounts: function(component, event, helper) {
        helper.handleSelections(component, event, helper);
        if(component.get("v.massProcess"))
            if(confirm('Are you sure?'))
                helper.deleteAccounts(component,event,helper);
    },
})