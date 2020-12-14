public class QueryExecuterController 
{
    
    public String query{get;set;}
    public Boolean showQueryResultsArea{get;set;}
    
    public QueryExecuterController ()
    {
        this.query = '';
        this.showQueryResultsArea = false;
    }
    
    public void execute()
    {
        if(!String.isBlank(query))
        {
            this.showQueryResultsArea = true;
        }
        
        else
        {
            this.showQueryResultsArea = false;
            final String errorMessage = 'Please Enter query';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errorMessage));
        }
    }


}