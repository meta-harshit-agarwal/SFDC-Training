trigger accountTriggerGLimits on Account (before delete, before insert, before update) 
{
    
    List<Opportunity> opptysClosedLost = [select id, name, closedate, stagename from Opportunity
    where accountId IN :Trigger.newMap.keySet() and StageName='Closed - Lost'];
    List<Opportunity> opptysClosedWon = [select id, name, closedate, stagename from Opportunity where
    accountId IN :Trigger.newMap.keySet() and StageName='Closed - Won'];
    // No need to create two seperate list can make one list using OR operator in Query
    
    for(Account a : Trigger.new)
    {
    for(Opportunity o: opptysClosedLost)
    {
    if(o.accountid == a.id)
    System.debug('Do more logic here...');
    }
    for(Opportunity o: opptysClosedWon)
    {
    if(o.accountid == a.id)
    System.debug('Do more logic here...');
    }
      // Here we can do same using one loop and one list of required opportunites.   
        
}
}

/*
	trigger accountTrigger on Account (before delete, before insert, before update) 
	{
	List<Opportunity> opportunities = [select id, name, closedate, stagename from Opportunity where accountId IN :Trigger.newMap.keySet() and (StageName='Closed Lost' OR StageName='Closed Won')];
	for(Opportunity closedWonORclosedLostOpportunities : opportunities)
    {
        if(closedWonORclosedLostOpportunities.StageName == 'Closed Won')
        {
            	System.debug('Do Somthing for Closed Won');
        }
        if(closedWonORclosedLostOpportunities.StageName == 'Closed Lost')
        {
            System.debug('Do Somthing for Closed Lost');
        }
    }
}

*/