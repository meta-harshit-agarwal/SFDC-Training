public with sharing class createContactController {

    @AuraEnabled
    public static String[] saveContact(Contact contact)
    {
        try
        {
            insert contact;
        }
        catch(Exception e)
        {
			System.debug('Error In Create Contact');
            return  new List<String>{'ERROR', e.getMessage()};            
        }
        
        return new List<String>{'success', contact.Id};
    }
    
    @AuraEnabled
    public static List<Contact> getContact()
    {
        return [SELECT Id, FirstName, LastName, Phone, Fax, Email FROM Contact ORDER BY CreatedDate DESC LIMIT 1 ];
    }
}