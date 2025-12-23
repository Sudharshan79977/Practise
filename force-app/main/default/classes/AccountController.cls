public with sharing class AccountController {
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccount() {

        return [SELECT Name, Phone, Industry FROM Account limit 10];
    }
    @AuraEnabled(cacheable=true)
public static List<Contact> getContacts() {
    return [SELECT Id, FirstName, LastName, Email, Title FROM Contact limit 10];
}
 
  @AuraEnabled(cacheable=true)
  public static list<Contact> getAccountRealtedContacts(String AccountName){
    return [SELECT Id, FirstName, LastName, Email, Title FROM Contact WHERE Account.Name =:AccountName limit 10 ];
  }
 
}