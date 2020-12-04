public class ManageClassController 
{
    public Id classId{get;set;}
    public boolean render{get;set;}
    public class__c selectedClass{get;set;}

    public manageClassController() 
    {
        render = false;
    }
 
    public list<class__c> getClassRecList() 
    {
        List<class__c> classRecList = [SELECT Name, MaxSize__c, MyCount__c, Custom_Status__c FROM class__c];
        return classRecList;
    }
    
    public void editClass() 
    {
        selectedClass = [SELECT Name, MaxSize__c, MyCount__c, Custom_Status__c FROM Class__c WHERE Id =: classId];
        render = true;
    }
    
    public void updateClass() 
    {
        update selectedClass;
        render = false;
    }
   
    public void deleteClass() 
    {
        selectedClass = [SELECT Name, MaxSize__c, MyCount__c, Custom_Status__c FROM Class__c WHERE Id =: classId];
        render = false;
        delete selectedClass;
    }
}