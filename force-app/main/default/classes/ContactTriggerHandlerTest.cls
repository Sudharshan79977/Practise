@IsTest
public class ContactTriggerHandlerTest {

    @IsTest
    static void testInsertUpdateDeleteUndelete() {

        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Contact con1 = new Contact(FirstName = 'John', LastName = 'Doe', AccountId = acc.Id);
        Contact con2 = new Contact(FirstName = 'Jane', LastName = 'Smith', AccountId = acc.Id);
        insert new List<Contact>{con1, con2};

        acc = [SELECT Id, Number_of_Contacts__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(2, acc.Number_of_Contacts__c, 'Should count 2 contacts after insert');

        Account acc2 = new Account(Name = 'Second Account');
        insert acc2;

        con1.AccountId = acc2.Id;
        update con1;
        Map<Id, Account> accMap = new Map<Id, Account>(
            [SELECT Id, Number_of_Contacts__c FROM Account WHERE Id IN :new List<Id>{acc.Id, acc2.Id}]
        );
        System.assertEquals(1, accMap.get(acc.Id).Number_of_Contacts__c, 'Acc1 should have 1 contact');
        System.assertEquals(1, accMap.get(acc2.Id).Number_of_Contacts__c, 'Acc2 should have 1 contact');

        delete con2;
        acc = [SELECT Id, Number_of_Contacts__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(0, acc.Number_of_Contacts__c, 'Acc1 should have 0 contacts after delete');

        undelete con2;
        acc = [SELECT Id, Number_of_Contacts__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(1, acc.Number_of_Contacts__c, 'Acc1 should have 1 contact after undelete');

    }
}