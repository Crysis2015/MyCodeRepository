public class ItemObjectUtility {
    public static void calculateShippingData(Set<Id> setShippingInvoiceIds){
        if( setShippingInvoiceIds!=NULL && setShippingInvoiceIds.size()>0){
            List<Shipping_Invoice__c> lstInvoicesUpdate=new List<Shipping_Invoice__c>();
            for(Shipping_Invoice__c invoice : [select Id,(select Id,Price__c ,Quantity__c ,Shipping_Invoice__c , Weight__c from Items__r) from Shipping_Invoice__c where Id IN :setShippingInvoiceIds]){
                invoice.Sub_Total__c         =0;
                invoice.Grand_Total__c       =0;
                invoice.Shipping_Cost__c     =0;
                invoice.Shipping_Discount__c =0;
                invoice.Tax__c               =0;
                invoice.Total_Weight__c 	 =0;
                if(invoice.Items__r!=NULL && invoice.Items__r.size()>0){
                    for(Item__c item : invoice.Items__r){
                       if(item.Quantity__c !=NULL && item.Quantity__c >0 && item.Weight__c!=NULL && item.Weight__c>0){
                           invoice.Total_Weight__c+=(item.Quantity__c*item.Weight__c);
                       }
                       if(item.Quantity__c !=NULL && item.Quantity__c >0 && item.Price__c!=NULL && item.Price__c>0)
                          invoice.Sub_Total__c+=(item.Quantity__c*item.Price__c);
                    }
                    invoice.Tax__c=(Double.valueOf(System.Label.Tax_Rate)*invoice.Sub_Total__c)/100;
                    if(invoice.Sub_Total__c<=Double.valueOf(System.Label.Threshold_SubTotal_For_Discount)){
                    	invoice.Shipping_Cost__c=(Double.valueOf(System.Label.Shipping_Rate)*invoice.Sub_Total__c)/100;
                        invoice.Shipping_Discount__c=0.0;
                    }
                    else{
                        invoice.Shipping_Discount__c=(Double.valueOf(System.Label.Shipping_Rate)*invoice.Sub_Total__c)/100;
                        invoice.Shipping_Cost__c    =(Double.valueOf(System.Label.Shipping_Rate)*invoice.Sub_Total__c)/100;
                    }
                    invoice.Grand_Total__c=invoice.Sub_Total__c+invoice.Tax__c+invoice.Shipping_Cost__c-invoice.Shipping_Discount__c;
                    invoice.Grand_Total__c=invoice.Grand_Total__c<0 ? 0 : invoice.Grand_Total__c;
                }
                lstInvoicesUpdate.add(invoice);
            }
            update lstInvoicesUpdate;
        }
    }
}