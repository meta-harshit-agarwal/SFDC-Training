public with sharing class cartService 
{

    public static Decimal getTotalPrice(List<Product2> checkoutItems)
    {
        Decimal totalPrice = 0.0;
        for(Product2 checkoutProduct : checkoutItems)
        {
            totalPrice = totalPrice + (checkoutProduct.Quantity__c * checkoutProduct.Price_Per_Unit__c);
        }

        return totalPrice;

    }
    
}