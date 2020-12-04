trigger StudentTrigger on Student__c (before insert , after Update , after insert ) 
{
    
    if(Trigger.isBefore && Trigger.isInsert)
    {
        Map<Id, Class__c> studentClassMap = new Map<Id, Class__c>();
        
        	for(Student__c myStudent : Trigger.New)
        	{   
            	Id classId = myStudent.Class__c;
            	studentClassMap.put(myStudent.Id, [SELECT Id, NumberOfStudents__c, MaxSize__c FROM Class__c WHERE Id =: classId]);
            
        	}
        
        	for(Student__c myStudent : Trigger.New)
        	{
            	Id studentId = myStudent.Id;
            	Class__c myClass = studentClassMap.get(studentId);
            	if(myClass.NumberOfStudents__c + Trigger.New.Size() > myClass.MaxSize__c)
            		myStudent.addError('Class limit Exceeds cant insert more students');
            
        	}
        
        
        
    }
    
   
    
    if(Trigger.isAfter && (Trigger.isUpdate || Trigger.isInsert))
    {
       
        for(student__c myStudent : Trigger.New)
    		{
     		   	Id classId = myStudent.Class__c;
        		Class__c myClass = [SELECT Id FROM Class__c WHERE Id =: classId];
     		  	myClass.MyCount__c = myClass.Students__r.Size();
                update myClass;
            }
    }
    	
}