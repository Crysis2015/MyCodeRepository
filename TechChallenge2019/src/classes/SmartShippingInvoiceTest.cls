@isTest
public class SmartShippingInvoiceTest {
    public static testmethod void testNewInvoiceGenerationWithlt100(){
        List<Item__c> lstLineItems=new List<Item__c>();
        lstLineItems.add((Item__c)(TestClassUtil.getsObj(new Map<Schema.sObjectField,Object>{Item__c.Name=>'ITEM-1',Item__c.Price__c=>12,Item__c.Quantity__c=>2,Item__c.Weight__c=>20},Schema.Item__c.sObjectType,NULL)));
        lstLineItems.add((Item__c)(TestClassUtil.getsObj(new Map<Schema.sObjectField,Object>{Item__c.Name=>'ITEM-2',Item__c.Price__c=>13,Item__c.Quantity__c=>3,Item__c.Weight__c=>30},Schema.Item__c.sObjectType,NULL)));
        ShippingItemController.ResponseWrapper response=ShippingItemController.processInvoiceCreation(NULL,'INV 1',lstLineItems);
        System.assertEquals(true,response.isSuccess);
        Shipping_Invoice__c invoice=[select Id,Shipping_Discount__c from Shipping_Invoice__c where Id= :response.message];
        System.assertEquals(0, invoice.Shipping_Discount__c);
    }
    public static testmethod void testNewInvoiceGenerationWithgt100(){
        List<Item__c> lstLineItems=new List<Item__c>();
        lstLineItems.add((Item__c)(TestClassUtil.getsObj(new Map<Schema.sObjectField,Object>{Item__c.Name=>'ITEM-1',Item__c.Price__c=>40,Item__c.Quantity__c=>2,Item__c.Weight__c=>20},Schema.Item__c.sObjectType,NULL)));
        lstLineItems.add((Item__c)(TestClassUtil.getsObj(new Map<Schema.sObjectField,Object>{Item__c.Name=>'ITEM-2',Item__c.Price__c=>60,Item__c.Quantity__c=>3,Item__c.Weight__c=>30},Schema.Item__c.sObjectType,NULL)));
        ShippingItemController.ResponseWrapper response=ShippingItemController.processInvoiceCreation(NULL,'INV 1',lstLineItems);
        System.assertEquals(true,response.isSuccess);
        Shipping_Invoice__c invoice=[select Id,Shipping_Discount__c from Shipping_Invoice__c where Id= :response.message];
        System.assertNotEquals(0, invoice.Shipping_Discount__c);
    }
    
    public static testmethod void testExistingInvoiceEditWithlt100(){
        Shipping_Invoice__c invoice=(Shipping_Invoice__c)(TestClassUtil.getsObj(new Map<Schema.sObjectField,Object>{Shipping_Invoice__c.Name=>'INV_0'},Schema.Shipping_Invoice__c.sObjectType,NULL));
        insert invoice;
        ShippingItemController.ResponseWrapper response=ShippingItemController.getInvoiceData(String.valueOf(invoice.Id));
        System.assertEquals('INV_0', invoice.Name);
        List<Item__c> lstLineItems=new List<Item__c>();
        lstLineItems.add((Item__c)(TestClassUtil.getsObj(new Map<Schema.sObjectField,Object>{Item__c.Name=>'ITEM-1',Item__c.Price__c=>12,Item__c.Quantity__c=>2,Item__c.Weight__c=>20},Schema.Item__c.sObjectType,NULL)));
        lstLineItems.add((Item__c)(TestClassUtil.getsObj(new Map<Schema.sObjectField,Object>{Item__c.Name=>'ITEM-2',Item__c.Price__c=>13,Item__c.Quantity__c=>3,Item__c.Weight__c=>30},Schema.Item__c.sObjectType,NULL)));
        response=ShippingItemController.processInvoiceCreation(invoice.Id,'INV_1',lstLineItems);
        System.assertEquals(true,response.isSuccess);
        invoice=[select Id,Name,Shipping_Discount__c from Shipping_Invoice__c where Id= :response.message];
        System.assertEquals(0, invoice.Shipping_Discount__c);
        System.assertEquals('INV_1', invoice.Name);
    }
    public static testmethod void testExistingInvoiceEditWithgt100(){
        Shipping_Invoice__c invoice=(Shipping_Invoice__c)(TestClassUtil.getsObj(new Map<Schema.sObjectField,Object>{Shipping_Invoice__c.Name=>'INV_0'},Schema.Shipping_Invoice__c.sObjectType,NULL));
        insert invoice;
        ShippingItemController.ResponseWrapper response=ShippingItemController.getInvoiceData(String.valueOf(invoice.Id));
        System.assertEquals('INV_0', invoice.Name);
        System.assert( ShippingItemController.getUIThemeDescription()!=NULL);
        List<Item__c> lstLineItems=new List<Item__c>();
        lstLineItems.add((Item__c)(TestClassUtil.getsObj(new Map<Schema.sObjectField,Object>{Item__c.Name=>'ITEM-1',Item__c.Price__c=>40,Item__c.Quantity__c=>2,Item__c.Weight__c=>20},Schema.Item__c.sObjectType,NULL)));
        lstLineItems.add((Item__c)(TestClassUtil.getsObj(new Map<Schema.sObjectField,Object>{Item__c.Name=>'ITEM-2',Item__c.Price__c=>60,Item__c.Quantity__c=>3,Item__c.Weight__c=>30},Schema.Item__c.sObjectType,NULL)));
        response=ShippingItemController.processInvoiceCreation(invoice.Id,'INV_1',lstLineItems);
        System.assertEquals(true,response.isSuccess);
        invoice=[select Id,Name,Shipping_Discount__c from Shipping_Invoice__c where Id= :response.message];
        System.assertNotEquals(0, invoice.Shipping_Discount__c);
        System.assertEquals('INV_1', invoice.Name);
    }
    public static testmethod void testExistingInvoiceWithExistingLineItems(){
        Shipping_Invoice__c invoice=(Shipping_Invoice__c)(TestClassUtil.getsObj(new Map<Schema.sObjectField,Object>{Shipping_Invoice__c.Name=>'INV_0'},Schema.Shipping_Invoice__c.sObjectType,NULL));
        insert invoice;
        ShippingItemController.ResponseWrapper response=ShippingItemController.getInvoiceData(String.valueOf(invoice.Id));
        System.assertEquals('INV_0', invoice.Name);
        System.assert( ShippingItemController.getUIThemeDescription()!=NULL);
        List<Item__c> lstLineItems=new List<Item__c>();
        lstLineItems.add((Item__c)(TestClassUtil.getsObj(new Map<Schema.sObjectField,Object>{Item__c.Name=>'ITEM-1',Item__c.Price__c=>40,Item__c.Quantity__c=>2,Item__c.Weight__c=>20,Item__c.Shipping_Invoice__c => invoice.Id},Schema.Item__c.sObjectType,NULL)));
        lstLineItems.add((Item__c)(TestClassUtil.getsObj(new Map<Schema.sObjectField,Object>{Item__c.Name=>'ITEM-2',Item__c.Price__c=>60,Item__c.Quantity__c=>3,Item__c.Weight__c=>30,Item__c.Shipping_Invoice__c => invoice.Id},Schema.Item__c.sObjectType,NULL)));
        insert lstLineItems;
        System.assertEquals(2,[select count() from Item__c where Shipping_Invoice__c =:invoice.Id]);
        lstLineItems=new List<Item__c>();
        lstLineItems.add((Item__c)(TestClassUtil.getsObj(new Map<Schema.sObjectField,Object>{Item__c.Name=>'ITEM-3',Item__c.Price__c=>70,Item__c.Quantity__c=>2,Item__c.Weight__c=>20},Schema.Item__c.sObjectType,NULL)));
        lstLineItems.add((Item__c)(TestClassUtil.getsObj(new Map<Schema.sObjectField,Object>{Item__c.Name=>'ITEM-4',Item__c.Price__c=>80,Item__c.Quantity__c=>3,Item__c.Weight__c=>30},Schema.Item__c.sObjectType,NULL)));
        lstLineItems.add((Item__c)(TestClassUtil.getsObj(new Map<Schema.sObjectField,Object>{Item__c.Name=>'ITEM-5',Item__c.Price__c=>80,Item__c.Quantity__c=>3,Item__c.Weight__c=>30},Schema.Item__c.sObjectType,NULL)));
        response=ShippingItemController.processInvoiceCreation(invoice.Id,'INV_1',lstLineItems);
        System.assertEquals(true,response.isSuccess);
        invoice=[select Id,Name,Shipping_Discount__c from Shipping_Invoice__c where Id= :response.message];
        System.assertNotEquals(0, invoice.Shipping_Discount__c);
        System.assertEquals('INV_1', invoice.Name);
        System.assertEquals(3,[select count() from Item__c where Shipping_Invoice__c =:invoice.Id]);
    }
    public static testmethod void testNewShipInvoiceAndLineItemAdd(){   
        Shipping_Invoice__c invoice=(Shipping_Invoice__c)(TestClassUtil.getsObj(new Map<Schema.sObjectField,Object>{Shipping_Invoice__c.Name=>'INV_0'},Schema.Shipping_Invoice__c.sObjectType,NULL));
        insert invoice;
        ShippingItemController.ResponseWrapper response=ShippingItemController.getInvoiceData(String.valueOf(invoice.Id));
        System.assertEquals('INV_0', invoice.Name);
        List<Item__c> lstLineItems=new List<Item__c>();
        lstLineItems.add((Item__c)(TestClassUtil.getsObj(new Map<Schema.sObjectField,Object>{Item__c.Name=>'ITEM-1',Item__c.Price__c=>40,Item__c.Quantity__c=>2,Item__c.Weight__c=>20,Item__c.Shipping_Invoice__c => invoice.Id},Schema.Item__c.sObjectType,NULL)));
        lstLineItems.add((Item__c)(TestClassUtil.getsObj(new Map<Schema.sObjectField,Object>{Item__c.Name=>'ITEM-2',Item__c.Price__c=>60,Item__c.Quantity__c=>3,Item__c.Weight__c=>30,Item__c.Shipping_Invoice__c => invoice.Id},Schema.Item__c.sObjectType,NULL)));
        ItemObjectService.runShippingDataCalculation=true;
        insert lstLineItems;
        System.assertEquals(2,[select count() from Item__c where Shipping_Invoice__c =:invoice.Id]);
        invoice=[select Id,Name,Grand_Total__c,Shipping_Discount__c from Shipping_Invoice__c where Id= :invoice.Id];
        System.assertNotEquals(0, invoice.Shipping_Discount__c);
        System.assertNotEquals(0, invoice.Grand_Total__c);
        System.assertEquals('INV_0', invoice.Name);
    }
    public static testmethod void testNewShipInvoiceAndLineItemCUDU(){   
        Shipping_Invoice__c invoice=(Shipping_Invoice__c)(TestClassUtil.getsObj(new Map<Schema.sObjectField,Object>{Shipping_Invoice__c.Name=>'INV_0'},Schema.Shipping_Invoice__c.sObjectType,NULL));
        insert invoice;
        ShippingItemController.ResponseWrapper response=ShippingItemController.getInvoiceData(String.valueOf(invoice.Id));
        System.assertEquals('INV_0', invoice.Name);
        List<Item__c> lstLineItems=new List<Item__c>();
        lstLineItems.add((Item__c)(TestClassUtil.getsObj(new Map<Schema.sObjectField,Object>{Item__c.Name=>'ITEM-1',Item__c.Price__c=>40,Item__c.Quantity__c=>2,Item__c.Weight__c=>20,Item__c.Shipping_Invoice__c => invoice.Id},Schema.Item__c.sObjectType,NULL)));
        lstLineItems.add((Item__c)(TestClassUtil.getsObj(new Map<Schema.sObjectField,Object>{Item__c.Name=>'ITEM-2',Item__c.Price__c=>60,Item__c.Quantity__c=>3,Item__c.Weight__c=>30,Item__c.Shipping_Invoice__c => invoice.Id},Schema.Item__c.sObjectType,NULL)));
        ItemObjectService.runShippingDataCalculation=true;
        insert lstLineItems;
        System.assertEquals(2,[select count() from Item__c where Shipping_Invoice__c =:invoice.Id]);
        invoice=[select Id,Name,Grand_Total__c,Shipping_Discount__c from Shipping_Invoice__c where Id= :invoice.Id];
        Double grandTotalVal1=invoice.Grand_Total__c;
        System.assertNotEquals(0, invoice.Shipping_Discount__c);
        System.assertNotEquals(0, grandTotalVal1);
        System.assertEquals('INV_0', invoice.Name);
        lstLineItems[0].Price__c=60;
        ItemObjectService.runShippingDataCalculation=true;
        update lstLineItems;
        invoice=[select Id,Name,Grand_Total__c,Shipping_Discount__c from Shipping_Invoice__c where Id= :invoice.Id];
        System.assertNotEquals(0, grandTotalVal1);
        Double grandTotalVal2=invoice.Grand_Total__c;
        System.assertNotEquals(grandTotalVal2, grandTotalVal1);
        Test.startTest();
        ItemObjectService.runShippingDataCalculation=true;
        delete lstLineItems[0];
        invoice=[select Id,Name,Grand_Total__c,Shipping_Discount__c from Shipping_Invoice__c where Id= :invoice.Id];
        System.assertNotEquals(0, grandTotalVal2);
        Double grandTotalVal3=invoice.Grand_Total__c;
        System.assertNotEquals(grandTotalVal3, grandTotalVal2);
        ItemObjectService.runShippingDataCalculation=true;
        undelete lstLineItems[0];
        invoice=[select Id,Name,Grand_Total__c,Shipping_Discount__c from Shipping_Invoice__c where Id= :invoice.Id];
        System.assertNotEquals(0, grandTotalVal2);
        Double grandTotalVal4=invoice.Grand_Total__c;
        System.assertNotEquals(grandTotalVal4, grandTotalVal3);
        System.assertEquals(grandTotalVal4, grandTotalVal2);
        Test.stopTest();
    }
}