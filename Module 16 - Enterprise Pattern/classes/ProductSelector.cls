public class ProductSelector extends fflib_SObjectSelector 
{
    public List<Schema.SObjectField> getSObjectFieldList() 
    {
        return new List<Schema.SObjectField>
        { Product2.Id, Product2.Name, Product2.ProductCode, Product2.Description, Product2.Price_Per_Unit__c, Product2.Quantity__c, Product2.Select_Checkbox__c, Product2.Quantity_Available__c };
    }
    
    public Schema.SObjectType getSObjectType() 
    {
        return Product2.sObjectType;
    }

    public static Integer getProductCount()
    {
        return [SELECT count() FROM Product2];

    }

    public static List<Product2> getProductById(Id id)
    {
        return [SELECT Select_Checkbox__c, Name, Id, ProductCode, Description, Price_Per_Unit__c, Quantity__c, Quantity_Available__c FROM Product2 WHERE Id =: id];

    }

    public static List<Product2> getProductByIdList(List<Id> idList)
    {
        return [SELECT Select_Checkbox__c, Name, Id, ProductCode, Description, Price_Per_Unit__c, Quantity__c, Quantity_Available__c FROM Product2 WHERE Id IN :idList];

    }

    public static List<Product2> getProductsByOffset(String direction, Integer limitValue, Integer offsetValue)
    {
        if(direction == 'ASC')
            return [SELECT Select_Checkbox__c, Name, Id, ProductCode, Description, Price_Per_Unit__c, Quantity__c, Quantity_Available__c FROM Product2 Order By Name ASC LIMIT : limitValue OFFSET : offsetValue];
        else
            return [SELECT Select_Checkbox__c, Name, Id, ProductCode, Description, Price_Per_Unit__c, Quantity__c, Quantity_Available__c FROM Product2 Order By Name DESC LIMIT : limitValue OFFSET : offsetValue];
    }

    public static List<Product2> getProductsByKey(String key)
    {
        return [SELECT Select_Checkbox__c, Name, Id, ProductCode, Description, Price_Per_Unit__c, Quantity__c, Quantity_Available__c FROM Product2 WHERE Name LIKE '%key%'];
    }
}
//