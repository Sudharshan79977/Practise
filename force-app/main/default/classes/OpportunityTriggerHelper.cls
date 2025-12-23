public class OpportunityTriggerHelper {
    
    public static void updateLastOpportunityDate(List<Opportunity> oppList) {
        Set<Id> accountIds = new Set<Id>();
        for (Opportunity opp : oppList) {
            if (opp.AccountId != null) {
                accountIds.add(opp.AccountId);
            }
        }

        if (!accountIds.isEmpty()) {
        

        Map<Id, Date> accountToLatestCloseDate = new Map<Id, Date>();
        for (AggregateResult ar : [
            SELECT AccountId, MAX(CloseDate) latestDate
            FROM Opportunity
            WHERE AccountId IN :accountIds
            GROUP BY AccountId
        ]) {
            Id accId = (Id) ar.get('AccountId');
            Date latestDate = (Date) ar.get('latestDate');
            accountToLatestCloseDate.put(accId, latestDate);
        }

        List<Account> accountsToUpdate = new List<Account>();
        for (Id accId : accountIds) {
            Account acc = new Account(Id = accId);
            if (accountToLatestCloseDate.containsKey(accId)) {
                acc.Last_Opportunity_Date__c = accountToLatestCloseDate.get(accId);
                            accountsToUpdate.add(acc);

            } 
        }

        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
        }}
}