trigger accountTestTrigger on Account (before insert, before update) 
{
    
    
   
    for(Account a: Trigger.new) 
    {
        // Query inside loop bad practice can build contact list using Trigger.newMap.KeySet()
    List<Contact> contacts = [select id, salutation, firstname, lastname, email
    from Contact where accountId = :a.Id];
    for(Contact c: contacts) {
    System.debug('Contact Id[' + c.Id + '], FirstName[' + c.firstname + '], LastName[' + c.lastname +']');
    c.Description=c.salutation + ' ' + c.firstName + ' ' + c.lastname;
     // Avoid Multiple DML statement instead use Bulk DML using Collections            
    update c;
    }
    
}
    
}
    /* Optimized code
    List<Contact> contacts = [SELECT Id, salutation, firstname, lastname, email FROM Contact WHERE accountId IN Trigger.newMap.KeySet()];   
                         
    List<Contact> toUpdateContactList = new List<Contact>();
    for(Contact c : contacts) 
    {
          System.debug('Contact Id[' + c.Id + '], FirstName[' + c.firstname + '],
          LastName[' + c.lastname +']');
          c.Description=c.salutation + ' ' + c.firstName + ' ' + c.lastname;
          toUpdateContactList.add(c);
    } 
    update toUpdateContactList;
    */