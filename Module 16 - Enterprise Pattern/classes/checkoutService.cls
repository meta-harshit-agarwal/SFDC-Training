public with sharing class checkoutService 
{
     public static Purchase_Order__c placeOrder(List<Product2> checkoutItems)
     {
        fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
            new List<SObjectType> { Product2.SObjectType, Purchase_Order__c.SObjectType, Purchase_Order_Line_Item__c.SObjectType  }
        );

        Purchase_Order__c purchaseOrder = new Purchase_Order__c(Name = 'Harshit', Order_Status__c = 'Pending');
        insert purchaseOrder;
        //uow.registerNew(purchaseOrder);
        //List<Purchase_Order_Line_Item__c> purchaseOrderLineItemList = new List<Purchase_Order_Line_Item__c>();
        //List<Product2> productList = new List<Product2>();
        for(Product2 product : checkoutItems) 
        {
            uow.registerNew(new Purchase_Order_Line_Item__c(Purchase_Order__c = purchaseOrder.Id,
                                                                       Product__c = product.Id,
                                                                       Quantity__c = product.Quantity__c,
                                                                       Total_Price__c = product.Quantity__c * product.Price_Per_Unit__c));
            product.Quantity__c = product.Quantity_Available__c;
            //productList.add(product);
            uow.registerDirty(product);
        }
        //update productList;        
        //insert purchaseOrderLineItemList; 
        uow.commitwork(); 
        return purchaseOrder;


     }
}