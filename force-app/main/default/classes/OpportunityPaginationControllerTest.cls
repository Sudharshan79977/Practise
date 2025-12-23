@isTest
public class OpportunityPaginationControllerTest {

    @testSetup
    static void setupData() {
        List<Account> accList = new List<Account>();
        for (Integer i = 0; i < 5; i++) {
            accList.add(new Account(Name = 'Test Account ' + i));
        }
        insert accList;
        
        List<Opportunity> oppList = new List<Opportunity>();
        for (Integer i = 0; i < 25; i++) {
                        Account acc = new Account();
            oppList.add(new Opportunity(
                Name = 'Test Opportunity ' + i,
                StageName = 'Prospecting',
                CloseDate = Date.today().addDays(30),
                Amount = 5000 + i,
                AccountId = acc.Id
            ));
        }
        insert oppList;
    }

    @isTest
    static void testPaginationLogic() {
        Test.startTest();
        OpportunityPaginationController ctrl = new OpportunityPaginationController();
        Test.stopTest();
        
        System.assertNotEquals(0, ctrl.totalRecords, 'Total records should not be zero');
        System.assertEquals(1, ctrl.pageNumber, 'Default page number should be 1');
        System.assertEquals(10, ctrl.opportunities.size(), 'Should load 10 records on first page');
        System.assert(ctrl.getHasNext(), 'Should have a next page');
        System.assert(!ctrl.getHasPrevious(), 'Should not have a previous page on first load');
        
        ctrl.nextPage();
        System.assertEquals(2, ctrl.pageNumber, 'Page number should increment');
        System.assertEquals(10, ctrl.opportunities.size(), 'Next page should also have 10 records');
        System.assert(ctrl.getHasPrevious(), 'Should now have previous page available');
        
        while (ctrl.getHasNext()) {
            ctrl.nextPage();
        }
        System.assert(!ctrl.getHasNext(), 'Should not have next page after reaching end');
        
        ctrl.previousPage();
        System.assert(ctrl.getHasNext(), 'After moving back, should again have next page');
    }

    @isTest
    static void testEdgeCases() {
        delete [SELECT Id FROM Opportunity];

        Test.startTest();
        OpportunityPaginationController ctrlEmpty = new OpportunityPaginationController();
        Test.stopTest();

        System.assertEquals(0, ctrlEmpty.totalRecords, 'No opportunities should exist');
        System.assertEquals(0, ctrlEmpty.opportunities.size(), 'Opportunity list should be empty');
        System.assert(!ctrlEmpty.getHasNext(), 'Should not have next page');
        System.assert(!ctrlEmpty.getHasPrevious(), 'Should not have previous page');
    }
}