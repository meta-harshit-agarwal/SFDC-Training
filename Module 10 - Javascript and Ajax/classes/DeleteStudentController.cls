public class DeleteStudentController
{ 
    ApexPages.StandardSetController setCon; 
    public Boolean isNotEmpty {get; set;} 
    public Boolean isEmpty {get; set;} 
    public List<Id> listOfIds {get; set;} 
    public Boolean toRenderStudentsName{get; set;} 
    public DeleteStudentController(ApexPages.StandardSetController controller) 
    { 
        toRenderStudentsName = true; 
        setCon = controller; 
        listOfIds = new List<Id>(); 
        for ( Student__c selectedStudent : (Student__c[])setCon.getSelected() ) 
        { 
            listOfIds.add(selectedStudent.Id);
        } 
        if(listOfIds.size() == 0) 
        { 
            isEmpty = true; 
            toRenderStudentsName = false; 
            final String msg = 'No record selected';
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info, msg));
        } 
        else 
        { 
            isNotEmpty = true; 
        } 
    } 
}