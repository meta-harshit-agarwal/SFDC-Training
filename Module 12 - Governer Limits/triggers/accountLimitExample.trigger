trigger accountLimitExample on Account (after delete, after insert, after update) 
{
    public List<Opportunity> opptys;
    opptys = new List<Opportunity>();
    // Using getLimitQueries method of Limit class
    System.debug('Total Number of SOQL Queries allowed in this Apex code context: ' + Limits.getLimitQueries());
    
    // Using getLimitQueryRows method of Limit class
    System.debug('Total Number of records that can be queried in this Apex code context: ' + Limits.getLimitQueryRows());
    
    // Using getLimitDMLStatements method of Limit class
    System.debug('Total Number of DML statements allowed in this Apex code context: ' + Limits.getLimitDMLStatements());
    
    // Using getLimitCpuTime method of Limit class
    System.debug('Total Number of CPU usage time (in ms) allowed in this Apex code context: ' + Limits.getLimitCpuTime());
    
    // Query the Opportunity object
    if (Trigger.isInsert || Trigger.isUpdate) 
    {
        opptys =[select id, description, name, accountid, closedate, stagename from Opportunity where accountId IN:
                 Trigger.newMap.keySet()];
    }
    else
    {
        opptys =[select id, description, name, accountid, closedate, stagename from Opportunity where accountId IN:
                 Trigger.oldMap.keySet()];
    }
    
    // Using getQueries method of Limit class
    System.debug('1. Number of Queries used in this Apex code so far: ' + Limits.getQueries());
    
    // Using getQueryRows method of Limit class
    System.debug('2. Number of rows queried in this Apex code so far: ' + Limits.getQueryRows());
    
    // Using getDMLStatements method of Limit class
    System.debug('3. Number of DML statements used so far: ' + Limits.getDMLStatements());
    
    // Using getCpuTime method of Limit class
    System.debug('4. Amount of CPU time (in ms) used so far: ' + Limits.getCpuTime());
    
    //Proactively determine if there are too many Opportunities to update and avoid governor limits
    // condition to determine too many opportunities to update *
    if(opptys.size() > Limits.getLimitDMLRows()) 
    {
        
        system.debug(opptys.size());
        for(account a:trigger.new)
        {
            a.addError('Too much opportunities to update');
        }
        
    }
    
    else
    {
        
        System.debug('Continue processing. Not going to hit DML governor limits');
        
        System.debug('Going to update ' + opptys.size() + ' opportunities and governor limits will allow ' + Limits.getLimitDMLRows());
        
        for(Account a : Trigger.new)
        {
            
            System.debug('Number of DML statements used so far: ' + Limits.getDMLStatements());
            for(Opportunity o: opptys)
            {
                
                if (o.accountid == a.id)
                    
                    o.description = 'testing';
                
            }
            
        }
        
        update opptys;
        
        System.debug('Final number of DML statements used so far: ' + Limits.getDMLStatements());
        
        System.debug('Final heap size: ' + Limits.getHeapSize());
        
    }
    
}