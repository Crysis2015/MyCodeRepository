public without sharing class ItemObjectService extends ObjectService{  
    /* static flags for execution control*/ 
    public static Boolean runShippingDataCalculation=true;
    public override void doAfterInsert( List<SObject> newRecords,Map<Id,sObject> newMap){
        Set<Id> setShippingInvoiceIds =new Set<Id>();
        for(Item__c item : (List<Item__c>)newRecords){
            setShippingInvoiceIds.add(item.Shipping_Invoice__c);
        }
        if(setShippingInvoiceIds.size()>0 && runShippingDataCalculation){
       		ItemObjectUtility.calculateShippingData(setShippingInvoiceIds);
            runShippingDataCalculation=false;
        }
    } 
    public override void doAfterUpdate(List<SObject> oldRecords, List<SObject> newRecords,Map<Id,sObject> oldMap,Map<Id,sObject> newMap){
        Set<Id> setShippingInvoiceIds =new Set<Id>();
        for(Item__c item : (List<Item__c>)newRecords){
            setShippingInvoiceIds.add(item.Shipping_Invoice__c);
            setShippingInvoiceIds.add((Id)oldMap.get(item.Id).get('Shipping_Invoice__c'));
        }
        if(setShippingInvoiceIds.size()>0 && runShippingDataCalculation){
       		ItemObjectUtility.calculateShippingData(setShippingInvoiceIds);
            runShippingDataCalculation=false;
        }
    }
    public override void doAfterDelete(List<SObject> oldRecords, Map<Id,sObject> oldMap){
        Set<Id> setShippingInvoiceIds =new Set<Id>();
        for(Item__c item : (List<Item__c>)oldRecords){
            setShippingInvoiceIds.add(item.Shipping_Invoice__c);
        }
        if(setShippingInvoiceIds.size()>0 && runShippingDataCalculation){
       		ItemObjectUtility.calculateShippingData(setShippingInvoiceIds);
            runShippingDataCalculation=false;
        }
    }
    public override void doAfterUndelete(List<SObject> newRecords, Map<Id,sObject> newMap){
        Set<Id> setShippingInvoiceIds =new Set<Id>();
        for(Item__c item : (List<Item__c>)newRecords){
            setShippingInvoiceIds.add(item.Shipping_Invoice__c);
        }
        if(setShippingInvoiceIds.size()>0 && runShippingDataCalculation){
       		ItemObjectUtility.calculateShippingData(setShippingInvoiceIds);
            runShippingDataCalculation=false;
        } 
    }
}