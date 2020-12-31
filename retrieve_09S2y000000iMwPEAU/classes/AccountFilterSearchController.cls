public class AccountFilterSearchController 
{
    public Integer noOfRecords{get;set;} 
    public String city{get;set;}
    public String state{get;set;}
    public String country{get;set;}
    public String query;
    public Integer resultSize{get;set;}
    
    public AccountController() 
    {
        noOfRecords = 10;
    }
    /*
    public String getCity()
    {
        return this.city ;
    }
    
    public void setCity(String city)
    {
        this.city = city;
    }
    
    public String getState()
    {
        return this.state ;
    }
    
    public void setState(String state)
    {
        this.state = state ;
    }
    
    public String getCountry()
    {
        return this.country ;
    }
    
    public void setCountry(String country)
    {
        this.country = country ;
    }
    */
    public ApexPages.StandardSetController setCon
    {
        get {
            if(setCon == null) { 
                setCon = new ApexPages.StandardSetController(Database.query(query));
                setCon.setPageSize(noOfRecords);  
            }            
            return setCon;
        }
        set;
    }
    
    public void searchAccounts()
    {
        setCon = null;
    }
    
    public List<Account> getAccounts() 
    {
        query = 'SELECT Name, BillingCity, BillingState, BillingCountry FROM Account ';
        if(!String.isBlank(city) || !String.isBlank(state) || !String.isBlank(country)) 
        {
            query += 'WHERE' ;
            query += String.isBlank(city) ? '' : ' BillingCity LIKE ' + '\'%' + city + '%\'' + ' AND ';
            query += String.isBlank(state) ? '' : ' BillingState LIKE ' + '\'%' + state + '%\'' + ' AND ';
            query += String.isBlank(country) ? '' : ' BillingCountry LIKE ' + '\'%' + country + '%\'';
        }
        query.removeEnd('AND ');
        city = null;
        state = null;
        country = null;
        resultSize = setCon.getResultSize();
        return (List<Account>) setCon.getRecords();
    }
}