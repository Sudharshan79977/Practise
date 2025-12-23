trigger RollUpAmount on Opportunity (After insert) {
    
    set<id> allAccIds  = new set<id>();
    for(Opportunity opp : trigger.new){
        allAccIds.add(opp.AccountId);
    }
    
    List<Account> allAccounts = [select Id,Name,Total_Average_Amount__c from Account where Id in :allAccIds ];
    Map<Id,AggregateResult> AccOpportunityAmount = new Map<Id,AggregateResult>();
    List<AggregateResult> totalOpp = [select count(id) totalcount,Avg(Amount) avgAmount, accountId from Opportunity where AccountId in :allAccIds group by AccountId];
    for(AggregateResult arr :totalOpp){
        Id accId = (Id)arr.get('accountId');
        AccOpportunityAmount.put(accId,arr);
    }
    if(!AccOpportunityAmount.isEmpty()){
        List<Account> updatedAmount = new  List<Account>();
        for(Account acc : allAccounts){
            if(AccOpportunityAmount.containsKey(acc.id)){
                AggregateResult ar = AccOpportunityAmount.get(acc.Id);
            
            acc.Total_Average_Amount__c = (Decimal)ar.get('avgAmount');
                updatedAmount.add(acc);}
        }
         if(!updatedAmount.isEmpty()){
        update updatedAmount;
    }

    }
   
}