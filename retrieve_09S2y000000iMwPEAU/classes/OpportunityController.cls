public class OpportunityController 
{
    public Opportunity myOpportunity{get; set;}
    public List<Contact> contactList{get; set;}
    public Id contactId{set; get;}
    
    public OpportunityController()
    {
   		Id opportunityId =  ApexPages.currentPage().getParameters().get('Id');
    	myOpportunity = [SELECT Id, Name, BillToContact__c, Manager__c FROM Opportunity WHERE Id =: opportunityId];     
    	contactList = [SELECT Id, Name FROM Contact WHERE Account.Id =: myOpportunity.Manager__c];
    }
    
    public pageReference Save()
    {
        System.debug(contactId);
        myOpportunity.BillToContact__c = contactId;
        update myOpportunity;
        PageReference pageRef = new PageReference('/' + myOpportunity.Id);
        return pageRef;
    }
    public pageReference Clear()
    {
        System.debug(contactId);
        if(myOpportunity.BillToContact__c == contactId)
        {
            myOpportunity.BillToContact__c = null;
            update myOpportunity;
        } 
        PageReference pageRef = new PageReference('/' + myOpportunity.Id);
        return pageRef;
    }
    public pageReference Cancel()
    {
        System.debug(contactId);
        PageReference pageRef = new PageReference('/' + myOpportunity.Id);
        return pageRef;
    }
    
}