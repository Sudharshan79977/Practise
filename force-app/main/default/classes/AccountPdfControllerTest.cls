@isTest
public class AccountPdfControllerTest {
    
    @testSetup
    static void setupTestData() {
        // Create test Account
        Account acc = new Account(
            Name = 'Test Account',
            Phone = '9999999999',
            Industry = 'Technology'
        );
        insert acc;

        // Create related Contacts
        List<Contact> cons = new List<Contact>();
        for (Integer i = 0; i < 3; i++) {
            cons.add(new Contact(
                FirstName = 'First' + i,
                LastName = 'Last' + i,
                Email = 'user' + i + '@test.com',
                AccountId = acc.Id
            ));
        }
        insert cons;
    }

    @isTest
    static void testGetAccountWithContacts() {
        Account testAcc = [SELECT Id FROM Account LIMIT 1];
        
        Test.startTest();
        Map<String, Object> result = AccountPdfController.getAccountWithContacts(testAcc.Id);
        Test.stopTest();

        System.assertNotEquals(null, result, 'Result should not be null');
        System.assert(result.containsKey('account'), 'Should contain account key');
        System.assert(result.containsKey('contacts'), 'Should contain contacts key');

        Account acc = (Account) result.get('account');
        List<Contact> cons = (List<Contact>) result.get('contacts');
        System.assertEquals('Test Account', acc.Name);
        System.assertEquals(3, cons.size(), 'There should be 3 contacts');
    }

    @isTest
    static void testGenerateAccountPdf() {
        Account testAcc = [SELECT Id FROM Account LIMIT 1];
        
        Test.startTest();
        try {
            // This will throw an exception in test context because getContentAsPDF is not supported
            AccountPdfController.generateAccountPdf(testAcc.Id);
        } catch (Exception e) {
            System.assert(
                e.getMessage().contains('getContentAsPDF') || e.getMessage().contains('PDF'),
                'Expected PDF generation restriction in test context'
            );
        }
        Test.stopTest();
    }
}