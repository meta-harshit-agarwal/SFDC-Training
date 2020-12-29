public class PurchaseOrderSelector extends fflib_SObjectSelector
{
    public List<Schema.SObjectField> getSObjectFieldList()
    {
        return new List<Schema.SObjectField>{Purchase_Order__c.Id, Purchase_Order__c.Total_Price__c, Purchase_Order__c.Order_Status__c};
    }

    public Schema.SObjectType getSObjectType()
    {
        return Purchase_Order__c.sObjectType;
    }
    
    public static List<Purchase_Order__c> getPurchaseOrders()
    {
        return [SELECT Id, Total_Price__c, Order_Status__c FROM Purchase_Order__c];

    }

    public static List<Purchase_Order__c> getPurchaseOrdersWithLimit(Integer limitValue)
    {
        return [SELECT Id, Total_Price__c, Order_Status__c FROM Purchase_Order__c LIMIT : limitValue];

    }

    public static Integer getPurchaseOrderCount()
    {
        return [SELECT count() FROM Purchase_Order__c];

    }

    public static List<Purchase_Order__c> getPurchaseOrdersByOffset(Integer limitValue, Integer offsetValue)
    {
        return [SELECT Id, Total_Price__c, Order_Status__c FROM Purchase_Order__c LIMIT : limitValue OFFSET : offsetValue];
    }

}