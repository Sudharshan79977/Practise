public with sharing class ContactController {
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts(Integer limitSize, Integer offsetSize) {
        return [
            SELECT Id, FirstName, LastName, Email, Title 
            FROM Contact 
            ORDER BY CreatedDate DESC
            LIMIT :limitSize OFFSET :offsetSize
        ];
    }

    @AuraEnabled(cacheable=true)
    public static Integer getTotalContactsCount() {
        return [SELECT COUNT() FROM Contact];
    }
}