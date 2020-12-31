public class ManageClassController 
{
    public Id classId{get;set;}
    public Boolean renderClassEditForm{get;set;}
    public Class__c selectedClass{get;set;}
    public List<Class__c> classRecordList = [SELECT Name, MaxSize__c, MyCount__c, Custom_Status__c FROM Class__c];

    public void setSelectedClass(List<Class__c> classRecordList)
    {
        for(Class__c classIterator : classRecordList)
        {
            if(classIterator.Id == classId)
                selectedClass = classIterator;
        }

    }

    public manageClassController() 
    {
        renderClassEditForm = false;
    }
 
    public List<Class__c> getClassRecordList() 
    {
         return classRecordList;
    }
    
    public void editClass() 
    {
        renderClassEditForm = true;
    }
    
    public void updateClass() 
    {
        update selectedClass;
        renderClassEditForm = false;
    }
   
    public void deleteClass() 
    {
        renderClassEditForm = false;
        delete selectedClass;
    }
}