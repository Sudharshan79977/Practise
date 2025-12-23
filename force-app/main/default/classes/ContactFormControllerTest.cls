@isTest
public class ContactFormControllerTest {
    
    @testSetup
    static void setupTestData() {
        // Create Active Accounts
        List<Account> accounts = new List<Account>{
            new Account(Name = 'Active Account 1', Active__c = 'Yes'),
            new Account(Name = 'Active Account 2', Active__c = 'Yes'),
            new Account(Name = 'Inactive Account', Active__c = 'Yes')
        };
        insert accounts;
    }

    @isTest
    static void testGetActiveAccounts() {
        // Act
        List<Account> activeAccounts = ContactFormController.getActiveAccounts();

        // Assert
        System.assertNotEquals(0, activeAccounts.size(), 'Active accounts should not be empty');
        for (Account acc : activeAccounts) {
            System.assertEquals('Yes', acc.Active__c, 'Only active accounts should be returned');
        }
    }

    @isTest
    static void testSaveContactSuccess() {
        // Arrange
        Account activeAcc = [SELECT Id FROM Account WHERE Active__c = 'Yes' LIMIT 1];
        Contact con = new Contact(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuser@example.com',
            AccountId = activeAcc.Id
        );

        // Act
        String result = ContactFormController.saveContact(con);

        // Assert
        System.assert(result.contains('Contact Created Successfully'), 'Success message expected');
        Contact insertedCon = [SELECT Id, Email FROM Contact WHERE Email = 'testuser@example.com' LIMIT 1];
        System.assertEquals('testuser@example.com', insertedCon.Email);
    }

    @isTest
    static void testSaveContactException() {
        // Arrange - create invalid contact (missing required field)
        Contact con = new Contact();

        // Act & Assert
        try {
            ContactFormController.saveContact(con);
            System.assert(false, 'Expected exception was not thrown');
        } catch (AuraHandledException e) {
            System.assert(e.getMessage().contains('required fields'), 'Should throw required field exception');
        }
    }
}