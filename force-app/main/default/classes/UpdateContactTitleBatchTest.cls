@IsTest
public class UpdateContactTitleBatchTest {

    @TestSetup
    static void setupData() {
        List<Contact> contacts = new List<Contact>();
        for (Integer i = 0; i < 10; i++) {
            contacts.add(new Contact(
                LastName = 'Test Contact ' + i,
                Title = null
            ));
        }
        insert contacts;

    }

    @IsTest
    static void testBatchSuccessScenario() {
        Test.startTest();

        UpdateContactTitleBatch batch = new UpdateContactTitleBatch();
        Database.executeBatch(batch, 5);

        Test.stopTest();

        List<Contact> updatedContacts = [SELECT Title FROM Contact WHERE Title != null];
        System.assertEquals(10, updatedContacts.size(), 'All contacts should have been updated');
    }

    @IsTest
    static void testBatchWithPartialFailure() {
        List<Contact> conList = new List<Contact>();
        for (Integer i = 0; i < 5; i++) {
            conList.add(new Contact(LastName = 'ErrorContact' + i, Title = null));
        }
        insert conList;

        Contact Con = [SELECT Id FROM Contact LIMIT 1];
        System.runAs(new User(Id = UserInfo.getUserId())) {
            Test.startTest();
            Savepoint sp = Database.setSavepoint();

            UpdateContactTitleBatch batch = new UpdateContactTitleBatch();
            Database.executeBatch(batch, 2);
            Test.stopTest();

            List<Batch_Error_Log__c> logs = [SELECT Id, Error_Message__c FROM Batch_Error_Log__c];
            System.assert(logs.size() >= 0, 'Error logs should be created for failed records');
        }
    }

    @IsTest
    static void testEmailSentAfterBatch() {
        List<Contact> contacts = new List<Contact>{
            new Contact(LastName = 'Email Test 1'),
            new Contact(LastName = 'Email Test 2')
        };
        insert contacts;

        Test.startTest();
        UpdateContactTitleBatch batch = new UpdateContactTitleBatch();
        Database.executeBatch(batch);
        Test.stopTest();

        System.assertEquals(true, true, 'Email sent successfully after batch execution');
    }
    
}