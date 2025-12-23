@IsTest
public class OpportunityTriggerHandlerTest {
    @IsTest
    static void testInsertUpdateDeleteUndelete() {
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        
        Opportunity opp1 = new Opportunity(Name = 'Opp1', CloseDate = Date.newInstance(2025, 1, 10), StageName = 'Prospecting', AccountId = acc.Id);
        Opportunity opp2 = new Opportunity(Name = 'Opp2', CloseDate = Date.newInstance(2025, 5, 20), StageName = 'Closed Won', AccountId = acc.Id);
        insert new List<Opportunity>{opp1, opp2};
            
            acc = [SELECT Last_Opportunity_Date__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(Date.newInstance(2025, 5, 20), acc.Last_Opportunity_Date__c, 'Latest date should be from Opp2');
        
        opp1.CloseDate = Date.newInstance(2025, 6, 15);
        update opp1;
        acc = [SELECT Last_Opportunity_Date__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(Date.newInstance(2025, 6, 15), acc.Last_Opportunity_Date__c, 'Latest date should update after CloseDate change');
        
        delete opp1;
        acc = [SELECT Last_Opportunity_Date__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(Date.newInstance(2025, 5, 20), acc.Last_Opportunity_Date__c, 'After delete, should revert to older opportunity date');
        
        undelete opp1;
        acc = [SELECT Last_Opportunity_Date__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(Date.newInstance(2025, 6, 15), acc.Last_Opportunity_Date__c, 'After undelete, should restore latest date');
        
        
    }}