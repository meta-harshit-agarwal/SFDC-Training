public class StudentDetailsController 
{
 
    public Id parentId{get;set;}
    public String pdfName {get;set;}
    public Student__c myStudent{get;set;}
    
    public StudentController( )
    {
        
        Id studentId = Apexpages.CurrentPage().getParameters().get('Id');
        myStudent = [SELECT Id, Class__c, Name, DOB__c, Class__r.Name, email__c FROM Student__c WHERE Id =: studentId LIMIT 1 ][0];
        parentId = myStudent.Id;
        pdfName = myStudent.Id;
       
    }
    
    public void savePdf()
    {
        
        PageReference pdf = ApexPages.currentPage();
        
   		Attachment attach = new Attachment();
    	Blob body;
    	try 
        {
        
    	body = pdf.getContent();
    		
    	} catch (VisualforceException e) 
        {
    	body = Blob.valueOf('Some Text');
   		}
        
		attach.Body = body;
        attach.Name = pdfName;
        attach.IsPrivate = false;
   		attach.ParentId = parentId;
        List<Attachment> attachments = [SELECT Id FROM Attachment WHERE Name =: pdfName];
        
        if(attachments.size() > 0)
            delete attachments[0];

   		insert attach;
    }
}