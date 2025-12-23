public with sharing class AccountAction {
    
    public class AnnualRevenueResult {
        @InvocableVariable
        public Decimal annualRevenue;
    }

    @InvocableMethod
    public static List<AnnualRevenueResult> returnAnnualRevenue(List<Id> oppIds){

        List<Opportunity> oppList = [
            SELECT Id, AccountId, Amount
            FROM Opportunity
            WHERE Id IN :oppIds
        ];

        Map<Id, Decimal> accountAmountMap = new Map<Id, Decimal>();
        for (Opportunity opp : oppList) {
            if (!accountAmountMap.containsKey(opp.AccountId)) {
                accountAmountMap.put(opp.AccountId, 0);
            }
            accountAmountMap.put(opp.AccountId, accountAmountMap.get(opp.AccountId) + opp.Amount);
        }

        List<Account> accList = [
            SELECT Id, AnnualRevenue
            FROM Account
            WHERE Id IN :accountAmountMap.keySet()
        ];

        for (Account acc : accList) {
            Decimal currentRevenue = acc.AnnualRevenue != null ? acc.AnnualRevenue : 0;
            acc.AnnualRevenue = currentRevenue + accountAmountMap.get(acc.Id);
        }
        update accList;

        List<AnnualRevenueResult> results = new List<AnnualRevenueResult>();
        for (Account acc : accList) {
            AnnualRevenueResult r = new AnnualRevenueResult();
            r.annualRevenue = acc.AnnualRevenue;
            results.add(r);
        }

        return results;
    }
}