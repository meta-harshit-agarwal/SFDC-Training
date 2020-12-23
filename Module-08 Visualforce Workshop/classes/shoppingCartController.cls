public class shoppingCartController 
{
    public Boolean error {get;set;}
    public String sortDirection {get;set;}
    private Integer productCount = 0;
    private Integer productQueryOffSet = 0;
    private Integer productQueryLimit = 10;
    private Integer purchaseOrderCount = 0;
    private Integer purchaseOrderQueryOffSet = 0;
    private Integer purchaseOrderQueryLimit = 10;
    public Id orderItemId {get;set;}
    public Id orderItemIdForQuantity {get;set;}
    public List<Id> productIds = new List<Id>();
    public List<Product2> products {get;set;}
    public String searchKey {get;set;}
    public List<Purchase_Order__c> purchaseOrderHistories{get; set;}
    public Boolean hideShowCartList {get;set;}
    public Boolean hideShowCheckoutList {get;set;}
    public Boolean hideShowProductList {get;set;}
    public Decimal totalPrice {get;set;}
    public Product2 productIteratorForQuantity;
    public List<Product2> orderItems{get;set;}
    public List<Product2> checkoutItems{get;set;}

    public ApexPages.StandardSetController orderStandardSetController
    {
        get {
            if(orderStandardSetController == null) 
            {                
                orderStandardSetController = new ApexPages.StandardSetController(ProductSelector.getProductByIdList(productIds)); 
                orderStandardSetController.setPageSize(2);
                orderItems = orderStandardSetController.getRecords();
            }            
            return orderStandardSetController;
        }
        set;
    }
    
    public ApexPages.StandardSetController checkoutStandardSetController
    {
        get {
            if(checkoutStandardSetController == null) 
            {                
                checkoutStandardSetController = new ApexPages.StandardSetController(ProductSelector.getProductByIdList(productIds)); 
                checkoutStandardSetController.setPageSize(5);
                checkoutItems = checkoutStandardSetController.getRecords();
            }            
            return checkoutStandardSetController;
        }
        set;
    }
    
    private final static String SORT_DIRECTION_ASC = 'ASC';
    private final static String SORT_DIRECTION_DESC = 'DESC';
    
    public shoppingCartController()
    {
        totalPrice = 0.0;
        error = false;
        sortDirection = SORT_DIRECTION_ASC;
        purchaseOrderHistories = PurchaseOrderSelector.getPurchaseOrdersWithLimit(5);
        productCount = ProductSelector.getProductCount();
        purchaseOrderCount = PurchaseOrderSelector.getPurchaseOrderCount();
        products = ProductSelector.getProductsByOffset(sortDirection, productQueryLimit, productQueryOffSet);
    }
    
    public List<Product2> getOrderItems(List<Id> productids)
    {
        orderItems = ProductSelector.getProductByIdList(productIds);
        
        for(Product2 orderedProduct : orderItems)
        {
            for(Product2 selectedProduct : products)
            {
                Product2 productIteratorForQuantity = ProductSelector.getProductById(selectedProduct.Id)[0];
                
                if(orderedProduct.id == selectedProduct.id)
                {
                    orderedProduct.Quantity__c = productIteratorForQuantity.Quantity_Available__c - selectedProduct.Quantity_Available__c;
                }
            }
        }
        
        return orderItems;
    }
    
    public List<Product2> getCheckoutItems(List<Id> productIds)
    {
        orderItems = ProductSelector.getProductByIdList(productIds);
        checkoutItems = ProductSelector.getProductByIdList(productIds);
        
        for(Product2 checkoutProduct : checkoutItems)
        {
            for(Product2 selectedProduct : products)
            {
                Product2 productIteratorForQuantity = ProductSelector.getProductById(selectedProduct.Id)[0];
                
                if(checkoutProduct.id == selectedProduct.id)
                {
                    checkoutProduct.Quantity__c = productIteratorForQuantity.Quantity_Available__c - selectedProduct.Quantity_Available__c;
                    checkoutProduct.Total__c = checkoutProduct.Quantity__c * checkoutProduct.Price_Per_Unit__c;
                }
            }
        }
        
        return checkoutItems;
    }
    
    public void search()
    {
        products = ProductSelector.getProductsByKey(searchKey);
    }
    
    public void submit()
    {
        hideShowCartList = true;
        hideShowProductList = false;
        for(Product2 selectedProduct : products)
        {
            if(selectedProduct.Select_Checkbox__c == true && selectedProduct.Quantity_Available__c >= 1)
            {
                selectedProduct.Quantity_Available__c = selectedProduct.Quantity_Available__c - 1;
                productids.add(selectedProduct.id);
            }
        }
        getOrderItems(productIds);
    }
    
    public void checkout()
    {
        totalPrice = 0.0;
        hideShowCartList = false;
        hideShowProductList = false;
        hideShowCheckoutList = true;
        
        for(Product2 orderedProduct : orderItems)
        {
            productIds.add(orderedProduct.id);
        }
        
        getCheckoutItems(productIds);
        
        for(Product2 checkoutProduct : checkoutitems)
        {
            totalPrice = totalPrice + (checkoutProduct.Quantity__c * checkoutProduct.Price_Per_Unit__c);
        }
    }
    
    public void placeOrder()
    {
        purchaseOrderHistories.add(new Purchase_Order__c(Name = 'purchasing',Order_Price__c = totalPrice, Order_Status__c = 'pending'));
        upsert purchaseOrderHistories;
        hideShowCheckoutList = false;
    }
    
    public void removeOrderItem()
    {
        for(Integer i = productIds.size() - 1; i >= 0; i--)
        {
            if(productIds[i].equals(orderItemId))
            {
                for(Product2 productToRemove : products)
                {
                    if(productIds[i].equals(productToRemove.id))
                    {
                        Product2 productIteratorForQuantity = ProductSelector.getProductById(productToRemove.Id)[0];
                        productToRemove.Quantity_Available__c = productIteratorForQuantity.Quantity_Available__c;
                    }
                }
                productIds.remove(i);
            }
        } 
        getorderitems(productIds);
    }
    
    public void changeAvailabeQuantity()
    {
        for(Product2 selectedProduct : products)
        {
            Product2 productIteratorForQuantity = ProductSelector.getProductById(selectedProduct.Id)[0];

            for(Product2 orderedProduct: orderitems)
            {
                
                if(selectedProduct.id == orderItemIdForQuantity && orderedProduct.id == orderItemIdForQuantity)
                {
                    if(productIteratorForQuantity.Quantity_Available__c >= orderedProduct.Quantity__c && orderedProduct.Quantity__c != 0)
                    {
                        error = false;
                        selectedProduct.Quantity_Available__c = productIteratorForQuantity.Quantity_Available__c - orderedProduct.Quantity__c;
                    }
                    
                    else
                    {
                        error = true;
                        final String msg = 'Please enter valid value';
                        apexPages.addmessage(new apexpages.message(apexpages.severity.Error, msg));
                        
                    }
                }
                
            }
        }
    }
    
    public void showProductList()
    {
        hideShowProductList = true;
        
    }

    public pageReference sortAccountColumn()
    {
        if(sortDirection == SORT_DIRECTION_ASC)
        {
            sortDirection = SORT_DIRECTION_DESC;
        }
        
        else if(sortDirection == SORT_DIRECTION_DESC)
        {
            sortDirection = SORT_DIRECTION_ASC;
        }
        
        products = ProductSelector.getProductsByOffset(sortDirection, productQueryOffSet, productQueryOffSet);
        
        return null;
    }
    
    public void firstProductPage()
    {
        productQueryOffSet = 0;
        products = ProductSelector.getProductsByOffset(sortDirection, productQueryOffSet, productQueryOffSet);
    }
    
    public void previousProductPage()
    {
        productQueryOffSet = productQueryOffSet - productQueryLimit;
        products = ProductSelector.getProductsByOffset(sortDirection, productQueryOffSet, productQueryOffSet);
    }
    
    public void nextProductPage()
    {
        productQueryOffSet = productQueryOffSet + productQueryLimit;
        products = ProductSelector.getProductsByOffset(sortDirection, productQueryOffSet, productQueryOffSet);
    }
    
    public void lastProductPage()
    {
        productQueryOffSet = productCount - math.mod(productCount, productQueryLimit);
        products = ProductSelector.getProductsByOffset(sortDirection, productQueryOffSet, productQueryOffSet);
        
    }
    
    public Boolean getPreviousProductPage()
    {
        if(productQueryOffSet == 0)
            return true;
        else
            return false;
    }
    
    public Boolean getNextProductPage()
    {
        if((productQueryOffSet + productQueryLimit) > productCount)
            return true;
        else
            return false;
    }

    public void firstPurchaseOrderPage()
    {
        purchaseOrderQueryOffSet = 0;
        purchaseOrderHistories = PurchaseOrderSelector.getPurchaseOrdersByOffset(purchaseOrderQueryLimit, purchaseOrderQueryOffSet);
    }
    
    public void previousPurchaseOrderPage()
    {
        purchaseOrderQueryOffSet = purchaseOrderQueryOffSet - purchaseOrderQueryLimit;
        purchaseOrderHistories = PurchaseOrderSelector.getPurchaseOrdersByOffset(purchaseOrderQueryLimit, purchaseOrderQueryOffSet);
    }
    
    public void nextPurchaseOrderPage()
    {
        purchaseOrderQueryOffSet = purchaseOrderQueryOffSet + purchaseOrderQueryLimit;
        purchaseOrderHistories = PurchaseOrderSelector.getPurchaseOrdersByOffset(purchaseOrderQueryLimit, purchaseOrderQueryOffSet);
    }
    
    public void lastPurchaseOrderPage()
    {
        purchaseOrderQueryOffSet = purchaseOrderCount - math.mod(purchaseOrderCount, purchaseOrderQueryLimit);
        purchaseOrderHistories = PurchaseOrderSelector.getPurchaseOrdersByOffset(purchaseOrderQueryLimit, purchaseOrderQueryOffSet);
    }
    
    public Boolean getPreviousPurchaseOrderPage()
    {
        if(purchaseOrderQueryOffSet == 0)
            return true;
        else
            return false;
    }
    
    public Boolean getNextPurchaseOrderPage()
    {
        if((purchaseOrderQueryOffSet + purchaseOrderQueryLimit) > purchaseOrderCount)
            return true;
        else
            return false;
    }
    
    public Boolean getHasNextCartItem()
    {
        return orderStandardSetController.getHasNext();
    }
    
    public Boolean getHasPreviousCartItem()
    {
        return orderStandardSetController.getHasPrevious();
    }
    
    public Boolean getHasNextCheckoutItem()
    {
        return checkoutStandardSetController.getHasNext();
    }
    
    public Boolean getHasPreviousCheckoutItem()
    {
        return checkoutStandardSetController.getHasPrevious();
    }
    
    public void nextCartItem()
    {
        orderStandardSetController.next();
    } 
    
    public void previousCartItem()
    {
        orderStandardSetController.previous();
    }
    
    public void nextCheckoutItem()
    {
        checkoutStandardSetController.next();
    } 
    
    public void previousCheckoutItem()
    {
        checkoutStandardSetController.previous();
    }
    
}