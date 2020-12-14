public class QueryComponentController 
{

    public String queryToBeExecuted = '';
    public List<String> fieldsList{get;set;}
    public String sortBy = '';
    public Integer DesiredPage{get;set;}
    public Boolean isSortingLinkClicked = false;
    public boolean sortAscending = true;
    
    public ApexPages.StandardSetController setCon
    {
        get
        {
            if(setCon == null)
            {
                List<sObject> listOfDisplayingObjects = new List<sObject>();
                listOfDisplayingObjects = getDisplayFields(queryToBeExecuted);
                if(listOfDisplayingObjects != null)
                {
                    setCon = new ApexPages.StandardSetController(listOfDisplayingObjects);
                    setCon.setPageSize(10);
                }
            }
            
            return setCon;
        }
        set;
    }
    
    public QueryComponentController()
    {
        this.queryToBeExecuted = '';
        this.sortBy = '';
    }
   
    public String getQueryToBeExecuted()
    {
        return this.queryToBeExecuted;
    }
    
    public void setQueryToBeExecuted(String query)
    {
        if(!this.queryToBeExecuted.equalsIgnoreCase(query))
        {
            this.queryToBeExecuted = query;
            this.setCon = null;
        }
    }
    
    public void sortByMethod()
    {
        this.setCon = null;
        this.isSortingLinkClicked = true;
        this.sortAscending = !this.sortAscending; 
    }
    
    public void setSortBy(String fieldName)
    {
        this.sortBy = fieldName;
    }

    public String getSortBy()
    {
        return this.sortBy;
    }
    
	public List<sObject> getRecordsList()
    {
        if(setCon != null)
        {
            return setCon.getRecords();
        }
        
        else
        {
            return null;
        }
    }
    
    private String createQuery(String query)
    {
        String orderedQuery = query;        
        if(isSortingLinkClicked && String.isNotBlank(this.getSortBy()))
        {
            if(sortAscending)
            {
                if(query.containsIgnoreCase('order by'))
                {
                    orderedQuery = orderedQuery.substring(0, query.indexOfIgnoreCase('order by') - 1);
                }
                orderedQuery = orderedQuery + ' ORDER BY ' + this.getSortBy();                
            }
            
            else
            {
                if(query.containsIgnoreCase('order by'))
                {
                    orderedQuery = orderedQuery.substring(0, query.indexOfIgnoreCase('order by') - 1);
                }
                orderedQuery = orderedQuery + ' ORDER BY ' + this.getSortBy() + ' DESC';
            }
        }
        
        return orderedQuery;
    }
    
    private List<sObject> executeQuery(String query)
    {
        String orderedQuery = createQuery(query);
        List<sObject> sObjectList = new List<sObject>();
        try
        {
            sObjectList = Database.query(orderedQuery);
            
        }
        catch(Exception ex)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage())); 
            
            return null;
        }
        
        return sObjectList;
    }
    
    public List<sObject> getDisplayFields(String query)
    {
        List<sObject> records = executeQuery(query);
        if(records == null)
        {
            return null;
        }
        
        else
        {
            if(records.isEmpty())
            {
                final String msg = 'No records found';
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, msg));
                records = new List<Account>();
            }
            
            else
            {
                Set<String> fieldsSet = new Set<String>();
                for(sObject record : records)
                {
                    fieldsSet.addAll(record.getPopulatedFieldsAsMap().keySet());
                }
                this.fieldsList = new List<String>();
                this.fieldsList.addAll(fieldsSet);
            }
            
            return records; 
        }
    }  
    
    

}