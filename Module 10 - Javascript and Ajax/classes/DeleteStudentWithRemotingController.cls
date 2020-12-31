public class DeleteStudentWithRemotingController
{
    public Boolean isNotEmpty {get; set;}
    public Boolean isEmpty {get; set;}
    public List<Student__c> listofStudents{get; set;}
    public Boolean toRenderStudentsName{get; set;}
    
    public DeleteStudentWithRemotingController(ApexPages.StandardSetController controller)
    {
        toRenderStudentsName = true;
        listofStudents = new List<Student__c>();
        listofStudents = (Student__c[])controller.getSelected();
        if(listofStudents.size() == 0)
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
    
    @RemoteAction
    public static pageReference  deleteStudents(String studentsList)
    {
        String str = studentsList.substring(1, studentsList.lastIndexOf(']'));
        List<String> Ids =  str.split(', ');
        List<Student__c> studentsToBeDeleted = [SELECT Id FROM Student__c WHERE Id IN : Ids];
        delete studentsToBeDeleted;
        
        return null;
    }
    
   
    
}