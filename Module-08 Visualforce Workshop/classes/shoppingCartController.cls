public class shoppingCartController 
{
    public boolean error {get;set;}
    public String sortDirection {get;set;}
    private Integer totalRecs1 = 0;
    private Integer OffSetSize1 = 0;
    private Integer LimitSize1 = 10;
    // dsbjdbscscscbsdjchsdcjscs
    // csncsdcscjs
    private Integer totalRecs2 = 0;
    private Integer OffSetSize2 = 0;
    private Integer LimitSize2 = 10;
    public String idOfItem {get;set;}
    public String idOfItemQuant {get;set;}
    public List<Id> productIds = new List<Id>();
    public List<Product2> shoppingProduct {get;set;}
    public String searchKey {get;set;}
    
    public List<Product2> orderItems 
    {
        get
        {
            if(ossc != null)
            	return ossc.getRecords();
            else return null;
        } set;
    }
    
    public List<Product2> checkoutItems 
    {
        get
        {
            if(cssc != null)
                return cssc.getRecords();
            else return null;
        } set;
    }
    
    public List<Purchase_Order__c> purchaseOrderHistory{get; set;}
    public boolean hideShowCartList {get;set;}
    public boolean hideShowCheckoutList {get;set;}
    public boolean hideShowProductList {get;set;}
    public decimal totalMoney {get;set;}
    public product2 valueOfQuant;
    
    public ApexPages.StandardSetController ossc{set;get;}
    
    public Boolean hasNext1
    {
        get 
        {
            if(ossc != NULL)
                return ossc.getHasNext();
            return false;
        } set;
    }
    
    public Boolean hasPrev1
    {
        get
        {
            if(ossc != NULL) 
                return ossc.getHasPrevious();
            return false;
        } set;
    }
    
    public ApexPages.StandardSetController cssc{set;get;}
    public Boolean hasNext2
    {
        get
        {
            if(cssc != NULL)
                return cssc.getHasNext();
            return false;
        } set;
    }
    
    public Boolean hasPrev2
    {
        get
        {
            if(cssc != NULL) 
                return cssc.getHasPrevious();
            return false;
        } set;
    }
    
    public boolean getHideShowCartList(boolean input)
    {
        hideShowCartList = input;
        
        return hideShowCartList;
    }
    
    public boolean getHideShowCheckoutList(boolean input)
    {
        hideShowCheckoutList = input;
        
        return hideShowCheckoutList;
    }
    
    public boolean getHideShowProductList(boolean input)
    {
        hideShowProductList = input;
        
        return hideShowProductList;
    }
    
    public shoppingCartController()
    {
        totalMoney = 0.0;
        error = false;
        sortDirection = 'asc';
        List<Product2> orderItems = new List<Product2>();
        PurchaseOrderHistory = [SELECT Id, Order_Price__c, Order_Status__c FROM Purchase_Order__c LIMIT 5];
        totalRecs1 = [SELECT count() FROM product2];
        totalRecs2 = [SELECT count() FROM Purchase_Order__c];
        string searchQuery = 'SELECT Select_Checkbox__c, Name, Id, ProductCode, Description, Price_Per_Unit__c, Quantity_Available__c FROM product2 Order By Name ' + sortDirection + ' LIMIT : LimitSize1 OFFSET : OffsetSize1';
        shoppingProduct = Database.query(searchQuery);
    }
    
    public List<Product2> getOrderItems(List<Id> productsid)
    {
        string searchQuery = 'SELECT Name, Id, ProductCode, Quantity__c, Description, Price_Per_Unit__c, Quantity_Available__c FROM product2 WHERE Id IN : productIds';
        ossc = new ApexPages.StandardSetController(Database.getQueryLocator(searchQuery)); 
        ossc.setPageSize(5);
        orderItems = Database.query(searchQuery);
        
        for(Product2 query : orderItems)
        {
            for(product2 sProduct : shoppingProduct)
            {
                product2 valueOfQuant = [SELECT Quantity_Available__c FROM product2 WHERE Id =: sProduct.Id][0];
                
                if(query.id == sProduct.id)
                {
                    query.Quantity__c = valueofquant.Quantity_Available__c - sProduct.Quantity_Available__c;
                }
            }
        }
        
        return orderItems;
    }
    
    public List<Product2> getCheckoutItems(List<Id> productIds)
    {
        string searchQuery = 'SELECT Name, Id, ProductCode, Description, Price_Per_Unit__c, Quantity__c, Total__c FROM product2 WHERE Id IN : productIds';
        cssc = new ApexPages.StandardSetController(Database.getQueryLocator(searchQuery)); 
        cssc.setPageSize(5);
        orderItems = Database.query(searchQuery);
        checkoutItems = Database.query(searchQuery);
        
        for(product2 cProduct : checkoutItems)
        {
            for(product2 sProduct : shoppingProduct)
            {
                product2 valueOfQuant = [SELECT Quantity_Available__c FROM product2 WHERE Id =: sProduct.id][0];
                
                if(cProduct.id == sProduct.id)
                {
                    cProduct.Quantity__c = valueofquant.Quantity_Available__c - sProduct.Quantity_Available__c;
                    cProduct.Total__c = cProduct.Quantity__c * cProduct.Price_Per_Unit__c;
                }
            }
        }
        
        return checkoutItems;
    }
    
    public void search()
    {
        string searchQuery = 'SELECT Select_Checkbox__c, Name, Id, ProductCode, Description, Price_Per_Unit__c, Quantity_Available__c FROM product2 WHERE Name LIKE \'%' + searchKey + '%\'';
        shoppingProduct = Database.query(searchQuery);
    }
    
    public void submit()
    {
        getHideShowCartList(true);
        for(product2 sProduct : shoppingProduct)
        {
            if(sProduct.Select_Checkbox__c == true && sProduct.Quantity_Available__c >= 1)
            {
                sProduct.Quantity_Available__c = sProduct.Quantity_Available__c - 1;
                productids.add(sProduct.id);
            }
        }
        getOrderItems(productIds);
    }
    
    public void checkout()
    {
        totalMoney = 0.0;
        getHideShowCheckoutList(true);
        
        for(product2 oProduct : orderitems)
        {
            productids.add(oProduct.id);
        }
        
        getCheckoutItems(productIds);
        
        for(product2 checkBalance : checkoutitems)
        {
            totalmoney = totalmoney + (checkBalance.Quantity__c * checkBalance.Price_Per_Unit__c);
        }
    }
    
    public void placeOrder()
    {
        Purchaseorderhistory.add(new Purchase_Order__c(Name = 'purchasing',Order_Price__c = totalmoney, Order_Status__c = 'pending'));
        upsert Purchaseorderhistory;
    }
    
    public void removeOrderItem()
    {
        for(Integer i = productids.size() - 1; i >= 0; i--)
        {
            if(productids[i].equals(idOfItem))
            {
                for(product2 query1 : shoppingProduct)
                {
                    if(productids[i].equals(query1.id))
                    {
                        product2 valueofquant = [SELECT Quantity_Available__c FROM product2 WHERE id =: query1.id][0];
                        query1.Quantity_Available__c = valueofquant.Quantity_Available__c;
                    }
                }
                productIds.remove(i);
            }
        } 
        getorderitems(productIds);
    }
    
    public void changeAvailableQuantity()
    {
        for(product2 sProduct : shoppingProduct)
        {
            product2 valueofquant = [SELECT Quantity_Available__c FROM product2 WHERE Id =: sProduct.Id][0];
            for(product2 oProduct: orderitems)
            {
                
                if(sProduct.id == idOfItemQuant && oProduct.id == idOfItemQuant)
                {
                    if(valueofquant.Quantity_Available__c >= oProduct.Quantity__c && oProduct.Quantity__c != 0)
                    {
                        error = false;
                        sProduct.Quantity_Available__c = valueofquant.Quantity_Available__c - oProduct.Quantity__c;
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
    
    public void showproductlist()
    {
        gethideShowProductList(true);
    }
    
    public pageReference sortAccNamecolumn()
    {
        if(sortDirection == 'asc')
        {
            sortDirection = 'desc';
        }
        
        else if(sortDirection == 'desc')
        {
            sortDirection = 'asc';
        }
        
        string searchquery = 'SELECT Select_Checkbox__c, Name, Id, ProductCode, Description, Price_Per_Unit__c, Quantity_Available__c FROM product2 Order By Name ' + sortDirection + ' LIMIT : LimitSize1 OFFSET : OffsetSize1';
        shoppingProduct = Database.query(searchquery);
        
        return null;
    }
    
    
    public void FirstPage1()
    {
        OffsetSize1 = 0;
        string searchQuery = 'SELECT Select_Checkbox__c, Name, Id, ProductCode, Description, Price_Per_Unit__c, Quantity_Available__c FROM product2 Order By Name ' + sortDirection + ' LIMIT : LimitSize1 OFFSET : OffsetSize1';
        shoppingProduct = Database.query(searchQuery);
    }
    
    public void previous1()
    {
        OffsetSize1 = OffsetSize1 - LimitSize1;
        string searchQuery = 'SELECT Select_Checkbox__c, Name, Id, ProductCode, Description, Price_Per_Unit__c, Quantity_Available__c FROM product2 Order By Name ' + sortDirection + ' LIMIT : LimitSize1 OFFSET : OffsetSize1';
        shoppingProduct = Database.query(searchQuery);
    }
    
    public void next1()
    {
        OffsetSize1 = OffsetSize1 + LimitSize1;
        string searchQuery = 'SELECT Select_Checkbox__c, Name, Id, ProductCode, Description, Price_Per_Unit__c, Quantity_Available__c FROM product2 Order By Name ' + sortDirection + ' LIMIT : LimitSize1 OFFSET : OffsetSize1';
        shoppingProduct = Database.query(searchQuery);
    }
    
    public void LastPage1()
    {
        OffSetSize1 = totalRecs1 - math.mod(totalRecs1, LimitSize1);
        string searchQuery = 'SELECT Select_Checkbox__c, Name, Id, ProductCode, Description, Price_Per_Unit__c, Quantity_Available__c FROM product2 Order By Name ' + sortDirection + ' LIMIT : LimitSize1 OFFSET : OffsetSize1';
        shoppingProduct = Database.query(searchQuery);
    }
    
    public boolean getprev1()
    {
        if(OffSetSize1 == 0)
            return true;
        else
            return false;
    }
    
    public boolean getnext1()
    {
        if((OffsetSize1 + LimitSize1) > totalRecs1)
            return true;
        else
            return false;
    }

    public void FirstPage2()
    {
        OffsetSize2 = 0;
        string searchQuery = 'SELECT Id, Order_Price__c, Order_Status__c FROM Purchase_Order__c LIMIT : LimitSize2 OFFSET : OffsetSize2';
        Purchaseorderhistory = Database.query(searchQuery);
    }
    
    public void previous2()
    {
        OffsetSize2 = OffsetSize2 - LimitSize2;
        string searchQuery = 'SELECT, Id, Order_Price__c, Order_Status__c FROM Purchase_Order__c LIMIT : LimitSize2 OFFSET : OffsetSize2';
        Purchaseorderhistory = Database.query(searchQuery);
    }
    
    public void next2()
    {
        OffsetSize2 = OffsetSize2 + LimitSize2;
        string searchQuery = 'SELECT, Id, Order_Price__c, Order_Status__c FROM Purchase_Order__c LIMIT : LimitSize2 OFFSET : OffsetSize2';
        Purchaseorderhistory = Database.query(searchQuery);
    }
    
    public void LastPage2()
    {
        OffsetSize2 = totalRecs2 - math.mod(totalRecs2, LimitSize2);
        string searchQuery = 'SELECT, Id, Order_Price__c, Order_Status__c FROM Purchase_Order__c LIMIT : LimitSize2 OFFSET : OffsetSize2';
        Purchaseorderhistory = Database.query(searchQuery);
    }
    
    public boolean getprev2()
    {
        if(OffsetSize2 == 0)
            return true;
        else
            return false;
    }
    
    public boolean getnext2()
    {
        if((OffsetSize2 + LimitSize2) > totalRecs2)
            return true;
        else
            return false;
    }
    
    public void next3()
    {
        ossc.save();
        ossc.next();
    } 
    
    public void prev3()
    {
        ossc.save();
        ossc.previous();
    }
    
    public void next4()
    {
        cssc.save();
        cssc.next();
    } 
    
    public void prev4()
    {
        cssc.save();
        cssc.previous();
    }
    
}