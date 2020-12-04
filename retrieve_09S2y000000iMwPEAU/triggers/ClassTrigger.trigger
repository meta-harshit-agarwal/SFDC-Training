trigger ClassTrigger on Class__c (before delete , after Update) 
{
    
    if(Trigger.isBefore && Trigger.isDelete)
    {
     	List<Class__c> classes = [SELECT Id , (SELECT Id FROM Students__r WHERE Sex__c = 'female')  FROM Class__c  WHERE Id IN :Trigger.Old];
		for(Class__c myClass : classes)
        {
            if(myClass.students__r.Size() > 1)
       	 		Trigger.oldMap.get(myClass.Id).addError('Cant delete class Because No Of Female Student is More Than 1');   
        }
       
    }
    if(Trigger.isAfter && Trigger.isUpdate)
    {
        Class__c resultClass = new Class__c();
        List<Class__c > newClass = Trigger.New;
        for(Class__c testClass : newClass)
        {
            if(Trigger.oldMap.get(testClass.Id).Custom_Status__c != 'Reset' && testClass.Custom_Status__c == 'Reset')
                resultClass = testClass;
        }
         
        List<Student__c> studentListToDelete = [SELECT Id FROM Student__c WHERE Class__r.Id =: resultClass.Id];
        delete(studentListToDelete);
        
    }
}