public with sharing class ContactFormController {
    
    @AuraEnabled(cacheable=true)
    public static List<Account> getActiveAccounts(){
        return [select Id,Name from Account where Active__c = 'Yes' Order by Name limit 20];
    }
    @AuraEnabled
    public static String saveContact(Contact con){
        try {
            insert con;
            return 'Contact Created Successfully: ' + con.Id;
        }
        catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
}