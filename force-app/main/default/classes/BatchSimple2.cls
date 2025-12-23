public class BatchSimple2 implements Database.Batchable<sobject>{
     public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator([select Id,LastName,Title from Contact limit 2]);
    }
    
     public void execute(Database.BatchableContext bc, List<Contact> conList){
        List<Contact> contactsToUpdate = new List<Contact>();
         for(Contact con : conList){
             con.LastName = con.LastName + 'simple2';
         contactsToUpdate.add(con);
         }
         update contactsToUpdate;
     }
    
     public void finish(Database.BatchableContext bc){
       System.debug('from batchsimple2');

     }}