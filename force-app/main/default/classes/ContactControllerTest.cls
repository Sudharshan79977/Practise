@isTest
public class ContactControllerTest {
    
    // Utility method to create sample Contacts
    private static void createTestContacts(Integer count) {
        List<Contact> contacts = new List<Contact>();
        for (Integer i = 0; i < count; i++) {
            contacts.add(new Contact(
                FirstName = 'TestFirst' + i,
                LastName = 'TestLast' + i,
                Email = 'test' + i + '@example.com',
                Title = 'Developer'
            ));
        }
        insert contacts;
    }

    @isTest
    static void testGetContacts() {
        // Arrange
        createTestContacts(25);

        // Act
        Test.startTest();
        List<Contact> result = ContactController.getContacts(10, 0);
        Test.stopTest();

        // Assert
        System.assertNotEquals(0, result.size(), 'Contacts should be returned');
        System.assertEquals(10, result.size(), 'Should return only 10 records as per limit');
    }

    @isTest
    static void testPagination() {
        // Arrange
        createTestContacts(30);

        // Page 1
        List<Contact> page1 = ContactController.getContacts(10, 0);
        // Page 2
        List<Contact> page2 = ContactController.getContacts(10, 10);

        // Assert
        System.assertNotEquals(page1[0].Id, page2[0].Id, 'Page 1 and Page 2 results should differ');
    }

    @isTest
    static void testGetTotalContactsCount() {
        // Arrange
        createTestContacts(5);

        // Act
        Integer count = ContactController.getTotalContactsCount();

        // Assert
        System.assert(count >= 5, 'Total count should be at least 5');
    }

    @isTest
    static void testEmptyContacts() {
        // No data created

        Test.startTest();
        List<Contact> result = ContactController.getContacts(10, 0);
        Integer totalCount = ContactController.getTotalContactsCount();
        Test.stopTest();

        System.assertEquals(0, result.size(), 'Should return empty list when no contacts exist');
        System.assertEquals(0, totalCount, 'Total count should be zero');
    }
}