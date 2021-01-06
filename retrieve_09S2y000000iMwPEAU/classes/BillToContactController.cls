public class BillToContactController
{
    public Opportunity myOpportunity{get; set;}
    public List<Contact> contactList{get; set;}
    public Id contactId{set; get;}
    
    public  BillToContactController()
    {
   		Id opportunityId =  ApexPages.currentPage().getParameters().get('Id');
    	myOpportunity = [SELECT Id, Name, BillToContact__c, Manager__c FROM Opportunity WHERE Id =: opportunityId];     
    	contactList = [SELECT Id, Name FROM Contact WHERE AccountId =: myOpportunity.Manager__c];
    }
    
    public pageReference save()
    {
        myOpportunity.BillToContact__c = contactId;
        update myOpportunity;
        PageReference pageRef = new PageReference('/' + myOpportunity.Id);

        return pageRef;
    }

    public pageReference clear()
    {
        if(myOpportunity.BillToContact__c == contactId)
        {
            myOpportunity.BillToContact__c = null;
            update myOpportunity;
        } 
        PageReference pageRef = new PageReference('/' + myOpportunity.Id);

        return pageRef;
    }

    public pageReference cancel()
    {
        PageReference pageRef = new PageReference('/' + myOpportunity.Id);

        return pageRef;
    }
    
}