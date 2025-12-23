public class contactBatch implements Database.Batchable<Sobject>,Database.Stateful {
    private List<Contact> failedContacts = new List<Contact>();
    private String newLastName;
    private Integer Count=0;
    
    public contactBatch(String newLastName) {
        this.newLastName = newLastName;
    }
    
    public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator([select Id,LastName from Contact where LastName like '%test%']);
    }
    
    public void execute(Database.BatchAbleContext Bc,List<Contact> conList){
        List<Contact> contactsToUpdate = new List<Contact>();
        
        for(Contact con : conList){
            con.LastName = con.LastName + newLastName;
            Count++;
            contactsToUpdate.add(con);
        }
        
        Database.Saveresult[] results = Database.update(contactsToUpdate,false);
        
        for(Integer i = 0; i < results.size(); i++) {
            if(!results[i].isSuccess()) {
                failedContacts.add(contactsToUpdate[i]);
                System.debug('Failed record: ' + contactsToUpdate[i].Id + ' Error: ' + results[i].getErrors()[0].getMessage());
            }
            
        }}
    public void finish(Database.BatchableContext bc) {
        if(failedContacts.size() > 0) {
            System.debug('Total failed contacts: ' + failedContacts.size());
            
            for(Contact c : failedContacts) {
                System.debug('Failed Contact Id: ' + c.Id + ', LastName: ' + c.LastName);
            }
        } else {
            System.debug('All contacts updated are processed with count'+Count);
            
        }
    }
    
}