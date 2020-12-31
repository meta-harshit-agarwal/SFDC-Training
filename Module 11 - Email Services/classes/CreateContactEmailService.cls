global class CreateContactEmailService implements Messaging.InboundEmailHandler 
{
    String xmlString;
    List<Contact> contactsList = new List<Contact>();
    Contact tempContact;
    
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) 
    {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        for (Messaging.Inboundemail.TextAttachment tAttachment : email.textAttachments) 
        {
            
            xmlString = tAttachment.body;
            DOM.Document doc = new DOM.Document();
            try
            {
                doc.load(xmlString);
                DOM.XmlNode rootNode = doc.getRootElement();
                parseXML(rootNode);
                contactsList.add(tempContact);
                insert contactsList;
            }
            catch(exception e)
            {
                system.debug(e.getMessage());
            }
        }
        result.success = true;
        
        return result;
    }
    
    public void parseXML(DOM.XMLNode node) 
    {
        if (node.getNodeType() == DOM.XMLNodeType.ELEMENT)
        {
            if(node.getName() == 'contact')
            {
                if(tempContact != null)
                    contactsList.add(tempContact);
                tempContact = new contact();
            }
            
            if(node.getName() == 'FirstName')
                tempContact.firstName = node.getText().trim();
            if(node.getName() == 'LastName')
                tempContact.lastName = node.getText().trim();
            if(node.getName() == 'ContactNo')
                tempContact.MobilePhone = node.getText().trim();
            if(node.getName() == 'Email')
                tempContact.email = node.getText().trim();
            if(node.getName() == 'department')
                tempContact.Department = node.getText().trim();   
        }
        
        for (Dom.XMLNode child : node.getChildElements()) 
        {
            parseXML(child);
        }
    }
}