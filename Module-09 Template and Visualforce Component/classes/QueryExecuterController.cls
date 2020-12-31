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
        this.showQueryResultsArea = true;      
    }
}