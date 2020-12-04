public class JSONController 
{
    public Account myAccount{get; set;}
    public Contact myContact1{get; set;}
    public Contact myContact2{get; set;}
    public String jsonString{get;set;}
    public Boolean jsonBool{set;get;}
    
    public jsonController()
    {
        myAccount = new Account();
        myContact1 = new Contact();
        myContact2 = new Contact();
        jsonBool = false;
    }
    
    public void generate()
    {
 		insert myAccount;
        insert myContact1;
        insert myContact2;
      
        List<WrapperContact> contacts = new List<WrapperContact>();
        WrapperContact wContact1 = new WrapperContact(myContact1, myAccount.Id);
        WrapperContact wContact2 = new WrapperContact(myContact2, myAccount.Id);
        contacts.add(wContact1);
        contacts.add(wContact2);
        WrapperAccount accountList = new WrapperAccount(contacts, myAccount);
        jsonString = JSON.serialize(accountList);
        jsonBool = true;
    }
    
    public class WrapperAccount
    {
        public string Name{get;set;}
        public Integer AnnualRevenue{get;set;}
        public string BillingCity{get;set;}
        public string ShippingCity{get;set;}
        List<WrapperContact> Contacts;
        public  WrapperAccount(List<WrapperContact> contactList, Account myAccount)
        {
            Contacts = contactList;
            this.Name = myAccount.Name;
            this.AnnualRevenue = 0;
            this.BillingCity = myAccount.BillingCity;
            this.ShippingCity = myAccount.ShippingCity;
        }
    }
    
    public class WrapperContact
    {
        public string FirstName{get;set;}
        public String LastName{get;set;}
        public String Email{get;set;}
        public Date BirthDate{get;set;}
        public Id accountId{get;set;}
        public  WrapperContact(Contact myContact, Id accountId)
        {
            this.FirstName = myContact.FirstName;
            this.LastName = myContact.LastName;
            this.Email = myContact.Email;
            this.BirthDate = myContact.BirthDate;
          	this.accountId=accountId;
        }
    }
}