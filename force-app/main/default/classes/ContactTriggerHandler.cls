public class ContactTriggerHandler {
    
    public static void updateAccountContactCount(List<Contact> newContact,List<Contact> oldContact){
        Set<Id> accIds = new Set<Id>();
        try{
            if(newContact!=null){
                for(Contact con : newContact){
                    if(con.AccountId!=null){
                        accIds.add(con.AccountId);
                    }
                }
            }
            if(oldContact!=null){
                for(Contact con : oldContact){
                    if(con.AccountId!=null){
                        accIds.add(con.AccountId);
                    }
                }
            }
            List<Account> account = [select Id,Number_of_Contacts__c ,(select Id from Contacts) from Account where Id in: accIds];
            if(account!=null){
                for(Account acc : account){
                    acc.Number_of_Contacts__c = acc.Contacts.size();
                }
                
            }
            if(!account.isEmpty()){
                update account;
            }
        }
        catch(exception e){
            System.debug('Get Message'+e.getMessage());
        }
    }
    
    public static void AccountRelatedContactsAlteastTwo(List<Contact> newContacts,List<Contact> oldContacts){
        set<Id> accId = new set<Id>();
        for(Contact con : newContacts){
            if(con.AccountId != null)
               accId.add(con.AccountId);
        }
        
        Map<Id,List<Contact>> mapContact = new Map<Id,List<Contact>>();
        List<Contact> conList = [select Id,AccountId from Contact where AccountId in: accId];
        for(Contact con : conList){
            if (!mapContact.containsKey(con.AccountId)) {
            mapContact.put(con.AccountId,new List<Contact>());
            }	
            mapContact.get(con.AccountId).add(con);
        }
        
        for(Contact con : newContacts){
            if(mapContact.containsKey(con.AccountId)  && mapContact.get(con.AccountId).size() > 2){
                con.addError('this account cannot exceed for more than 2 contacts');
            }
        }
    }
}