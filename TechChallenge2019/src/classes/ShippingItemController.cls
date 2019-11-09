public class ShippingItemController {
    @AuraEnabled
    public static String getUIThemeDescription() {
        return UserInfo.getUiThemeDisplayed();
    }
	@AuraEnabled
    public static ResponseWrapper processInvoiceCreation(String invoiceId,String invoiceName,List<Item__c> lstLineItems){
      Savepoint sp=Database.setSavepoint();  
      try{  
          List<sObject> lstInsert=new List<sObject>();
          if(String.isBlank(invoiceId) || (String.isNotBlank(invoiceId) && !(invoiceId instanceOf Id))){
          	  Shipping_Invoice__c invoice =new Shipping_Invoice__c(Name=invoiceName);
              lstInsert.add(invoice);  
              for(Item__c item : lstLineItems){
                 item.Shipping_Invoice__r=invoice;
                 lstInsert.add(item);  
              }
              ItemObjectService.runShippingDataCalculation=true;
              insert lstInsert;
              return new ResponseWrapper(true,String.valueOf(invoice.Id));
          }
          else{
              Shipping_Invoice__c invoice =new Shipping_Invoice__c(Id=invoiceId,Name=invoiceName);
              update invoice;
              List<Item__c> lstLineItemDelete=[select Id from Item__c where Shipping_Invoice__c=:invoiceId];
              if(lstLineItemDelete.size()>0)
                  delete lstLineItemDelete;
              for(Item__c item : lstLineItems){
                 item.Shipping_Invoice__c=invoice.Id;
                 item.Id=NULL; 
                 lstInsert.add(item);  
              }
              ItemObjectService.runShippingDataCalculation=true;
              insert lstInsert;
              return new ResponseWrapper(true,String.valueOf(invoice.Id));
          }
      }catch(Exception e){
          Database.rollback(sp);
          return new ResponseWrapper(false,e.getMessage()+'@'+e.getStackTraceString());
      }
    }
    @AuraEnabled
    public static ResponseWrapper getInvoiceData(String invoiceId){ 
        try{ 
                if(String.isBlank(invoiceId) || (String.isNotBlank(invoiceId) && !(invoiceId instanceOf Id))){
                    return new ResponseWrapper(false,'Invalid or NULL Id');
                } 
                return new ResponseWrapper(true,JSON.serialize([select Id,Name,CurrencyISOCode,(select Id,Name,Price__c ,Quantity__c ,Shipping_Invoice__c , Weight__c from Items__r) from Shipping_Invoice__c where Id=:invoiceId])); 
            }catch(Exception e){
                 return new ResponseWrapper(false,e.getMessage()+'@'+e.getStackTraceString());       
           }
    }
    public class ResponseWrapper{
        @AuraEnabled public Boolean isSuccess{get;set;}
        @AuraEnabled public String message{get;set;}
        public ResponseWrapper(Boolean isSuccess,String message){
            this.isSuccess=isSuccess;
            this.message=message;
        }
    }
}